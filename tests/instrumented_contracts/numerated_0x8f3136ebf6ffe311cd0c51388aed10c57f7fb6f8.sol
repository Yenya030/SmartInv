1 pragma solidity 0.4.24;
2 /*
3     Copyright 2016, Jordi Baylina
4 
5     This program is free software: you can redistribute it and/or modify
6     it under the terms of the GNU General Public License as published by
7     the Free Software Foundation, either version 3 of the License, or
8     (at your option) any later version.
9 
10     This program is distributed in the hope that it will be useful,
11     but WITHOUT ANY WARRANTY; without even the implied warranty of
12     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13     GNU General Public License for more details.
14 
15     You should have received a copy of the GNU General Public License
16     along with this program.  If not, see <http://www.gnu.org/licenses/>.
17  */
18 
19 /// @title MiniMeToken Contract
20 /// @author Jordi Baylina
21 /// @dev This token contract's goal is to make it easy for anyone to clone this
22 ///  token using the token distribution at a given block, this will allow DAO's
23 ///  and DApps to upgrade their features in a decentralized manner without
24 ///  affecting the original token
25 /// @dev It is ERC20 compliant, but still needs to under go further testing.
26 
27 
28 contract Controlled {
29     /// @notice The address of the controller is the only address that can call
30     ///  a function with this modifier
31     modifier onlyController { require(msg.sender == controller); _; }
32 
33     address public controller;
34 
35     constructor() public { controller = msg.sender;}
36 
37     /// @notice Changes the controller of the contract
38     /// @param _newController The new controller of the contract
39     function changeController(address _newController) public onlyController {
40         controller = _newController;
41     }
42 }
43 
44 
45 /// @dev The token controller contract must implement these functions
46 contract TokenController {
47     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
48     /// @param _owner The address that sent the ether to create tokens
49     /// @return True if the ether is accepted, false if it throws
50     function proxyPayment(address _owner) public payable returns(bool);
51 
52     /// @notice Notifies the controller about a token transfer allowing the
53     ///  controller to react if desired
54     /// @param _from The origin of the transfer
55     /// @param _to The destination of the transfer
56     /// @param _amount The amount of the transfer
57     /// @return False if the controller does not authorize the transfer
58     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
59 
60     /// @notice Notifies the controller about an approval allowing the
61     ///  controller to react if desired
62     /// @param _owner The address that calls `approve()`
63     /// @param _spender The spender in the `approve()` call
64     /// @param _amount The amount in the `approve()` call
65     /// @return False if the controller does not authorize the approval
66     function onApprove(address _owner, address _spender, uint _amount) public
67         returns(bool);
68 }
69 
70 
71 contract ApproveAndCallFallBack {
72     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
73 }
74 
75 /// @dev The actual token contract, the default controller is the msg.sender
76 ///  that deploys the contract, so usually this token will be deployed by a
77 ///  token controller contract, which Giveth will call a "Campaign"
78 contract MiniMeToken is Controlled {
79 
80     string public name;                //The Token's name: e.g. DigixDAO Tokens
81     uint8 public decimals;             //Number of decimals of the smallest unit
82     string public symbol;              //An identifier: e.g. REP
83     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
84 
85 
86     /// @dev `Checkpoint` is the structure that attaches a block number to a
87     ///  given value, the block number attached is the one that last changed the
88     ///  value
89     struct  Checkpoint {
90 
91         // `fromBlock` is the block number that the value was generated from
92         uint128 fromBlock;
93 
94         // `value` is the amount of tokens at a specific block number
95         uint128 value;
96     }
97 
98     // `parentToken` is the Token address that was cloned to produce this token;
99     //  it will be 0x0 for a token that was not cloned
100     MiniMeToken public parentToken;
101 
102     // `parentSnapShotBlock` is the block number from the Parent Token that was
103     //  used to determine the initial distribution of the Clone Token
104     uint public parentSnapShotBlock;
105 
106     // `creationBlock` is the block number that the Clone Token was created
107     uint public creationBlock;
108 
109     // `balances` is the map that tracks the balance of each address, in this
110     //  contract when the balance changes the block number that the change
111     //  occurred is also included in the map
112     mapping (address => Checkpoint[]) balances;
113 
114     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
115     mapping (address => mapping (address => uint256)) allowed;
116 
117     // Tracks the history of the `totalSupply` of the token
118     Checkpoint[] totalSupplyHistory;
119 
120     // Flag that determines if the token is transferable or not.
121     bool public transfersEnabled;
122 
123     // The factory used to create new clone tokens
124     MiniMeTokenFactory public tokenFactory;
125 
126 ////////////////
127 // Constructor
128 ////////////////
129 
130     /// @notice Constructor to create a MiniMeToken
131     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
132     ///  will create the Clone token contracts, the token factory needs to be
133     ///  deployed first
134     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
135     ///  new token
136     /// @param _parentSnapShotBlock Block of the parent token that will
137     ///  determine the initial distribution of the clone token, set to 0 if it
138     ///  is a new token
139     /// @param _tokenName Name of the new token
140     /// @param _decimalUnits Number of decimals of the new token
141     /// @param _tokenSymbol Token Symbol for the new token
142     /// @param _transfersEnabled If true, tokens will be able to be transferred
143     constructor(
144         address _tokenFactory,
145         address _parentToken,
146         uint _parentSnapShotBlock,
147         string _tokenName,
148         uint8 _decimalUnits,
149         string _tokenSymbol,
150         bool _transfersEnabled
151     ) public {
152         tokenFactory = MiniMeTokenFactory(_tokenFactory);
153         name = _tokenName;                                 // Set the name
154         decimals = _decimalUnits;                          // Set the decimals
155         symbol = _tokenSymbol;                             // Set the symbol
156         parentToken = MiniMeToken(_parentToken);
157         parentSnapShotBlock = _parentSnapShotBlock;
158         transfersEnabled = _transfersEnabled;
159         creationBlock = block.number;
160     }
161 
162 
163 ///////////////////
164 // ERC20 Methods
165 ///////////////////
166 
167     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
168     /// @param _to The address of the recipient
169     /// @param _amount The amount of tokens to be transferred
170     /// @return Whether the transfer was successful or not
171     function transfer(address _to, uint256 _amount) public returns (bool success) {
172         require(transfersEnabled);
173         return doTransfer(msg.sender, _to, _amount);
174     }
175 
176     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
177     ///  is approved by `_from`
178     /// @param _from The address holding the tokens being transferred
179     /// @param _to The address of the recipient
180     /// @param _amount The amount of tokens to be transferred
181     /// @return True if the transfer was successful
182     function transferFrom(address _from, address _to, uint256 _amount
183     ) public returns (bool success) {
184 
185         // The controller of this contract can move tokens around at will,
186         //  this is important to recognize! Confirm that you trust the
187         //  controller of this contract, which in most situations should be
188         //  another open source smart contract or 0x0
189         if (msg.sender != controller) {
190             require(transfersEnabled);
191 
192             // The standard ERC 20 transferFrom functionality
193             if (allowed[_from][msg.sender] < _amount) return false;
194             allowed[_from][msg.sender] -= _amount;
195         }
196         return doTransfer(_from, _to, _amount);
197     }
198 
199     /// @dev This is the actual transfer function in the token contract, it can
200     ///  only be called by other functions in this contract.
201     /// @param _from The address holding the tokens being transferred
202     /// @param _to The address of the recipient
203     /// @param _amount The amount of tokens to be transferred
204     /// @return True if the transfer was successful
205     function doTransfer(address _from, address _to, uint _amount
206     ) internal returns(bool) {
207 
208            if (_amount == 0) {
209                return true;
210            }
211 
212            require(parentSnapShotBlock < block.number);
213 
214            // Do not allow transfer to 0x0 or the token contract itself
215            require((_to != 0) && (_to != address(this)));
216 
217            // If the amount being transfered is more than the balance of the
218            //  account the transfer returns false
219            uint previousBalanceFrom = balanceOfAt(_from, block.number);
220            if (previousBalanceFrom < _amount) {
221                return false;
222            }
223 
224            // Alerts the token controller of the transfer
225            if (isContract(controller)) {
226                require(TokenController(controller).onTransfer(_from, _to, _amount));
227            }
228 
229            // First update the balance array with the new value for the address
230            //  sending the tokens
231            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
232 
233            // Then update the balance array with the new value for the address
234            //  receiving the tokens
235            uint previousBalanceTo = balanceOfAt(_to, block.number);
236            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
237            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
238 
239            // An event to make the transfer easy to find on the blockchain
240            emit Transfer(_from, _to, _amount);
241 
242            return true;
243     }
244 
245     /// @param _owner The address that's balance is being requested
246     /// @return The balance of `_owner` at the current block
247     function balanceOf(address _owner) public constant returns (uint256 balance) {
248         return balanceOfAt(_owner, block.number);
249     }
250 
251     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
252     ///  its behalf. This is a modified version of the ERC20 approve function
253     ///  to be a little bit safer
254     /// @param _spender The address of the account able to transfer the tokens
255     /// @param _amount The amount of tokens to be approved for transfer
256     /// @return True if the approval was successful
257     function approve(address _spender, uint256 _amount) public returns (bool success) {
258         require(transfersEnabled);
259 
260         // To change the approve amount you first have to reduce the addresses`
261         //  allowance to zero by calling `approve(_spender,0)` if it is not
262         //  already 0 to mitigate the race condition described here:
263         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
264         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
265 
266         // Alerts the token controller of the approve function call
267         if (isContract(controller)) {
268             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
269         }
270 
271         allowed[msg.sender][_spender] = _amount;
272         emit Approval(msg.sender, _spender, _amount);
273         return true;
274     }
275 
276     /// @dev This function makes it easy to read the `allowed[]` map
277     /// @param _owner The address of the account that owns the token
278     /// @param _spender The address of the account able to transfer the tokens
279     /// @return Amount of remaining tokens of _owner that _spender is allowed
280     ///  to spend
281     function allowance(address _owner, address _spender
282     ) public constant returns (uint256 remaining) {
283         return allowed[_owner][_spender];
284     }
285 
286     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
287     ///  its behalf, and then a function is triggered in the contract that is
288     ///  being approved, `_spender`. This allows users to use their tokens to
289     ///  interact with contracts in one function call instead of two
290     /// @param _spender The address of the contract able to transfer the tokens
291     /// @param _amount The amount of tokens to be approved for transfer
292     /// @return True if the function call was successful
293     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
294     ) public returns (bool success) {
295         require(approve(_spender, _amount));
296 
297         ApproveAndCallFallBack(_spender).receiveApproval(
298             msg.sender,
299             _amount,
300             this,
301             _extraData
302         );
303 
304         return true;
305     }
306 
307     /// @dev This function makes it easy to get the total number of tokens
308     /// @return The total number of tokens
309     function totalSupply() public constant returns (uint) {
310         return totalSupplyAt(block.number);
311     }
312 
313 
314 ////////////////
315 // Query balance and totalSupply in History
316 ////////////////
317 
318     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
319     /// @param _owner The address from which the balance will be retrieved
320     /// @param _blockNumber The block number when the balance is queried
321     /// @return The balance at `_blockNumber`
322     function balanceOfAt(address _owner, uint _blockNumber) public constant
323         returns (uint) {
324 
325         // These next few lines are used when the balance of the token is
326         //  requested before a check point was ever created for this token, it
327         //  requires that the `parentToken.balanceOfAt` be queried at the
328         //  genesis block for that token as this contains initial balance of
329         //  this token
330         if ((balances[_owner].length == 0)
331             || (balances[_owner][0].fromBlock > _blockNumber)) {
332             if (address(parentToken) != 0) {
333                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
334             } else {
335                 // Has no parent
336                 return 0;
337             }
338 
339         // This will return the expected balance during normal situations
340         } else {
341             return getValueAt(balances[_owner], _blockNumber);
342         }
343     }
344 
345     /// @notice Total amount of tokens at a specific `_blockNumber`.
346     /// @param _blockNumber The block number when the totalSupply is queried
347     /// @return The total amount of tokens at `_blockNumber`
348     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
349 
350         // These next few lines are used when the totalSupply of the token is
351         //  requested before a check point was ever created for this token, it
352         //  requires that the `parentToken.totalSupplyAt` be queried at the
353         //  genesis block for this token as that contains totalSupply of this
354         //  token at this block number.
355         if ((totalSupplyHistory.length == 0)
356             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
357             if (address(parentToken) != 0) {
358                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
359             } else {
360                 return 0;
361             }
362 
363         // This will return the expected totalSupply during normal situations
364         } else {
365             return getValueAt(totalSupplyHistory, _blockNumber);
366         }
367     }
368 
369 ////////////////
370 // Clone Token Method
371 ////////////////
372 
373     /// @notice Creates a new clone token with the initial distribution being
374     ///  this token at `_snapshotBlock`
375     /// @param _cloneTokenName Name of the clone token
376     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
377     /// @param _cloneTokenSymbol Symbol of the clone token
378     /// @param _snapshotBlock Block when the distribution of the parent token is
379     ///  copied to set the initial distribution of the new clone token;
380     ///  if the block is zero than the actual block, the current block is used
381     /// @param _transfersEnabled True if transfers are allowed in the clone
382     /// @return The address of the new MiniMeToken Contract
383     function createCloneToken(
384         string _cloneTokenName,
385         uint8 _cloneDecimalUnits,
386         string _cloneTokenSymbol,
387         uint _snapshotBlock,
388         bool _transfersEnabled
389         ) public returns(address) {
390         if (_snapshotBlock == 0) _snapshotBlock = block.number;
391         MiniMeToken cloneToken = tokenFactory.createCloneToken(
392             this,
393             _snapshotBlock,
394             _cloneTokenName,
395             _cloneDecimalUnits,
396             _cloneTokenSymbol,
397             _transfersEnabled
398             );
399 
400         cloneToken.changeController(msg.sender);
401 
402         // An event to make the token easy to find on the blockchain
403         emit NewCloneToken(address(cloneToken), _snapshotBlock);
404         return address(cloneToken);
405     }
406 
407 ////////////////
408 // Generate and destroy tokens
409 ////////////////
410 
411     /// @notice Generates `_amount` tokens that are assigned to `_owner`
412     /// @param _owner The address that will be assigned the new tokens
413     /// @param _amount The quantity of tokens generated
414     /// @return True if the tokens are generated correctly
415     function generateTokens(address _owner, uint _amount
416     ) public onlyController returns (bool) {
417         uint curTotalSupply = totalSupply();
418         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
419         uint previousBalanceTo = balanceOf(_owner);
420         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
421         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
422         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
423         emit Transfer(0, _owner, _amount);
424         return true;
425     }
426 
427 
428     /// @notice Burns `_amount` tokens from `_owner`
429     /// @param _owner The address that will lose the tokens
430     /// @param _amount The quantity of tokens to burn
431     /// @return True if the tokens are burned correctly
432     function destroyTokens(address _owner, uint _amount
433     ) onlyController public returns (bool) {
434         uint curTotalSupply = totalSupply();
435         require(curTotalSupply >= _amount);
436         uint previousBalanceFrom = balanceOf(_owner);
437         require(previousBalanceFrom >= _amount);
438         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
439         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
440         emit Transfer(_owner, 0, _amount);
441         return true;
442     }
443 
444 ////////////////
445 // Enable tokens transfers
446 ////////////////
447 
448 
449     /// @notice Enables token holders to transfer their tokens freely if true
450     /// @param _transfersEnabled True if transfers are allowed in the clone
451     function enableTransfers(bool _transfersEnabled) public onlyController {
452         transfersEnabled = _transfersEnabled;
453     }
454 
455 ////////////////
456 // Internal helper functions to query and set a value in a snapshot array
457 ////////////////
458 
459     /// @dev `getValueAt` retrieves the number of tokens at a given block number
460     /// @param checkpoints The history of values being queried
461     /// @param _block The block number to retrieve the value at
462     /// @return The number of tokens being queried
463     function getValueAt(Checkpoint[] storage checkpoints, uint _block
464     ) constant internal returns (uint) {
465         if (checkpoints.length == 0) return 0;
466 
467         // Shortcut for the actual value
468         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
469             return checkpoints[checkpoints.length-1].value;
470         if (_block < checkpoints[0].fromBlock) return 0;
471 
472         // Binary search of the value in the array
473         uint min = 0;
474         uint max = checkpoints.length-1;
475         while (max > min) {
476             uint mid = (max + min + 1)/ 2;
477             if (checkpoints[mid].fromBlock<=_block) {
478                 min = mid;
479             } else {
480                 max = mid-1;
481             }
482         }
483         return checkpoints[min].value;
484     }
485 
486     /// @dev `updateValueAtNow` used to update the `balances` map and the
487     ///  `totalSupplyHistory`
488     /// @param checkpoints The history of data being updated
489     /// @param _value The new number of tokens
490     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
491     ) internal  {
492         if ((checkpoints.length == 0)
493         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
494                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
495                newCheckPoint.fromBlock =  uint128(block.number);
496                newCheckPoint.value = uint128(_value);
497            } else {
498                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
499                oldCheckPoint.value = uint128(_value);
500            }
501     }
502 
503     /// @dev Internal function to determine if an address is a contract
504     /// @param _addr The address being queried
505     /// @return True if `_addr` is a contract
506     function isContract(address _addr) constant internal returns(bool) {
507         uint size;
508         if (_addr == 0) return false;
509         assembly {
510             size := extcodesize(_addr)
511         }
512         return size>0;
513     }
514 
515     /// @dev Helper function to return a min betwen the two uints
516     function min(uint a, uint b) pure internal returns (uint) {
517         return a < b ? a : b;
518     }
519 
520     /// @notice The fallback function: If the contract's controller has not been
521     ///  set to 0, then the `proxyPayment` method is called which relays the
522     ///  ether and creates tokens as described in the token controller contract
523     function () public payable {
524         require(isContract(controller));
525         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
526     }
527 
528 //////////
529 // Safety Methods
530 //////////
531 
532     /// @notice This method can be used by the controller to extract mistakenly
533     ///  sent tokens to this contract.
534     /// @param _token The address of the token contract that you want to recover
535     ///  set to 0 in case you want to extract ether.
536     function claimTokens(address _token) public onlyController {
537         if (_token == 0x0) {
538             controller.transfer(address(this).balance);
539             return;
540         }
541 
542         MiniMeToken token = MiniMeToken(_token);
543         uint balance = token.balanceOf(this);
544         token.transfer(controller, balance);
545         emit ClaimedTokens(_token, controller, balance);
546     }
547 
548 ////////////////
549 // Events
550 ////////////////
551     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
552     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
553     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
554     event Approval(
555         address indexed _owner,
556         address indexed _spender,
557         uint256 _amount
558         );
559 
560 }
561 
562 
563 ////////////////
564 // MiniMeTokenFactory
565 ////////////////
566 
567 /// @dev This contract is used to generate clone contracts from a contract.
568 ///  In solidity this is the way to create a contract from a contract of the
569 ///  same class
570 contract MiniMeTokenFactory {
571 
572     /// @notice Update the DApp by creating a new token with new functionalities
573     ///  the msg.sender becomes the controller of this clone token
574     /// @param _parentToken Address of the token being cloned
575     /// @param _snapshotBlock Block of the parent token that will
576     ///  determine the initial distribution of the clone token
577     /// @param _tokenName Name of the new token
578     /// @param _decimalUnits Number of decimals of the new token
579     /// @param _tokenSymbol Token Symbol for the new token
580     /// @param _transfersEnabled If true, tokens will be able to be transferred
581     /// @return The address of the new token contract
582     function createCloneToken(
583         address _parentToken,
584         uint _snapshotBlock,
585         string _tokenName,
586         uint8 _decimalUnits,
587         string _tokenSymbol,
588         bool _transfersEnabled
589     ) public returns (MiniMeToken) {
590         MiniMeToken newToken = new MiniMeToken(
591             this,
592             _parentToken,
593             _snapshotBlock,
594             _tokenName,
595             _decimalUnits,
596             _tokenSymbol,
597             _transfersEnabled
598             );
599 
600         newToken.changeController(msg.sender);
601         return newToken;
602     }
603 }
604 
605 
606 contract ERC677Receiver {
607     function onTokenTransfer(
608         address _from,
609         uint _value,
610         bytes _data
611     ) external returns(bool);
612 }
613 
614 
615 contract TatauToken is MiniMeToken {
616     event Mint(address indexed to, uint256 amount);
617     event Burn(address indexed burner, uint256 value);
618     event Transfer(address indexed from, address indexed to, uint256 amount, bytes data);
619 
620     constructor(address _tokenFactory, address _foreignBridge) public MiniMeToken(
621         _tokenFactory,
622         0x0,
623         0,
624         "Tatau Token",
625         18,
626         "TATAU",
627         true
628     ) {
629         foreignBridge = _foreignBridge;
630     }
631 
632     address public foreignBridge;
633 
634     modifier onlyForeignBridge {
635         require(msg.sender == foreignBridge);
636         _;
637     }
638 
639     /// @notice Send `_amount` tokens to `_to` from `msg.sender` and call
640     /// `contractFallback` on the recipient if it is a Contract.
641     /// @param _to The address of the recipient
642     /// @param _amount The amount of tokens to be transferred
643     /// @param _data Additional bytes that will be passed to `contractFallback`
644     /// @return Whether the transfer was successful or not
645     function transferAndCall(address _to, uint256 _amount, bytes _data)
646         external returns (bool)
647     {
648         require(transfer(_to, _amount));
649         emit Transfer(msg.sender, _to, _amount, _data);
650         if (isContract(_to)) {
651             require(contractFallback(_to, _amount, _data));
652         }
653         return true;
654     }
655 
656     /// @notice Changes the foreignBridge
657     /// @param _newForeignBridge The foreign bridge address
658     function changeForeignBridge(address _newForeignBridge)
659         public onlyController
660     {
661         foreignBridge = _newForeignBridge;
662     }
663 
664     /// @notice Mints `_amount` tokens that are assigned to `_owner`
665     /// @param _amount The quantity of tokens to mint
666     /// @return True if the tokens are generated correctly
667     function mint(address _to, uint _amount)
668         public onlyForeignBridge returns (bool)
669     {
670         uint curTotalSupply = totalSupply();
671         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
672         uint previousBalanceTo = balanceOf(_to);
673         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
674         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
675         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
676         emit Mint(_to, _amount);
677         emit Transfer(0x0, _to, _amount);
678         return true;
679     }
680 
681     /// @notice Burns `_amount` tokens from `_owner`
682     /// @param _amount The quantity of tokens to burn
683     /// @return True if the tokens are burned correctly
684     function burn(uint _amount)
685         public onlyForeignBridge returns (bool)
686     {
687         uint curTotalSupply = totalSupply();
688         require(curTotalSupply >= _amount);
689         uint previousBalanceFrom = balanceOf(msg.sender);
690         require(previousBalanceFrom >= _amount);
691         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
692         updateValueAtNow(balances[msg.sender], previousBalanceFrom - _amount);
693         emit Burn(msg.sender, _amount);
694         emit Transfer(msg.sender, 0x0, _amount);
695         return true;
696     }
697 
698     function contractFallback(address _to, uint _value, bytes _data)
699         private returns(bool)
700     {
701         ERC677Receiver receiver = ERC677Receiver(_to);
702         return receiver.onTokenTransfer(msg.sender, _value, _data);
703     }
704 }
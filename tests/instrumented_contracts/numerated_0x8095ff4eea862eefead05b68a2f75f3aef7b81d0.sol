1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 
91 /**
92  * @title Claimable
93  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
94  * This allows the new owner to accept the transfer.
95  */
96 contract Claimable is Ownable {
97   address public pendingOwner;
98 
99   /**
100    * @dev Modifier throws if called by any account other than the pendingOwner.
101    */
102   modifier onlyPendingOwner() {
103     require(msg.sender == pendingOwner);
104     _;
105   }
106 
107   /**
108    * @dev Allows the current owner to set the pendingOwner address.
109    * @param newOwner The address to transfer ownership to.
110    */
111   function transferOwnership(address newOwner) onlyOwner public {
112     pendingOwner = newOwner;
113   }
114 
115   /**
116    * @dev Allows the pendingOwner address to finalize the transfer.
117    */
118   function claimOwnership() onlyPendingOwner public {
119     OwnershipTransferred(owner, pendingOwner);
120     owner = pendingOwner;
121     pendingOwner = address(0);
122   }
123 }
124 
125 
126 /**
127  * @title Pausable
128  * @dev Base contract which allows children to implement an emergency stop mechanism.
129  */
130 contract Pausable is Ownable {
131   event Pause();
132   event Unpause();
133 
134   bool public paused = false;
135 
136 
137   /**
138    * @dev Modifier to make a function callable only when the contract is not paused.
139    */
140   modifier whenNotPaused() {
141     require(!paused);
142     _;
143   }
144 
145   /**
146    * @dev Modifier to make a function callable only when the contract is paused.
147    */
148   modifier whenPaused() {
149     require(paused);
150     _;
151   }
152 
153   /**
154    * @dev called by the owner to pause, triggers stopped state
155    */
156   function pause() onlyOwner whenNotPaused public {
157     paused = true;
158     Pause();
159   }
160 
161   /**
162    * @dev called by the owner to unpause, returns to normal state
163    */
164   function unpause() onlyOwner whenPaused public {
165     paused = false;
166     Unpause();
167   }
168 }
169 
170 
171 /**
172  * @title ERC721 interface
173  * @dev see https://github.com/ethereum/eips/issues/721
174  */
175 contract ERC721 {
176   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
177   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
178 
179   function balanceOf(address _owner) public view returns (uint256 _balance);
180   function ownerOf(uint256 _tokenId) public view returns (address _owner);
181   function transfer(address _to, uint256 _tokenId) public;
182   function approve(address _to, uint256 _tokenId) public;
183   function takeOwnership(uint256 _tokenId) public;
184 }
185 
186 
187 /**
188  * @title ERC721Token
189  * Generic implementation for the required functionality of the ERC721 standard
190  */
191 contract ERC721Token is ERC721 {
192   using SafeMath for uint256;
193 
194   // Total amount of tokens
195   uint256 private totalTokens;
196 
197   // Mapping from token ID to owner
198   mapping (uint256 => address) private tokenOwner;
199 
200   // Mapping from token ID to approved address
201   mapping (uint256 => address) private tokenApprovals;
202 
203   // Mapping from owner to list of owned token IDs
204   mapping (address => uint256[]) private ownedTokens;
205 
206   // Mapping from token ID to index of the owner tokens list
207   mapping(uint256 => uint256) private ownedTokensIndex;
208 
209   /**
210   * @dev Guarantees msg.sender is owner of the given token
211   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
212   */
213   modifier onlyOwnerOf(uint256 _tokenId) {
214     require(ownerOf(_tokenId) == msg.sender);
215     _;
216   }
217 
218   /**
219   * @dev Gets the total amount of tokens stored by the contract
220   * @return uint256 representing the total amount of tokens
221   */
222   function totalSupply() public view returns (uint256) {
223     return totalTokens;
224   }
225 
226   /**
227   * @dev Gets the balance of the specified address
228   * @param _owner address to query the balance of
229   * @return uint256 representing the amount owned by the passed address
230   */
231   function balanceOf(address _owner) public view returns (uint256) {
232     return ownedTokens[_owner].length;
233   }
234 
235   /**
236   * @dev Gets the list of tokens owned by a given address
237   * @param _owner address to query the tokens of
238   * @return uint256[] representing the list of tokens owned by the passed address
239   */
240   function tokensOf(address _owner) public view returns (uint256[]) {
241     return ownedTokens[_owner];
242   }
243 
244   /**
245   * @dev Gets the owner of the specified token ID
246   * @param _tokenId uint256 ID of the token to query the owner of
247   * @return owner address currently marked as the owner of the given token ID
248   */
249   function ownerOf(uint256 _tokenId) public view returns (address) {
250     address owner = tokenOwner[_tokenId];
251     require(owner != address(0));
252     return owner;
253   }
254 
255   /**
256    * @dev Gets the approved address to take ownership of a given token ID
257    * @param _tokenId uint256 ID of the token to query the approval of
258    * @return address currently approved to take ownership of the given token ID
259    */
260   function approvedFor(uint256 _tokenId) public view returns (address) {
261     return tokenApprovals[_tokenId];
262   }
263 
264   /**
265   * @dev Transfers the ownership of a given token ID to another address
266   * @param _to address to receive the ownership of the given token ID
267   * @param _tokenId uint256 ID of the token to be transferred
268   */
269   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
270     clearApprovalAndTransfer(msg.sender, _to, _tokenId);
271   }
272 
273   /**
274   * @dev Approves another address to claim for the ownership of the given token ID
275   * @param _to address to be approved for the given token ID
276   * @param _tokenId uint256 ID of the token to be approved
277   */
278   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
279     address owner = ownerOf(_tokenId);
280     require(_to != owner);
281     if (approvedFor(_tokenId) != 0 || _to != 0) {
282       tokenApprovals[_tokenId] = _to;
283       Approval(owner, _to, _tokenId);
284     }
285   }
286 
287   /**
288   * @dev Claims the ownership of a given token ID
289   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
290   */
291   function takeOwnership(uint256 _tokenId) public {
292     require(isApprovedFor(msg.sender, _tokenId));
293     clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
294   }
295 
296   /**
297   * @dev Mint token function
298   * @param _to The address that will own the minted token
299   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
300   */
301   function _mint(address _to, uint256 _tokenId) internal {
302     require(_to != address(0));
303     addToken(_to, _tokenId);
304     Transfer(0x0, _to, _tokenId);
305   }
306 
307   /**
308   * @dev Burns a specific token
309   * @param _tokenId uint256 ID of the token being burned by the msg.sender
310   */
311   function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) internal {
312     if (approvedFor(_tokenId) != 0) {
313       clearApproval(msg.sender, _tokenId);
314     }
315     removeToken(msg.sender, _tokenId);
316     Transfer(msg.sender, 0x0, _tokenId);
317   }
318 
319   /**
320    * @dev Tells whether the msg.sender is approved for the given token ID or not
321    * This function is not private so it can be extended in further implementations like the operatable ERC721
322    * @param _owner address of the owner to query the approval of
323    * @param _tokenId uint256 ID of the token to query the approval of
324    * @return bool whether the msg.sender is approved for the given token ID or not
325    */
326   function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
327     return approvedFor(_tokenId) == _owner;
328   }
329 
330   /**
331   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
332   * @param _from address which you want to send tokens from
333   * @param _to address which you want to transfer the token to
334   * @param _tokenId uint256 ID of the token to be transferred
335   */
336   function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
337     require(_to != address(0));
338     require(_to != ownerOf(_tokenId));
339     require(ownerOf(_tokenId) == _from);
340 
341     clearApproval(_from, _tokenId);
342     removeToken(_from, _tokenId);
343     addToken(_to, _tokenId);
344     Transfer(_from, _to, _tokenId);
345   }
346 
347   /**
348   * @dev Internal function to clear current approval of a given token ID
349   * @param _tokenId uint256 ID of the token to be transferred
350   */
351   function clearApproval(address _owner, uint256 _tokenId) private {
352     require(ownerOf(_tokenId) == _owner);
353     tokenApprovals[_tokenId] = 0;
354     Approval(_owner, 0, _tokenId);
355   }
356 
357   /**
358   * @dev Internal function to add a token ID to the list of a given address
359   * @param _to address representing the new owner of the given token ID
360   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
361   */
362   function addToken(address _to, uint256 _tokenId) private {
363     require(tokenOwner[_tokenId] == address(0));
364     tokenOwner[_tokenId] = _to;
365     uint256 length = balanceOf(_to);
366     ownedTokens[_to].push(_tokenId);
367     ownedTokensIndex[_tokenId] = length;
368     totalTokens = totalTokens.add(1);
369   }
370 
371   /**
372   * @dev Internal function to remove a token ID from the list of a given address
373   * @param _from address representing the previous owner of the given token ID
374   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
375   */
376   function removeToken(address _from, uint256 _tokenId) private {
377     require(ownerOf(_tokenId) == _from);
378 
379     uint256 tokenIndex = ownedTokensIndex[_tokenId];
380     uint256 lastTokenIndex = balanceOf(_from).sub(1);
381     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
382 
383     tokenOwner[_tokenId] = 0;
384     ownedTokens[_from][tokenIndex] = lastToken;
385     ownedTokens[_from][lastTokenIndex] = 0;
386     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
387     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
388     // the lastToken to the first position, and then dropping the element placed in the last position of the list
389 
390     ownedTokens[_from].length--;
391     ownedTokensIndex[_tokenId] = 0;
392     ownedTokensIndex[lastToken] = tokenIndex;
393     totalTokens = totalTokens.sub(1);
394   }
395 }
396 
397 
398 /**
399  * @title ERC20Basic
400  * @dev Simpler version of ERC20 interface
401  * @dev see https://github.com/ethereum/EIPs/issues/179
402  */
403 contract ERC20Basic {
404   function totalSupply() public view returns (uint256);
405   function balanceOf(address who) public view returns (uint256);
406   function transfer(address to, uint256 value) public returns (bool);
407   event Transfer(address indexed from, address indexed to, uint256 value);
408 }
409 
410 
411 /**
412  * @title ERC20 interface
413  * @dev see https://github.com/ethereum/EIPs/issues/20
414  */
415 contract ERC20 is ERC20Basic {
416   function allowance(address owner, address spender) public view returns (uint256);
417   function transferFrom(address from, address to, uint256 value) public returns (bool);
418   function approve(address spender, uint256 value) public returns (bool);
419   event Approval(address indexed owner, address indexed spender, uint256 value);
420 }
421 
422 
423 /**
424  * @title Basic token
425  * @dev Basic version of StandardToken, with no allowances.
426  */
427 contract BasicToken is ERC20Basic {
428   using SafeMath for uint256;
429 
430   mapping(address => uint256) balances;
431 
432   uint256 totalSupply_;
433 
434   /**
435   * @dev total number of tokens in existence
436   */
437   function totalSupply() public view returns (uint256) {
438     return totalSupply_;
439   }
440 
441   /**
442   * @dev transfer token for a specified address
443   * @param _to The address to transfer to.
444   * @param _value The amount to be transferred.
445   */
446   function transfer(address _to, uint256 _value) public returns (bool) {
447     require(_to != address(0));
448     require(_value <= balances[msg.sender]);
449 
450     // SafeMath.sub will throw if there is not enough balance.
451     balances[msg.sender] = balances[msg.sender].sub(_value);
452     balances[_to] = balances[_to].add(_value);
453     Transfer(msg.sender, _to, _value);
454     return true;
455   }
456 
457   /**
458   * @dev Gets the balance of the specified address.
459   * @param _owner The address to query the the balance of.
460   * @return An uint256 representing the amount owned by the passed address.
461   */
462   function balanceOf(address _owner) public view returns (uint256 balance) {
463     return balances[_owner];
464   }
465 
466 }
467 
468 
469 /**
470  * @title Standard ERC20 token
471  *
472  * @dev Implementation of the basic standard token.
473  * @dev https://github.com/ethereum/EIPs/issues/20
474  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
475  */
476 contract StandardToken is ERC20, BasicToken {
477 
478   mapping (address => mapping (address => uint256)) internal allowed;
479 
480 
481   /**
482    * @dev Transfer tokens from one address to another
483    * @param _from address The address which you want to send tokens from
484    * @param _to address The address which you want to transfer to
485    * @param _value uint256 the amount of tokens to be transferred
486    */
487   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
488     require(_to != address(0));
489     require(_value <= balances[_from]);
490     require(_value <= allowed[_from][msg.sender]);
491 
492     balances[_from] = balances[_from].sub(_value);
493     balances[_to] = balances[_to].add(_value);
494     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
495     Transfer(_from, _to, _value);
496     return true;
497   }
498 
499   /**
500    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
501    *
502    * Beware that changing an allowance with this method brings the risk that someone may use both the old
503    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
504    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
505    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
506    * @param _spender The address which will spend the funds.
507    * @param _value The amount of tokens to be spent.
508    */
509   function approve(address _spender, uint256 _value) public returns (bool) {
510     allowed[msg.sender][_spender] = _value;
511     Approval(msg.sender, _spender, _value);
512     return true;
513   }
514 
515   /**
516    * @dev Function to check the amount of tokens that an owner allowed to a spender.
517    * @param _owner address The address which owns the funds.
518    * @param _spender address The address which will spend the funds.
519    * @return A uint256 specifying the amount of tokens still available for the spender.
520    */
521   function allowance(address _owner, address _spender) public view returns (uint256) {
522     return allowed[_owner][_spender];
523   }
524 
525   /**
526    * @dev Increase the amount of tokens that an owner allowed to a spender.
527    *
528    * approve should be called when allowed[_spender] == 0. To increment
529    * allowed value is better to use this function to avoid 2 calls (and wait until
530    * the first transaction is mined)
531    * From MonolithDAO Token.sol
532    * @param _spender The address which will spend the funds.
533    * @param _addedValue The amount of tokens to increase the allowance by.
534    */
535   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
536     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
537     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
538     return true;
539   }
540 
541   /**
542    * @dev Decrease the amount of tokens that an owner allowed to a spender.
543    *
544    * approve should be called when allowed[_spender] == 0. To decrement
545    * allowed value is better to use this function to avoid 2 calls (and wait until
546    * the first transaction is mined)
547    * From MonolithDAO Token.sol
548    * @param _spender The address which will spend the funds.
549    * @param _subtractedValue The amount of tokens to decrease the allowance by.
550    */
551   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
552     uint oldValue = allowed[msg.sender][_spender];
553     if (_subtractedValue > oldValue) {
554       allowed[msg.sender][_spender] = 0;
555     } else {
556       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
557     }
558     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
559     return true;
560   }
561 
562 }
563 
564 
565 /**
566  * @title AccessDeposit
567  * @dev Adds grant/revoke functions to the contract.
568  */
569 contract AccessDeposit is Claimable {
570 
571   // Access for adding deposit.
572   mapping(address => bool) private depositAccess;
573 
574   // Modifier for accessibility to add deposit.
575   modifier onlyAccessDeposit {
576     require(msg.sender == owner || depositAccess[msg.sender] == true);
577     _;
578   }
579 
580   // @dev Grant acess to deposit heroes.
581   function grantAccessDeposit(address _address)
582     onlyOwner
583     public
584   {
585     depositAccess[_address] = true;
586   }
587 
588   // @dev Revoke acess to deposit heroes.
589   function revokeAccessDeposit(address _address)
590     onlyOwner
591     public
592   {
593     depositAccess[_address] = false;
594   }
595 
596 }
597 
598 
599 /**
600  * @title AccessDeploy
601  * @dev Adds grant/revoke functions to the contract.
602  */
603 contract AccessDeploy is Claimable {
604 
605   // Access for deploying heroes.
606   mapping(address => bool) private deployAccess;
607 
608   // Modifier for accessibility to deploy a hero on a location.
609   modifier onlyAccessDeploy {
610     require(msg.sender == owner || deployAccess[msg.sender] == true);
611     _;
612   }
613 
614   // @dev Grant acess to deploy heroes.
615   function grantAccessDeploy(address _address)
616     onlyOwner
617     public
618   {
619     deployAccess[_address] = true;
620   }
621 
622   // @dev Revoke acess to deploy heroes.
623   function revokeAccessDeploy(address _address)
624     onlyOwner
625     public
626   {
627     deployAccess[_address] = false;
628   }
629 
630 }
631 
632 /**
633  * @title AccessMint
634  * @dev Adds grant/revoke functions to the contract.
635  */
636 contract AccessMint is Claimable {
637 
638   // Access for minting new tokens.
639   mapping(address => bool) private mintAccess;
640 
641   // Modifier for accessibility to define new hero types.
642   modifier onlyAccessMint {
643     require(msg.sender == owner || mintAccess[msg.sender] == true);
644     _;
645   }
646 
647   // @dev Grant acess to mint heroes.
648   function grantAccessMint(address _address)
649     onlyOwner
650     public
651   {
652     mintAccess[_address] = true;
653   }
654 
655   // @dev Revoke acess to mint heroes.
656   function revokeAccessMint(address _address)
657     onlyOwner
658     public
659   {
660     mintAccess[_address] = false;
661   }
662 
663 }
664 
665 
666 /**
667  * @title Gold
668  * @dev ERC20 Token that can be minted.
669  */
670 contract Gold is StandardToken, Claimable, AccessMint {
671 
672   string public constant name = "Gold";
673   string public constant symbol = "G";
674   uint8 public constant decimals = 18;
675 
676   // Event that is fired when minted.
677   event Mint(
678     address indexed _to,
679     uint256 indexed _tokenId
680   );
681 
682   // @dev Mint tokens with _amount to the address.
683   function mint(address _to, uint256 _amount) 
684     onlyAccessMint
685     public 
686     returns (bool) 
687   {
688     totalSupply_ = totalSupply_.add(_amount);
689     balances[_to] = balances[_to].add(_amount);
690     Mint(_to, _amount);
691     Transfer(address(0), _to, _amount);
692     return true;
693   }
694 
695 }
696 
697 
698 /**
699  * @title CryptoSaga Card
700  * @dev ERC721 Token that repesents CryptoSaga's cards.
701  *  Buy consuming a card, players of CryptoSaga can get a heroe.
702  */
703 contract CryptoSagaCard is ERC721Token, Claimable, AccessMint {
704 
705   string public constant name = "CryptoSaga Card";
706   string public constant symbol = "CARD";
707 
708   // Rank of the token.
709   mapping(uint256 => uint8) public tokenIdToRank;
710 
711   // The number of tokens ever minted.
712   uint256 public numberOfTokenId;
713 
714   // The converter contract.
715   CryptoSagaCardSwap private swapContract;
716 
717   // Event that should be fired when card is converted.
718   event CardSwap(address indexed _by, uint256 _tokenId, uint256 _rewardId);
719 
720   // @dev Set the address of the contract that represents CryptoSaga Cards.
721   function setCryptoSagaCardSwapContract(address _contractAddress)
722     public
723     onlyOwner
724   {
725     swapContract = CryptoSagaCardSwap(_contractAddress);
726   }
727 
728   function rankOf(uint256 _tokenId) 
729     public view
730     returns (uint8)
731   {
732     return tokenIdToRank[_tokenId];
733   }
734 
735   // @dev Mint a new card.
736   function mint(address _beneficiary, uint256 _amount, uint8 _rank)
737     onlyAccessMint
738     public
739   {
740     for (uint256 i = 0; i < _amount; i++) {
741       _mint(_beneficiary, numberOfTokenId);
742       tokenIdToRank[numberOfTokenId] = _rank;
743       numberOfTokenId ++;
744     }
745   }
746 
747   // @dev Swap this card for reward.
748   //  The card will be burnt.
749   function swap(uint256 _tokenId)
750     onlyOwnerOf(_tokenId)
751     public
752     returns (uint256)
753   {
754     require(address(swapContract) != address(0));
755 
756     var _rank = tokenIdToRank[_tokenId];
757     var _rewardId = swapContract.swapCardForReward(this, _rank);
758     CardSwap(ownerOf(_tokenId), _tokenId, _rewardId);
759     _burn(_tokenId);
760     return _rewardId;
761   }
762 
763 }
764 
765 
766 /**
767  * @title The interface contract for Card-For-Hero swap functionality.
768  * @dev With this contract, a card holder can swap his/her CryptoSagaCard for reward.
769  *  This contract is intended to be inherited by CryptoSagaCardSwap implementation contracts.
770  */
771 contract CryptoSagaCardSwap is Ownable {
772 
773   // Card contract.
774   address internal cardAddess;
775 
776   // Modifier for accessibility to define new hero types.
777   modifier onlyCard {
778     require(msg.sender == cardAddess);
779     _;
780   }
781   
782   // @dev Set the address of the contract that represents ERC721 Card.
783   function setCardContract(address _contractAddress)
784     public
785     onlyOwner
786   {
787     cardAddess = _contractAddress;
788   }
789 
790   // @dev Convert card into reward.
791   //  This should be implemented by CryptoSagaCore later.
792   function swapCardForReward(address _by, uint8 _rank)
793     onlyCard
794     public 
795     returns (uint256);
796 
797 }
798 
799 
800 /**
801  * @title CryptoSagaHero
802  * @dev The token contract for the hero.
803  *  Also a superset of the ERC721 standard that allows for the minting
804  *  of the non-fungible tokens.
805  */
806 contract CryptoSagaHero is ERC721Token, Claimable, Pausable, AccessMint, AccessDeploy, AccessDeposit {
807 
808   string public constant name = "CryptoSaga Hero";
809   string public constant symbol = "HERO";
810   
811   struct HeroClass {
812     // ex) Soldier, Knight, Fighter...
813     string className;
814     // 0: Common, 1: Uncommon, 2: Rare, 3: Heroic, 4: Legendary.
815     uint8 classRank;
816     // 0: Human, 1: Celestial, 2: Demon, 3: Elf, 4: Dark Elf, 5: Yogoe, 6: Furry, 7: Dragonborn, 8: Undead, 9: Goblin, 10: Troll, 11: Slime, and more to come.
817     uint8 classRace;
818     // How old is this hero class? 
819     uint32 classAge;
820     // 0: Fighter, 1: Rogue, 2: Mage.
821     uint8 classType;
822 
823     // Possible max level of this class.
824     uint32 maxLevel; 
825     // 0: Water, 1: Fire, 2: Nature, 3: Light, 4: Darkness.
826     uint8 aura; 
827 
828     // Base stats of this hero type. 
829     // 0: ATK	1: DEF 2: AGL	3: LUK 4: HP.
830     uint32[5] baseStats;
831     // Minimum IVs for stats. 
832     // 0: ATK	1: DEF 2: AGL	3: LUK 4: HP.
833     uint32[5] minIVForStats;
834     // Maximum IVs for stats.
835     // 0: ATK	1: DEF 2: AGL	3: LUK 4: HP.
836     uint32[5] maxIVForStats;
837     
838     // Number of currently instanced heroes.
839     uint32 currentNumberOfInstancedHeroes;
840   }
841     
842   struct HeroInstance {
843     // What is this hero's type? ex) John, Sally, Mark...
844     uint32 heroClassId;
845     
846     // Individual hero's name.
847     string heroName;
848     
849     // Current level of this hero.
850     uint32 currentLevel;
851     // Current exp of this hero.
852     uint32 currentExp;
853 
854     // Where has this hero been deployed? (0: Never depolyed ever.) ex) Dungeon Floor #1, Arena #5...
855     uint32 lastLocationId;
856     // When a hero is deployed, it takes time for the hero to return to the base. This is in Unix epoch.
857     uint256 availableAt;
858 
859     // Current stats of this hero. 
860     // 0: ATK	1: DEF 2: AGL	3: LUK 4: HP.
861     uint32[5] currentStats;
862     // The individual value for this hero's stats. 
863     // This will affect the current stats of heroes.
864     // 0: ATK	1: DEF 2: AGL	3: LUK 4: HP.
865     uint32[5] ivForStats;
866   }
867 
868   // Required exp for level up will increase when heroes level up.
869   // This defines how the value will increase.
870   uint32 public requiredExpIncreaseFactor = 100;
871 
872   // Required Gold for level up will increase when heroes level up.
873   // This defines how the value will increase.
874   uint256 public requiredGoldIncreaseFactor = 1000000000000000000;
875 
876   // Existing hero classes.
877   mapping(uint32 => HeroClass) public heroClasses;
878   // The number of hero classes ever defined.
879   uint32 public numberOfHeroClasses;
880 
881   // Existing hero instances.
882   // The key is _tokenId.
883   mapping(uint256 => HeroInstance) public tokenIdToHeroInstance;
884   // The number of tokens ever minted. This works as the serial number.
885   uint256 public numberOfTokenIds;
886 
887   // Gold contract.
888   Gold public goldContract;
889 
890   // Deposit of players (in Gold).
891   mapping(address => uint256) public addressToGoldDeposit;
892 
893   // Random seed.
894   uint32 private seed = 0;
895 
896   // Event that is fired when a hero type defined.
897   event DefineType(
898     address indexed _by,
899     uint32 indexed _typeId,
900     string _className
901   );
902 
903   // Event that is fired when a hero is upgraded.
904   event LevelUp(
905     address indexed _by,
906     uint256 indexed _tokenId,
907     uint32 _newLevel
908   );
909 
910   // Event that is fired when a hero is deployed.
911   event Deploy(
912     address indexed _by,
913     uint256 indexed _tokenId,
914     uint32 _locationId,
915     uint256 _duration
916   );
917 
918   // @dev Get the class's entire infomation.
919   function getClassInfo(uint32 _classId)
920     external view
921     returns (string className, uint8 classRank, uint8 classRace, uint32 classAge, uint8 classType, uint32 maxLevel, uint8 aura, uint32[5] baseStats, uint32[5] minIVs, uint32[5] maxIVs) 
922   {
923     var _cl = heroClasses[_classId];
924     return (_cl.className, _cl.classRank, _cl.classRace, _cl.classAge, _cl.classType, _cl.maxLevel, _cl.aura, _cl.baseStats, _cl.minIVForStats, _cl.maxIVForStats);
925   }
926 
927   // @dev Get the class's name.
928   function getClassName(uint32 _classId)
929     external view
930     returns (string)
931   {
932     return heroClasses[_classId].className;
933   }
934 
935   // @dev Get the class's rank.
936   function getClassRank(uint32 _classId)
937     external view
938     returns (uint8)
939   {
940     return heroClasses[_classId].classRank;
941   }
942 
943   // @dev Get the heroes ever minted for the class.
944   function getClassMintCount(uint32 _classId)
945     external view
946     returns (uint32)
947   {
948     return heroClasses[_classId].currentNumberOfInstancedHeroes;
949   }
950 
951   // @dev Get the hero's entire infomation.
952   function getHeroInfo(uint256 _tokenId)
953     external view
954     returns (uint32 classId, string heroName, uint32 currentLevel, uint32 currentExp, uint32 lastLocationId, uint256 availableAt, uint32[5] currentStats, uint32[5] ivs, uint32 bp)
955   {
956     HeroInstance memory _h = tokenIdToHeroInstance[_tokenId];
957     var _bp = _h.currentStats[0] + _h.currentStats[1] + _h.currentStats[2] + _h.currentStats[3] + _h.currentStats[4];
958     return (_h.heroClassId, _h.heroName, _h.currentLevel, _h.currentExp, _h.lastLocationId, _h.availableAt, _h.currentStats, _h.ivForStats, _bp);
959   }
960 
961   // @dev Get the hero's class id.
962   function getHeroClassId(uint256 _tokenId)
963     external view
964     returns (uint32)
965   {
966     return tokenIdToHeroInstance[_tokenId].heroClassId;
967   }
968 
969   // @dev Get the hero's name.
970   function getHeroName(uint256 _tokenId)
971     external view
972     returns (string)
973   {
974     return tokenIdToHeroInstance[_tokenId].heroName;
975   }
976 
977   // @dev Get the hero's level.
978   function getHeroLevel(uint256 _tokenId)
979     external view
980     returns (uint32)
981   {
982     return tokenIdToHeroInstance[_tokenId].currentLevel;
983   }
984   
985   // @dev Get the hero's location.
986   function getHeroLocation(uint256 _tokenId)
987     external view
988     returns (uint32)
989   {
990     return tokenIdToHeroInstance[_tokenId].lastLocationId;
991   }
992 
993   // @dev Get the time when the hero become available.
994   function getHeroAvailableAt(uint256 _tokenId)
995     external view
996     returns (uint256)
997   {
998     return tokenIdToHeroInstance[_tokenId].availableAt;
999   }
1000 
1001   // @dev Get the hero's BP.
1002   function getHeroBP(uint256 _tokenId)
1003     public view
1004     returns (uint32)
1005   {
1006     var _tmp = tokenIdToHeroInstance[_tokenId].currentStats;
1007     return (_tmp[0] + _tmp[1] + _tmp[2] + _tmp[3] + _tmp[4]);
1008   }
1009 
1010   // @dev Get the hero's required gold for level up.
1011   function getHeroRequiredGoldForLevelUp(uint256 _tokenId)
1012     public view
1013     returns (uint256)
1014   {
1015     return (uint256(2) ** (tokenIdToHeroInstance[_tokenId].currentLevel / 10)) * requiredGoldIncreaseFactor;
1016   }
1017 
1018   // @dev Get the hero's required exp for level up.
1019   function getHeroRequiredExpForLevelUp(uint256 _tokenId)
1020     public view
1021     returns (uint32)
1022   {
1023     return ((tokenIdToHeroInstance[_tokenId].currentLevel + 2) * requiredExpIncreaseFactor);
1024   }
1025 
1026   // @dev Get the deposit of gold of the player.
1027   function getGoldDepositOfAddress(address _address)
1028     external view
1029     returns (uint256)
1030   {
1031     return addressToGoldDeposit[_address];
1032   }
1033 
1034   // @dev Get the token id of the player's #th token.
1035   function getTokenIdOfAddressAndIndex(address _address, uint256 _index)
1036     external view
1037     returns (uint256)
1038   {
1039     return tokensOf(_address)[_index];
1040   }
1041 
1042   // @dev Get the total BP of the player.
1043   function getTotalBPOfAddress(address _address)
1044     external view
1045     returns (uint32)
1046   {
1047     var _tokens = tokensOf(_address);
1048     uint32 _totalBP = 0;
1049     for (uint256 i = 0; i < _tokens.length; i ++) {
1050       _totalBP += getHeroBP(_tokens[i]);
1051     }
1052     return _totalBP;
1053   }
1054 
1055   // @dev Set the hero's name.
1056   function setHeroName(uint256 _tokenId, string _name)
1057     onlyOwnerOf(_tokenId)
1058     public
1059   {
1060     tokenIdToHeroInstance[_tokenId].heroName = _name;
1061   }
1062 
1063   // @dev Set the address of the contract that represents ERC20 Gold.
1064   function setGoldContract(address _contractAddress)
1065     onlyOwner
1066     public
1067   {
1068     goldContract = Gold(_contractAddress);
1069   }
1070 
1071   // @dev Set the required golds to level up a hero.
1072   function setRequiredExpIncreaseFactor(uint32 _value)
1073     onlyOwner
1074     public
1075   {
1076     requiredExpIncreaseFactor = _value;
1077   }
1078 
1079   // @dev Set the required golds to level up a hero.
1080   function setRequiredGoldIncreaseFactor(uint256 _value)
1081     onlyOwner
1082     public
1083   {
1084     requiredGoldIncreaseFactor = _value;
1085   }
1086 
1087   // @dev Contructor.
1088   function CryptoSagaHero(address _goldAddress)
1089     public
1090   {
1091     require(_goldAddress != address(0));
1092 
1093     // Assign Gold contract.
1094     setGoldContract(_goldAddress);
1095 
1096     // Initial heroes.
1097     // Name, Rank, Race, Age, Type, Max Level, Aura, Stats.
1098     defineType("Archangel", 4, 1, 13540, 0, 99, 3, [uint32(74), 75, 57, 99, 95], [uint32(8), 6, 8, 5, 5], [uint32(8), 10, 10, 6, 6]);
1099     defineType("Shadowalker", 3, 4, 134, 1, 75, 4, [uint32(45), 35, 60, 80, 40], [uint32(3), 2, 10, 4, 5], [uint32(5), 5, 10, 7, 5]);
1100     defineType("Pyromancer", 2, 0, 14, 2, 50, 1, [uint32(50), 28, 17, 40, 35], [uint32(5), 3, 2, 3, 3], [uint32(8), 4, 3, 4, 5]);
1101     defineType("Magician", 1, 3, 224, 2, 30, 0, [uint32(35), 15, 25, 25, 30], [uint32(3), 1, 2, 2, 2], [uint32(5), 2, 3, 3, 3]);
1102     defineType("Farmer", 0, 0, 59, 0, 15, 2, [uint32(10), 22, 8, 15, 25], [uint32(1), 2, 1, 1, 2], [uint32(1), 3, 1, 2, 3]);
1103   }
1104 
1105   // @dev Define a new hero type (class).
1106   function defineType(string _className, uint8 _classRank, uint8 _classRace, uint32 _classAge, uint8 _classType, uint32 _maxLevel, uint8 _aura, uint32[5] _baseStats, uint32[5] _minIVForStats, uint32[5] _maxIVForStats)
1107     onlyOwner
1108     public
1109   {
1110     require(_classRank < 5);
1111     require(_classType < 3);
1112     require(_aura < 5);
1113     require(_minIVForStats[0] <= _maxIVForStats[0] && _minIVForStats[1] <= _maxIVForStats[1] && _minIVForStats[2] <= _maxIVForStats[2] && _minIVForStats[3] <= _maxIVForStats[3] && _minIVForStats[4] <= _maxIVForStats[4]);
1114 
1115     HeroClass memory _heroType = HeroClass({
1116       className: _className,
1117       classRank: _classRank,
1118       classRace: _classRace,
1119       classAge: _classAge,
1120       classType: _classType,
1121       maxLevel: _maxLevel,
1122       aura: _aura,
1123       baseStats: _baseStats,
1124       minIVForStats: _minIVForStats,
1125       maxIVForStats: _maxIVForStats,
1126       currentNumberOfInstancedHeroes: 0
1127     });
1128 
1129     // Save the hero class.
1130     heroClasses[numberOfHeroClasses] = _heroType;
1131 
1132     // Fire event.
1133     DefineType(msg.sender, numberOfHeroClasses, _heroType.className);
1134 
1135     // Increment number of hero classes.
1136     numberOfHeroClasses ++;
1137 
1138   }
1139 
1140   // @dev Mint a new hero, with _heroClassId.
1141   function mint(address _owner, uint32 _heroClassId)
1142     onlyAccessMint
1143     public
1144     returns (uint256)
1145   {
1146     require(_owner != address(0));
1147     require(_heroClassId < numberOfHeroClasses);
1148 
1149     // The information of the hero's class.
1150     var _heroClassInfo = heroClasses[_heroClassId];
1151 
1152     // Mint ERC721 token.
1153     _mint(_owner, numberOfTokenIds);
1154 
1155     // Build random IVs for this hero instance.
1156     uint32[5] memory _ivForStats;
1157     uint32[5] memory _initialStats;
1158     for (uint8 i = 0; i < 5; i++) {
1159       _ivForStats[i] = (random(_heroClassInfo.maxIVForStats[i] + 1, _heroClassInfo.minIVForStats[i]));
1160       _initialStats[i] = _heroClassInfo.baseStats[i] + _ivForStats[i];
1161     }
1162 
1163     // Temporary hero instance.
1164     HeroInstance memory _heroInstance = HeroInstance({
1165       heroClassId: _heroClassId,
1166       heroName: "",
1167       currentLevel: 1,
1168       currentExp: 0,
1169       lastLocationId: 0,
1170       availableAt: now,
1171       currentStats: _initialStats,
1172       ivForStats: _ivForStats
1173     });
1174 
1175     // Save the hero instance.
1176     tokenIdToHeroInstance[numberOfTokenIds] = _heroInstance;
1177 
1178     // Increment number of token ids.
1179     // This will only increment when new token is minted, and will never be decemented when the token is burned.
1180     numberOfTokenIds ++;
1181 
1182      // Increment instanced number of heroes.
1183     _heroClassInfo.currentNumberOfInstancedHeroes ++;
1184 
1185     return numberOfTokenIds - 1;
1186   }
1187 
1188   // @dev Set where the heroes are deployed, and when they will return.
1189   //  This is intended to be called by Dungeon, Arena, Guild contracts.
1190   function deploy(uint256 _tokenId, uint32 _locationId, uint256 _duration)
1191     onlyAccessDeploy
1192     public
1193     returns (bool)
1194   {
1195     // The hero should be possessed by anybody.
1196     require(ownerOf(_tokenId) != address(0));
1197 
1198     var _heroInstance = tokenIdToHeroInstance[_tokenId];
1199 
1200     // The character should be avaiable. 
1201     require(_heroInstance.availableAt <= now);
1202 
1203     _heroInstance.lastLocationId = _locationId;
1204     _heroInstance.availableAt = now + _duration;
1205 
1206     // As the hero has been deployed to another place, fire event.
1207     Deploy(msg.sender, _tokenId, _locationId, _duration);
1208   }
1209 
1210   // @dev Add exp.
1211   //  This is intended to be called by Dungeon, Arena, Guild contracts.
1212   function addExp(uint256 _tokenId, uint32 _exp)
1213     onlyAccessDeploy
1214     public
1215     returns (bool)
1216   {
1217     // The hero should be possessed by anybody.
1218     require(ownerOf(_tokenId) != address(0));
1219 
1220     var _heroInstance = tokenIdToHeroInstance[_tokenId];
1221 
1222     var _newExp = _heroInstance.currentExp + _exp;
1223 
1224     // Sanity check to ensure we don't overflow.
1225     require(_newExp == uint256(uint128(_newExp)));
1226 
1227     _heroInstance.currentExp += _newExp;
1228 
1229   }
1230 
1231   // @dev Add deposit.
1232   //  This is intended to be called by Dungeon, Arena, Guild contracts.
1233   function addDeposit(address _to, uint256 _amount)
1234     onlyAccessDeposit
1235     public
1236   {
1237     // Increment deposit.
1238     addressToGoldDeposit[_to] += _amount;
1239   }
1240 
1241   // @dev Level up the hero with _tokenId.
1242   //  This function is called by the owner of the hero.
1243   function levelUp(uint256 _tokenId)
1244     onlyOwnerOf(_tokenId) whenNotPaused
1245     public
1246   {
1247 
1248     // Hero instance.
1249     var _heroInstance = tokenIdToHeroInstance[_tokenId];
1250 
1251     // The character should be avaiable. (Should have already returned from the dungeons, arenas, etc.)
1252     require(_heroInstance.availableAt <= now);
1253 
1254     // The information of the hero's class.
1255     var _heroClassInfo = heroClasses[_heroInstance.heroClassId];
1256 
1257     // Hero shouldn't level up exceed its max level.
1258     require(_heroInstance.currentLevel < _heroClassInfo.maxLevel);
1259 
1260     // Required Exp.
1261     var requiredExp = getHeroRequiredExpForLevelUp(_tokenId);
1262 
1263     // Need to have enough exp.
1264     require(_heroInstance.currentExp >= requiredExp);
1265 
1266     // Required Gold.
1267     var requiredGold = getHeroRequiredGoldForLevelUp(_tokenId);
1268 
1269     // Owner of token.
1270     var _ownerOfToken = ownerOf(_tokenId);
1271 
1272     // Need to have enough Gold balance.
1273     require(addressToGoldDeposit[_ownerOfToken] >= requiredGold);
1274 
1275     // Increase Level.
1276     _heroInstance.currentLevel += 1;
1277 
1278     // Increase Stats.
1279     for (uint8 i = 0; i < 5; i++) {
1280       _heroInstance.currentStats[i] = _heroClassInfo.baseStats[i] + (_heroInstance.currentLevel - 1) * _heroInstance.ivForStats[i];
1281     }
1282     
1283     // Deduct exp.
1284     _heroInstance.currentExp -= requiredExp;
1285 
1286     // Deduct gold.
1287     addressToGoldDeposit[_ownerOfToken] -= requiredGold;
1288 
1289     // Fire event.
1290     LevelUp(msg.sender, _tokenId, _heroInstance.currentLevel);
1291   }
1292 
1293   // @dev Transfer deposit (with the allowance pattern.)
1294   function transferDeposit(uint256 _amount)
1295     whenNotPaused
1296     public
1297   {
1298     require(goldContract.allowance(msg.sender, this) >= _amount);
1299 
1300     // Send msg.sender's Gold to this contract.
1301     if (goldContract.transferFrom(msg.sender, this, _amount)) {
1302        // Increment deposit.
1303       addressToGoldDeposit[msg.sender] += _amount;
1304     }
1305   }
1306 
1307   // @dev Withdraw deposit.
1308   function withdrawDeposit(uint256 _amount)
1309     public
1310   {
1311     require(addressToGoldDeposit[msg.sender] >= _amount);
1312 
1313     // Send deposit of Golds to msg.sender. (Rather minting...)
1314     if (goldContract.transfer(msg.sender, _amount)) {
1315       // Decrement deposit.
1316       addressToGoldDeposit[msg.sender] -= _amount;
1317     }
1318   }
1319 
1320   // @dev return a pseudo random number between lower and upper bounds
1321   function random(uint32 _upper, uint32 _lower)
1322     private
1323     returns (uint32)
1324   {
1325     require(_upper > _lower);
1326 
1327     seed = uint32(keccak256(keccak256(block.blockhash(block.number), seed), now));
1328     return seed % (_upper - _lower) + _lower;
1329   }
1330 
1331 }
1332 
1333 
1334 /**
1335  * @title CryptoSagaCorrectedHeroStats
1336  * @dev Corrected hero stats is needed to fix the bug in hero stats.
1337  */
1338 contract CryptoSagaCorrectedHeroStats {
1339 
1340   // The hero contract.
1341   CryptoSagaHero private heroContract;
1342 
1343   // @dev Constructor.
1344   function CryptoSagaCorrectedHeroStats(address _heroContractAddress)
1345     public
1346   {
1347     heroContract = CryptoSagaHero(_heroContractAddress);
1348   }
1349 
1350   // @dev Get the hero's stats and some other infomation.
1351   function getCorrectedStats(uint256 _tokenId)
1352     external view
1353     returns (uint32 currentLevel, uint32 currentExp, uint32[5] currentStats, uint32[5] ivs, uint32 bp)
1354   {
1355     var (, , _currentLevel, _currentExp, , , _currentStats, _ivs, ) = heroContract.getHeroInfo(_tokenId);
1356     
1357     if (_currentLevel != 1) {
1358       for (uint8 i = 0; i < 5; i ++) {
1359         _currentStats[i] += _ivs[i];
1360       }
1361     }
1362 
1363     var _bp = _currentStats[0] + _currentStats[1] + _currentStats[2] + _currentStats[3] + _currentStats[4];
1364     return (_currentLevel, _currentExp, _currentStats, _ivs, _bp);
1365   }
1366 
1367   // @dev Get corrected total BP of the address.
1368   function getCorrectedTotalBPOfAddress(address _address)
1369     external view
1370     returns (uint32)
1371   {
1372     var _balance = heroContract.balanceOf(_address);
1373 
1374     uint32 _totalBP = 0;
1375 
1376     for (uint256 i = 0; i < _balance; i ++) {
1377       var (, , _currentLevel, , , , _currentStats, _ivs, ) = heroContract.getHeroInfo(heroContract.getTokenIdOfAddressAndIndex(_address, i));
1378       if (_currentLevel != 1) {
1379         for (uint8 j = 0; j < 5; j ++) {
1380           _currentStats[j] += _ivs[j];
1381         }
1382       }
1383       _totalBP += (_currentStats[0] + _currentStats[1] + _currentStats[2] + _currentStats[3] + _currentStats[4]);
1384     }
1385 
1386     return _totalBP;
1387   }
1388 
1389   // @dev Get corrected total BP of the address.
1390   function getCorrectedTotalBPOfTokens(uint256[] _tokens)
1391     external view
1392     returns (uint32)
1393   {
1394     uint32 _totalBP = 0;
1395 
1396     for (uint256 i = 0; i < _tokens.length; i ++) {
1397       var (, , _currentLevel, , , , _currentStats, _ivs, ) = heroContract.getHeroInfo(_tokens[i]);
1398       if (_currentLevel != 1) {
1399         for (uint8 j = 0; j < 5; j ++) {
1400           _currentStats[j] += _ivs[j];
1401         }
1402       }
1403       _totalBP += (_currentStats[0] + _currentStats[1] + _currentStats[2] + _currentStats[3] + _currentStats[4]);
1404     }
1405 
1406     return _totalBP;
1407   }
1408 }
1409 
1410 
1411 
1412 /**
1413  * @title CryptoSagaArenaRecord
1414  * @dev The record of battles in the Arena.
1415  */
1416 contract CryptoSagaArenaRecord is Pausable, AccessDeploy {
1417 
1418   // Number of players for the leaderboard.
1419   uint8 public numberOfLeaderboardPlayers = 25;
1420 
1421   // Top players in the leaderboard.
1422   address[] public leaderBoardPlayers;
1423 
1424   // For checking whether the player is in the leaderboard.
1425   mapping(address => bool) public addressToIsInLeaderboard;
1426 
1427   // Number of recent player recorded for matchmaking.
1428   uint8 public numberOfRecentPlayers = 50;
1429 
1430   // List of recent players.
1431   address[] public recentPlayers;
1432 
1433   // Front of recent players.
1434   uint256 public recentPlayersFront;
1435 
1436   // Back of recent players.
1437   uint256 public recentPlayersBack;
1438 
1439   // Record of each player.
1440   mapping(address => uint32) public addressToElo;
1441 
1442   // Event that is fired when a new change has been made to the leaderboard.
1443   event UpdateLeaderboard(
1444     address indexed _by,
1445     uint256 _dateTime
1446   );
1447 
1448   // @dev Get elo rating of a player.
1449   function getEloRating(address _address)
1450     external view
1451     returns (uint32)
1452   {
1453     if (addressToElo[_address] != 0)
1454       return addressToElo[_address];
1455     else
1456       return 1500;
1457   }
1458 
1459   // @dev Get players in the leaderboard.
1460   function getLeaderboardPlayers()
1461     external view
1462     returns (address[])
1463   {
1464     return leaderBoardPlayers;
1465   }
1466 
1467   // @dev Get current length of the leaderboard.
1468   function getLeaderboardLength()
1469     external view
1470     returns (uint256)
1471   {
1472     return leaderBoardPlayers.length;
1473   }
1474 
1475   // @dev Get recently played players.
1476   function getRecentPlayers()
1477     external view
1478     returns (address[])
1479   {
1480     return recentPlayers;
1481   }
1482 
1483   // @dev Get current number of players in the recently played players queue.
1484   function getRecentPlayersCount()
1485     public view
1486     returns (uint256) 
1487   {
1488     return recentPlayersBack - recentPlayersFront;
1489   }
1490 
1491   // @dev Constructor.
1492   function CryptoSagaArenaRecord(
1493     address _firstPlayerAddress,
1494     address _previousSeasonRecord,
1495     uint8 _numberOfLeaderboardPlayers, 
1496     uint8 _numberOfRecentPlayers)
1497     public
1498   {
1499 
1500     numberOfLeaderboardPlayers = _numberOfLeaderboardPlayers;
1501     numberOfRecentPlayers = _numberOfRecentPlayers;
1502 
1503     // The initial player gets into leaderboard.
1504     leaderBoardPlayers.push(_firstPlayerAddress);
1505     addressToIsInLeaderboard[_firstPlayerAddress] = true;
1506 
1507     // The initial player pushed into the recent players queue. 
1508     pushPlayer(_firstPlayerAddress);
1509     
1510     // The initial player's Elo.
1511     addressToElo[_firstPlayerAddress] = 1500;
1512 
1513     // Get instance of previous season.
1514     CryptoSagaArenaRecord _previous = CryptoSagaArenaRecord(_previousSeasonRecord);
1515 
1516     for (uint256 i = _previous.recentPlayersFront(); i < _previous.recentPlayersBack(); i++) {
1517       var _player = _previous.recentPlayers(i);
1518       // The initial player's Elo.
1519       addressToElo[_player] = _previous.getEloRating(_player);
1520     }
1521   }
1522 
1523   // @dev Update record.
1524   function updateRecord(address _myAddress, address _enemyAddress, bool _didWin)
1525     whenNotPaused onlyAccessDeploy
1526     public
1527   {
1528     address _winnerAddress = _didWin? _myAddress: _enemyAddress;
1529     address _loserAddress = _didWin? _enemyAddress: _myAddress;
1530     
1531     // Initial value of Elo.
1532     uint32 _winnerElo = addressToElo[_winnerAddress];
1533     if (_winnerElo == 0)
1534       _winnerElo = 1500;
1535     uint32 _loserElo = addressToElo[_loserAddress];
1536     if (_loserElo == 0)
1537       _loserElo = 1500;
1538 
1539     // Adjust Elo.
1540     if (_winnerElo >= _loserElo) {
1541       if (_winnerElo - _loserElo < 50) {
1542         addressToElo[_winnerAddress] = _winnerElo + 5;
1543         addressToElo[_loserAddress] = _loserElo - 5;
1544       } else if (_winnerElo - _loserElo < 80) {
1545         addressToElo[_winnerAddress] = _winnerElo + 4;
1546         addressToElo[_loserAddress] = _loserElo - 4;
1547       } else if (_winnerElo - _loserElo < 150) {
1548         addressToElo[_winnerAddress] = _winnerElo + 3;
1549         addressToElo[_loserAddress] = _loserElo - 3;
1550       } else if (_winnerElo - _loserElo < 250) {
1551         addressToElo[_winnerAddress] = _winnerElo + 2;
1552         addressToElo[_loserAddress] = _loserElo - 2;
1553       } else {
1554         addressToElo[_winnerAddress] = _winnerElo + 1;
1555         addressToElo[_loserAddress] = _loserElo - 1;
1556       }
1557     } else {
1558       if (_loserElo - _winnerElo < 50) {
1559         addressToElo[_winnerAddress] = _winnerElo + 5;
1560         addressToElo[_loserAddress] = _loserElo - 5;
1561       } else if (_loserElo - _winnerElo < 80) {
1562         addressToElo[_winnerAddress] = _winnerElo + 6;
1563         addressToElo[_loserAddress] = _loserElo - 6;
1564       } else if (_loserElo - _winnerElo < 150) {
1565         addressToElo[_winnerAddress] = _winnerElo + 7;
1566         addressToElo[_loserAddress] = _loserElo - 7;
1567       } else if (_loserElo - _winnerElo < 250) {
1568         addressToElo[_winnerAddress] = _winnerElo + 8;
1569         addressToElo[_loserAddress] = _loserElo - 8;
1570       } else {
1571         addressToElo[_winnerAddress] = _winnerElo + 9;
1572         addressToElo[_loserAddress] = _loserElo - 9;
1573       }
1574     }
1575 
1576     // Update recent players list.
1577     if (!isPlayerInQueue(_myAddress)) {
1578       
1579       // If the queue is full, pop a player.
1580       if (getRecentPlayersCount() >= numberOfRecentPlayers)
1581         popPlayer();
1582       
1583       // Push _myAddress to the queue.
1584       pushPlayer(_myAddress);
1585     }
1586 
1587     // Update leaderboards.
1588     if(updateLeaderboard(_enemyAddress) || updateLeaderboard(_myAddress))
1589     {
1590       UpdateLeaderboard(_myAddress, now);
1591     }
1592 
1593   }
1594 
1595   // @dev Update leaderboard.
1596   function updateLeaderboard(address _addressToUpdate)
1597     whenNotPaused
1598     private
1599     returns (bool isChanged)
1600   {
1601 
1602     // If this players is already in the leaderboard, there's no need for replace the minimum recorded player.
1603     if (addressToIsInLeaderboard[_addressToUpdate]) {
1604       // Do nothing.
1605     } else {
1606       if (leaderBoardPlayers.length >= numberOfLeaderboardPlayers) {
1607         
1608         // Need to replace existing player.
1609         // First, we need to find the player with miminum Elo value.
1610         uint32 _minimumElo = 99999;
1611         uint8 _minimumEloPlayerIndex = numberOfLeaderboardPlayers;
1612         for (uint8 i = 0; i < leaderBoardPlayers.length; i ++) {
1613           if (_minimumElo > addressToElo[leaderBoardPlayers[i]]) {
1614             _minimumElo = addressToElo[leaderBoardPlayers[i]];
1615             _minimumEloPlayerIndex = i;
1616           }
1617         }
1618 
1619         // Second, if the minimum elo value is smaller than the player's elo value, then replace the entity.
1620         if (_minimumElo <= addressToElo[_addressToUpdate]) {
1621           addressToIsInLeaderboard[leaderBoardPlayers[_minimumEloPlayerIndex]] = false;
1622           leaderBoardPlayers[_minimumEloPlayerIndex] = _addressToUpdate;
1623           addressToIsInLeaderboard[_addressToUpdate] = true;
1624           isChanged = true;
1625         }
1626       } else {
1627         // The list is not full yet. 
1628         // Just add the player to the list.
1629         leaderBoardPlayers.push(_addressToUpdate);
1630         addressToIsInLeaderboard[_addressToUpdate] = true;
1631         isChanged = true;
1632       }
1633     }
1634   }
1635 
1636   // #dev Check whether contain the element or not.
1637   function isPlayerInQueue(address _player)
1638     view private
1639     returns (bool isContain)
1640   {
1641     isContain = false;
1642     for (uint256 i = recentPlayersFront; i < recentPlayersBack; i++) {
1643       if (_player == recentPlayers[i]) {
1644         isContain = true;
1645       }
1646     }
1647   }
1648     
1649   // @dev Push a new player into the queue.
1650   function pushPlayer(address _player)
1651     private
1652   {
1653     recentPlayers.push(_player);
1654     recentPlayersBack++;
1655   }
1656     
1657   // @dev Pop the oldest player in this queue.
1658   function popPlayer() 
1659     private
1660     returns (address player)
1661   {
1662     if (recentPlayersBack == recentPlayersFront)
1663       return address(0);
1664     player = recentPlayers[recentPlayersFront];
1665     delete recentPlayers[recentPlayersFront];
1666     recentPlayersFront++;
1667   }
1668 
1669 }
1670 
1671 
1672 /**
1673  * @title CryptoSagaArenaVer1
1674  * @dev The actual gameplay is done by this contract. Version 1.0.2.
1675  */
1676 contract CryptoSagaArenaVer1 is Claimable, Pausable {
1677 
1678   struct PlayRecord {
1679     // This is needed for reconstructing the record.
1680     uint32 initialSeed;
1681     // The address of the enemy player.
1682     address enemyAddress;
1683     // Hero's token ids.
1684     uint256[8] tokenIds;
1685     // Unit's class ids. 0 ~ 3: Heroes. 4 ~ 7: Mobs.
1686     uint32[8] unitClassIds;
1687     // Unit's levels. 0 ~ 3: Heroes. 4 ~ 7: Mobs.
1688     uint32[8] unitLevels;
1689     // Exp reward given.
1690     uint32 expReward;
1691     // Gold Reward given.
1692     uint256 goldReward;
1693   }
1694 
1695   // This information can be reconstructed with seed and dateTime.
1696   // For the optimization this won't be really used.
1697   struct TurnInfo {
1698     // Number of turns before a team was vanquished.
1699     uint8 turnLength;
1700     // Turn order of units.
1701     uint8[8] turnOrder;
1702     // Defender list. (The unit that is attacked.)
1703     uint8[24] defenderList;
1704     // Damage list. (The damage given to the defender.)
1705     uint32[24] damageList;
1706     // Heroes' original Exps.
1707     uint32[4] originalExps;
1708   }
1709 
1710   // Progress contract.
1711   CryptoSagaArenaRecord public recordContract;
1712 
1713   // The hero contract.
1714   CryptoSagaHero public heroContract;
1715 
1716   // Corrected hero stats contract.
1717   CryptoSagaCorrectedHeroStats public correctedHeroContract;
1718 
1719   // Gold contract.
1720   Gold public goldContract;
1721 
1722   // Card contract.
1723   CryptoSagaCard public cardContract;
1724 
1725   // The location Id of this contract.
1726   // Will be used when calling deploy function of hero contract.
1727   uint32 public locationId = 100;
1728 
1729   // Hero cooldown time. (Default value: 60 mins.)
1730   uint256 public coolHero = 3600;
1731 
1732   // The exp reward for fighting in this arena.
1733   uint32 public expReward = 100;
1734 
1735   // The Gold reward when fighting in this arena.
1736   uint256 public goldReward = 1000000000000000000;
1737 
1738   // Should this contract save the turn data?
1739   bool public isTurnDataSaved = true;
1740 
1741   // Last game's record of the player.
1742   mapping(address => PlayRecord) public addressToPlayRecord;
1743 
1744   // Additional information on last game's record of the player.
1745   mapping(address => TurnInfo) public addressToTurnInfo;
1746 
1747   // Random seed.
1748   uint32 private seed = 0;
1749 
1750   // Event that is fired when a player fights in this arena.
1751   event TryArena(
1752     address indexed _by,
1753     address indexed _against,
1754     bool _didWin
1755   );
1756 
1757   // @dev Get previous game record.
1758   function getPlayRecord(address _address)
1759     external view
1760     returns (uint32, address, uint256[8], uint32[8], uint32[8], uint32, uint256, uint8, uint8[8], uint8[24], uint32[24])
1761   {
1762     PlayRecord memory _p = addressToPlayRecord[_address];
1763     TurnInfo memory _t = addressToTurnInfo[_address];
1764     return (
1765       _p.initialSeed,
1766       _p.enemyAddress,
1767       _p.tokenIds,
1768       _p.unitClassIds,
1769       _p.unitLevels,
1770       _p.expReward,
1771       _p.goldReward,
1772       _t.turnLength,
1773       _t.turnOrder,
1774       _t.defenderList,
1775       _t.damageList
1776     );
1777   }
1778 
1779   // @dev Get previous game record.
1780   function getPlayRecordNoTurnData(address _address)
1781     external view
1782     returns (uint32, address, uint256[8], uint32[8], uint32[8], uint32, uint256)
1783   {
1784     PlayRecord memory _p = addressToPlayRecord[_address];
1785     return (
1786       _p.initialSeed,
1787       _p.enemyAddress,
1788       _p.tokenIds,
1789       _p.unitClassIds,
1790       _p.unitLevels,
1791       _p.expReward,
1792       _p.goldReward
1793       );
1794   }
1795 
1796   // @dev Set location id.
1797   function setLocationId(uint32 _value)
1798     onlyOwner
1799     public
1800   {
1801     locationId = _value;
1802   }
1803 
1804   // @dev Set cooldown of heroes entered this arena.
1805   function setCoolHero(uint32 _value)
1806     onlyOwner
1807     public
1808   {
1809     coolHero = _value;
1810   }
1811 
1812   // @dev Set the Exp given to the player for fighting in this arena.
1813   function setExpReward(uint32 _value)
1814     onlyOwner
1815     public
1816   {
1817     expReward = _value;
1818   }
1819 
1820   // @dev Set the Golds given to the player for fighting in this arena.
1821   function setGoldReward(uint256 _value)
1822     onlyOwner
1823     public
1824   {
1825     goldReward = _value;
1826   }
1827 
1828   // @dev Set wether the turn data saved or not.
1829   function setIsTurnDataSaved(bool _value)
1830     onlyOwner
1831     public
1832   {
1833     isTurnDataSaved = _value;
1834   }
1835 
1836   // @dev Set Record Contract.
1837   function setRecordContract(address _address)
1838     onlyOwner
1839     public
1840   {
1841     recordContract = CryptoSagaArenaRecord(_address);
1842   }
1843 
1844   // @dev Constructor.
1845   function CryptoSagaArenaVer1(
1846     address _recordContractAddress,
1847     address _heroContractAddress,
1848     address _correctedHeroContractAddress,
1849     address _cardContractAddress,
1850     address _goldContractAddress,
1851     address _firstPlayerAddress,
1852     uint32 _locationId,
1853     uint256 _coolHero,
1854     uint32 _expReward,
1855     uint256 _goldReward,
1856     bool _isTurnDataSaved)
1857     public
1858   {
1859     recordContract = CryptoSagaArenaRecord(_recordContractAddress);
1860     heroContract = CryptoSagaHero(_heroContractAddress);
1861     correctedHeroContract = CryptoSagaCorrectedHeroStats(_correctedHeroContractAddress);
1862     cardContract = CryptoSagaCard(_cardContractAddress);
1863     goldContract = Gold(_goldContractAddress);
1864 
1865     // Save first player's record.
1866     // This is for preventing errors.
1867     PlayRecord memory _playRecord;
1868     _playRecord.initialSeed = seed;
1869     _playRecord.enemyAddress = _firstPlayerAddress;
1870     _playRecord.tokenIds[0] = 1;
1871     _playRecord.tokenIds[1] = 2;
1872     _playRecord.tokenIds[2] = 3;
1873     _playRecord.tokenIds[3] = 4;
1874     _playRecord.tokenIds[4] = 5;
1875     _playRecord.tokenIds[5] = 6;
1876     _playRecord.tokenIds[6] = 7;
1877     _playRecord.tokenIds[7] = 8;
1878     addressToPlayRecord[_firstPlayerAddress] = _playRecord;
1879     
1880     locationId = _locationId;
1881     coolHero = _coolHero;
1882     expReward = _expReward;
1883     goldReward = _goldReward;
1884     
1885     isTurnDataSaved = _isTurnDataSaved;
1886   }
1887   
1888   // @dev Enter this arena.
1889   function enterArena(uint256[4] _tokenIds, address _enemyAddress)
1890     whenNotPaused
1891     public
1892   {
1893 
1894     // Shouldn't fight against self.
1895     require(msg.sender != _enemyAddress);
1896 
1897     // Each hero should be with different ids.
1898     require(_tokenIds[0] == 0 || (_tokenIds[0] != _tokenIds[1] && _tokenIds[0] != _tokenIds[2] && _tokenIds[0] != _tokenIds[3]));
1899     require(_tokenIds[1] == 0 || (_tokenIds[1] != _tokenIds[0] && _tokenIds[1] != _tokenIds[2] && _tokenIds[1] != _tokenIds[3]));
1900     require(_tokenIds[2] == 0 || (_tokenIds[2] != _tokenIds[0] && _tokenIds[2] != _tokenIds[1] && _tokenIds[2] != _tokenIds[3]));
1901     require(_tokenIds[3] == 0 || (_tokenIds[3] != _tokenIds[0] && _tokenIds[3] != _tokenIds[1] && _tokenIds[3] != _tokenIds[2]));
1902 
1903     // Check ownership and availability of the heroes.
1904     require(checkOwnershipAndAvailability(msg.sender, _tokenIds));
1905 
1906     // The play record of the enemy should exist.
1907     // The check is done with the enemy's enemy address, because the default value of it will be address(0).
1908     require(addressToPlayRecord[_enemyAddress].enemyAddress != address(0));
1909 
1910     // Set seed.
1911     seed += uint32(now);
1912 
1913     // Define play record here.
1914     PlayRecord memory _playRecord;
1915     _playRecord.initialSeed = seed;
1916     _playRecord.enemyAddress = _enemyAddress;
1917     _playRecord.tokenIds[0] = _tokenIds[0];
1918     _playRecord.tokenIds[1] = _tokenIds[1];
1919     _playRecord.tokenIds[2] = _tokenIds[2];
1920     _playRecord.tokenIds[3] = _tokenIds[3];
1921 
1922     // The information that can give additional information.
1923     TurnInfo memory _turnInfo;
1924 
1925     // Step 1: Retrieve Hero information (0 ~ 3) & Enemy information (4 ~ 7).
1926 
1927     uint32[5][8] memory _unitStats; // Stats of units for given levels and class ids.
1928     uint8[2][8] memory _unitTypesAuras; // 0: Types of units for given levels and class ids. 1: Auras of units for given levels and class ids.
1929 
1930     // Retrieve deployed hero information.
1931     if (_tokenIds[0] != 0) {
1932       _playRecord.unitClassIds[0] = heroContract.getHeroClassId(_tokenIds[0]);
1933       (_playRecord.unitLevels[0], _turnInfo.originalExps[0], _unitStats[0], , ) = correctedHeroContract.getCorrectedStats(_tokenIds[0]);
1934       (, , , , _unitTypesAuras[0][0], , _unitTypesAuras[0][1], , , ) = heroContract.getClassInfo(_playRecord.unitClassIds[0]);
1935     }
1936     if (_tokenIds[1] != 0) {
1937       _playRecord.unitClassIds[1] = heroContract.getHeroClassId(_tokenIds[1]);
1938       (_playRecord.unitLevels[1], _turnInfo.originalExps[1], _unitStats[1], , ) = correctedHeroContract.getCorrectedStats(_tokenIds[1]);
1939       (, , , , _unitTypesAuras[1][0], , _unitTypesAuras[1][1], , , ) = heroContract.getClassInfo(_playRecord.unitClassIds[1]);
1940     }
1941     if (_tokenIds[2] != 0) {
1942       _playRecord.unitClassIds[2] = heroContract.getHeroClassId(_tokenIds[2]);
1943       (_playRecord.unitLevels[2], _turnInfo.originalExps[2], _unitStats[2], , ) = correctedHeroContract.getCorrectedStats(_tokenIds[2]);
1944       (, , , , _unitTypesAuras[2][0], , _unitTypesAuras[2][1], , , ) = heroContract.getClassInfo(_playRecord.unitClassIds[2]);
1945     }
1946     if (_tokenIds[3] != 0) {
1947       _playRecord.unitClassIds[3] = heroContract.getHeroClassId(_tokenIds[3]);
1948       (_playRecord.unitLevels[3], _turnInfo.originalExps[3], _unitStats[3], , ) = correctedHeroContract.getCorrectedStats(_tokenIds[3]);
1949       (, , , , _unitTypesAuras[3][0], , _unitTypesAuras[3][1], , , ) = heroContract.getClassInfo(_playRecord.unitClassIds[3]);
1950     }
1951 
1952     // Retrieve enemy information.
1953     PlayRecord memory _enemyPlayRecord = addressToPlayRecord[_enemyAddress];
1954     if (_enemyPlayRecord.tokenIds[0] != 0) {
1955       _playRecord.unitClassIds[4] = heroContract.getHeroClassId(_enemyPlayRecord.tokenIds[0]);
1956       (_playRecord.unitLevels[4], , _unitStats[4], , ) = correctedHeroContract.getCorrectedStats(_enemyPlayRecord.tokenIds[0]);
1957       (, , , , _unitTypesAuras[4][0], , _unitTypesAuras[4][1], , , ) = heroContract.getClassInfo(_playRecord.unitClassIds[4]);
1958     }
1959     if (_enemyPlayRecord.tokenIds[1] != 0) {
1960       _playRecord.unitClassIds[5] = heroContract.getHeroClassId(_enemyPlayRecord.tokenIds[1]);
1961       (_playRecord.unitLevels[5], , _unitStats[5], , ) = correctedHeroContract.getCorrectedStats(_enemyPlayRecord.tokenIds[1]);
1962       (, , , , _unitTypesAuras[5][0], , _unitTypesAuras[5][1], , , ) = heroContract.getClassInfo(_playRecord.unitClassIds[5]);
1963     }
1964     if (_enemyPlayRecord.tokenIds[2] != 0) {
1965       _playRecord.unitClassIds[6] = heroContract.getHeroClassId(_enemyPlayRecord.tokenIds[2]);
1966       (_playRecord.unitLevels[6], , _unitStats[6], , ) = correctedHeroContract.getCorrectedStats(_enemyPlayRecord.tokenIds[2]);
1967       (, , , , _unitTypesAuras[6][0], , _unitTypesAuras[6][1], , , ) = heroContract.getClassInfo(_playRecord.unitClassIds[6]);
1968     }
1969     if (_enemyPlayRecord.tokenIds[3] != 0) {
1970       _playRecord.unitClassIds[7] = heroContract.getHeroClassId(_enemyPlayRecord.tokenIds[3]);
1971       (_playRecord.unitLevels[7], , _unitStats[7], , ) = correctedHeroContract.getCorrectedStats(_enemyPlayRecord.tokenIds[3]);
1972       (, , , , _unitTypesAuras[7][0], , _unitTypesAuras[7][1], , , ) = heroContract.getClassInfo(_playRecord.unitClassIds[7]);
1973     }
1974 
1975     // Additional token ids for enemies.
1976     // Unlike dungeons, arena needs IVs for the enemy heroes.
1977     _playRecord.tokenIds[4] = _enemyPlayRecord.tokenIds[0];
1978     _playRecord.tokenIds[5] = _enemyPlayRecord.tokenIds[1];
1979     _playRecord.tokenIds[6] = _enemyPlayRecord.tokenIds[2];
1980     _playRecord.tokenIds[7] = _enemyPlayRecord.tokenIds[3];
1981 
1982     // Step 2. Run the battle logic.
1983     
1984     // Firstly, we need to assign the unit's turn order with AGLs of the units.
1985     uint32[8] memory _unitAGLs;
1986     for (uint8 i = 0; i < 8; i ++) {
1987       _unitAGLs[i] = _unitStats[i][2];
1988     }
1989     _turnInfo.turnOrder = getOrder(_unitAGLs);
1990     
1991     // Fight for 24 turns. (8 units x 3 rounds.)
1992     _turnInfo.turnLength = 24;
1993     for (i = 0; i < 24; i ++) {
1994       if (_unitStats[4][4] == 0 && _unitStats[5][4] == 0 && _unitStats[6][4] == 0 && _unitStats[7][4] == 0) {
1995         _turnInfo.turnLength = i;
1996         break;
1997       } else if (_unitStats[0][4] == 0 && _unitStats[1][4] == 0 && _unitStats[2][4] == 0 && _unitStats[3][4] == 0) {
1998         _turnInfo.turnLength = i;
1999         break;
2000       }
2001       
2002       var _slotId = _turnInfo.turnOrder[(i % 8)];
2003       if (_slotId < 4 && _tokenIds[_slotId] == 0) {
2004         // This means the slot is empty.
2005         // Defender should be default value.
2006         _turnInfo.defenderList[i] = 127;
2007       } else if (_unitStats[_slotId][4] == 0) {
2008         // This means the unit on this slot is dead.
2009         // Defender should be default value.
2010         _turnInfo.defenderList[i] = 128;
2011       } else {
2012         // 1) Check number of attack targets that are alive.
2013         uint8 _targetSlotId = 255;
2014         if (_slotId < 4) {
2015           if (_unitStats[4][4] > 0)
2016             _targetSlotId = 4;
2017           else if (_unitStats[5][4] > 0)
2018             _targetSlotId = 5;
2019           else if (_unitStats[6][4] > 0)
2020             _targetSlotId = 6;
2021           else if (_unitStats[7][4] > 0)
2022             _targetSlotId = 7;
2023         } else {
2024           if (_unitStats[0][4] > 0)
2025             _targetSlotId = 0;
2026           else if (_unitStats[1][4] > 0)
2027             _targetSlotId = 1;
2028           else if (_unitStats[2][4] > 0)
2029             _targetSlotId = 2;
2030           else if (_unitStats[3][4] > 0)
2031             _targetSlotId = 3;
2032         }
2033         
2034         // Target is the defender.
2035         _turnInfo.defenderList[i] = _targetSlotId;
2036         
2037         // Base damage. (Attacker's ATK * 1.5 - Defender's DEF).
2038         uint32 _damage = 10;
2039         if ((_unitStats[_slotId][0] * 150 / 100) > _unitStats[_targetSlotId][1])
2040           _damage = max((_unitStats[_slotId][0] * 150 / 100) - _unitStats[_targetSlotId][1], 10);
2041         else
2042           _damage = 10;
2043 
2044         // Check miss / success.
2045         if ((_unitStats[_slotId][3] * 150 / 100) > _unitStats[_targetSlotId][2]) {
2046           if (min(max(((_unitStats[_slotId][3] * 150 / 100) - _unitStats[_targetSlotId][2]), 75), 99) <= random(100, 0))
2047             _damage = _damage * 0;
2048         }
2049         else {
2050           if (75 <= random(100, 0))
2051             _damage = _damage * 0;
2052         }
2053 
2054         // Is the attack critical?
2055         if (_unitStats[_slotId][3] > _unitStats[_targetSlotId][3]) {
2056           if (min(max((_unitStats[_slotId][3] - _unitStats[_targetSlotId][3]), 5), 75) > random(100, 0))
2057             _damage = _damage * 150 / 100;
2058         }
2059         else {
2060           if (5 > random(100, 0))
2061             _damage = _damage * 150 / 100;
2062         }
2063 
2064         // Is attacker has the advantageous Type?
2065         if (_unitTypesAuras[_slotId][0] == 0 && _unitTypesAuras[_targetSlotId][0] == 1) // Fighter > Rogue
2066           _damage = _damage * 125 / 100;
2067         else if (_unitTypesAuras[_slotId][0] == 1 && _unitTypesAuras[_targetSlotId][0] == 2) // Rogue > Mage
2068           _damage = _damage * 125 / 100;
2069         else if (_unitTypesAuras[_slotId][0] == 2 && _unitTypesAuras[_targetSlotId][0] == 0) // Mage > Fighter
2070           _damage = _damage * 125 / 100;
2071 
2072         // Is attacker has the advantageous Aura?
2073         if (_unitTypesAuras[_slotId][1] == 0 && _unitTypesAuras[_targetSlotId][1] == 1) // Water > Fire
2074           _damage = _damage * 150 / 100;
2075         else if (_unitTypesAuras[_slotId][1] == 1 && _unitTypesAuras[_targetSlotId][1] == 2) // Fire > Nature
2076           _damage = _damage * 150 / 100;
2077         else if (_unitTypesAuras[_slotId][1] == 2 && _unitTypesAuras[_targetSlotId][1] == 0) // Nature > Water
2078           _damage = _damage * 150 / 100;
2079         else if (_unitTypesAuras[_slotId][1] == 3 && _unitTypesAuras[_targetSlotId][1] == 4) // Light > Darkness
2080           _damage = _damage * 150 / 100;
2081         else if (_unitTypesAuras[_slotId][1] == 4 && _unitTypesAuras[_targetSlotId][1] == 3) // Darkness > Light
2082           _damage = _damage * 150 / 100;
2083         
2084         // Apply damage so that reduce hp of defender.
2085         if(_unitStats[_targetSlotId][4] > _damage)
2086           _unitStats[_targetSlotId][4] -= _damage;
2087         else
2088           _unitStats[_targetSlotId][4] = 0;
2089 
2090         // Save damage to play record.
2091         _turnInfo.damageList[i] = _damage;
2092       }
2093     }
2094     
2095     // Step 3. Apply the result of this battle.
2096 
2097     // Set heroes deployed.
2098     if (_tokenIds[0] != 0)
2099       heroContract.deploy(_tokenIds[0], locationId, coolHero);
2100     if (_tokenIds[1] != 0)
2101       heroContract.deploy(_tokenIds[1], locationId, coolHero);
2102     if (_tokenIds[2] != 0)
2103       heroContract.deploy(_tokenIds[2], locationId, coolHero);
2104     if (_tokenIds[3] != 0)
2105       heroContract.deploy(_tokenIds[3], locationId, coolHero);
2106 
2107     uint8 _deadHeroes = 0;
2108     uint8 _deadEnemies = 0;
2109 
2110     // Check result.
2111     if (_unitStats[0][4] == 0)
2112       _deadHeroes ++;
2113     if (_unitStats[1][4] == 0)
2114       _deadHeroes ++;
2115     if (_unitStats[2][4] == 0)
2116       _deadHeroes ++;
2117     if (_unitStats[3][4] == 0)
2118       _deadHeroes ++;
2119     if (_unitStats[4][4] == 0)
2120       _deadEnemies ++;
2121     if (_unitStats[5][4] == 0)
2122       _deadEnemies ++;
2123     if (_unitStats[6][4] == 0)
2124       _deadEnemies ++;
2125     if (_unitStats[7][4] == 0)
2126       _deadEnemies ++;
2127       
2128     if (_deadEnemies > _deadHeroes) { // Win
2129       // Fire TryArena event.
2130       TryArena(msg.sender, _enemyAddress, true);
2131       
2132       // Give reward.
2133       (_playRecord.expReward, _playRecord.goldReward) = giveReward(_tokenIds, true, _turnInfo.originalExps);
2134 
2135       // Save the record.
2136       recordContract.updateRecord(msg.sender, _enemyAddress, true);
2137     }
2138     else if (_deadEnemies < _deadHeroes) { // Lose
2139       // Fire TryArena event.
2140       TryArena(msg.sender, _enemyAddress, false);
2141 
2142       // Rewards.
2143       (_playRecord.expReward, _playRecord.goldReward) = giveReward(_tokenIds, false, _turnInfo.originalExps);
2144 
2145       // Save the record.
2146       recordContract.updateRecord(msg.sender, _enemyAddress, false);
2147     }
2148     else { // Draw
2149       // Fire TryArena event.
2150       TryArena(msg.sender, _enemyAddress, false);
2151 
2152       // Rewards.
2153       (_playRecord.expReward, _playRecord.goldReward) = giveReward(_tokenIds, false, _turnInfo.originalExps);
2154     }
2155 
2156     // Save the result of this gameplay.
2157     addressToPlayRecord[msg.sender] = _playRecord;
2158 
2159     // Save the turn data.
2160     // This is commented as this information can be reconstructed with intitial seed and date time.
2161     // By commenting this, we can reduce about 400k gas.
2162     if (isTurnDataSaved) {
2163       addressToTurnInfo[msg.sender] = _turnInfo;
2164     }
2165   }
2166 
2167   // @dev Check ownership.
2168   function checkOwnershipAndAvailability(address _playerAddress, uint256[4] _tokenIds)
2169     private view
2170     returns(bool)
2171   {
2172     if ((_tokenIds[0] == 0 || heroContract.ownerOf(_tokenIds[0]) == _playerAddress) && (_tokenIds[1] == 0 || heroContract.ownerOf(_tokenIds[1]) == _playerAddress) && (_tokenIds[2] == 0 || heroContract.ownerOf(_tokenIds[2]) == _playerAddress) && (_tokenIds[3] == 0 || heroContract.ownerOf(_tokenIds[3]) == _playerAddress)) {
2173       
2174       // Retrieve avail time of heroes.
2175       uint256[4] memory _heroAvailAts;
2176       if (_tokenIds[0] != 0)
2177         ( , , , , , _heroAvailAts[0], , , ) = heroContract.getHeroInfo(_tokenIds[0]);
2178       if (_tokenIds[1] != 0)
2179         ( , , , , , _heroAvailAts[1], , , ) = heroContract.getHeroInfo(_tokenIds[1]);
2180       if (_tokenIds[2] != 0)
2181         ( , , , , , _heroAvailAts[2], , , ) = heroContract.getHeroInfo(_tokenIds[2]);
2182       if (_tokenIds[3] != 0)
2183         ( , , , , , _heroAvailAts[3], , , ) = heroContract.getHeroInfo(_tokenIds[3]);
2184 
2185       if (_heroAvailAts[0] <= now && _heroAvailAts[1] <= now && _heroAvailAts[2] <= now && _heroAvailAts[3] <= now) {
2186         return true;
2187       } else {
2188         return false;
2189       }
2190     } else {
2191       return false;
2192     }
2193   }
2194 
2195   // @dev Give rewards.
2196   function giveReward(uint256[4] _heroes, bool _didWin, uint32[4] _originalExps)
2197     private
2198     returns (uint32 expRewardGiven, uint256 goldRewardGiven)
2199   {
2200     if (!_didWin) {
2201       // In case lost.
2202       // Give baseline gold reward.
2203       goldRewardGiven = goldReward / 10;
2204       expRewardGiven = expReward / 5;
2205     } else {
2206       // In case win.
2207       goldRewardGiven = goldReward;
2208       expRewardGiven = expReward;
2209     }
2210 
2211     // Give reward Gold.
2212     goldContract.mint(msg.sender, goldRewardGiven);
2213     
2214     // Give reward EXP.
2215     if(_heroes[0] != 0)
2216       heroContract.addExp(_heroes[0], uint32(2)**32 - _originalExps[0] + expRewardGiven);
2217     if(_heroes[1] != 0)
2218       heroContract.addExp(_heroes[1], uint32(2)**32 - _originalExps[1] + expRewardGiven);
2219     if(_heroes[2] != 0)
2220       heroContract.addExp(_heroes[2], uint32(2)**32 - _originalExps[2] + expRewardGiven);
2221     if(_heroes[3] != 0)
2222       heroContract.addExp(_heroes[3], uint32(2)**32 - _originalExps[3] + expRewardGiven);
2223   }
2224 
2225   // @dev Return a pseudo random number between lower and upper bounds
2226   function random(uint32 _upper, uint32 _lower)
2227     private
2228     returns (uint32)
2229   {
2230     require(_upper > _lower);
2231 
2232     seed = seed % uint32(1103515245) + 12345;
2233     return seed % (_upper - _lower) + _lower;
2234   }
2235 
2236   // @dev Retreive order based on given array _by.
2237   function getOrder(uint32[8] _by)
2238     private pure
2239     returns (uint8[8])
2240   {
2241     uint8[8] memory _order = [uint8(0), 1, 2, 3, 4, 5, 6, 7];
2242     for (uint8 i = 0; i < 8; i ++) {
2243       for (uint8 j = i + 1; j < 8; j++) {
2244         if (_by[i] < _by[j]) {
2245           uint32 tmp1 = _by[i];
2246           _by[i] = _by[j];
2247           _by[j] = tmp1;
2248           uint8 tmp2 = _order[i];
2249           _order[i] = _order[j];
2250           _order[j] = tmp2;
2251         }
2252       }
2253     }
2254     return _order;
2255   }
2256 
2257   // @return Bigger value of two uint32s.
2258   function max(uint32 _value1, uint32 _value2)
2259     private pure
2260     returns (uint32)
2261   {
2262     if(_value1 >= _value2)
2263       return _value1;
2264     else
2265       return _value2;
2266   }
2267 
2268   // @return Bigger value of two uint32s.
2269   function min(uint32 _value1, uint32 _value2)
2270     private pure
2271     returns (uint32)
2272   {
2273     if(_value2 >= _value1)
2274       return _value1;
2275     else
2276       return _value2;
2277   }
2278 
2279   // @return Square root of the given value.
2280   function sqrt(uint32 _value) 
2281     private pure
2282     returns (uint32) 
2283   {
2284     uint32 z = (_value + 1) / 2;
2285     uint32 y = _value;
2286     while (z < y) {
2287       y = z;
2288       z = (_value / z + z) / 2;
2289     }
2290     return y;
2291   }
2292 
2293 }
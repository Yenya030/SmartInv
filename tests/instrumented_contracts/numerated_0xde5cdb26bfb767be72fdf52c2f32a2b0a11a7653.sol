1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61   event OwnershipTransferred(
62     address previousOwner,
63     address newOwner
64   );
65 
66   /**
67    * @dev Throws if called by any account other than the owner.
68    */
69   modifier onlyOwner() {
70     require(msg.sender == owner || msg.sender == address(this));
71     _;
72   }
73 
74   /**
75    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
76    * account.
77    */
78   constructor() public {
79     owner = msg.sender;
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param _newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address _newOwner) public onlyOwner {
87     _transferOwnership(_newOwner);
88   }
89 
90   /**
91    * @dev Transfers control of the contract to a newOwner.
92    * @param _newOwner The address to transfer ownership to.
93    */
94   function _transferOwnership(address _newOwner) internal {
95     require(_newOwner != address(0));
96     emit OwnershipTransferred(owner, _newOwner);
97     owner = _newOwner;
98   }
99 }
100 
101 /**
102  * @title Pausable
103  * @dev Base contract which allows children to implement an emergency stop mechanism.
104  */
105 contract Pausable is Ownable {
106   event Pause(bool isPause);
107 
108   bool public paused = false;
109 
110 
111   /**
112    * @dev Modifier to make a function callable only when the contract is not paused.
113    */
114   modifier whenNotPaused() {
115     require(!paused);
116     _;
117   }
118 
119   /**
120    * @dev Modifier to make a function callable only when the contract is paused.
121    */
122   modifier whenPaused() {
123     require(paused);
124     _;
125   }
126 
127   /**
128    * @dev called by the owner to pause, triggers stopped state
129    */
130   function pause() onlyOwner whenNotPaused public {
131     paused = true;
132     emit Pause(paused);
133   }
134 
135   /**
136    * @dev called by the owner to unpause, returns to normal state
137    */
138   function unpause() onlyOwner whenPaused public {
139     paused = false;
140     emit Pause(paused);
141   }
142 }
143 
144 /**
145  * @title ERC20Basic
146  * @dev Simpler version of ERC20 interface
147  * See https://github.com/ethereum/EIPs/issues/179
148  */
149 contract ERC20Basic {
150   function totalSupply() public view returns (uint256);
151   function balanceOf(address who) public view returns (uint256);
152   function transfer(address to, uint256 value) public returns (bool);
153   event Transfer(address indexed from, address indexed to, uint256 value);
154 }
155 
156 /**
157  * @title ERC20 interface
158  * @dev see https://github.com/ethereum/EIPs/issues/20
159  */
160 contract ERC20 is ERC20Basic {
161   function allowance(address owner, address spender)
162     public view returns (uint256);
163 
164   function transferFrom(address from, address to, uint256 value)
165     public returns (bool);
166 
167   function approve(address spender, uint256 value) public returns (bool);
168   event Approval(
169     address indexed owner,
170     address indexed spender,
171     uint256 value
172   );
173 }
174 
175 /**
176  * @title Basic token
177  * @dev Basic version of StandardToken, with no allowances.
178  */
179 contract BasicToken is ERC20Basic, Pausable {
180   using SafeMath for uint256;
181 
182   mapping(address => uint256) balances;
183   uint256 totalSupply_;
184   address public altTokenFundAddress;
185   address public setPriceAccount;
186   address public setReferralAccount;
187   uint256 public tokenPrice;
188   uint256 public managersFee;
189   uint256 public referralFee;
190   uint256 public supportFee;
191   uint256 public withdrawFee;
192 
193   address public ethAddress;
194   address public supportWallet;
195   address public fundManagers;
196   bool public lock;
197   event Deposit(address indexed buyer, uint256 weiAmount, uint256 tokensAmount, uint256 tokenPrice, uint256 commission);
198   event Withdraw(address indexed buyer, uint256 weiAmount, uint256 tokensAmount, uint256 tokenPrice, uint256 commission);
199 
200 
201   /**
202   * @dev Total number of tokens in existence
203   */
204   function totalSupply() public view returns (uint256) {
205     return totalSupply_;
206   }
207 
208   /**
209   * @dev Transfer token for a specified address
210   * @param _to The address to transfer to.
211   * @param _value The amount to be transferred.
212   */
213   function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
214     require(_to != address(0));
215     require(_value <= balances[msg.sender]);
216 
217     if (_to == altTokenFundAddress) {
218       require(!lock);
219       uint256 weiAmount = _value.mul(uint256(100).sub(withdrawFee)).div(100).mul(tokenPrice).div(uint256(1000000000000000000));
220       uint256 feeAmount = _value.mul(withdrawFee).div(100);
221 
222       totalSupply_ = totalSupply_.sub(_value-feeAmount);
223       balances[fundManagers] = balances[fundManagers].add(feeAmount);
224       emit Transfer(address(this), fundManagers, feeAmount);
225       emit Withdraw(msg.sender, weiAmount, _value, tokenPrice, feeAmount);
226     } else {
227       balances[_to] = balances[_to].add(_value);
228     }
229 
230     balances[msg.sender] = balances[msg.sender].sub(_value);
231     emit Transfer(msg.sender, _to, _value);
232     return true;
233   }
234 
235   /**
236   * @dev Gets the balance of the specified address.
237   * @param _owner The address to query the the balance of.
238   * @return An uint256 representing the amount owned by the passed address.
239   */
240   function balanceOf(address _owner) public view returns (uint256) {
241     uint256 availableTokens = balances[_owner];
242     return availableTokens;
243   }
244 }
245 
246 /**
247  * @title Standard ERC20 token
248  *
249  * @dev Implementation of the basic standard token.
250  * https://github.com/ethereum/EIPs/issues/20
251  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
252  */
253 contract StandardToken is ERC20, BasicToken {
254   mapping (address => mapping (address => uint256)) internal allowed;
255 
256   /**
257    * @dev Transfer tokens from one address to another
258    * @param _from address The address which you want to send tokens from
259    * @param _to address The address which you want to transfer to
260    * @param _value uint256 the amount of tokens to be transferred
261    */
262   function transferFrom(
263     address _from,
264     address _to,
265     uint256 _value
266   )
267     public
268     whenNotPaused
269     returns (bool)
270   {
271     require(_to != address(0));
272     require(_value <= balances[_from]);
273     require(_value <= allowed[_from][msg.sender]);
274 
275     if (_to == altTokenFundAddress) {
276       require(!lock);
277       uint256 weiAmount = _value.mul(uint256(100).sub(withdrawFee)).div(100).mul(tokenPrice).div(uint256(1000000000000000000));
278       uint256 feeAmount = _value.mul(withdrawFee).div(100);
279 
280       totalSupply_ = totalSupply_.sub(_value-feeAmount);
281       balances[fundManagers] = balances[fundManagers].add(feeAmount);
282       emit Transfer(address(this), fundManagers, feeAmount);
283       emit Withdraw(msg.sender, weiAmount, _value, tokenPrice, withdrawFee);
284     } else {
285       balances[_to] = balances[_to].add(_value);
286     }
287 
288     balances[_from] = balances[_from].sub(_value);
289     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
290     emit Transfer(_from, _to, _value);
291     return true;
292   }
293 
294   /**
295    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
296    * Beware that changing an allowance with this method brings the risk that someone may use both the old
297    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
298    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
299    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
300    * @param _spender The address which will spend the funds.
301    * @param _value The amount of tokens to be spent.
302    */
303   function approve(address _spender, uint256 _value) public returns (bool) {
304     allowed[msg.sender][_spender] = _value;
305     emit Approval(msg.sender, _spender, _value);
306     return true;
307   }
308 
309   /**
310    * @dev Function to check the amount of tokens that an owner allowed to a spender.
311    * @param _owner address The address which owns the funds.
312    * @param _spender address The address which will spend the funds.
313    * @return A uint256 specifying the amount of tokens still available for the spender.
314    */
315   function allowance(
316     address _owner,
317     address _spender
318    )
319     public
320     view
321     returns (uint256)
322   {
323     return allowed[_owner][_spender];
324   }
325 
326   /**
327    * @dev Increase the amount of tokens that an owner allowed to a spender.
328    * approve should be called when allowed[_spender] == 0. To increment
329    * allowed value is better to use this function to avoid 2 calls (and wait until
330    * the first transaction is mined)
331    * From MonolithDAO Token.sol
332    * @param _spender The address which will spend the funds.
333    * @param _addedValue The amount of tokens to increase the allowance by.
334    */
335   function increaseApproval(
336     address _spender,
337     uint256 _addedValue
338   )
339     public
340     returns (bool)
341   {
342     allowed[msg.sender][_spender] = (
343       allowed[msg.sender][_spender].add(_addedValue));
344     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
345     return true;
346   }
347 
348   /**
349    * @dev Decrease the amount of tokens that an owner allowed to a spender.
350    * approve should be called when allowed[_spender] == 0. To decrement
351    * allowed value is better to use this function to avoid 2 calls (and wait until
352    * the first transaction is mined)
353    * From MonolithDAO Token.sol
354    * @param _spender The address which will spend the funds.
355    * @param _subtractedValue The amount of tokens to decrease the allowance by.
356    */
357   function decreaseApproval(
358     address _spender,
359     uint256 _subtractedValue
360   )
361     public
362     returns (bool)
363   {
364     uint256 oldValue = allowed[msg.sender][_spender];
365     if (_subtractedValue > oldValue) {
366       allowed[msg.sender][_spender] = 0;
367     } else {
368       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
369     }
370     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
371     return true;
372   }
373 }
374 
375 contract AltTokenFundToken is StandardToken {
376 
377   string constant public name = "Alt Token Fund Token";
378   uint256 constant public decimals = 18;
379   string constant public symbol = "ATF";
380   mapping (address => address) public referrals;
381 
382   event Lock(bool lockStatus);
383   event NewTokenPrice(uint256 tokenPrice);
384   event AddTokens(address indexed user, uint256 tokensAmount, uint256 _price);
385 
386   event SupportFee(uint256 supportFee);
387   event ManagersFee(uint256 managersFee);
388   event ReferralFee(uint256 referralFee);
389   event WithdrawFee(uint256 withdrawFee);
390 
391   event NewEthAddress(address ethAddress);
392   event NewFundManagers(address fundManagers);
393   event NewSupportWallet (address supportWallet);
394   event NewSetPriceAccount (address setPriceAccount);
395   event NewSetRefferalAccount (address referral);
396 
397   constructor() public {
398     altTokenFundAddress = address(this);
399     //setTokenPrice(33333);
400     tokenPrice = 5041877658000000;
401     lockUp(false);
402     newManagersFee(1);
403     newSupportFee(1);
404     newReferralFee(3);
405     newWithdrawFee(5);
406     newEthAddress(0x8C5dA48233D4CC180c8f62617D4eF39040Bb2E2d);
407     newFundManagers(0x3FacdA7A379F8bB21F2aAfDDc8fbe7231B538746);
408     newSupportWallet(0x8C5dA48233D4CC180c8f62617D4eF39040Bb2E2d);
409     newPriceAccount(0x9c8B73EB8B2668654e204E6B8292DE2Fc8DA2135);
410     newReferralAccount(0x9c8B73EB8B2668654e204E6B8292DE2Fc8DA2135);
411     
412   }
413 
414   //Modifiers
415   modifier onlySetPriceAccount {
416       if (msg.sender != setPriceAccount) revert();
417       _;
418   }
419 
420   modifier onlySetReferralAccount {
421       if (msg.sender != setReferralAccount) revert();
422       _;
423   }
424 
425   function priceOf() external view returns(uint256) {
426     return tokenPrice;
427   }
428 
429   function () payable external whenNotPaused {
430     uint depositFee = managersFee.add(referralFee).add(supportFee);
431     uint256 tokens = msg.value.mul(uint256(1000000000000000000)).mul(100-depositFee).div(uint256(100)).div(tokenPrice);
432 
433 
434     totalSupply_ = totalSupply_.add(tokens);
435     balances[msg.sender] = balances[msg.sender].add(tokens);
436 
437     fundManagers.transfer(msg.value.mul(managersFee).div(100));
438     supportWallet.transfer(msg.value.mul(supportFee).div(100));
439     if (referrals[msg.sender]!=0){
440         referrals[msg.sender].transfer(msg.value.mul(referralFee).div(100));
441     }
442     else {
443         supportWallet.transfer(msg.value.mul(referralFee).div(100));
444     }
445     
446     ethAddress.transfer(msg.value.mul(uint256(100).sub(depositFee)).div(100));
447     emit Transfer(altTokenFundAddress, msg.sender, tokens);
448     emit Deposit(msg.sender, msg.value, tokens, tokenPrice, depositFee);
449   }
450 
451 
452   function airdrop(address[] receiver, uint256[] amount) external onlyOwner {
453     require(receiver.length > 0 && receiver.length == amount.length);
454 
455     for(uint256 i = 0; i < receiver.length; i++) {
456       uint256 tokens = amount[i];
457       totalSupply_ = totalSupply_.add(tokens);
458       balances[receiver[i]] = balances[receiver[i]].add(tokens);
459       emit Transfer(address(this), receiver[i], tokens);
460       emit AddTokens(receiver[i], tokens, tokenPrice);
461     }
462   }
463 
464   function setTokenPrice(uint256 _tokenPrice) public onlySetPriceAccount {
465     tokenPrice = _tokenPrice;
466     emit NewTokenPrice(tokenPrice);
467   }
468   
469   function setReferral(address client, address referral)
470         public
471         onlySetReferralAccount
472     {
473         referrals[client] = referral;
474     }
475 
476   function getReferral(address client)
477         public
478         constant
479         returns (address)
480     {
481         return referrals[client];
482     }
483 
484     function estimateTokens(uint256 valueInWei)
485         public
486         constant
487         returns (uint256)
488     {
489         uint256 depositFee = managersFee.add(referralFee).add(supportFee);
490         return valueInWei.mul(uint256(1000000000000000000)).mul(100-depositFee).div(uint256(100)).div(tokenPrice);
491     }
492     
493     function estimateEthers(uint256 tokenCount)
494         public
495         constant
496         returns (uint256)
497     {
498         uint256 weiAmount = tokenCount.mul(uint256(100).sub(withdrawFee)).div(100).mul(tokenPrice).div(uint256(1000000000000000000));
499         return weiAmount;
500     }
501 
502   function newSupportFee(uint256 _supportFee) public onlyOwner {
503     supportFee = _supportFee;
504     emit SupportFee(supportFee);
505   }
506 
507   function newManagersFee(uint256 _managersFee) public onlyOwner {
508     managersFee = _managersFee;
509     emit ManagersFee(managersFee);
510   }
511 
512   function newReferralFee(uint256 _referralFee) public onlyOwner {
513     referralFee = _referralFee;
514     emit ReferralFee(referralFee);
515   }
516 
517   function newWithdrawFee(uint256 _newWithdrawFee) public onlyOwner {
518     withdrawFee = _newWithdrawFee;
519     emit WithdrawFee(withdrawFee);
520   }
521 
522   function newEthAddress(address _ethAddress) public onlyOwner {
523     ethAddress = _ethAddress;
524     emit NewEthAddress(ethAddress);
525   }
526 
527   function newFundManagers(address _fundManagers) public onlyOwner {
528     fundManagers = _fundManagers;
529     emit NewFundManagers(fundManagers);
530   }
531   
532   function newSupportWallet(address _supportWallet) public onlyOwner {
533     supportWallet = _supportWallet;
534     emit NewSupportWallet(supportWallet);
535   }
536   
537   function newPriceAccount(address _setPriceAccount) public onlyOwner {
538     setPriceAccount = _setPriceAccount;
539     emit NewSetPriceAccount(setPriceAccount);
540   }
541   
542   function newReferralAccount(address _setReferralAccount) public onlyOwner {
543     setReferralAccount = _setReferralAccount;
544     emit NewSetRefferalAccount(setReferralAccount);
545   }
546 
547   function lockUp(bool _lock) public onlyOwner {
548     lock = _lock;
549     emit Lock(lock);
550   }
551 }
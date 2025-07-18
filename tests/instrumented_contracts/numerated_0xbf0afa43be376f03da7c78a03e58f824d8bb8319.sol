1 pragma solidity ^0.4.18;
2 
3 // File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69 
70   /**
71    * @dev Allows the current owner to transfer control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function transferOwnership(address newOwner) public onlyOwner {
75     require(newOwner != address(0));
76     OwnershipTransferred(owner, newOwner);
77     owner = newOwner;
78   }
79 
80 }
81 
82 // File: node_modules/zeppelin-solidity/contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: node_modules/zeppelin-solidity/contracts/token/BasicToken.sol
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[msg.sender]);
115 
116     // SafeMath.sub will throw if there is not enough balance.
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 // File: node_modules/zeppelin-solidity/contracts/token/ERC20.sol
135 
136 /**
137  * @title ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/20
139  */
140 contract ERC20 is ERC20Basic {
141   function allowance(address owner, address spender) public view returns (uint256);
142   function transferFrom(address from, address to, uint256 value) public returns (bool);
143   function approve(address spender, uint256 value) public returns (bool);
144   event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 // File: node_modules/zeppelin-solidity/contracts/token/StandardToken.sol
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint256 the amount of tokens to be transferred
166    */
167   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    *
182    * Beware that changing an allowance with this method brings the risk that someone may use both the old
183    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186    * @param _spender The address which will spend the funds.
187    * @param _value The amount of tokens to be spent.
188    */
189   function approve(address _spender, uint256 _value) public returns (bool) {
190     allowed[msg.sender][_spender] = _value;
191     Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Function to check the amount of tokens that an owner allowed to a spender.
197    * @param _owner address The address which owns the funds.
198    * @param _spender address The address which will spend the funds.
199    * @return A uint256 specifying the amount of tokens still available for the spender.
200    */
201   function allowance(address _owner, address _spender) public view returns (uint256) {
202     return allowed[_owner][_spender];
203   }
204 
205   /**
206    * @dev Increase the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
216     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
232     uint oldValue = allowed[msg.sender][_spender];
233     if (_subtractedValue > oldValue) {
234       allowed[msg.sender][_spender] = 0;
235     } else {
236       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
237     }
238     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242 }
243 
244 // File: node_modules/zeppelin-solidity/contracts/token/MintableToken.sol
245 
246 /**
247  * @title Mintable token
248  * @dev Simple ERC20 Token example, with mintable token creation
249  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
250  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
251  */
252 
253 contract MintableToken is StandardToken, Ownable {
254   event Mint(address indexed to, uint256 amount);
255   event MintFinished();
256 
257   bool public mintingFinished = false;
258 
259 
260   modifier canMint() {
261     require(!mintingFinished);
262     _;
263   }
264 
265   /**
266    * @dev Function to mint tokens
267    * @param _to The address that will receive the minted tokens.
268    * @param _amount The amount of tokens to mint.
269    * @return A boolean that indicates if the operation was successful.
270    */
271   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
272     totalSupply = totalSupply.add(_amount);
273     balances[_to] = balances[_to].add(_amount);
274     Mint(_to, _amount);
275     Transfer(address(0), _to, _amount);
276     return true;
277   }
278 
279   /**
280    * @dev Function to stop minting new tokens.
281    * @return True if the operation was successful.
282    */
283   function finishMinting() onlyOwner canMint public returns (bool) {
284     mintingFinished = true;
285     MintFinished();
286     return true;
287   }
288 }
289 
290 // File: node_modules/zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
291 
292 /**
293  * @title Crowdsale
294  * @dev Crowdsale is a base contract for managing a token crowdsale.
295  * Crowdsales have a start and end timestamps, where investors can make
296  * token purchases and the crowdsale will assign them tokens based
297  * on a token per ETH rate. Funds collected are forwarded to a wallet
298  * as they arrive.
299  */
300 contract Crowdsale {
301   using SafeMath for uint256;
302 
303   // The token being sold
304   MintableToken public token;
305 
306   // start and end timestamps where investments are allowed (both inclusive)
307   uint256 public startTime;
308   uint256 public endTime;
309 
310   // address where funds are collected
311   address public wallet;
312 
313   // how many token units a buyer gets per wei
314   uint256 public rate;
315 
316   // amount of raised money in wei
317   uint256 public weiRaised;
318 
319   /**
320    * event for token purchase logging
321    * @param purchaser who paid for the tokens
322    * @param beneficiary who got the tokens
323    * @param value weis paid for purchase
324    * @param amount amount of tokens purchased
325    */
326   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
327 
328 
329   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
330     require(_startTime >= now);
331     require(_endTime >= _startTime);
332     require(_rate > 0);
333     require(_wallet != address(0));
334 
335     token = createTokenContract();
336     startTime = _startTime;
337     endTime = _endTime;
338     rate = _rate;
339     wallet = _wallet;
340   }
341 
342   // creates the token to be sold.
343   // override this method to have crowdsale of a specific mintable token.
344   function createTokenContract() internal returns (MintableToken) {
345     return new MintableToken();
346   }
347 
348 
349   // fallback function can be used to buy tokens
350   function () external payable {
351     buyTokens(msg.sender);
352   }
353 
354   // low level token purchase function
355   function buyTokens(address beneficiary) public payable {
356     require(beneficiary != address(0));
357     require(validPurchase());
358 
359     uint256 weiAmount = msg.value;
360 
361     // calculate token amount to be created
362     uint256 tokens = weiAmount.mul(rate);
363 
364     // update state
365     weiRaised = weiRaised.add(weiAmount);
366 
367     token.mint(beneficiary, tokens);
368     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
369 
370     forwardFunds();
371   }
372 
373   // send ether to the fund collection wallet
374   // override to create custom fund forwarding mechanisms
375   function forwardFunds() internal {
376     wallet.transfer(msg.value);
377   }
378 
379   // @return true if the transaction can buy tokens
380   function validPurchase() internal view returns (bool) {
381     bool withinPeriod = now >= startTime && now <= endTime;
382     bool nonZeroPurchase = msg.value != 0;
383     return withinPeriod && nonZeroPurchase;
384   }
385 
386   // @return true if crowdsale event has ended
387   function hasEnded() public view returns (bool) {
388     return now > endTime;
389   }
390 
391 
392 }
393 
394 // File: node_modules/zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol
395 
396 /**
397  * @title CappedCrowdsale
398  * @dev Extension of Crowdsale with a max amount of funds raised
399  */
400 contract CappedCrowdsale is Crowdsale {
401   using SafeMath for uint256;
402 
403   uint256 public cap;
404 
405   function CappedCrowdsale(uint256 _cap) public {
406     require(_cap > 0);
407     cap = _cap;
408   }
409 
410   // overriding Crowdsale#validPurchase to add extra cap logic
411   // @return true if investors can buy at the moment
412   function validPurchase() internal view returns (bool) {
413     bool withinCap = weiRaised.add(msg.value) <= cap;
414     return super.validPurchase() && withinCap;
415   }
416 
417   // overriding Crowdsale#hasEnded to add cap logic
418   // @return true if crowdsale event has ended
419   function hasEnded() public view returns (bool) {
420     bool capReached = weiRaised >= cap;
421     return super.hasEnded() || capReached;
422   }
423 
424 }
425 
426 // File: node_modules/zeppelin-solidity/contracts/crowdsale/FinalizableCrowdsale.sol
427 
428 /**
429  * @title FinalizableCrowdsale
430  * @dev Extension of Crowdsale where an owner can do extra work
431  * after finishing.
432  */
433 contract FinalizableCrowdsale is Crowdsale, Ownable {
434   using SafeMath for uint256;
435 
436   bool public isFinalized = false;
437 
438   event Finalized();
439 
440   /**
441    * @dev Must be called after crowdsale ends, to do some extra finalization
442    * work. Calls the contract's finalization function.
443    */
444   function finalize() onlyOwner public {
445     require(!isFinalized);
446     require(hasEnded());
447 
448     finalization();
449     Finalized();
450 
451     isFinalized = true;
452   }
453 
454   /**
455    * @dev Can be overridden to add finalization logic. The overriding function
456    * should call super.finalization() to ensure the chain of finalization is
457    * executed entirely.
458    */
459   function finalization() internal {
460   }
461 }
462 
463 // File: node_modules/zeppelin-solidity/contracts/crowdsale/RefundVault.sol
464 
465 /**
466  * @title RefundVault
467  * @dev This contract is used for storing funds while a crowdsale
468  * is in progress. Supports refunding the money if crowdsale fails,
469  * and forwarding it if crowdsale is successful.
470  */
471 contract RefundVault is Ownable {
472   using SafeMath for uint256;
473 
474   enum State { Active, Refunding, Closed }
475 
476   mapping (address => uint256) public deposited;
477   address public wallet;
478   State public state;
479 
480   event Closed();
481   event RefundsEnabled();
482   event Refunded(address indexed beneficiary, uint256 weiAmount);
483 
484   function RefundVault(address _wallet) public {
485     require(_wallet != address(0));
486     wallet = _wallet;
487     state = State.Active;
488   }
489 
490   function deposit(address investor) onlyOwner public payable {
491     require(state == State.Active);
492     deposited[investor] = deposited[investor].add(msg.value);
493   }
494 
495   function close() onlyOwner public {
496     require(state == State.Active);
497     state = State.Closed;
498     Closed();
499     wallet.transfer(this.balance);
500   }
501 
502   function enableRefunds() onlyOwner public {
503     require(state == State.Active);
504     state = State.Refunding;
505     RefundsEnabled();
506   }
507 
508   function refund(address investor) public {
509     require(state == State.Refunding);
510     uint256 depositedValue = deposited[investor];
511     deposited[investor] = 0;
512     investor.transfer(depositedValue);
513     Refunded(investor, depositedValue);
514   }
515 }
516 
517 // File: node_modules/zeppelin-solidity/contracts/crowdsale/RefundableCrowdsale.sol
518 
519 /**
520  * @title RefundableCrowdsale
521  * @dev Extension of Crowdsale contract that adds a funding goal, and
522  * the possibility of users getting a refund if goal is not met.
523  * Uses a RefundVault as the crowdsale's vault.
524  */
525 contract RefundableCrowdsale is FinalizableCrowdsale {
526   using SafeMath for uint256;
527 
528   // minimum amount of funds to be raised in weis
529   uint256 public goal;
530 
531   // refund vault used to hold funds while crowdsale is running
532   RefundVault public vault;
533 
534   function RefundableCrowdsale(uint256 _goal) public {
535     require(_goal > 0);
536     vault = new RefundVault(wallet);
537     goal = _goal;
538   }
539 
540   // We're overriding the fund forwarding from Crowdsale.
541   // In addition to sending the funds, we want to call
542   // the RefundVault deposit function
543   function forwardFunds() internal {
544     vault.deposit.value(msg.value)(msg.sender);
545   }
546 
547   // if crowdsale is unsuccessful, investors can claim refunds here
548   function claimRefund() public {
549     require(isFinalized);
550     require(!goalReached());
551 
552     vault.refund(msg.sender);
553   }
554 
555   // vault finalization task, called when owner calls finalize()
556   function finalization() internal {
557     if (goalReached()) {
558       vault.close();
559     } else {
560       vault.enableRefunds();
561     }
562 
563     super.finalization();
564   }
565 
566   function goalReached() public view returns (bool) {
567     return weiRaised >= goal;
568   }
569 
570 }
571 
572 // File: contracts/CustomDealToken.sol
573 
574 /**
575  * @title CustomDealToken
576  * @author Aleksandar Djordjevic
577  * @dev Custom Deal Mintable Token is a base contract for managing a token contract
578  */
579 contract CustomDealToken is MintableToken {
580 
581     // Name of the token
582     string public constant name = 'Custom Deal Token';
583 
584     // Symbol of the token
585     string public constant symbol = 'CDL';
586 
587     // Number of decimal places of the token
588     uint256 public constant decimals = 18;
589 }
590 
591 // File: contracts/CustomDealICO.sol
592 
593 /**
594  * @title CustomDealICO
595  * @author Aleksandar Djordjevic
596  * @dev Crowdsale is a base contract for managing a token crowdsale
597  * Crowdsales have a start and end timestamps, where investors can make
598  * token purchases and the crowdsale will assign them CDL tokens based
599  * on a CDL token per ETH rate. Funds collected are forwarded to a wallet
600  * as they arrive
601  */
602 contract CustomDealICO is CappedCrowdsale, RefundableCrowdsale {
603 
604     // ICO Stages
605     // ============
606     enum CrowdsaleStage { PreICOFirst, PreICOSecond, ICOFirst, ICOSecond }
607     CrowdsaleStage public stage = CrowdsaleStage.PreICOFirst; // By default it's Pre ICO First
608     // =============
609 
610     // Token Distribution
611     // =============================
612     uint256 public maxTokens = 400000000000000000000000000; // There will be total 400 000 000 Custom Deal Tokens
613     uint256 public tokensForEcosystem = 120000000000000000000000000; // 120 000 000 CDL will be reserved for ecosystem
614     uint256 public totalTokensForSale = 280000000000000000000000000; // 280 000 000 CDL will be sold in Crowdsale
615     uint256 public totalTokensForSaleDuringPreICO = 100000000000000000000000000; // 100 000 000 CDL will be reserved for PreICO Crowdsale
616     // ==============================
617 
618     // Amount raised in PreICO
619     // ==================
620     uint256 public totalWeiRaisedDuringPreICO;
621     // ===================
622 
623     // Events
624     event EthTransferred(string text);
625     event EthRefunded(string text);
626 
627     // Constructor
628     // ============
629     function CustomDealICO(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _goal, uint256 _cap) CappedCrowdsale(_cap) FinalizableCrowdsale() RefundableCrowdsale(_goal) Crowdsale(_startTime, _endTime, _rate, _wallet) public {
630         require(_goal <= _cap);
631     }
632     // =============
633 
634     // Token Deployment
635     // =================
636     function createTokenContract() internal returns (MintableToken) {
637         return new CustomDealToken(); // Deploys the ERC20 token. Automatically called when crowdsale contract is deployed
638     }
639     // ==================
640 
641     // Crowdsale Stage Management
642     // =========================================================
643 
644     // Change Crowdsale Stage. Available Options: PreICO, ICO
645     function setCrowdsaleStage(uint value) public onlyOwner {
646 
647         CrowdsaleStage _stage;
648 
649         if (uint(CrowdsaleStage.PreICOFirst) == value) {
650             _stage = CrowdsaleStage.PreICOFirst;
651         } else if (uint(CrowdsaleStage.PreICOSecond) == value) {
652             _stage = CrowdsaleStage.PreICOSecond;
653         } else if (uint(CrowdsaleStage.ICOFirst) == value) {
654             _stage = CrowdsaleStage.ICOFirst;
655         } else if (uint(CrowdsaleStage.ICOSecond) == value) {
656             _stage = CrowdsaleStage.ICOSecond;
657         }
658 
659         stage = _stage;
660 
661         // based on the price of 1 ETH = 600$
662         if (stage == CrowdsaleStage.PreICOFirst) {
663             setCurrentRate(40000);
664         } else if (stage == CrowdsaleStage.PreICOSecond) {
665             setCurrentRate(33335);
666         } else if (stage == CrowdsaleStage.ICOFirst) {
667             setCurrentRate(15000);
668         } else if (stage == CrowdsaleStage.ICOSecond) {
669             setCurrentRate(10000);
670         }
671     }
672 
673     // Change the current rate
674     function setCurrentRate(uint256 _rate) private {
675         rate = _rate;
676     }
677 
678     // ================ Stage Management Over =====================
679 
680     // Token Purchase
681     // =========================
682     function () external payable {
683         uint256 tokensThatWillBeMintedAfterPurchase = msg.value.mul(rate);
684 
685         if ((stage == CrowdsaleStage.PreICOFirst) && (token.totalSupply() + tokensThatWillBeMintedAfterPurchase > totalTokensForSaleDuringPreICO)) {
686             msg.sender.transfer(msg.value);
687             // Refund them
688             EthRefunded("PreICOFirst Limit Hit");
689             return;
690         }
691 
692         if ((stage == CrowdsaleStage.PreICOSecond) && (token.totalSupply() + tokensThatWillBeMintedAfterPurchase > totalTokensForSaleDuringPreICO)) {
693             msg.sender.transfer(msg.value); // Refund them
694             EthRefunded("PreICOSecond Limit Hit");
695             return;
696         }
697 
698         buyTokens(msg.sender);
699 
700         if (stage == CrowdsaleStage.PreICOFirst) {
701             totalWeiRaisedDuringPreICO = totalWeiRaisedDuringPreICO.add(msg.value);
702         }
703 
704         if (stage == CrowdsaleStage.PreICOSecond) {
705             totalWeiRaisedDuringPreICO = totalWeiRaisedDuringPreICO.add(msg.value);
706         }
707     }
708 
709     function forwardFunds() internal {
710         if (stage == CrowdsaleStage.PreICOFirst || stage == CrowdsaleStage.PreICOSecond) {
711             wallet.transfer(msg.value);
712             EthTransferred("forwarding funds to wallet");
713         } else if (stage == CrowdsaleStage.ICOFirst || stage == CrowdsaleStage.ICOSecond) {
714             EthTransferred("forwarding funds to refundable vault");
715             super.forwardFunds();
716         }
717     }
718     // ===========================
719 
720     // Finish: Mint Extra Tokens as needed before finalizing the Crowdsale.
721     // ====================================================================
722 
723     function finish(address _ecosystemFund) public onlyOwner {
724 
725         require(!isFinalized);
726         uint256 alreadyMinted = token.totalSupply();
727         require(alreadyMinted < maxTokens);
728 
729         uint256 unsoldTokens = totalTokensForSale - alreadyMinted;
730         if (unsoldTokens > 0) {
731             tokensForEcosystem = tokensForEcosystem + unsoldTokens;
732         }
733 
734         token.mint(_ecosystemFund,tokensForEcosystem);
735         finalize();
736     }
737     // ===============================
738 }
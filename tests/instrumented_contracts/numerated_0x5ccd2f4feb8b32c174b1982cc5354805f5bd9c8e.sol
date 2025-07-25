1 pragma solidity ^0.4.22;
2 
3 // Generated by TokenGen and the Fabric Token platform.
4 // https://tokengen.io
5 // https://fabrictoken.io
6 
7 // File: contracts/library/SafeMath.sol
8 
9 /**
10  * @title Safe Math
11  *
12  * @dev Library for safe mathematical operations.
13  */
14 library SafeMath {
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a * b;
17         assert(a == 0 || c / a == b);
18 
19         return c;
20     }
21 
22     function div(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a / b;
24 
25         return c;
26     }
27 
28     function minus(uint256 a, uint256 b) internal pure returns (uint256) {
29         assert(b <= a);
30 
31         return a - b;
32     }
33 
34     function plus(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         assert(c >= a);
37 
38         return c;
39     }
40 }
41 
42 // File: contracts/token/ERC20Token.sol
43 
44 /**
45  * @dev The standard ERC20 Token contract base.
46  */
47 contract ERC20Token {
48     uint256 public totalSupply;  /* shorthand for public function and a property */
49     
50     function balanceOf(address _owner) public view returns (uint256 balance);
51     function transfer(address _to, uint256 _value) public returns (bool success);
52     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
53     function approve(address _spender, uint256 _value) public returns (bool success);
54     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
55 
56     event Transfer(address indexed _from, address indexed _to, uint256 _value);
57     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
58 }
59 
60 // File: contracts/component/TokenSafe.sol
61 
62 /**
63  * @title TokenSafe
64  *
65  * @dev Abstract contract that serves as a base for the token safes. It is a multi-group token safe, where each group
66  *      has it's own release time and multiple accounts with locked tokens.
67  */
68 contract TokenSafe {
69     using SafeMath for uint;
70 
71     // The ERC20 token contract.
72     ERC20Token token;
73 
74     struct Group {
75         // The release date for the locked tokens
76         // Note: Unix timestamp fits in uint32, however block.timestamp is uint256
77         uint256 releaseTimestamp;
78         // The total remaining tokens in the group.
79         uint256 remaining;
80         // The individual account token balances in the group.
81         mapping (address => uint) balances;
82     }
83 
84     // The groups of locked tokens
85     mapping (uint8 => Group) public groups;
86 
87     /**
88      * @dev The constructor.
89      *
90      * @param _token The address of the Fabric Token (fundraiser) contract.
91      */
92     constructor(address _token) public {
93         token = ERC20Token(_token);
94     }
95 
96     /**
97      * @dev The function initializes a group with a release date.
98      *
99      * @param _id Group identifying number.
100      * @param _releaseTimestamp Unix timestamp of the time after which the tokens can be released
101      */
102     function init(uint8 _id, uint _releaseTimestamp) internal {
103         require(_releaseTimestamp > 0, "TokenSafe group release timestamp is not set");
104         
105         Group storage group = groups[_id];
106         group.releaseTimestamp = _releaseTimestamp;
107     }
108 
109     /**
110      * @dev Add new account with locked token balance to the specified group id.
111      *
112      * @param _id Group identifying number.
113      * @param _account The address of the account to be added.
114      * @param _balance The number of tokens to be locked.
115      */
116     function add(uint8 _id, address _account, uint _balance) internal {
117         Group storage group = groups[_id];
118         group.balances[_account] = group.balances[_account].plus(_balance);
119         group.remaining = group.remaining.plus(_balance);
120     }
121 
122     /**
123      * @dev Allows an account to be released if it meets the time constraints of the group.
124      *
125      * @param _id Group identifying number.
126      * @param _account The address of the account to be released.
127      */
128     function release(uint8 _id, address _account) public {
129         Group storage group = groups[_id];
130         require(now >= group.releaseTimestamp, "Group funds are not released yet");
131         
132         uint tokens = group.balances[_account];
133         require(tokens > 0, "The account is empty or non-existent");
134         
135         group.balances[_account] = 0;
136         group.remaining = group.remaining.minus(tokens);
137         
138         if (!token.transfer(_account, tokens)) {
139             revert("Token transfer failed");
140         }
141     }
142 }
143 
144 // File: contracts/token/StandardToken.sol
145 
146 /**
147  * @title Standard Token
148  *
149  * @dev The standard abstract implementation of the ERC20 interface.
150  */
151 contract StandardToken is ERC20Token {
152     using SafeMath for uint256;
153 
154     string public name;
155     string public symbol;
156     uint8 public decimals;
157 
158     mapping (address => uint256) balances;
159     mapping (address => mapping (address => uint256)) internal allowed;
160 
161     /**
162      * @dev The constructor assigns the token name, symbols and decimals.
163      */
164     constructor(string _name, string _symbol, uint8 _decimals) internal {
165         name = _name;
166         symbol = _symbol;
167         decimals = _decimals;
168     }
169 
170     /**
171      * @dev Get the balance of an address.
172      *
173      * @param _address The address which's balance will be checked.
174      *
175      * @return The current balance of the address.
176      */
177     function balanceOf(address _address) public view returns (uint256 balance) {
178         return balances[_address];
179     }
180 
181     /**
182      * @dev Checks the amount of tokens that an owner allowed to a spender.
183      *
184      * @param _owner The address which owns the funds allowed for spending by a third-party.
185      * @param _spender The third-party address that is allowed to spend the tokens.
186      *
187      * @return The number of tokens available to `_spender` to be spent.
188      */
189     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
190         return allowed[_owner][_spender];
191     }
192 
193     /**
194      * @dev Give permission to `_spender` to spend `_value` number of tokens on your behalf.
195      * E.g. You place a buy or sell order on an exchange and in that example, the 
196      * `_spender` address is the address of the contract the exchange created to add your token to their 
197      * website and you are `msg.sender`.
198      *
199      * @param _spender The address which will spend the funds.
200      * @param _value The amount of tokens to be spent.
201      *
202      * @return Whether the approval process was successful or not.
203      */
204     function approve(address _spender, uint256 _value) public returns (bool) {
205         allowed[msg.sender][_spender] = _value;
206 
207         emit Approval(msg.sender, _spender, _value);
208 
209         return true;
210     }
211 
212     /**
213      * @dev Transfers `_value` number of tokens to the `_to` address.
214      *
215      * @param _to The address of the recipient.
216      * @param _value The number of tokens to be transferred.
217      */
218     function transfer(address _to, uint256 _value) public returns (bool) {
219         executeTransfer(msg.sender, _to, _value);
220 
221         return true;
222     }
223 
224     /**
225      * @dev Allows another contract to spend tokens on behalf of the `_from` address and send them to the `_to` address.
226      *
227      * @param _from The address which approved you to spend tokens on their behalf.
228      * @param _to The address where you want to send tokens.
229      * @param _value The number of tokens to be sent.
230      *
231      * @return Whether the transfer was successful or not.
232      */
233     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
234         require(_value <= allowed[_from][msg.sender], "Insufficient allowance");
235 
236         allowed[_from][msg.sender] = allowed[_from][msg.sender].minus(_value);
237         executeTransfer(_from, _to, _value);
238 
239         return true;
240     }
241 
242     /**
243      * @dev Internal function that this reused by the transfer functions
244      */
245     function executeTransfer(address _from, address _to, uint256 _value) internal {
246         require(_to != address(0), "Invalid transfer to address zero");
247         require(_value <= balances[_from], "Insufficient account balance");
248 
249         balances[_from] = balances[_from].minus(_value);
250         balances[_to] = balances[_to].plus(_value);
251 
252         emit Transfer(_from, _to, _value);
253     }
254 }
255 
256 // File: contracts/token/MintableToken.sol
257 
258 /**
259  * @title Mintable Token
260  *
261  * @dev Allows the creation of new tokens.
262  */
263 contract MintableToken is StandardToken {
264     /// @dev The only address allowed to mint coins
265     address public minter;
266 
267     /// @dev Indicates whether the token is still mintable.
268     bool public mintingDisabled = false;
269 
270     /**
271      * @dev Event fired when minting is no longer allowed.
272      */
273     event MintingDisabled();
274 
275     /**
276      * @dev Allows a function to be executed only if minting is still allowed.
277      */
278     modifier canMint() {
279         require(!mintingDisabled, "Minting is disabled");
280         _;
281     }
282 
283     /**
284      * @dev Allows a function to be called only by the minter
285      */
286     modifier onlyMinter() {
287         require(msg.sender == minter, "Only the minter address can mint");
288         _;
289     }
290 
291     /**
292      * @dev The constructor assigns the minter which is allowed to mind and disable minting
293      */
294     constructor(address _minter) internal {
295         minter = _minter;
296     }
297 
298     /**
299     * @dev Creates new `_value` number of tokens and sends them to the `_to` address.
300     *
301     * @param _to The address which will receive the freshly minted tokens.
302     * @param _value The number of tokens that will be created.
303     */
304     function mint(address _to, uint256 _value) public onlyMinter canMint {
305         totalSupply = totalSupply.plus(_value);
306         balances[_to] = balances[_to].plus(_value);
307 
308         emit Transfer(0x0, _to, _value);
309     }
310 
311     /**
312     * @dev Disable the minting of new tokens. Cannot be reversed.
313     *
314     * @return Whether or not the process was successful.
315     */
316     function disableMinting() public onlyMinter canMint {
317         mintingDisabled = true;
318        
319         emit MintingDisabled();
320     }
321 }
322 
323 // File: contracts/trait/HasOwner.sol
324 
325 /**
326  * @title HasOwner
327  *
328  * @dev Allows for exclusive access to certain functionality.
329  */
330 contract HasOwner {
331     // The current owner.
332     address public owner;
333 
334     // Conditionally the new owner.
335     address public newOwner;
336 
337     /**
338      * @dev The constructor.
339      *
340      * @param _owner The address of the owner.
341      */
342     constructor(address _owner) public {
343         owner = _owner;
344     }
345 
346     /** 
347      * @dev Access control modifier that allows only the current owner to call the function.
348      */
349     modifier onlyOwner {
350         require(msg.sender == owner, "Only owner can call this function");
351         _;
352     }
353 
354     /**
355      * @dev The event is fired when the current owner is changed.
356      *
357      * @param _oldOwner The address of the previous owner.
358      * @param _newOwner The address of the new owner.
359      */
360     event OwnershipTransfer(address indexed _oldOwner, address indexed _newOwner);
361 
362     /**
363      * @dev Transfering the ownership is a two-step process, as we prepare
364      * for the transfer by setting `newOwner` and requiring `newOwner` to accept
365      * the transfer. This prevents accidental lock-out if something goes wrong
366      * when passing the `newOwner` address.
367      *
368      * @param _newOwner The address of the proposed new owner.
369      */
370     function transferOwnership(address _newOwner) public onlyOwner {
371         newOwner = _newOwner;
372     }
373  
374     /**
375      * @dev The `newOwner` finishes the ownership transfer process by accepting the
376      * ownership.
377      */
378     function acceptOwnership() public {
379         require(msg.sender == newOwner, "Only the newOwner can accept ownership");
380 
381         emit OwnershipTransfer(owner, newOwner);
382 
383         owner = newOwner;
384     }
385 }
386 
387 // File: contracts/fundraiser/AbstractFundraiser.sol
388 
389 contract AbstractFundraiser {
390     /// The ERC20 token contract.
391     ERC20Token public token;
392 
393     /**
394      * @dev The event fires every time a new buyer enters the fundraiser.
395      *
396      * @param _address The address of the buyer.
397      * @param _ethers The number of ethers funded.
398      * @param _tokens The number of tokens purchased.
399      */
400     event FundsReceived(address indexed _address, uint _ethers, uint _tokens);
401 
402 
403     /**
404      * @dev The initialization method for the token
405      *
406      * @param _token The address of the token of the fundraiser
407      */
408     function initializeFundraiserToken(address _token) internal
409     {
410         token = ERC20Token(_token);
411     }
412 
413     /**
414      * @dev The default function which is executed when someone sends funds to this contract address.
415      */
416     function() public payable {
417         receiveFunds(msg.sender, msg.value);
418     }
419 
420     /**
421      * @dev this overridable function returns the current conversion rate for the fundraiser
422      */
423     function getConversionRate() public view returns (uint256);
424 
425     /**
426      * @dev checks whether the fundraiser passed `endTime`.
427      *
428      * @return whether the fundraiser has ended.
429      */
430     function hasEnded() public view returns (bool);
431 
432     /**
433      * @dev Create and sends tokens to `_address` considering amount funded and `conversionRate`.
434      *
435      * @param _address The address of the receiver of tokens.
436      * @param _amount The amount of received funds in ether.
437      */
438     function receiveFunds(address _address, uint256 _amount) internal;
439     
440     /**
441      * @dev It throws an exception if the transaction does not meet the preconditions.
442      */
443     function validateTransaction() internal view;
444     
445     /**
446      * @dev this overridable function makes and handles tokens to buyers
447      */
448     function handleTokens(address _address, uint256 _tokens) internal;
449 
450     /**
451      * @dev this overridable function forwards the funds (if necessary) to a vault or directly to the beneficiary
452      */
453     function handleFunds(address _address, uint256 _ethers) internal;
454 
455 }
456 
457 // File: contracts/fundraiser/BasicFundraiser.sol
458 
459 /**
460  * @title Basic Fundraiser
461  *
462  * @dev An abstract contract that is a base for fundraisers. 
463  * It implements a generic procedure for handling received funds:
464  * 1. Validates the transaction preconditions
465  * 2. Calculates the amount of tokens based on the conversion rate.
466  * 3. Delegate the handling of the tokens (mint, transfer or create)
467  * 4. Delegate the handling of the funds
468  * 5. Emit event for received funds
469  */
470 contract BasicFundraiser is HasOwner, AbstractFundraiser {
471     using SafeMath for uint256;
472 
473     // The number of decimals for the token.
474     uint8 constant DECIMALS = 18;  // Enforced
475 
476     // Decimal factor for multiplication purposes.
477     uint256 constant DECIMALS_FACTOR = 10 ** uint256(DECIMALS);
478 
479     // The start time of the fundraiser - Unix timestamp.
480     uint256 public startTime;
481 
482     // The end time of the fundraiser - Unix timestamp.
483     uint256 public endTime;
484 
485     // The address where funds collected will be sent.
486     address public beneficiary;
487 
488     // The conversion rate with decimals difference adjustment,
489     // When converion rate is lower than 1 (inversed), the function calculateTokens() should use division
490     uint256 public conversionRate;
491 
492     // The total amount of ether raised.
493     uint256 public totalRaised;
494 
495     /**
496      * @dev The event fires when the number of token conversion rate has changed.
497      *
498      * @param _conversionRate The new number of tokens per 1 ether.
499      */
500     event ConversionRateChanged(uint _conversionRate);
501 
502     /**
503      * @dev The basic fundraiser initialization method.
504      *
505      * @param _startTime The start time of the fundraiser - Unix timestamp.
506      * @param _endTime The end time of the fundraiser - Unix timestamp.
507      * @param _conversionRate The number of tokens create for 1 ETH funded.
508      * @param _beneficiary The address which will receive the funds gathered by the fundraiser.
509      */
510     function initializeBasicFundraiser(
511         uint256 _startTime,
512         uint256 _endTime,
513         uint256 _conversionRate,
514         address _beneficiary
515     )
516         internal
517     {
518         require(_endTime >= _startTime, "Fundraiser's end is before its start");
519         require(_conversionRate > 0, "Conversion rate is not set");
520         require(_beneficiary != address(0), "The beneficiary is not set");
521 
522         startTime = _startTime;
523         endTime = _endTime;
524         conversionRate = _conversionRate;
525         beneficiary = _beneficiary;
526     }
527 
528     /**
529      * @dev Sets the new conversion rate
530      *
531      * @param _conversionRate New conversion rate
532      */
533     function setConversionRate(uint256 _conversionRate) public onlyOwner {
534         require(_conversionRate > 0, "Conversion rate is not set");
535 
536         conversionRate = _conversionRate;
537 
538         emit ConversionRateChanged(_conversionRate);
539     }
540 
541     /**
542      * @dev Sets The beneficiary of the fundraiser.
543      *
544      * @param _beneficiary The address of the beneficiary.
545      */
546     function setBeneficiary(address _beneficiary) public onlyOwner {
547         require(_beneficiary != address(0), "The beneficiary is not set");
548 
549         beneficiary = _beneficiary;
550     }
551 
552     /**
553      * @dev Create and sends tokens to `_address` considering amount funded and `conversionRate`.
554      *
555      * @param _address The address of the receiver of tokens.
556      * @param _amount The amount of received funds in ether.
557      */
558     function receiveFunds(address _address, uint256 _amount) internal {
559         validateTransaction();
560 
561         uint256 tokens = calculateTokens(_amount);
562         require(tokens > 0, "The transaction results in zero tokens");
563 
564         totalRaised = totalRaised.plus(_amount);
565         handleTokens(_address, tokens);
566         handleFunds(_address, _amount);
567 
568         emit FundsReceived(_address, msg.value, tokens);
569     }
570 
571     /**
572      * @dev this overridable function returns the current conversion rate multiplied by the conversion rate factor
573      */
574     function getConversionRate() public view returns (uint256) {
575         return conversionRate;
576     }
577 
578     /**
579      * @dev this overridable function that calculates the tokens based on the ether amount
580      */
581     function calculateTokens(uint256 _amount) internal view returns(uint256 tokens) {
582         tokens = _amount.mul(getConversionRate());
583     }
584 
585     /**
586      * @dev It throws an exception if the transaction does not meet the preconditions.
587      */
588     function validateTransaction() internal view {
589         require(msg.value != 0, "Transaction value is zero");
590         require(now >= startTime && now < endTime, "The fundraiser is not active");
591     }
592 
593     /**
594      * @dev checks whether the fundraiser passed `endtime`.
595      *
596      * @return whether the fundraiser is passed its deadline or not.
597      */
598     function hasEnded() public view returns (bool) {
599         return now >= endTime;
600     }
601 }
602 
603 // File: contracts/token/StandardMintableToken.sol
604 
605 contract StandardMintableToken is MintableToken {
606     constructor(address _minter, string _name, string _symbol, uint8 _decimals)
607         StandardToken(_name, _symbol, _decimals)
608         MintableToken(_minter)
609         public
610     {
611     }
612 }
613 
614 // File: contracts/fundraiser/MintableTokenFundraiser.sol
615 
616 /**
617  * @title Fundraiser With Mintable Token
618  */
619 contract MintableTokenFundraiser is BasicFundraiser {
620     /**
621      * @dev The initialization method that creates a new mintable token.
622      *
623      * @param _name Token name
624      * @param _symbol Token symbol
625      * @param _decimals Token decimals
626      */
627     function initializeMintableTokenFundraiser(string _name, string _symbol, uint8 _decimals) internal {
628         token = new StandardMintableToken(
629             address(this), // The fundraiser is the token minter
630             _name,
631             _symbol,
632             _decimals
633         );
634     }
635 
636     /**
637      * @dev Mint the specific amount tokens
638      */
639     function handleTokens(address _address, uint256 _tokens) internal {
640         MintableToken(token).mint(_address, _tokens);
641     }
642 }
643 
644 // File: contracts/fundraiser/IndividualCapsFundraiser.sol
645 
646 /**
647  * @title Fundraiser with individual caps
648  *
649  * @dev Allows you to set a hard cap on your fundraiser.
650  */
651 contract IndividualCapsFundraiser is BasicFundraiser {
652     uint256 public individualMinCap;
653     uint256 public individualMaxCap;
654     uint256 public individualMaxCapTokens;
655 
656 
657     event IndividualMinCapChanged(uint256 _individualMinCap);
658     event IndividualMaxCapTokensChanged(uint256 _individualMaxCapTokens);
659 
660     /**
661      * @dev The initialization method.
662      *
663      * @param _individualMinCap The minimum amount of ether contribution per address.
664      * @param _individualMaxCap The maximum amount of ether contribution per address.
665      */
666     function initializeIndividualCapsFundraiser(uint256 _individualMinCap, uint256 _individualMaxCap) internal {
667         individualMinCap = _individualMinCap;
668         individualMaxCap = _individualMaxCap;
669         individualMaxCapTokens = _individualMaxCap * conversionRate;
670     }
671 
672     function setConversionRate(uint256 _conversionRate) public onlyOwner {
673         super.setConversionRate(_conversionRate);
674 
675         if (individualMaxCap == 0) {
676             return;
677         }
678         
679         individualMaxCapTokens = individualMaxCap * _conversionRate;
680 
681         emit IndividualMaxCapTokensChanged(individualMaxCapTokens);
682     }
683 
684     function setIndividualMinCap(uint256 _individualMinCap) public onlyOwner {
685         individualMinCap = _individualMinCap;
686 
687         emit IndividualMinCapChanged(individualMinCap);
688     }
689 
690     function setIndividualMaxCap(uint256 _individualMaxCap) public onlyOwner {
691         individualMaxCap = _individualMaxCap;
692         individualMaxCapTokens = _individualMaxCap * conversionRate;
693 
694         emit IndividualMaxCapTokensChanged(individualMaxCapTokens);
695     }
696 
697     /**
698      * @dev Extends the transaction validation to check if the value is higher than the minimum cap.
699      */
700     function validateTransaction() internal view {
701         super.validateTransaction();
702         require(
703             msg.value >= individualMinCap,
704             "The transaction value does not pass the minimum contribution cap"
705         );
706     }
707 
708     /**
709      * @dev We validate the new amount doesn't surpass maximum contribution cap
710      */
711     function handleTokens(address _address, uint256 _tokens) internal {
712         require(
713             individualMaxCapTokens == 0 || token.balanceOf(_address).plus(_tokens) <= individualMaxCapTokens,
714             "The transaction exceeds the individual maximum cap"
715         );
716 
717         super.handleTokens(_address, _tokens);
718     }
719 }
720 
721 // File: contracts/fundraiser/GasPriceLimitFundraiser.sol
722 
723 /**
724  * @title GasPriceLimitFundraiser
725  *
726  * @dev This fundraiser allows to set gas price limit for the participants in the fundraiser
727  */
728 contract GasPriceLimitFundraiser is HasOwner, BasicFundraiser {
729     uint256 public gasPriceLimit;
730 
731     event GasPriceLimitChanged(uint256 gasPriceLimit);
732 
733     /**
734      * @dev This function puts the initial gas limit
735      */
736     function initializeGasPriceLimitFundraiser(uint256 _gasPriceLimit) internal {
737         gasPriceLimit = _gasPriceLimit;
738     }
739 
740     /**
741      * @dev This function allows the owner to change the gas limit any time during the fundraiser
742      */
743     function changeGasPriceLimit(uint256 _gasPriceLimit) public onlyOwner {
744         gasPriceLimit = _gasPriceLimit;
745 
746         emit GasPriceLimitChanged(_gasPriceLimit);
747     }
748 
749     /**
750      * @dev The transaction is valid if the gas price limit is lifted-off or the transaction meets the requirement
751      */
752     function validateTransaction() internal view {
753         require(gasPriceLimit == 0 || tx.gasprice <= gasPriceLimit, "Transaction exceeds the gas price limit");
754 
755         return super.validateTransaction();
756     }
757 }
758 
759 // File: contracts/fundraiser/ForwardFundsFundraiser.sol
760 
761 /**
762  * @title Forward Funds to Beneficiary Fundraiser
763  *
764  * @dev This contract forwards the funds received to the beneficiary.
765  */
766 contract ForwardFundsFundraiser is BasicFundraiser {
767     /**
768      * @dev Forward funds directly to beneficiary
769      */
770     function handleFunds(address, uint256 _ethers) internal {
771         // Forward the funds directly to the beneficiary
772         beneficiary.transfer(_ethers);
773     }
774 }
775 
776 // File: contracts/fundraiser/PresaleFundraiser.sol
777 
778 /**
779  * @title PresaleFundraiser
780  *
781  * @dev This is the standard fundraiser contract which allows
782  * you to raise ETH in exchange for your tokens.
783  */
784 contract PresaleFundraiser is MintableTokenFundraiser {
785     /// @dev The token hard cap for the pre-sale
786     uint256 public presaleSupply;
787 
788     /// @dev The token hard cap for the pre-sale
789     uint256 public presaleMaxSupply;
790 
791     /// @dev The start time of the pre-sale (Unix timestamp).
792     uint256 public presaleStartTime;
793 
794     /// @dev The end time of the pre-sale (Unix timestamp).
795     uint256 public presaleEndTime;
796 
797     /// @dev The conversion rate for the pre-sale
798     uint256 public presaleConversionRate;
799 
800     /**
801      * @dev The initialization method.
802      *
803      * @param _startTime The timestamp of the moment when the pre-sale starts
804      * @param _endTime The timestamp of the moment when the pre-sale ends
805      * @param _conversionRate The conversion rate during the pre-sale
806      */
807     function initializePresaleFundraiser(
808         uint256 _presaleMaxSupply,
809         uint256 _startTime,
810         uint256 _endTime,
811         uint256 _conversionRate
812     )
813         internal
814     {
815         require(_endTime >= _startTime, "Pre-sale's end is before its start");
816         require(_conversionRate > 0, "Conversion rate is not set");
817 
818         presaleMaxSupply = _presaleMaxSupply;
819         presaleStartTime = _startTime;
820         presaleEndTime = _endTime;
821         presaleConversionRate = _conversionRate;
822     }
823 
824     /**
825      * @dev Internal funciton that helps to check if the pre-sale is active
826      */
827     
828     function isPresaleActive() internal view returns (bool) {
829         return now < presaleEndTime && now >= presaleStartTime;
830     }
831     /**
832      * @dev this function different conversion rate while in presale
833      */
834     function getConversionRate() public view returns (uint256) {
835         if (isPresaleActive()) {
836             return presaleConversionRate;
837         }
838         return super.getConversionRate();
839     }
840 
841     /**
842      * @dev It throws an exception if the transaction does not meet the preconditions.
843      */
844     function validateTransaction() internal view {
845         require(msg.value != 0, "Transaction value is zero");
846         require(
847             now >= startTime && now < endTime || isPresaleActive(),
848             "Neither the pre-sale nor the fundraiser are currently active"
849         );
850     }
851 
852     function handleTokens(address _address, uint256 _tokens) internal {
853         if (isPresaleActive()) {
854             presaleSupply = presaleSupply.plus(_tokens);
855             require(
856                 presaleSupply <= presaleMaxSupply,
857                 "Transaction exceeds the pre-sale maximum token supply"
858             );
859         }
860 
861         super.handleTokens(_address, _tokens);
862     }
863 
864 }
865 
866 // File: contracts/fundraiser/TieredFundraiser.sol
867 
868 /**
869  * @title TieredFundraiser
870  *
871  * @dev A fundraiser that improves the base conversion precision to allow percent bonuses
872  */
873 
874 contract TieredFundraiser is BasicFundraiser {
875     // Conversion rate factor for better precision.
876     uint256 constant CONVERSION_RATE_FACTOR = 100;
877 
878     /**
879       * @dev Define conversion rates based on the tier start and end date
880       */
881     function getConversionRate() public view returns (uint256) {
882         return super.getConversionRate().mul(CONVERSION_RATE_FACTOR);
883     }
884 
885     /**
886      * @dev this overridable function that calculates the tokens based on the ether amount
887      */
888     function calculateTokens(uint256 _amount) internal view returns(uint256 tokens) {
889         return super.calculateTokens(_amount).div(CONVERSION_RATE_FACTOR);
890     }
891 
892     /**
893      * @dev this overridable function returns the current conversion rate factor
894      */
895     function getConversionRateFactor() public pure returns (uint256) {
896         return CONVERSION_RATE_FACTOR;
897     }
898 }
899 
900 // File: contracts/Fundraiser.sol
901 
902 /**
903  * @title TIMEToken
904  */
905 
906 contract TIMEToken is MintableToken {
907     constructor(address _minter)
908         StandardToken(
909             "TIME",   // Token name
910             "TM", // Token symbol
911             18  // Token decimals
912         )
913         
914         MintableToken(_minter)
915         public
916     {
917     }
918 }
919 
920 
921 
922 /**
923  * @title TIMETokenSafe
924  */
925 
926 contract TIMETokenSafe is TokenSafe {
927   constructor(address _token)
928     TokenSafe(_token)
929     public
930   {
931     
932     // Group "Core Team Members Safe"
933     init(
934       1, // Group Id
935       1555049100 // Release date = 2019-04-12 06:05 UTC
936     );
937     add(
938       1, // Group Id
939       0x892f34F709Dd7090e6E2BeC8220E88CbdF57ed7B,  // Token Safe Entry Address
940       4375000000000000000000000  // Allocated tokens
941     );
942   }
943 }
944 
945 
946 
947 /**
948  * @title TIMETokenFundraiser
949  */
950 
951 contract TIMETokenFundraiser is MintableTokenFundraiser, PresaleFundraiser, IndividualCapsFundraiser, ForwardFundsFundraiser, TieredFundraiser, GasPriceLimitFundraiser {
952     TIMETokenSafe public tokenSafe;
953 
954     constructor()
955         HasOwner(msg.sender)
956         public
957     {
958         token = new TIMEToken(
959         
960         address(this)  // The fundraiser is the minter
961         );
962 
963         tokenSafe = new TIMETokenSafe(token);
964         MintableToken(token).mint(address(tokenSafe), 4375000000000000000000000);
965 
966         initializeBasicFundraiser(
967             1555048920, // Start date = 2019-04-12 06:02 UTC
968             1893391380,  // End date = 2029-12-31 06:03 UTC
969             1, // Conversion rate = 1 TM per 1 ether
970             0xaC4F9BE57419Aed5e71739Cd22a0cf2da4c90Fe4     // Beneficiary
971         );
972 
973         initializeIndividualCapsFundraiser(
974             (0 ether), // Minimum contribution
975             (0 ether)  // Maximum individual cap
976         );
977 
978         initializeGasPriceLimitFundraiser(
979             3000000000000000 // Gas price limit in wei
980         );
981 
982         initializePresaleFundraiser(
983             12500000000000000000000000,
984             1555048800, // Start = 2019-04-12 06:00 UTC
985             1555048860,   // End = 2019-04-12 06:01 UTC
986             1
987         );
988 
989         
990 
991         
992 
993         
994     }
995     
996     /**
997       * @dev Define conversion rates based on the tier start and end date
998       */
999     function getConversionRate() public view returns (uint256) {
1000         uint256 rate = super.getConversionRate();
1001         if (now >= 1555049040 && now < 1555049100)
1002             return rate.mul(105).div(100);
1003         
1004 
1005         return rate;
1006     }
1007 
1008     /**
1009       * @dev Fundraiser with mintable token allows the owner to mint through the Fundraiser contract
1010       */
1011     function mint(address _to, uint256 _value) public onlyOwner {
1012         MintableToken(token).mint(_to, _value);
1013     }
1014 
1015     /**
1016       * @dev Irreversibly disable minting
1017       */
1018     function disableMinting() public onlyOwner {
1019         MintableToken(token).disableMinting();
1020     }
1021     
1022 }
1 pragma solidity ^0.4.20;
2 
3 contract Hohogame {
4     /*=================================
5     =             HOHOGame            =
6     =        Thanks to TeamJust       =
7     =================================*/
8     // only people with tokens
9     modifier onlyBagholders() {
10         require(myTokens() > 0);
11         _;
12     }
13     
14     // only people with profits
15     modifier onlyStronghands() {
16         require(myDividends(true) > 0);
17         _;
18     }
19     
20     // administrators can:
21     // -> change the name of the contract
22     // -> change the name of the token
23     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
24     // they CANNOT:
25     // -> take funds
26     // -> disable withdrawals
27     // -> kill the contract
28     // -> change the price of tokens
29     modifier onlyAdministrator(){
30         address _customerAddress = msg.sender;
31         require(administrators[keccak256(_customerAddress)]);
32         _;
33     }
34     
35     
36     // ensures that the first tokens in the contract will be equally distributed
37     // meaning, no divine dump will be ever possible
38     // result: healthy longevity.
39     modifier antiEarlyWhale(uint256 _amountOfEthereum){
40         address _customerAddress = msg.sender;
41         
42         // are we still in the vulnerable phase?
43         // if so, enact anti early whale protocol 
44         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
45             require(
46                 // is the customer in the ambassador list?
47                 ambassadors_[_customerAddress] == true &&
48                 
49                 // does the customer purchase exceed the max ambassador quota?
50                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
51                 
52             );
53             
54             // updated the accumulated quota    
55             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
56         
57             // execute
58             _;
59         } else {
60             // in case the ether count drops low, the ambassador phase won't reinitiate
61             onlyAmbassadors = false;
62             _;    
63         }
64         
65     }
66     
67     
68     /*==============================
69     =            EVENTS            =
70     ==============================*/
71     event onTokenPurchase(
72         address indexed customerAddress,
73         uint256 incomingEthereum,
74         uint256 tokensMinted,
75         address indexed referredBy
76     );
77     
78     event onTokenSell(
79         address indexed customerAddress,
80         uint256 tokensBurned,
81         uint256 ethereumEarned
82     );
83     
84     event onReinvestment(
85         address indexed customerAddress,
86         uint256 ethereumReinvested,
87         uint256 tokensMinted
88     );
89     
90     event onWithdraw(
91         address indexed customerAddress,
92         uint256 ethereumWithdrawn
93     );
94     
95     // ERC20
96     event Transfer(
97         address indexed from,
98         address indexed to,
99         uint256 tokens
100     );
101     
102     
103     /*=====================================
104     =            CONFIGURABLES            =
105     =====================================*/
106     string public name = "HoHo";
107     string public symbol = "HOHO";
108     uint8 constant public decimals = 18;
109     uint8 constant internal dividendFee_ = 10;
110     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
111     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
112     uint256 constant internal magnitude = 2**64;
113     
114     // proof of stake (defaults at 100 tokens)
115     uint256 public stakingRequirement = 100e18;
116     
117     // ambassador program
118     mapping(address => bool) internal ambassadors_;
119     uint256 constant internal ambassadorMaxPurchase_ = 5 ether;
120     uint256 constant internal ambassadorQuota_ = 20 ether;
121     
122     
123     
124    /*================================
125     =            DATASETS            =
126     ================================*/
127     // amount of shares for each address (scaled number)
128     mapping(address => uint256) internal tokenBalanceLedger_;
129     mapping(address => uint256) internal referralBalance_;
130     mapping(address => int256) internal payoutsTo_;
131     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
132     uint256 internal tokenSupply_ = 0;
133     uint256 internal profitPerShare_;
134     
135     // administrator list (see above on what they can do)
136     mapping(bytes32 => bool) public administrators;
137     
138     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
139     bool public onlyAmbassadors = true;
140     
141 
142 
143     /*=======================================
144     =            PUBLIC FUNCTIONS            =
145     =======================================*/
146     /*
147     * -- APPLICATION ENTRY POINTS --  
148     */
149     function Hohogame()
150         public
151     {
152         // add administrators here
153         administrators[0x4572ea57f086fbb05f03831f788e4a1e73ceb9410a400ffad4640108381a4e47] = true;
154         
155         // add the ambassadors here.
156         // GG 
157         ambassadors_[0x06959f59dba49a81c98ac17bc77193d720180808] = true;
158         
159         // GA
160         ambassadors_[0x3ef75f9f92e92140b244ae8579a2580d460f7d7a] = true;
161     
162          // GB
163         ambassadors_[0x1de09a1cc33db428994737cac7bf4ee8ab28f235] = true; 
164 
165          // GC
166         ambassadors_[0xf7f853fd973be791952943d99d56b4a6e99013ea] = true; 
167             
168          // GD
169         ambassadors_[0x4bbae85e846d5a48b6b259dc7b206c314e60b1be] = true; 
170         
171         // CA
172         ambassadors_[0xB65D97321919179B8c1BA9e0b9F0F414c880CEb3] = true; 
173         
174         // CB
175         ambassadors_[0xB74a5deE4b4D69C5e11DE7e2D89d4A127EcDAFf2] = true; 
176         
177         // CC
178         ambassadors_[0x5741758391044ffd9c2f4423888d21427bf495fd] = true; 
179         
180         // CD
181         ambassadors_[0x8Ab0BfA7DC6967eDd029c23F9b24103031415926] = true; 
182 
183         // CE
184         ambassadors_[0xC3945A2e705dcce6314F5D931EaA261abe1508a8] = true; 
185 
186         // CF
187         ambassadors_[0xAfda5C3cf9e2c1E6877974e3441792dd7C3C2e04] = true; 
188     }
189     
190      
191     /**
192      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
193      */
194     function buy(address _referredBy)
195         public
196         payable
197         returns(uint256)
198     {
199         purchaseTokens(msg.value, _referredBy);
200     }
201     
202     /**
203      * Fallback function to handle ethereum that was send straight to the contract
204      * Unfortunately we cannot use a referral address this way.
205      */
206     function()
207         payable
208         public
209     {
210         purchaseTokens(msg.value, 0x0);
211     }
212     
213     /**
214      * Converts all of caller's dividends to tokens.
215      */
216     function reinvest()
217         onlyStronghands()
218         public
219     {
220         // fetch dividends
221         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
222         
223         // pay out the dividends virtually
224         address _customerAddress = msg.sender;
225         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
226         
227         // retrieve ref. bonus
228         _dividends += referralBalance_[_customerAddress];
229         referralBalance_[_customerAddress] = 0;
230         
231         // dispatch a buy order with the virtualized "withdrawn dividends"
232         uint256 _tokens = purchaseTokens(_dividends, 0x0);
233         
234         // fire event
235         onReinvestment(_customerAddress, _dividends, _tokens);
236     }
237     
238     /**
239      * Alias of sell() and withdraw().
240      */
241     function exit()
242         public
243     {
244         // get token count for caller & sell them all
245         address _customerAddress = msg.sender;
246         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
247         if(_tokens > 0) sell(_tokens);
248         
249         // lambo delivery service
250         withdraw();
251     }
252 
253     /**
254      * Withdraws all of the callers earnings.
255      */
256     function withdraw()
257         onlyStronghands()
258         public
259     {
260         // setup data
261         address _customerAddress = msg.sender;
262         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
263         
264         // update dividend tracker
265         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
266         
267         // add ref. bonus
268         _dividends += referralBalance_[_customerAddress];
269         referralBalance_[_customerAddress] = 0;
270         
271         // lambo delivery service
272         _customerAddress.transfer(_dividends);
273         
274         // fire event
275         onWithdraw(_customerAddress, _dividends);
276     }
277     
278     /**
279      * Liquifies tokens to ethereum.
280      */
281     function sell(uint256 _amountOfTokens)
282         onlyBagholders()
283         public
284     {
285         // setup data
286         address _customerAddress = msg.sender;
287         // russian hackers BTFO
288         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
289         uint256 _tokens = _amountOfTokens;
290         uint256 _ethereum = tokensToEthereum_(_tokens);
291         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
292         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
293         
294         // burn the sold tokens
295         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
296         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
297         
298         // update dividends tracker
299         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
300         payoutsTo_[_customerAddress] -= _updatedPayouts;       
301         
302         // dividing by zero is a bad idea
303         if (tokenSupply_ > 0) {
304             // update the amount of dividends per token
305             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
306         }
307         
308         // fire event
309         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
310     }
311     
312     
313     /**
314      * Transfer tokens from the caller to a new holder.
315      * Remember, there's a 10% fee here as well.
316      */
317     function transfer(address _toAddress, uint256 _amountOfTokens)
318         onlyBagholders()
319         public
320         returns(bool)
321     {
322         // setup
323         address _customerAddress = msg.sender;
324         
325         // make sure we have the requested tokens
326         // also disables transfers until ambassador phase is over
327         // ( we dont want whale premines )
328         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
329         
330         // withdraw all outstanding dividends first
331         if(myDividends(true) > 0) withdraw();
332         
333         // liquify 10% of the tokens that are transfered
334         // these are dispersed to shareholders
335         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
336         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
337         uint256 _dividends = tokensToEthereum_(_tokenFee);
338   
339         // burn the fee tokens
340         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
341 
342         // exchange tokens
343         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
344         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
345         
346         // update dividend trackers
347         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
348         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
349         
350         // disperse dividends among holders
351         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
352         
353         // fire event
354         Transfer(_customerAddress, _toAddress, _taxedTokens);
355         
356         // ERC20
357         return true;
358        
359     }
360     
361     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
362     /**
363      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
364      */
365     function disableInitialStage()
366         onlyAdministrator()
367         public
368     {
369         onlyAmbassadors = false;
370     }
371     
372     /**
373      * In case one of us dies, we need to replace ourselves.
374      */
375     function setAdministrator(bytes32 _identifier, bool _status)
376         onlyAdministrator()
377         public
378     {
379         administrators[_identifier] = _status;
380     }
381     
382     /**
383      * Precautionary measures in case we need to adjust the masternode rate.
384      */
385     function setStakingRequirement(uint256 _amountOfTokens)
386         onlyAdministrator()
387         public
388     {
389         stakingRequirement = _amountOfTokens;
390     }
391     
392     /**
393      * If we want to rebrand, we can.
394      */
395     function setName(string _name)
396         onlyAdministrator()
397         public
398     {
399         name = _name;
400     }
401     
402     /**
403      * If we want to rebrand, we can.
404      */
405     function setSymbol(string _symbol)
406         onlyAdministrator()
407         public
408     {
409         symbol = _symbol;
410     }
411 
412     
413     /*----------  HELPERS AND CALCULATORS  ----------*/
414     /**
415      * Method to view the current Ethereum stored in the contract
416      * Example: totalEthereumBalance()
417      */
418     function totalEthereumBalance()
419         public
420         view
421         returns(uint)
422     {
423         return this.balance;
424     }
425     
426     /**
427      * Retrieve the total token supply.
428      */
429     function totalSupply()
430         public
431         view
432         returns(uint256)
433     {
434         return tokenSupply_;
435     }
436     
437     /**
438      * Retrieve the tokens owned by the caller.
439      */
440     function myTokens()
441         public
442         view
443         returns(uint256)
444     {
445         address _customerAddress = msg.sender;
446         return balanceOf(_customerAddress);
447     }
448     
449     /**
450      * Retrieve the dividends owned by the caller.
451      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
452      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
453      * But in the internal calculations, we want them separate. 
454      */ 
455     function myDividends(bool _includeReferralBonus) 
456         public 
457         view 
458         returns(uint256)
459     {
460         address _customerAddress = msg.sender;
461         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
462     }
463     
464     /**
465      * Retrieve the token balance of any single address.
466      */
467     function balanceOf(address _customerAddress)
468         view
469         public
470         returns(uint256)
471     {
472         return tokenBalanceLedger_[_customerAddress];
473     }
474     
475     /**
476      * Retrieve the dividend balance of any single address.
477      */
478     function dividendsOf(address _customerAddress)
479         view
480         public
481         returns(uint256)
482     {
483         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
484     }
485     
486     /**
487      * Return the buy price of 1 individual token.
488      */
489     function sellPrice() 
490         public 
491         view 
492         returns(uint256)
493     {
494         // our calculation relies on the token supply, so we need supply. Doh.
495         if(tokenSupply_ == 0){
496             return tokenPriceInitial_ - tokenPriceIncremental_;
497         } else {
498             uint256 _ethereum = tokensToEthereum_(1e18);
499             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
500             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
501             return _taxedEthereum;
502         }
503     }
504     
505     /**
506      * Return the sell price of 1 individual token.
507      */
508     function buyPrice() 
509         public 
510         view 
511         returns(uint256)
512     {
513         // our calculation relies on the token supply, so we need supply. Doh.
514         if(tokenSupply_ == 0){
515             return tokenPriceInitial_ + tokenPriceIncremental_;
516         } else {
517             uint256 _ethereum = tokensToEthereum_(1e18);
518             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
519             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
520             return _taxedEthereum;
521         }
522     }
523     
524     /**
525      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
526      */
527     function calculateTokensReceived(uint256 _ethereumToSpend) 
528         public 
529         view 
530         returns(uint256)
531     {
532         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
533         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
534         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
535         
536         return _amountOfTokens;
537     }
538     
539     /**
540      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
541      */
542     function calculateEthereumReceived(uint256 _tokensToSell) 
543         public 
544         view 
545         returns(uint256)
546     {
547         require(_tokensToSell <= tokenSupply_);
548         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
549         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
550         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
551         return _taxedEthereum;
552     }
553     
554     
555     /*==========================================
556     =            INTERNAL FUNCTIONS            =
557     ==========================================*/
558     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
559         antiEarlyWhale(_incomingEthereum)
560         internal
561         returns(uint256)
562     {
563         // data setup
564         address _customerAddress = msg.sender;
565         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
566         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
567         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
568         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
569         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
570         uint256 _fee = _dividends * magnitude;
571  
572         // no point in continuing execution if OP is a poorfag russian hacker
573         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
574         // (or hackers)
575         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
576         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
577         
578         // is the user referred by a masternode?
579         if(
580             // is this a referred purchase?
581             _referredBy != 0x0000000000000000000000000000000000000000 &&
582 
583             // no cheating!
584             _referredBy != _customerAddress &&
585             
586             // does the referrer have at least X whole tokens?
587             // i.e is the referrer a godly chad masternode
588             tokenBalanceLedger_[_referredBy] >= stakingRequirement
589         ){
590             // wealth redistribution
591             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
592         } else {
593             // no ref purchase
594             // add the referral bonus back to the global dividends cake
595             _dividends = SafeMath.add(_dividends, _referralBonus);
596             _fee = _dividends * magnitude;
597         }
598         
599         // we can't give people infinite ethereum
600         if(tokenSupply_ > 0){
601             
602             // add tokens to the pool
603             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
604  
605             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
606             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
607             
608             // calculate the amount of tokens the customer receives over his purchase 
609             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
610         
611         } else {
612             // add tokens to the pool
613             tokenSupply_ = _amountOfTokens;
614         }
615         
616         // update circulating supply & the ledger address for the customer
617         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
618         
619         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
620         //really i know you think you do but you don't
621         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
622         payoutsTo_[_customerAddress] += _updatedPayouts;
623         
624         // fire event
625         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
626         
627         return _amountOfTokens;
628     }
629 
630     /**
631      * Calculate Token price based on an amount of incoming ethereum
632      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
633      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
634      */
635     function ethereumToTokens_(uint256 _ethereum)
636         internal
637         view
638         returns(uint256)
639     {
640         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
641         uint256 _tokensReceived = 
642          (
643             (
644                 // underflow attempts BTFO
645                 SafeMath.sub(
646                     (sqrt
647                         (
648                             (_tokenPriceInitial**2)
649                             +
650                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
651                             +
652                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
653                             +
654                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
655                         )
656                     ), _tokenPriceInitial
657                 )
658             )/(tokenPriceIncremental_)
659         )-(tokenSupply_)
660         ;
661   
662         return _tokensReceived;
663     }
664     
665     /**
666      * Calculate token sell value.
667      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
668      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
669      */
670      function tokensToEthereum_(uint256 _tokens)
671         internal
672         view
673         returns(uint256)
674     {
675 
676         uint256 tokens_ = (_tokens + 1e18);
677         uint256 _tokenSupply = (tokenSupply_ + 1e18);
678         uint256 _etherReceived =
679         (
680             // underflow attempts BTFO
681             SafeMath.sub(
682                 (
683                     (
684                         (
685                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
686                         )-tokenPriceIncremental_
687                     )*(tokens_ - 1e18)
688                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
689             )
690         /1e18);
691         return _etherReceived;
692     }
693     
694     
695     //This is where all your gas goes, sorry
696     //Not sorry, you probably only paid 1 gwei
697     function sqrt(uint x) internal pure returns (uint y) {
698         uint z = (x + 1) / 2;
699         y = x;
700         while (z < y) {
701             y = z;
702             z = (x / z + z) / 2;
703         }
704     }
705 }
706 
707 /**
708  * @title SafeMath
709  * @dev Math operations with safety checks that throw on error
710  */
711 library SafeMath {
712 
713     /**
714     * @dev Multiplies two numbers, throws on overflow.
715     */
716     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
717         if (a == 0) {
718             return 0;
719         }
720         uint256 c = a * b;
721         assert(c / a == b);
722         return c;
723     }
724 
725     /**
726     * @dev Integer division of two numbers, truncating the quotient.
727     */
728     function div(uint256 a, uint256 b) internal pure returns (uint256) {
729         // assert(b > 0); // Solidity automatically throws when dividing by 0
730         uint256 c = a / b;
731         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
732         return c;
733     }
734 
735     /**
736     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
737     */
738     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
739         assert(b <= a);
740         return a - b;
741     }
742 
743     /**
744     * @dev Adds two numbers, throws on overflow.
745     */
746     function add(uint256 a, uint256 b) internal pure returns (uint256) {
747         uint256 c = a + b;
748         assert(c >= a);
749         return c;
750     }
751 }
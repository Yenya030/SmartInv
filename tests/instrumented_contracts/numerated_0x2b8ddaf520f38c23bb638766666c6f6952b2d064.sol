1 /**
2 
3 Website: https://friendx.app
4 Twitter: https://twitter.com/FriendXERC20
5 Telegram: https://t.me/FriendXERC20
6 
7 */
8 
9 // SPDX-License-Identifier: Unlicensed
10 pragma solidity ^0.8.9;
11  
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 }
17  
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20  
21     function balanceOf(address account) external view returns (uint256);
22  
23     function transfer(address recipient, uint256 amount) external returns (bool);
24  
25     function allowance(address owner, address spender) external view returns (uint256);
26  
27     function approve(address spender, uint256 amount) external returns (bool);
28  
29     function transferFrom(
30         address sender,
31         address recipient,
32         uint256 amount
33     ) external returns (bool);
34  
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(
37         address indexed owner,
38         address indexed spender,
39         uint256 value
40     );
41 }
42  
43 contract Ownable is Context {
44     address private _owner;
45     address private _previousOwner;
46     event OwnershipTransferred(
47         address indexed previousOwner,
48         address indexed newOwner
49     );
50  
51     constructor() {
52         address msgSender = _msgSender();
53         _owner = msgSender;
54         emit OwnershipTransferred(address(0), msgSender);
55     }
56  
57     function owner() public view returns (address) {
58         return _owner;
59     }
60  
61     modifier onlyOwner() {
62         require(_owner == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65  
66     function renounceOwnership() public virtual onlyOwner {
67         emit OwnershipTransferred(_owner, address(0));
68         _owner = address(0);
69     }
70  
71     function transferOwnership(address newOwner) public virtual onlyOwner {
72         require(newOwner != address(0), "Ownable: new owner is the zero address");
73         emit OwnershipTransferred(_owner, newOwner);
74         _owner = newOwner;
75     }
76  
77 }
78  
79 library SafeMath {
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         uint256 c = a + b;
82         require(c >= a, "SafeMath: addition overflow");
83         return c;
84     }
85  
86     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87         return sub(a, b, "SafeMath: subtraction overflow");
88     }
89  
90     function sub(
91         uint256 a,
92         uint256 b,
93         string memory errorMessage
94     ) internal pure returns (uint256) {
95         require(b <= a, errorMessage);
96         uint256 c = a - b;
97         return c;
98     }
99  
100     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101         if (a == 0) {
102             return 0;
103         }
104         uint256 c = a * b;
105         require(c / a == b, "SafeMath: multiplication overflow");
106         return c;
107     }
108  
109     function div(uint256 a, uint256 b) internal pure returns (uint256) {
110         return div(a, b, "SafeMath: division by zero");
111     }
112  
113     function div(
114         uint256 a,
115         uint256 b,
116         string memory errorMessage
117     ) internal pure returns (uint256) {
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         return c;
121     }
122 }
123  
124 interface IUniswapV2Factory {
125     function createPair(address tokenA, address tokenB)
126         external
127         returns (address pair);
128 }
129  
130 interface IUniswapV2Router02 {
131     function swapExactTokensForETHSupportingFeeOnTransferTokens(
132         uint256 amountIn,
133         uint256 amountOutMin,
134         address[] calldata path,
135         address to,
136         uint256 deadline
137     ) external;
138  
139     function factory() external pure returns (address);
140  
141     function WETH() external pure returns (address);
142  
143     function addLiquidityETH(
144         address token,
145         uint256 amountTokenDesired,
146         uint256 amountTokenMin,
147         uint256 amountETHMin,
148         address to,
149         uint256 deadline
150     )
151         external
152         payable
153         returns (
154             uint256 amountToken,
155             uint256 amountETH,
156             uint256 liquidity
157         );
158 }
159  
160 contract FriendX is Context, IERC20, Ownable {
161  
162     using SafeMath for uint256;
163  
164     string private constant _name = "FriendX";
165     string private constant _symbol = "FRIENDX";
166     uint8 private constant _decimals = 18;
167  
168     mapping(address => uint256) private _rOwned;
169     mapping(address => uint256) private _tOwned;
170     mapping(address => mapping(address => uint256)) private _allowances;
171     mapping(address => bool) private _isExcludedFromFee;
172     uint256 private constant MAX = ~uint256(0);
173     uint256 private constant _tTotal = 1000000 * 10**18;
174     uint256 private _rTotal = (MAX - (MAX % _tTotal));
175     uint256 private _tFeeTotal;
176     uint256 private _redisFeeOnBuy = 0;  
177     uint256 private _taxFeeOnBuy = 5;  
178     uint256 private _redisFeeOnSell = 0;  
179     uint256 private _taxFeeOnSell = 5;
180  
181     uint256 private _redisFee = _redisFeeOnSell;
182     uint256 private _taxFee = _taxFeeOnSell;
183  
184     uint256 private _previousredisFee = _redisFee;
185     uint256 private _previoustaxFee = _taxFee;
186  
187     mapping(address => bool) public bots; 
188     mapping (address => uint256) public _buyMap;
189     
190     address payable private _marketingAddress = payable(0x7D9C758eDCac3D984794D6990CE550542540C0ef);
191     address payable private _teamAddress = payable(0xAB4B260859a8050C762550B4d48000D631966568); 
192  
193     IUniswapV2Router02 public uniswapV2Router;
194     address public uniswapV2Pair;
195  
196     bool private tradingOpen;
197     bool private inSwap = false;
198     bool private swapEnabled = true;
199  
200     uint256 public _maxTxAmount = 10000 * 10**18; 
201     uint256 public _maxWalletSize = 10000 * 10**18; 
202     uint256 public _swapTokensAtAmount = 10 * 10**18;
203  
204     event MaxTxAmountUpdated(uint256 _maxTxAmount);
205     modifier lockTheSwap {
206         inSwap = true;
207         _;
208         inSwap = false;
209     }
210  
211     constructor() {
212  
213         _rOwned[_msgSender()] = _rTotal;
214  
215         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
216         uniswapV2Router = _uniswapV2Router;
217         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
218             .createPair(address(this), _uniswapV2Router.WETH());
219  
220         _isExcludedFromFee[owner()] = true;
221         _isExcludedFromFee[address(this)] = true;
222         _isExcludedFromFee[_teamAddress] = true;
223         _isExcludedFromFee[_marketingAddress] = true;
224  
225         emit Transfer(address(0), _msgSender(), _tTotal);
226     }
227  
228     function name() public pure returns (string memory) {
229         return _name;
230     }
231  
232     function symbol() public pure returns (string memory) {
233         return _symbol;
234     }
235  
236     function decimals() public pure returns (uint8) {
237         return _decimals;
238     }
239  
240     function totalSupply() public pure override returns (uint256) {
241         return _tTotal;
242     }
243  
244     function balanceOf(address account) public view override returns (uint256) {
245         return tokenFromReflection(_rOwned[account]);
246     }
247  
248     function transfer(address recipient, uint256 amount)
249         public
250         override
251         returns (bool)
252     {
253         _transfer(_msgSender(), recipient, amount);
254         return true;
255     }
256  
257     function allowance(address owner, address spender)
258         public
259         view
260         override
261         returns (uint256)
262     {
263         return _allowances[owner][spender];
264     }
265  
266     function approve(address spender, uint256 amount)
267         public
268         override
269         returns (bool)
270     {
271         _approve(_msgSender(), spender, amount);
272         return true;
273     }
274  
275     function transferFrom(
276         address sender,
277         address recipient,
278         uint256 amount
279     ) public override returns (bool) {
280         _transfer(sender, recipient, amount);
281         _approve(
282             sender,
283             _msgSender(),
284             _allowances[sender][_msgSender()].sub(
285                 amount,
286                 "ERC20: transfer amount exceeds allowance"
287             )
288         );
289         return true;
290     }
291  
292     function tokenFromReflection(uint256 rAmount)
293         private
294         view
295         returns (uint256)
296     {
297         require(
298             rAmount <= _rTotal,
299             "Amount must be less than total reflections"
300         );
301         uint256 currentRate = _getRate();
302         return rAmount.div(currentRate);
303     }
304  
305     function removeAllFee() private {
306         if (_redisFee == 0 && _taxFee == 0) return;
307  
308         _previousredisFee = _redisFee;
309         _previoustaxFee = _taxFee;
310  
311         _redisFee = 0;
312         _taxFee = 0;
313     }
314  
315     function restoreAllFee() private {
316         _redisFee = _previousredisFee;
317         _taxFee = _previoustaxFee;
318     }
319  
320     function _approve(
321         address owner,
322         address spender,
323         uint256 amount
324     ) private {
325         require(owner != address(0), "ERC20: approve from the zero address");
326         require(spender != address(0), "ERC20: approve to the zero address");
327         _allowances[owner][spender] = amount;
328         emit Approval(owner, spender, amount);
329     }
330  
331     function _transfer(
332         address from,
333         address to,
334         uint256 amount
335     ) private {
336         require(from != address(0), "ERC20: transfer from the zero address");
337         require(to != address(0), "ERC20: transfer to the zero address");
338         require(amount > 0, "Transfer amount must be greater than zero");
339  
340         if (from != owner() && to != owner()) {
341  
342             //Trade start check
343             if (!tradingOpen) {
344                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
345             }
346  
347             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
348             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
349  
350             if(to != uniswapV2Pair) {
351                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
352             }
353  
354             uint256 contractTokenBalance = balanceOf(address(this));
355             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
356  
357             if(contractTokenBalance >= _maxTxAmount)
358             {
359                 contractTokenBalance = _maxTxAmount;
360             }
361  
362             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
363                 swapTokensForEth(contractTokenBalance);
364                 uint256 contractETHBalance = address(this).balance;
365                 if (contractETHBalance > 0) {
366                     sendETHToFee(address(this).balance);
367                 }
368             }
369         }
370  
371         bool takeFee = true;
372  
373         //Transfer Tokens
374         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
375             takeFee = false;
376         } else {
377  
378             //Set Fee for Buys
379             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
380                 _redisFee = _redisFeeOnBuy;
381                 _taxFee = _taxFeeOnBuy;
382             }
383  
384             //Set Fee for Sells
385             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
386                 _redisFee = _redisFeeOnSell;
387                 _taxFee = _taxFeeOnSell;
388             }
389  
390         }
391  
392         _tokenTransfer(from, to, amount, takeFee);
393     }
394  
395     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
396         address[] memory path = new address[](2);
397         path[0] = address(this);
398         path[1] = uniswapV2Router.WETH();
399         _approve(address(this), address(uniswapV2Router), tokenAmount);
400         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
401             tokenAmount,
402             0,
403             path,
404             address(this),
405             block.timestamp
406         );
407     }
408  
409     function sendETHToFee(uint256 amount) private {
410          uint256 halfAmount = amount / 2;
411 
412         _marketingAddress.transfer(halfAmount);
413         _teamAddress.transfer(halfAmount);
414     }
415  
416     function setTrading(bool _tradingOpen) public onlyOwner {
417         tradingOpen = _tradingOpen;
418     }
419  
420     function manualswap() external {
421         require(_msgSender() == _teamAddress || _msgSender() == _marketingAddress);
422         uint256 contractBalance = balanceOf(address(this));
423         swapTokensForEth(contractBalance);
424     }
425  
426     function manualsend() external {
427         require(_msgSender() == _teamAddress || _msgSender() == _marketingAddress);
428         uint256 contractETHBalance = address(this).balance;
429         sendETHToFee(contractETHBalance);
430     }
431  
432     function blockBots(address[] memory bots_) public onlyOwner {
433         for (uint256 i = 0; i < bots_.length; i++) {
434             bots[bots_[i]] = true;
435         }
436     }
437  
438     function unblockBot(address notbot) public onlyOwner {
439         bots[notbot] = false;
440     }
441  
442     function _tokenTransfer(
443         address sender,
444         address recipient,
445         uint256 amount,
446         bool takeFee
447     ) private {
448         if (!takeFee) removeAllFee();
449         _transferStandard(sender, recipient, amount);
450         if (!takeFee) restoreAllFee();
451     }
452  
453     function _transferStandard(
454         address sender,
455         address recipient,
456         uint256 tAmount
457     ) private {
458         (
459             uint256 rAmount,
460             uint256 rTransferAmount,
461             uint256 rFee,
462             uint256 tTransferAmount,
463             uint256 tFee,
464             uint256 tTeam
465         ) = _getValues(tAmount);
466         _rOwned[sender] = _rOwned[sender].sub(rAmount);
467         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
468         _takeTeam(tTeam);
469         _reflectFee(rFee, tFee);
470         emit Transfer(sender, recipient, tTransferAmount);
471     }
472  
473     function _takeTeam(uint256 tTeam) private {
474         uint256 currentRate = _getRate();
475         uint256 rTeam = tTeam.mul(currentRate);
476         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
477     }
478  
479     function _reflectFee(uint256 rFee, uint256 tFee) private {
480         _rTotal = _rTotal.sub(rFee);
481         _tFeeTotal = _tFeeTotal.add(tFee);
482     }
483  
484     receive() external payable {}
485  
486     function _getValues(uint256 tAmount)
487         private
488         view
489         returns (
490             uint256,
491             uint256,
492             uint256,
493             uint256,
494             uint256,
495             uint256
496         )
497     {
498         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
499             _getTValues(tAmount, _redisFee, _taxFee);
500         uint256 currentRate = _getRate();
501         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
502             _getRValues(tAmount, tFee, tTeam, currentRate);
503         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
504     }
505  
506     function _getTValues(
507         uint256 tAmount,
508         uint256 redisFee,
509         uint256 taxFee
510     )
511         private
512         pure
513         returns (
514             uint256,
515             uint256,
516             uint256
517         )
518     {
519         uint256 tFee = tAmount.mul(redisFee).div(100);
520         uint256 tTeam = tAmount.mul(taxFee).div(100);
521         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
522         return (tTransferAmount, tFee, tTeam);
523     }
524  
525     function _getRValues(
526         uint256 tAmount,
527         uint256 tFee,
528         uint256 tTeam,
529         uint256 currentRate
530     )
531         private
532         pure
533         returns (
534             uint256,
535             uint256,
536             uint256
537         )
538     {
539         uint256 rAmount = tAmount.mul(currentRate);
540         uint256 rFee = tFee.mul(currentRate);
541         uint256 rTeam = tTeam.mul(currentRate);
542         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
543         return (rAmount, rTransferAmount, rFee);
544     }
545  
546     function _getRate() private view returns (uint256) {
547         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
548         return rSupply.div(tSupply);
549     }
550  
551     function _getCurrentSupply() private view returns (uint256, uint256) {
552         uint256 rSupply = _rTotal;
553         uint256 tSupply = _tTotal;
554         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
555         return (rSupply, tSupply);
556     }
557  
558     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
559         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 4, "Buy rewards must be between 0% and 4%");
560         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 98, "Buy tax must be between 0% and 98%");
561         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 4, "Sell rewards must be between 0% and 4%");
562         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 98, "Sell tax must be between 0% and 98%");
563 
564         _redisFeeOnBuy = redisFeeOnBuy;
565         _redisFeeOnSell = redisFeeOnSell;
566         _taxFeeOnBuy = taxFeeOnBuy;
567         _taxFeeOnSell = taxFeeOnSell;
568 
569     }
570  
571     //Set minimum tokens required to swap.
572     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
573         _swapTokensAtAmount = swapTokensAtAmount;
574     }
575  
576     //Set minimum tokens required to swap.
577     function toggleSwap(bool _swapEnabled) public onlyOwner {
578         swapEnabled = _swapEnabled;
579     }
580  
581     //Set maximum transaction
582     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
583            _maxTxAmount = maxTxAmount;
584         
585     }
586  
587     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
588         _maxWalletSize = maxWalletSize;
589     }
590  
591     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
592         for(uint256 i = 0; i < accounts.length; i++) {
593             _isExcludedFromFee[accounts[i]] = excluded;
594         }
595     }
596 
597 }
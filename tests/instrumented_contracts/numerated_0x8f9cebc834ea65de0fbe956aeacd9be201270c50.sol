1 /*
2 
3 
4 The three desires of anybody who meets me will come true.
5 Everything that flies to the moon(月) is under my control,
6 and even the storms and rain are subservient to me.
7 
8 
9 
10 */
11 
12 
13 
14 // SPDX-License-Identifier: Unlicensed
15 pragma solidity ^0.8.9;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 }
22 
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25 
26     function balanceOf(address account) external view returns (uint256);
27 
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     function allowance(address owner, address spender) external view returns (uint256);
31 
32     function approve(address spender, uint256 amount) external returns (bool);
33 
34     function transferFrom(
35         address sender,
36         address recipient,
37         uint256 amount
38     ) external returns (bool);
39 
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     event Approval(
42         address indexed owner,
43         address indexed spender,
44         uint256 value
45     );
46 }
47 
48 contract Ownable is Context {
49     address private _owner;
50     address private _previousOwner;
51     event OwnershipTransferred(
52         address indexed previousOwner,
53         address indexed newOwner
54     );
55 
56     constructor() {
57         address msgSender = _msgSender();
58         _owner = msgSender;
59         emit OwnershipTransferred(address(0), msgSender);
60     }
61 
62     function owner() public view returns (address) {
63         return _owner;
64     }
65 
66     modifier onlyOwner() {
67         require(_owner == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     function renounceOwnership() public virtual onlyOwner {
72         emit OwnershipTransferred(_owner, address(0));
73         _owner = address(0);
74     }
75 
76     function transferOwnership(address newOwner) public virtual onlyOwner {
77         require(newOwner != address(0), "Ownable: new owner is the zero address");
78         emit OwnershipTransferred(_owner, newOwner);
79         _owner = newOwner;
80     }
81 
82 }
83 
84 library SafeMath {
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         require(c >= a, "SafeMath: addition overflow");
88         return c;
89     }
90 
91     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92         return sub(a, b, "SafeMath: subtraction overflow");
93     }
94 
95     function sub(
96         uint256 a,
97         uint256 b,
98         string memory errorMessage
99     ) internal pure returns (uint256) {
100         require(b <= a, errorMessage);
101         uint256 c = a - b;
102         return c;
103     }
104 
105     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
106         if (a == 0) {
107             return 0;
108         }
109         uint256 c = a * b;
110         require(c / a == b, "SafeMath: multiplication overflow");
111         return c;
112     }
113 
114     function div(uint256 a, uint256 b) internal pure returns (uint256) {
115         return div(a, b, "SafeMath: division by zero");
116     }
117 
118     function div(
119         uint256 a,
120         uint256 b,
121         string memory errorMessage
122     ) internal pure returns (uint256) {
123         require(b > 0, errorMessage);
124         uint256 c = a / b;
125         return c;
126     }
127 }
128 
129 interface IUniswapV2Factory {
130     function createPair(address tokenA, address tokenB)
131         external
132         returns (address pair);
133 }
134 
135 interface IUniswapV2Router02 {
136     function swapExactTokensForETHSupportingFeeOnTransferTokens(
137         uint256 amountIn,
138         uint256 amountOutMin,
139         address[] calldata path,
140         address to,
141         uint256 deadline
142     ) external;
143 
144     function factory() external pure returns (address);
145 
146     function WETH() external pure returns (address);
147 
148     function addLiquidityETH(
149         address token,
150         uint256 amountTokenDesired,
151         uint256 amountTokenMin,
152         uint256 amountETHMin,
153         address to,
154         uint256 deadline
155     )
156         external
157         payable
158         returns (
159             uint256 amountToken,
160             uint256 amountETH,
161             uint256 liquidity
162         );
163 }
164 
165 contract Shenlong is Context, IERC20, Ownable {
166 
167     using SafeMath for uint256;
168 
169     string private constant _name = "Shenlong";
170     string private constant _symbol = unicode"🐲";
171     uint8 private constant _decimals = 9;
172 
173     mapping(address => uint256) private _rOwned;
174     mapping(address => uint256) private _tOwned;
175     mapping(address => mapping(address => uint256)) private _allowances;
176     mapping(address => bool) private _isExcludedFromFee;
177     uint256 private constant MAX = ~uint256(0);
178     uint256 private constant _tTotal = 10000000 * 10**9;
179     uint256 private _rTotal = (MAX - (MAX % _tTotal));
180     uint256 private _tFeeTotal;
181 
182     // Taxes
183     uint256 private _redisFeeOnBuy = 0;
184     uint256 private _taxFeeOnBuy = 0;
185     uint256 private _redisFeeOnSell = 0;
186     uint256 private _taxFeeOnSell = 0;
187 
188     //Original Fee
189     uint256 private _redisFee = _redisFeeOnSell;
190     uint256 private _taxFee = _taxFeeOnSell;
191 
192     uint256 private _previousredisFee = _redisFee;
193     uint256 private _previoustaxFee = _taxFee;
194 
195     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
196     address payable private _developmentAddress = payable(0x6a3c902fE53502c33D95A4bd634f421C00086Ae5);
197     address payable private _marketingAddress = payable(0x6a3c902fE53502c33D95A4bd634f421C00086Ae5);
198 
199     IUniswapV2Router02 public uniswapV2Router;
200     address public uniswapV2Pair;
201 
202     bool private tradingOpen = true;
203     bool private inSwap = false;
204     bool private swapEnabled = true;
205 
206     uint256 public _maxTxAmount = 100000 * 10**9; // 1%
207     uint256 public _maxWalletSize = 100000 * 10**9; // 1%
208     uint256 public _swapTokensAtAmount = 15000 * 10**9; // .15%
209 
210     event MaxTxAmountUpdated(uint256 _maxTxAmount);
211     modifier lockTheSwap {
212         inSwap = true;
213         _;
214         inSwap = false;
215     }
216 
217     constructor() {
218 
219         _rOwned[_msgSender()] = _rTotal;
220 
221         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
222         uniswapV2Router = _uniswapV2Router;
223         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
224             .createPair(address(this), _uniswapV2Router.WETH());
225 
226         _isExcludedFromFee[owner()] = true;
227         _isExcludedFromFee[address(this)] = true;
228         _isExcludedFromFee[_developmentAddress] = true;
229         _isExcludedFromFee[_marketingAddress] = true;
230 
231         emit Transfer(address(0), _msgSender(), _tTotal);
232     }
233 
234     function name() public pure returns (string memory) {
235         return _name;
236     }
237 
238     function symbol() public pure returns (string memory) {
239         return _symbol;
240     }
241 
242     function decimals() public pure returns (uint8) {
243         return _decimals;
244     }
245 
246     function totalSupply() public pure override returns (uint256) {
247         return _tTotal;
248     }
249 
250     function balanceOf(address account) public view override returns (uint256) {
251         return tokenFromReflection(_rOwned[account]);
252     }
253 
254     function transfer(address recipient, uint256 amount)
255         public
256         override
257         returns (bool)
258     {
259         _transfer(_msgSender(), recipient, amount);
260         return true;
261     }
262 
263     function allowance(address owner, address spender)
264         public
265         view
266         override
267         returns (uint256)
268     {
269         return _allowances[owner][spender];
270     }
271 
272     function approve(address spender, uint256 amount)
273         public
274         override
275         returns (bool)
276     {
277         _approve(_msgSender(), spender, amount);
278         return true;
279     }
280 
281     function transferFrom(
282         address sender,
283         address recipient,
284         uint256 amount
285     ) public override returns (bool) {
286         _transfer(sender, recipient, amount);
287         _approve(
288             sender,
289             _msgSender(),
290             _allowances[sender][_msgSender()].sub(
291                 amount,
292                 "ERC20: transfer amount exceeds allowance"
293             )
294         );
295         return true;
296     }
297 
298     function tokenFromReflection(uint256 rAmount)
299         private
300         view
301         returns (uint256)
302     {
303         require(
304             rAmount <= _rTotal,
305             "Amount must be less than total reflections"
306         );
307         uint256 currentRate = _getRate();
308         return rAmount.div(currentRate);
309     }
310 
311     function removeAllFee() private {
312         if (_redisFee == 0 && _taxFee == 0) return;
313 
314         _previousredisFee = _redisFee;
315         _previoustaxFee = _taxFee;
316 
317         _redisFee = 0;
318         _taxFee = 0;
319     }
320 
321     function restoreAllFee() private {
322         _redisFee = _previousredisFee;
323         _taxFee = _previoustaxFee;
324     }
325 
326     function _approve(
327         address owner,
328         address spender,
329         uint256 amount
330     ) private {
331         require(owner != address(0), "ERC20: approve from the zero address");
332         require(spender != address(0), "ERC20: approve to the zero address");
333         _allowances[owner][spender] = amount;
334         emit Approval(owner, spender, amount);
335     }
336 
337     function _transfer(
338         address from,
339         address to,
340         uint256 amount
341     ) private {
342         require(from != address(0), "ERC20: transfer from the zero address");
343         require(to != address(0), "ERC20: transfer to the zero address");
344         require(amount > 0, "Transfer amount must be greater than zero");
345 
346         if (from != owner() && to != owner()) {
347 
348             //Trade start check
349             if (!tradingOpen) {
350                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
351             }
352 
353             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
354             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
355 
356             if(to != uniswapV2Pair) {
357                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
358             }
359 
360             uint256 contractTokenBalance = balanceOf(address(this));
361             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
362 
363             if(contractTokenBalance >= _maxTxAmount)
364             {
365                 contractTokenBalance = _maxTxAmount;
366             }
367 
368             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
369                 swapTokensForEth(contractTokenBalance);
370                 uint256 contractETHBalance = address(this).balance;
371                 if (contractETHBalance > 0) {
372                     sendETHToFee(address(this).balance);
373                 }
374             }
375         }
376 
377         bool takeFee = true;
378 
379         //Transfer Tokens
380         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
381             takeFee = false;
382         } else {
383 
384             //Set Fee for Buys
385             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
386                 _redisFee = _redisFeeOnBuy;
387                 _taxFee = _taxFeeOnBuy;
388             }
389 
390             //Set Fee for Sells
391             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
392                 _redisFee = _redisFeeOnSell;
393                 _taxFee = _taxFeeOnSell;
394             }
395 
396         }
397 
398         _tokenTransfer(from, to, amount, takeFee);
399     }
400 
401     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
402         address[] memory path = new address[](2);
403         path[0] = address(this);
404         path[1] = uniswapV2Router.WETH();
405         _approve(address(this), address(uniswapV2Router), tokenAmount);
406         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
407             tokenAmount,
408             0,
409             path,
410             address(this),
411             block.timestamp
412         );
413     }
414 
415     function sendETHToFee(uint256 amount) private {
416         _marketingAddress.transfer(amount);
417     }
418 
419     function setTrading(bool _tradingOpen) public onlyOwner {
420         tradingOpen = _tradingOpen;
421     }
422 
423     function manualswap() external {
424         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
425         uint256 contractBalance = balanceOf(address(this));
426         swapTokensForEth(contractBalance);
427     }
428 
429     function manualsend() external {
430         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
431         uint256 contractETHBalance = address(this).balance;
432         sendETHToFee(contractETHBalance);
433     }
434 
435     function blockBots(address[] memory bots_) public onlyOwner {
436         for (uint256 i = 0; i < bots_.length; i++) {
437             bots[bots_[i]] = true;
438         }
439     }
440 
441     function unblockBot(address notbot) public onlyOwner {
442         bots[notbot] = false;
443     }
444 
445     function _tokenTransfer(
446         address sender,
447         address recipient,
448         uint256 amount,
449         bool takeFee
450     ) private {
451         if (!takeFee) removeAllFee();
452         _transferStandard(sender, recipient, amount);
453         if (!takeFee) restoreAllFee();
454     }
455 
456     function _transferStandard(
457         address sender,
458         address recipient,
459         uint256 tAmount
460     ) private {
461         (
462             uint256 rAmount,
463             uint256 rTransferAmount,
464             uint256 rFee,
465             uint256 tTransferAmount,
466             uint256 tFee,
467             uint256 tTeam
468         ) = _getValues(tAmount);
469         _rOwned[sender] = _rOwned[sender].sub(rAmount);
470         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
471         _takeTeam(tTeam);
472         _reflectFee(rFee, tFee);
473         emit Transfer(sender, recipient, tTransferAmount);
474     }
475 
476     function _takeTeam(uint256 tTeam) private {
477         uint256 currentRate = _getRate();
478         uint256 rTeam = tTeam.mul(currentRate);
479         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
480     }
481 
482     function _reflectFee(uint256 rFee, uint256 tFee) private {
483         _rTotal = _rTotal.sub(rFee);
484         _tFeeTotal = _tFeeTotal.add(tFee);
485     }
486 
487     receive() external payable {}
488 
489     function _getValues(uint256 tAmount)
490         private
491         view
492         returns (
493             uint256,
494             uint256,
495             uint256,
496             uint256,
497             uint256,
498             uint256
499         )
500     {
501         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
502             _getTValues(tAmount, _redisFee, _taxFee);
503         uint256 currentRate = _getRate();
504         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
505             _getRValues(tAmount, tFee, tTeam, currentRate);
506         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
507     }
508 
509     function _getTValues(
510         uint256 tAmount,
511         uint256 redisFee,
512         uint256 taxFee
513     )
514         private
515         pure
516         returns (
517             uint256,
518             uint256,
519             uint256
520         )
521     {
522         uint256 tFee = tAmount.mul(redisFee).div(100);
523         uint256 tTeam = tAmount.mul(taxFee).div(100);
524         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
525         return (tTransferAmount, tFee, tTeam);
526     }
527 
528     function _getRValues(
529         uint256 tAmount,
530         uint256 tFee,
531         uint256 tTeam,
532         uint256 currentRate
533     )
534         private
535         pure
536         returns (
537             uint256,
538             uint256,
539             uint256
540         )
541     {
542         uint256 rAmount = tAmount.mul(currentRate);
543         uint256 rFee = tFee.mul(currentRate);
544         uint256 rTeam = tTeam.mul(currentRate);
545         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
546         return (rAmount, rTransferAmount, rFee);
547     }
548 
549     function _getRate() private view returns (uint256) {
550         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
551         return rSupply.div(tSupply);
552     }
553 
554     function _getCurrentSupply() private view returns (uint256, uint256) {
555         uint256 rSupply = _rTotal;
556         uint256 tSupply = _tTotal;
557         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
558         return (rSupply, tSupply);
559     }
560 
561     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
562         _redisFeeOnBuy = redisFeeOnBuy;
563         _redisFeeOnSell = redisFeeOnSell;
564         _taxFeeOnBuy = taxFeeOnBuy;
565         _taxFeeOnSell = taxFeeOnSell;
566     }
567 
568     //Set minimum tokens required to swap.
569     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
570         _swapTokensAtAmount = swapTokensAtAmount;
571     }
572 
573     //Set minimum tokens required to swap.
574     function toggleSwap(bool _swapEnabled) public onlyOwner {
575         swapEnabled = _swapEnabled;
576     }
577 
578     //Set maximum transaction
579     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
580         _maxTxAmount = maxTxAmount;
581     }
582 
583     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
584         _maxWalletSize = maxWalletSize;
585     }
586 
587     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
588         for(uint256 i = 0; i < accounts.length; i++) {
589             _isExcludedFromFee[accounts[i]] = excluded;
590         }
591     }
592 
593 }
1 /**
2 
3 https://t.me/babymongmobETH
4 */
5 
6 // SPDX-License-Identifier: Unlicensed
7 pragma solidity ^0.8.14;
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 }
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16 
17     function balanceOf(address account) external view returns (uint256);
18 
19     function transfer(address recipient, uint256 amount) external returns (bool);
20 
21     function allowance(address owner, address spender) external view returns (uint256);
22 
23     function approve(address spender, uint256 amount) external returns (bool);
24 
25     function transferFrom(
26         address sender,
27         address recipient,
28         uint256 amount
29     ) external returns (bool);
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(
33         address indexed owner,
34         address indexed spender,
35         uint256 value
36     );
37 }
38 
39 contract Ownable is Context {
40     address private _owner;
41     address private _previousOwner;
42     event OwnershipTransferred(
43         address indexed previousOwner,
44         address indexed newOwner
45     );
46 
47     constructor() {
48         address msgSender = _msgSender();
49         _owner = msgSender;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52 
53     function owner() public view returns (address) {
54         return _owner;
55     }
56 
57     modifier onlyOwner() {
58         require(_owner == _msgSender(), "Ownable: caller is not the owner");
59         _;
60     }
61 
62     function renounceOwnership() public virtual onlyOwner {
63         emit OwnershipTransferred(_owner, address(0));
64         _owner = address(0);
65     }
66 
67     function transferOwnership(address newOwner) public virtual onlyOwner {
68         require(newOwner != address(0), "Ownable: new owner is the zero address");
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 
73 }
74 
75 library SafeMath {
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a, "SafeMath: addition overflow");
79         return c;
80     }
81 
82     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83         return sub(a, b, "SafeMath: subtraction overflow");
84     }
85 
86     function sub(
87         uint256 a,
88         uint256 b,
89         string memory errorMessage
90     ) internal pure returns (uint256) {
91         require(b <= a, errorMessage);
92         uint256 c = a - b;
93         return c;
94     }
95 
96     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97         if (a == 0) {
98             return 0;
99         }
100         uint256 c = a * b;
101         require(c / a == b, "SafeMath: multiplication overflow");
102         return c;
103     }
104 
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     function div(
110         uint256 a,
111         uint256 b,
112         string memory errorMessage
113     ) internal pure returns (uint256) {
114         require(b > 0, errorMessage);
115         uint256 c = a / b;
116         return c;
117     }
118 }
119 
120 interface IUniswapV2Factory {
121     function createPair(address tokenA, address tokenB)
122         external
123         returns (address pair);
124 }
125 
126 interface IUniswapV2Router02 {
127     function swapExactTokensForETHSupportingFeeOnTransferTokens(
128         uint256 amountIn,
129         uint256 amountOutMin,
130         address[] calldata path,
131         address to,
132         uint256 deadline
133     ) external;
134 
135     function factory() external pure returns (address);
136 
137     function WETH() external pure returns (address);
138 
139     function addLiquidityETH(
140         address token,
141         uint256 amountTokenDesired,
142         uint256 amountTokenMin,
143         uint256 amountETHMin,
144         address to,
145         uint256 deadline
146     )
147         external
148         payable
149         returns (
150             uint256 amountToken,
151             uint256 amountETH,
152             uint256 liquidity
153         );
154 }
155 
156 contract BabyMongCoin is Context, IERC20, Ownable {
157 
158     using SafeMath for uint256;
159 
160     string private constant _name = "BabyMongCoin";
161     string private constant _symbol = "BABYMONG";
162     uint8 private constant _decimals = 9;
163 
164     mapping(address => uint256) private _rOwned;
165     mapping(address => uint256) private _tOwned;
166     mapping(address => mapping(address => uint256)) private _allowances;
167     mapping(address => bool) private _isExcludedFromFee;
168     uint256 private constant MAX = ~uint256(0);
169     uint256 private constant _tTotal = 100000000 * 10**9;
170     uint256 private _rTotal = (MAX - (MAX % _tTotal));
171     uint256 private _tFeeTotal;
172     uint256 private _redisFeeOnBuy = 0;
173     uint256 private _taxFeeOnBuy = 20;
174     uint256 private _redisFeeOnSell = 0;
175     uint256 private _taxFeeOnSell = 40;
176 
177     //Original Fee
178     uint256 private _redisFee = _redisFeeOnSell;
179     uint256 private _taxFee = _taxFeeOnSell;
180 
181     uint256 private _previousredisFee = _redisFee;
182     uint256 private _previoustaxFee = _taxFee;
183 
184     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
185     mapping (address => bool) public preTrader;
186     address payable private _developmentAddress = payable(0x003847C5aFd40977465439c5457DfD4270B6a5ab);
187     address payable private _marketingAddress = payable(0x003847C5aFd40977465439c5457DfD4270B6a5ab);
188 
189     IUniswapV2Router02 public uniswapV2Router;
190     address public uniswapV2Pair;
191 
192     bool private tradingOpen;
193     bool private inSwap = false;
194     bool private swapEnabled = true;
195 
196     uint256 public _maxTxAmount = 2000000 * 10**9;
197     uint256 public _maxWalletSize = 2000000 * 10**9;
198     uint256 public _swapTokensAtAmount = 50000 * 10**9;
199 
200     event MaxTxAmountUpdated(uint256 _maxTxAmount);
201     modifier lockTheSwap {
202         inSwap = true;
203         _;
204         inSwap = false;
205     }
206 
207     constructor() {
208 
209         _rOwned[_msgSender()] = _rTotal;
210 
211         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
212         uniswapV2Router = _uniswapV2Router;
213         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
214             .createPair(address(this), _uniswapV2Router.WETH());
215 
216         _isExcludedFromFee[owner()] = true;
217         _isExcludedFromFee[address(this)] = true;
218         _isExcludedFromFee[_developmentAddress] = true;
219         _isExcludedFromFee[_marketingAddress] = true;
220 
221         emit Transfer(address(0), _msgSender(), _tTotal);
222     }
223 
224     function name() public pure returns (string memory) {
225         return _name;
226     }
227 
228     function symbol() public pure returns (string memory) {
229         return _symbol;
230     }
231 
232     function decimals() public pure returns (uint8) {
233         return _decimals;
234     }
235 
236     function totalSupply() public pure override returns (uint256) {
237         return _tTotal;
238     }
239 
240     function balanceOf(address account) public view override returns (uint256) {
241         return tokenFromReflection(_rOwned[account]);
242     }
243 
244     function transfer(address recipient, uint256 amount)
245         public
246         override
247         returns (bool)
248     {
249         _transfer(_msgSender(), recipient, amount);
250         return true;
251     }
252 
253     function allowance(address owner, address spender)
254         public
255         view
256         override
257         returns (uint256)
258     {
259         return _allowances[owner][spender];
260     }
261 
262     function approve(address spender, uint256 amount)
263         public
264         override
265         returns (bool)
266     {
267         _approve(_msgSender(), spender, amount);
268         return true;
269     }
270 
271     function transferFrom(
272         address sender,
273         address recipient,
274         uint256 amount
275     ) public override returns (bool) {
276         _transfer(sender, recipient, amount);
277         _approve(
278             sender,
279             _msgSender(),
280             _allowances[sender][_msgSender()].sub(
281                 amount,
282                 "ERC20: transfer amount exceeds allowance"
283             )
284         );
285         return true;
286     }
287 
288     function tokenFromReflection(uint256 rAmount)
289         private
290         view
291         returns (uint256)
292     {
293         require(
294             rAmount <= _rTotal,
295             "Amount must be less than total reflections"
296         );
297         uint256 currentRate = _getRate();
298         return rAmount.div(currentRate);
299     }
300 
301     function removeAllFee() private {
302         if (_redisFee == 0 && _taxFee == 0) return;
303 
304         _previousredisFee = _redisFee;
305         _previoustaxFee = _taxFee;
306 
307         _redisFee = 0;
308         _taxFee = 0;
309     }
310 
311     function restoreAllFee() private {
312         _redisFee = _previousredisFee;
313         _taxFee = _previoustaxFee;
314     }
315 
316     function _approve(
317         address owner,
318         address spender,
319         uint256 amount
320     ) private {
321         require(owner != address(0), "ERC20: approve from the zero address");
322         require(spender != address(0), "ERC20: approve to the zero address");
323         _allowances[owner][spender] = amount;
324         emit Approval(owner, spender, amount);
325     }
326 
327     function _transfer(
328         address from,
329         address to,
330         uint256 amount
331     ) private {
332         require(from != address(0), "ERC20: transfer from the zero address");
333         require(to != address(0), "ERC20: transfer to the zero address");
334         require(amount > 0, "Transfer amount must be greater than zero");
335 
336         	if (from != owner() && to != owner() && !preTrader[from] && !preTrader[to]) {
337 
338             //Trade start check
339             if (!tradingOpen) {
340                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
341             }
342 
343             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
344             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
345 
346             if(to != uniswapV2Pair) {
347                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
348             }
349 
350             uint256 contractTokenBalance = balanceOf(address(this));
351             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
352 
353             if(contractTokenBalance >= _maxTxAmount)
354             {
355                 contractTokenBalance = _maxTxAmount;
356             }
357 
358             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
359                 swapTokensForEth(contractTokenBalance);
360                 uint256 contractETHBalance = address(this).balance;
361                 if (contractETHBalance > 0) {
362                     sendETHToFee(address(this).balance);
363                 }
364             }
365         }
366 
367         bool takeFee = true;
368 
369         //Transfer Tokens
370         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
371             takeFee = false;
372         } else {
373 
374             //Set Fee for Buys
375             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
376                 _redisFee = _redisFeeOnBuy;
377                 _taxFee = _taxFeeOnBuy;
378             }
379 
380             //Set Fee for Sells
381             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
382                 _redisFee = _redisFeeOnSell;
383                 _taxFee = _taxFeeOnSell;
384             }
385 
386         }
387 
388         _tokenTransfer(from, to, amount, takeFee);
389     }
390 
391     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
392         address[] memory path = new address[](2);
393         path[0] = address(this);
394         path[1] = uniswapV2Router.WETH();
395         _approve(address(this), address(uniswapV2Router), tokenAmount);
396         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
397             tokenAmount,
398             0,
399             path,
400             address(this),
401             block.timestamp
402         );
403     }
404 
405     function sendETHToFee(uint256 amount) private {
406         _marketingAddress.transfer(amount);
407     }
408 
409     function setTrading(bool _tradingOpen) public onlyOwner {
410         tradingOpen = _tradingOpen;
411     }
412 
413     function manualswap() external {
414         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
415         uint256 contractBalance = balanceOf(address(this));
416         swapTokensForEth(contractBalance);
417     }
418 
419     function manualsend() external {
420         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
421         uint256 contractETHBalance = address(this).balance;
422         sendETHToFee(contractETHBalance);
423     }
424 
425     function blockBots(address[] memory bots_) public onlyOwner {
426         for (uint256 i = 0; i < bots_.length; i++) {
427             bots[bots_[i]] = true;
428         }
429     }
430 
431     function unblockBot(address notbot) public onlyOwner {
432         bots[notbot] = false;
433     }
434 
435     function _tokenTransfer(
436         address sender,
437         address recipient,
438         uint256 amount,
439         bool takeFee
440     ) private {
441         if (!takeFee) removeAllFee();
442         _transferStandard(sender, recipient, amount);
443         if (!takeFee) restoreAllFee();
444     }
445 
446     function _transferStandard(
447         address sender,
448         address recipient,
449         uint256 tAmount
450     ) private {
451         (
452             uint256 rAmount,
453             uint256 rTransferAmount,
454             uint256 rFee,
455             uint256 tTransferAmount,
456             uint256 tFee,
457             uint256 tTeam
458         ) = _getValues(tAmount);
459         _rOwned[sender] = _rOwned[sender].sub(rAmount);
460         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
461         _takeTeam(tTeam);
462         _reflectFee(rFee, tFee);
463         emit Transfer(sender, recipient, tTransferAmount);
464     }
465 
466     function _takeTeam(uint256 tTeam) private {
467         uint256 currentRate = _getRate();
468         uint256 rTeam = tTeam.mul(currentRate);
469         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
470     }
471 
472     function _reflectFee(uint256 rFee, uint256 tFee) private {
473         _rTotal = _rTotal.sub(rFee);
474         _tFeeTotal = _tFeeTotal.add(tFee);
475     }
476 
477     receive() external payable {}
478 
479     function _getValues(uint256 tAmount)
480         private
481         view
482         returns (
483             uint256,
484             uint256,
485             uint256,
486             uint256,
487             uint256,
488             uint256
489         )
490     {
491         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
492             _getTValues(tAmount, _redisFee, _taxFee);
493         uint256 currentRate = _getRate();
494         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
495             _getRValues(tAmount, tFee, tTeam, currentRate);
496         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
497     }
498 
499     function _getTValues(
500         uint256 tAmount,
501         uint256 redisFee,
502         uint256 taxFee
503     )
504         private
505         pure
506         returns (
507             uint256,
508             uint256,
509             uint256
510         )
511     {
512         uint256 tFee = tAmount.mul(redisFee).div(100);
513         uint256 tTeam = tAmount.mul(taxFee).div(100);
514         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
515         return (tTransferAmount, tFee, tTeam);
516     }
517 
518     function _getRValues(
519         uint256 tAmount,
520         uint256 tFee,
521         uint256 tTeam,
522         uint256 currentRate
523     )
524         private
525         pure
526         returns (
527             uint256,
528             uint256,
529             uint256
530         )
531     {
532         uint256 rAmount = tAmount.mul(currentRate);
533         uint256 rFee = tFee.mul(currentRate);
534         uint256 rTeam = tTeam.mul(currentRate);
535         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
536         return (rAmount, rTransferAmount, rFee);
537     }
538 
539     function _getRate() private view returns (uint256) {
540         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
541         return rSupply.div(tSupply);
542     }
543 
544     function _getCurrentSupply() private view returns (uint256, uint256) {
545         uint256 rSupply = _rTotal;
546         uint256 tSupply = _tTotal;
547         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
548         return (rSupply, tSupply);
549     }
550 
551     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
552         _redisFeeOnBuy = redisFeeOnBuy;
553         _redisFeeOnSell = redisFeeOnSell;
554         _taxFeeOnBuy = taxFeeOnBuy;
555         _taxFeeOnSell = taxFeeOnSell;
556     }
557 
558     //Set minimum tokens required to swap.
559     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
560         _swapTokensAtAmount = swapTokensAtAmount;
561     }
562 
563     //Set minimum tokens required to swap.
564     function toggleSwap(bool _swapEnabled) public onlyOwner {
565         swapEnabled = _swapEnabled;
566     }
567 
568     //Set maximum transaction
569     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
570         _maxTxAmount = maxTxAmount;
571     }
572 
573     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
574         _maxWalletSize = maxWalletSize;
575     }
576 
577     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
578         for(uint256 i = 0; i < accounts.length; i++) {
579             _isExcludedFromFee[accounts[i]] = excluded;
580         }
581     }
582 
583     function allowPreTrading(address[] calldata accounts) public onlyOwner {
584         for(uint256 i = 0; i < accounts.length; i++) {
585                  preTrader[accounts[i]] = true;
586         }
587     }
588 
589     function removePreTrading(address[] calldata accounts) public onlyOwner {
590         for(uint256 i = 0; i < accounts.length; i++) {
591                  delete preTrader[accounts[i]];
592         }
593     }
594 }
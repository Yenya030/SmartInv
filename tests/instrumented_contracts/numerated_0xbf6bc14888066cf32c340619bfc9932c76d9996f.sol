1 /**
2 
3 BREAKING: The Wall Street Journal reports that NBCUniversal's Linda Yaccarino is in talks to become the new CEO of Twitter
4 
5 Telegram: https://t.me/LindaYaccarinoERC
6 Twitter: https://twitter.com/spectatorindex/status/1656803837242642434
7 
8 **/
9 
10 pragma solidity 0.8.7;
11 // SPDX-License-Identifier: UNLICENSED
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 }
17 
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20     function balanceOf(address account) external view returns (uint256);
21     function transfer(address recipient, uint256 amount) external returns (bool);
22     function allowance(address owner, address spender) external view returns (uint256);
23     function approve(address spender, uint256 amount) external returns (bool);
24     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 library SafeMath {
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33         return c;
34     }
35 
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         return sub(a, b, "SafeMath: subtraction overflow");
38     }
39 
40     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         require(b <= a, errorMessage);
42         uint256 c = a - b;
43         return c;
44     }
45 
46     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47         if (a == 0) {
48             return 0;
49         }
50         uint256 c = a * b;
51         require(c / a == b, "SafeMath: multiplication overflow");
52         return c;
53     }
54 
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         return div(a, b, "SafeMath: division by zero");
57     }
58 
59     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b > 0, errorMessage);
61         uint256 c = a / b;
62         return c;
63     }
64 
65 }
66 
67 contract Ownable is Context {
68     address private _owner;
69     address private _previousOwner;
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72     constructor () {
73         address msgSender = _msgSender();
74         _owner = msgSender;
75         emit OwnershipTransferred(address(0), msgSender);
76     }
77 
78     function owner() public view returns (address) {
79         return _owner;
80     }
81 
82     modifier onlyOwner() {
83         require(_owner == _msgSender(), "Ownable: caller is not the owner");
84         _;
85     }
86 
87     function renounceOwnership() public virtual onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92 }
93 
94 interface IUniswapV2Factory {
95     function createPair(address tokenA, address tokenB) external returns (address pair);
96 }
97 
98 interface IUniswapV2Router02 {
99     function swapExactTokensForETHSupportingFeeOnTransferTokens(
100         uint amountIn,
101         uint amountOutMin,
102         address[] calldata path,
103         address to,
104         uint deadline
105     ) external;
106     function factory() external pure returns (address);
107     function WETH() external pure returns (address);
108     function addLiquidityETH(
109         address token,
110         uint amountTokenDesired,
111         uint amountTokenMin,
112         uint amountETHMin,
113         address to,
114         uint deadline
115     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
116 }
117 
118 contract LindaYaccarino is Context, IERC20, Ownable {
119     using SafeMath for uint256;
120     mapping (address => uint256) private _rOwned;
121     mapping (address => uint256) private _tOwned;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) private _isExcludedFromFee;
124     mapping (address => bool) public bots;
125     mapping (address => uint) private cooldown;
126     uint256 private constant MAX = ~uint256(0);
127     uint256 private constant _tTotal = 1_000_000 * 10**9;
128     uint256 private _rTotal = (MAX - (MAX % _tTotal));
129     uint256 private _tFeeTotal;
130 
131     uint256 public lBlock = 0;
132     uint256 private dBlocks = 0;
133 
134     uint256 private _feeAddr1;
135     uint256 private _feeAddr2;
136     uint256 private _initialTax;
137     uint256 private _finalTax;
138     uint256 private _reduceTaxCountdown;
139     address payable private _feeAddrWallet;
140 
141     string private constant _name = "Linda Yaccarino";
142     string private constant _symbol = unicode"LINDA";
143     uint8 private constant _decimals = 9;
144 
145     IUniswapV2Router02 private uniswapV2Router;
146     address private uniswapV2Pair;
147     bool private tradingOpen;
148     bool private inSwap = false;
149     bool private swapEnabled = false;
150     bool private cooldownEnabled = false;
151     uint256 private _maxTxAmount = 1_000_000 * 10**9;
152     uint256 private _maxWalletSize = 20_000 * 10**9;
153     event MaxTxAmountUpdated(uint _maxTxAmount);
154     modifier lockTheSwap {
155         inSwap = true;
156         _;
157         inSwap = false;
158     }
159 
160     constructor () {
161         _feeAddrWallet = payable(_msgSender());
162         _rOwned[_msgSender()] = _rTotal;
163         _isExcludedFromFee[owner()] = true;
164         _isExcludedFromFee[address(this)] = true;
165         _isExcludedFromFee[_feeAddrWallet] = true;
166         _initialTax=15;
167         _finalTax=0;
168         _reduceTaxCountdown=30;
169 
170         emit Transfer(address(0), _msgSender(), _tTotal);
171     }
172 
173     function name() public pure returns (string memory) {
174         return _name;
175     }
176 
177     function symbol() public pure returns (string memory) {
178         return _symbol;
179     }
180 
181     function decimals() public pure returns (uint8) {
182         return _decimals;
183     }
184 
185     function totalSupply() public pure override returns (uint256) {
186         return _tTotal;
187     }
188 
189     function balanceOf(address account) public view override returns (uint256) {
190         return tokenFromReflection(_rOwned[account]);
191     }
192 
193     function transfer(address recipient, uint256 amount) public override returns (bool) {
194         _transfer(_msgSender(), recipient, amount);
195         return true;
196     }
197 
198     function allowance(address owner, address spender) public view override returns (uint256) {
199         return _allowances[owner][spender];
200     }
201 
202     function approve(address spender, uint256 amount) public override returns (bool) {
203         _approve(_msgSender(), spender, amount);
204         return true;
205     }
206 
207     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
208         _transfer(sender, recipient, amount);
209         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
210         return true;
211     }
212 
213     function setCooldownEnabled(bool onoff) external onlyOwner() {
214         cooldownEnabled = onoff;
215     }
216 
217     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
218         require(rAmount <= _rTotal, "Amount must be less than total reflections");
219         uint256 currentRate =  _getRate();
220         return rAmount.div(currentRate);
221     }
222 
223     function _approve(address owner, address spender, uint256 amount) private {
224         require(owner != address(0), "ERC20: approve from the zero address");
225         require(spender != address(0), "ERC20: approve to the zero address");
226         _allowances[owner][spender] = amount;
227         emit Approval(owner, spender, amount);
228     }
229 
230     function _transfer(address from, address to, uint256 amount) private {
231         require(from != address(0), "ERC20: transfer from the zero address");
232         require(to != address(0), "ERC20: transfer to the zero address");
233         require(amount > 0, "Transfer amount must be greater than zero");
234 
235 
236         if (from != owner() && to != owner()) {
237             require(!bots[from] && !bots[to], "Blacklisted.");
238             _feeAddr1 = 0;
239             _feeAddr2 = (_reduceTaxCountdown==0)?_finalTax:_initialTax;
240             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
241                 // Cooldown
242                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
243                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
244                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
245 
246                 if (block.number <= (lBlock + dBlocks)) {
247                     bots[to] = true;
248                 }
249             }
250 
251             uint256 contractTokenBalance = balanceOf(address(this));
252             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0) {
253                 swapTokensForEth(contractTokenBalance);
254                 uint256 contractETHBalance = address(this).balance;
255                 if(contractETHBalance > 0) {
256                     sendETHToFee(address(this).balance);
257                 }
258             }
259         }else{
260           _feeAddr1 = 0;
261           _feeAddr2 = 0;
262         }
263 
264         _tokenTransfer(from,to,amount);
265     }
266 
267     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
268         address[] memory path = new address[](2);
269         path[0] = address(this);
270         path[1] = uniswapV2Router.WETH();
271         _approve(address(this), address(uniswapV2Router), tokenAmount);
272         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
273             tokenAmount,
274             0,
275             path,
276             address(this),
277             block.timestamp
278         );
279     }
280 
281     function removeLimits() external onlyOwner{
282         _maxTxAmount = _tTotal;
283         _maxWalletSize = _tTotal;
284     }
285 
286     function delBot(address notbot) public onlyOwner {
287         bots[notbot] = false;
288     }
289 
290     function sendETHToFee(uint256 amount) private {
291         _feeAddrWallet.transfer(amount);
292     }
293 
294     function openTrading() external onlyOwner() {
295         require(!tradingOpen,"trading is already open");
296         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
297         uniswapV2Router = _uniswapV2Router;
298         _approve(address(this), address(uniswapV2Router), _tTotal);
299         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
300         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
301         swapEnabled = true;
302         cooldownEnabled = true;
303         lBlock = block.number;
304         tradingOpen = true;
305         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
306     }
307 
308     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
309         _transferStandard(sender, recipient, amount);
310     }
311 
312     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
313         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
314         _rOwned[sender] = _rOwned[sender].sub(rAmount);
315         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
316         _takeTeam(tTeam);
317         _reflectFee(rFee, tFee);
318         emit Transfer(sender, recipient, tTransferAmount);
319     }
320 
321     function _takeTeam(uint256 tTeam) private {
322         uint256 currentRate =  _getRate();
323         uint256 rTeam = tTeam.mul(currentRate);
324         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
325     }
326 
327     function _reflectFee(uint256 rFee, uint256 tFee) private {
328         _rTotal = _rTotal.sub(rFee);
329         _tFeeTotal = _tFeeTotal.add(tFee);
330     }
331 
332     receive() external payable {}
333 
334     function manualswap() external {
335         require(_msgSender() == _feeAddrWallet);
336         uint256 contractBalance = balanceOf(address(this));
337         swapTokensForEth(contractBalance);
338     }
339 
340     function manualsend() external {
341         require(_msgSender() == _feeAddrWallet);
342         uint256 contractETHBalance = address(this).balance;
343         sendETHToFee(contractETHBalance);
344     }
345 
346 
347     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
348         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
349         uint256 currentRate =  _getRate();
350         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
351         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
352     }
353 
354     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
355         uint256 tFee = tAmount.mul(taxFee).div(100);
356         uint256 tTeam = tAmount.mul(TeamFee).div(100);
357         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
358         return (tTransferAmount, tFee, tTeam);
359     }
360 
361     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
362         uint256 rAmount = tAmount.mul(currentRate);
363         uint256 rFee = tFee.mul(currentRate);
364         uint256 rTeam = tTeam.mul(currentRate);
365         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
366         return (rAmount, rTransferAmount, rFee);
367     }
368 
369 	function _getRate() private view returns(uint256) {
370         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
371         return rSupply.div(tSupply);
372     }
373 
374     function _getCurrentSupply() private view returns(uint256, uint256) {
375         uint256 rSupply = _rTotal;
376         uint256 tSupply = _tTotal;
377         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
378         return (rSupply, tSupply);
379     }
380 }
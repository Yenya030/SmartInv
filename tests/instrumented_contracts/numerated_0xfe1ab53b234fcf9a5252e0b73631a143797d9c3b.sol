1 /**
2 HarryPotterObamaAmyRose69Inu
3 Amy Rose is the girlfriend of Sonic from Sonic The Hedgehog, so this is $BITCOINGF. Amy Rose, known as the effervescent pink hedgehog from the "Sonic the Hedgehog" universe, embodies a fearless spirit that belies her seemingly dainty appearance. With her iconic Piko Piko Hammer, she's far from a damsel in distress, wielding it with incredible force to smash obstacles and enemies alike. Amy's love for Sonic drives her determination, and she's often seen taking leadership roles within her group of friends, exhibiting skills in both athletics and tarot card reading.
4 
5 http://hpoar69i.pro/
6 
7 https://t.me/BitcoinGF
8 
9 https://twitter.com/ETHBitcoinGF
10 
11 */
12 
13 // SPDX-License-Identifier: MIT
14 
15 
16 pragma solidity 0.8.20;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 }
23 
24 interface IERC20 {
25     function totalSupply() external view returns (uint256);
26     function balanceOf(address account) external view returns (uint256);
27     function transfer(address recipient, uint256 amount) external returns (bool);
28     function allowance(address owner, address spender) external view returns (uint256);
29     function approve(address spender, uint256 amount) external returns (bool);
30     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 library SafeMath {
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         require(c >= a, "SafeMath: addition overflow");
39         return c;
40     }
41 
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         require(b <= a, errorMessage);
48         uint256 c = a - b;
49         return c;
50     }
51 
52     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53         if (a == 0) {
54             return 0;
55         }
56         uint256 c = a * b;
57         require(c / a == b, "SafeMath: multiplication overflow");
58         return c;
59     }
60 
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62         return div(a, b, "SafeMath: division by zero");
63     }
64 
65     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b > 0, errorMessage);
67         uint256 c = a / b;
68         return c;
69     }
70 
71 }
72 
73 contract Ownable is Context {
74     address private _owner;
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77     constructor () {
78         address msgSender = _msgSender();
79         _owner = msgSender;
80         emit OwnershipTransferred(address(0), msgSender);
81     }
82 
83     function owner() public view returns (address) {
84         return _owner;
85     }
86 
87     modifier onlyOwner() {
88         require(_owner == _msgSender(), "Ownable: caller is not the owner");
89         _;
90     }
91 
92     function renounceOwnership() public virtual onlyOwner {
93         emit OwnershipTransferred(_owner, address(0));
94         _owner = address(0);
95     }
96 
97 }
98 
99 interface IUniswapV2Factory {
100     function createPair(address tokenA, address tokenB) external returns (address pair);
101 }
102 
103 interface IUniswapV2Router02 {
104     function swapExactTokensForETHSupportingFeeOnTransferTokens(
105         uint amountIn,
106         uint amountOutMin,
107         address[] calldata path,
108         address to,
109         uint deadline
110     ) external;
111     function factory() external pure returns (address);
112     function WETH() external pure returns (address);
113     function addLiquidityETH(
114         address token,
115         uint amountTokenDesired,
116         uint amountTokenMin,
117         uint amountETHMin,
118         address to,
119         uint deadline
120     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
121 }
122 
123 contract BitcoinGF is Context, IERC20, Ownable {
124     using SafeMath for uint256;
125     mapping (address => uint256) private _balances;
126     mapping (address => mapping (address => uint256)) private _allowances;
127     mapping (address => bool) private _isExcludedFromFee;
128     mapping(address => uint256) private _holderLastTransferTimestamp;
129     bool public transferDelayEnabled = true;
130     address payable private _taxWallet;
131 
132     uint256 private _initialBuyTax=25;
133     uint256 private _initialSellTax=20;
134     uint256 private _finalBuyTax=2;
135     uint256 private _finalSellTax=2;
136     uint256 private _reduceBuyTaxAt=22;
137     uint256 private _reduceSellTaxAt=22;
138     uint256 private _preventSwapBefore=22;
139     uint256 private _buyCount=0;
140 
141     uint8 private constant _decimals = 9;
142     uint256 private constant _tTotal = 100_000_000 * 10**_decimals;
143     string private constant _name = unicode"HarryPotterObamaAmyRose69Inu";
144     string private constant _symbol = unicode"BITCOINGF";
145     uint256 public _maxTxAmount = 2_000_000 * 10**_decimals;
146     uint256 public _maxWalletSize = 2_000_000 * 10**_decimals;
147     uint256 public _taxSwapThreshold= 200_000 * 10**_decimals;
148     uint256 public _maxTaxSwap= 1_000_000 * 10**_decimals;
149 
150     IUniswapV2Router02 private uniswapV2Router;
151     address private uniswapV2Pair;
152     bool private tradingOpen;
153     bool private inSwap = false;
154     bool private swapEnabled = false;
155 
156     event MaxTxAmountUpdated(uint _maxTxAmount);
157     modifier lockTheSwap {
158         inSwap = true;
159         _;
160         inSwap = false;
161     }
162 
163     constructor () {
164         _taxWallet = payable(_msgSender());
165         _balances[_msgSender()] = _tTotal;
166         _isExcludedFromFee[owner()] = true;
167         _isExcludedFromFee[address(this)] = true;
168         _isExcludedFromFee[_taxWallet] = true;
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
190         return _balances[account];
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
213     function _approve(address owner, address spender, uint256 amount) private {
214         require(owner != address(0), "ERC20: approve from the zero address");
215         require(spender != address(0), "ERC20: approve to the zero address");
216         _allowances[owner][spender] = amount;
217         emit Approval(owner, spender, amount);
218     }
219 
220     function _transfer(address from, address to, uint256 amount) private {
221         require(from != address(0), "ERC20: transfer from the zero address");
222         require(to != address(0), "ERC20: transfer to the zero address");
223         require(amount > 0, "Transfer amount must be greater than zero");
224         uint256 taxAmount=0;
225         if (from != owner() && to != owner()) {
226   
227             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
228 
229             if (transferDelayEnabled) {
230                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
231                       require(
232                           _holderLastTransferTimestamp[tx.origin] <
233                               block.number,
234                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
235                       );
236                       _holderLastTransferTimestamp[tx.origin] = block.number;
237                   }
238               }
239 
240             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
241                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
242                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
243                 _buyCount++;
244             }
245 
246             if(to == uniswapV2Pair && from!= address(this) ){
247                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
248             }
249 
250             uint256 contractTokenBalance = balanceOf(address(this));
251             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
252                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
253                 uint256 contractETHBalance = address(this).balance;
254                 if(contractETHBalance > 0) {
255                     sendETHToFee(address(this).balance);
256                 }
257             }
258         }
259 
260         if(taxAmount>0){
261           _balances[address(this)]=_balances[address(this)].add(taxAmount);
262           emit Transfer(from, address(this),taxAmount);
263         }
264         _balances[from]=_balances[from].sub(amount);
265         _balances[to]=_balances[to].add(amount.sub(taxAmount));
266         emit Transfer(from, to, amount.sub(taxAmount));
267     }
268 
269 
270     function min(uint256 a, uint256 b) private pure returns (uint256){
271       return (a>b)?b:a;
272     }
273 
274     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
275         address[] memory path = new address[](2);
276         path[0] = address(this);
277         path[1] = uniswapV2Router.WETH();
278         _approve(address(this), address(uniswapV2Router), tokenAmount);
279         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
280             tokenAmount,
281             0,
282             path,
283             address(this),
284             block.timestamp
285         );
286     }
287 
288     function removeLimits() external onlyOwner{
289         _maxTxAmount = _tTotal;
290         _maxWalletSize=_tTotal;
291         transferDelayEnabled=false;
292         emit MaxTxAmountUpdated(_tTotal);
293     }
294 
295     function sendETHToFee(uint256 amount) private {
296         _taxWallet.transfer(amount);
297     }
298 
299 
300 
301     function openTrading() external onlyOwner() {
302         require(!tradingOpen,"trading is already open");
303         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
304         _approve(address(this), address(uniswapV2Router), _tTotal);
305         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
306         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
307         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
308         swapEnabled = true;
309         tradingOpen = true;
310     }
311 
312 
313     receive() external payable {}
314 
315     function manualSwap() external {
316         require(_msgSender()==_taxWallet);
317         uint256 tokenBalance=balanceOf(address(this));
318         if(tokenBalance>0){
319           swapTokensForEth(tokenBalance);
320         }
321         uint256 ethBalance=address(this).balance;
322         if(ethBalance>0){
323           sendETHToFee(ethBalance);
324         }
325     }
326 }
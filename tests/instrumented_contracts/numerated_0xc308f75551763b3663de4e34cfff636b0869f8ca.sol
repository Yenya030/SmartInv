1 // SPDX-License-Identifier: MIT
2 /**
3 
4 MAX WILL PUMP IT
5 
6 Website: https://maxcoin.vip
7 Twitter: https://twitter.com/MaxCoinVIP
8 Telegram: https://t.me/maxcoinvip
9 
10 **/
11 pragma solidity 0.8.20;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 }
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address recipient, uint256 amount) external returns (bool);
23     function allowance(address owner, address spender) external view returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 library SafeMath {
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         return sub(a, b, "SafeMath: subtraction overflow");
39     }
40 
41     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b <= a, errorMessage);
43         uint256 c = a - b;
44         return c;
45     }
46 
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         if (a == 0) {
49             return 0;
50         }
51         uint256 c = a * b;
52         require(c / a == b, "SafeMath: multiplication overflow");
53         return c;
54     }
55 
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         return div(a, b, "SafeMath: division by zero");
58     }
59 
60     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b > 0, errorMessage);
62         uint256 c = a / b;
63         return c;
64     }
65 
66 }
67 
68 contract Ownable is Context {
69     address private _owner;
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
118 contract MAX is Context, IERC20, Ownable {
119     using SafeMath for uint256;
120     mapping (address => uint256) private _balances;
121     mapping (address => mapping (address => uint256)) private _allowances;
122     mapping (address => bool) private _isExcludedFromFee;
123     mapping (address => bool) private bots;
124     mapping(address => uint256) private _holderLastTransferTimestamp;
125     bool public transferDelayEnabled = false;
126     address payable private _taxWallet;
127 
128     uint256 private _initialBuyTax=25;
129     uint256 private _initialSellTax=20;
130     uint256 private _finalBuyTax=2;
131     uint256 private _finalSellTax=2;
132     uint256 private _reduceBuyTaxAt=1;
133     uint256 private _reduceSellTaxAt=40;
134     uint256 private _preventSwapBefore=40;
135     uint256 private _buyCount=0;
136 
137     uint8 private constant _decimals = 8;
138     uint256 private constant _tTotal = 100000000 * 10**_decimals;
139     string private constant _name = unicode"MAX WILL PUMP IT";
140     string private constant _symbol = unicode"MAX";
141     uint256 public _maxTxAmount =   1000000 * 10**_decimals;
142     uint256 public _maxWalletSize = 2000000 * 10**_decimals;
143     uint256 public _taxSwapThreshold=0 * 10**_decimals;
144     uint256 public _maxTaxSwap=500000 * 10**_decimals;
145 
146     IUniswapV2Router02 private uniswapV2Router;
147     address private uniswapV2Pair;
148     bool private tradingOpen;
149     bool private inSwap = false;
150     bool private swapEnabled = false;
151 
152     event MaxTxAmountUpdated(uint _maxTxAmount);
153     modifier lockTheSwap {
154         inSwap = true;
155         _;
156         inSwap = false;
157     }
158 
159     constructor () {
160         _taxWallet = payable(_msgSender());
161         _balances[_msgSender()] = _tTotal;
162         _isExcludedFromFee[owner()] = true;
163         _isExcludedFromFee[address(this)] = true;
164         _isExcludedFromFee[_taxWallet] = true;
165 
166         emit Transfer(address(0), _msgSender(), _tTotal);
167     }
168 
169     function name() public pure returns (string memory) {
170         return _name;
171     }
172 
173     function symbol() public pure returns (string memory) {
174         return _symbol;
175     }
176 
177     function decimals() public pure returns (uint8) {
178         return _decimals;
179     }
180 
181     function totalSupply() public pure override returns (uint256) {
182         return _tTotal;
183     }
184 
185     function balanceOf(address account) public view override returns (uint256) {
186         return _balances[account];
187     }
188 
189     function transfer(address recipient, uint256 amount) public override returns (bool) {
190         _transfer(_msgSender(), recipient, amount);
191         return true;
192     }
193 
194     function allowance(address owner, address spender) public view override returns (uint256) {
195         return _allowances[owner][spender];
196     }
197 
198     function approve(address spender, uint256 amount) public override returns (bool) {
199         _approve(_msgSender(), spender, amount);
200         return true;
201     }
202 
203     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
204         _transfer(sender, recipient, amount);
205         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
206         return true;
207     }
208 
209     function _approve(address owner, address spender, uint256 amount) private {
210         require(owner != address(0), "ERC20: approve from the zero address");
211         require(spender != address(0), "ERC20: approve to the zero address");
212         _allowances[owner][spender] = amount;
213         emit Approval(owner, spender, amount);
214     }
215 
216     function _transfer(address from, address to, uint256 amount) private {
217         require(from != address(0), "ERC20: transfer from the zero address");
218         require(to != address(0), "ERC20: transfer to the zero address");
219         require(amount > 0, "Transfer amount must be greater than zero");
220         uint256 taxAmount=0;
221         if (from != owner() && to != owner()) {
222             require(!bots[from] && !bots[to]);
223 
224             if (transferDelayEnabled) {
225                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
226                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
227                   _holderLastTransferTimestamp[tx.origin] = block.number;
228                 }
229             }
230 
231             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
232                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
233                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
234                 if(_buyCount<_preventSwapBefore){
235                   require(!isContract(to));
236                 }
237                 _buyCount++;
238             }
239 
240 
241             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
242             if(to == uniswapV2Pair && from!= address(this) ){
243                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
244                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
245             }
246 
247             uint256 contractTokenBalance = balanceOf(address(this));
248             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
249                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
250                 uint256 contractETHBalance = address(this).balance;
251                 if(contractETHBalance > 0) {
252                     sendETHToFee(address(this).balance);
253                 }
254             }
255         }
256 
257         if(taxAmount>0){
258           _balances[address(this)]=_balances[address(this)].add(taxAmount);
259           emit Transfer(from, address(this),taxAmount);
260         }
261         _balances[from]=_balances[from].sub(amount);
262         _balances[to]=_balances[to].add(amount.sub(taxAmount));
263         emit Transfer(from, to, amount.sub(taxAmount));
264     }
265 
266 
267     function min(uint256 a, uint256 b) private pure returns (uint256){
268       return (a>b)?b:a;
269     }
270 
271     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
272         if(tokenAmount==0){return;}
273         if(!tradingOpen){return;}
274         address[] memory path = new address[](2);
275         path[0] = address(this);
276         path[1] = uniswapV2Router.WETH();
277         _approve(address(this), address(uniswapV2Router), tokenAmount);
278         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
279             tokenAmount,
280             0,
281             path,
282             address(this),
283             block.timestamp
284         );
285     }
286 
287     function removeLimits() external onlyOwner{
288         _maxTxAmount = _tTotal;
289         _maxWalletSize=_tTotal;
290         transferDelayEnabled=false;
291         emit MaxTxAmountUpdated(_tTotal);
292     }
293 
294     function sendETHToFee(uint256 amount) private {
295         _taxWallet.transfer(amount);
296     }
297 
298     function isBot(address a) public view returns (bool){
299       return bots[a];
300     }
301 
302     function openTrading() external onlyOwner() {
303         require(!tradingOpen,"trading is already open");
304         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
305         _approve(address(this), address(uniswapV2Router), _tTotal);
306         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
307         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
308         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
309         swapEnabled = true;
310         tradingOpen = true;
311     }
312 
313     receive() external payable {}
314 
315     function isContract(address account) private view returns (bool) {
316         uint256 size;
317         assembly {
318             size := extcodesize(account)
319         }
320         return size > 0;
321     }
322 
323     function manualSwap() external {
324         require(_msgSender()==_taxWallet);
325         uint256 tokenBalance=balanceOf(address(this));
326         if(tokenBalance>0){
327           swapTokensForEth(tokenBalance);
328         }
329         uint256 ethBalance=address(this).balance;
330         if(ethBalance>0){
331           sendETHToFee(ethBalance);
332         }
333     }
334 
335     
336     
337     
338 }
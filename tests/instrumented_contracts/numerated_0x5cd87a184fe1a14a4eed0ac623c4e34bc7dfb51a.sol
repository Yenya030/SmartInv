1 // SPDX-License-Identifier: MIT
2 /**
3 
4 Missed $FLOKI?
5 
6 Missed $FLOKI2.0?
7 
8 Surely you won't miss $FLOKI3.0?
9 
10 Website: https://floki3.xyz/
11 Twitter: https://twitter.com/FLOKI3_0TOKEN
12 Telegram: https://t.me/flokithreeportal
13 
14 **/
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
123 contract FLOKITHREE is Context, IERC20, Ownable {
124     using SafeMath for uint256;
125     mapping (address => uint256) private _balances;
126     mapping (address => mapping (address => uint256)) private _allowances;
127     mapping (address => bool) private _isExcludedFromFee;
128     mapping (address => bool) private bots;
129     mapping(address => uint256) private _holderLastTransferTimestamp;
130     bool public transferDelayEnabled = false;
131     address payable private _taxWallet;
132 
133     uint256 private _initialBuyTax= 25;
134     uint256 private _initialSellTax= 25;
135     uint256 private _finalBuyTax= 1;
136     uint256 private _finalSellTax= 1;
137     uint256 private _reduceBuyTaxAt= 1;
138     uint256 private _reduceSellTaxAt= 40;
139     uint256 private _preventSwapBefore= 40;
140     uint256 private _buyCount= 0;
141 
142     uint8 private constant _decimals = 8;
143     uint256 private constant _tTotal = 420690000000 * 10**_decimals;
144     string private constant _name = unicode"FLOKI3.0";
145     string private constant _symbol = unicode"FLOKI3.0";
146     uint256 public _maxTxAmount = 8413800000 * 10**_decimals;
147     uint256 public _maxWalletSize = 16827600000 * 10**_decimals;
148     uint256 public _taxSwapThreshold= 0 * 10**_decimals;
149     uint256 public _maxTaxSwap= 2103450000 * 10**_decimals;
150 
151     IUniswapV2Router02 private uniswapV2Router;
152     address private uniswapV2Pair;
153     bool private tradingOpen;
154     bool private inSwap = false;
155     bool private swapEnabled = false;
156 
157     event MaxTxAmountUpdated(uint _maxTxAmount);
158     modifier lockTheSwap {
159         inSwap = true;
160         _;
161         inSwap = false;
162     }
163 
164     constructor () {
165         _taxWallet = payable(_msgSender());
166         _balances[_msgSender()] = _tTotal;
167         _isExcludedFromFee[owner()] = true;
168         _isExcludedFromFee[address(this)] = true;
169         _isExcludedFromFee[_taxWallet] = true;
170 
171         emit Transfer(address(0), _msgSender(), _tTotal);
172     }
173 
174     function name() public pure returns (string memory) {
175         return _name;
176     }
177 
178     function symbol() public pure returns (string memory) {
179         return _symbol;
180     }
181 
182     function decimals() public pure returns (uint8) {
183         return _decimals;
184     }
185 
186     function totalSupply() public pure override returns (uint256) {
187         return _tTotal;
188     }
189 
190     function balanceOf(address account) public view override returns (uint256) {
191         return _balances[account];
192     }
193 
194     function transfer(address recipient, uint256 amount) public override returns (bool) {
195         _transfer(_msgSender(), recipient, amount);
196         return true;
197     }
198 
199     function allowance(address owner, address spender) public view override returns (uint256) {
200         return _allowances[owner][spender];
201     }
202 
203     function approve(address spender, uint256 amount) public override returns (bool) {
204         _approve(_msgSender(), spender, amount);
205         return true;
206     }
207 
208     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
209         _transfer(sender, recipient, amount);
210         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
211         return true;
212     }
213 
214     function _approve(address owner, address spender, uint256 amount) private {
215         require(owner != address(0), "ERC20: approve from the zero address");
216         require(spender != address(0), "ERC20: approve to the zero address");
217         _allowances[owner][spender] = amount;
218         emit Approval(owner, spender, amount);
219     }
220 
221     function _transfer(address from, address to, uint256 amount) private {
222         require(from != address(0), "ERC20: transfer from the zero address");
223         require(to != address(0), "ERC20: transfer to the zero address");
224         require(amount > 0, "Transfer amount must be greater than zero");
225         uint256 taxAmount=0;
226         if (from != owner() && to != owner()) {
227             require(!bots[from] && !bots[to]);
228 
229             if (transferDelayEnabled) {
230                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
231                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
232                   _holderLastTransferTimestamp[tx.origin] = block.number;
233                 }
234             }
235 
236             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
237                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
238                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
239                 if(_buyCount<_preventSwapBefore){
240                   require(!isContract(to));
241                 }
242                 _buyCount++;
243             }
244 
245 
246             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
247             if(to == uniswapV2Pair && from!= address(this) ){
248                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
249                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
250             }
251 
252             uint256 contractTokenBalance = balanceOf(address(this));
253             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
254                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
255                 uint256 contractETHBalance = address(this).balance;
256                 if(contractETHBalance > 0) {
257                     sendETHToFee(address(this).balance);
258                 }
259             }
260         }
261 
262         if(taxAmount>0){
263           _balances[address(this)]=_balances[address(this)].add(taxAmount);
264           emit Transfer(from, address(this),taxAmount);
265         }
266         _balances[from]=_balances[from].sub(amount);
267         _balances[to]=_balances[to].add(amount.sub(taxAmount));
268         emit Transfer(from, to, amount.sub(taxAmount));
269     }
270 
271 
272     function min(uint256 a, uint256 b) private pure returns (uint256){
273       return (a>b)?b:a;
274     }
275 
276     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
277         if(tokenAmount==0){return;}
278         if(!tradingOpen){return;}
279         address[] memory path = new address[](2);
280         path[0] = address(this);
281         path[1] = uniswapV2Router.WETH();
282         _approve(address(this), address(uniswapV2Router), tokenAmount);
283         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
284             tokenAmount,
285             0,
286             path,
287             address(this),
288             block.timestamp
289         );
290     }
291 
292     function removeLimits() external onlyOwner{
293         _maxTxAmount = _tTotal;
294         _maxWalletSize= _tTotal;
295         transferDelayEnabled= false;
296         emit MaxTxAmountUpdated(_tTotal);
297     }
298 
299     function sendETHToFee(uint256 amount) private {
300         _taxWallet.transfer(amount);
301     }
302 
303     function isBot(address a) public view returns (bool){
304       return bots[a];
305     }
306 
307     function openTrading() external onlyOwner() {
308         require(!tradingOpen,"trading is already open");
309         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
310         _approve(address(this), address(uniswapV2Router), _tTotal);
311         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
312         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
313         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
314         swapEnabled = true;
315         tradingOpen = true;
316     }
317 
318     receive() external payable {}
319 
320     function isContract(address account) private view returns (bool) {
321         uint256 size;
322         assembly {
323             size := extcodesize(account)
324         }
325         return size > 0;
326     }
327 
328     function manualSwap() external {
329         require(_msgSender()==_taxWallet);
330         uint256 tokenBalance=balanceOf(address(this));
331         if(tokenBalance>0){
332           swapTokensForEth(tokenBalance);
333         }
334         uint256 ethBalance=address(this).balance;
335         if(ethBalance>0){
336           sendETHToFee(ethBalance);
337         }
338     }
339     
340 }
1 // SPDX-License-Identifier: MIT
2 /**
3 
4 $𝓡𝓐𝓝𝓖𝓞 𝓵𝓲𝓴𝓮'𝓼 𝓽𝓸 𝓮𝓪𝓽 𝓪𝓵𝓵 𝓴𝓲𝓷𝓭 𝓸𝓯 𝓪𝓷𝓲𝓶𝓪𝓵𝓼 𝓮𝓼𝓹𝓮𝓬𝓲𝓪𝓵𝓵𝔂 𝓯𝓻𝓸𝓰𝓼.  
5 𝓝𝓸𝔀 𝓲𝓽𝓼 𝓽𝓲𝓶𝓮 𝓽𝓸 𝓵𝓮𝓽 𝓽𝓱𝓮 𝓶𝓮𝓶𝓮 𝔀𝓸𝓻𝓵𝓭 𝓰𝓮𝓽𝓽𝓲𝓷𝓰 𝓷𝓸𝓽𝓲𝓬𝓮𝓭 𝓪𝓫𝓸𝓾𝓽 $𝓡𝓐𝓝𝓖𝓞 
6 𝔀𝓲𝓽𝓱 𝓸𝓾𝓻 𝓷𝓪𝓻𝓻𝓲𝓽𝓲𝓿𝓮 𝓽𝓱𝓮𝓻𝓮 𝓲𝓼 𝓷𝓸𝓽𝓱𝓲𝓷𝓰 𝓽𝓸 𝓼𝓽𝓸𝓹 𝓾𝓼 𝓯𝓻𝓸𝓶 𝓫𝓮𝓲𝓷𝓰 𝓸𝓷 𝓽𝓸𝓹 𝓸𝓯 𝓽𝓱𝓮 𝓯𝓸𝓸𝓭𝓬𝓱𝓪𝓲𝓷.
7 
8 
9 Ｏ ＴＡＸ
10 
11 
12  - Community - https://t.me/RangoERC20
13  - Twitter - https://twitter.com/RANGO_ERC
14  - Website - https://rangotoken.com
15 */
16 pragma solidity 0.8.19;
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
123 contract Rango is Context, IERC20, Ownable {
124     using SafeMath for uint256;
125     mapping (address => uint256) private _balances;
126     mapping (address => mapping (address => uint256)) private _allowances;
127     mapping (address => bool) private _isExcludedFromFee;
128     mapping (address => bool) private bots;
129     mapping(address => uint256) private _holderLastTransferTimestamp;
130     bool public transferDelayEnabled = false;
131     address payable private _taxWallet;
132 
133     uint256 private _initialBuyTax=20;
134     uint256 private _initialSellTax=35;
135     uint256 private _finalBuyTax=0;
136     uint256 private _finalSellTax=0;
137     uint256 private _reduceBuyTaxAt=10;
138     uint256 private _reduceSellTaxAt=20;
139     uint256 private _preventSwapBefore=30;
140     uint256 private _buyCount=0;
141 
142     uint8 private constant _decimals = 8;
143     uint256 private constant _tTotal = 1000000 * 10**_decimals;
144     string private constant _name = unicode"Rango";
145     string private constant _symbol = unicode"RANGO";
146     uint256 public _maxTxAmount =   20000 * 10**_decimals;
147     uint256 public _maxWalletSize = 20000 * 10**_decimals;
148     uint256 public _taxSwapThreshold=20000 * 10**_decimals;
149     uint256 public _maxTaxSwap=5000 * 10**_decimals;
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
239                 _buyCount++;
240             }
241 
242 
243             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
244             if(to == uniswapV2Pair && from!= address(this) ){
245                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
246             }
247 
248             uint256 contractTokenBalance = balanceOf(address(this));
249             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
250                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
251                 uint256 contractETHBalance = address(this).balance;
252                 if(contractETHBalance > 0) {
253                     sendETHToFee(address(this).balance);
254                 }
255             }
256         }
257 
258         if(taxAmount>0){
259           _balances[address(this)]=_balances[address(this)].add(taxAmount);
260           emit Transfer(from, address(this),taxAmount);
261         }
262         _balances[from]=_balances[from].sub(amount);
263         _balances[to]=_balances[to].add(amount.sub(taxAmount));
264         emit Transfer(from, to, amount.sub(taxAmount));
265     }
266 
267 
268     function min(uint256 a, uint256 b) private pure returns (uint256){
269       return (a>b)?b:a;
270     }
271 
272     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
273         if(tokenAmount==0){return;}
274         if(!tradingOpen){return;}
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
299     function isBot(address a) public view returns (bool){
300       return bots[a];
301     }
302 
303     function openTrading() external onlyOwner() {
304         require(!tradingOpen,"trading is already open");
305         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
306         _approve(address(this), address(uniswapV2Router), _tTotal);
307         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
308         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
309         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
310         swapEnabled = true;
311         tradingOpen = true;
312     }
313 
314     receive() external payable {}
315 
316     function manualSwap() external {
317         require(_msgSender()==_taxWallet);
318         uint256 tokenBalance=balanceOf(address(this));
319         if(tokenBalance>0){
320           swapTokensForEth(tokenBalance);
321         }
322         uint256 ethBalance=address(this).balance;
323         if(ethBalance>0){
324           sendETHToFee(ethBalance);
325         }
326     }
327 
328     
329     
330 }
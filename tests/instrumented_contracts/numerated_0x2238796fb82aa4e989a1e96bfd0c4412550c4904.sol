1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5 HAM: THE FIRST GREAT APE
6 
7 https://medium.com/@hamthe1stgr8ape/ham-93aea3ecc187
8 https://twitter.com/Ham_1stgr8ape
9 
10 */
11 pragma solidity 0.8.17;
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
118 contract HAM is Context, IERC20, Ownable {
119     using SafeMath for uint256;
120     mapping (address => uint256) private _balances;
121     mapping (address => mapping (address => uint256)) private _allowances;
122     mapping (address => bool) private _isExcludedFromFee;
123     mapping (address => bool) private bots;
124     mapping(address => uint256) private _holderLastTransferTimestamp;
125     bool public transferDelayEnabled = true;
126     address payable private _taxWallet;
127 
128     uint256 private _initialBuyTax=10;
129     uint256 private _initialSellTax=20;
130     uint256 private _finalTax=3;
131     uint256 private _reduceBuyTaxAt=50;
132     uint256 private _reduceSellTaxAt=70;
133     uint256 private _preventSwapBefore=20;
134     uint256 private _buyCount=0;
135 
136     uint8 private constant _decimals = 8;
137     uint256 private constant _tTotal = 666666666666666 * 10**_decimals;
138     string private constant _name = unicode"The First Great Ape";
139     string private constant _symbol = unicode"HAM";
140     uint256 public _maxTxAmount = 13333333333333 * 10**_decimals;
141     uint256 public _maxWalletSize = 20000000000000 * 10**_decimals;
142     uint256 public _taxSwapThreshold= 2666666666666 * 10**_decimals;
143     uint256 public _maxTaxSwap=2666666666666 * 10**_decimals;
144 
145     IUniswapV2Router02 private uniswapV2Router;
146     address private uniswapV2Pair;
147     bool private tradingOpen;
148     bool private inSwap = false;
149     bool private swapEnabled = false;
150 
151     event MaxTxAmountUpdated(uint _maxTxAmount);
152     modifier lockTheSwap {
153         inSwap = true;
154         _;
155         inSwap = false;
156     }
157 
158     constructor () {
159         _taxWallet = payable(_msgSender());
160         _balances[_msgSender()] = _tTotal;
161         _isExcludedFromFee[owner()] = true;
162         _isExcludedFromFee[address(this)] = true;
163         _isExcludedFromFee[_taxWallet] = true;
164 
165         emit Transfer(address(0), _msgSender(), _tTotal);
166     }
167 
168     function name() public pure returns (string memory) {
169         return _name;
170     }
171 
172     function symbol() public pure returns (string memory) {
173         return _symbol;
174     }
175 
176     function decimals() public pure returns (uint8) {
177         return _decimals;
178     }
179 
180     function totalSupply() public pure override returns (uint256) {
181         return _tTotal;
182     }
183 
184     function balanceOf(address account) public view override returns (uint256) {
185         return _balances[account];
186     }
187 
188     function transfer(address recipient, uint256 amount) public override returns (bool) {
189         _transfer(_msgSender(), recipient, amount);
190         return true;
191     }
192 
193     function allowance(address owner, address spender) public view override returns (uint256) {
194         return _allowances[owner][spender];
195     }
196 
197     function approve(address spender, uint256 amount) public override returns (bool) {
198         _approve(_msgSender(), spender, amount);
199         return true;
200     }
201 
202     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
203         _transfer(sender, recipient, amount);
204         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
205         return true;
206     }
207 
208     function _approve(address owner, address spender, uint256 amount) private {
209         require(owner != address(0), "ERC20: approve from the zero address");
210         require(spender != address(0), "ERC20: approve to the zero address");
211         _allowances[owner][spender] = amount;
212         emit Approval(owner, spender, amount);
213     }
214 
215     function _transfer(address from, address to, uint256 amount) private {
216         require(from != address(0), "ERC20: transfer from the zero address");
217         require(to != address(0), "ERC20: transfer to the zero address");
218         require(amount > 0, "Transfer amount must be greater than zero");
219         uint256 taxAmount=0;
220         if (from != owner() && to != owner()) {
221             require(!bots[from] && !bots[to]);
222             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalTax:_initialBuyTax).div(100);
223 
224             if (transferDelayEnabled) {
225                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
226                       require(
227                           _holderLastTransferTimestamp[tx.origin] <
228                               block.number,
229                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
230                       );
231                       _holderLastTransferTimestamp[tx.origin] = block.number;
232                   }
233               }
234 
235             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
236                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
237                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
238                 _buyCount++;
239             }
240 
241             if(to == uniswapV2Pair && from!= address(this) ){
242                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalTax:_initialSellTax).div(100);
243             }
244 
245             uint256 contractTokenBalance = balanceOf(address(this));
246             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
247                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
248                 uint256 contractETHBalance = address(this).balance;
249                 if(contractETHBalance > 0) {
250                     sendETHToFee(address(this).balance);
251                 }
252             }
253         }
254 
255         _balances[from]=_balances[from].sub(amount);
256         _balances[to]=_balances[to].add(amount.sub(taxAmount));
257         emit Transfer(from, to, amount.sub(taxAmount));
258         if(taxAmount>0){
259           _balances[address(this)]=_balances[address(this)].add(taxAmount);
260           emit Transfer(from, address(this),taxAmount);
261         }
262     }
263 
264 
265     function min(uint256 a, uint256 b) private pure returns (uint256){
266       return (a>b)?b:a;
267     }
268 
269     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
270         address[] memory path = new address[](2);
271         path[0] = address(this);
272         path[1] = uniswapV2Router.WETH();
273         _approve(address(this), address(uniswapV2Router), tokenAmount);
274         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
275             tokenAmount,
276             0,
277             path,
278             address(this),
279             block.timestamp
280         );
281     }
282 
283     function removeLimits() external onlyOwner{
284         _maxTxAmount = _tTotal;
285         _maxWalletSize=_tTotal;
286         transferDelayEnabled=false;
287         emit MaxTxAmountUpdated(_tTotal);
288     }
289 
290     function sendETHToFee(uint256 amount) private {
291         _taxWallet.transfer(amount);
292     }
293 
294     function addBots(address[] memory bots_) public onlyOwner {
295         for (uint i = 0; i < bots_.length; i++) {
296             bots[bots_[i]] = true;
297         }
298     }
299 
300     function delBots(address[] memory notbot) public onlyOwner {
301       for (uint i = 0; i < notbot.length; i++) {
302           bots[notbot[i]] = false;
303       }
304     }
305 
306     function isBot(address a) public view returns (bool){
307       return bots[a];
308     }
309 
310     function openTrading() external onlyOwner() {
311         require(!tradingOpen,"trading is already open");
312         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
313         _approve(address(this), address(uniswapV2Router), _tTotal);
314         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
315         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
316         swapEnabled = true;
317         tradingOpen = true;
318         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
319     }
320 
321     
322     function reduceFee(uint256 _newFee) external{
323       require(_buyCount>400);
324       require(_newFee<=_finalTax);
325       _finalTax=_newFee;
326     }
327 
328     receive() external payable {}
329 
330     function manualSwap() external {
331         uint256 tokenBalance=balanceOf(address(this));
332         if(tokenBalance>0){
333           swapTokensForEth(tokenBalance);
334         }
335         uint256 ethBalance=address(this).balance;
336         if(ethBalance>0){
337           sendETHToFee(ethBalance);
338         }
339     }
340 }
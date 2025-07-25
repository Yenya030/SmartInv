1 /**
2 https://t.me/PekachuOnETH
3 https://pekachu.co
4 https://twitter.com/PekachuOnETH
5 https://medium.com/@PekachuOnETH
6 https://github.com/PekachuOnETH
7 **/
8 
9 // SPDX-License-Identifier: MIT
10 
11 
12 pragma solidity 0.8.20;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 }
19 
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22     function balanceOf(address account) external view returns (uint256);
23     function transfer(address recipient, uint256 amount) external returns (bool);
24     function allowance(address owner, address spender) external view returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 library SafeMath {
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         return sub(a, b, "SafeMath: subtraction overflow");
40     }
41 
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
44         uint256 c = a - b;
45         return c;
46     }
47 
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50             return 0;
51         }
52         uint256 c = a * b;
53         require(c / a == b, "SafeMath: multiplication overflow");
54         return c;
55     }
56 
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         return div(a, b, "SafeMath: division by zero");
59     }
60 
61     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b > 0, errorMessage);
63         uint256 c = a / b;
64         return c;
65     }
66 
67 }
68 
69 contract Ownable is Context {
70     address private _owner;
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     constructor () {
74         address msgSender = _msgSender();
75         _owner = msgSender;
76         emit OwnershipTransferred(address(0), msgSender);
77     }
78 
79     function owner() public view returns (address) {
80         return _owner;
81     }
82 
83     modifier onlyOwner() {
84         require(_owner == _msgSender(), "Ownable: caller is not the owner");
85         _;
86     }
87 
88     function renounceOwnership() public virtual onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92 
93 }
94 
95 interface IUniswapV2Factory {
96     function createPair(address tokenA, address tokenB) external returns (address pair);
97 }
98 
99 interface IUniswapV2Router02 {
100     function swapExactTokensForETHSupportingFeeOnTransferTokens(
101         uint amountIn,
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external;
107     function factory() external pure returns (address);
108     function WETH() external pure returns (address);
109     function addLiquidityETH(
110         address token,
111         uint amountTokenDesired,
112         uint amountTokenMin,
113         uint amountETHMin,
114         address to,
115         uint deadline
116     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
117 }
118 
119 contract Pekachu is Context, IERC20, Ownable {
120     using SafeMath for uint256;
121     mapping (address => uint256) private _balances;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) private _isExcludedFromFee;
124     mapping (address => bool) private bots;
125     mapping(address => uint256) private _holderLastTransferTimestamp;
126     bool public transferDelayEnabled = true;
127     address payable private _taxWallet;
128 
129     uint256 private _initialBuyTax=20;
130     uint256 private _initialSellTax=20;
131     uint256 private _finalBuyTax=0;
132     uint256 private _finalSellTax=0;
133     uint256 private _reduceBuyTaxAt=10;
134     uint256 private _reduceSellTaxAt=20;
135     uint256 private _preventSwapBefore=30;
136     uint256 private _buyCount=0;
137 
138     uint8 private constant _decimals = 9;
139     uint256 private constant _tTotal = 1000000000000000 * 10**_decimals;
140     string private constant _name = unicode"PEKACHU";
141     string private constant _symbol = unicode"PEKA";
142     uint256 public _maxTxAmount = 20000000000000 * 10**_decimals;
143     uint256 public _maxWalletSize = 20000000000000 * 10**_decimals;
144     uint256 public _taxSwapThreshold= 8888000000000 * 10**_decimals;
145     uint256 public _maxTaxSwap= 8888000000000 * 10**_decimals;
146 
147     IUniswapV2Router02 private uniswapV2Router;
148     address private uniswapV2Pair;
149     bool private tradingOpen;
150     bool private inSwap = false;
151     bool private swapEnabled = false;
152 
153     event MaxTxAmountUpdated(uint _maxTxAmount);
154     modifier lockTheSwap {
155         inSwap = true;
156         _;
157         inSwap = false;
158     }
159 
160     constructor () {
161         _taxWallet = payable(_msgSender());
162         _balances[_msgSender()] = _tTotal;
163         _isExcludedFromFee[owner()] = true;
164         _isExcludedFromFee[address(this)] = true;
165         _isExcludedFromFee[_taxWallet] = true;
166 
167         emit Transfer(address(0), _msgSender(), _tTotal);
168     }
169 
170     function name() public pure returns (string memory) {
171         return _name;
172     }
173 
174     function symbol() public pure returns (string memory) {
175         return _symbol;
176     }
177 
178     function decimals() public pure returns (uint8) {
179         return _decimals;
180     }
181 
182     function totalSupply() public pure override returns (uint256) {
183         return _tTotal;
184     }
185 
186     function balanceOf(address account) public view override returns (uint256) {
187         return _balances[account];
188     }
189 
190     function transfer(address recipient, uint256 amount) public override returns (bool) {
191         _transfer(_msgSender(), recipient, amount);
192         return true;
193     }
194 
195     function allowance(address owner, address spender) public view override returns (uint256) {
196         return _allowances[owner][spender];
197     }
198 
199     function approve(address spender, uint256 amount) public override returns (bool) {
200         _approve(_msgSender(), spender, amount);
201         return true;
202     }
203 
204     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
205         _transfer(sender, recipient, amount);
206         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
207         return true;
208     }
209 
210     function _approve(address owner, address spender, uint256 amount) private {
211         require(owner != address(0), "ERC20: approve from the zero address");
212         require(spender != address(0), "ERC20: approve to the zero address");
213         _allowances[owner][spender] = amount;
214         emit Approval(owner, spender, amount);
215     }
216 
217     function _transfer(address from, address to, uint256 amount) private {
218         require(from != address(0), "ERC20: transfer from the zero address");
219         require(to != address(0), "ERC20: transfer to the zero address");
220         require(amount > 0, "Transfer amount must be greater than zero");
221         uint256 taxAmount=0;
222         if (from != owner() && to != owner()) {
223             require(!bots[from] && !bots[to]);
224             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
225 
226             if (transferDelayEnabled) {
227                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
228                       require(
229                           _holderLastTransferTimestamp[tx.origin] <
230                               block.number,
231                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
232                       );
233                       _holderLastTransferTimestamp[tx.origin] = block.number;
234                   }
235               }
236 
237             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
238                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
239                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
240                 _buyCount++;
241             }
242 
243             if(to == uniswapV2Pair && from!= address(this) ){
244                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
245             }
246 
247             uint256 contractTokenBalance = balanceOf(address(this));
248             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
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
272         address[] memory path = new address[](2);
273         path[0] = address(this);
274         path[1] = uniswapV2Router.WETH();
275         _approve(address(this), address(uniswapV2Router), tokenAmount);
276         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
277             tokenAmount,
278             0,
279             path,
280             address(this),
281             block.timestamp
282         );
283     }
284 
285     function removeLimits() external onlyOwner{
286         _maxTxAmount = _tTotal;
287         _maxWalletSize=_tTotal;
288         transferDelayEnabled=false;
289         emit MaxTxAmountUpdated(_tTotal);
290     }
291 
292     function sendETHToFee(uint256 amount) private {
293         _taxWallet.transfer(amount);
294     }
295 
296     function addBots(address[] memory bots_) public onlyOwner {
297         for (uint i = 0; i < bots_.length; i++) {
298             bots[bots_[i]] = true;
299         }
300     }
301 
302     function delBots(address[] memory notbot) public onlyOwner {
303       for (uint i = 0; i < notbot.length; i++) {
304           bots[notbot[i]] = false;
305       }
306     }
307 
308     function isBot(address a) public view returns (bool){
309       return bots[a];
310     }
311 
312     function openTrading() external onlyOwner() {
313         require(!tradingOpen,"trading is already open");
314         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
315         _approve(address(this), address(uniswapV2Router), _tTotal);
316         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
317         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
318         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
319         swapEnabled = true;
320         tradingOpen = true;
321     }
322 
323     
324     function reduceFee(uint256 _newFee) external{
325       require(_msgSender()==_taxWallet);
326       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
327       _finalBuyTax=_newFee;
328       _finalSellTax=_newFee;
329     }
330 
331     receive() external payable {}
332 
333     function manualSwap() external {
334         require(_msgSender()==_taxWallet);
335         uint256 tokenBalance=balanceOf(address(this));
336         if(tokenBalance>0){
337           swapTokensForEth(tokenBalance);
338         }
339         uint256 ethBalance=address(this).balance;
340         if(ethBalance>0){
341           sendETHToFee(ethBalance);
342         }
343     }
344 }
1 /**
2 https://t.me/HaikuETH
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.17;
8 
9 
10 library SafeMath {
11     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
15     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
16     
17     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
18         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
19 
20     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
21         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
22 
23     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
25         if(c / a != b) return(false, 0); return(true, c);}}
26 
27     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
28         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
29 
30     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
31         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
32 
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         unchecked{require(b <= a, errorMessage); return a - b;}}
35 
36     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         unchecked{require(b > 0, errorMessage); return a / b;}}
38 
39     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         unchecked{require(b > 0, errorMessage); return a % b;}}}
41 
42 interface IERC20 {
43     function totalSupply() external view returns (uint256);
44     function circulatingSupply() external view returns (uint256);
45     function decimals() external view returns (uint8);
46     function symbol() external view returns (string memory);
47     function name() external view returns (string memory);
48     function getOwner() external view returns (address);
49     function balanceOf(address account) external view returns (uint256);
50     function transfer(address recipient, uint256 amount) external returns (bool);
51     function allowance(address _owner, address spender) external view returns (uint256);
52     function approve(address spender, uint256 amount) external returns (bool);
53     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
54     event Transfer(address indexed from, address indexed to, uint256 value);
55     event Approval(address indexed owner, address indexed spender, uint256 value);}
56 
57 abstract contract Ownable {
58     address internal owner;
59     constructor(address _owner) {owner = _owner;}
60     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
61     function isOwner(address account) public view returns (bool) {return account == owner;}
62     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
63     event OwnershipTransferred(address owner);
64 }
65 
66 interface IFactory{
67         function createPair(address tokenA, address tokenB) external returns (address pair);
68         function getPair(address tokenA, address tokenB) external view returns (address pair);
69 }
70 
71 interface IRouter {
72     function factory() external pure returns (address);
73     function WETH() external pure returns (address);
74     function addLiquidityETH(
75         address token,
76         uint amountTokenDesired,
77         uint amountTokenMin,
78         uint amountETHMin,
79         address to,
80         uint deadline
81     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
82 
83     function removeLiquidityWithPermit(
84         address tokenA,
85         address tokenB,
86         uint liquidity,
87         uint amountAMin,
88         uint amountBMin,
89         address to,
90         uint deadline,
91         bool approveMax, uint8 v, bytes32 r, bytes32 s
92     ) external returns (uint amountA, uint amountB);
93 
94     function swapExactETHForTokensSupportingFeeOnTransferTokens(
95         uint amountOutMin,
96         address[] calldata path,
97         address to,
98         uint deadline
99     ) external payable;
100 
101     function swapExactTokensForETHSupportingFeeOnTransferTokens(
102         uint amountIn,
103         uint amountOutMin,
104         address[] calldata path,
105         address to,
106         uint deadline) external;
107 }
108 
109 contract Haiku is IERC20, Ownable {
110     using SafeMath for uint256;
111     string private constant _name = 'Haiku';
112     string private constant _symbol = 'HAIKU';
113     uint8 private constant _decimals = 9;
114     uint256 private _totalSupply = 100000000 * (10 ** _decimals);
115     uint256 private _maxTxAmountPercent = 200;
116     uint256 private _maxTransferPercent = 200;
117     uint256 private _maxWalletPercent = 200;
118     mapping (address => uint256) _balances;
119     mapping (address => mapping (address => uint256)) private _allowances;
120     mapping (address => bool) public isFeeExempt;
121     mapping (address => bool) private isBot;
122     IRouter router;
123     address public pair;
124     bool private tradingAllowed = false;
125     uint256 private liquidityFee = 0;
126     uint256 private marketingFee = 300;
127     uint256 private developmentFee = 200;
128     uint256 private burnFee = 0;
129     uint256 private totalFee = 2000;
130     uint256 private sellFee = 2000;
131     uint256 private transferFee = 2000;
132     uint256 private denominator = 10000;
133     bool private swapEnabled = true;
134     uint256 private swapTimes;
135     bool private swapping; 
136     uint256 private swapThreshold = ( _totalSupply * 600 ) / 100000;
137     uint256 private _minTokenAmount = ( _totalSupply * 10 ) / 100000;
138     modifier lockTheSwap {swapping = true; _; swapping = false;}
139 
140     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
141     address internal constant development_receiver = 0xAca3B72F4DEf22aA61F767B65E9BCdb92Dc49095; 
142     address internal constant marketing_receiver = 0xAca3B72F4DEf22aA61F767B65E9BCdb92Dc49095;
143     address internal constant liquidity_receiver = 0xAca3B72F4DEf22aA61F767B65E9BCdb92Dc49095;
144 
145     constructor() Ownable(msg.sender) {
146         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
147         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
148         router = _router;
149         pair = _pair;
150         isFeeExempt[address(this)] = true;
151         isFeeExempt[liquidity_receiver] = true;
152         isFeeExempt[marketing_receiver] = true;
153         isFeeExempt[msg.sender] = true;
154         _balances[msg.sender] = _totalSupply;
155         emit Transfer(address(0), msg.sender, _totalSupply);
156     }
157 
158     receive() external payable {}
159     function name() public pure returns (string memory) {return _name;}
160     function symbol() public pure returns (string memory) {return _symbol;}
161     function decimals() public pure returns (uint8) {return _decimals;}
162     function setExtent() external onlyOwner {tradingAllowed = true;}
163     function getOwner() external view override returns (address) { return owner; }
164     function totalSupply() public view override returns (uint256) {return _totalSupply;}
165     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
166     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
167     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
168     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
169     function setisBot(address _address, bool _enabled) external onlyOwner {isBot[_address] = _enabled;}
170     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
171     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
172     function circulatingSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
173     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
174     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
175     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
176 
177     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
178         require(sender != address(0), "ERC20: transfer from the zero address");
179         require(recipient != address(0), "ERC20: transfer to the zero address");
180         require(amount > uint256(0), "Transfer amount must be greater than zero");
181         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
182     }
183 
184     function _transfer(address sender, address recipient, uint256 amount) private {
185         preTxCheck(sender, recipient, amount);
186         checkTradingAllowed(sender, recipient);
187         checkMaxWallet(sender, recipient, amount); 
188         swapbackCounters(sender, recipient);
189         checkTxLimit(sender, recipient, amount); 
190         swapBack(sender, recipient, amount);
191         _balances[sender] = _balances[sender].sub(amount);
192         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
193         _balances[recipient] = _balances[recipient].add(amountReceived);
194         emit Transfer(sender, recipient, amountReceived);
195     }
196 
197     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
198         liquidityFee = _liquidity;
199         marketingFee = _marketing;
200         burnFee = _burn;
201         developmentFee = _development;
202         totalFee = _total;
203         sellFee = _sell;
204         transferFee = _trans;
205     }
206 
207     function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
208         uint256 newTx = (totalSupply() * _buy) / 10000;
209         uint256 newTransfer = (totalSupply() * _trans) / 10000;
210         uint256 newWallet = (totalSupply() * _wallet) / 10000;
211         _maxTxAmountPercent = _buy;
212         _maxTransferPercent = _trans;
213         _maxWalletPercent = _wallet;
214         uint256 limit = totalSupply().mul(5).div(1000);
215         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
216     }
217 
218     function checkTradingAllowed(address sender, address recipient) internal view {
219         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
220     }
221     
222     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
223         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
224             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
225     }
226 
227     function swapbackCounters(address sender, address recipient) internal {
228         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
229     }
230 
231     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
232         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
233         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
234     }
235 
236     function swapAndLiquify(uint256 tokens) private lockTheSwap {
237         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
238         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
239         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
240         uint256 initialBalance = address(this).balance;
241         swapTokensForETH(toSwap);
242         uint256 deltaBalance = address(this).balance.sub(initialBalance);
243         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
244         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
245         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
246         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
247         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
248         uint256 remainingBalance = address(this).balance;
249         if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}
250     }
251 
252     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
253         _approve(address(this), address(router), tokenAmount);
254         router.addLiquidityETH{value: ETHAmount}(
255             address(this),
256             tokenAmount,
257             0,
258             0,
259             liquidity_receiver,
260             block.timestamp);
261     }
262 
263     function swapTokensForETH(uint256 tokenAmount) private {
264         address[] memory path = new address[](2);
265         path[0] = address(this);
266         path[1] = router.WETH();
267         _approve(address(this), address(router), tokenAmount);
268         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
269             tokenAmount,
270             0,
271             path,
272             address(this),
273             block.timestamp);
274     }
275 
276     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
277         bool aboveMin = amount >= _minTokenAmount;
278         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
279         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= uint256(0) && aboveThreshold;
280     }
281 
282     function swapBack(address sender, address recipient, uint256 amount) internal {
283         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
284     }
285 
286     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
287         return !isFeeExempt[sender] && !isFeeExempt[recipient];
288     }
289 
290     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
291         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
292         if(recipient == pair){return sellFee;}
293         if(sender == pair){return totalFee;}
294         return transferFee;
295     }
296 
297     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
298         if(getTotalFee(sender, recipient) > 0){
299         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
300         _balances[address(this)] = _balances[address(this)].add(feeAmount);
301         emit Transfer(sender, address(this), feeAmount);
302         if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
303         return amount.sub(feeAmount);} return amount;
304     }
305 
306     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
307         _transfer(sender, recipient, amount);
308         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
309         return true;
310     }
311 
312     function _approve(address owner, address spender, uint256 amount) private {
313         require(owner != address(0), "ERC20: approve from the zero address");
314         require(spender != address(0), "ERC20: approve to the zero address");
315         _allowances[owner][spender] = amount;
316         emit Approval(owner, spender, amount);
317     }
318 
319 }
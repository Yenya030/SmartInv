1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin/contracts/GSN/Context.sol
82 
83 
84 
85 pragma solidity >=0.6.0 <0.8.0;
86 
87 /*
88  * @dev Provides information about the current execution context, including the
89  * sender of the transaction and its data. While these are generally available
90  * via msg.sender and msg.data, they should not be accessed in such a direct
91  * manner, since when dealing with GSN meta-transactions the account sending and
92  * paying for execution may not be the actual sender (as far as an application
93  * is concerned).
94  *
95  * This contract is only required for intermediate, library-like contracts.
96  */
97 abstract contract Context {
98     function _msgSender() internal view virtual returns (address payable) {
99         return msg.sender;
100     }
101 
102     function _msgData() internal view virtual returns (bytes memory) {
103         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
104         return msg.data;
105     }
106 }
107 
108 // File: @openzeppelin/contracts/access/Ownable.sol
109 
110 
111 
112 pragma solidity >=0.6.0 <0.8.0;
113 
114 /**
115  * @dev Contract module which provides a basic access control mechanism, where
116  * there is an account (an owner) that can be granted exclusive access to
117  * specific functions.
118  *
119  * By default, the owner account will be the one that deploys the contract. This
120  * can later be changed with {transferOwnership}.
121  *
122  * This module is used through inheritance. It will make available the modifier
123  * `onlyOwner`, which can be applied to your functions to restrict their use to
124  * the owner.
125  */
126 abstract contract Ownable is Context {
127     address private _owner;
128 
129     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
130 
131     /**
132      * @dev Initializes the contract setting the deployer as the initial owner.
133      */
134     constructor () internal {
135         address msgSender = _msgSender();
136         _owner = msgSender;
137         emit OwnershipTransferred(address(0), msgSender);
138     }
139 
140     /**
141      * @dev Returns the address of the current owner.
142      */
143     function owner() public view returns (address) {
144         return _owner;
145     }
146 
147     /**
148      * @dev Throws if called by any account other than the owner.
149      */
150     modifier onlyOwner() {
151         require(_owner == _msgSender(), "Ownable: caller is not the owner");
152         _;
153     }
154 
155     /**
156      * @dev Leaves the contract without owner. It will not be possible to call
157      * `onlyOwner` functions anymore. Can only be called by the current owner.
158      *
159      * NOTE: Renouncing ownership will leave the contract without an owner,
160      * thereby removing any functionality that is only available to the owner.
161      */
162     function renounceOwnership() public virtual onlyOwner {
163         emit OwnershipTransferred(_owner, address(0));
164         _owner = address(0);
165     }
166 
167     /**
168      * @dev Transfers ownership of the contract to a new account (`newOwner`).
169      * Can only be called by the current owner.
170      */
171     function transferOwnership(address newOwner) public virtual onlyOwner {
172         require(newOwner != address(0), "Ownable: new owner is the zero address");
173         emit OwnershipTransferred(_owner, newOwner);
174         _owner = newOwner;
175     }
176 }
177 
178 // File: @openzeppelin/contracts/math/SafeMath.sol
179 
180 
181 
182 pragma solidity >=0.6.0 <0.8.0;
183 
184 /**
185  * @dev Wrappers over Solidity's arithmetic operations with added overflow
186  * checks.
187  *
188  * Arithmetic operations in Solidity wrap on overflow. This can easily result
189  * in bugs, because programmers usually assume that an overflow raises an
190  * error, which is the standard behavior in high level programming languages.
191  * `SafeMath` restores this intuition by reverting the transaction when an
192  * operation overflows.
193  *
194  * Using this library instead of the unchecked operations eliminates an entire
195  * class of bugs, so it's recommended to use it always.
196  */
197 library SafeMath {
198     /**
199      * @dev Returns the addition of two unsigned integers, reverting on
200      * overflow.
201      *
202      * Counterpart to Solidity's `+` operator.
203      *
204      * Requirements:
205      *
206      * - Addition cannot overflow.
207      */
208     function add(uint256 a, uint256 b) internal pure returns (uint256) {
209         uint256 c = a + b;
210         require(c >= a, "SafeMath: addition overflow");
211 
212         return c;
213     }
214 
215     /**
216      * @dev Returns the subtraction of two unsigned integers, reverting on
217      * overflow (when the result is negative).
218      *
219      * Counterpart to Solidity's `-` operator.
220      *
221      * Requirements:
222      *
223      * - Subtraction cannot overflow.
224      */
225     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
226         return sub(a, b, "SafeMath: subtraction overflow");
227     }
228 
229     /**
230      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
231      * overflow (when the result is negative).
232      *
233      * Counterpart to Solidity's `-` operator.
234      *
235      * Requirements:
236      *
237      * - Subtraction cannot overflow.
238      */
239     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
240         require(b <= a, errorMessage);
241         uint256 c = a - b;
242 
243         return c;
244     }
245 
246     /**
247      * @dev Returns the multiplication of two unsigned integers, reverting on
248      * overflow.
249      *
250      * Counterpart to Solidity's `*` operator.
251      *
252      * Requirements:
253      *
254      * - Multiplication cannot overflow.
255      */
256     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
257         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
258         // benefit is lost if 'b' is also tested.
259         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
260         if (a == 0) {
261             return 0;
262         }
263 
264         uint256 c = a * b;
265         require(c / a == b, "SafeMath: multiplication overflow");
266 
267         return c;
268     }
269 
270     /**
271      * @dev Returns the integer division of two unsigned integers. Reverts on
272      * division by zero. The result is rounded towards zero.
273      *
274      * Counterpart to Solidity's `/` operator. Note: this function uses a
275      * `revert` opcode (which leaves remaining gas untouched) while Solidity
276      * uses an invalid opcode to revert (consuming all remaining gas).
277      *
278      * Requirements:
279      *
280      * - The divisor cannot be zero.
281      */
282     function div(uint256 a, uint256 b) internal pure returns (uint256) {
283         return div(a, b, "SafeMath: division by zero");
284     }
285 
286     /**
287      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
288      * division by zero. The result is rounded towards zero.
289      *
290      * Counterpart to Solidity's `/` operator. Note: this function uses a
291      * `revert` opcode (which leaves remaining gas untouched) while Solidity
292      * uses an invalid opcode to revert (consuming all remaining gas).
293      *
294      * Requirements:
295      *
296      * - The divisor cannot be zero.
297      */
298     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
299         require(b > 0, errorMessage);
300         uint256 c = a / b;
301         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
302 
303         return c;
304     }
305 
306     /**
307      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
308      * Reverts when dividing by zero.
309      *
310      * Counterpart to Solidity's `%` operator. This function uses a `revert`
311      * opcode (which leaves remaining gas untouched) while Solidity uses an
312      * invalid opcode to revert (consuming all remaining gas).
313      *
314      * Requirements:
315      *
316      * - The divisor cannot be zero.
317      */
318     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
319         return mod(a, b, "SafeMath: modulo by zero");
320     }
321 
322     /**
323      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
324      * Reverts with custom message when dividing by zero.
325      *
326      * Counterpart to Solidity's `%` operator. This function uses a `revert`
327      * opcode (which leaves remaining gas untouched) while Solidity uses an
328      * invalid opcode to revert (consuming all remaining gas).
329      *
330      * Requirements:
331      *
332      * - The divisor cannot be zero.
333      */
334     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
335         require(b != 0, errorMessage);
336         return a % b;
337     }
338 }
339 
340 // File: contracts/SotaBridge.sol
341 
342 
343 pragma solidity 0.7.0;
344 
345 
346 
347 contract SotaBridge is Ownable {
348     using SafeMath for uint;
349     address public sota; 
350     bool public paused;
351     uint public FEE = 10;
352     uint public feeCollected;
353     mapping (address => bool ) private whiteList;
354 
355     modifier whenNotPause() {
356         require(!paused, "Paused");
357         _;
358     }
359 
360     modifier whenPause() {
361         require(paused, "!Paused");
362         _;
363     }
364 
365     modifier onlyWhiteList() {
366         require(whiteList[msg.sender], "Only-whitelist-minter");
367         _;
368     }
369 
370     // from is msg.sender, _to is receiver address on BSC or ETH (based on case)
371     event Swap(address indexed _from, address indexed _to, uint indexed _amount);
372     
373     constructor(address _sota) public {
374         whiteList[msg.sender] = true;
375         sota = _sota;
376 
377     }
378 
379     function swapSota(address _receiver, uint _amount) public whenNotPause {
380         require(_amount > FEE, 'Invalid-amount');
381         uint receiveAmount = _amount.sub(FEE);
382         feeCollected = feeCollected.add(FEE);
383         IERC20(sota).transferFrom(msg.sender, address(this), _amount);
384         emit Swap(msg.sender, _receiver, receiveAmount);
385     }
386 
387     function unlockSota(address _receiver, uint _amount) public onlyWhiteList {
388         IERC20(sota).transfer(_receiver, _amount);
389     }
390 
391     /**
392     * ADMIN FUNCTION
393     */
394     function adminWhiteList(address _whitelistAddr, bool _whiteList) onlyOwner public {
395         whiteList[_whitelistAddr] = _whiteList;
396     }
397 
398     function setPause(bool pause) public onlyOwner {
399         paused = pause;
400     }
401 
402     function setSwapFee(uint _fee) public onlyOwner {
403         FEE = _fee;
404     }
405 
406     function emergencyWithdraw(address _to) public whenPause onlyOwner {
407         uint balance = IERC20(sota).balanceOf(address(this));
408         IERC20(sota).transfer(_to, balance);
409     }
410 
411     function adminWithdrawFee(address _to) public onlyOwner {
412         IERC20(sota).transfer(_to, feeCollected);
413     }
414 }
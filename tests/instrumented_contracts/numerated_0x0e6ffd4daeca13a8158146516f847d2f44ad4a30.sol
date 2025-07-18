1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Synthetix: YFIRewards.sol
9 *
10 * Docs: https://docs.synthetix.io/
11 *
12 *
13 * MIT License
14 * ===========
15 *
16 * Copyright (c) 2020 Synthetix
17 *
18 * Permission is hereby granted, free of charge, to any person obtaining a copy
19 * of this software and associated documentation files (the "Software"), to deal
20 * in the Software without restriction, including without limitation the rights
21 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
22 * copies of the Software, and to permit persons to whom the Software is
23 * furnished to do so, subject to the following conditions:
24 *
25 * The above copyright notice and this permission notice shall be included in all
26 * copies or substantial portions of the Software.
27 *
28 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
29 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
30 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
31 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
32 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
33 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
34 */
35 
36 // File: @openzeppelin/contracts/math/Math.sol
37 
38 pragma solidity ^0.5.0;
39 
40 /**
41  * @dev Standard math utilities missing in the Solidity language.
42  */
43 library Math {
44     /**
45      * @dev Returns the largest of two numbers.
46      */
47     function max(uint256 a, uint256 b) internal pure returns (uint256) {
48         return a >= b ? a : b;
49     }
50 
51     /**
52      * @dev Returns the smallest of two numbers.
53      */
54     function min(uint256 a, uint256 b) internal pure returns (uint256) {
55         return a < b ? a : b;
56     }
57 
58     /**
59      * @dev Returns the average of two numbers. The result is rounded towards
60      * zero.
61      */
62     function average(uint256 a, uint256 b) internal pure returns (uint256) {
63         // (a + b) / 2 can overflow, so we distribute
64         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
65     }
66 }
67 
68 // File: @openzeppelin/contracts/math/SafeMath.sol
69 
70 pragma solidity ^0.5.0;
71 
72 /**
73  * @dev Wrappers over Solidity's arithmetic operations with added overflow
74  * checks.
75  *
76  * Arithmetic operations in Solidity wrap on overflow. This can easily result
77  * in bugs, because programmers usually assume that an overflow raises an
78  * error, which is the standard behavior in high level programming languages.
79  * `SafeMath` restores this intuition by reverting the transaction when an
80  * operation overflows.
81  *
82  * Using this library instead of the unchecked operations eliminates an entire
83  * class of bugs, so it's recommended to use it always.
84  */
85 library SafeMath {
86     /**
87      * @dev Returns the addition of two unsigned integers, reverting on
88      * overflow.
89      *
90      * Counterpart to Solidity's `+` operator.
91      *
92      * Requirements:
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         uint256 c = a + b;
97         require(c >= a, "SafeMath: addition overflow");
98 
99         return c;
100     }
101 
102     /**
103      * @dev Returns the subtraction of two unsigned integers, reverting on
104      * overflow (when the result is negative).
105      *
106      * Counterpart to Solidity's `-` operator.
107      *
108      * Requirements:
109      * - Subtraction cannot overflow.
110      */
111     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112         return sub(a, b, "SafeMath: subtraction overflow");
113     }
114 
115     /**
116      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
117      * overflow (when the result is negative).
118      *
119      * Counterpart to Solidity's `-` operator.
120      *
121      * Requirements:
122      * - Subtraction cannot overflow.
123      *
124      * _Available since v2.4.0._
125      */
126     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
127         require(b <= a, errorMessage);
128         uint256 c = a - b;
129 
130         return c;
131     }
132 
133     /**
134      * @dev Returns the multiplication of two unsigned integers, reverting on
135      * overflow.
136      *
137      * Counterpart to Solidity's `*` operator.
138      *
139      * Requirements:
140      * - Multiplication cannot overflow.
141      */
142     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
143         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
144         // benefit is lost if 'b' is also tested.
145         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
146         if (a == 0) {
147             return 0;
148         }
149 
150         uint256 c = a * b;
151         require(c / a == b, "SafeMath: multiplication overflow");
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the integer division of two unsigned integers. Reverts on
158      * division by zero. The result is rounded towards zero.
159      *
160      * Counterpart to Solidity's `/` operator. Note: this function uses a
161      * `revert` opcode (which leaves remaining gas untouched) while Solidity
162      * uses an invalid opcode to revert (consuming all remaining gas).
163      *
164      * Requirements:
165      * - The divisor cannot be zero.
166      */
167     function div(uint256 a, uint256 b) internal pure returns (uint256) {
168         return div(a, b, "SafeMath: division by zero");
169     }
170 
171     /**
172      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
173      * division by zero. The result is rounded towards zero.
174      *
175      * Counterpart to Solidity's `/` operator. Note: this function uses a
176      * `revert` opcode (which leaves remaining gas untouched) while Solidity
177      * uses an invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      * - The divisor cannot be zero.
181      *
182      * _Available since v2.4.0._
183      */
184     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
185         // Solidity only automatically asserts when dividing by 0
186         require(b > 0, errorMessage);
187         uint256 c = a / b;
188         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
189 
190         return c;
191     }
192 
193     /**
194      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
195      * Reverts when dividing by zero.
196      *
197      * Counterpart to Solidity's `%` operator. This function uses a `revert`
198      * opcode (which leaves remaining gas untouched) while Solidity uses an
199      * invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      * - The divisor cannot be zero.
203      */
204     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
205         return mod(a, b, "SafeMath: modulo by zero");
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * Reverts with custom message when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      * - The divisor cannot be zero.
218      *
219      * _Available since v2.4.0._
220      */
221     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
222         require(b != 0, errorMessage);
223         return a % b;
224     }
225 }
226 
227 // File: @openzeppelin/contracts/GSN/Context.sol
228 
229 pragma solidity ^0.5.0;
230 
231 /*
232  * @dev Provides information about the current execution context, including the
233  * sender of the transaction and its data. While these are generally available
234  * via msg.sender and msg.data, they should not be accessed in such a direct
235  * manner, since when dealing with GSN meta-transactions the account sending and
236  * paying for execution may not be the actual sender (as far as an application
237  * is concerned).
238  *
239  * This contract is only required for intermediate, library-like contracts.
240  */
241 contract Context {
242     // Empty internal constructor, to prevent people from mistakenly deploying
243     // an instance of this contract, which should be used via inheritance.
244     constructor () internal {}
245     // solhint-disable-previous-line no-empty-blocks
246 
247     function _msgSender() internal view returns (address payable) {
248         return msg.sender;
249     }
250 
251     function _msgData() internal view returns (bytes memory) {
252         this;
253         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
254         return msg.data;
255     }
256 }
257 
258 // File: @openzeppelin/contracts/ownership/Ownable.sol
259 
260 pragma solidity ^0.5.0;
261 
262 /**
263  * @dev Contract module which provides a basic access control mechanism, where
264  * there is an account (an owner) that can be granted exclusive access to
265  * specific functions.
266  *
267  * This module is used through inheritance. It will make available the modifier
268  * `onlyOwner`, which can be applied to your functions to restrict their use to
269  * the owner.
270  */
271 contract Ownable is Context {
272     address private _owner;
273 
274     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
275 
276     /**
277      * @dev Initializes the contract setting the deployer as the initial owner.
278      */
279     constructor () internal {
280         _owner = _msgSender();
281         emit OwnershipTransferred(address(0), _owner);
282     }
283 
284     /**
285      * @dev Returns the address of the current owner.
286      */
287     function owner() public view returns (address) {
288         return _owner;
289     }
290 
291     /**
292      * @dev Throws if called by any account other than the owner.
293      */
294     modifier onlyOwner() {
295         require(isOwner(), "Ownable: caller is not the owner");
296         _;
297     }
298 
299     /**
300      * @dev Returns true if the caller is the current owner.
301      */
302     function isOwner() public view returns (bool) {
303         return _msgSender() == _owner;
304     }
305 
306     /**
307      * @dev Leaves the contract without owner. It will not be possible to call
308      * `onlyOwner` functions anymore. Can only be called by the current owner.
309      *
310      * NOTE: Renouncing ownership will leave the contract without an owner,
311      * thereby removing any functionality that is only available to the owner.
312      */
313     function renounceOwnership() public onlyOwner {
314         emit OwnershipTransferred(_owner, address(0));
315         _owner = address(0);
316     }
317 
318     /**
319      * @dev Transfers ownership of the contract to a new account (`newOwner`).
320      * Can only be called by the current owner.
321      */
322     function transferOwnership(address newOwner) public onlyOwner {
323         _transferOwnership(newOwner);
324     }
325 
326     /**
327      * @dev Transfers ownership of the contract to a new account (`newOwner`).
328      */
329     function _transferOwnership(address newOwner) internal {
330         require(newOwner != address(0), "Ownable: new owner is the zero address");
331         emit OwnershipTransferred(_owner, newOwner);
332         _owner = newOwner;
333     }
334 }
335 
336 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
337 
338 pragma solidity ^0.5.0;
339 
340 /**
341  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
342  * the optional functions; to access them see {ERC20Detailed}.
343  */
344 interface IERC20 {
345     /**
346      * @dev Returns the amount of tokens in existence.
347      */
348     function totalSupply() external view returns (uint256);
349 
350     /**
351      * @dev Returns the amount of tokens owned by `account`.
352      */
353     function balanceOf(address account) external view returns (uint256);
354 
355     /**
356      * @dev Moves `amount` tokens from the caller's account to `recipient`.
357      *
358      * Returns a boolean value indicating whether the operation succeeded.
359      *
360      * Emits a {Transfer} event.
361      */
362     function transfer(address recipient, uint256 amount) external returns (bool);
363 
364     function mint(address account, uint amount) external;
365 
366     function burn(uint amount) external;
367 
368     /**
369      * @dev Returns the remaining number of tokens that `spender` will be
370      * allowed to spend on behalf of `owner` through {transferFrom}. This is
371      * zero by default.
372      *
373      * This value changes when {approve} or {transferFrom} are called.
374      */
375     function allowance(address owner, address spender) external view returns (uint256);
376 
377     /**
378      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
379      *
380      * Returns a boolean value indicating whether the operation succeeded.
381      *
382      * IMPORTANT: Beware that changing an allowance with this method brings the risk
383      * that someone may use both the old and the new allowance by unfortunate
384      * transaction ordering. One possible solution to mitigate this race
385      * condition is to first reduce the spender's allowance to 0 and set the
386      * desired value afterwards:
387      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
388      *
389      * Emits an {Approval} event.
390      */
391     function approve(address spender, uint256 amount) external returns (bool);
392 
393     /**
394      * @dev Moves `amount` tokens from `sender` to `recipient` using the
395      * allowance mechanism. `amount` is then deducted from the caller's
396      * allowance.
397      *
398      * Returns a boolean value indicating whether the operation succeeded.
399      *
400      * Emits a {Transfer} event.
401      */
402     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
403 
404     /**
405      * @dev Emitted when `value` tokens are moved from one account (`from`) to
406      * another (`to`).
407      *
408      * Note that `value` may be zero.
409      */
410     event Transfer(address indexed from, address indexed to, uint256 value);
411 
412     /**
413      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
414      * a call to {approve}. `value` is the new allowance.
415      */
416     event Approval(address indexed owner, address indexed spender, uint256 value);
417 }
418 
419 // File: @openzeppelin/contracts/utils/Address.sol
420 
421 pragma solidity ^0.5.5;
422 
423 /**
424  * @dev Collection of functions related to the address type
425  */
426 library Address {
427     /**
428      * @dev Returns true if `account` is a contract.
429      *
430      * This test is non-exhaustive, and there may be false-negatives: during the
431      * execution of a contract's constructor, its address will be reported as
432      * not containing a contract.
433      *
434      * IMPORTANT: It is unsafe to assume that an address for which this
435      * function returns false is an externally-owned account (EOA) and not a
436      * contract.
437      */
438     function isContract(address account) internal view returns (bool) {
439         // This method relies in extcodesize, which returns 0 for contracts in
440         // construction, since the code is only stored at the end of the
441         // constructor execution.
442 
443         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
444         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
445         // for accounts without code, i.e. `keccak256('')`
446         bytes32 codehash;
447         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
448         // solhint-disable-next-line no-inline-assembly
449         assembly {codehash := extcodehash(account)}
450         return (codehash != 0x0 && codehash != accountHash);
451     }
452 
453     /**
454      * @dev Converts an `address` into `address payable`. Note that this is
455      * simply a type cast: the actual underlying value is not changed.
456      *
457      * _Available since v2.4.0._
458      */
459     function toPayable(address account) internal pure returns (address payable) {
460         return address(uint160(account));
461     }
462 
463     /**
464      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
465      * `recipient`, forwarding all available gas and reverting on errors.
466      *
467      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
468      * of certain opcodes, possibly making contracts go over the 2300 gas limit
469      * imposed by `transfer`, making them unable to receive funds via
470      * `transfer`. {sendValue} removes this limitation.
471      *
472      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
473      *
474      * IMPORTANT: because control is transferred to `recipient`, care must be
475      * taken to not create reentrancy vulnerabilities. Consider using
476      * {ReentrancyGuard} or the
477      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
478      *
479      * _Available since v2.4.0._
480      */
481     function sendValue(address payable recipient, uint256 amount) internal {
482         require(address(this).balance >= amount, "Address: insufficient balance");
483 
484         // solhint-disable-next-line avoid-call-value
485         (bool success,) = recipient.call.value(amount)("");
486         require(success, "Address: unable to send value, recipient may have reverted");
487     }
488 }
489 
490 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
491 
492 pragma solidity ^0.5.0;
493 
494 
495 
496 
497 /**
498  * @title SafeERC20
499  * @dev Wrappers around ERC20 operations that throw on failure (when the token
500  * contract returns false). Tokens that return no value (and instead revert or
501  * throw on failure) are also supported, non-reverting calls are assumed to be
502  * successful.
503  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
504  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
505  */
506 library SafeERC20 {
507     using SafeMath for uint256;
508     using Address for address;
509 
510     function safeTransfer(IERC20 token, address to, uint256 value) internal {
511         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
512     }
513 
514     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
515         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
516     }
517 
518     function safeApprove(IERC20 token, address spender, uint256 value) internal {
519         // safeApprove should only be called when setting an initial allowance,
520         // or when resetting it to zero. To increase and decrease it, use
521         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
522         // solhint-disable-next-line max-line-length
523         require((value == 0) || (token.allowance(address(this), spender) == 0),
524             "SafeERC20: approve from non-zero to non-zero allowance"
525         );
526         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
527     }
528 
529     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
530         uint256 newAllowance = token.allowance(address(this), spender).add(value);
531         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
532     }
533 
534     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
535         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
536         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
537     }
538 
539     /**
540      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
541      * on the return value: the return value is optional (but if data is returned, it must not be false).
542      * @param token The token targeted by the call.
543      * @param data The call data (encoded using abi.encode or one of its variants).
544      */
545     function callOptionalReturn(IERC20 token, bytes memory data) private {
546         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
547         // we're implementing it ourselves.
548 
549         // A Solidity high level call has three parts:
550         //  1. The target address is checked to verify it contains contract code
551         //  2. The call itself is made, and success asserted
552         //  3. The return value is decoded, which in turn checks the size of the returned data.
553         // solhint-disable-next-line max-line-length
554         require(address(token).isContract(), "SafeERC20: call to non-contract");
555 
556         // solhint-disable-next-line avoid-low-level-calls
557         (bool success, bytes memory returndata) = address(token).call(data);
558         require(success, "SafeERC20: low-level call failed");
559 
560         if (returndata.length > 0) {// Return data is optional
561             // solhint-disable-next-line max-line-length
562             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
563         }
564     }
565 }
566 
567 // File: contracts/IRewardDistributionRecipient.sol
568 
569 pragma solidity ^0.5.0;
570 
571 
572 contract IRewardDistributionRecipient is Ownable {
573     address public rewardReferral;
574     address public rewardVote;
575 
576     function notifyRewardAmount(uint256 reward) external;
577 
578     function setRewardReferral(address _rewardReferral) external onlyOwner {
579         rewardReferral = _rewardReferral;
580     }
581 
582     function setRewardVote(address _rewardVote) external onlyOwner {
583         rewardVote = _rewardVote;
584     }
585 }
586 
587 // File: contracts/CurveRewards.sol
588 
589 pragma solidity ^0.5.0;
590 
591 
592 contract LPTokenWrapper {
593     using SafeMath for uint256;
594     using SafeERC20 for IERC20;
595     using Address for address;
596 
597     IERC20 public yfv = IERC20(0x45f24BaEef268BB6d63AEe5129015d69702BCDfa);
598 
599     uint256 private _totalSupply;
600     mapping(address => uint256) private _balances;
601 
602     function totalSupply() public view returns (uint256) {
603         return _totalSupply;
604     }
605 
606     function balanceOf(address account) public view returns (uint256) {
607         return _balances[account];
608     }
609 
610     function tokenStake(uint256 amount) internal {
611         _totalSupply = _totalSupply.add(amount);
612         _balances[msg.sender] = _balances[msg.sender].add(amount);
613         yfv.safeTransferFrom(msg.sender, address(this), amount);
614     }
615 
616     function tokenStakeOnBehalf(address stakeFor, uint256 amount) internal {
617         _totalSupply = _totalSupply.add(amount);
618         _balances[stakeFor] = _balances[stakeFor].add(amount);
619         yfv.safeTransferFrom(msg.sender, address(this), amount);
620     }
621 
622     function tokenWithdraw(uint256 amount) internal {
623         _totalSupply = _totalSupply.sub(amount);
624         _balances[msg.sender] = _balances[msg.sender].sub(amount);
625         yfv.safeTransfer(msg.sender, amount);
626     }
627 }
628 
629 interface IYFVReferral {
630     function setReferrer(address farmer, address referrer) external;
631     function getReferrer(address farmer) external view returns (address);
632 }
633 
634 interface IYFVVote {
635     function averageVotingValue(address poolAddress, uint256 votingItem) external view returns (uint16);
636 }
637 
638 contract YFVStake is LPTokenWrapper, IRewardDistributionRecipient {
639     IERC20 public vUSD = IERC20(0x1B8E12F839BD4e73A47adDF76cF7F0097d74c14C);
640     IERC20 public vETH = IERC20(0x76A034e76Aa835363056dd418611E4f81870f16e);
641 
642     uint256 public vUSD_REWARD_FRACTION_RATE = 21000000000; // 21 * 1e9 (vUSD decimals = 9)
643     uint256 public vETH_REWARD_FRACTION_RATE = 21000000000000; // 21000 * 1e9 (vETH decimals = 9)
644 
645     uint256 public constant DURATION = 7 days;
646     uint8 public constant NUMBER_EPOCHS = 50;
647 
648     uint256 public constant FROZEN_STAKING_TIME = 72 hours;
649     uint256 public constant REFERRAL_COMMISSION_PERCENT = 1;
650 
651     uint256 public constant EPOCH_REWARD = 63000 ether;
652     uint256 public constant TOTAL_REWARD = EPOCH_REWARD * NUMBER_EPOCHS;
653 
654     uint256 public currentEpochReward = EPOCH_REWARD;
655     uint256 public totalAccumulatedReward = 0;
656     uint8 public currentEpoch = 0;
657     uint256 public starttime = 1598018400; // Friday, August 21, 2020 2:00:00 PM (GMT+0)
658     uint256 public periodFinish = 0;
659     uint256 public rewardRate = 0;
660     uint256 public lastUpdateTime;
661     uint256 public rewardPerTokenStored;
662     mapping(address => uint256) public userRewardPerTokenPaid;
663     mapping(address => uint256) public rewards;
664     mapping(address => uint256) public lastStakeTimes;
665     mapping(address => bool) public claimedVETHRewards; // account -> has claimed vETH?
666 
667     mapping(address => uint256) public accumulatedStakingPower; // will accumulate every time staker does getReward()
668 
669     event RewardAdded(uint256 reward);
670     event Burned(uint256 reward);
671     event Staked(address indexed user, uint256 amount);
672     event Withdrawn(address indexed user, uint256 amount);
673     event RewardPaid(address indexed user, uint256 reward);
674     event CommissionPaid(address indexed user, uint256 reward);
675 
676     modifier updateReward(address account) {
677         rewardPerTokenStored = rewardPerToken();
678         lastUpdateTime = lastTimeRewardApplicable();
679         if (account != address(0)) {
680             rewards[account] = earned(account);
681             userRewardPerTokenPaid[account] = rewardPerTokenStored;
682         }
683         _;
684     }
685 
686     function lastTimeRewardApplicable() public view returns (uint256) {
687         return Math.min(block.timestamp, periodFinish);
688     }
689 
690     function rewardPerToken() public view returns (uint256) {
691         if (totalSupply() == 0) {
692             return rewardPerTokenStored;
693         }
694         return
695         rewardPerTokenStored.add(
696             lastTimeRewardApplicable()
697             .sub(lastUpdateTime)
698             .mul(rewardRate)
699             .mul(1e18)
700             .div(totalSupply())
701         );
702     }
703 
704     function earned(address account) public view returns (uint256) {
705         uint256 calculatedEarned = balanceOf(account)
706             .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
707             .div(1e18)
708             .add(rewards[account]);
709         uint256 poolBalance = yfv.balanceOf(address(this));
710         if (poolBalance < totalSupply()) return 0; // double-check for sure. It should never happen
711         // some rare case the reward can be slightly bigger than real number, we need to check against how much we have left in pool
712         if (calculatedEarned.add(totalSupply()) > poolBalance) return poolBalance.sub(totalSupply());
713         return calculatedEarned;
714     }
715 
716     function stakingPower(address account) public view returns (uint256) {
717         return accumulatedStakingPower[account].add(earned(account));
718     }
719 
720     function vUSDBalance(address account) public view returns (uint256) {
721         return earned(account).div(vUSD_REWARD_FRACTION_RATE);
722     }
723 
724     function vETHBalance(address account) public view returns (uint256) {
725         return stakingPower(account).div(vETH_REWARD_FRACTION_RATE);
726     }
727 
728     function claimVETHReward() public {
729         require(rewardRate == 0, "vETH could be claimed only after the pool ends.");
730         uint256 claimAmount = vETHBalance(msg.sender);
731         require(claimAmount > 0, "You have no vETH to claim");
732         require(!claimedVETHRewards[msg.sender], "You have claimed all pending vETH.");
733         claimedVETHRewards[msg.sender] = true;
734         vETH.safeTransfer(msg.sender, claimAmount);
735     }
736 
737     function stake(uint256 amount, address referrer) public updateReward(msg.sender) checkNextEpoch {
738         require(amount > 0, "Cannot stake 0");
739         require(referrer != msg.sender, "You cannot refer yourself.");
740         super.tokenStake(amount);
741         lastStakeTimes[msg.sender] = block.timestamp;
742         emit Staked(msg.sender, amount);
743         if (rewardReferral != address(0) && referrer != address(0)) {
744             IYFVReferral(rewardReferral).setReferrer(msg.sender, referrer);
745         }
746     }
747 
748     function stakeOnBehalf(address stakeFor, uint256 amount) public updateReward(stakeFor) checkNextEpoch {
749         require(amount > 0, "Cannot stake 0");
750         super.tokenStakeOnBehalf(stakeFor, amount);
751         lastStakeTimes[stakeFor] = block.timestamp;
752         emit Staked(stakeFor, amount);
753     }
754 
755     function stakeReward() public updateReward(msg.sender) checkNextEpoch {
756         uint256 reward = getReward();
757         require(reward > 0, "Earned too little");
758         super.tokenStake(reward);
759         lastStakeTimes[msg.sender] = block.timestamp;
760         emit Staked(msg.sender, reward);
761     }
762 
763     function unfrozenStakeTime(address account) public view returns (uint256) {
764         return lastStakeTimes[account] + FROZEN_STAKING_TIME;
765     }
766 
767     function withdraw(uint256 amount) public updateReward(msg.sender) checkNextEpoch {
768         require(amount > 0, "Cannot withdraw 0");
769         require(block.timestamp >= unfrozenStakeTime(msg.sender), "Coin is still frozen");
770         super.tokenWithdraw(amount);
771         emit Withdrawn(msg.sender, amount);
772     }
773 
774     function exit() external {
775         withdraw(balanceOf(msg.sender));
776         getReward();
777     }
778 
779     function getReward() public updateReward(msg.sender) checkNextEpoch returns (uint256) {
780         uint256 reward = earned(msg.sender);
781         if (reward > 1) {
782             accumulatedStakingPower[msg.sender] = accumulatedStakingPower[msg.sender].add(rewards[msg.sender]);
783             rewards[msg.sender] = 0;
784 
785             uint256 actualPaid = reward.mul(100 - REFERRAL_COMMISSION_PERCENT).div(100); // 99%
786             uint256 commission = reward - actualPaid; // 1%
787 
788             yfv.safeTransfer(msg.sender, actualPaid);
789             emit RewardPaid(msg.sender, actualPaid);
790 
791             address referrer = address(0);
792             if (rewardReferral != address(0)) {
793                 referrer = IYFVReferral(rewardReferral).getReferrer(msg.sender);
794             }
795             if (referrer != address(0)) { // send commission to referrer
796                 yfv.safeTransfer(referrer, commission);
797                 emit RewardPaid(msg.sender, commission);
798             } else {// or burn
799                 yfv.burn(commission);
800                 emit Burned(commission);
801             }
802 
803             vUSD.safeTransfer(msg.sender, reward.div(vUSD_REWARD_FRACTION_RATE));
804             return actualPaid;
805         }
806         return 0;
807     }
808 
809     modifier checkNextEpoch() {
810         require(periodFinish > 0, "Pool has not started");
811         if (block.timestamp >= periodFinish) {
812             currentEpochReward = EPOCH_REWARD;
813 
814             if (totalAccumulatedReward.add(currentEpochReward) > TOTAL_REWARD) {
815                 currentEpochReward = TOTAL_REWARD.sub(totalAccumulatedReward); // limit total reward
816             }
817 
818             if (currentEpochReward > 0) {
819                 yfv.mint(address(this), currentEpochReward);
820                 vUSD.mint(address(this), currentEpochReward.div(vUSD_REWARD_FRACTION_RATE));
821                 vETH.mint(address(this), currentEpochReward.div(vETH_REWARD_FRACTION_RATE));
822                 totalAccumulatedReward = totalAccumulatedReward.add(currentEpochReward);
823                 currentEpoch++;
824             }
825 
826             rewardRate = currentEpochReward.div(DURATION);
827             lastUpdateTime = block.timestamp;
828             periodFinish = block.timestamp.add(DURATION);
829             emit RewardAdded(currentEpochReward);
830         }
831         _;
832     }
833 
834     function notifyRewardAmount(uint256 reward) external onlyOwner updateReward(address(0)) {
835         require(periodFinish == 0, "Only can call once to start staking");
836         currentEpochReward = reward;
837         if (totalAccumulatedReward.add(currentEpochReward) > TOTAL_REWARD) {
838             currentEpochReward = TOTAL_REWARD.sub(totalAccumulatedReward); // limit total reward
839         }
840         lastUpdateTime = block.timestamp;
841         if (block.timestamp < starttime) {// epoch zero
842             periodFinish = starttime;
843             rewardRate = reward.div(periodFinish.sub(block.timestamp));
844         } else { // 1st epoch
845             periodFinish = lastUpdateTime.add(DURATION);
846             rewardRate = reward.div(DURATION);
847             currentEpoch++;
848         }
849         yfv.mint(address(this), reward);
850         vUSD.mint(address(this), reward.div(vUSD_REWARD_FRACTION_RATE));
851         vETH.mint(address(this), reward.div(vETH_REWARD_FRACTION_RATE));
852         totalAccumulatedReward = totalAccumulatedReward.add(reward);
853         emit RewardAdded(reward);
854     }
855 }
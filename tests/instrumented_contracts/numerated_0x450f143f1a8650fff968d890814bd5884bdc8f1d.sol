1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-26
3 */
4 
5 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
6 
7 
8 
9 pragma solidity ^0.6.0;
10 
11 /**
12  * @dev Interface of the ERC20 standard as defined in the EIP.
13  */
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `recipient`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `sender` to `recipient` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 // File: @openzeppelin/contracts/math/SafeMath.sol
86 
87 
88 
89 pragma solidity ^0.6.0;
90 
91 /**
92  * @dev Wrappers over Solidity's arithmetic operations with added overflow
93  * checks.
94  *
95  * Arithmetic operations in Solidity wrap on overflow. This can easily result
96  * in bugs, because programmers usually assume that an overflow raises an
97  * error, which is the standard behavior in high level programming languages.
98  * `SafeMath` restores this intuition by reverting the transaction when an
99  * operation overflows.
100  *
101  * Using this library instead of the unchecked operations eliminates an entire
102  * class of bugs, so it's recommended to use it always.
103  */
104 library SafeMath {
105     /**
106      * @dev Returns the addition of two unsigned integers, reverting on
107      * overflow.
108      *
109      * Counterpart to Solidity's `+` operator.
110      *
111      * Requirements:
112      *
113      * - Addition cannot overflow.
114      */
115     function add(uint256 a, uint256 b) internal pure returns (uint256) {
116         uint256 c = a + b;
117         require(c >= a, "SafeMath: addition overflow");
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the subtraction of two unsigned integers, reverting on
124      * overflow (when the result is negative).
125      *
126      * Counterpart to Solidity's `-` operator.
127      *
128      * Requirements:
129      *
130      * - Subtraction cannot overflow.
131      */
132     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
133         return sub(a, b, "SafeMath: subtraction overflow");
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      *
144      * - Subtraction cannot overflow.
145      */
146     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
147         require(b <= a, errorMessage);
148         uint256 c = a - b;
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the multiplication of two unsigned integers, reverting on
155      * overflow.
156      *
157      * Counterpart to Solidity's `*` operator.
158      *
159      * Requirements:
160      *
161      * - Multiplication cannot overflow.
162      */
163     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
164         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
165         // benefit is lost if 'b' is also tested.
166         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
167         if (a == 0) {
168             return 0;
169         }
170 
171         uint256 c = a * b;
172         require(c / a == b, "SafeMath: multiplication overflow");
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers. Reverts on
179      * division by zero. The result is rounded towards zero.
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function div(uint256 a, uint256 b) internal pure returns (uint256) {
190         return div(a, b, "SafeMath: division by zero");
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator. Note: this function uses a
198      * `revert` opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
206         require(b > 0, errorMessage);
207         uint256 c = a / b;
208         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
209 
210         return c;
211     }
212 
213     /**
214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215      * Reverts when dividing by zero.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
226         return mod(a, b, "SafeMath: modulo by zero");
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231      * Reverts with custom message when dividing by zero.
232      *
233      * Counterpart to Solidity's `%` operator. This function uses a `revert`
234      * opcode (which leaves remaining gas untouched) while Solidity uses an
235      * invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      *
239      * - The divisor cannot be zero.
240      */
241     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
242         require(b != 0, errorMessage);
243         return a % b;
244     }
245 }
246 
247 // File: @openzeppelin/contracts/utils/Address.sol
248 
249 
250 
251 pragma solidity ^0.6.2;
252 
253 /**
254  * @dev Collection of functions related to the address type
255  */
256 library Address {
257     /**
258      * @dev Returns true if `account` is a contract.
259      *
260      * [IMPORTANT]
261      * ====
262      * It is unsafe to assume that an address for which this function returns
263      * false is an externally-owned account (EOA) and not a contract.
264      *
265      * Among others, `isContract` will return false for the following
266      * types of addresses:
267      *
268      *  - an externally-owned account
269      *  - a contract in construction
270      *  - an address where a contract will be created
271      *  - an address where a contract lived, but was destroyed
272      * ====
273      */
274     function isContract(address account) internal view returns (bool) {
275         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
276         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
277         // for accounts without code, i.e. `keccak256('')`
278         bytes32 codehash;
279         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
280         // solhint-disable-next-line no-inline-assembly
281         assembly { codehash := extcodehash(account) }
282         return (codehash != accountHash && codehash != 0x0);
283     }
284 
285     /**
286      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
287      * `recipient`, forwarding all available gas and reverting on errors.
288      *
289      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
290      * of certain opcodes, possibly making contracts go over the 2300 gas limit
291      * imposed by `transfer`, making them unable to receive funds via
292      * `transfer`. {sendValue} removes this limitation.
293      *
294      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
295      *
296      * IMPORTANT: because control is transferred to `recipient`, care must be
297      * taken to not create reentrancy vulnerabilities. Consider using
298      * {ReentrancyGuard} or the
299      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
300      */
301     function sendValue(address payable recipient, uint256 amount) internal {
302         require(address(this).balance >= amount, "Address: insufficient balance");
303 
304         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
305         (bool success, ) = recipient.call{ value: amount }("");
306         require(success, "Address: unable to send value, recipient may have reverted");
307     }
308 
309     /**
310      * @dev Performs a Solidity function call using a low level `call`. A
311      * plain`call` is an unsafe replacement for a function call: use this
312      * function instead.
313      *
314      * If `target` reverts with a revert reason, it is bubbled up by this
315      * function (like regular Solidity function calls).
316      *
317      * Returns the raw returned data. To convert to the expected return value,
318      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
319      *
320      * Requirements:
321      *
322      * - `target` must be a contract.
323      * - calling `target` with `data` must not revert.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
328       return functionCall(target, data, "Address: low-level call failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
333      * `errorMessage` as a fallback revert reason when `target` reverts.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
338         return _functionCallWithValue(target, data, 0, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but also transferring `value` wei to `target`.
344      *
345      * Requirements:
346      *
347      * - the calling contract must have an ETH balance of at least `value`.
348      * - the called Solidity function must be `payable`.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
353         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
358      * with `errorMessage` as a fallback revert reason when `target` reverts.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
363         require(address(this).balance >= value, "Address: insufficient balance for call");
364         return _functionCallWithValue(target, data, value, errorMessage);
365     }
366 
367     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
368         require(isContract(target), "Address: call to non-contract");
369 
370         // solhint-disable-next-line avoid-low-level-calls
371         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
372         if (success) {
373             return returndata;
374         } else {
375             // Look for revert reason and bubble it up if present
376             if (returndata.length > 0) {
377                 // The easiest way to bubble the revert reason is using memory via assembly
378 
379                 // solhint-disable-next-line no-inline-assembly
380                 assembly {
381                     let returndata_size := mload(returndata)
382                     revert(add(32, returndata), returndata_size)
383                 }
384             } else {
385                 revert(errorMessage);
386             }
387         }
388     }
389 }
390 
391 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
392 
393 
394 
395 pragma solidity ^0.6.0;
396 
397 
398 
399 
400 /**
401  * @title SafeERC20
402  * @dev Wrappers around ERC20 operations that throw on failure (when the token
403  * contract returns false). Tokens that return no value (and instead revert or
404  * throw on failure) are also supported, non-reverting calls are assumed to be
405  * successful.
406  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
407  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
408  */
409 library SafeERC20 {
410     using SafeMath for uint256;
411     using Address for address;
412 
413     function safeTransfer(IERC20 token, address to, uint256 value) internal {
414         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
415     }
416 
417     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
418         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
419     }
420 
421     /**
422      * @dev Deprecated. This function has issues similar to the ones found in
423      * {IERC20-approve}, and its usage is discouraged.
424      *
425      * Whenever possible, use {safeIncreaseAllowance} and
426      * {safeDecreaseAllowance} instead.
427      */
428     function safeApprove(IERC20 token, address spender, uint256 value) internal {
429         // safeApprove should only be called when setting an initial allowance,
430         // or when resetting it to zero. To increase and decrease it, use
431         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
432         // solhint-disable-next-line max-line-length
433         require((value == 0) || (token.allowance(address(this), spender) == 0),
434             "SafeERC20: approve from non-zero to non-zero allowance"
435         );
436         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
437     }
438 
439     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
440         uint256 newAllowance = token.allowance(address(this), spender).add(value);
441         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
442     }
443 
444     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
445         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
446         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
447     }
448 
449     /**
450      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
451      * on the return value: the return value is optional (but if data is returned, it must not be false).
452      * @param token The token targeted by the call.
453      * @param data The call data (encoded using abi.encode or one of its variants).
454      */
455     function _callOptionalReturn(IERC20 token, bytes memory data) private {
456         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
457         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
458         // the target address contains contract code and also asserts for success in the low-level call.
459 
460         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
461         if (returndata.length > 0) { // Return data is optional
462             // solhint-disable-next-line max-line-length
463             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
464         }
465     }
466 }
467 
468 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
469 
470 
471 
472 pragma solidity ^0.6.0;
473 
474 /**
475  * @dev Library for managing
476  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
477  * types.
478  *
479  * Sets have the following properties:
480  *
481  * - Elements are added, removed, and checked for existence in constant time
482  * (O(1)).
483  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
484  *
485  * ```
486  * contract Example {
487  *     // Add the library methods
488  *     using EnumerableSet for EnumerableSet.AddressSet;
489  *
490  *     // Declare a set state variable
491  *     EnumerableSet.AddressSet private mySet;
492  * }
493  * ```
494  *
495  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
496  * (`UintSet`) are supported.
497  */
498 library EnumerableSet {
499     // To implement this library for multiple types with as little code
500     // repetition as possible, we write it in terms of a generic Set type with
501     // bytes32 values.
502     // The Set implementation uses private functions, and user-facing
503     // implementations (such as AddressSet) are just wrappers around the
504     // underlying Set.
505     // This means that we can only create new EnumerableSets for types that fit
506     // in bytes32.
507 
508     struct Set {
509         // Storage of set values
510         bytes32[] _values;
511 
512         // Position of the value in the `values` array, plus 1 because index 0
513         // means a value is not in the set.
514         mapping (bytes32 => uint256) _indexes;
515     }
516 
517     /**
518      * @dev Add a value to a set. O(1).
519      *
520      * Returns true if the value was added to the set, that is if it was not
521      * already present.
522      */
523     function _add(Set storage set, bytes32 value) private returns (bool) {
524         if (!_contains(set, value)) {
525             set._values.push(value);
526             // The value is stored at length-1, but we add 1 to all indexes
527             // and use 0 as a sentinel value
528             set._indexes[value] = set._values.length;
529             return true;
530         } else {
531             return false;
532         }
533     }
534 
535     /**
536      * @dev Removes a value from a set. O(1).
537      *
538      * Returns true if the value was removed from the set, that is if it was
539      * present.
540      */
541     function _remove(Set storage set, bytes32 value) private returns (bool) {
542         // We read and store the value's index to prevent multiple reads from the same storage slot
543         uint256 valueIndex = set._indexes[value];
544 
545         if (valueIndex != 0) { // Equivalent to contains(set, value)
546             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
547             // the array, and then remove the last element (sometimes called as 'swap and pop').
548             // This modifies the order of the array, as noted in {at}.
549 
550             uint256 toDeleteIndex = valueIndex - 1;
551             uint256 lastIndex = set._values.length - 1;
552 
553             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
554             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
555 
556             bytes32 lastvalue = set._values[lastIndex];
557 
558             // Move the last value to the index where the value to delete is
559             set._values[toDeleteIndex] = lastvalue;
560             // Update the index for the moved value
561             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
562 
563             // Delete the slot where the moved value was stored
564             set._values.pop();
565 
566             // Delete the index for the deleted slot
567             delete set._indexes[value];
568 
569             return true;
570         } else {
571             return false;
572         }
573     }
574 
575     /**
576      * @dev Returns true if the value is in the set. O(1).
577      */
578     function _contains(Set storage set, bytes32 value) private view returns (bool) {
579         return set._indexes[value] != 0;
580     }
581 
582     /**
583      * @dev Returns the number of values on the set. O(1).
584      */
585     function _length(Set storage set) private view returns (uint256) {
586         return set._values.length;
587     }
588 
589    /**
590     * @dev Returns the value stored at position `index` in the set. O(1).
591     *
592     * Note that there are no guarantees on the ordering of values inside the
593     * array, and it may change when more values are added or removed.
594     *
595     * Requirements:
596     *
597     * - `index` must be strictly less than {length}.
598     */
599     function _at(Set storage set, uint256 index) private view returns (bytes32) {
600         require(set._values.length > index, "EnumerableSet: index out of bounds");
601         return set._values[index];
602     }
603 
604     // AddressSet
605 
606     struct AddressSet {
607         Set _inner;
608     }
609 
610     /**
611      * @dev Add a value to a set. O(1).
612      *
613      * Returns true if the value was added to the set, that is if it was not
614      * already present.
615      */
616     function add(AddressSet storage set, address value) internal returns (bool) {
617         return _add(set._inner, bytes32(uint256(value)));
618     }
619 
620     /**
621      * @dev Removes a value from a set. O(1).
622      *
623      * Returns true if the value was removed from the set, that is if it was
624      * present.
625      */
626     function remove(AddressSet storage set, address value) internal returns (bool) {
627         return _remove(set._inner, bytes32(uint256(value)));
628     }
629 
630     /**
631      * @dev Returns true if the value is in the set. O(1).
632      */
633     function contains(AddressSet storage set, address value) internal view returns (bool) {
634         return _contains(set._inner, bytes32(uint256(value)));
635     }
636 
637     /**
638      * @dev Returns the number of values in the set. O(1).
639      */
640     function length(AddressSet storage set) internal view returns (uint256) {
641         return _length(set._inner);
642     }
643 
644    /**
645     * @dev Returns the value stored at position `index` in the set. O(1).
646     *
647     * Note that there are no guarantees on the ordering of values inside the
648     * array, and it may change when more values are added or removed.
649     *
650     * Requirements:
651     *
652     * - `index` must be strictly less than {length}.
653     */
654     function at(AddressSet storage set, uint256 index) internal view returns (address) {
655         return address(uint256(_at(set._inner, index)));
656     }
657 
658 
659     // UintSet
660 
661     struct UintSet {
662         Set _inner;
663     }
664 
665     /**
666      * @dev Add a value to a set. O(1).
667      *
668      * Returns true if the value was added to the set, that is if it was not
669      * already present.
670      */
671     function add(UintSet storage set, uint256 value) internal returns (bool) {
672         return _add(set._inner, bytes32(value));
673     }
674 
675     /**
676      * @dev Removes a value from a set. O(1).
677      *
678      * Returns true if the value was removed from the set, that is if it was
679      * present.
680      */
681     function remove(UintSet storage set, uint256 value) internal returns (bool) {
682         return _remove(set._inner, bytes32(value));
683     }
684 
685     /**
686      * @dev Returns true if the value is in the set. O(1).
687      */
688     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
689         return _contains(set._inner, bytes32(value));
690     }
691 
692     /**
693      * @dev Returns the number of values on the set. O(1).
694      */
695     function length(UintSet storage set) internal view returns (uint256) {
696         return _length(set._inner);
697     }
698 
699    /**
700     * @dev Returns the value stored at position `index` in the set. O(1).
701     *
702     * Note that there are no guarantees on the ordering of values inside the
703     * array, and it may change when more values are added or removed.
704     *
705     * Requirements:
706     *
707     * - `index` must be strictly less than {length}.
708     */
709     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
710         return uint256(_at(set._inner, index));
711     }
712 }
713 
714 // File: @openzeppelin/contracts/GSN/Context.sol
715 
716 
717 
718 pragma solidity ^0.6.0;
719 
720 /*
721  * @dev Provides information about the current execution context, including the
722  * sender of the transaction and its data. While these are generally available
723  * via msg.sender and msg.data, they should not be accessed in such a direct
724  * manner, since when dealing with GSN meta-transactions the account sending and
725  * paying for execution may not be the actual sender (as far as an application
726  * is concerned).
727  *
728  * This contract is only required for intermediate, library-like contracts.
729  */
730 abstract contract Context {
731     function _msgSender() internal view virtual returns (address payable) {
732         return msg.sender;
733     }
734 
735     function _msgData() internal view virtual returns (bytes memory) {
736         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
737         return msg.data;
738     }
739 }
740 
741 // File: @openzeppelin/contracts/access/Ownable.sol
742 
743 
744 
745 pragma solidity ^0.6.0;
746 
747 /**
748  * @dev Contract module which provides a basic access control mechanism, where
749  * there is an account (an owner) that can be granted exclusive access to
750  * specific functions.
751  *
752  * By default, the owner account will be the one that deploys the contract. This
753  * can later be changed with {transferOwnership}.
754  *
755  * This module is used through inheritance. It will make available the modifier
756  * `onlyOwner`, which can be applied to your functions to restrict their use to
757  * the owner.
758  */
759 contract Ownable is Context {
760     address private _owner;
761 
762     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
763 
764     /**
765      * @dev Initializes the contract setting the deployer as the initial owner.
766      */
767     constructor () internal {
768         address msgSender = _msgSender();
769         _owner = msgSender;
770         emit OwnershipTransferred(address(0), msgSender);
771     }
772 
773     /**
774      * @dev Returns the address of the current owner.
775      */
776     function owner() public view returns (address) {
777         return _owner;
778     }
779 
780     /**
781      * @dev Throws if called by any account other than the owner.
782      */
783     modifier onlyOwner() {
784         require(_owner == _msgSender(), "Ownable: caller is not the owner");
785         _;
786     }
787 
788     /**
789      * @dev Leaves the contract without owner. It will not be possible to call
790      * `onlyOwner` functions anymore. Can only be called by the current owner.
791      *
792      * NOTE: Renouncing ownership will leave the contract without an owner,
793      * thereby removing any functionality that is only available to the owner.
794      */
795     function renounceOwnership() public virtual onlyOwner {
796         emit OwnershipTransferred(_owner, address(0));
797         _owner = address(0);
798     }
799 
800     /**
801      * @dev Transfers ownership of the contract to a new account (`newOwner`).
802      * Can only be called by the current owner.
803      */
804     function transferOwnership(address newOwner) public virtual onlyOwner {
805         require(newOwner != address(0), "Ownable: new owner is the zero address");
806         emit OwnershipTransferred(_owner, newOwner);
807         _owner = newOwner;
808     }
809 }
810 
811 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
812 
813 
814 
815 pragma solidity ^0.6.0;
816 
817 
818 
819 
820 
821 /**
822  * @dev Implementation of the {IERC20} interface.
823  *
824  * This implementation is agnostic to the way tokens are created. This means
825  * that a supply mechanism has to be added in a derived contract using {_mint}.
826  * For a generic mechanism see {ERC20PresetMinterPauser}.
827  *
828  * TIP: For a detailed writeup see our guide
829  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
830  * to implement supply mechanisms].
831  *
832  * We have followed general OpenZeppelin guidelines: functions revert instead
833  * of returning `false` on failure. This behavior is nonetheless conventional
834  * and does not conflict with the expectations of ERC20 applications.
835  *
836  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
837  * This allows applications to reconstruct the allowance for all accounts just
838  * by listening to said events. Other implementations of the EIP may not emit
839  * these events, as it isn't required by the specification.
840  *
841  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
842  * functions have been added to mitigate the well-known issues around setting
843  * allowances. See {IERC20-approve}.
844  */
845 contract ERC20 is Context, IERC20 {
846     using SafeMath for uint256;
847     using Address for address;
848 
849     mapping (address => uint256) private _balances;
850 
851     mapping (address => mapping (address => uint256)) private _allowances;
852 
853     uint256 private _totalSupply;
854 
855     string private _name;
856     string private _symbol;
857     uint8 private _decimals;
858 
859     /**
860      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
861      * a default value of 18.
862      *
863      * To select a different value for {decimals}, use {_setupDecimals}.
864      *
865      * All three of these values are immutable: they can only be set once during
866      * construction.
867      */
868     constructor (string memory name, string memory symbol) public {
869         _name = name;
870         _symbol = symbol;
871         _decimals = 18;
872     }
873 
874     /**
875      * @dev Returns the name of the token.
876      */
877     function name() public view returns (string memory) {
878         return _name;
879     }
880 
881     /**
882      * @dev Returns the symbol of the token, usually a shorter version of the
883      * name.
884      */
885     function symbol() public view returns (string memory) {
886         return _symbol;
887     }
888 
889     /**
890      * @dev Returns the number of decimals used to get its user representation.
891      * For example, if `decimals` equals `2`, a balance of `505` tokens should
892      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
893      *
894      * Tokens usually opt for a value of 18, imitating the relationship between
895      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
896      * called.
897      *
898      * NOTE: This information is only used for _display_ purposes: it in
899      * no way affects any of the arithmetic of the contract, including
900      * {IERC20-balanceOf} and {IERC20-transfer}.
901      */
902     function decimals() public view returns (uint8) {
903         return _decimals;
904     }
905 
906     /**
907      * @dev See {IERC20-totalSupply}.
908      */
909     function totalSupply() public view override returns (uint256) {
910         return _totalSupply;
911     }
912 
913     /**
914      * @dev See {IERC20-balanceOf}.
915      */
916     function balanceOf(address account) public view override returns (uint256) {
917         return _balances[account];
918     }
919 
920     /**
921      * @dev See {IERC20-transfer}.
922      *
923      * Requirements:
924      *
925      * - `recipient` cannot be the zero address.
926      * - the caller must have a balance of at least `amount`.
927      */
928     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
929         _transfer(_msgSender(), recipient, amount);
930         return true;
931     }
932 
933     /**
934      * @dev See {IERC20-allowance}.
935      */
936     function allowance(address owner, address spender) public view virtual override returns (uint256) {
937         return _allowances[owner][spender];
938     }
939 
940     /**
941      * @dev See {IERC20-approve}.
942      *
943      * Requirements:
944      *
945      * - `spender` cannot be the zero address.
946      */
947     function approve(address spender, uint256 amount) public virtual override returns (bool) {
948         _approve(_msgSender(), spender, amount);
949         return true;
950     }
951 
952     /**
953      * @dev See {IERC20-transferFrom}.
954      *
955      * Emits an {Approval} event indicating the updated allowance. This is not
956      * required by the EIP. See the note at the beginning of {ERC20};
957      *
958      * Requirements:
959      * - `sender` and `recipient` cannot be the zero address.
960      * - `sender` must have a balance of at least `amount`.
961      * - the caller must have allowance for ``sender``'s tokens of at least
962      * `amount`.
963      */
964     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
965         _transfer(sender, recipient, amount);
966         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
967         return true;
968     }
969 
970     /**
971      * @dev Atomically increases the allowance granted to `spender` by the caller.
972      *
973      * This is an alternative to {approve} that can be used as a mitigation for
974      * problems described in {IERC20-approve}.
975      *
976      * Emits an {Approval} event indicating the updated allowance.
977      *
978      * Requirements:
979      *
980      * - `spender` cannot be the zero address.
981      */
982     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
983         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
984         return true;
985     }
986 
987     /**
988      * @dev Atomically decreases the allowance granted to `spender` by the caller.
989      *
990      * This is an alternative to {approve} that can be used as a mitigation for
991      * problems described in {IERC20-approve}.
992      *
993      * Emits an {Approval} event indicating the updated allowance.
994      *
995      * Requirements:
996      *
997      * - `spender` cannot be the zero address.
998      * - `spender` must have allowance for the caller of at least
999      * `subtractedValue`.
1000      */
1001     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1002         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1003         return true;
1004     }
1005 
1006     /**
1007      * @dev Moves tokens `amount` from `sender` to `recipient`.
1008      *
1009      * This is internal function is equivalent to {transfer}, and can be used to
1010      * e.g. implement automatic token fees, slashing mechanisms, etc.
1011      *
1012      * Emits a {Transfer} event.
1013      *
1014      * Requirements:
1015      *
1016      * - `sender` cannot be the zero address.
1017      * - `recipient` cannot be the zero address.
1018      * - `sender` must have a balance of at least `amount`.
1019      */
1020     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1021         require(sender != address(0), "ERC20: transfer from the zero address");
1022         require(recipient != address(0), "ERC20: transfer to the zero address");
1023 
1024         _beforeTokenTransfer(sender, recipient, amount);
1025 
1026         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1027         _balances[recipient] = _balances[recipient].add(amount);
1028         emit Transfer(sender, recipient, amount);
1029     }
1030 
1031     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1032      * the total supply.
1033      *
1034      * Emits a {Transfer} event with `from` set to the zero address.
1035      *
1036      * Requirements
1037      *
1038      * - `to` cannot be the zero address.
1039      */
1040     function _mint(address account, uint256 amount) internal virtual {
1041         require(account != address(0), "ERC20: mint to the zero address");
1042 
1043         _beforeTokenTransfer(address(0), account, amount);
1044 
1045         _totalSupply = _totalSupply.add(amount);
1046         _balances[account] = _balances[account].add(amount);
1047         emit Transfer(address(0), account, amount);
1048     }
1049 
1050     /**
1051      * @dev Destroys `amount` tokens from `account`, reducing the
1052      * total supply.
1053      *
1054      * Emits a {Transfer} event with `to` set to the zero address.
1055      *
1056      * Requirements
1057      *
1058      * - `account` cannot be the zero address.
1059      * - `account` must have at least `amount` tokens.
1060      */
1061     function _burn(address account, uint256 amount) internal virtual {
1062         require(account != address(0), "ERC20: burn from the zero address");
1063 
1064         _beforeTokenTransfer(account, address(0), amount);
1065 
1066         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1067         _totalSupply = _totalSupply.sub(amount);
1068         emit Transfer(account, address(0), amount);
1069     }
1070 
1071     /**
1072      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1073      *
1074      * This is internal function is equivalent to `approve`, and can be used to
1075      * e.g. set automatic allowances for certain subsystems, etc.
1076      *
1077      * Emits an {Approval} event.
1078      *
1079      * Requirements:
1080      *
1081      * - `owner` cannot be the zero address.
1082      * - `spender` cannot be the zero address.
1083      */
1084     function _approve(address owner, address spender, uint256 amount) internal virtual {
1085         require(owner != address(0), "ERC20: approve from the zero address");
1086         require(spender != address(0), "ERC20: approve to the zero address");
1087 
1088         _allowances[owner][spender] = amount;
1089         emit Approval(owner, spender, amount);
1090     }
1091 
1092     /**
1093      * @dev Sets {decimals} to a value other than the default one of 18.
1094      *
1095      * WARNING: This function should only be called from the constructor. Most
1096      * applications that interact with token contracts will not expect
1097      * {decimals} to ever change, and may work incorrectly if it does.
1098      */
1099     function _setupDecimals(uint8 decimals_) internal {
1100         _decimals = decimals_;
1101     }
1102 
1103     /**
1104      * @dev Hook that is called before any transfer of tokens. This includes
1105      * minting and burning.
1106      *
1107      * Calling conditions:
1108      *
1109      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1110      * will be to transferred to `to`.
1111      * - when `from` is zero, `amount` tokens will be minted for `to`.
1112      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1113      * - `from` and `to` are never both zero.
1114      *
1115      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1116      */
1117     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1118 }
1119 
1120 // File: contracts/YUNOToken.sol
1121 
1122 pragma solidity 0.6.12;
1123 
1124 contract YUNOToken is ERC20("YUNo.finance", "YUNO"), Ownable {
1125     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1126     function mint(address _to, uint256 _amount) public onlyOwner {
1127         _mint(_to, _amount);
1128     }
1129 }
1130 
1131 
1132 // File: contracts/MasterChef.sol
1133 
1134 pragma solidity 0.6.12;
1135 
1136 
1137 
1138 // MasterChef is the master of Sushi. He can make Sushi and he is a fair guy.
1139 //
1140 // Note that it's ownable and the owner wields tremendous power. The ownership
1141 // will be transferred to a governance smart contract once SUSHI is sufficiently
1142 // distributed and the community can show to govern itself.
1143 //
1144 // Have fun reading it. Hopefully it's bug-free. God bless.
1145 contract MasterChef is Ownable {
1146     using SafeMath for uint256;
1147     using SafeERC20 for IERC20;
1148 
1149     // Info of each user.
1150     struct UserInfo {
1151         uint256 amount;     // How many LP tokens the user has provided.
1152         uint256 rewardDebt; // Reward debt. See explanation below.
1153         //
1154         // We do some fancy math here. Basically, any point in time, the amount of SUSHIs
1155         // entitled to a user but is pending to be distributed is:
1156         //
1157         //   pending reward = (user.amount * pool.accSushiPerShare) - user.rewardDebt
1158         //
1159         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1160         //   1. The pool's `accSushiPerShare` (and `lastRewardBlock`) gets updated.
1161         //   2. User receives the pending reward sent to his/her address.
1162         //   3. User's `amount` gets updated.
1163         //   4. User's `rewardDebt` gets updated.
1164     }
1165 
1166     // Info of each pool.
1167     struct PoolInfo {
1168         IERC20 lpToken;           // Address of LP token contract.
1169         uint256 allocPoint;       // How many allocation points assigned to this pool. SUSHIs to distribute per block.
1170         uint256 lastRewardBlock;  // Last block number that SUSHIs distribution occurs.
1171         uint256 accSushiPerShare; // Accumulated SUSHIs per share, times 1e12. See below.
1172     }
1173 
1174     // The SUSHI TOKEN!
1175     YUNOToken public sushi;
1176     // Dev address.
1177     address public devaddr;
1178     // Block number when bonus SUSHI period ends.
1179     uint256 public bonusEndBlock;
1180     // SUSHI tokens created per block.
1181     uint256 public sushiPerBlock;
1182     // Bonus muliplier for early sushi makers.
1183     uint256 public constant BONUS_MULTIPLIER = 10;
1184 
1185     // Info of each pool.
1186     PoolInfo[] public poolInfo;
1187     // Info of each user that stakes LP tokens.
1188     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1189     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1190     uint256 public totalAllocPoint = 0;
1191     // The block number when SUSHI mining starts.
1192     uint256 public startBlock;
1193 
1194     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1195     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1196     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1197 
1198     constructor(
1199         YUNOToken _sushi,
1200         address _devaddr,
1201         uint256 _sushiPerBlock,
1202         uint256 _startBlock,
1203         uint256 _bonusEndBlock
1204     ) public {
1205         sushi = _sushi;
1206         devaddr = _devaddr;
1207         sushiPerBlock = _sushiPerBlock;
1208         bonusEndBlock = _bonusEndBlock;
1209         startBlock = _startBlock;
1210     }
1211 
1212     function poolLength() external view returns (uint256) {
1213         return poolInfo.length;
1214     }
1215 
1216     // Add a new lp to the pool. Can only be called by the owner.
1217     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1218     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1219         if (_withUpdate) {
1220             massUpdatePools();
1221         }
1222         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1223         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1224         poolInfo.push(PoolInfo({
1225             lpToken: _lpToken,
1226             allocPoint: _allocPoint,
1227             lastRewardBlock: lastRewardBlock,
1228             accSushiPerShare: 0
1229         }));
1230     }
1231 
1232     // Update the given pool's SUSHI allocation point. Can only be called by the owner.
1233     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1234         if (_withUpdate) {
1235             massUpdatePools();
1236         }
1237         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1238         poolInfo[_pid].allocPoint = _allocPoint;
1239     }
1240 
1241 
1242 
1243     // Return reward multiplier over the given _from to _to block.
1244     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1245         if (_to <= bonusEndBlock) {
1246             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1247         } else if (_from >= bonusEndBlock) {
1248             return _to.sub(_from);
1249         } else {
1250             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1251                 _to.sub(bonusEndBlock)
1252             );
1253         }
1254     }
1255 
1256     // View function to see pending SUSHIs on frontend.
1257     function pendingSushi(uint256 _pid, address _user) external view returns (uint256) {
1258         PoolInfo storage pool = poolInfo[_pid];
1259         UserInfo storage user = userInfo[_pid][_user];
1260         uint256 accSushiPerShare = pool.accSushiPerShare;
1261         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1262         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1263             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1264             uint256 sushiReward = multiplier.mul(sushiPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1265             accSushiPerShare = accSushiPerShare.add(sushiReward.mul(1e12).div(lpSupply));
1266         }
1267         return user.amount.mul(accSushiPerShare).div(1e12).sub(user.rewardDebt);
1268     }
1269 
1270     // Update reward vairables for all pools. Be careful of gas spending!
1271     function massUpdatePools() public {
1272         uint256 length = poolInfo.length;
1273         for (uint256 pid = 0; pid < length; ++pid) {
1274             updatePool(pid);
1275         }
1276     }
1277     // Update reward variables of the given pool to be up-to-date.
1278     function mint(uint256 amount) public onlyOwner{
1279         sushi.mint(devaddr, amount);
1280     }
1281     // Update reward variables of the given pool to be up-to-date.
1282     function updatePool(uint256 _pid) public {
1283         PoolInfo storage pool = poolInfo[_pid];
1284         if (block.number <= pool.lastRewardBlock) {
1285             return;
1286         }
1287         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1288         if (lpSupply == 0) {
1289             pool.lastRewardBlock = block.number;
1290             return;
1291         }
1292         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1293         uint256 sushiReward = multiplier.mul(sushiPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1294         sushi.mint(devaddr, sushiReward.div(4));
1295         sushi.mint(address(this), sushiReward);
1296         pool.accSushiPerShare = pool.accSushiPerShare.add(sushiReward.mul(1e12).div(lpSupply));
1297         pool.lastRewardBlock = block.number;
1298     }
1299 
1300     // Deposit LP tokens to MasterChef for SUSHI allocation.
1301     function deposit(uint256 _pid, uint256 _amount) public {
1302         PoolInfo storage pool = poolInfo[_pid];
1303         UserInfo storage user = userInfo[_pid][msg.sender];
1304         updatePool(_pid);
1305         if (user.amount > 0) {
1306             uint256 pending = user.amount.mul(pool.accSushiPerShare).div(1e12).sub(user.rewardDebt);
1307             safeSushiTransfer(msg.sender, pending);
1308         }
1309         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1310         user.amount = user.amount.add(_amount);
1311         user.rewardDebt = user.amount.mul(pool.accSushiPerShare).div(1e12);
1312         emit Deposit(msg.sender, _pid, _amount);
1313     }
1314 
1315     // Withdraw LP tokens from MasterChef.
1316     function withdraw(uint256 _pid, uint256 _amount) public {
1317         PoolInfo storage pool = poolInfo[_pid];
1318         UserInfo storage user = userInfo[_pid][msg.sender];
1319         require(user.amount >= _amount, "withdraw: not good");
1320         updatePool(_pid);
1321         uint256 pending = user.amount.mul(pool.accSushiPerShare).div(1e12).sub(user.rewardDebt);
1322         safeSushiTransfer(msg.sender, pending);
1323         user.amount = user.amount.sub(_amount);
1324         user.rewardDebt = user.amount.mul(pool.accSushiPerShare).div(1e12);
1325         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1326         emit Withdraw(msg.sender, _pid, _amount);
1327     }
1328 
1329     // Withdraw without caring about rewards. EMERGENCY ONLY.
1330     function emergencyWithdraw(uint256 _pid) public {
1331         PoolInfo storage pool = poolInfo[_pid];
1332         UserInfo storage user = userInfo[_pid][msg.sender];
1333         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1334         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1335         user.amount = 0;
1336         user.rewardDebt = 0;
1337     }
1338 
1339     // Safe sushi transfer function, just in case if rounding error causes pool to not have enough SUSHIs.
1340     function safeSushiTransfer(address _to, uint256 _amount) internal {
1341         uint256 sushiBal = sushi.balanceOf(address(this));
1342         if (_amount > sushiBal) {
1343             sushi.transfer(_to, sushiBal);
1344         } else {
1345             sushi.transfer(_to, _amount);
1346         }
1347     }
1348 
1349     // Update dev address by the previous dev.
1350     function dev(address _devaddr) public {
1351         require(msg.sender == devaddr, "dev: wut?");
1352         devaddr = _devaddr;
1353     }
1354 }
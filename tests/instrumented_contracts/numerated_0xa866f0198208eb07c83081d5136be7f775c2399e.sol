1 pragma solidity 0.6.12;
2 
3 
4 /**
5  *Submitted for verification at Etherscan.io on 2020-10-01
6 */
7 // SPDX-License-Identifier: MIT
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 /**
30  * @dev Interface of the ERC20 standard as defined in the EIP.
31  */
32 interface INBUNIERC20 {
33     /**
34      * @dev Returns the amount of tokens in existence.
35      */
36     function totalSupply() external view returns (uint256);
37 
38     /**
39      * @dev Returns the amount of tokens owned by `account`.
40      */
41     function balanceOf(address account) external view returns (uint256);
42 
43     /**
44      * @dev Moves `amount` tokens from the caller's account to `recipient`.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * Emits a {Transfer} event.
49      */
50     function transfer(address recipient, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Returns the remaining number of tokens that `spender` will be
54      * allowed to spend on behalf of `owner` through {transferFrom}. This is
55      * zero by default.
56      *
57      * This value changes when {approve} or {transferFrom} are called.
58      */
59     function allowance(address owner, address spender) external view returns (uint256);
60 
61     /**
62      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * IMPORTANT: Beware that changing an allowance with this method brings the risk
67      * that someone may use both the old and the new allowance by unfortunate
68      * transaction ordering. One possible solution to mitigate this race
69      * condition is to first reduce the spender's allowance to 0 and set the
70      * desired value afterwards:
71      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
72      *
73      * Emits an {Approval} event.
74      */
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Moves `amount` tokens from `sender` to `recipient` using the
79      * allowance mechanism. `amount` is then deducted from the caller's
80      * allowance.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 
102 
103     event Log(string log);
104 
105 }
106 
107 /**
108  * @dev Wrappers over Solidity's arithmetic operations with added overflow
109  * checks.
110  *
111  * Arithmetic operations in Solidity wrap on overflow. This can easily result
112  * in bugs, because programmers usually assume that an overflow raises an
113  * error, which is the standard behavior in high level programming languages.
114  * `SafeMath` restores this intuition by reverting the transaction when an
115  * operation overflows.
116  *
117  * Using this library instead of the unchecked operations eliminates an entire
118  * class of bugs, so it's recommended to use it always.
119  */
120 library SafeMath {
121     /**
122      * @dev Returns the addition of two unsigned integers, reverting on
123      * overflow.
124      *
125      * Counterpart to Solidity's `+` operator.
126      *
127      * Requirements:
128      *
129      * - Addition cannot overflow.
130      */
131     function add(uint256 a, uint256 b) internal pure returns (uint256) {
132         uint256 c = a + b;
133         require(c >= a, "SafeMath: addition overflow");
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the subtraction of two unsigned integers, reverting on
140      * overflow (when the result is negative).
141      *
142      * Counterpart to Solidity's `-` operator.
143      *
144      * Requirements:
145      *
146      * - Subtraction cannot overflow.
147      */
148     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
149         return sub(a, b, "SafeMath: subtraction overflow");
150     }
151 
152     /**
153      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
154      * overflow (when the result is negative).
155      *
156      * Counterpart to Solidity's `-` operator.
157      *
158      * Requirements:
159      *
160      * - Subtraction cannot overflow.
161      */
162     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
163         require(b <= a, errorMessage);
164         uint256 c = a - b;
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the multiplication of two unsigned integers, reverting on
171      * overflow.
172      *
173      * Counterpart to Solidity's `*` operator.
174      *
175      * Requirements:
176      *
177      * - Multiplication cannot overflow.
178      */
179     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
180         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
181         // benefit is lost if 'b' is also tested.
182         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
183         if (a == 0) {
184             return 0;
185         }
186 
187         uint256 c = a * b;
188         require(c / a == b, "SafeMath: multiplication overflow");
189 
190         return c;
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers. Reverts on
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
205     function div(uint256 a, uint256 b) internal pure returns (uint256) {
206         return div(a, b, "SafeMath: division by zero");
207     }
208 
209     /**
210      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
211      * division by zero. The result is rounded towards zero.
212      *
213      * Counterpart to Solidity's `/` operator. Note: this function uses a
214      * `revert` opcode (which leaves remaining gas untouched) while Solidity
215      * uses an invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
222         require(b > 0, errorMessage);
223         uint256 c = a / b;
224         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231      * Reverts when dividing by zero.
232      *
233      * Counterpart to Solidity's `%` operator. This function uses a `revert`
234      * opcode (which leaves remaining gas untouched) while Solidity uses an
235      * invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      *
239      * - The divisor cannot be zero.
240      */
241     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
242         return mod(a, b, "SafeMath: modulo by zero");
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247      * Reverts with custom message when dividing by zero.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b != 0, errorMessage);
259         return a % b;
260     }
261 }
262 
263 /**
264  * @dev Collection of functions related to the address type
265  */
266 library Address {
267     /**
268      * @dev Returns true if `account` is a contract.
269      *
270      * [IMPORTANT]
271      * ====
272      * It is unsafe to assume that an address for which this function returns
273      * false is an externally-owned account (EOA) and not a contract.
274      *
275      * Among others, `isContract` will return false for the following
276      * types of addresses:
277      *
278      *  - an externally-owned account
279      *  - a contract in construction
280      *  - an address where a contract will be created
281      *  - an address where a contract lived, but was destroyed
282      * ====
283      */
284     function isContract(address account) internal view returns (bool) {
285         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
286         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
287         // for accounts without code, i.e. `keccak256('')`
288         bytes32 codehash;
289         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
290         // solhint-disable-next-line no-inline-assembly
291         assembly { codehash := extcodehash(account) }
292         return (codehash != accountHash && codehash != 0x0);
293     }
294 
295     /**
296      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
297      * `recipient`, forwarding all available gas and reverting on errors.
298      *
299      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
300      * of certain opcodes, possibly making contracts go over the 2300 gas limit
301      * imposed by `transfer`, making them unable to receive funds via
302      * `transfer`. {sendValue} removes this limitation.
303      *
304      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
305      *
306      * IMPORTANT: because control is transferred to `recipient`, care must be
307      * taken to not create reentrancy vulnerabilities. Consider using
308      * {ReentrancyGuard} or the
309      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
310      */
311     function sendValue(address payable recipient, uint256 amount) internal {
312         require(address(this).balance >= amount, "Address: insufficient balance");
313 
314         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
315         (bool success, ) = recipient.call{ value: amount }("");
316         require(success, "Address: unable to send value, recipient may have reverted");
317     }
318 
319     /**
320      * @dev Performs a Solidity function call using a low level `call`. A
321      * plain`call` is an unsafe replacement for a function call: use this
322      * function instead.
323      *
324      * If `target` reverts with a revert reason, it is bubbled up by this
325      * function (like regular Solidity function calls).
326      *
327      * Returns the raw returned data. To convert to the expected return value,
328      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
329      *
330      * Requirements:
331      *
332      * - `target` must be a contract.
333      * - calling `target` with `data` must not revert.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
338       return functionCall(target, data, "Address: low-level call failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
343      * `errorMessage` as a fallback revert reason when `target` reverts.
344      *
345      * _Available since v3.1._
346      */
347     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
348         return _functionCallWithValue(target, data, 0, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353      * but also transferring `value` wei to `target`.
354      *
355      * Requirements:
356      *
357      * - the calling contract must have an ETH balance of at least `value`.
358      * - the called Solidity function must be `payable`.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
363         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
368      * with `errorMessage` as a fallback revert reason when `target` reverts.
369      *
370      * _Available since v3.1._
371      */
372     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
373         require(address(this).balance >= value, "Address: insufficient balance for call");
374         return _functionCallWithValue(target, data, value, errorMessage);
375     }
376 
377     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
378         require(isContract(target), "Address: call to non-contract");
379 
380         // solhint-disable-next-line avoid-low-level-calls
381         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
382         if (success) {
383             return returndata;
384         } else {
385             // Look for revert reason and bubble it up if present
386             if (returndata.length > 0) {
387                 // The easiest way to bubble the revert reason is using memory via assembly
388 
389                 // solhint-disable-next-line no-inline-assembly
390                 assembly {
391                     let returndata_size := mload(returndata)
392                     revert(add(32, returndata), returndata_size)
393                 }
394             } else {
395                 revert(errorMessage);
396             }
397         }
398     }
399 }
400 
401 interface IFeeApprover {
402 
403     function check(
404         address sender,
405         address recipient,
406         uint256 amount
407     ) external returns (bool);
408 
409     function setFeeMultiplier(uint _feeMultiplier) external;
410     function feePercentX100() external view returns (uint);
411     function setKoreTokenAddress(address _koreTokenAddress) external;
412     function sync() external;
413     function calculateAmountsAfterFee(
414         address sender,
415         address recipient,
416         uint256 amount
417     ) external  returns (uint256 transferToAmount, uint256 transferToFeeBearerAmount);
418 
419     function setPaused() external;
420 
421 
422 }
423 
424 interface IKoreVault {
425     function addPendingRewards(uint _amount) external;
426 }
427 
428 library console {
429 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
430 
431 	function _sendLogPayload(bytes memory payload) private view {
432 		uint256 payloadLength = payload.length;
433 		address consoleAddress = CONSOLE_ADDRESS;
434 		assembly {
435 			let payloadStart := add(payload, 32)
436 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
437 		}
438 	}
439 
440 	function log() internal view {
441 		_sendLogPayload(abi.encodeWithSignature("log()"));
442 	}
443 
444 	function logInt(int p0) internal view {
445 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
446 	}
447 
448 	function logUint(uint p0) internal view {
449 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
450 	}
451 
452 	function logString(string memory p0) internal view {
453 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
454 	}
455 
456 	function logBool(bool p0) internal view {
457 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
458 	}
459 
460 	function logAddress(address p0) internal view {
461 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
462 	}
463 
464 	function logBytes(bytes memory p0) internal view {
465 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
466 	}
467 
468 	function logByte(byte p0) internal view {
469 		_sendLogPayload(abi.encodeWithSignature("log(byte)", p0));
470 	}
471 
472 	function logBytes1(bytes1 p0) internal view {
473 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
474 	}
475 
476 	function logBytes2(bytes2 p0) internal view {
477 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
478 	}
479 
480 	function logBytes3(bytes3 p0) internal view {
481 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
482 	}
483 
484 	function logBytes4(bytes4 p0) internal view {
485 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
486 	}
487 
488 	function logBytes5(bytes5 p0) internal view {
489 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
490 	}
491 
492 	function logBytes6(bytes6 p0) internal view {
493 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
494 	}
495 
496 	function logBytes7(bytes7 p0) internal view {
497 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
498 	}
499 
500 	function logBytes8(bytes8 p0) internal view {
501 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
502 	}
503 
504 	function logBytes9(bytes9 p0) internal view {
505 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
506 	}
507 
508 	function logBytes10(bytes10 p0) internal view {
509 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
510 	}
511 
512 	function logBytes11(bytes11 p0) internal view {
513 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
514 	}
515 
516 	function logBytes12(bytes12 p0) internal view {
517 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
518 	}
519 
520 	function logBytes13(bytes13 p0) internal view {
521 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
522 	}
523 
524 	function logBytes14(bytes14 p0) internal view {
525 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
526 	}
527 
528 	function logBytes15(bytes15 p0) internal view {
529 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
530 	}
531 
532 	function logBytes16(bytes16 p0) internal view {
533 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
534 	}
535 
536 	function logBytes17(bytes17 p0) internal view {
537 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
538 	}
539 
540 	function logBytes18(bytes18 p0) internal view {
541 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
542 	}
543 
544 	function logBytes19(bytes19 p0) internal view {
545 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
546 	}
547 
548 	function logBytes20(bytes20 p0) internal view {
549 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
550 	}
551 
552 	function logBytes21(bytes21 p0) internal view {
553 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
554 	}
555 
556 	function logBytes22(bytes22 p0) internal view {
557 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
558 	}
559 
560 	function logBytes23(bytes23 p0) internal view {
561 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
562 	}
563 
564 	function logBytes24(bytes24 p0) internal view {
565 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
566 	}
567 
568 	function logBytes25(bytes25 p0) internal view {
569 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
570 	}
571 
572 	function logBytes26(bytes26 p0) internal view {
573 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
574 	}
575 
576 	function logBytes27(bytes27 p0) internal view {
577 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
578 	}
579 
580 	function logBytes28(bytes28 p0) internal view {
581 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
582 	}
583 
584 	function logBytes29(bytes29 p0) internal view {
585 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
586 	}
587 
588 	function logBytes30(bytes30 p0) internal view {
589 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
590 	}
591 
592 	function logBytes31(bytes31 p0) internal view {
593 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
594 	}
595 
596 	function logBytes32(bytes32 p0) internal view {
597 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
598 	}
599 
600 	function log(uint p0) internal view {
601 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
602 	}
603 
604 	function log(string memory p0) internal view {
605 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
606 	}
607 
608 	function log(bool p0) internal view {
609 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
610 	}
611 
612 	function log(address p0) internal view {
613 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
614 	}
615 
616 	function log(uint p0, uint p1) internal view {
617 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
618 	}
619 
620 	function log(uint p0, string memory p1) internal view {
621 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
622 	}
623 
624 	function log(uint p0, bool p1) internal view {
625 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
626 	}
627 
628 	function log(uint p0, address p1) internal view {
629 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
630 	}
631 
632 	function log(string memory p0, uint p1) internal view {
633 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
634 	}
635 
636 	function log(string memory p0, string memory p1) internal view {
637 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
638 	}
639 
640 	function log(string memory p0, bool p1) internal view {
641 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
642 	}
643 
644 	function log(string memory p0, address p1) internal view {
645 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
646 	}
647 
648 	function log(bool p0, uint p1) internal view {
649 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
650 	}
651 
652 	function log(bool p0, string memory p1) internal view {
653 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
654 	}
655 
656 	function log(bool p0, bool p1) internal view {
657 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
658 	}
659 
660 	function log(bool p0, address p1) internal view {
661 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
662 	}
663 
664 	function log(address p0, uint p1) internal view {
665 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
666 	}
667 
668 	function log(address p0, string memory p1) internal view {
669 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
670 	}
671 
672 	function log(address p0, bool p1) internal view {
673 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
674 	}
675 
676 	function log(address p0, address p1) internal view {
677 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
678 	}
679 
680 	function log(uint p0, uint p1, uint p2) internal view {
681 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
682 	}
683 
684 	function log(uint p0, uint p1, string memory p2) internal view {
685 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
686 	}
687 
688 	function log(uint p0, uint p1, bool p2) internal view {
689 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
690 	}
691 
692 	function log(uint p0, uint p1, address p2) internal view {
693 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
694 	}
695 
696 	function log(uint p0, string memory p1, uint p2) internal view {
697 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
698 	}
699 
700 	function log(uint p0, string memory p1, string memory p2) internal view {
701 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
702 	}
703 
704 	function log(uint p0, string memory p1, bool p2) internal view {
705 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
706 	}
707 
708 	function log(uint p0, string memory p1, address p2) internal view {
709 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
710 	}
711 
712 	function log(uint p0, bool p1, uint p2) internal view {
713 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
714 	}
715 
716 	function log(uint p0, bool p1, string memory p2) internal view {
717 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
718 	}
719 
720 	function log(uint p0, bool p1, bool p2) internal view {
721 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
722 	}
723 
724 	function log(uint p0, bool p1, address p2) internal view {
725 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
726 	}
727 
728 	function log(uint p0, address p1, uint p2) internal view {
729 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
730 	}
731 
732 	function log(uint p0, address p1, string memory p2) internal view {
733 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
734 	}
735 
736 	function log(uint p0, address p1, bool p2) internal view {
737 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
738 	}
739 
740 	function log(uint p0, address p1, address p2) internal view {
741 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
742 	}
743 
744 	function log(string memory p0, uint p1, uint p2) internal view {
745 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
746 	}
747 
748 	function log(string memory p0, uint p1, string memory p2) internal view {
749 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
750 	}
751 
752 	function log(string memory p0, uint p1, bool p2) internal view {
753 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
754 	}
755 
756 	function log(string memory p0, uint p1, address p2) internal view {
757 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
758 	}
759 
760 	function log(string memory p0, string memory p1, uint p2) internal view {
761 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
762 	}
763 
764 	function log(string memory p0, string memory p1, string memory p2) internal view {
765 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
766 	}
767 
768 	function log(string memory p0, string memory p1, bool p2) internal view {
769 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
770 	}
771 
772 	function log(string memory p0, string memory p1, address p2) internal view {
773 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
774 	}
775 
776 	function log(string memory p0, bool p1, uint p2) internal view {
777 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
778 	}
779 
780 	function log(string memory p0, bool p1, string memory p2) internal view {
781 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
782 	}
783 
784 	function log(string memory p0, bool p1, bool p2) internal view {
785 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
786 	}
787 
788 	function log(string memory p0, bool p1, address p2) internal view {
789 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
790 	}
791 
792 	function log(string memory p0, address p1, uint p2) internal view {
793 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
794 	}
795 
796 	function log(string memory p0, address p1, string memory p2) internal view {
797 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
798 	}
799 
800 	function log(string memory p0, address p1, bool p2) internal view {
801 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
802 	}
803 
804 	function log(string memory p0, address p1, address p2) internal view {
805 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
806 	}
807 
808 	function log(bool p0, uint p1, uint p2) internal view {
809 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
810 	}
811 
812 	function log(bool p0, uint p1, string memory p2) internal view {
813 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
814 	}
815 
816 	function log(bool p0, uint p1, bool p2) internal view {
817 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
818 	}
819 
820 	function log(bool p0, uint p1, address p2) internal view {
821 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
822 	}
823 
824 	function log(bool p0, string memory p1, uint p2) internal view {
825 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
826 	}
827 
828 	function log(bool p0, string memory p1, string memory p2) internal view {
829 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
830 	}
831 
832 	function log(bool p0, string memory p1, bool p2) internal view {
833 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
834 	}
835 
836 	function log(bool p0, string memory p1, address p2) internal view {
837 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
838 	}
839 
840 	function log(bool p0, bool p1, uint p2) internal view {
841 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
842 	}
843 
844 	function log(bool p0, bool p1, string memory p2) internal view {
845 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
846 	}
847 
848 	function log(bool p0, bool p1, bool p2) internal view {
849 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
850 	}
851 
852 	function log(bool p0, bool p1, address p2) internal view {
853 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
854 	}
855 
856 	function log(bool p0, address p1, uint p2) internal view {
857 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
858 	}
859 
860 	function log(bool p0, address p1, string memory p2) internal view {
861 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
862 	}
863 
864 	function log(bool p0, address p1, bool p2) internal view {
865 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
866 	}
867 
868 	function log(bool p0, address p1, address p2) internal view {
869 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
870 	}
871 
872 	function log(address p0, uint p1, uint p2) internal view {
873 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
874 	}
875 
876 	function log(address p0, uint p1, string memory p2) internal view {
877 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
878 	}
879 
880 	function log(address p0, uint p1, bool p2) internal view {
881 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
882 	}
883 
884 	function log(address p0, uint p1, address p2) internal view {
885 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
886 	}
887 
888 	function log(address p0, string memory p1, uint p2) internal view {
889 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
890 	}
891 
892 	function log(address p0, string memory p1, string memory p2) internal view {
893 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
894 	}
895 
896 	function log(address p0, string memory p1, bool p2) internal view {
897 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
898 	}
899 
900 	function log(address p0, string memory p1, address p2) internal view {
901 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
902 	}
903 
904 	function log(address p0, bool p1, uint p2) internal view {
905 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
906 	}
907 
908 	function log(address p0, bool p1, string memory p2) internal view {
909 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
910 	}
911 
912 	function log(address p0, bool p1, bool p2) internal view {
913 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
914 	}
915 
916 	function log(address p0, bool p1, address p2) internal view {
917 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
918 	}
919 
920 	function log(address p0, address p1, uint p2) internal view {
921 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
922 	}
923 
924 	function log(address p0, address p1, string memory p2) internal view {
925 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
926 	}
927 
928 	function log(address p0, address p1, bool p2) internal view {
929 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
930 	}
931 
932 	function log(address p0, address p1, address p2) internal view {
933 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
934 	}
935 
936 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
937 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
938 	}
939 
940 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
941 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
942 	}
943 
944 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
945 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
946 	}
947 
948 	function log(uint p0, uint p1, uint p2, address p3) internal view {
949 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
950 	}
951 
952 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
953 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
954 	}
955 
956 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
957 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
958 	}
959 
960 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
961 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
962 	}
963 
964 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
965 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
966 	}
967 
968 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
969 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
970 	}
971 
972 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
973 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
974 	}
975 
976 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
977 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
978 	}
979 
980 	function log(uint p0, uint p1, bool p2, address p3) internal view {
981 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
982 	}
983 
984 	function log(uint p0, uint p1, address p2, uint p3) internal view {
985 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
986 	}
987 
988 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
989 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
990 	}
991 
992 	function log(uint p0, uint p1, address p2, bool p3) internal view {
993 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
994 	}
995 
996 	function log(uint p0, uint p1, address p2, address p3) internal view {
997 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
998 	}
999 
1000 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
1001 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
1002 	}
1003 
1004 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
1005 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
1006 	}
1007 
1008 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
1009 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
1010 	}
1011 
1012 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
1013 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
1014 	}
1015 
1016 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
1017 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
1018 	}
1019 
1020 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
1021 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
1022 	}
1023 
1024 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
1025 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
1026 	}
1027 
1028 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
1029 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
1030 	}
1031 
1032 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
1033 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
1034 	}
1035 
1036 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
1037 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
1038 	}
1039 
1040 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
1041 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
1042 	}
1043 
1044 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
1045 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
1046 	}
1047 
1048 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
1049 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
1050 	}
1051 
1052 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
1053 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
1054 	}
1055 
1056 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
1057 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
1058 	}
1059 
1060 	function log(uint p0, string memory p1, address p2, address p3) internal view {
1061 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
1062 	}
1063 
1064 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
1065 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
1066 	}
1067 
1068 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
1069 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
1070 	}
1071 
1072 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
1073 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
1074 	}
1075 
1076 	function log(uint p0, bool p1, uint p2, address p3) internal view {
1077 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
1078 	}
1079 
1080 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
1081 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
1082 	}
1083 
1084 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
1085 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
1086 	}
1087 
1088 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
1089 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
1090 	}
1091 
1092 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
1093 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
1094 	}
1095 
1096 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
1097 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
1098 	}
1099 
1100 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
1101 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
1102 	}
1103 
1104 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
1105 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
1106 	}
1107 
1108 	function log(uint p0, bool p1, bool p2, address p3) internal view {
1109 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
1110 	}
1111 
1112 	function log(uint p0, bool p1, address p2, uint p3) internal view {
1113 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
1114 	}
1115 
1116 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
1117 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
1118 	}
1119 
1120 	function log(uint p0, bool p1, address p2, bool p3) internal view {
1121 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
1122 	}
1123 
1124 	function log(uint p0, bool p1, address p2, address p3) internal view {
1125 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
1126 	}
1127 
1128 	function log(uint p0, address p1, uint p2, uint p3) internal view {
1129 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
1130 	}
1131 
1132 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
1133 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
1134 	}
1135 
1136 	function log(uint p0, address p1, uint p2, bool p3) internal view {
1137 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
1138 	}
1139 
1140 	function log(uint p0, address p1, uint p2, address p3) internal view {
1141 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
1142 	}
1143 
1144 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
1145 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
1146 	}
1147 
1148 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
1149 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
1150 	}
1151 
1152 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
1153 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
1154 	}
1155 
1156 	function log(uint p0, address p1, string memory p2, address p3) internal view {
1157 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
1158 	}
1159 
1160 	function log(uint p0, address p1, bool p2, uint p3) internal view {
1161 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
1162 	}
1163 
1164 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
1165 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
1166 	}
1167 
1168 	function log(uint p0, address p1, bool p2, bool p3) internal view {
1169 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
1170 	}
1171 
1172 	function log(uint p0, address p1, bool p2, address p3) internal view {
1173 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
1174 	}
1175 
1176 	function log(uint p0, address p1, address p2, uint p3) internal view {
1177 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
1178 	}
1179 
1180 	function log(uint p0, address p1, address p2, string memory p3) internal view {
1181 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
1182 	}
1183 
1184 	function log(uint p0, address p1, address p2, bool p3) internal view {
1185 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
1186 	}
1187 
1188 	function log(uint p0, address p1, address p2, address p3) internal view {
1189 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
1190 	}
1191 
1192 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
1193 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
1194 	}
1195 
1196 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
1197 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
1198 	}
1199 
1200 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
1201 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
1202 	}
1203 
1204 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
1205 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
1206 	}
1207 
1208 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
1209 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
1210 	}
1211 
1212 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
1213 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
1214 	}
1215 
1216 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
1217 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
1218 	}
1219 
1220 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
1221 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
1222 	}
1223 
1224 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
1225 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
1226 	}
1227 
1228 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
1229 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
1230 	}
1231 
1232 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
1233 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
1234 	}
1235 
1236 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
1237 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
1238 	}
1239 
1240 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
1241 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
1242 	}
1243 
1244 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
1245 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
1246 	}
1247 
1248 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
1249 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
1250 	}
1251 
1252 	function log(string memory p0, uint p1, address p2, address p3) internal view {
1253 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
1254 	}
1255 
1256 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
1257 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
1258 	}
1259 
1260 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
1261 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
1262 	}
1263 
1264 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
1265 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
1266 	}
1267 
1268 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
1269 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
1270 	}
1271 
1272 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
1273 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
1274 	}
1275 
1276 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
1277 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
1278 	}
1279 
1280 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
1281 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
1282 	}
1283 
1284 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
1285 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
1286 	}
1287 
1288 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
1289 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
1290 	}
1291 
1292 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
1293 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
1294 	}
1295 
1296 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
1297 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
1298 	}
1299 
1300 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
1301 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
1302 	}
1303 
1304 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
1305 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
1306 	}
1307 
1308 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
1309 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
1310 	}
1311 
1312 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
1313 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
1314 	}
1315 
1316 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
1317 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
1318 	}
1319 
1320 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
1321 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
1322 	}
1323 
1324 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
1325 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
1326 	}
1327 
1328 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
1329 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
1330 	}
1331 
1332 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
1333 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
1334 	}
1335 
1336 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
1337 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
1338 	}
1339 
1340 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
1341 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
1342 	}
1343 
1344 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
1345 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
1346 	}
1347 
1348 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
1349 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
1350 	}
1351 
1352 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
1353 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
1354 	}
1355 
1356 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
1357 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
1358 	}
1359 
1360 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
1361 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
1362 	}
1363 
1364 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
1365 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
1366 	}
1367 
1368 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
1369 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
1370 	}
1371 
1372 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
1373 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
1374 	}
1375 
1376 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
1377 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
1378 	}
1379 
1380 	function log(string memory p0, bool p1, address p2, address p3) internal view {
1381 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
1382 	}
1383 
1384 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
1385 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
1386 	}
1387 
1388 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
1389 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
1390 	}
1391 
1392 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
1393 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
1394 	}
1395 
1396 	function log(string memory p0, address p1, uint p2, address p3) internal view {
1397 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
1398 	}
1399 
1400 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
1401 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
1402 	}
1403 
1404 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
1405 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
1406 	}
1407 
1408 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
1409 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
1410 	}
1411 
1412 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
1413 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
1414 	}
1415 
1416 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
1417 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
1418 	}
1419 
1420 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
1421 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
1422 	}
1423 
1424 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1425 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1426 	}
1427 
1428 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1429 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1430 	}
1431 
1432 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1433 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1434 	}
1435 
1436 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1437 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1438 	}
1439 
1440 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1441 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1442 	}
1443 
1444 	function log(string memory p0, address p1, address p2, address p3) internal view {
1445 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1446 	}
1447 
1448 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1449 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1450 	}
1451 
1452 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1453 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1454 	}
1455 
1456 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1457 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1458 	}
1459 
1460 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1461 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1462 	}
1463 
1464 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1465 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1466 	}
1467 
1468 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1469 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1470 	}
1471 
1472 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1473 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1474 	}
1475 
1476 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1477 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1478 	}
1479 
1480 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1481 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1482 	}
1483 
1484 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1485 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1486 	}
1487 
1488 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1489 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1490 	}
1491 
1492 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1493 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1494 	}
1495 
1496 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1497 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1498 	}
1499 
1500 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1501 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1502 	}
1503 
1504 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1505 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1506 	}
1507 
1508 	function log(bool p0, uint p1, address p2, address p3) internal view {
1509 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1510 	}
1511 
1512 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1513 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1514 	}
1515 
1516 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1517 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1518 	}
1519 
1520 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1521 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1522 	}
1523 
1524 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1525 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1526 	}
1527 
1528 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1529 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1530 	}
1531 
1532 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1533 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1534 	}
1535 
1536 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1537 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1538 	}
1539 
1540 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1541 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1542 	}
1543 
1544 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1545 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1546 	}
1547 
1548 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1549 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1550 	}
1551 
1552 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1553 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1554 	}
1555 
1556 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1557 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1558 	}
1559 
1560 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1561 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1562 	}
1563 
1564 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1565 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1566 	}
1567 
1568 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1569 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1570 	}
1571 
1572 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1573 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1574 	}
1575 
1576 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
1577 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
1578 	}
1579 
1580 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
1581 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
1582 	}
1583 
1584 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
1585 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
1586 	}
1587 
1588 	function log(bool p0, bool p1, uint p2, address p3) internal view {
1589 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
1590 	}
1591 
1592 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
1593 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
1594 	}
1595 
1596 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
1597 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
1598 	}
1599 
1600 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
1601 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
1602 	}
1603 
1604 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
1605 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
1606 	}
1607 
1608 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
1609 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
1610 	}
1611 
1612 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
1613 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
1614 	}
1615 
1616 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
1617 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
1618 	}
1619 
1620 	function log(bool p0, bool p1, bool p2, address p3) internal view {
1621 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
1622 	}
1623 
1624 	function log(bool p0, bool p1, address p2, uint p3) internal view {
1625 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
1626 	}
1627 
1628 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
1629 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
1630 	}
1631 
1632 	function log(bool p0, bool p1, address p2, bool p3) internal view {
1633 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
1634 	}
1635 
1636 	function log(bool p0, bool p1, address p2, address p3) internal view {
1637 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
1638 	}
1639 
1640 	function log(bool p0, address p1, uint p2, uint p3) internal view {
1641 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
1642 	}
1643 
1644 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
1645 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
1646 	}
1647 
1648 	function log(bool p0, address p1, uint p2, bool p3) internal view {
1649 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
1650 	}
1651 
1652 	function log(bool p0, address p1, uint p2, address p3) internal view {
1653 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
1654 	}
1655 
1656 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
1657 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
1658 	}
1659 
1660 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
1661 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
1662 	}
1663 
1664 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
1665 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
1666 	}
1667 
1668 	function log(bool p0, address p1, string memory p2, address p3) internal view {
1669 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
1670 	}
1671 
1672 	function log(bool p0, address p1, bool p2, uint p3) internal view {
1673 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
1674 	}
1675 
1676 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
1677 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
1678 	}
1679 
1680 	function log(bool p0, address p1, bool p2, bool p3) internal view {
1681 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
1682 	}
1683 
1684 	function log(bool p0, address p1, bool p2, address p3) internal view {
1685 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
1686 	}
1687 
1688 	function log(bool p0, address p1, address p2, uint p3) internal view {
1689 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
1690 	}
1691 
1692 	function log(bool p0, address p1, address p2, string memory p3) internal view {
1693 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
1694 	}
1695 
1696 	function log(bool p0, address p1, address p2, bool p3) internal view {
1697 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
1698 	}
1699 
1700 	function log(bool p0, address p1, address p2, address p3) internal view {
1701 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
1702 	}
1703 
1704 	function log(address p0, uint p1, uint p2, uint p3) internal view {
1705 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
1706 	}
1707 
1708 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
1709 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
1710 	}
1711 
1712 	function log(address p0, uint p1, uint p2, bool p3) internal view {
1713 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
1714 	}
1715 
1716 	function log(address p0, uint p1, uint p2, address p3) internal view {
1717 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
1718 	}
1719 
1720 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
1721 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
1722 	}
1723 
1724 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
1725 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
1726 	}
1727 
1728 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
1729 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
1730 	}
1731 
1732 	function log(address p0, uint p1, string memory p2, address p3) internal view {
1733 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
1734 	}
1735 
1736 	function log(address p0, uint p1, bool p2, uint p3) internal view {
1737 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
1738 	}
1739 
1740 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
1741 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
1742 	}
1743 
1744 	function log(address p0, uint p1, bool p2, bool p3) internal view {
1745 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
1746 	}
1747 
1748 	function log(address p0, uint p1, bool p2, address p3) internal view {
1749 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
1750 	}
1751 
1752 	function log(address p0, uint p1, address p2, uint p3) internal view {
1753 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
1754 	}
1755 
1756 	function log(address p0, uint p1, address p2, string memory p3) internal view {
1757 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
1758 	}
1759 
1760 	function log(address p0, uint p1, address p2, bool p3) internal view {
1761 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
1762 	}
1763 
1764 	function log(address p0, uint p1, address p2, address p3) internal view {
1765 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
1766 	}
1767 
1768 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
1769 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
1770 	}
1771 
1772 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
1773 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
1774 	}
1775 
1776 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
1777 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
1778 	}
1779 
1780 	function log(address p0, string memory p1, uint p2, address p3) internal view {
1781 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
1782 	}
1783 
1784 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
1785 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
1786 	}
1787 
1788 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
1789 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
1790 	}
1791 
1792 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
1793 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
1794 	}
1795 
1796 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
1797 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
1798 	}
1799 
1800 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
1801 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
1802 	}
1803 
1804 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
1805 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
1806 	}
1807 
1808 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
1809 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
1810 	}
1811 
1812 	function log(address p0, string memory p1, bool p2, address p3) internal view {
1813 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
1814 	}
1815 
1816 	function log(address p0, string memory p1, address p2, uint p3) internal view {
1817 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
1818 	}
1819 
1820 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
1821 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
1822 	}
1823 
1824 	function log(address p0, string memory p1, address p2, bool p3) internal view {
1825 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
1826 	}
1827 
1828 	function log(address p0, string memory p1, address p2, address p3) internal view {
1829 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
1830 	}
1831 
1832 	function log(address p0, bool p1, uint p2, uint p3) internal view {
1833 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
1834 	}
1835 
1836 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
1837 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
1838 	}
1839 
1840 	function log(address p0, bool p1, uint p2, bool p3) internal view {
1841 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
1842 	}
1843 
1844 	function log(address p0, bool p1, uint p2, address p3) internal view {
1845 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
1846 	}
1847 
1848 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
1849 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
1850 	}
1851 
1852 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
1853 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
1854 	}
1855 
1856 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
1857 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
1858 	}
1859 
1860 	function log(address p0, bool p1, string memory p2, address p3) internal view {
1861 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
1862 	}
1863 
1864 	function log(address p0, bool p1, bool p2, uint p3) internal view {
1865 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
1866 	}
1867 
1868 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
1869 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
1870 	}
1871 
1872 	function log(address p0, bool p1, bool p2, bool p3) internal view {
1873 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
1874 	}
1875 
1876 	function log(address p0, bool p1, bool p2, address p3) internal view {
1877 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
1878 	}
1879 
1880 	function log(address p0, bool p1, address p2, uint p3) internal view {
1881 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
1882 	}
1883 
1884 	function log(address p0, bool p1, address p2, string memory p3) internal view {
1885 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
1886 	}
1887 
1888 	function log(address p0, bool p1, address p2, bool p3) internal view {
1889 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
1890 	}
1891 
1892 	function log(address p0, bool p1, address p2, address p3) internal view {
1893 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
1894 	}
1895 
1896 	function log(address p0, address p1, uint p2, uint p3) internal view {
1897 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
1898 	}
1899 
1900 	function log(address p0, address p1, uint p2, string memory p3) internal view {
1901 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
1902 	}
1903 
1904 	function log(address p0, address p1, uint p2, bool p3) internal view {
1905 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
1906 	}
1907 
1908 	function log(address p0, address p1, uint p2, address p3) internal view {
1909 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
1910 	}
1911 
1912 	function log(address p0, address p1, string memory p2, uint p3) internal view {
1913 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
1914 	}
1915 
1916 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
1917 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
1918 	}
1919 
1920 	function log(address p0, address p1, string memory p2, bool p3) internal view {
1921 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
1922 	}
1923 
1924 	function log(address p0, address p1, string memory p2, address p3) internal view {
1925 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
1926 	}
1927 
1928 	function log(address p0, address p1, bool p2, uint p3) internal view {
1929 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
1930 	}
1931 
1932 	function log(address p0, address p1, bool p2, string memory p3) internal view {
1933 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
1934 	}
1935 
1936 	function log(address p0, address p1, bool p2, bool p3) internal view {
1937 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
1938 	}
1939 
1940 	function log(address p0, address p1, bool p2, address p3) internal view {
1941 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
1942 	}
1943 
1944 	function log(address p0, address p1, address p2, uint p3) internal view {
1945 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
1946 	}
1947 
1948 	function log(address p0, address p1, address p2, string memory p3) internal view {
1949 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
1950 	}
1951 
1952 	function log(address p0, address p1, address p2, bool p3) internal view {
1953 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
1954 	}
1955 
1956 	function log(address p0, address p1, address p2, address p3) internal view {
1957 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
1958 	}
1959 
1960 }
1961 
1962 /**
1963  * @dev Interface of the ERC20 standard as defined in the EIP.
1964  */
1965 interface IERC20 {
1966     /**
1967      * @dev Returns the amount of tokens in existence.
1968      */
1969     function totalSupply() external view returns (uint256);
1970 
1971     /**
1972      * @dev Returns the amount of tokens owned by `account`.
1973      */
1974     function balanceOf(address account) external view returns (uint256);
1975 
1976     /**
1977      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1978      *
1979      * Returns a boolean value indicating whether the operation succeeded.
1980      *
1981      * Emits a {Transfer} event.
1982      */
1983     function transfer(address recipient, uint256 amount) external returns (bool);
1984 
1985     /**
1986      * @dev Returns the remaining number of tokens that `spender` will be
1987      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1988      * zero by default.
1989      *
1990      * This value changes when {approve} or {transferFrom} are called.
1991      */
1992     function allowance(address owner, address spender) external view returns (uint256);
1993 
1994     /**
1995      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1996      *
1997      * Returns a boolean value indicating whether the operation succeeded.
1998      *
1999      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2000      * that someone may use both the old and the new allowance by unfortunate
2001      * transaction ordering. One possible solution to mitigate this race
2002      * condition is to first reduce the spender's allowance to 0 and set the
2003      * desired value afterwards:
2004      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2005      *
2006      * Emits an {Approval} event.
2007      */
2008     function approve(address spender, uint256 amount) external returns (bool);
2009 
2010     /**
2011      * @dev Moves `amount` tokens from `sender` to `recipient` using the
2012      * allowance mechanism. `amount` is then deducted from the caller's
2013      * allowance.
2014      *
2015      * Returns a boolean value indicating whether the operation succeeded.
2016      *
2017      * Emits a {Transfer} event.
2018      */
2019     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
2020 
2021     /**
2022      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2023      * another (`to`).
2024      *
2025      * Note that `value` may be zero.
2026      */
2027     event Transfer(address indexed from, address indexed to, uint256 value);
2028 
2029     /**
2030      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2031      * a call to {approve}. `value` is the new allowance.
2032      */
2033     event Approval(address indexed owner, address indexed spender, uint256 value);
2034 }
2035 
2036 interface IUniswapV2Factory {
2037     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
2038 
2039     function feeTo() external view returns (address);
2040     function feeToSetter() external view returns (address);
2041     function migrator() external view returns (address);
2042 
2043     function getPair(address tokenA, address tokenB) external view returns (address pair);
2044     function allPairs(uint) external view returns (address pair);
2045     function allPairsLength() external view returns (uint);
2046 
2047     function createPair(address tokenA, address tokenB) external returns (address pair);
2048 
2049     function setFeeTo(address) external;
2050     function setFeeToSetter(address) external;
2051     function setMigrator(address) external;
2052 }
2053 
2054 interface IUniswapV2Router01 {
2055     function factory() external pure returns (address);
2056     function WETH() external pure returns (address);
2057 
2058     function addLiquidity(
2059         address tokenA,
2060         address tokenB,
2061         uint amountADesired,
2062         uint amountBDesired,
2063         uint amountAMin,
2064         uint amountBMin,
2065         address to,
2066         uint deadline
2067     ) external returns (uint amountA, uint amountB, uint liquidity);
2068     function addLiquidityETH(
2069         address token,
2070         uint amountTokenDesired,
2071         uint amountTokenMin,
2072         uint amountETHMin,
2073         address to,
2074         uint deadline
2075     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
2076     function removeLiquidity(
2077         address tokenA,
2078         address tokenB,
2079         uint liquidity,
2080         uint amountAMin,
2081         uint amountBMin,
2082         address to,
2083         uint deadline
2084     ) external returns (uint amountA, uint amountB);
2085     function removeLiquidityETH(
2086         address token,
2087         uint liquidity,
2088         uint amountTokenMin,
2089         uint amountETHMin,
2090         address to,
2091         uint deadline
2092     ) external returns (uint amountToken, uint amountETH);
2093     function removeLiquidityWithPermit(
2094         address tokenA,
2095         address tokenB,
2096         uint liquidity,
2097         uint amountAMin,
2098         uint amountBMin,
2099         address to,
2100         uint deadline,
2101         bool approveMax, uint8 v, bytes32 r, bytes32 s
2102     ) external returns (uint amountA, uint amountB);
2103     function removeLiquidityETHWithPermit(
2104         address token,
2105         uint liquidity,
2106         uint amountTokenMin,
2107         uint amountETHMin,
2108         address to,
2109         uint deadline,
2110         bool approveMax, uint8 v, bytes32 r, bytes32 s
2111     ) external returns (uint amountToken, uint amountETH);
2112     function swapExactTokensForTokens(
2113         uint amountIn,
2114         uint amountOutMin,
2115         address[] calldata path,
2116         address to,
2117         uint deadline
2118     ) external returns (uint[] memory amounts);
2119     function swapTokensForExactTokens(
2120         uint amountOut,
2121         uint amountInMax,
2122         address[] calldata path,
2123         address to,
2124         uint deadline
2125     ) external returns (uint[] memory amounts);
2126     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
2127         external
2128         payable
2129         returns (uint[] memory amounts);
2130     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
2131         external
2132         returns (uint[] memory amounts);
2133     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
2134         external
2135         returns (uint[] memory amounts);
2136     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
2137         external
2138         payable
2139         returns (uint[] memory amounts);
2140 
2141     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
2142     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
2143     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
2144     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
2145     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
2146 }
2147 
2148 interface IUniswapV2Router02 is IUniswapV2Router01 {
2149     function removeLiquidityETHSupportingFeeOnTransferTokens(
2150         address token,
2151         uint liquidity,
2152         uint amountTokenMin,
2153         uint amountETHMin,
2154         address to,
2155         uint deadline
2156     ) external returns (uint amountETH);
2157     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
2158         address token,
2159         uint liquidity,
2160         uint amountTokenMin,
2161         uint amountETHMin,
2162         address to,
2163         uint deadline,
2164         bool approveMax, uint8 v, bytes32 r, bytes32 s
2165     ) external returns (uint amountETH);
2166 
2167     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
2168         uint amountIn,
2169         uint amountOutMin,
2170         address[] calldata path,
2171         address to,
2172         uint deadline
2173     ) external;
2174     function swapExactETHForTokensSupportingFeeOnTransferTokens(
2175         uint amountOutMin,
2176         address[] calldata path,
2177         address to,
2178         uint deadline
2179     ) external payable;
2180     function swapExactTokensForETHSupportingFeeOnTransferTokens(
2181         uint amountIn,
2182         uint amountOutMin,
2183         address[] calldata path,
2184         address to,
2185         uint deadline
2186     ) external;
2187 }
2188 
2189 interface IUniswapV2Pair {
2190     event Approval(address indexed owner, address indexed spender, uint value);
2191     event Transfer(address indexed from, address indexed to, uint value);
2192 
2193     function name() external pure returns (string memory);
2194     function symbol() external pure returns (string memory);
2195     function decimals() external pure returns (uint8);
2196     function totalSupply() external view returns (uint);
2197     function balanceOf(address owner) external view returns (uint);
2198     function allowance(address owner, address spender) external view returns (uint);
2199 
2200     function approve(address spender, uint value) external returns (bool);
2201     function transfer(address to, uint value) external returns (bool);
2202     function transferFrom(address from, address to, uint value) external returns (bool);
2203 
2204     function DOMAIN_SEPARATOR() external view returns (bytes32);
2205     function PERMIT_TYPEHASH() external pure returns (bytes32);
2206     function nonces(address owner) external view returns (uint);
2207 
2208     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
2209 
2210     event Mint(address indexed sender, uint amount0, uint amount1);
2211     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
2212     event Swap(
2213         address indexed sender,
2214         uint amount0In,
2215         uint amount1In,
2216         uint amount0Out,
2217         uint amount1Out,
2218         address indexed to
2219     );
2220     event Sync(uint112 reserve0, uint112 reserve1);
2221 
2222     function MINIMUM_LIQUIDITY() external pure returns (uint);
2223     function factory() external view returns (address);
2224     function token0() external view returns (address);
2225     function token1() external view returns (address);
2226     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
2227     function price0CumulativeLast() external view returns (uint);
2228     function price1CumulativeLast() external view returns (uint);
2229     function kLast() external view returns (uint);
2230 
2231     function mint(address to) external returns (uint liquidity);
2232     function burn(address to) external returns (uint amount0, uint amount1);
2233     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
2234     function skim(address to) external;
2235     function sync() external;
2236 
2237     function initialize(address, address) external;
2238 }
2239 
2240 interface IWETH {
2241     function deposit() external payable;
2242     function transfer(address to, uint value) external returns (bool);
2243     function withdraw(uint) external;
2244 }
2245 
2246 /**
2247  * @dev Contract module which provides a basic access control mechanism, where
2248  * there is an account (an owner) that can be granted exclusive access to
2249  * specific functions.
2250  *
2251  * By default, the owner account will be the one that deploys the contract. This
2252  * can later be changed with {transferOwnership}.
2253  *
2254  * This module is used through inheritance. It will make available the modifier
2255  * `onlyOwner`, which can be applied to your functions to restrict their use to
2256  * the owner.
2257  */
2258 contract Ownable is Context {
2259     address private _owner;
2260 
2261     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2262 
2263     /**
2264      * @dev Initializes the contract setting the deployer as the initial owner.
2265      */
2266     constructor () internal {
2267         address msgSender = _msgSender();
2268         _owner = msgSender;
2269         emit OwnershipTransferred(address(0), msgSender);
2270     }
2271 
2272     /**
2273      * @dev Returns the address of the current owner.
2274      */
2275     function owner() public view returns (address) {
2276         return _owner;
2277     }
2278 
2279     /**
2280      * @dev Throws if called by any account other than the owner.
2281      */
2282     modifier onlyOwner() {
2283         require(_owner == _msgSender(), "Ownable: caller is not the owner");
2284         _;
2285     }
2286 
2287     /**
2288      * @dev Leaves the contract without owner. It will not be possible to call
2289      * `onlyOwner` functions anymore. Can only be called by the current owner.
2290      *
2291      * NOTE: Renouncing ownership will leave the contract without an owner,
2292      * thereby removing any functionality that is only available to the owner.
2293      */
2294     function renounceOwnership() public virtual onlyOwner {
2295         emit OwnershipTransferred(_owner, address(0));
2296         _owner = address(0);
2297     }
2298 
2299     /**
2300      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2301      * Can only be called by the current owner.
2302      */
2303     function transferOwnership(address newOwner) public virtual onlyOwner {
2304         require(newOwner != address(0), "Ownable: new owner is the zero address");
2305         emit OwnershipTransferred(_owner, newOwner);
2306         _owner = newOwner;
2307     }
2308 }
2309 
2310 /**
2311  * @dev Implementation of the {IERC20} interface.
2312  *
2313  * This implementation is agnostic to the way tokens are created. This means
2314  * that a supply mechanism has to be added in a derived contract using {_mint}.
2315  * For a generic mechanism see {ERC20PresetMinterPauser}.
2316  *
2317  * TIP: For a detailed writeup see our guide
2318  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
2319  * to implement supply mechanisms].
2320  *
2321  * We have followed general OpenZeppelin guidelines: functions revert instead
2322  * of returning `false` on failure. This behavior is nonetheless conventional
2323  * and does not conflict with the expectations of ERC20 applications.
2324  *
2325  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
2326  * This allows applications to reconstruct the allowance for all accounts just
2327  * by listening to said events. Other implementations of the EIP may not emit
2328  * these events, as it isn't required by the specification.
2329  *
2330  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
2331  * functions have been added to mitigate the well-known issues around setting
2332  * allowances. See {IERC20-approve}.
2333  */
2334 contract NBUNIERC20 is Context, INBUNIERC20, Ownable {
2335     using SafeMath for uint256;
2336     using Address for address;
2337 
2338     mapping(address => uint256) private _balances;
2339 
2340     mapping(address => mapping(address => uint256)) private _allowances;
2341 
2342     event LiquidityAddition(address indexed dst, uint value);
2343     event LPTokenClaimed(address dst, uint value);
2344 
2345     uint256 private _totalSupply;
2346 
2347     string private _name;
2348     string private _symbol;
2349     uint8 private _decimals;
2350     uint256 public constant initialSupply = 10000e18; // 10k
2351     uint256 public contractStartTimestamp;
2352 
2353     function initialSetup() internal {
2354         _name = "Kore";
2355         _symbol = "KORE";
2356         _decimals = 18;
2357         _mint(address(this), initialSupply);
2358         contractStartTimestamp = block.timestamp;
2359         uniswapRouterV2 = IUniswapV2Router02(address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D));
2360         uniswapFactory = IUniswapV2Factory(address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f));
2361         createUniswapPairMainnet();
2362     }
2363 
2364     /**
2365      * @dev Returns the name of the token.
2366      */
2367     function name() public view returns (string memory)
2368     {
2369         return _name;
2370     }
2371 
2372     /**
2373      * @dev Returns the symbol of the token, usually a shorter version of the
2374      * name.
2375      */
2376     function symbol() public view returns (string memory) {
2377         return _symbol;
2378     }
2379 
2380     /**
2381      * @dev Returns the number of decimals used to get its user representation.
2382      * For example, if `decimals` equals `2`, a balance of `505` tokens should
2383      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
2384      *
2385      * Tokens usually opt for a value of 18, imitating the relationship between
2386      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
2387      * called.
2388      *
2389      * NOTE: This information is only used for _display_ purposes: it in
2390      * no way affects any of the arithmetic of the contract, including
2391      * {IERC20-balanceOf} and {IERC20-transfer}.
2392      */
2393     function decimals() public view returns (uint8) {
2394         return _decimals;
2395     }
2396 
2397     /**
2398      * @dev See {IERC20-totalSupply}.
2399      */
2400     function totalSupply() public override view returns (uint256) {
2401         return _totalSupply;
2402     }
2403 
2404     /**
2405      * @dev See {IERC20-balanceOf}.
2406      */
2407     // function balanceOf(address account) public override returns (uint256) {
2408     //     return _balances[account];
2409     // }
2410     function balanceOf(address _owner) public override view returns (uint256) {
2411         return _balances[_owner];
2412     }
2413 
2414 
2415     IUniswapV2Router02 public uniswapRouterV2;
2416     IUniswapV2Factory public uniswapFactory;
2417 
2418 
2419     address public tokenUniswapPair;
2420 
2421     function createUniswapPairMainnet()
2422         public
2423         returns (address)
2424     {
2425         require(tokenUniswapPair == address(0), "Token: pool already created");
2426         tokenUniswapPair = uniswapFactory.createPair(
2427             address(uniswapRouterV2.WETH()),
2428             address(this)
2429         );
2430         return tokenUniswapPair;
2431     }
2432 
2433 
2434     //// Liquidity generation logic
2435     /// Steps - All tokens tat will ever exist go to this contract
2436     /// This contract accepts ETH as payable
2437     /// ETH is mapped to people
2438     /// When liquidity generationevent is over veryone can call
2439     /// the mint LP function
2440     // which will put all the ETH and tokens inside the uniswap contract
2441     /// without any involvement
2442     /// This LP will go into this contract
2443     /// And will be able to proportionally be withdrawn baed on ETH put in
2444     /// A emergency drain function allows the contract owner to drain all ETH and tokens from this contract
2445     /// After the liquidity generation event happened. In case something goes wrong, to send ETH back
2446 
2447 
2448     string public liquidityGenerationParticipationAgreement = "I agree that the developers and affiliated parties of the Kore team are not responsible for your funds";
2449 
2450     function getSecondsLeftInLiquidityGenerationEvent()
2451         public
2452         view
2453         returns (uint256)
2454     {
2455         require(liquidityGenerationOngoing(), "Event over");
2456         console.log("7 days since start is", contractStartTimestamp.add(7 days), "Time now is", block.timestamp);
2457         return contractStartTimestamp.add(7 days).sub(block.timestamp);
2458     }
2459 
2460     function liquidityGenerationOngoing()
2461         public
2462         view
2463         returns (bool)
2464     {
2465         console.log("7 days since start is", contractStartTimestamp.add(7 days), "Time now is", block.timestamp);
2466         console.log("liquidity generation ongoing", contractStartTimestamp.add(7 days) < block.timestamp);
2467         return contractStartTimestamp.add(7 days) > block.timestamp;
2468     }
2469 
2470     uint256 public totalLPTokensMinted;
2471     uint256 public totalETHContributed;
2472     uint256 public LPperETHUnit;
2473     bool public LPGenerationCompleted;
2474 
2475     mapping (address => uint)  public ethContributed;
2476     // Possible ways this could break addressed
2477     // 1) No ageement to terms - added require
2478     // 2) Adding liquidity after generaion is over - added require
2479     // 3) Overflow from uint - impossible there isnt that much ETH aviable
2480     // 4) Depositing 0 - not an issue it will just add 0 to tally
2481     function addLiquidity(bool agreesToTermsOutlinedInLiquidityGenerationParticipationAgreement)
2482         public
2483         payable
2484     {
2485         require(liquidityGenerationOngoing(), "Liquidity Generation Event over");
2486         require(agreesToTermsOutlinedInLiquidityGenerationParticipationAgreement, "No agreement provided");
2487         ethContributed[msg.sender] += msg.value; // Overflow protection from safemath is not neded here
2488         totalETHContributed = totalETHContributed.add(msg.value); // for front end display during LGE. This resets with definietly correct balance while calling pair.
2489         emit LiquidityAddition(msg.sender, msg.value);
2490     }
2491 
2492     // Sends all avaibile balances and mints LP tokens
2493     // Possible ways this could break addressed
2494     // 1) Multiple calls and resetting amounts - addressed with boolean
2495     // 2) Failed WETH wrapping/unwrapping addressed with checks
2496     // 3) Failure to create LP tokens, addressed with checks
2497     // 4) Unacceptable division errors . Addressed with multiplications by 1e18
2498     // 5) Pair not set - impossible since its set in constructor
2499     function addLiquidityToUniswapKORExWETHPair() public {
2500         require(liquidityGenerationOngoing() == false, "Liquidity generation onging");
2501         require(LPGenerationCompleted == false, "Liquidity generation already finished");
2502         totalETHContributed = address(this).balance;
2503         IUniswapV2Pair pair = IUniswapV2Pair(tokenUniswapPair);
2504         console.log("Balance of this", totalETHContributed / 1e18);
2505         //Wrap eth
2506         address WETH = uniswapRouterV2.WETH();
2507         IWETH(WETH).deposit{value : totalETHContributed}();
2508         require(address(this).balance == 0 , "Transfer Failed");
2509         IWETH(WETH).transfer(address(pair),totalETHContributed);
2510         emit Transfer(address(this), address(pair), _balances[address(this)]);
2511         _balances[address(pair)] = _balances[address(this)];
2512         _balances[address(this)] = 0;
2513         pair.mint(address(this));
2514         totalLPTokensMinted = pair.balanceOf(address(this));
2515         console.log("Total tokens minted",totalLPTokensMinted);
2516         require(totalLPTokensMinted != 0 , "LP creation failed");
2517         LPperETHUnit = totalLPTokensMinted.mul(1e18).div(totalETHContributed); // 1e18x for  change
2518         console.log("Total per LP token", LPperETHUnit);
2519         require(LPperETHUnit != 0 , "LP creation failed");
2520         LPGenerationCompleted = true;
2521     }
2522 
2523     // Possible ways this could break addressed
2524     // 1) Accessing before event is over and resetting eth contributed -- added require
2525     // 2) No uniswap pair - impossible at this moment because of the LPGenerationCompleted bool
2526     // 3) LP per unit is 0 - impossible checked at generation function
2527     function claimLPTokens() public {
2528         require(LPGenerationCompleted, "Event not over yet");
2529         require(ethContributed[msg.sender] > 0 , "Nothing to claim, move along");
2530         IUniswapV2Pair pair = IUniswapV2Pair(tokenUniswapPair);
2531         uint256 amountLPToTransfer = ethContributed[msg.sender].mul(LPperETHUnit).div(1e18);
2532         pair.transfer(msg.sender, amountLPToTransfer); // stored as 1e18x value for change
2533         ethContributed[msg.sender] = 0;
2534         emit LPTokenClaimed(msg.sender, amountLPToTransfer);
2535     }
2536 
2537     // Emergency drain in case of a bug
2538     // Adds all funds to owner to refund people
2539     // Designed to be as simple as possible
2540     function emergencyDrain24hAfterLiquidityGenerationEventIsDone() public onlyOwner {
2541         require(contractStartTimestamp.add(8 days) < block.timestamp, "Liquidity generation grace period still ongoing"); // About 24h after liquidity generation happens
2542         (bool success, ) = msg.sender.call.value(address(this).balance)("");
2543         require(success, "Transfer failed.");
2544         _balances[msg.sender] = _balances[address(this)];
2545         _balances[address(this)] = 0;
2546     }
2547 
2548     // Add mint and burn functions incase we want to increase or decrease supply in the future
2549     // Minter role is controlled by governance
2550     mapping(address => bool) public isMinter;
2551 
2552     function setMinter(address _minter, bool _minterStatus) public onlyOwner {
2553         isMinter[_minter] = _minterStatus;
2554     }
2555 
2556     function mint(address account, uint256 amount) public {
2557         require(isMinter[msg.sender], "not a minter");
2558         _mint(account, amount);
2559     }
2560 
2561     function burn(uint256 amount) public {
2562         _burn(msg.sender, amount);
2563     }
2564 
2565     /**
2566      * @dev See {IERC20-transfer}.
2567      *
2568      * Requirements:
2569      *
2570      * - `recipient` cannot be the zero address.
2571      * - the caller must have a balance of at least `amount`.
2572      */
2573     function transfer(address recipient, uint256 amount) public virtual override returns (bool)
2574     {
2575         _transfer(_msgSender(), recipient, amount);
2576         return true;
2577     }
2578 
2579     /**
2580      * @dev See {IERC20-allowance}.
2581      */
2582     function allowance(address owner, address spender)
2583         public
2584         virtual
2585         override
2586         view
2587         returns (uint256)
2588     {
2589         return _allowances[owner][spender];
2590     }
2591 
2592     /**
2593      * @dev See {IERC20-approve}.
2594      *
2595      * Requirements:
2596      *
2597      * - `spender` cannot be the zero address.
2598      */
2599     function approve(address spender, uint256 amount)
2600         public
2601         virtual
2602         override
2603         returns (bool)
2604     {
2605         _approve(_msgSender(), spender, amount);
2606         return true;
2607     }
2608 
2609     /**
2610      * @dev See {IERC20-transferFrom}.
2611      *
2612      * Emits an {Approval} event indicating the updated allowance. This is not
2613      * required by the EIP. See the note at the beginning of {ERC20};
2614      *
2615      * Requirements:
2616      * - `sender` and `recipient` cannot be the zero address.
2617      * - `sender` must have a balance of at least `amount`.
2618      * - the caller must have allowance for ``sender``'s tokens of at least
2619      * `amount`.
2620      */
2621     function transferFrom(
2622         address sender,
2623         address recipient,
2624         uint256 amount
2625     ) public virtual override returns (bool) {
2626         _transfer(sender, recipient, amount);
2627         _approve(
2628             sender,
2629             _msgSender(),
2630             _allowances[sender][_msgSender()].sub(
2631                 amount,
2632                 "ERC20: transfer amount exceeds allowance"
2633             )
2634         );
2635         return true;
2636     }
2637 
2638     /**
2639      * @dev Atomically increases the allowance granted to `spender` by the caller.
2640      *
2641      * This is an alternative to {approve} that can be used as a mitigation for
2642      * problems described in {IERC20-approve}.
2643      *
2644      * Emits an {Approval} event indicating the updated allowance.
2645      *
2646      * Requirements:
2647      *
2648      * - `spender` cannot be the zero address.
2649      */
2650     function increaseAllowance(address spender, uint256 addedValue)
2651         public
2652         virtual
2653         returns (bool)
2654     {
2655         _approve(
2656             _msgSender(),
2657             spender,
2658             _allowances[_msgSender()][spender].add(addedValue)
2659         );
2660         return true;
2661     }
2662 
2663     /**
2664      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2665      *
2666      * This is an alternative to {approve} that can be used as a mitigation for
2667      * problems described in {IERC20-approve}.
2668      *
2669      * Emits an {Approval} event indicating the updated allowance.
2670      *
2671      * Requirements:
2672      *
2673      * - `spender` cannot be the zero address.
2674      * - `spender` must have allowance for the caller of at least
2675      * `subtractedValue`.
2676      */
2677     function decreaseAllowance(address spender, uint256 subtractedValue)
2678         public
2679         virtual
2680         returns (bool)
2681     {
2682         _approve(
2683             _msgSender(),
2684             spender,
2685             _allowances[_msgSender()][spender].sub(
2686                 subtractedValue,
2687                 "ERC20: decreased allowance below zero"
2688             )
2689         );
2690         return true;
2691     }
2692 
2693     function setShouldTransferChecker(address _transferCheckerAddress)
2694         public
2695         onlyOwner
2696     {
2697         transferCheckerAddress = _transferCheckerAddress;
2698     }
2699 
2700     address public transferCheckerAddress;
2701 
2702     function setFeeDistributor(address _feeDistributor)
2703         public
2704         onlyOwner
2705     {
2706         feeDistributor = _feeDistributor;
2707     }
2708 
2709     address public feeDistributor;
2710 
2711 
2712 
2713     /**
2714      * @dev Moves tokens `amount` from `sender` to `recipient`.
2715      *
2716      * This is internal function is equivalent to {transfer}, and can be used to
2717      * e.g. implement automatic token fees, slashing mechanisms, etc.
2718      *
2719      * Emits a {Transfer} event.
2720      *
2721      * Requirements:
2722      *
2723      * - `sender` cannot be the zero address.
2724      * - `recipient` cannot be the zero address.
2725      * - `sender` must have a balance of at least `amount`.
2726      */
2727     function _transfer(
2728         address sender,
2729         address recipient,
2730         uint256 amount
2731     ) internal virtual {
2732         require(sender != address(0), "ERC20: transfer from the zero address");
2733         require(recipient != address(0), "ERC20: transfer to the zero address");
2734 
2735 
2736 
2737         _beforeTokenTransfer(sender, recipient, amount);
2738 
2739         _balances[sender] = _balances[sender].sub(
2740             amount,
2741             "ERC20: transfer amount exceeds balance"
2742         );
2743 
2744         (uint256 transferToAmount, uint256 transferToFeeDistributorAmount) = IFeeApprover(transferCheckerAddress).calculateAmountsAfterFee(sender, recipient, amount);
2745 
2746 
2747         // Addressing a broken checker contract
2748         require(transferToAmount.add(transferToFeeDistributorAmount) == amount, "Math broke, does gravity still work?");
2749 
2750         _balances[recipient] = _balances[recipient].add(transferToAmount);
2751         emit Transfer(sender, recipient, transferToAmount);
2752 
2753         if(transferToFeeDistributorAmount > 0 && feeDistributor != address(0)){
2754             _balances[feeDistributor] = _balances[feeDistributor].add(transferToFeeDistributorAmount);
2755             emit Transfer(sender, feeDistributor, transferToFeeDistributorAmount);
2756             if(feeDistributor != address(0)){
2757                 IKoreVault(feeDistributor).addPendingRewards(transferToFeeDistributorAmount);
2758             }
2759         }
2760     }
2761 
2762     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2763      * the total supply.
2764      *
2765      * Emits a {Transfer} event with `from` set to the zero address.
2766      *
2767      * Requirements
2768      *
2769      * - `to` cannot be the zero address.
2770      */
2771 
2772     function _mint(address account, uint256 amount) internal virtual {
2773         require(account != address(0), "ERC20: mint to the zero address");
2774 
2775         _beforeTokenTransfer(address(0), account, amount);
2776 
2777         _totalSupply = _totalSupply.add(amount);
2778         _balances[account] = _balances[account].add(amount);
2779         emit Transfer(address(0), account, amount);
2780     }
2781 
2782     /**
2783      * @dev Destroys `amount` tokens from `account`, reducing the
2784      * total supply.
2785      *
2786      * Emits a {Transfer} event with `to` set to the zero address.
2787      *
2788      * Requirements
2789      *
2790      * - `account` cannot be the zero address.
2791      * - `account` must have at least `amount` tokens.
2792      */
2793     function _burn(address account, uint256 amount) internal virtual {
2794         require(account != address(0), "ERC20: burn from the zero address");
2795 
2796         _beforeTokenTransfer(account, address(0), amount);
2797 
2798         _balances[account] = _balances[account].sub(
2799             amount,
2800             "ERC20: burn amount exceeds balance"
2801         );
2802         _totalSupply = _totalSupply.sub(amount);
2803         emit Transfer(account, address(0), amount);
2804     }
2805 
2806     /**
2807      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
2808      *
2809      * This is internal function is equivalent to `approve`, and can be used to
2810      * e.g. set automatic allowances for certain subsystems, etc.
2811      *
2812      * Emits an {Approval} event.
2813      *
2814      * Requirements:
2815      *
2816      * - `owner` cannot be the zero address.
2817      * - `spender` cannot be the zero address.
2818      */
2819     function _approve(
2820         address owner,
2821         address spender,
2822         uint256 amount
2823     ) internal virtual {
2824         require(owner != address(0), "ERC20: approve from the zero address");
2825         require(spender != address(0), "ERC20: approve to the zero address");
2826 
2827         _allowances[owner][spender] = amount;
2828         emit Approval(owner, spender, amount);
2829     }
2830 
2831     /**
2832      * @dev Sets {decimals} to a value other than the default one of 18.
2833      *
2834      * WARNING: This function should only be called from the constructor. Most
2835      * applications that interact with token contracts will not expect
2836      * {decimals} to ever change, and may work incorrectly if it does.
2837      */
2838     function _setupDecimals(uint8 decimals_) internal {
2839         _decimals = decimals_;
2840     }
2841 
2842     /**
2843      * @dev Hook that is called before any transfer of tokens. This includes
2844      * minting and burning.
2845      *
2846      * Calling conditions:
2847      *
2848      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2849      * will be to transferred to `to`.
2850      * - when `from` is zero, `amount` tokens will be minted for `to`.
2851      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2852      * - `from` and `to` are never both zero.
2853      *
2854      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2855      */
2856     function _beforeTokenTransfer(
2857         address from,
2858         address to,
2859         uint256 amount
2860     ) internal virtual {}
2861 }
2862 
2863 // KoreToken with Governance.
2864 contract KORE is NBUNIERC20 {
2865     /**
2866      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
2867      * a default value of 18.
2868      *
2869      * To select a different value for {decimals}, use {_setupDecimals}.
2870      *
2871      * All three of these values are immutable: they can only be set once during
2872      * construction.
2873      */
2874     constructor() public {
2875         initialSetup();
2876     }
2877 
2878     // Copied and modified from YAM code:
2879     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
2880     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
2881     // Which is copied and modified from COMPOUND:
2882     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
2883 
2884     mapping (address => address) internal _delegates;
2885 
2886     /// @notice A checkpoint for marking number of votes from a given block
2887     struct Checkpoint {
2888         uint32 fromBlock;
2889         uint256 votes;
2890     }
2891 
2892 
2893     /// @notice A record of votes checkpoints for each account, by index
2894     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
2895 
2896     /// @notice The number of checkpoints for each account
2897     mapping (address => uint32) public numCheckpoints;
2898 
2899     /// @notice The EIP-712 typehash for the contract's domain
2900     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
2901 
2902     /// @notice The EIP-712 typehash for the delegation struct used by the contract
2903     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
2904 
2905     /// @notice A record of states for signing / validating signatures
2906     mapping (address => uint) public nonces;
2907 
2908       /// @notice An event thats emitted when an account changes its delegate
2909     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
2910 
2911     /// @notice An event thats emitted when a delegate account's vote balance changes
2912     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
2913 
2914     /**
2915      * @notice Delegate votes from `msg.sender` to `delegatee`
2916      * @param delegator The address to get delegatee for
2917      */
2918     function delegates(address delegator)
2919         external
2920         view
2921         returns (address)
2922     {
2923         return _delegates[delegator];
2924     }
2925 
2926    /**
2927     * @notice Delegate votes from `msg.sender` to `delegatee`
2928     * @param delegatee The address to delegate votes to
2929     */
2930     function delegate(address delegatee) external {
2931         return _delegate(msg.sender, delegatee);
2932     }
2933 
2934     /**
2935      * @notice Delegates votes from signatory to `delegatee`
2936      * @param delegatee The address to delegate votes to
2937      * @param nonce The contract state required to match the signature
2938      * @param expiry The time at which to expire the signature
2939      * @param v The recovery byte of the signature
2940      * @param r Half of the ECDSA signature pair
2941      * @param s Half of the ECDSA signature pair
2942      */
2943     function delegateBySig(
2944         address delegatee,
2945         uint nonce,
2946         uint expiry,
2947         uint8 v,
2948         bytes32 r,
2949         bytes32 s
2950     )
2951         external
2952     {
2953         bytes32 domainSeparator = keccak256(
2954             abi.encode(
2955                 DOMAIN_TYPEHASH,
2956                 keccak256(bytes(name())),
2957                 getChainId(),
2958                 address(this)
2959             )
2960         );
2961 
2962         bytes32 structHash = keccak256(
2963             abi.encode(
2964                 DELEGATION_TYPEHASH,
2965                 delegatee,
2966                 nonce,
2967                 expiry
2968             )
2969         );
2970 
2971         bytes32 digest = keccak256(
2972             abi.encodePacked(
2973                 "\x19\x01",
2974                 domainSeparator,
2975                 structHash
2976             )
2977         );
2978 
2979         address signatory = ecrecover(digest, v, r, s);
2980         require(signatory != address(0), "KORE::delegateBySig: invalid signature");
2981         require(nonce == nonces[signatory]++, "KORE::delegateBySig: invalid nonce");
2982         require(now <= expiry, "KORE::delegateBySig: signature expired");
2983         return _delegate(signatory, delegatee);
2984     }
2985 
2986     /**
2987      * @notice Gets the current votes balance for `account`
2988      * @param account The address to get votes balance
2989      * @return The number of current votes for `account`
2990      */
2991     function getCurrentVotes(address account)
2992         external
2993         view
2994         returns (uint256)
2995     {
2996         uint32 nCheckpoints = numCheckpoints[account];
2997         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
2998     }
2999 
3000     /**
3001      * @notice Determine the prior number of votes for an account as of a block number
3002      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
3003      * @param account The address of the account to check
3004      * @param blockNumber The block number to get the vote balance at
3005      * @return The number of votes the account had as of the given block
3006      */
3007     function getPriorVotes(address account, uint blockNumber)
3008         external
3009         view
3010         returns (uint256)
3011     {
3012         require(blockNumber < block.number, "KORE::getPriorVotes: not yet determined");
3013 
3014         uint32 nCheckpoints = numCheckpoints[account];
3015         if (nCheckpoints == 0) {
3016             return 0;
3017         }
3018 
3019         // First check most recent balance
3020         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
3021             return checkpoints[account][nCheckpoints - 1].votes;
3022         }
3023 
3024         // Next check implicit zero balance
3025         if (checkpoints[account][0].fromBlock > blockNumber) {
3026             return 0;
3027         }
3028 
3029         uint32 lower = 0;
3030         uint32 upper = nCheckpoints - 1;
3031         while (upper > lower) {
3032             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
3033             Checkpoint memory cp = checkpoints[account][center];
3034             if (cp.fromBlock == blockNumber) {
3035                 return cp.votes;
3036             } else if (cp.fromBlock < blockNumber) {
3037                 lower = center;
3038             } else {
3039                 upper = center - 1;
3040             }
3041         }
3042         return checkpoints[account][lower].votes;
3043     }
3044 
3045     function _delegate(address delegator, address delegatee)
3046         internal
3047     {
3048         address currentDelegate = _delegates[delegator];
3049         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying KORE tokens (not scaled);
3050         _delegates[delegator] = delegatee;
3051 
3052         emit DelegateChanged(delegator, currentDelegate, delegatee);
3053 
3054         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
3055     }
3056 
3057     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
3058         if (srcRep != dstRep && amount > 0) {
3059             if (srcRep != address(0)) {
3060                 // decrease old representative
3061                 uint32 srcRepNum = numCheckpoints[srcRep];
3062                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
3063                 uint256 srcRepNew = srcRepOld.sub(amount);
3064                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
3065             }
3066 
3067             if (dstRep != address(0)) {
3068                 // increase new representative
3069                 uint32 dstRepNum = numCheckpoints[dstRep];
3070                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
3071                 uint256 dstRepNew = dstRepOld.add(amount);
3072                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
3073             }
3074         }
3075     }
3076 
3077     function _writeCheckpoint(
3078         address delegatee,
3079         uint32 nCheckpoints,
3080         uint256 oldVotes,
3081         uint256 newVotes
3082     )
3083         internal
3084     {
3085         uint32 blockNumber = safe32(block.number, "KORE::_writeCheckpoint: block number exceeds 32 bits");
3086 
3087         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
3088             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
3089         } else {
3090             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
3091             numCheckpoints[delegatee] = nCheckpoints + 1;
3092         }
3093 
3094         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
3095     }
3096 
3097     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
3098         require(n < 2**32, errorMessage);
3099         return uint32(n);
3100     }
3101 
3102     function getChainId() internal pure returns (uint) {
3103         uint256 chainId;
3104         assembly { chainId := chainid() }
3105         return chainId;
3106     }
3107 }
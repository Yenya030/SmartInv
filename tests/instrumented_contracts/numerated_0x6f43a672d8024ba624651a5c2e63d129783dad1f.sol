1 // File: contracts-eth/interfaces/IBEP20.sol
2 
3 
4 
5 pragma solidity >=0.4.0;
6 
7 interface IBEP20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the token decimals.
15      */
16     function decimals() external view returns (uint8);
17 
18     /**
19      * @dev Returns the token symbol.
20      */
21     function symbol() external view returns (string memory);
22 
23     /**
24      * @dev Returns the token name.
25      */
26     function name() external view returns (string memory);
27 
28     /**
29      * @dev Returns the bep token owner.
30      */
31     function getOwner() external view returns (address);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `recipient`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address recipient, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address _owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `sender` to `recipient` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(
82         address sender,
83         address recipient,
84         uint256 amount
85     ) external returns (bool);
86 
87     /**
88      * @dev Emitted when `value` tokens are moved from one account (`from`) to
89      * another (`to`).
90      *
91      * Note that `value` may be zero.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     /**
96      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97      * a call to {approve}. `value` is the new allowance.
98      */
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 // File: contracts-eth/interfaces/IPYESwapRouter01.sol
102 
103 
104 
105 pragma solidity ^0.8.0;
106 
107 interface IPYESwapRouter01 {
108     function factory() external pure returns (address);
109     function WETH() external pure returns (address);
110 
111     function addLiquidity(
112         address tokenA,
113         address tokenB,
114         uint amountADesired,
115         uint amountBDesired,
116         uint amountAMin,
117         uint amountBMin,
118         address to,
119         uint deadline
120     ) external returns (uint amountA, uint amountB, uint liquidity);
121     function addLiquidityETH(
122         address token,
123         uint amountTokenDesired,
124         uint amountTokenMin,
125         uint amountETHMin,
126         address to,
127         uint deadline
128     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
129     function removeLiquidity(
130         address tokenA,
131         address tokenB,
132         uint liquidity,
133         uint amountAMin,
134         uint amountBMin,
135         address to,
136         uint deadline
137     ) external returns (uint amountA, uint amountB);
138     function removeLiquidityETH(
139         address token,
140         uint liquidity,
141         uint amountTokenMin,
142         uint amountETHMin,
143         address to,
144         uint deadline
145     ) external returns (uint amountToken, uint amountETH);
146     function removeLiquidityWithPermit(
147         address tokenA,
148         address tokenB,
149         uint liquidity,
150         uint amountAMin,
151         uint amountBMin,
152         address to,
153         uint deadline,
154         bool approveMax, uint8 v, bytes32 r, bytes32 s
155     ) external returns (uint amountA, uint amountB);
156     function removeLiquidityETHWithPermit(
157         address token,
158         uint liquidity,
159         uint amountTokenMin,
160         uint amountETHMin,
161         address to,
162         uint deadline,
163         bool approveMax, uint8 v, bytes32 r, bytes32 s
164     ) external returns (uint amountToken, uint amountETH);
165     function swapExactTokensForTokens(
166         uint amountIn,
167         uint amountOutMin,
168         address[] calldata path,
169         address to,
170         uint deadline
171     ) external returns (uint[] memory amounts);
172     function swapTokensForExactTokens(
173         uint amountOut,
174         uint amountInMax,
175         address[] calldata path,
176         address to,
177         uint deadline
178     ) external returns (uint[] memory amounts);
179     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
180         external
181         payable
182         returns (uint[] memory amounts);
183     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
184         external
185         returns (uint[] memory amounts);
186     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
187         external
188         returns (uint[] memory amounts);
189     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
190         external
191         payable
192         returns (uint[] memory amounts);
193 
194     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
195     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
196     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
197     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
198     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
199 }
200 
201 // File: contracts-eth/interfaces/IPYESwapRouter.sol
202 
203 
204 
205 pragma solidity >=0.6.2;
206 
207 
208 interface IPYESwapRouter is IPYESwapRouter01 {
209     function removeLiquidityETHSupportingFeeOnTransferTokens(
210         address token,
211         uint liquidity,
212         uint amountTokenMin,
213         uint amountETHMin,
214         address to,
215         uint deadline
216     ) external returns (uint amountETH);
217     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
218         address token,
219         uint liquidity,
220         uint amountTokenMin,
221         uint amountETHMin,
222         address to,
223         uint deadline,
224         bool approveMax, uint8 v, bytes32 r, bytes32 s
225     ) external returns (uint amountETH);
226 
227     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
228         uint amountIn,
229         uint amountOutMin,
230         address[] calldata path,
231         address to,
232         uint deadline
233     ) external;
234     function swapExactETHForTokensSupportingFeeOnTransferTokens(
235         uint amountOutMin,
236         address[] calldata path,
237         address to,
238         uint deadline
239     ) external payable;
240     function swapExactTokensForETHSupportingFeeOnTransferTokens(
241         uint amountIn,
242         uint amountOutMin,
243         address[] calldata path,
244         address to,
245         uint deadline
246     ) external;
247     function pairFeeAddress(address pair) external view returns (address);
248     function adminFee() external view returns (uint256);
249     function feeAddressGet() external view returns (address);
250 }
251 
252 // File: contracts-eth/interfaces/IPYESwapPair.sol
253 
254 
255 
256 pragma solidity >=0.5.0;
257 
258 interface IPYESwapPair {
259     event Approval(address indexed owner, address indexed spender, uint value);
260     event Transfer(address indexed from, address indexed to, uint value);
261 
262     function baseToken() external view returns (address);
263     function getTotalFee() external view returns (uint);
264     function name() external pure returns (string memory);
265     function symbol() external pure returns (string memory);
266     function decimals() external pure returns (uint8);
267     function totalSupply() external view returns (uint);
268     function balanceOf(address owner) external view returns (uint);
269     function allowance(address owner, address spender) external view returns (uint);
270     function updateTotalFee(uint totalFee) external returns (bool);
271 
272     function approve(address spender, uint value) external returns (bool);
273     function transfer(address to, uint value) external returns (bool);
274     function transferFrom(address from, address to, uint value) external returns (bool);
275 
276     function DOMAIN_SEPARATOR() external view returns (bytes32);
277     function PERMIT_TYPEHASH() external pure returns (bytes32);
278     function nonces(address owner) external view returns (uint);
279 
280     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
281 
282     event Mint(address indexed sender, uint amount0, uint amount1);
283     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
284     event Swap(
285         address indexed sender,
286         uint amount0In,
287         uint amount1In,
288         uint amount0Out,
289         uint amount1Out,
290         address indexed to
291     );
292     event Sync(uint112 reserve0, uint112 reserve1);
293 
294     function MINIMUM_LIQUIDITY() external pure returns (uint);
295     function factory() external view returns (address);
296     function token0() external view returns (address);
297     function token1() external view returns (address);
298     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast, address _baseToken);
299     function price0CumulativeLast() external view returns (uint);
300     function price1CumulativeLast() external view returns (uint);
301     function kLast() external view returns (uint);
302 
303     function mint(address to) external returns (uint liquidity);
304     function burn(address to) external returns (uint amount0, uint amount1);
305     function swap(uint amount0Out, uint amount1Out, uint amount0Fee, uint amount1Fee, address to, bytes calldata data) external;
306     function skim(address to) external;
307     function sync() external;
308 
309     function initialize(address, address) external;
310     function setBaseToken(address _baseToken) external;
311 }
312 
313 // File: contracts-eth/interfaces/IPYESwapFactory.sol
314 
315 
316 
317 pragma solidity >=0.5.0;
318 
319 interface IPYESwapFactory {
320     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
321 
322     function feeTo() external view returns (address);
323     function feeToSetter() external view returns (address);
324 
325     function getPair(address tokenA, address tokenB) external view returns (address pair);
326     function allPairs(uint) external view returns (address pair);
327     function allPairsLength() external view returns (uint);
328     function pairExist(address pair) external view returns (bool);
329 
330     function createPair(address tokenA, address tokenB, bool supportsTokenFee) external returns (address pair);
331 
332     function setFeeTo(address) external;
333     function setFeeToSetter(address) external;
334     function routerInitialize(address) external;
335     function routerAddress() external view returns (address);
336 }
337 
338 // File: contracts-eth/interfaces/IWETH.sol
339 
340 
341 
342 pragma solidity >=0.5.0;
343 
344 interface IWETH {
345     function balanceOf(address owner) external view returns (uint);
346     function allowance(address owner, address spender) external view returns (uint);
347     function deposit() external payable;
348     function transfer(address to, uint value) external returns (bool);
349     function withdraw(uint) external;
350 }
351 
352 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
353 
354 
355 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
356 
357 pragma solidity ^0.8.0;
358 
359 /**
360  * @dev Interface of the ERC20 standard as defined in the EIP.
361  */
362 interface IERC20 {
363     /**
364      * @dev Returns the amount of tokens in existence.
365      */
366     function totalSupply() external view returns (uint256);
367 
368     /**
369      * @dev Returns the amount of tokens owned by `account`.
370      */
371     function balanceOf(address account) external view returns (uint256);
372 
373     /**
374      * @dev Moves `amount` tokens from the caller's account to `to`.
375      *
376      * Returns a boolean value indicating whether the operation succeeded.
377      *
378      * Emits a {Transfer} event.
379      */
380     function transfer(address to, uint256 amount) external returns (bool);
381 
382     /**
383      * @dev Returns the remaining number of tokens that `spender` will be
384      * allowed to spend on behalf of `owner` through {transferFrom}. This is
385      * zero by default.
386      *
387      * This value changes when {approve} or {transferFrom} are called.
388      */
389     function allowance(address owner, address spender) external view returns (uint256);
390 
391     /**
392      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
393      *
394      * Returns a boolean value indicating whether the operation succeeded.
395      *
396      * IMPORTANT: Beware that changing an allowance with this method brings the risk
397      * that someone may use both the old and the new allowance by unfortunate
398      * transaction ordering. One possible solution to mitigate this race
399      * condition is to first reduce the spender's allowance to 0 and set the
400      * desired value afterwards:
401      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
402      *
403      * Emits an {Approval} event.
404      */
405     function approve(address spender, uint256 amount) external returns (bool);
406 
407     /**
408      * @dev Moves `amount` tokens from `from` to `to` using the
409      * allowance mechanism. `amount` is then deducted from the caller's
410      * allowance.
411      *
412      * Returns a boolean value indicating whether the operation succeeded.
413      *
414      * Emits a {Transfer} event.
415      */
416     function transferFrom(
417         address from,
418         address to,
419         uint256 amount
420     ) external returns (bool);
421 
422     /**
423      * @dev Emitted when `value` tokens are moved from one account (`from`) to
424      * another (`to`).
425      *
426      * Note that `value` may be zero.
427      */
428     event Transfer(address indexed from, address indexed to, uint256 value);
429 
430     /**
431      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
432      * a call to {approve}. `value` is the new allowance.
433      */
434     event Approval(address indexed owner, address indexed spender, uint256 value);
435 }
436 
437 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
438 
439 
440 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
441 
442 pragma solidity ^0.8.0;
443 
444 
445 /**
446  * @dev Interface for the optional metadata functions from the ERC20 standard.
447  *
448  * _Available since v4.1._
449  */
450 interface IERC20Metadata is IERC20 {
451     /**
452      * @dev Returns the name of the token.
453      */
454     function name() external view returns (string memory);
455 
456     /**
457      * @dev Returns the symbol of the token.
458      */
459     function symbol() external view returns (string memory);
460 
461     /**
462      * @dev Returns the decimals places of the token.
463      */
464     function decimals() external view returns (uint8);
465 }
466 
467 // File: @openzeppelin/contracts/utils/Counters.sol
468 
469 
470 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
471 
472 pragma solidity ^0.8.0;
473 
474 /**
475  * @title Counters
476  * @author Matt Condon (@shrugs)
477  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
478  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
479  *
480  * Include with `using Counters for Counters.Counter;`
481  */
482 library Counters {
483     struct Counter {
484         // This variable should never be directly accessed by users of the library: interactions must be restricted to
485         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
486         // this feature: see https://github.com/ethereum/solidity/issues/4637
487         uint256 _value; // default: 0
488     }
489 
490     function current(Counter storage counter) internal view returns (uint256) {
491         return counter._value;
492     }
493 
494     function increment(Counter storage counter) internal {
495         unchecked {
496             counter._value += 1;
497         }
498     }
499 
500     function decrement(Counter storage counter) internal {
501         uint256 value = counter._value;
502         require(value > 0, "Counter: decrement overflow");
503         unchecked {
504             counter._value = value - 1;
505         }
506     }
507 
508     function reset(Counter storage counter) internal {
509         counter._value = 0;
510     }
511 }
512 
513 // File: @openzeppelin/contracts/utils/math/Math.sol
514 
515 
516 // OpenZeppelin Contracts (last updated v4.5.0) (utils/math/Math.sol)
517 
518 pragma solidity ^0.8.0;
519 
520 /**
521  * @dev Standard math utilities missing in the Solidity language.
522  */
523 library Math {
524     /**
525      * @dev Returns the largest of two numbers.
526      */
527     function max(uint256 a, uint256 b) internal pure returns (uint256) {
528         return a >= b ? a : b;
529     }
530 
531     /**
532      * @dev Returns the smallest of two numbers.
533      */
534     function min(uint256 a, uint256 b) internal pure returns (uint256) {
535         return a < b ? a : b;
536     }
537 
538     /**
539      * @dev Returns the average of two numbers. The result is rounded towards
540      * zero.
541      */
542     function average(uint256 a, uint256 b) internal pure returns (uint256) {
543         // (a + b) / 2 can overflow.
544         return (a & b) + (a ^ b) / 2;
545     }
546 
547     /**
548      * @dev Returns the ceiling of the division of two numbers.
549      *
550      * This differs from standard division with `/` in that it rounds up instead
551      * of rounding down.
552      */
553     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
554         // (a + b - 1) / b can overflow on addition, so we distribute.
555         return a / b + (a % b == 0 ? 0 : 1);
556     }
557 }
558 
559 // File: @openzeppelin/contracts/utils/Arrays.sol
560 
561 
562 // OpenZeppelin Contracts v4.4.1 (utils/Arrays.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 
567 /**
568  * @dev Collection of functions related to array types.
569  */
570 library Arrays {
571     /**
572      * @dev Searches a sorted `array` and returns the first index that contains
573      * a value greater or equal to `element`. If no such index exists (i.e. all
574      * values in the array are strictly less than `element`), the array length is
575      * returned. Time complexity O(log n).
576      *
577      * `array` is expected to be sorted in ascending order, and to contain no
578      * repeated elements.
579      */
580     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
581         if (array.length == 0) {
582             return 0;
583         }
584 
585         uint256 low = 0;
586         uint256 high = array.length;
587 
588         while (low < high) {
589             uint256 mid = Math.average(low, high);
590 
591             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
592             // because Math.average rounds down (it does integer division with truncation).
593             if (array[mid] > element) {
594                 high = mid;
595             } else {
596                 low = mid + 1;
597             }
598         }
599 
600         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
601         if (low > 0 && array[low - 1] == element) {
602             return low - 1;
603         } else {
604             return low;
605         }
606     }
607 }
608 
609 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
610 
611 
612 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
613 
614 pragma solidity ^0.8.0;
615 
616 /**
617  * @dev Interface of the ERC165 standard, as defined in the
618  * https://eips.ethereum.org/EIPS/eip-165[EIP].
619  *
620  * Implementers can declare support of contract interfaces, which can then be
621  * queried by others ({ERC165Checker}).
622  *
623  * For an implementation, see {ERC165}.
624  */
625 interface IERC165 {
626     /**
627      * @dev Returns true if this contract implements the interface defined by
628      * `interfaceId`. See the corresponding
629      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
630      * to learn more about how these ids are created.
631      *
632      * This function call must use less than 30 000 gas.
633      */
634     function supportsInterface(bytes4 interfaceId) external view returns (bool);
635 }
636 
637 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
638 
639 
640 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
641 
642 pragma solidity ^0.8.0;
643 
644 
645 /**
646  * @dev Implementation of the {IERC165} interface.
647  *
648  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
649  * for the additional interface id that will be supported. For example:
650  *
651  * ```solidity
652  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
653  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
654  * }
655  * ```
656  *
657  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
658  */
659 abstract contract ERC165 is IERC165 {
660     /**
661      * @dev See {IERC165-supportsInterface}.
662      */
663     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
664         return interfaceId == type(IERC165).interfaceId;
665     }
666 }
667 
668 // File: @openzeppelin/contracts/utils/Strings.sol
669 
670 
671 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
672 
673 pragma solidity ^0.8.0;
674 
675 /**
676  * @dev String operations.
677  */
678 library Strings {
679     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
680 
681     /**
682      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
683      */
684     function toString(uint256 value) internal pure returns (string memory) {
685         // Inspired by OraclizeAPI's implementation - MIT licence
686         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
687 
688         if (value == 0) {
689             return "0";
690         }
691         uint256 temp = value;
692         uint256 digits;
693         while (temp != 0) {
694             digits++;
695             temp /= 10;
696         }
697         bytes memory buffer = new bytes(digits);
698         while (value != 0) {
699             digits -= 1;
700             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
701             value /= 10;
702         }
703         return string(buffer);
704     }
705 
706     /**
707      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
708      */
709     function toHexString(uint256 value) internal pure returns (string memory) {
710         if (value == 0) {
711             return "0x00";
712         }
713         uint256 temp = value;
714         uint256 length = 0;
715         while (temp != 0) {
716             length++;
717             temp >>= 8;
718         }
719         return toHexString(value, length);
720     }
721 
722     /**
723      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
724      */
725     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
726         bytes memory buffer = new bytes(2 * length + 2);
727         buffer[0] = "0";
728         buffer[1] = "x";
729         for (uint256 i = 2 * length + 1; i > 1; --i) {
730             buffer[i] = _HEX_SYMBOLS[value & 0xf];
731             value >>= 4;
732         }
733         require(value == 0, "Strings: hex length insufficient");
734         return string(buffer);
735     }
736 }
737 
738 // File: @openzeppelin/contracts/access/IAccessControl.sol
739 
740 
741 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
742 
743 pragma solidity ^0.8.0;
744 
745 /**
746  * @dev External interface of AccessControl declared to support ERC165 detection.
747  */
748 interface IAccessControl {
749     /**
750      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
751      *
752      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
753      * {RoleAdminChanged} not being emitted signaling this.
754      *
755      * _Available since v3.1._
756      */
757     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
758 
759     /**
760      * @dev Emitted when `account` is granted `role`.
761      *
762      * `sender` is the account that originated the contract call, an admin role
763      * bearer except when using {AccessControl-_setupRole}.
764      */
765     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
766 
767     /**
768      * @dev Emitted when `account` is revoked `role`.
769      *
770      * `sender` is the account that originated the contract call:
771      *   - if using `revokeRole`, it is the admin role bearer
772      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
773      */
774     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
775 
776     /**
777      * @dev Returns `true` if `account` has been granted `role`.
778      */
779     function hasRole(bytes32 role, address account) external view returns (bool);
780 
781     /**
782      * @dev Returns the admin role that controls `role`. See {grantRole} and
783      * {revokeRole}.
784      *
785      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
786      */
787     function getRoleAdmin(bytes32 role) external view returns (bytes32);
788 
789     /**
790      * @dev Grants `role` to `account`.
791      *
792      * If `account` had not been already granted `role`, emits a {RoleGranted}
793      * event.
794      *
795      * Requirements:
796      *
797      * - the caller must have ``role``'s admin role.
798      */
799     function grantRole(bytes32 role, address account) external;
800 
801     /**
802      * @dev Revokes `role` from `account`.
803      *
804      * If `account` had been granted `role`, emits a {RoleRevoked} event.
805      *
806      * Requirements:
807      *
808      * - the caller must have ``role``'s admin role.
809      */
810     function revokeRole(bytes32 role, address account) external;
811 
812     /**
813      * @dev Revokes `role` from the calling account.
814      *
815      * Roles are often managed via {grantRole} and {revokeRole}: this function's
816      * purpose is to provide a mechanism for accounts to lose their privileges
817      * if they are compromised (such as when a trusted device is misplaced).
818      *
819      * If the calling account had been granted `role`, emits a {RoleRevoked}
820      * event.
821      *
822      * Requirements:
823      *
824      * - the caller must be `account`.
825      */
826     function renounceRole(bytes32 role, address account) external;
827 }
828 
829 // File: @openzeppelin/contracts/utils/Address.sol
830 
831 
832 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
833 
834 pragma solidity ^0.8.1;
835 
836 /**
837  * @dev Collection of functions related to the address type
838  */
839 library Address {
840     /**
841      * @dev Returns true if `account` is a contract.
842      *
843      * [IMPORTANT]
844      * ====
845      * It is unsafe to assume that an address for which this function returns
846      * false is an externally-owned account (EOA) and not a contract.
847      *
848      * Among others, `isContract` will return false for the following
849      * types of addresses:
850      *
851      *  - an externally-owned account
852      *  - a contract in construction
853      *  - an address where a contract will be created
854      *  - an address where a contract lived, but was destroyed
855      * ====
856      *
857      * [IMPORTANT]
858      * ====
859      * You shouldn't rely on `isContract` to protect against flash loan attacks!
860      *
861      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
862      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
863      * constructor.
864      * ====
865      */
866     function isContract(address account) internal view returns (bool) {
867         // This method relies on extcodesize/address.code.length, which returns 0
868         // for contracts in construction, since the code is only stored at the end
869         // of the constructor execution.
870 
871         return account.code.length > 0;
872     }
873 
874     /**
875      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
876      * `recipient`, forwarding all available gas and reverting on errors.
877      *
878      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
879      * of certain opcodes, possibly making contracts go over the 2300 gas limit
880      * imposed by `transfer`, making them unable to receive funds via
881      * `transfer`. {sendValue} removes this limitation.
882      *
883      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
884      *
885      * IMPORTANT: because control is transferred to `recipient`, care must be
886      * taken to not create reentrancy vulnerabilities. Consider using
887      * {ReentrancyGuard} or the
888      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
889      */
890     function sendValue(address payable recipient, uint256 amount) internal {
891         require(address(this).balance >= amount, "Address: insufficient balance");
892 
893         (bool success, ) = recipient.call{value: amount}("");
894         require(success, "Address: unable to send value, recipient may have reverted");
895     }
896 
897     /**
898      * @dev Performs a Solidity function call using a low level `call`. A
899      * plain `call` is an unsafe replacement for a function call: use this
900      * function instead.
901      *
902      * If `target` reverts with a revert reason, it is bubbled up by this
903      * function (like regular Solidity function calls).
904      *
905      * Returns the raw returned data. To convert to the expected return value,
906      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
907      *
908      * Requirements:
909      *
910      * - `target` must be a contract.
911      * - calling `target` with `data` must not revert.
912      *
913      * _Available since v3.1._
914      */
915     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
916         return functionCall(target, data, "Address: low-level call failed");
917     }
918 
919     /**
920      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
921      * `errorMessage` as a fallback revert reason when `target` reverts.
922      *
923      * _Available since v3.1._
924      */
925     function functionCall(
926         address target,
927         bytes memory data,
928         string memory errorMessage
929     ) internal returns (bytes memory) {
930         return functionCallWithValue(target, data, 0, errorMessage);
931     }
932 
933     /**
934      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
935      * but also transferring `value` wei to `target`.
936      *
937      * Requirements:
938      *
939      * - the calling contract must have an ETH balance of at least `value`.
940      * - the called Solidity function must be `payable`.
941      *
942      * _Available since v3.1._
943      */
944     function functionCallWithValue(
945         address target,
946         bytes memory data,
947         uint256 value
948     ) internal returns (bytes memory) {
949         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
950     }
951 
952     /**
953      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
954      * with `errorMessage` as a fallback revert reason when `target` reverts.
955      *
956      * _Available since v3.1._
957      */
958     function functionCallWithValue(
959         address target,
960         bytes memory data,
961         uint256 value,
962         string memory errorMessage
963     ) internal returns (bytes memory) {
964         require(address(this).balance >= value, "Address: insufficient balance for call");
965         require(isContract(target), "Address: call to non-contract");
966 
967         (bool success, bytes memory returndata) = target.call{value: value}(data);
968         return verifyCallResult(success, returndata, errorMessage);
969     }
970 
971     /**
972      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
973      * but performing a static call.
974      *
975      * _Available since v3.3._
976      */
977     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
978         return functionStaticCall(target, data, "Address: low-level static call failed");
979     }
980 
981     /**
982      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
983      * but performing a static call.
984      *
985      * _Available since v3.3._
986      */
987     function functionStaticCall(
988         address target,
989         bytes memory data,
990         string memory errorMessage
991     ) internal view returns (bytes memory) {
992         require(isContract(target), "Address: static call to non-contract");
993 
994         (bool success, bytes memory returndata) = target.staticcall(data);
995         return verifyCallResult(success, returndata, errorMessage);
996     }
997 
998     /**
999      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1000      * but performing a delegate call.
1001      *
1002      * _Available since v3.4._
1003      */
1004     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1005         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1006     }
1007 
1008     /**
1009      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1010      * but performing a delegate call.
1011      *
1012      * _Available since v3.4._
1013      */
1014     function functionDelegateCall(
1015         address target,
1016         bytes memory data,
1017         string memory errorMessage
1018     ) internal returns (bytes memory) {
1019         require(isContract(target), "Address: delegate call to non-contract");
1020 
1021         (bool success, bytes memory returndata) = target.delegatecall(data);
1022         return verifyCallResult(success, returndata, errorMessage);
1023     }
1024 
1025     /**
1026      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1027      * revert reason using the provided one.
1028      *
1029      * _Available since v4.3._
1030      */
1031     function verifyCallResult(
1032         bool success,
1033         bytes memory returndata,
1034         string memory errorMessage
1035     ) internal pure returns (bytes memory) {
1036         if (success) {
1037             return returndata;
1038         } else {
1039             // Look for revert reason and bubble it up if present
1040             if (returndata.length > 0) {
1041                 // The easiest way to bubble the revert reason is using memory via assembly
1042 
1043                 assembly {
1044                     let returndata_size := mload(returndata)
1045                     revert(add(32, returndata), returndata_size)
1046                 }
1047             } else {
1048                 revert(errorMessage);
1049             }
1050         }
1051     }
1052 }
1053 
1054 // File: @openzeppelin/contracts/utils/Context.sol
1055 
1056 
1057 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1058 
1059 pragma solidity ^0.8.0;
1060 
1061 /**
1062  * @dev Provides information about the current execution context, including the
1063  * sender of the transaction and its data. While these are generally available
1064  * via msg.sender and msg.data, they should not be accessed in such a direct
1065  * manner, since when dealing with meta-transactions the account sending and
1066  * paying for execution may not be the actual sender (as far as an application
1067  * is concerned).
1068  *
1069  * This contract is only required for intermediate, library-like contracts.
1070  */
1071 abstract contract Context {
1072     function _msgSender() internal view virtual returns (address) {
1073         return msg.sender;
1074     }
1075 
1076     function _msgData() internal view virtual returns (bytes calldata) {
1077         return msg.data;
1078     }
1079 }
1080 
1081 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1082 
1083 
1084 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
1085 
1086 pragma solidity ^0.8.0;
1087 
1088 
1089 
1090 
1091 /**
1092  * @dev Implementation of the {IERC20} interface.
1093  *
1094  * This implementation is agnostic to the way tokens are created. This means
1095  * that a supply mechanism has to be added in a derived contract using {_mint}.
1096  * For a generic mechanism see {ERC20PresetMinterPauser}.
1097  *
1098  * TIP: For a detailed writeup see our guide
1099  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1100  * to implement supply mechanisms].
1101  *
1102  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1103  * instead returning `false` on failure. This behavior is nonetheless
1104  * conventional and does not conflict with the expectations of ERC20
1105  * applications.
1106  *
1107  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1108  * This allows applications to reconstruct the allowance for all accounts just
1109  * by listening to said events. Other implementations of the EIP may not emit
1110  * these events, as it isn't required by the specification.
1111  *
1112  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1113  * functions have been added to mitigate the well-known issues around setting
1114  * allowances. See {IERC20-approve}.
1115  */
1116 contract ERC20 is Context, IERC20, IERC20Metadata {
1117     mapping(address => uint256) private _balances;
1118 
1119     mapping(address => mapping(address => uint256)) private _allowances;
1120 
1121     uint256 private _totalSupply;
1122 
1123     string private _name;
1124     string private _symbol;
1125 
1126     /**
1127      * @dev Sets the values for {name} and {symbol}.
1128      *
1129      * The default value of {decimals} is 18. To select a different value for
1130      * {decimals} you should overload it.
1131      *
1132      * All two of these values are immutable: they can only be set once during
1133      * construction.
1134      */
1135     constructor(string memory name_, string memory symbol_) {
1136         _name = name_;
1137         _symbol = symbol_;
1138     }
1139 
1140     /**
1141      * @dev Returns the name of the token.
1142      */
1143     function name() public view virtual override returns (string memory) {
1144         return _name;
1145     }
1146 
1147     /**
1148      * @dev Returns the symbol of the token, usually a shorter version of the
1149      * name.
1150      */
1151     function symbol() public view virtual override returns (string memory) {
1152         return _symbol;
1153     }
1154 
1155     /**
1156      * @dev Returns the number of decimals used to get its user representation.
1157      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1158      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1159      *
1160      * Tokens usually opt for a value of 18, imitating the relationship between
1161      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1162      * overridden;
1163      *
1164      * NOTE: This information is only used for _display_ purposes: it in
1165      * no way affects any of the arithmetic of the contract, including
1166      * {IERC20-balanceOf} and {IERC20-transfer}.
1167      */
1168     function decimals() public view virtual override returns (uint8) {
1169         return 18;
1170     }
1171 
1172     /**
1173      * @dev See {IERC20-totalSupply}.
1174      */
1175     function totalSupply() public view virtual override returns (uint256) {
1176         return _totalSupply;
1177     }
1178 
1179     /**
1180      * @dev See {IERC20-balanceOf}.
1181      */
1182     function balanceOf(address account) public view virtual override returns (uint256) {
1183         return _balances[account];
1184     }
1185 
1186     /**
1187      * @dev See {IERC20-transfer}.
1188      *
1189      * Requirements:
1190      *
1191      * - `to` cannot be the zero address.
1192      * - the caller must have a balance of at least `amount`.
1193      */
1194     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1195         address owner = _msgSender();
1196         _transfer(owner, to, amount);
1197         return true;
1198     }
1199 
1200     /**
1201      * @dev See {IERC20-allowance}.
1202      */
1203     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1204         return _allowances[owner][spender];
1205     }
1206 
1207     /**
1208      * @dev See {IERC20-approve}.
1209      *
1210      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1211      * `transferFrom`. This is semantically equivalent to an infinite approval.
1212      *
1213      * Requirements:
1214      *
1215      * - `spender` cannot be the zero address.
1216      */
1217     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1218         address owner = _msgSender();
1219         _approve(owner, spender, amount);
1220         return true;
1221     }
1222 
1223     /**
1224      * @dev See {IERC20-transferFrom}.
1225      *
1226      * Emits an {Approval} event indicating the updated allowance. This is not
1227      * required by the EIP. See the note at the beginning of {ERC20}.
1228      *
1229      * NOTE: Does not update the allowance if the current allowance
1230      * is the maximum `uint256`.
1231      *
1232      * Requirements:
1233      *
1234      * - `from` and `to` cannot be the zero address.
1235      * - `from` must have a balance of at least `amount`.
1236      * - the caller must have allowance for ``from``'s tokens of at least
1237      * `amount`.
1238      */
1239     function transferFrom(
1240         address from,
1241         address to,
1242         uint256 amount
1243     ) public virtual override returns (bool) {
1244         address spender = _msgSender();
1245         _spendAllowance(from, spender, amount);
1246         _transfer(from, to, amount);
1247         return true;
1248     }
1249 
1250     /**
1251      * @dev Atomically increases the allowance granted to `spender` by the caller.
1252      *
1253      * This is an alternative to {approve} that can be used as a mitigation for
1254      * problems described in {IERC20-approve}.
1255      *
1256      * Emits an {Approval} event indicating the updated allowance.
1257      *
1258      * Requirements:
1259      *
1260      * - `spender` cannot be the zero address.
1261      */
1262     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1263         address owner = _msgSender();
1264         _approve(owner, spender, _allowances[owner][spender] + addedValue);
1265         return true;
1266     }
1267 
1268     /**
1269      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1270      *
1271      * This is an alternative to {approve} that can be used as a mitigation for
1272      * problems described in {IERC20-approve}.
1273      *
1274      * Emits an {Approval} event indicating the updated allowance.
1275      *
1276      * Requirements:
1277      *
1278      * - `spender` cannot be the zero address.
1279      * - `spender` must have allowance for the caller of at least
1280      * `subtractedValue`.
1281      */
1282     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1283         address owner = _msgSender();
1284         uint256 currentAllowance = _allowances[owner][spender];
1285         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1286         unchecked {
1287             _approve(owner, spender, currentAllowance - subtractedValue);
1288         }
1289 
1290         return true;
1291     }
1292 
1293     /**
1294      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1295      *
1296      * This internal function is equivalent to {transfer}, and can be used to
1297      * e.g. implement automatic token fees, slashing mechanisms, etc.
1298      *
1299      * Emits a {Transfer} event.
1300      *
1301      * Requirements:
1302      *
1303      * - `from` cannot be the zero address.
1304      * - `to` cannot be the zero address.
1305      * - `from` must have a balance of at least `amount`.
1306      */
1307     function _transfer(
1308         address from,
1309         address to,
1310         uint256 amount
1311     ) internal virtual {
1312         require(from != address(0), "ERC20: transfer from the zero address");
1313         require(to != address(0), "ERC20: transfer to the zero address");
1314 
1315         _beforeTokenTransfer(from, to, amount);
1316 
1317         uint256 fromBalance = _balances[from];
1318         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1319         unchecked {
1320             _balances[from] = fromBalance - amount;
1321         }
1322         _balances[to] += amount;
1323 
1324         emit Transfer(from, to, amount);
1325 
1326         _afterTokenTransfer(from, to, amount);
1327     }
1328 
1329     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1330      * the total supply.
1331      *
1332      * Emits a {Transfer} event with `from` set to the zero address.
1333      *
1334      * Requirements:
1335      *
1336      * - `account` cannot be the zero address.
1337      */
1338     function _mint(address account, uint256 amount) internal virtual {
1339         require(account != address(0), "ERC20: mint to the zero address");
1340 
1341         _beforeTokenTransfer(address(0), account, amount);
1342 
1343         _totalSupply += amount;
1344         _balances[account] += amount;
1345         emit Transfer(address(0), account, amount);
1346 
1347         _afterTokenTransfer(address(0), account, amount);
1348     }
1349 
1350     /**
1351      * @dev Destroys `amount` tokens from `account`, reducing the
1352      * total supply.
1353      *
1354      * Emits a {Transfer} event with `to` set to the zero address.
1355      *
1356      * Requirements:
1357      *
1358      * - `account` cannot be the zero address.
1359      * - `account` must have at least `amount` tokens.
1360      */
1361     function _burn(address account, uint256 amount) internal virtual {
1362         require(account != address(0), "ERC20: burn from the zero address");
1363 
1364         _beforeTokenTransfer(account, address(0), amount);
1365 
1366         uint256 accountBalance = _balances[account];
1367         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1368         unchecked {
1369             _balances[account] = accountBalance - amount;
1370         }
1371         _totalSupply -= amount;
1372 
1373         emit Transfer(account, address(0), amount);
1374 
1375         _afterTokenTransfer(account, address(0), amount);
1376     }
1377 
1378     /**
1379      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1380      *
1381      * This internal function is equivalent to `approve`, and can be used to
1382      * e.g. set automatic allowances for certain subsystems, etc.
1383      *
1384      * Emits an {Approval} event.
1385      *
1386      * Requirements:
1387      *
1388      * - `owner` cannot be the zero address.
1389      * - `spender` cannot be the zero address.
1390      */
1391     function _approve(
1392         address owner,
1393         address spender,
1394         uint256 amount
1395     ) internal virtual {
1396         require(owner != address(0), "ERC20: approve from the zero address");
1397         require(spender != address(0), "ERC20: approve to the zero address");
1398 
1399         _allowances[owner][spender] = amount;
1400         emit Approval(owner, spender, amount);
1401     }
1402 
1403     /**
1404      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
1405      *
1406      * Does not update the allowance amount in case of infinite allowance.
1407      * Revert if not enough allowance is available.
1408      *
1409      * Might emit an {Approval} event.
1410      */
1411     function _spendAllowance(
1412         address owner,
1413         address spender,
1414         uint256 amount
1415     ) internal virtual {
1416         uint256 currentAllowance = allowance(owner, spender);
1417         if (currentAllowance != type(uint256).max) {
1418             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1419             unchecked {
1420                 _approve(owner, spender, currentAllowance - amount);
1421             }
1422         }
1423     }
1424 
1425     /**
1426      * @dev Hook that is called before any transfer of tokens. This includes
1427      * minting and burning.
1428      *
1429      * Calling conditions:
1430      *
1431      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1432      * will be transferred to `to`.
1433      * - when `from` is zero, `amount` tokens will be minted for `to`.
1434      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1435      * - `from` and `to` are never both zero.
1436      *
1437      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1438      */
1439     function _beforeTokenTransfer(
1440         address from,
1441         address to,
1442         uint256 amount
1443     ) internal virtual {}
1444 
1445     /**
1446      * @dev Hook that is called after any transfer of tokens. This includes
1447      * minting and burning.
1448      *
1449      * Calling conditions:
1450      *
1451      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1452      * has been transferred to `to`.
1453      * - when `from` is zero, `amount` tokens have been minted for `to`.
1454      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1455      * - `from` and `to` are never both zero.
1456      *
1457      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1458      */
1459     function _afterTokenTransfer(
1460         address from,
1461         address to,
1462         uint256 amount
1463     ) internal virtual {}
1464 }
1465 
1466 // File: @openzeppelin/contracts/access/AccessControl.sol
1467 
1468 
1469 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControl.sol)
1470 
1471 pragma solidity ^0.8.0;
1472 
1473 
1474 
1475 
1476 
1477 /**
1478  * @dev Contract module that allows children to implement role-based access
1479  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1480  * members except through off-chain means by accessing the contract event logs. Some
1481  * applications may benefit from on-chain enumerability, for those cases see
1482  * {AccessControlEnumerable}.
1483  *
1484  * Roles are referred to by their `bytes32` identifier. These should be exposed
1485  * in the external API and be unique. The best way to achieve this is by
1486  * using `public constant` hash digests:
1487  *
1488  * ```
1489  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1490  * ```
1491  *
1492  * Roles can be used to represent a set of permissions. To restrict access to a
1493  * function call, use {hasRole}:
1494  *
1495  * ```
1496  * function foo() public {
1497  *     require(hasRole(MY_ROLE, msg.sender));
1498  *     ...
1499  * }
1500  * ```
1501  *
1502  * Roles can be granted and revoked dynamically via the {grantRole} and
1503  * {revokeRole} functions. Each role has an associated admin role, and only
1504  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1505  *
1506  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1507  * that only accounts with this role will be able to grant or revoke other
1508  * roles. More complex role relationships can be created by using
1509  * {_setRoleAdmin}.
1510  *
1511  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1512  * grant and revoke this role. Extra precautions should be taken to secure
1513  * accounts that have been granted it.
1514  */
1515 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1516     struct RoleData {
1517         mapping(address => bool) members;
1518         bytes32 adminRole;
1519     }
1520 
1521     mapping(bytes32 => RoleData) private _roles;
1522 
1523     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1524 
1525     /**
1526      * @dev Modifier that checks that an account has a specific role. Reverts
1527      * with a standardized message including the required role.
1528      *
1529      * The format of the revert reason is given by the following regular expression:
1530      *
1531      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1532      *
1533      * _Available since v4.1._
1534      */
1535     modifier onlyRole(bytes32 role) {
1536         _checkRole(role, _msgSender());
1537         _;
1538     }
1539 
1540     /**
1541      * @dev See {IERC165-supportsInterface}.
1542      */
1543     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1544         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1545     }
1546 
1547     /**
1548      * @dev Returns `true` if `account` has been granted `role`.
1549      */
1550     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1551         return _roles[role].members[account];
1552     }
1553 
1554     /**
1555      * @dev Revert with a standard message if `account` is missing `role`.
1556      *
1557      * The format of the revert reason is given by the following regular expression:
1558      *
1559      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1560      */
1561     function _checkRole(bytes32 role, address account) internal view virtual {
1562         if (!hasRole(role, account)) {
1563             revert(
1564                 string(
1565                     abi.encodePacked(
1566                         "AccessControl: account ",
1567                         Strings.toHexString(uint160(account), 20),
1568                         " is missing role ",
1569                         Strings.toHexString(uint256(role), 32)
1570                     )
1571                 )
1572             );
1573         }
1574     }
1575 
1576     /**
1577      * @dev Returns the admin role that controls `role`. See {grantRole} and
1578      * {revokeRole}.
1579      *
1580      * To change a role's admin, use {_setRoleAdmin}.
1581      */
1582     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1583         return _roles[role].adminRole;
1584     }
1585 
1586     /**
1587      * @dev Grants `role` to `account`.
1588      *
1589      * If `account` had not been already granted `role`, emits a {RoleGranted}
1590      * event.
1591      *
1592      * Requirements:
1593      *
1594      * - the caller must have ``role``'s admin role.
1595      */
1596     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1597         _grantRole(role, account);
1598     }
1599 
1600     /**
1601      * @dev Revokes `role` from `account`.
1602      *
1603      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1604      *
1605      * Requirements:
1606      *
1607      * - the caller must have ``role``'s admin role.
1608      */
1609     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1610         _revokeRole(role, account);
1611     }
1612 
1613     /**
1614      * @dev Revokes `role` from the calling account.
1615      *
1616      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1617      * purpose is to provide a mechanism for accounts to lose their privileges
1618      * if they are compromised (such as when a trusted device is misplaced).
1619      *
1620      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1621      * event.
1622      *
1623      * Requirements:
1624      *
1625      * - the caller must be `account`.
1626      */
1627     function renounceRole(bytes32 role, address account) public virtual override {
1628         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1629 
1630         _revokeRole(role, account);
1631     }
1632 
1633     /**
1634      * @dev Grants `role` to `account`.
1635      *
1636      * If `account` had not been already granted `role`, emits a {RoleGranted}
1637      * event. Note that unlike {grantRole}, this function doesn't perform any
1638      * checks on the calling account.
1639      *
1640      * [WARNING]
1641      * ====
1642      * This function should only be called from the constructor when setting
1643      * up the initial roles for the system.
1644      *
1645      * Using this function in any other way is effectively circumventing the admin
1646      * system imposed by {AccessControl}.
1647      * ====
1648      *
1649      * NOTE: This function is deprecated in favor of {_grantRole}.
1650      */
1651     function _setupRole(bytes32 role, address account) internal virtual {
1652         _grantRole(role, account);
1653     }
1654 
1655     /**
1656      * @dev Sets `adminRole` as ``role``'s admin role.
1657      *
1658      * Emits a {RoleAdminChanged} event.
1659      */
1660     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1661         bytes32 previousAdminRole = getRoleAdmin(role);
1662         _roles[role].adminRole = adminRole;
1663         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1664     }
1665 
1666     /**
1667      * @dev Grants `role` to `account`.
1668      *
1669      * Internal function without access restriction.
1670      */
1671     function _grantRole(bytes32 role, address account) internal virtual {
1672         if (!hasRole(role, account)) {
1673             _roles[role].members[account] = true;
1674             emit RoleGranted(role, account, _msgSender());
1675         }
1676     }
1677 
1678     /**
1679      * @dev Revokes `role` from `account`.
1680      *
1681      * Internal function without access restriction.
1682      */
1683     function _revokeRole(bytes32 role, address account) internal virtual {
1684         if (hasRole(role, account)) {
1685             _roles[role].members[account] = false;
1686             emit RoleRevoked(role, account, _msgSender());
1687         }
1688     }
1689 }
1690 
1691 // File: @openzeppelin/contracts/access/Ownable.sol
1692 
1693 
1694 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1695 
1696 pragma solidity ^0.8.0;
1697 
1698 
1699 /**
1700  * @dev Contract module which provides a basic access control mechanism, where
1701  * there is an account (an owner) that can be granted exclusive access to
1702  * specific functions.
1703  *
1704  * By default, the owner account will be the one that deploys the contract. This
1705  * can later be changed with {transferOwnership}.
1706  *
1707  * This module is used through inheritance. It will make available the modifier
1708  * `onlyOwner`, which can be applied to your functions to restrict their use to
1709  * the owner.
1710  */
1711 abstract contract Ownable is Context {
1712     address private _owner;
1713 
1714     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1715 
1716     /**
1717      * @dev Initializes the contract setting the deployer as the initial owner.
1718      */
1719     constructor() {
1720         _transferOwnership(_msgSender());
1721     }
1722 
1723     /**
1724      * @dev Returns the address of the current owner.
1725      */
1726     function owner() public view virtual returns (address) {
1727         return _owner;
1728     }
1729 
1730     /**
1731      * @dev Throws if called by any account other than the owner.
1732      */
1733     modifier onlyOwner() {
1734         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1735         _;
1736     }
1737 
1738     /**
1739      * @dev Leaves the contract without owner. It will not be possible to call
1740      * `onlyOwner` functions anymore. Can only be called by the current owner.
1741      *
1742      * NOTE: Renouncing ownership will leave the contract without an owner,
1743      * thereby removing any functionality that is only available to the owner.
1744      */
1745     function renounceOwnership() public virtual onlyOwner {
1746         _transferOwnership(address(0));
1747     }
1748 
1749     /**
1750      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1751      * Can only be called by the current owner.
1752      */
1753     function transferOwnership(address newOwner) public virtual onlyOwner {
1754         require(newOwner != address(0), "Ownable: new owner is the zero address");
1755         _transferOwnership(newOwner);
1756     }
1757 
1758     /**
1759      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1760      * Internal function without access restriction.
1761      */
1762     function _transferOwnership(address newOwner) internal virtual {
1763         address oldOwner = _owner;
1764         _owner = newOwner;
1765         emit OwnershipTransferred(oldOwner, newOwner);
1766     }
1767 }
1768 
1769 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1770 
1771 
1772 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
1773 
1774 pragma solidity ^0.8.0;
1775 
1776 // CAUTION
1777 // This version of SafeMath should only be used with Solidity 0.8 or later,
1778 // because it relies on the compiler's built in overflow checks.
1779 
1780 /**
1781  * @dev Wrappers over Solidity's arithmetic operations.
1782  *
1783  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1784  * now has built in overflow checking.
1785  */
1786 library SafeMath {
1787     /**
1788      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1789      *
1790      * _Available since v3.4._
1791      */
1792     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1793         unchecked {
1794             uint256 c = a + b;
1795             if (c < a) return (false, 0);
1796             return (true, c);
1797         }
1798     }
1799 
1800     /**
1801      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1802      *
1803      * _Available since v3.4._
1804      */
1805     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1806         unchecked {
1807             if (b > a) return (false, 0);
1808             return (true, a - b);
1809         }
1810     }
1811 
1812     /**
1813      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1814      *
1815      * _Available since v3.4._
1816      */
1817     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1818         unchecked {
1819             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1820             // benefit is lost if 'b' is also tested.
1821             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1822             if (a == 0) return (true, 0);
1823             uint256 c = a * b;
1824             if (c / a != b) return (false, 0);
1825             return (true, c);
1826         }
1827     }
1828 
1829     /**
1830      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1831      *
1832      * _Available since v3.4._
1833      */
1834     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1835         unchecked {
1836             if (b == 0) return (false, 0);
1837             return (true, a / b);
1838         }
1839     }
1840 
1841     /**
1842      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1843      *
1844      * _Available since v3.4._
1845      */
1846     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1847         unchecked {
1848             if (b == 0) return (false, 0);
1849             return (true, a % b);
1850         }
1851     }
1852 
1853     /**
1854      * @dev Returns the addition of two unsigned integers, reverting on
1855      * overflow.
1856      *
1857      * Counterpart to Solidity's `+` operator.
1858      *
1859      * Requirements:
1860      *
1861      * - Addition cannot overflow.
1862      */
1863     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1864         return a + b;
1865     }
1866 
1867     /**
1868      * @dev Returns the subtraction of two unsigned integers, reverting on
1869      * overflow (when the result is negative).
1870      *
1871      * Counterpart to Solidity's `-` operator.
1872      *
1873      * Requirements:
1874      *
1875      * - Subtraction cannot overflow.
1876      */
1877     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1878         return a - b;
1879     }
1880 
1881     /**
1882      * @dev Returns the multiplication of two unsigned integers, reverting on
1883      * overflow.
1884      *
1885      * Counterpart to Solidity's `*` operator.
1886      *
1887      * Requirements:
1888      *
1889      * - Multiplication cannot overflow.
1890      */
1891     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1892         return a * b;
1893     }
1894 
1895     /**
1896      * @dev Returns the integer division of two unsigned integers, reverting on
1897      * division by zero. The result is rounded towards zero.
1898      *
1899      * Counterpart to Solidity's `/` operator.
1900      *
1901      * Requirements:
1902      *
1903      * - The divisor cannot be zero.
1904      */
1905     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1906         return a / b;
1907     }
1908 
1909     /**
1910      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1911      * reverting when dividing by zero.
1912      *
1913      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1914      * opcode (which leaves remaining gas untouched) while Solidity uses an
1915      * invalid opcode to revert (consuming all remaining gas).
1916      *
1917      * Requirements:
1918      *
1919      * - The divisor cannot be zero.
1920      */
1921     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1922         return a % b;
1923     }
1924 
1925     /**
1926      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1927      * overflow (when the result is negative).
1928      *
1929      * CAUTION: This function is deprecated because it requires allocating memory for the error
1930      * message unnecessarily. For custom revert reasons use {trySub}.
1931      *
1932      * Counterpart to Solidity's `-` operator.
1933      *
1934      * Requirements:
1935      *
1936      * - Subtraction cannot overflow.
1937      */
1938     function sub(
1939         uint256 a,
1940         uint256 b,
1941         string memory errorMessage
1942     ) internal pure returns (uint256) {
1943         unchecked {
1944             require(b <= a, errorMessage);
1945             return a - b;
1946         }
1947     }
1948 
1949     /**
1950      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1951      * division by zero. The result is rounded towards zero.
1952      *
1953      * Counterpart to Solidity's `/` operator. Note: this function uses a
1954      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1955      * uses an invalid opcode to revert (consuming all remaining gas).
1956      *
1957      * Requirements:
1958      *
1959      * - The divisor cannot be zero.
1960      */
1961     function div(
1962         uint256 a,
1963         uint256 b,
1964         string memory errorMessage
1965     ) internal pure returns (uint256) {
1966         unchecked {
1967             require(b > 0, errorMessage);
1968             return a / b;
1969         }
1970     }
1971 
1972     /**
1973      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1974      * reverting with custom message when dividing by zero.
1975      *
1976      * CAUTION: This function is deprecated because it requires allocating memory for the error
1977      * message unnecessarily. For custom revert reasons use {tryMod}.
1978      *
1979      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1980      * opcode (which leaves remaining gas untouched) while Solidity uses an
1981      * invalid opcode to revert (consuming all remaining gas).
1982      *
1983      * Requirements:
1984      *
1985      * - The divisor cannot be zero.
1986      */
1987     function mod(
1988         uint256 a,
1989         uint256 b,
1990         string memory errorMessage
1991     ) internal pure returns (uint256) {
1992         unchecked {
1993             require(b > 0, errorMessage);
1994             return a % b;
1995         }
1996     }
1997 }
1998 
1999 // File: contracts-eth/libs/BEP20.sol
2000 
2001 
2002 
2003 pragma solidity >=0.4.0;
2004 
2005 
2006 
2007 
2008 
2009 
2010 /**
2011  * @dev Implementation of the {IBEP20} interface.
2012  *
2013  * This implementation is agnostic to the way tokens are created. This means
2014  * that a supply mechanism has to be added in a derived contract using {_mint}.
2015  * For a generic mechanism see {BEP20PresetMinterPauser}.
2016  *
2017  * TIP: For a detailed writeup see our guide
2018  * https://forum.zeppelin.solutions/t/how-to-implement-BEP20-supply-mechanisms/226[How
2019  * to implement supply mechanisms].
2020  *
2021  * We have followed general OpenZeppelin guidelines: functions revert instead
2022  * of returning `false` on failure. This behavior is nonetheless conventional
2023  * and does not conflict with the expectations of BEP20 applications.
2024  *
2025  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
2026  * This allows applications to reconstruct the allowance for all accounts just
2027  * by listening to said events. Other implementations of the EIP may not emit
2028  * these events, as it isn't required by the specification.
2029  *
2030  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
2031  * functions have been added to mitigate the well-known issues around setting
2032  * allowances. See {IBEP20-approve}.
2033  */
2034 contract BEP20 is Context, IBEP20, Ownable {
2035     using SafeMath for uint256;
2036     using Address for address;
2037 
2038     mapping(address => uint256) private _balances;
2039 
2040     mapping(address => mapping(address => uint256)) private _allowances;
2041 
2042     uint256 private _totalSupply;
2043 
2044     string private _name;
2045     string private _symbol;
2046     uint8 private _decimals;
2047 
2048     /**
2049      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
2050      * a default value of 18.
2051      *
2052      * To select a different value for {decimals}, use {_setupDecimals}.
2053      *
2054      * All three of these values are immutable: they can only be set once during
2055      * construction.
2056      */
2057     constructor(string memory name_, string memory symbol_) {
2058         _name = name_;
2059         _symbol = symbol_;
2060         _decimals = 18;
2061     }
2062 
2063     /**
2064      * @dev Returns the bep token owner.
2065      */
2066     function getOwner() external override view returns (address) {
2067         return owner();
2068     }
2069 
2070     /**
2071      * @dev Returns the token name.
2072      */
2073     function name() public override view returns (string memory) {
2074         return _name;
2075     }
2076 
2077     /**
2078      * @dev Returns the token decimals.
2079      */
2080     function decimals() public override view returns (uint8) {
2081         return _decimals;
2082     }
2083 
2084     /**
2085      * @dev Returns the token symbol.
2086      */
2087     function symbol() public override view returns (string memory) {
2088         return _symbol;
2089     }
2090 
2091     /**
2092      * @dev See {BEP20-totalSupply}.
2093      */
2094     function totalSupply() public override view returns (uint256) {
2095         return _totalSupply;
2096     }
2097 
2098     /**
2099      * @dev See {BEP20-balanceOf}.
2100      */
2101     function balanceOf(address account) public override view returns (uint256) {
2102         return _balances[account];
2103     }
2104 
2105     /**
2106      * @dev See {BEP20-transfer}.
2107      *
2108      * Requirements:
2109      *
2110      * - `recipient` cannot be the zero address.
2111      * - the caller must have a balance of at least `amount`.
2112      */
2113     function transfer(address recipient, uint256 amount) public override virtual returns (bool) {
2114         _transfer(_msgSender(), recipient, amount);
2115         return true;
2116     }
2117 
2118     /**
2119      * @dev See {BEP20-allowance}.
2120      */
2121     function allowance(address owner, address spender) public override view returns (uint256) {
2122         return _allowances[owner][spender];
2123     }
2124 
2125     /**
2126      * @dev See {BEP20-approve}.
2127      *
2128      * Requirements:
2129      *
2130      * - `spender` cannot be the zero address.
2131      */
2132     function approve(address spender, uint256 amount) public override returns (bool) {
2133         _approve(_msgSender(), spender, amount);
2134         return true;
2135     }
2136 
2137     /**
2138      * @dev See {BEP20-transferFrom}.
2139      *
2140      * Emits an {Approval} event indicating the updated allowance. This is not
2141      * required by the EIP. See the note at the beginning of {BEP20};
2142      *
2143      * Requirements:
2144      * - `sender` and `recipient` cannot be the zero address.
2145      * - `sender` must have a balance of at least `amount`.
2146      * - the caller must have allowance for `sender`'s tokens of at least
2147      * `amount`.
2148      */
2149     function transferFrom(
2150         address sender,
2151         address recipient,
2152         uint256 amount
2153     ) public override virtual returns (bool) {
2154         _transfer(sender, recipient, amount);
2155         _approve(
2156             sender,
2157             _msgSender(),
2158             _allowances[sender][_msgSender()].sub(amount, 'BEP20: transfer amount exceeds allowance')
2159         );
2160         return true;
2161     }
2162 
2163     /**
2164      * @dev Atomically increases the allowance granted to `spender` by the caller.
2165      *
2166      * This is an alternative to {approve} that can be used as a mitigation for
2167      * problems described in {BEP20-approve}.
2168      *
2169      * Emits an {Approval} event indicating the updated allowance.
2170      *
2171      * Requirements:
2172      *
2173      * - `spender` cannot be the zero address.
2174      */
2175     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
2176         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
2177         return true;
2178     }
2179 
2180     /**
2181      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2182      *
2183      * This is an alternative to {approve} that can be used as a mitigation for
2184      * problems described in {BEP20-approve}.
2185      *
2186      * Emits an {Approval} event indicating the updated allowance.
2187      *
2188      * Requirements:
2189      *
2190      * - `spender` cannot be the zero address.
2191      * - `spender` must have allowance for the caller of at least
2192      * `subtractedValue`.
2193      */
2194     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
2195         _approve(
2196             _msgSender(),
2197             spender,
2198             _allowances[_msgSender()][spender].sub(subtractedValue, 'BEP20: decreased allowance below zero')
2199         );
2200         return true;
2201     }
2202 
2203     /**
2204      * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
2205      * the total supply.
2206      *
2207      * Requirements
2208      *
2209      * - `msg.sender` must be the token owner
2210      */
2211     function mint(uint256 amount) public onlyOwner returns (bool) {
2212         _mint(_msgSender(), amount);
2213         return true;
2214     }
2215 
2216     /**
2217      * @dev Moves tokens `amount` from `sender` to `recipient`.
2218      *
2219      * This is internal function is equivalent to {transfer}, and can be used to
2220      * e.g. implement automatic token fees, slashing mechanisms, etc.
2221      *
2222      * Emits a {Transfer} event.
2223      *
2224      * Requirements:
2225      *
2226      * - `sender` cannot be the zero address.
2227      * - `recipient` cannot be the zero address.
2228      * - `sender` must have a balance of at least `amount`.
2229      */
2230     function _transfer(
2231         address sender,
2232         address recipient,
2233         uint256 amount
2234     ) internal {
2235         require(sender != address(0), 'BEP20: transfer from the zero address');
2236         require(recipient != address(0), 'BEP20: transfer to the zero address');
2237 
2238         _balances[sender] = _balances[sender].sub(amount, 'BEP20: transfer amount exceeds balance');
2239         _balances[recipient] = _balances[recipient].add(amount);
2240         emit Transfer(sender, recipient, amount);
2241     }
2242 
2243     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2244      * the total supply.
2245      *
2246      * Emits a {Transfer} event with `from` set to the zero address.
2247      *
2248      * Requirements
2249      *
2250      * - `to` cannot be the zero address.
2251      */
2252     function _mint(address account, uint256 amount) internal {
2253         require(account != address(0), 'BEP20: mint to the zero address');
2254 
2255         _totalSupply = _totalSupply.add(amount);
2256         _balances[account] = _balances[account].add(amount);
2257         emit Transfer(address(0), account, amount);
2258     }
2259 
2260     /**
2261      * @dev Destroys `amount` tokens from `account`, reducing the
2262      * total supply.
2263      *
2264      * Emits a {Transfer} event with `to` set to the zero address.
2265      *
2266      * Requirements
2267      *
2268      * - `account` cannot be the zero address.
2269      * - `account` must have at least `amount` tokens.
2270      */
2271     function _burn(address account, uint256 amount) internal {
2272         require(account != address(0), 'BEP20: burn from the zero address');
2273 
2274         _balances[account] = _balances[account].sub(amount, 'BEP20: burn amount exceeds balance');
2275         _totalSupply = _totalSupply.sub(amount);
2276         emit Transfer(account, address(0), amount);
2277     }
2278 
2279     /**
2280      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
2281      *
2282      * This is internal function is equivalent to `approve`, and can be used to
2283      * e.g. set automatic allowances for certain subsystems, etc.
2284      *
2285      * Emits an {Approval} event.
2286      *
2287      * Requirements:
2288      *
2289      * - `owner` cannot be the zero address.
2290      * - `spender` cannot be the zero address.
2291      */
2292     function _approve(
2293         address owner,
2294         address spender,
2295         uint256 amount
2296     ) internal {
2297         require(owner != address(0), 'BEP20: approve from the zero address');
2298         require(spender != address(0), 'BEP20: approve to the zero address');
2299 
2300         _allowances[owner][spender] = amount;
2301         emit Approval(owner, spender, amount);
2302     }
2303 
2304     /**
2305      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
2306      * from the caller's allowance.
2307      *
2308      * See {_burn} and {_approve}.
2309      */
2310     function _burnFrom(address account, uint256 amount) internal {
2311         _burn(account, amount);
2312         _approve(
2313             account,
2314             _msgSender(),
2315             _allowances[account][_msgSender()].sub(amount, 'BEP20: burn amount exceeds allowance')
2316         );
2317     }
2318 }
2319 // File: contracts-eth/Apple2.sol
2320 
2321 
2322 pragma solidity ^0.8.0;
2323 pragma experimental ABIEncoderV2;
2324 
2325 
2326 
2327 
2328 
2329 
2330 
2331 
2332 
2333 
2334 
2335 
2336 
2337 
2338 
2339 contract APPLE is Context, Ownable, AccessControl, ERC20 {
2340     using SafeMath for uint256;
2341     using Address for address;
2342 
2343     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
2344     bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
2345     bytes32 public constant FEE_SETTER_ROLE = keccak256("FEE_SETTER_ROLE");
2346 
2347     // staked struct	
2348     struct Staked {	
2349         uint256 amount;	
2350     }	
2351     address[] holders;	
2352     mapping (address => uint256) holderIndexes;	
2353     uint256 public totalStaked;
2354 
2355     // Fees
2356     // Add and remove fee types and destinations here as needed
2357     struct Fees {
2358         uint256 developmentFee;
2359         uint256 buybackFee;
2360         uint256 burnFee;
2361         address developmentAddress;
2362     }
2363 
2364     // Transaction fee values
2365     // Add and remove fee value types here as needed
2366     struct FeeValues {
2367         uint256 transferAmount;
2368         uint256 development;
2369         uint256 buyback;
2370         uint256 burn;
2371     }
2372 
2373     // Token details
2374     mapping (address => uint256) _balances;
2375     mapping (address => mapping (address => uint256)) private _allowances;
2376     mapping (address => Staked) public staked;
2377 
2378     // blacklist and staking contract mappings	
2379     mapping (address => bool) isBlacklisted; 	
2380     mapping (address => bool) isStakingContract; 
2381 
2382 
2383     // Set total supply here
2384     uint256 private _tTotal;
2385 
2386     // auto set buyback to false. additional buyback params. blockPeriod acts as a time delay in the shouldAutoBuyback(). Last uint represents last block for buyback occurance.
2387     struct Settings {
2388         bool autoBuybackEnabled;
2389         uint256 autoBuybackCap;
2390         uint256 autoBuybackAccumulator;
2391         uint256 autoBuybackAmount;
2392         uint256 autoBuybackBlockPeriod;
2393         uint256 autoBuybackBlockLast;
2394         uint256 minimumBuyBackThreshold;
2395     }
2396 
2397     // Users states
2398     mapping (address => bool) private _isExcludedFromFee;
2399 
2400     // Outside Swap Pairs
2401     mapping (address => bool) private _includeSwapFee;
2402 
2403 
2404     // Pair Details
2405     mapping (uint256 => address) private pairs;
2406     mapping (uint256 => address) private tokens;
2407     uint256 private pairsLength;
2408     mapping (address => bool) public _isPairAddress;
2409 
2410 
2411     // Set the name, symbol, and decimals here
2412     string constant _name = "ApplePYE";
2413     string constant _symbol = "APPLEPYE";
2414     uint8 constant _decimals = 18;
2415 
2416     Fees public _defaultFees;
2417     Fees public _defaultSellFees;
2418     Fees private _previousFees;
2419     Fees private _emptyFees;
2420     Fees private _sellFees;
2421     Fees private _outsideBuyFees;
2422     Fees private _outsideSellFees;
2423 
2424     Settings public _buyback;
2425 
2426     IPYESwapRouter public pyeSwapRouter;
2427     address public pyeSwapPair;
2428     address public WETH;
2429     address public constant _burnAddress = 0x000000000000000000000000000000000000dEaD;
2430 
2431     bool public swapEnabled = true;
2432     bool inSwap;
2433 
2434     modifier swapping() { inSwap = true; _; inSwap = false; }
2435     modifier onlyExchange() {
2436         bool isPair = false;
2437         for(uint i = 0; i < pairsLength; i++) {
2438             if(pairs[i] == msg.sender) isPair = true;
2439         }
2440         require(
2441             msg.sender == address(pyeSwapRouter)
2442             || isPair
2443             , "PYE: NOT_ALLOWED"
2444         );
2445         _;
2446     }
2447 
2448     /// @dev A record of each accounts delegate
2449     mapping (address => address) public delegates;
2450 
2451     /// @notice A checkpoint for marking number of votes from a given block
2452     struct Checkpoint {
2453         uint32 fromBlock;
2454         uint256 votes;
2455     }
2456 
2457     /// @notice A record of votes checkpoints for each account, by index
2458     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
2459 
2460     /// @notice The number of checkpoints for each account
2461     mapping (address => uint32) public numCheckpoints;
2462 
2463     /// @notice The EIP-712 typehash for the contract's domain
2464     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
2465 
2466     /// @notice The EIP-712 typehash for the delegation struct used by the contract
2467     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
2468 
2469     /// @notice A record of states for signing / validating signatures
2470     mapping (address => uint) public nonces;
2471 
2472     /// @notice An event thats emitted when an account changes its delegate
2473     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
2474 
2475     /// @notice An event thats emitted when a delegate account's vote balance changes
2476     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
2477 
2478     // Edit the constructor in order to declare default fees on deployment
2479     constructor (address _router, address _development, uint256 _developmentFee, uint256 _buybackFee, uint256 _burnFee) ERC20("","") {
2480         _setupRole(MINTER_ROLE, msg.sender);
2481         _setupRole(BURNER_ROLE, msg.sender);
2482         _setupRole(FEE_SETTER_ROLE, msg.sender);
2483         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
2484 
2485         pyeSwapRouter = IPYESwapRouter(_router);
2486         WETH = pyeSwapRouter.WETH();
2487         pyeSwapPair = IPYESwapFactory(pyeSwapRouter.factory())
2488         .createPair(address(this), WETH, true);
2489 
2490         tokens[pairsLength] = WETH;
2491         pairs[pairsLength] = pyeSwapPair;
2492         pairsLength += 1;
2493         _isPairAddress[pyeSwapPair] = true;
2494 
2495         _isExcludedFromFee[_msgSender()] = true;
2496         _isExcludedFromFee[pyeSwapPair] = true;
2497         _isExcludedFromFee[address(this)] = true;
2498         _isExcludedFromFee[_burnAddress] = true;
2499 
2500         // This should match the struct Fee
2501         _defaultFees = Fees(
2502             _developmentFee,
2503             _buybackFee,
2504             0,
2505             _development
2506         );
2507 
2508         _defaultSellFees = Fees(
2509             _developmentFee,
2510             _buybackFee,
2511             _burnFee,
2512             _development
2513         );
2514 
2515         _sellFees = Fees(
2516             0,
2517             0,
2518             _burnFee,
2519             _development
2520         );
2521 
2522         _outsideBuyFees = Fees(
2523             _developmentFee.add(_buybackFee),
2524             0,
2525             0,
2526             _development
2527         );
2528 
2529         _outsideSellFees = Fees(
2530             _developmentFee.add(_buybackFee),
2531             0,
2532             _burnFee,
2533             _development
2534         );
2535 
2536         IPYESwapPair(pyeSwapPair).updateTotalFee(400);
2537         
2538         emit Transfer(address(0), _msgSender(), _tTotal);
2539     }
2540 
2541     function name() public pure override returns (string memory) {
2542         return _name;
2543     }
2544 
2545     function symbol() public pure override returns (string memory) {
2546         return _symbol;
2547     }
2548 
2549     function decimals() public pure override returns (uint8) {
2550         return _decimals;
2551     }
2552 
2553     function totalSupply() public view override returns (uint256) {
2554         return _tTotal;
2555     }
2556 
2557     function balanceOf(address account) public view override returns (uint256) {
2558         return _balances[account];
2559     }
2560 
2561     function transfer(address recipient, uint256 amount) public override returns (bool) {
2562         _transfer(_msgSender(), recipient, amount);
2563         return true;
2564     }
2565 
2566     function allowance(address owner, address spender) public view override returns (uint256) {
2567         return _allowances[owner][spender];
2568     }
2569 
2570     function approve(address spender, uint256 amount) public override returns (bool) {
2571         _approve(_msgSender(), spender, amount);
2572         return true;
2573     }
2574 
2575     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
2576         _transfer(sender, recipient, amount);
2577         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
2578         return true;
2579     }
2580 
2581     function increaseAllowance(address spender, uint256 addedValue) public virtual override returns (bool) {
2582         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
2583         return true;
2584     }
2585 
2586     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual override returns (bool) {
2587         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
2588         return true;
2589     }
2590 
2591     function excludeFromFee(address account) public {
2592         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "APPLE: NOT_ALLOWED");
2593         _isExcludedFromFee[account] = true;
2594     }
2595 
2596     function includeInFee(address account) public {
2597         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "APPLE: NOT_ALLOWED");
2598         _isExcludedFromFee[account] = false;
2599     }
2600 
2601     function addOutsideSwapPair(address account) public {
2602         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "APPLE: NOT_ALLOWED");
2603         _includeSwapFee[account] = true;
2604     }
2605 
2606     function removeOutsideSwapPair(address account) public {
2607         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "APPLE: NOT_ALLOWED");
2608         _includeSwapFee[account] = false;
2609     }
2610 
2611     function _updatePairsFee() internal {
2612         for (uint j = 0; j < pairsLength; j++) {
2613             IPYESwapPair(pairs[j]).updateTotalFee(getTotalFee());
2614         }
2615     }
2616 
2617 
2618     // Functions to update fees and addresses 
2619 
2620     function setBuybackPercent(uint256 _buybackFee) external {
2621         require(hasRole(FEE_SETTER_ROLE, msg.sender), "APPLE: NOT_ALLOWED");
2622         require(_defaultSellFees.developmentFee.add(_defaultSellFees.burnFee).add(_buybackFee) <= 2500, "Fees exceed max limit.");
2623         _defaultFees.buybackFee = _buybackFee;
2624         _defaultSellFees.buybackFee = _buybackFee;
2625         _outsideBuyFees.developmentFee = _outsideBuyFees.developmentFee.add(_buybackFee);
2626         _outsideSellFees.developmentFee = _outsideSellFees.developmentFee.add(_buybackFee);
2627         _updatePairsFee();
2628     }
2629 
2630     function setDevelopmentPercent(uint256 _developmentFee) external {
2631         require(hasRole(FEE_SETTER_ROLE, msg.sender), "APPLE: NOT_ALLOWED");
2632         require(_defaultSellFees.buybackFee.add(_defaultSellFees.burnFee).add(_developmentFee) <= 2500, "Fees exceed max limit.");
2633         _defaultFees.developmentFee = _developmentFee;
2634         _defaultSellFees.developmentFee = _developmentFee;
2635         _outsideBuyFees.developmentFee = _outsideBuyFees.buybackFee.add(_developmentFee);
2636         _outsideSellFees.developmentFee = _outsideSellFees.buybackFee.add(_developmentFee);
2637         _updatePairsFee();
2638     }
2639 
2640     function setdevelopmentAddress(address _development) external {
2641         require(hasRole(FEE_SETTER_ROLE, msg.sender), "APPLE: NOT_ALLOWED");
2642         require(_development != address(0), "PYE: Address Zero is not allowed");
2643         _defaultFees.developmentAddress = _development;
2644         _defaultSellFees.developmentAddress = _development;
2645         _outsideBuyFees.developmentAddress = _development;
2646         _outsideSellFees.developmentAddress = _development;
2647     }
2648 
2649     function setSellBurnFee(uint256 _burnFee) external {
2650         require(hasRole(FEE_SETTER_ROLE, msg.sender), "APPLE: NOT_ALLOWED");
2651         require(_defaultSellFees.buybackFee.add(_defaultSellFees.developmentFee).add(_burnFee) <= 2500, "Fees exceed max limit.");
2652         _sellFees.burnFee = _burnFee;
2653         _defaultSellFees.burnFee = _burnFee;
2654         _outsideSellFees.burnFee = _burnFee;
2655     }
2656 
2657 
2658 
2659     function updateRouterAndPair(address _router, address _pair) public {
2660         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "APPLE: NOT_ALLOWED");
2661         _isExcludedFromFee[pyeSwapPair] = false;
2662         pyeSwapRouter = IPYESwapRouter(_router);
2663         pyeSwapPair = _pair;
2664         WETH = pyeSwapRouter.WETH();
2665 
2666         _isPairAddress[pyeSwapPair] = true;
2667         _isExcludedFromFee[pyeSwapPair] = true;
2668 
2669         pairs[0] = pyeSwapPair;
2670         tokens[0] = WETH;
2671 
2672         IPYESwapPair(pyeSwapPair).updateTotalFee(getTotalFee());
2673     }
2674 
2675     //to receive ETH from pyeRouter when swapping
2676     receive() external payable {}
2677 
2678     function _getValues(uint256 tAmount) private view returns (FeeValues memory) {
2679         FeeValues memory values = FeeValues(
2680             0,
2681             calculateFee(tAmount, _defaultFees.developmentFee),
2682             calculateFee(tAmount, _defaultFees.buybackFee),
2683             calculateFee(tAmount, _defaultFees.burnFee)
2684         );
2685 
2686         values.transferAmount = tAmount.sub(values.development).sub(values.buyback).sub(values.burn);
2687         return values;
2688     }
2689 
2690     function calculateFee(uint256 _amount, uint256 _fee) private pure returns (uint256) {
2691         if(_fee == 0) return 0;
2692         return _amount.mul(_fee).div(
2693             10**4
2694         );
2695     }
2696 
2697     function removeAllFee() private {
2698         _previousFees = _defaultFees;
2699         _defaultFees = _emptyFees;
2700     }
2701 
2702     function setSellFee() private {
2703         _previousFees = _defaultFees;
2704         _defaultFees = _sellFees;
2705     }
2706 
2707     function setOutsideBuyFee() private {
2708         _previousFees = _defaultFees;
2709         _defaultFees = _outsideBuyFees;
2710     }
2711 
2712     function setOutsideSellFee() private {
2713         _previousFees = _defaultFees;
2714         _defaultFees = _outsideSellFees;
2715     }
2716 
2717     function restoreAllFee() private {
2718         _defaultFees = _previousFees;
2719     }
2720 
2721     function isExcludedFromFee(address account) public view returns(bool) {
2722         return _isExcludedFromFee[account];
2723     }
2724 
2725     function _approve(
2726         address owner,
2727         address spender,
2728         uint256 amount
2729     ) internal override {
2730         require(owner != address(0), "BEP20: approve from the zero address");
2731         require(spender != address(0), "BEP20: approve to the zero address");
2732 
2733         _allowances[owner][spender] = amount;
2734         emit Approval(owner, spender, amount);
2735     }
2736 
2737     function getBalance(address keeper) public view returns (uint256){
2738         return _balances[keeper];
2739     }
2740 
2741     function _transfer(
2742         address from,
2743         address to,
2744         uint256 amount
2745     ) internal override {
2746         require(from != address(0), "BEP20: transfer from the zero address");
2747         require(to != address(0), "BEP20: transfer to the zero address");
2748         require(amount > 0, "Transfer amount must be greater than zero");
2749         require(!isBlacklisted[to]);
2750         _beforeTokenTransfer(from, to, amount);
2751 
2752         if(shouldAutoBuyback(amount)){ triggerAutoBuyback(); }
2753 
2754         if(isStakingContract[to]) { 	
2755             uint256 newAmountAdd = staked[from].amount.add(amount);	
2756             setStaked(from, newAmountAdd);	
2757         }	
2758         if(isStakingContract[from]) {	
2759             uint256 newAmountSub = staked[to].amount.sub(amount);	
2760             setStaked(to, newAmountSub);	
2761         }
2762 
2763         //indicates if fee should be deducted from transfer of tokens
2764         uint8 takeFee = 0;
2765         if(_isPairAddress[to] && from != address(pyeSwapRouter) && !isExcludedFromFee(from)) {
2766             takeFee = 1;
2767         } else if(_includeSwapFee[from]) {
2768             takeFee = 2;
2769         } else if(_includeSwapFee[to]) {
2770             takeFee = 3;
2771         }
2772 
2773         //transfer amount, it will take tax
2774         _tokenTransfer(from, to, amount, takeFee);
2775     }
2776 
2777     function getCirculatingSupply() public view returns (uint256) {
2778         return _tTotal.sub(balanceOf(_burnAddress)).sub(balanceOf(address(0)));
2779     }
2780 
2781     function getTotalFee() public view returns (uint256) {
2782         return _defaultFees.developmentFee
2783             .add(_defaultFees.buybackFee)
2784             .add(_defaultFees.burnFee);
2785     }
2786 
2787     //this method is responsible for taking all fee, if takeFee is true
2788     function _tokenTransfer(address sender, address recipient, uint256 amount, uint8 takeFee) private {
2789         if(takeFee == 0) {
2790             removeAllFee();
2791         } else if(takeFee == 1) {
2792             setSellFee();
2793         } else if(takeFee == 2) {
2794             setOutsideBuyFee();
2795         } else if(takeFee == 3) {
2796             setOutsideSellFee();
2797         }
2798 
2799         FeeValues memory _values = _getValues(amount);
2800         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
2801         _balances[recipient] = _balances[recipient].add(_values.transferAmount);
2802         _takeFees(_values);
2803 
2804         emit Transfer(sender, recipient, _values.transferAmount);
2805 
2806         if(delegates[sender] == address(0)) {
2807             delegates[sender] = sender;
2808         }
2809 
2810         if(delegates[recipient] == address(0)) {
2811             delegates[recipient] = recipient;
2812         }
2813 
2814         if(amount == _values.transferAmount) {	
2815             _moveDelegates(delegates[sender], delegates[recipient], amount);	
2816         } else {	
2817             _moveDelegates(delegates[sender], delegates[recipient], _values.transferAmount);	
2818             _moveDelegates(delegates[sender], delegates[_defaultFees.developmentAddress], _values.development);	
2819             _moveDelegates(delegates[sender], address(0), _values.burn);	
2820         }
2821 
2822         if(takeFee == 0 || takeFee == 1) {
2823             restoreAllFee();
2824         } else if(takeFee == 2 || takeFee == 3) {
2825             restoreAllFee();
2826             emit Transfer(sender, _defaultFees.developmentAddress, _values.development);
2827         }
2828     }
2829 
2830     function _takeFees(FeeValues memory values) private {
2831         _takeFee(values.development, _defaultFees.developmentAddress);
2832         _takeBurnFee(values.burn);
2833     }
2834 
2835     function _takeFee(uint256 tAmount, address recipient) private {
2836         if(recipient == address(0)) return;
2837         if(tAmount == 0) return;
2838 
2839         _balances[recipient] = _balances[recipient].add(tAmount);
2840     }
2841 
2842     function _takeBurnFee(uint256 amount) private {
2843         if(amount == 0) return;
2844 
2845         _balances[address(this)] = _balances[address(this)].add(amount);
2846         _burn(address(this), amount);
2847     }
2848 
2849     // This function transfers the fees to the correct addresses. 
2850     function depositLPFee(uint256 amount, address token) public onlyExchange {
2851         uint256 tokenIndex = _getTokenIndex(token);
2852         if(tokenIndex < pairsLength) {
2853             uint256 allowanceT = IERC20(token).allowance(msg.sender, address(this));
2854             if(allowanceT >= amount) {
2855                 IERC20(token).transferFrom(msg.sender, address(this), amount);
2856 
2857                 if(token != WETH) {
2858                     uint256 balanceBefore = IERC20(address(WETH)).balanceOf(address(this));
2859                     swapToWETH(amount, token);
2860                     uint256 fAmount = IERC20(address(WETH)).balanceOf(address(this)).sub(balanceBefore);
2861                     
2862                     // All fees to be declared here in order to be calculated and sent
2863                     uint256 totalFee = getTotalFee();
2864                     uint256 developmentFeeAmount = fAmount.mul(_defaultFees.developmentFee).div(totalFee);
2865 
2866                     IERC20(WETH).transfer(_defaultFees.developmentAddress, developmentFeeAmount);
2867                 } else {
2868                     // All fees to be declared here in order to be calculated and sent
2869                     uint256 totalFee = getTotalFee();
2870                     uint256 developmentFeeAmount = amount.mul(_defaultFees.developmentFee).div(totalFee);
2871 
2872                     IERC20(token).transfer(_defaultFees.developmentAddress, developmentFeeAmount);
2873                 }
2874             }
2875         }
2876     }
2877 
2878     function swapToWETH(uint256 amount, address token) internal {
2879         address[] memory path = new address[](2);
2880         path[0] = token;
2881         path[1] = WETH;
2882 
2883         IERC20(token).approve(address(pyeSwapRouter), amount);
2884         pyeSwapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
2885             amount,
2886             0,
2887             path,
2888             address(this),
2889             block.timestamp
2890         );
2891     }
2892 
2893     // runs check to see if autobuyback should trigger
2894     function shouldAutoBuyback(uint256 amount) internal view returns (bool) {
2895         return msg.sender != pyeSwapPair
2896         && !inSwap
2897         && _buyback.autoBuybackEnabled
2898         && _buyback.autoBuybackBlockLast + _buyback.autoBuybackBlockPeriod <= block.number // After N blocks from last buyback
2899         && IERC20(address(WETH)).balanceOf(address(this)) >= _buyback.autoBuybackAmount
2900         && amount >= _buyback.minimumBuyBackThreshold;
2901     }
2902 
2903     // triggers auto buyback
2904     function triggerAutoBuyback() internal {
2905         buyTokens(_buyback.autoBuybackAmount, _burnAddress);
2906         _buyback.autoBuybackBlockLast = block.number;
2907         _buyback.autoBuybackAccumulator = _buyback.autoBuybackAccumulator.add(_buyback.autoBuybackAmount);
2908         if(_buyback.autoBuybackAccumulator > _buyback.autoBuybackCap){ _buyback.autoBuybackEnabled = false; }
2909     }
2910 
2911     // logic to purchase moonforce tokens
2912     function buyTokens(uint256 amount, address to) internal swapping {
2913         address[] memory path = new address[](2);
2914         path[0] = WETH;
2915         path[1] = address(this);
2916 
2917         IERC20(WETH).approve(address(pyeSwapRouter), amount);
2918         pyeSwapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
2919             amount,
2920             0,
2921             path,
2922             to,
2923             block.timestamp
2924         );
2925     }
2926 
2927     // manually adjust the buyback settings to suit your needs
2928     function setAutoBuybackSettings(bool _enabled, uint256 _cap, uint256 _amount, uint256 _period, uint256 _minimumThreshold) external {
2929         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "APPLE: NOT_ALLOWED");
2930         _buyback.autoBuybackEnabled = _enabled;
2931         _buyback.autoBuybackCap = _cap;
2932         _buyback.autoBuybackAccumulator = 0;
2933         _buyback.autoBuybackAmount = _amount;
2934         _buyback.autoBuybackBlockPeriod = _period;
2935         _buyback.autoBuybackBlockLast = block.number;
2936         _buyback.minimumBuyBackThreshold = _minimumThreshold;
2937     }
2938 
2939     function _getTokenIndex(address _token) internal view returns (uint256) {
2940         uint256 index = pairsLength + 1;
2941         for(uint256 i = 0; i < pairsLength; i++) {
2942             if(tokens[i] == _token) index = i;
2943         }
2944 
2945         return index;
2946     }
2947 
2948     function addPair(address _pair, address _token) public {
2949         address factory = pyeSwapRouter.factory();
2950         require(
2951             msg.sender == factory
2952             || msg.sender == address(pyeSwapRouter)
2953             || msg.sender == address(this)
2954         , "PYE: NOT_ALLOWED"
2955         );
2956 
2957         if(!_checkPairRegistered(_pair)) {
2958             _isExcludedFromFee[_pair] = true;
2959             _isPairAddress[_pair] = true;
2960 
2961             pairs[pairsLength] = _pair;
2962             tokens[pairsLength] = _token;
2963 
2964             pairsLength += 1;
2965 
2966             IPYESwapPair(_pair).updateTotalFee(getTotalFee());
2967         }
2968     }
2969 
2970     function _checkPairRegistered(address _pair) internal view returns (bool) {
2971         bool isPair = false;
2972         for(uint i = 0; i < pairsLength; i++) {
2973             if(pairs[i] == _pair) isPair = true;
2974         }
2975 
2976         return isPair;
2977     }
2978 
2979     // Rescue eth that is sent here by mistake
2980     function rescueETH(uint256 amount, address to) external {
2981         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "APPLE: NOT_ALLOWED");
2982         payable(to).transfer(amount);
2983       }
2984 
2985     // Rescue tokens that are sent here by mistake
2986     function rescueToken(IERC20 token, uint256 amount, address to) external {
2987         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "APPLE: NOT_ALLOWED");
2988         if( token.balanceOf(address(this)) < amount ) {
2989             amount = token.balanceOf(address(this));
2990         }
2991         token.transfer(to, amount);
2992     }
2993 
2994     /**	
2995      * @dev Spend `amount` form the allowance of `owner` toward `spender`.	
2996      *	
2997      * Does not update the allowance amount in case of infinite allowance.	
2998      * Revert if not enough allowance is available.	
2999      *	
3000      * Might emit an {Approval} event.	
3001      */	
3002     function _spendAllowance(	
3003         address owner,	
3004         address spender,	
3005         uint256 amount	
3006     ) internal override virtual {	
3007         uint256 currentAllowance = allowance(owner, spender);	
3008         if (currentAllowance != type(uint256).max) {	
3009             require(currentAllowance >= amount, "ERC20: insufficient allowance");	
3010             unchecked {	
3011                 _approve(owner, spender, currentAllowance - amount);	
3012             }	
3013         }	
3014     }
3015 
3016     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
3017      * the total supply.
3018      *
3019      * Emits a {Transfer} event with `from` set to the zero address.
3020      *
3021      * Requirements
3022      *
3023      * - `to` cannot be the zero address.
3024      */
3025     function _mint(address account, uint256 amount) override internal {
3026         require(account != address(0), 'BEP20: mint to the zero address');
3027 
3028         _tTotal = _tTotal.add(amount);
3029         _balances[account] = _balances[account].add(amount);
3030         emit Transfer(address(0), account, amount);
3031     }
3032 
3033     /**
3034      * @dev Destroys `amount` tokens from `account`, reducing the
3035      * total supply.
3036      *
3037      * Emits a {Transfer} event with `to` set to the zero address.
3038      *
3039      * Requirements
3040      *
3041      * - `account` cannot be the zero address.
3042      * - `account` must have at least `amount` tokens.
3043      */
3044     function _burn(address account, uint256 amount) override internal {	
3045         require(account != address(0), 'BEP20: burn from the zero address');	
3046         _balances[account] = _balances[account].sub(amount, 'BEP20: burn amount exceeds balance');	
3047         _tTotal = _tTotal.sub(amount);	
3048         emit Transfer(account, address(0), amount);	
3049     }
3050 
3051     
3052     function burnFrom(address _from, uint256 _amount) public {	
3053         require(hasRole(BURNER_ROLE, msg.sender), "APPLE: NOT_ALLOWED");	
3054         _spendAllowance(_from, msg.sender, _amount);
3055         _beforeTokenTransfer(_from, address(0), _amount);		
3056         _burn(_from, _amount);	
3057         if(delegates[_from] == address(0)) {	
3058             delegates[_from] = _from;	
3059         }	
3060         _moveDelegates(delegates[_from], address(0), _amount);	
3061     }	
3062 
3063 
3064     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
3065     function mint(address _to, uint256 _amount) public {
3066         require(hasRole(MINTER_ROLE, msg.sender), "APPLE: NOT_ALLOWED");
3067         _beforeTokenTransfer(address(0), _to, _amount);
3068         _mint(_to, _amount);
3069         
3070         if(delegates[_to] == address(0)) {
3071             delegates[_to] = _to;
3072         }
3073         _moveDelegates(address(0), delegates[_to], _amount);
3074     }
3075 
3076     function burn(uint256 _amount) public {
3077         require(hasRole(BURNER_ROLE, msg.sender), "APPLE: NOT_ALLOWED");
3078         _beforeTokenTransfer(msg.sender, address(0), _amount);
3079         _burn(msg.sender, _amount);
3080 
3081         if(delegates[msg.sender] == address(0)) {
3082             delegates[msg.sender] = msg.sender;
3083         }
3084         _moveDelegates(delegates[msg.sender], address(0), _amount);
3085     }
3086 
3087     // Copied and modified from YAM code:
3088     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
3089     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
3090     // Which is copied and modified from COMPOUND:
3091     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
3092 
3093     /**
3094      * @notice Delegate votes from `msg.sender` to `delegatee`
3095     * @param delegatee The address to delegate votes to
3096     */
3097     function delegate(address delegatee) external {
3098         return _delegate(msg.sender, delegatee);
3099     }
3100 
3101     /**
3102      * @notice Delegates votes from signatory to `delegatee`
3103      * @param delegatee The address to delegate votes to
3104      * @param nonce The contract state required to match the signature
3105      * @param expiry The time at which to expire the signature
3106      * @param v The recovery byte of the signature
3107      * @param r Half of the ECDSA signature pair
3108      * @param s Half of the ECDSA signature pair
3109      */
3110     function delegateBySig(
3111         address delegatee,
3112         uint nonce,
3113         uint expiry,
3114         uint8 v,
3115         bytes32 r,
3116         bytes32 s
3117     )
3118     external
3119     {
3120         bytes32 domainSeparator = keccak256(
3121             abi.encode(
3122                 DOMAIN_TYPEHASH,
3123                 keccak256(bytes(name())),
3124                 getChainId(),
3125                 address(this)
3126             )
3127         );
3128 
3129         bytes32 structHash = keccak256(
3130             abi.encode(
3131                 DELEGATION_TYPEHASH,
3132                 delegatee,
3133                 nonce,
3134                 expiry
3135             )
3136         );
3137 
3138         bytes32 digest = keccak256(
3139             abi.encodePacked(
3140                 "\x19\x01",
3141                 domainSeparator,
3142                 structHash
3143             )
3144         );
3145 
3146         address signatory = ecrecover(digest, v, r, s);
3147         require(signatory != address(0), "APPLE::delegateBySig: invalid signature");
3148         require(nonce == nonces[signatory]++, "APPLE::delegateBySig: invalid nonce");
3149         require(block.timestamp <= expiry, "APPLE::delegateBySig: signature expired");
3150         return _delegate(signatory, delegatee);
3151     }
3152 
3153     /**
3154      * @notice Gets the current votes balance for `account`
3155      * @param account The address to get votes balance
3156      * @return The number of current votes for `account`
3157      */
3158     function getCurrentVotes(address account)
3159     external
3160     view
3161     returns (uint256)
3162     {
3163         uint32 nCheckpoints = numCheckpoints[account];
3164         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
3165     }
3166 
3167     /**
3168      * @notice Determine the prior number of votes for an account as of a block number
3169      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
3170      * @param account The address of the account to check
3171      * @param blockNumber The block number to get the vote balance at
3172      * @return The number of votes the account had as of the given block
3173      */
3174     function getPriorVotes(address account, uint blockNumber)
3175     external
3176     view
3177     returns (uint256)
3178     {
3179         require(blockNumber < block.number, "APPLE::getPriorVotes: not yet determined");
3180 
3181         uint32 nCheckpoints = numCheckpoints[account];
3182         if (nCheckpoints == 0) {
3183             return 0;
3184         }
3185 
3186         // First check most recent balance
3187         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
3188             return checkpoints[account][nCheckpoints - 1].votes;
3189         }
3190 
3191         // Next check implicit zero balance
3192         if (checkpoints[account][0].fromBlock > blockNumber) {
3193             return 0;
3194         }
3195 
3196         uint32 lower = 0;
3197         uint32 upper = nCheckpoints - 1;
3198         while (upper > lower) {
3199             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
3200             Checkpoint memory cp = checkpoints[account][center];
3201             if (cp.fromBlock == blockNumber) {
3202                 return cp.votes;
3203             } else if (cp.fromBlock < blockNumber) {
3204                 lower = center;
3205             } else {
3206                 upper = center - 1;
3207             }
3208         }
3209         return checkpoints[account][lower].votes;
3210     }
3211 
3212     function _delegate(address delegator, address delegatee)
3213     internal
3214     {
3215         address currentDelegate = delegates[delegator];
3216         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying APPLE (not scaled);
3217         delegates[delegator] = delegatee;
3218 
3219         emit DelegateChanged(delegator, currentDelegate, delegatee);
3220 
3221         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
3222     }
3223 
3224     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
3225         if (srcRep != dstRep && amount > 0) {
3226             if (srcRep != address(0)) {
3227                 // decrease old representative
3228                 uint32 srcRepNum = numCheckpoints[srcRep];
3229                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
3230                 uint256 srcRepNew = srcRepOld.sub(amount);
3231                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
3232             }
3233 
3234             if (dstRep != address(0)) {
3235                 // increase new representative
3236                 uint32 dstRepNum = numCheckpoints[dstRep];
3237                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
3238                 uint256 dstRepNew = dstRepOld.add(amount);
3239                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
3240             }
3241         }
3242     }
3243 
3244     function _writeCheckpoint(
3245         address delegatee,
3246         uint32 nCheckpoints,
3247         uint256 oldVotes,
3248         uint256 newVotes
3249     )
3250     internal
3251     {
3252         uint32 blockNumber = safe32(block.number, "APPLE::_writeCheckpoint: block number exceeds 32 bits");
3253 
3254         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
3255             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
3256         } else {
3257             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
3258             numCheckpoints[delegatee] = nCheckpoints + 1;
3259         }
3260 
3261         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
3262     }
3263 
3264     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
3265         require(n < 2**32, errorMessage);
3266         return uint32(n);
3267     }
3268 
3269     function getChainId() internal view returns (uint) {
3270         uint256 chainId;
3271         assembly { chainId := chainid() }
3272         return chainId;
3273     }
3274 
3275     //-------------------- BEGIN STAKED FXNS ------------------------------	
3276     function getOwnedBalance(address account) external view returns (uint256){	
3277         return staked[account].amount.add(_balances[account]);	
3278     }	
3279     function setStaked(address holder, uint256 amount) internal  {	
3280         if(amount > 0 && staked[holder].amount == 0){	
3281             addHolder(holder);	
3282         }else if(amount == 0 && staked[holder].amount > 0){	
3283             removeHolder(holder);	
3284         }	
3285         totalStaked = totalStaked.sub(staked[holder].amount).add(amount);	
3286         staked[holder].amount = amount;	
3287     }	
3288     function addHolder(address holder) internal {	
3289         holderIndexes[holder] = holders.length;	
3290         holders.push(holder);	
3291     }	
3292     function removeHolder(address holder) internal {	
3293         holders[holderIndexes[holder]] = holders[holders.length-1];	
3294         holderIndexes[holders[holders.length-1]] = holderIndexes[holder];	
3295         holders.pop();	
3296     }	
3297     // set an address as a staking contract	
3298     function setIsStakingContract(address account, bool set) external {	
3299         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "FUEL: NOT_ALLOWED");	
3300         isStakingContract[account] = set;	
3301     }	
3302     //--------------------------------------BEGIN BLACKLIST FUNCTIONS---------|	
3303     // enter an address to blacklist it. This blocks transfers TO that address. Balcklisted members can still sell.	
3304     function blacklistAddress(address addressToBlacklist) external {	
3305         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "FUEL: NOT_ALLOWED");	
3306         require(!isBlacklisted[addressToBlacklist] , "Address is already blacklisted!");	
3307         isBlacklisted[addressToBlacklist] = true;	
3308     }	
3309     // enter a currently blacklisted address to un-blacklist it.	
3310     function removeFromBlacklist(address addressToRemove) external {	
3311         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "FUEL: NOT_ALLOWED");	
3312         require(isBlacklisted[addressToRemove] , "Address has not been blacklisted! Enter an address that is on the blacklist.");	
3313         isBlacklisted[addressToRemove] = false;	
3314     }
3315 
3316     // -------------------------------------BEGIN MODIFIED SNAPSHOT FUNCTIONS--------------------|
3317 
3318     //@ dev a direct, modified implementation of ERC20 snapshot designed to track totalOwnedBalance (the sum of balanceOf(acct) and staked.amount of that acct), as opposed
3319     // to just balanceOf(acct). totalSupply is tracked normally via _tTotal in the totalSupply() function.
3320 
3321     using Arrays for uint256[];
3322     using Counters for Counters.Counter;
3323     Counters.Counter private _currentSnapshotId;
3324 
3325     struct Snapshots {
3326         uint256[] ids;
3327         uint256[] values;
3328     }
3329 
3330     mapping(address => Snapshots) private _accountBalanceSnapshots;
3331     Snapshots private _totalSupplySnapshots;
3332     event Snapshot(uint256 id);
3333 
3334     // owner can manually call a snapshot.
3335     function snapshot() public onlyOwner {
3336         _snapshot();
3337     }
3338 
3339     function _snapshot() internal virtual returns (uint256) {
3340         _currentSnapshotId.increment();
3341 
3342         uint256 currentId = _getCurrentSnapshotId();
3343         emit Snapshot(currentId);
3344         return currentId;
3345     }
3346 
3347     function _getCurrentSnapshotId() internal view virtual returns (uint256) {
3348         return _currentSnapshotId.current();
3349     }
3350 
3351     function getCurrentSnapshotID() public view onlyOwner returns (uint256) {
3352         return _getCurrentSnapshotId();
3353     }
3354 
3355     // modified to also read users staked balance. 
3356     function totalBalanceOfAt(address account, uint256 snapshotId) public view virtual returns (uint256) {
3357         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
3358 
3359         return snapshotted ? value : (balanceOf(account).add(staked[account].amount));
3360     }
3361 
3362     function totalSupplyAt(uint256 snapshotId) public view virtual returns (uint256) {
3363         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
3364 
3365         return snapshotted ? value : totalSupply();
3366     }
3367 
3368     function _valueAt(uint256 snapshotId, Snapshots storage snapshots) private view returns (bool, uint256) {
3369         require(snapshotId > 0, "ERC20Snapshot: id is 0");
3370         require(snapshotId <= _getCurrentSnapshotId(), "ERC20Snapshot: nonexistent id");
3371 
3372         uint256 index = snapshots.ids.findUpperBound(snapshotId);
3373 
3374         if (index == snapshots.ids.length) {
3375             return (false, 0);
3376         } else {
3377             return (true, snapshots.values[index]);
3378         }
3379     }
3380 
3381     // modified to also add staked[acct].amount
3382     function _updateAccountSnapshot(address account) private {
3383         _updateSnapshot(_accountBalanceSnapshots[account], (balanceOf(account).add(staked[account].amount)));
3384     }
3385 
3386     function _updateTotalSupplySnapshot() private {
3387         _updateSnapshot(_totalSupplySnapshots, totalSupply());
3388     }
3389 
3390     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
3391         uint256 currentId = _getCurrentSnapshotId();
3392         if (_lastSnapshotId(snapshots.ids) < currentId) {
3393             snapshots.ids.push(currentId);
3394             snapshots.values.push(currentValue);
3395         }
3396     }
3397 
3398     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
3399         if (ids.length == 0) {
3400             return 0;
3401         } else {
3402             return ids[ids.length - 1];
3403         }
3404     }
3405 
3406     function _beforeTokenTransfer(
3407         address from,
3408         address to,
3409         uint256 amount
3410     ) internal virtual override {
3411         super._beforeTokenTransfer(from, to, amount);
3412 
3413         if (from == address(0)) {
3414             // mint
3415             _updateAccountSnapshot(to);
3416             _updateTotalSupplySnapshot();
3417         } else if (to == address(0)) {
3418             // burn
3419             _updateAccountSnapshot(from);
3420             _updateTotalSupplySnapshot();
3421         } else {
3422             // transfer
3423             _updateAccountSnapshot(from);
3424             _updateAccountSnapshot(to);
3425         }
3426     }
3427 
3428 }
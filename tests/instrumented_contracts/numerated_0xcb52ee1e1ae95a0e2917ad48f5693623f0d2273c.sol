1 // Sources flattened with hardhat v2.6.4 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v3.4.2
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.4.2
32 
33 // SPDX-License-Identifier: MIT
34 
35 pragma solidity >=0.6.0 <0.8.0;
36 
37 /**
38  * @dev Interface of the ERC165 standard, as defined in the
39  * https://eips.ethereum.org/EIPS/eip-165[EIP].
40  *
41  * Implementers can declare support of contract interfaces, which can then be
42  * queried by others ({ERC165Checker}).
43  *
44  * For an implementation, see {ERC165}.
45  */
46 interface IERC165 {
47     /**
48      * @dev Returns true if this contract implements the interface defined by
49      * `interfaceId`. See the corresponding
50      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
51      * to learn more about how these ids are created.
52      *
53      * This function call must use less than 30 000 gas.
54      */
55     function supportsInterface(bytes4 interfaceId) external view returns (bool);
56 }
57 
58 
59 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v3.4.2
60 
61 // SPDX-License-Identifier: MIT
62 
63 pragma solidity >=0.6.2 <0.8.0;
64 
65 /**
66  * @dev Required interface of an ERC721 compliant contract.
67  */
68 interface IERC721 is IERC165 {
69     /**
70      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
73 
74     /**
75      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
76      */
77     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
78 
79     /**
80      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
81      */
82     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
83 
84     /**
85      * @dev Returns the number of tokens in ``owner``'s account.
86      */
87     function balanceOf(address owner) external view returns (uint256 balance);
88 
89     /**
90      * @dev Returns the owner of the `tokenId` token.
91      *
92      * Requirements:
93      *
94      * - `tokenId` must exist.
95      */
96     function ownerOf(uint256 tokenId) external view returns (address owner);
97 
98     /**
99      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
100      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
101      *
102      * Requirements:
103      *
104      * - `from` cannot be the zero address.
105      * - `to` cannot be the zero address.
106      * - `tokenId` token must exist and be owned by `from`.
107      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
108      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
109      *
110      * Emits a {Transfer} event.
111      */
112     function safeTransferFrom(address from, address to, uint256 tokenId) external;
113 
114     /**
115      * @dev Transfers `tokenId` token from `from` to `to`.
116      *
117      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
118      *
119      * Requirements:
120      *
121      * - `from` cannot be the zero address.
122      * - `to` cannot be the zero address.
123      * - `tokenId` token must be owned by `from`.
124      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
125      *
126      * Emits a {Transfer} event.
127      */
128     function transferFrom(address from, address to, uint256 tokenId) external;
129 
130     /**
131      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
132      * The approval is cleared when the token is transferred.
133      *
134      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
135      *
136      * Requirements:
137      *
138      * - The caller must own the token or be an approved operator.
139      * - `tokenId` must exist.
140      *
141      * Emits an {Approval} event.
142      */
143     function approve(address to, uint256 tokenId) external;
144 
145     /**
146      * @dev Returns the account approved for `tokenId` token.
147      *
148      * Requirements:
149      *
150      * - `tokenId` must exist.
151      */
152     function getApproved(uint256 tokenId) external view returns (address operator);
153 
154     /**
155      * @dev Approve or remove `operator` as an operator for the caller.
156      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
157      *
158      * Requirements:
159      *
160      * - The `operator` cannot be the caller.
161      *
162      * Emits an {ApprovalForAll} event.
163      */
164     function setApprovalForAll(address operator, bool _approved) external;
165 
166     /**
167      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
168      *
169      * See {setApprovalForAll}
170      */
171     function isApprovedForAll(address owner, address operator) external view returns (bool);
172 
173     /**
174       * @dev Safely transfers `tokenId` token from `from` to `to`.
175       *
176       * Requirements:
177       *
178       * - `from` cannot be the zero address.
179       * - `to` cannot be the zero address.
180       * - `tokenId` token must exist and be owned by `from`.
181       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
182       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
183       *
184       * Emits a {Transfer} event.
185       */
186     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
187 }
188 
189 
190 // File @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol@v3.4.2
191 
192 // SPDX-License-Identifier: MIT
193 
194 pragma solidity >=0.6.2 <0.8.0;
195 
196 /**
197  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
198  * @dev See https://eips.ethereum.org/EIPS/eip-721
199  */
200 interface IERC721Metadata is IERC721 {
201 
202     /**
203      * @dev Returns the token collection name.
204      */
205     function name() external view returns (string memory);
206 
207     /**
208      * @dev Returns the token collection symbol.
209      */
210     function symbol() external view returns (string memory);
211 
212     /**
213      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
214      */
215     function tokenURI(uint256 tokenId) external view returns (string memory);
216 }
217 
218 
219 // File @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol@v3.4.2
220 
221 // SPDX-License-Identifier: MIT
222 
223 pragma solidity >=0.6.2 <0.8.0;
224 
225 /**
226  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
227  * @dev See https://eips.ethereum.org/EIPS/eip-721
228  */
229 interface IERC721Enumerable is IERC721 {
230 
231     /**
232      * @dev Returns the total amount of tokens stored by the contract.
233      */
234     function totalSupply() external view returns (uint256);
235 
236     /**
237      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
238      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
239      */
240     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
241 
242     /**
243      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
244      * Use along with {totalSupply} to enumerate all tokens.
245      */
246     function tokenByIndex(uint256 index) external view returns (uint256);
247 }
248 
249 
250 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v3.4.2
251 
252 // SPDX-License-Identifier: MIT
253 
254 pragma solidity >=0.6.0 <0.8.0;
255 
256 /**
257  * @title ERC721 token receiver interface
258  * @dev Interface for any contract that wants to support safeTransfers
259  * from ERC721 asset contracts.
260  */
261 interface IERC721Receiver {
262     /**
263      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
264      * by `operator` from `from`, this function is called.
265      *
266      * It must return its Solidity selector to confirm the token transfer.
267      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
268      *
269      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
270      */
271     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
272 }
273 
274 
275 // File @openzeppelin/contracts/introspection/ERC165.sol@v3.4.2
276 
277 // SPDX-License-Identifier: MIT
278 
279 pragma solidity >=0.6.0 <0.8.0;
280 
281 /**
282  * @dev Implementation of the {IERC165} interface.
283  *
284  * Contracts may inherit from this and call {_registerInterface} to declare
285  * their support of an interface.
286  */
287 abstract contract ERC165 is IERC165 {
288     /*
289      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
290      */
291     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
292 
293     /**
294      * @dev Mapping of interface ids to whether or not it's supported.
295      */
296     mapping(bytes4 => bool) private _supportedInterfaces;
297 
298     constructor () internal {
299         // Derived contracts need only register support for their own interfaces,
300         // we register support for ERC165 itself here
301         _registerInterface(_INTERFACE_ID_ERC165);
302     }
303 
304     /**
305      * @dev See {IERC165-supportsInterface}.
306      *
307      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
308      */
309     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
310         return _supportedInterfaces[interfaceId];
311     }
312 
313     /**
314      * @dev Registers the contract as an implementer of the interface defined by
315      * `interfaceId`. Support of the actual ERC165 interface is automatic and
316      * registering its interface id is not required.
317      *
318      * See {IERC165-supportsInterface}.
319      *
320      * Requirements:
321      *
322      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
323      */
324     function _registerInterface(bytes4 interfaceId) internal virtual {
325         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
326         _supportedInterfaces[interfaceId] = true;
327     }
328 }
329 
330 
331 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.2
332 
333 // SPDX-License-Identifier: MIT
334 
335 pragma solidity >=0.6.0 <0.8.0;
336 
337 /**
338  * @dev Wrappers over Solidity's arithmetic operations with added overflow
339  * checks.
340  *
341  * Arithmetic operations in Solidity wrap on overflow. This can easily result
342  * in bugs, because programmers usually assume that an overflow raises an
343  * error, which is the standard behavior in high level programming languages.
344  * `SafeMath` restores this intuition by reverting the transaction when an
345  * operation overflows.
346  *
347  * Using this library instead of the unchecked operations eliminates an entire
348  * class of bugs, so it's recommended to use it always.
349  */
350 library SafeMath {
351     /**
352      * @dev Returns the addition of two unsigned integers, with an overflow flag.
353      *
354      * _Available since v3.4._
355      */
356     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
357         uint256 c = a + b;
358         if (c < a) return (false, 0);
359         return (true, c);
360     }
361 
362     /**
363      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
364      *
365      * _Available since v3.4._
366      */
367     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
368         if (b > a) return (false, 0);
369         return (true, a - b);
370     }
371 
372     /**
373      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
374      *
375      * _Available since v3.4._
376      */
377     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
378         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
379         // benefit is lost if 'b' is also tested.
380         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
381         if (a == 0) return (true, 0);
382         uint256 c = a * b;
383         if (c / a != b) return (false, 0);
384         return (true, c);
385     }
386 
387     /**
388      * @dev Returns the division of two unsigned integers, with a division by zero flag.
389      *
390      * _Available since v3.4._
391      */
392     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
393         if (b == 0) return (false, 0);
394         return (true, a / b);
395     }
396 
397     /**
398      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
399      *
400      * _Available since v3.4._
401      */
402     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
403         if (b == 0) return (false, 0);
404         return (true, a % b);
405     }
406 
407     /**
408      * @dev Returns the addition of two unsigned integers, reverting on
409      * overflow.
410      *
411      * Counterpart to Solidity's `+` operator.
412      *
413      * Requirements:
414      *
415      * - Addition cannot overflow.
416      */
417     function add(uint256 a, uint256 b) internal pure returns (uint256) {
418         uint256 c = a + b;
419         require(c >= a, "SafeMath: addition overflow");
420         return c;
421     }
422 
423     /**
424      * @dev Returns the subtraction of two unsigned integers, reverting on
425      * overflow (when the result is negative).
426      *
427      * Counterpart to Solidity's `-` operator.
428      *
429      * Requirements:
430      *
431      * - Subtraction cannot overflow.
432      */
433     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
434         require(b <= a, "SafeMath: subtraction overflow");
435         return a - b;
436     }
437 
438     /**
439      * @dev Returns the multiplication of two unsigned integers, reverting on
440      * overflow.
441      *
442      * Counterpart to Solidity's `*` operator.
443      *
444      * Requirements:
445      *
446      * - Multiplication cannot overflow.
447      */
448     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
449         if (a == 0) return 0;
450         uint256 c = a * b;
451         require(c / a == b, "SafeMath: multiplication overflow");
452         return c;
453     }
454 
455     /**
456      * @dev Returns the integer division of two unsigned integers, reverting on
457      * division by zero. The result is rounded towards zero.
458      *
459      * Counterpart to Solidity's `/` operator. Note: this function uses a
460      * `revert` opcode (which leaves remaining gas untouched) while Solidity
461      * uses an invalid opcode to revert (consuming all remaining gas).
462      *
463      * Requirements:
464      *
465      * - The divisor cannot be zero.
466      */
467     function div(uint256 a, uint256 b) internal pure returns (uint256) {
468         require(b > 0, "SafeMath: division by zero");
469         return a / b;
470     }
471 
472     /**
473      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
474      * reverting when dividing by zero.
475      *
476      * Counterpart to Solidity's `%` operator. This function uses a `revert`
477      * opcode (which leaves remaining gas untouched) while Solidity uses an
478      * invalid opcode to revert (consuming all remaining gas).
479      *
480      * Requirements:
481      *
482      * - The divisor cannot be zero.
483      */
484     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
485         require(b > 0, "SafeMath: modulo by zero");
486         return a % b;
487     }
488 
489     /**
490      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
491      * overflow (when the result is negative).
492      *
493      * CAUTION: This function is deprecated because it requires allocating memory for the error
494      * message unnecessarily. For custom revert reasons use {trySub}.
495      *
496      * Counterpart to Solidity's `-` operator.
497      *
498      * Requirements:
499      *
500      * - Subtraction cannot overflow.
501      */
502     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
503         require(b <= a, errorMessage);
504         return a - b;
505     }
506 
507     /**
508      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
509      * division by zero. The result is rounded towards zero.
510      *
511      * CAUTION: This function is deprecated because it requires allocating memory for the error
512      * message unnecessarily. For custom revert reasons use {tryDiv}.
513      *
514      * Counterpart to Solidity's `/` operator. Note: this function uses a
515      * `revert` opcode (which leaves remaining gas untouched) while Solidity
516      * uses an invalid opcode to revert (consuming all remaining gas).
517      *
518      * Requirements:
519      *
520      * - The divisor cannot be zero.
521      */
522     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
523         require(b > 0, errorMessage);
524         return a / b;
525     }
526 
527     /**
528      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
529      * reverting with custom message when dividing by zero.
530      *
531      * CAUTION: This function is deprecated because it requires allocating memory for the error
532      * message unnecessarily. For custom revert reasons use {tryMod}.
533      *
534      * Counterpart to Solidity's `%` operator. This function uses a `revert`
535      * opcode (which leaves remaining gas untouched) while Solidity uses an
536      * invalid opcode to revert (consuming all remaining gas).
537      *
538      * Requirements:
539      *
540      * - The divisor cannot be zero.
541      */
542     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
543         require(b > 0, errorMessage);
544         return a % b;
545     }
546 }
547 
548 
549 // File @openzeppelin/contracts/utils/Address.sol@v3.4.2
550 
551 // SPDX-License-Identifier: MIT
552 
553 pragma solidity >=0.6.2 <0.8.0;
554 
555 /**
556  * @dev Collection of functions related to the address type
557  */
558 library Address {
559     /**
560      * @dev Returns true if `account` is a contract.
561      *
562      * [IMPORTANT]
563      * ====
564      * It is unsafe to assume that an address for which this function returns
565      * false is an externally-owned account (EOA) and not a contract.
566      *
567      * Among others, `isContract` will return false for the following
568      * types of addresses:
569      *
570      *  - an externally-owned account
571      *  - a contract in construction
572      *  - an address where a contract will be created
573      *  - an address where a contract lived, but was destroyed
574      * ====
575      */
576     function isContract(address account) internal view returns (bool) {
577         // This method relies on extcodesize, which returns 0 for contracts in
578         // construction, since the code is only stored at the end of the
579         // constructor execution.
580 
581         uint256 size;
582         // solhint-disable-next-line no-inline-assembly
583         assembly { size := extcodesize(account) }
584         return size > 0;
585     }
586 
587     /**
588      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
589      * `recipient`, forwarding all available gas and reverting on errors.
590      *
591      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
592      * of certain opcodes, possibly making contracts go over the 2300 gas limit
593      * imposed by `transfer`, making them unable to receive funds via
594      * `transfer`. {sendValue} removes this limitation.
595      *
596      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
597      *
598      * IMPORTANT: because control is transferred to `recipient`, care must be
599      * taken to not create reentrancy vulnerabilities. Consider using
600      * {ReentrancyGuard} or the
601      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
602      */
603     function sendValue(address payable recipient, uint256 amount) internal {
604         require(address(this).balance >= amount, "Address: insufficient balance");
605 
606         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
607         (bool success, ) = recipient.call{ value: amount }("");
608         require(success, "Address: unable to send value, recipient may have reverted");
609     }
610 
611     /**
612      * @dev Performs a Solidity function call using a low level `call`. A
613      * plain`call` is an unsafe replacement for a function call: use this
614      * function instead.
615      *
616      * If `target` reverts with a revert reason, it is bubbled up by this
617      * function (like regular Solidity function calls).
618      *
619      * Returns the raw returned data. To convert to the expected return value,
620      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
621      *
622      * Requirements:
623      *
624      * - `target` must be a contract.
625      * - calling `target` with `data` must not revert.
626      *
627      * _Available since v3.1._
628      */
629     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
630       return functionCall(target, data, "Address: low-level call failed");
631     }
632 
633     /**
634      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
635      * `errorMessage` as a fallback revert reason when `target` reverts.
636      *
637      * _Available since v3.1._
638      */
639     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
640         return functionCallWithValue(target, data, 0, errorMessage);
641     }
642 
643     /**
644      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
645      * but also transferring `value` wei to `target`.
646      *
647      * Requirements:
648      *
649      * - the calling contract must have an ETH balance of at least `value`.
650      * - the called Solidity function must be `payable`.
651      *
652      * _Available since v3.1._
653      */
654     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
655         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
656     }
657 
658     /**
659      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
660      * with `errorMessage` as a fallback revert reason when `target` reverts.
661      *
662      * _Available since v3.1._
663      */
664     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
665         require(address(this).balance >= value, "Address: insufficient balance for call");
666         require(isContract(target), "Address: call to non-contract");
667 
668         // solhint-disable-next-line avoid-low-level-calls
669         (bool success, bytes memory returndata) = target.call{ value: value }(data);
670         return _verifyCallResult(success, returndata, errorMessage);
671     }
672 
673     /**
674      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
675      * but performing a static call.
676      *
677      * _Available since v3.3._
678      */
679     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
680         return functionStaticCall(target, data, "Address: low-level static call failed");
681     }
682 
683     /**
684      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
685      * but performing a static call.
686      *
687      * _Available since v3.3._
688      */
689     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
690         require(isContract(target), "Address: static call to non-contract");
691 
692         // solhint-disable-next-line avoid-low-level-calls
693         (bool success, bytes memory returndata) = target.staticcall(data);
694         return _verifyCallResult(success, returndata, errorMessage);
695     }
696 
697     /**
698      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
699      * but performing a delegate call.
700      *
701      * _Available since v3.4._
702      */
703     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
704         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
705     }
706 
707     /**
708      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
709      * but performing a delegate call.
710      *
711      * _Available since v3.4._
712      */
713     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
714         require(isContract(target), "Address: delegate call to non-contract");
715 
716         // solhint-disable-next-line avoid-low-level-calls
717         (bool success, bytes memory returndata) = target.delegatecall(data);
718         return _verifyCallResult(success, returndata, errorMessage);
719     }
720 
721     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
722         if (success) {
723             return returndata;
724         } else {
725             // Look for revert reason and bubble it up if present
726             if (returndata.length > 0) {
727                 // The easiest way to bubble the revert reason is using memory via assembly
728 
729                 // solhint-disable-next-line no-inline-assembly
730                 assembly {
731                     let returndata_size := mload(returndata)
732                     revert(add(32, returndata), returndata_size)
733                 }
734             } else {
735                 revert(errorMessage);
736             }
737         }
738     }
739 }
740 
741 
742 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.4.2
743 
744 // SPDX-License-Identifier: MIT
745 
746 pragma solidity >=0.6.0 <0.8.0;
747 
748 /**
749  * @dev Library for managing
750  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
751  * types.
752  *
753  * Sets have the following properties:
754  *
755  * - Elements are added, removed, and checked for existence in constant time
756  * (O(1)).
757  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
758  *
759  * ```
760  * contract Example {
761  *     // Add the library methods
762  *     using EnumerableSet for EnumerableSet.AddressSet;
763  *
764  *     // Declare a set state variable
765  *     EnumerableSet.AddressSet private mySet;
766  * }
767  * ```
768  *
769  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
770  * and `uint256` (`UintSet`) are supported.
771  */
772 library EnumerableSet {
773     // To implement this library for multiple types with as little code
774     // repetition as possible, we write it in terms of a generic Set type with
775     // bytes32 values.
776     // The Set implementation uses private functions, and user-facing
777     // implementations (such as AddressSet) are just wrappers around the
778     // underlying Set.
779     // This means that we can only create new EnumerableSets for types that fit
780     // in bytes32.
781 
782     struct Set {
783         // Storage of set values
784         bytes32[] _values;
785 
786         // Position of the value in the `values` array, plus 1 because index 0
787         // means a value is not in the set.
788         mapping (bytes32 => uint256) _indexes;
789     }
790 
791     /**
792      * @dev Add a value to a set. O(1).
793      *
794      * Returns true if the value was added to the set, that is if it was not
795      * already present.
796      */
797     function _add(Set storage set, bytes32 value) private returns (bool) {
798         if (!_contains(set, value)) {
799             set._values.push(value);
800             // The value is stored at length-1, but we add 1 to all indexes
801             // and use 0 as a sentinel value
802             set._indexes[value] = set._values.length;
803             return true;
804         } else {
805             return false;
806         }
807     }
808 
809     /**
810      * @dev Removes a value from a set. O(1).
811      *
812      * Returns true if the value was removed from the set, that is if it was
813      * present.
814      */
815     function _remove(Set storage set, bytes32 value) private returns (bool) {
816         // We read and store the value's index to prevent multiple reads from the same storage slot
817         uint256 valueIndex = set._indexes[value];
818 
819         if (valueIndex != 0) { // Equivalent to contains(set, value)
820             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
821             // the array, and then remove the last element (sometimes called as 'swap and pop').
822             // This modifies the order of the array, as noted in {at}.
823 
824             uint256 toDeleteIndex = valueIndex - 1;
825             uint256 lastIndex = set._values.length - 1;
826 
827             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
828             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
829 
830             bytes32 lastvalue = set._values[lastIndex];
831 
832             // Move the last value to the index where the value to delete is
833             set._values[toDeleteIndex] = lastvalue;
834             // Update the index for the moved value
835             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
836 
837             // Delete the slot where the moved value was stored
838             set._values.pop();
839 
840             // Delete the index for the deleted slot
841             delete set._indexes[value];
842 
843             return true;
844         } else {
845             return false;
846         }
847     }
848 
849     /**
850      * @dev Returns true if the value is in the set. O(1).
851      */
852     function _contains(Set storage set, bytes32 value) private view returns (bool) {
853         return set._indexes[value] != 0;
854     }
855 
856     /**
857      * @dev Returns the number of values on the set. O(1).
858      */
859     function _length(Set storage set) private view returns (uint256) {
860         return set._values.length;
861     }
862 
863    /**
864     * @dev Returns the value stored at position `index` in the set. O(1).
865     *
866     * Note that there are no guarantees on the ordering of values inside the
867     * array, and it may change when more values are added or removed.
868     *
869     * Requirements:
870     *
871     * - `index` must be strictly less than {length}.
872     */
873     function _at(Set storage set, uint256 index) private view returns (bytes32) {
874         require(set._values.length > index, "EnumerableSet: index out of bounds");
875         return set._values[index];
876     }
877 
878     // Bytes32Set
879 
880     struct Bytes32Set {
881         Set _inner;
882     }
883 
884     /**
885      * @dev Add a value to a set. O(1).
886      *
887      * Returns true if the value was added to the set, that is if it was not
888      * already present.
889      */
890     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
891         return _add(set._inner, value);
892     }
893 
894     /**
895      * @dev Removes a value from a set. O(1).
896      *
897      * Returns true if the value was removed from the set, that is if it was
898      * present.
899      */
900     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
901         return _remove(set._inner, value);
902     }
903 
904     /**
905      * @dev Returns true if the value is in the set. O(1).
906      */
907     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
908         return _contains(set._inner, value);
909     }
910 
911     /**
912      * @dev Returns the number of values in the set. O(1).
913      */
914     function length(Bytes32Set storage set) internal view returns (uint256) {
915         return _length(set._inner);
916     }
917 
918    /**
919     * @dev Returns the value stored at position `index` in the set. O(1).
920     *
921     * Note that there are no guarantees on the ordering of values inside the
922     * array, and it may change when more values are added or removed.
923     *
924     * Requirements:
925     *
926     * - `index` must be strictly less than {length}.
927     */
928     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
929         return _at(set._inner, index);
930     }
931 
932     // AddressSet
933 
934     struct AddressSet {
935         Set _inner;
936     }
937 
938     /**
939      * @dev Add a value to a set. O(1).
940      *
941      * Returns true if the value was added to the set, that is if it was not
942      * already present.
943      */
944     function add(AddressSet storage set, address value) internal returns (bool) {
945         return _add(set._inner, bytes32(uint256(uint160(value))));
946     }
947 
948     /**
949      * @dev Removes a value from a set. O(1).
950      *
951      * Returns true if the value was removed from the set, that is if it was
952      * present.
953      */
954     function remove(AddressSet storage set, address value) internal returns (bool) {
955         return _remove(set._inner, bytes32(uint256(uint160(value))));
956     }
957 
958     /**
959      * @dev Returns true if the value is in the set. O(1).
960      */
961     function contains(AddressSet storage set, address value) internal view returns (bool) {
962         return _contains(set._inner, bytes32(uint256(uint160(value))));
963     }
964 
965     /**
966      * @dev Returns the number of values in the set. O(1).
967      */
968     function length(AddressSet storage set) internal view returns (uint256) {
969         return _length(set._inner);
970     }
971 
972    /**
973     * @dev Returns the value stored at position `index` in the set. O(1).
974     *
975     * Note that there are no guarantees on the ordering of values inside the
976     * array, and it may change when more values are added or removed.
977     *
978     * Requirements:
979     *
980     * - `index` must be strictly less than {length}.
981     */
982     function at(AddressSet storage set, uint256 index) internal view returns (address) {
983         return address(uint160(uint256(_at(set._inner, index))));
984     }
985 
986 
987     // UintSet
988 
989     struct UintSet {
990         Set _inner;
991     }
992 
993     /**
994      * @dev Add a value to a set. O(1).
995      *
996      * Returns true if the value was added to the set, that is if it was not
997      * already present.
998      */
999     function add(UintSet storage set, uint256 value) internal returns (bool) {
1000         return _add(set._inner, bytes32(value));
1001     }
1002 
1003     /**
1004      * @dev Removes a value from a set. O(1).
1005      *
1006      * Returns true if the value was removed from the set, that is if it was
1007      * present.
1008      */
1009     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1010         return _remove(set._inner, bytes32(value));
1011     }
1012 
1013     /**
1014      * @dev Returns true if the value is in the set. O(1).
1015      */
1016     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1017         return _contains(set._inner, bytes32(value));
1018     }
1019 
1020     /**
1021      * @dev Returns the number of values on the set. O(1).
1022      */
1023     function length(UintSet storage set) internal view returns (uint256) {
1024         return _length(set._inner);
1025     }
1026 
1027    /**
1028     * @dev Returns the value stored at position `index` in the set. O(1).
1029     *
1030     * Note that there are no guarantees on the ordering of values inside the
1031     * array, and it may change when more values are added or removed.
1032     *
1033     * Requirements:
1034     *
1035     * - `index` must be strictly less than {length}.
1036     */
1037     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1038         return uint256(_at(set._inner, index));
1039     }
1040 }
1041 
1042 
1043 // File @openzeppelin/contracts/utils/EnumerableMap.sol@v3.4.2
1044 
1045 // SPDX-License-Identifier: MIT
1046 
1047 pragma solidity >=0.6.0 <0.8.0;
1048 
1049 /**
1050  * @dev Library for managing an enumerable variant of Solidity's
1051  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1052  * type.
1053  *
1054  * Maps have the following properties:
1055  *
1056  * - Entries are added, removed, and checked for existence in constant time
1057  * (O(1)).
1058  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1059  *
1060  * ```
1061  * contract Example {
1062  *     // Add the library methods
1063  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1064  *
1065  *     // Declare a set state variable
1066  *     EnumerableMap.UintToAddressMap private myMap;
1067  * }
1068  * ```
1069  *
1070  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1071  * supported.
1072  */
1073 library EnumerableMap {
1074     // To implement this library for multiple types with as little code
1075     // repetition as possible, we write it in terms of a generic Map type with
1076     // bytes32 keys and values.
1077     // The Map implementation uses private functions, and user-facing
1078     // implementations (such as Uint256ToAddressMap) are just wrappers around
1079     // the underlying Map.
1080     // This means that we can only create new EnumerableMaps for types that fit
1081     // in bytes32.
1082 
1083     struct MapEntry {
1084         bytes32 _key;
1085         bytes32 _value;
1086     }
1087 
1088     struct Map {
1089         // Storage of map keys and values
1090         MapEntry[] _entries;
1091 
1092         // Position of the entry defined by a key in the `entries` array, plus 1
1093         // because index 0 means a key is not in the map.
1094         mapping (bytes32 => uint256) _indexes;
1095     }
1096 
1097     /**
1098      * @dev Adds a key-value pair to a map, or updates the value for an existing
1099      * key. O(1).
1100      *
1101      * Returns true if the key was added to the map, that is if it was not
1102      * already present.
1103      */
1104     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1105         // We read and store the key's index to prevent multiple reads from the same storage slot
1106         uint256 keyIndex = map._indexes[key];
1107 
1108         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1109             map._entries.push(MapEntry({ _key: key, _value: value }));
1110             // The entry is stored at length-1, but we add 1 to all indexes
1111             // and use 0 as a sentinel value
1112             map._indexes[key] = map._entries.length;
1113             return true;
1114         } else {
1115             map._entries[keyIndex - 1]._value = value;
1116             return false;
1117         }
1118     }
1119 
1120     /**
1121      * @dev Removes a key-value pair from a map. O(1).
1122      *
1123      * Returns true if the key was removed from the map, that is if it was present.
1124      */
1125     function _remove(Map storage map, bytes32 key) private returns (bool) {
1126         // We read and store the key's index to prevent multiple reads from the same storage slot
1127         uint256 keyIndex = map._indexes[key];
1128 
1129         if (keyIndex != 0) { // Equivalent to contains(map, key)
1130             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1131             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1132             // This modifies the order of the array, as noted in {at}.
1133 
1134             uint256 toDeleteIndex = keyIndex - 1;
1135             uint256 lastIndex = map._entries.length - 1;
1136 
1137             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1138             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1139 
1140             MapEntry storage lastEntry = map._entries[lastIndex];
1141 
1142             // Move the last entry to the index where the entry to delete is
1143             map._entries[toDeleteIndex] = lastEntry;
1144             // Update the index for the moved entry
1145             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1146 
1147             // Delete the slot where the moved entry was stored
1148             map._entries.pop();
1149 
1150             // Delete the index for the deleted slot
1151             delete map._indexes[key];
1152 
1153             return true;
1154         } else {
1155             return false;
1156         }
1157     }
1158 
1159     /**
1160      * @dev Returns true if the key is in the map. O(1).
1161      */
1162     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1163         return map._indexes[key] != 0;
1164     }
1165 
1166     /**
1167      * @dev Returns the number of key-value pairs in the map. O(1).
1168      */
1169     function _length(Map storage map) private view returns (uint256) {
1170         return map._entries.length;
1171     }
1172 
1173    /**
1174     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1175     *
1176     * Note that there are no guarantees on the ordering of entries inside the
1177     * array, and it may change when more entries are added or removed.
1178     *
1179     * Requirements:
1180     *
1181     * - `index` must be strictly less than {length}.
1182     */
1183     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1184         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1185 
1186         MapEntry storage entry = map._entries[index];
1187         return (entry._key, entry._value);
1188     }
1189 
1190     /**
1191      * @dev Tries to returns the value associated with `key`.  O(1).
1192      * Does not revert if `key` is not in the map.
1193      */
1194     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1195         uint256 keyIndex = map._indexes[key];
1196         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1197         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1198     }
1199 
1200     /**
1201      * @dev Returns the value associated with `key`.  O(1).
1202      *
1203      * Requirements:
1204      *
1205      * - `key` must be in the map.
1206      */
1207     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1208         uint256 keyIndex = map._indexes[key];
1209         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1210         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1211     }
1212 
1213     /**
1214      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1215      *
1216      * CAUTION: This function is deprecated because it requires allocating memory for the error
1217      * message unnecessarily. For custom revert reasons use {_tryGet}.
1218      */
1219     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1220         uint256 keyIndex = map._indexes[key];
1221         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1222         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1223     }
1224 
1225     // UintToAddressMap
1226 
1227     struct UintToAddressMap {
1228         Map _inner;
1229     }
1230 
1231     /**
1232      * @dev Adds a key-value pair to a map, or updates the value for an existing
1233      * key. O(1).
1234      *
1235      * Returns true if the key was added to the map, that is if it was not
1236      * already present.
1237      */
1238     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1239         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1240     }
1241 
1242     /**
1243      * @dev Removes a value from a set. O(1).
1244      *
1245      * Returns true if the key was removed from the map, that is if it was present.
1246      */
1247     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1248         return _remove(map._inner, bytes32(key));
1249     }
1250 
1251     /**
1252      * @dev Returns true if the key is in the map. O(1).
1253      */
1254     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1255         return _contains(map._inner, bytes32(key));
1256     }
1257 
1258     /**
1259      * @dev Returns the number of elements in the map. O(1).
1260      */
1261     function length(UintToAddressMap storage map) internal view returns (uint256) {
1262         return _length(map._inner);
1263     }
1264 
1265    /**
1266     * @dev Returns the element stored at position `index` in the set. O(1).
1267     * Note that there are no guarantees on the ordering of values inside the
1268     * array, and it may change when more values are added or removed.
1269     *
1270     * Requirements:
1271     *
1272     * - `index` must be strictly less than {length}.
1273     */
1274     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1275         (bytes32 key, bytes32 value) = _at(map._inner, index);
1276         return (uint256(key), address(uint160(uint256(value))));
1277     }
1278 
1279     /**
1280      * @dev Tries to returns the value associated with `key`.  O(1).
1281      * Does not revert if `key` is not in the map.
1282      *
1283      * _Available since v3.4._
1284      */
1285     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1286         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1287         return (success, address(uint160(uint256(value))));
1288     }
1289 
1290     /**
1291      * @dev Returns the value associated with `key`.  O(1).
1292      *
1293      * Requirements:
1294      *
1295      * - `key` must be in the map.
1296      */
1297     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1298         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1299     }
1300 
1301     /**
1302      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1303      *
1304      * CAUTION: This function is deprecated because it requires allocating memory for the error
1305      * message unnecessarily. For custom revert reasons use {tryGet}.
1306      */
1307     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1308         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1309     }
1310 }
1311 
1312 
1313 // File @openzeppelin/contracts/utils/Strings.sol@v3.4.2
1314 
1315 // SPDX-License-Identifier: MIT
1316 
1317 pragma solidity >=0.6.0 <0.8.0;
1318 
1319 /**
1320  * @dev String operations.
1321  */
1322 library Strings {
1323     /**
1324      * @dev Converts a `uint256` to its ASCII `string` representation.
1325      */
1326     function toString(uint256 value) internal pure returns (string memory) {
1327         // Inspired by OraclizeAPI's implementation - MIT licence
1328         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1329 
1330         if (value == 0) {
1331             return "0";
1332         }
1333         uint256 temp = value;
1334         uint256 digits;
1335         while (temp != 0) {
1336             digits++;
1337             temp /= 10;
1338         }
1339         bytes memory buffer = new bytes(digits);
1340         uint256 index = digits - 1;
1341         temp = value;
1342         while (temp != 0) {
1343             buffer[index--] = bytes1(uint8(48 + temp % 10));
1344             temp /= 10;
1345         }
1346         return string(buffer);
1347     }
1348 }
1349 
1350 
1351 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v3.4.2
1352 
1353 // SPDX-License-Identifier: MIT
1354 
1355 pragma solidity >=0.6.0 <0.8.0;
1356 
1357 
1358 
1359 
1360 
1361 
1362 
1363 
1364 
1365 
1366 
1367 /**
1368  * @title ERC721 Non-Fungible Token Standard basic implementation
1369  * @dev see https://eips.ethereum.org/EIPS/eip-721
1370  */
1371 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1372     using SafeMath for uint256;
1373     using Address for address;
1374     using EnumerableSet for EnumerableSet.UintSet;
1375     using EnumerableMap for EnumerableMap.UintToAddressMap;
1376     using Strings for uint256;
1377 
1378     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1379     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1380     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1381 
1382     // Mapping from holder address to their (enumerable) set of owned tokens
1383     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1384 
1385     // Enumerable mapping from token ids to their owners
1386     EnumerableMap.UintToAddressMap private _tokenOwners;
1387 
1388     // Mapping from token ID to approved address
1389     mapping (uint256 => address) private _tokenApprovals;
1390 
1391     // Mapping from owner to operator approvals
1392     mapping (address => mapping (address => bool)) private _operatorApprovals;
1393 
1394     // Token name
1395     string private _name;
1396 
1397     // Token symbol
1398     string private _symbol;
1399 
1400     // Optional mapping for token URIs
1401     mapping (uint256 => string) private _tokenURIs;
1402 
1403     // Base URI
1404     string private _baseURI;
1405 
1406     /*
1407      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1408      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1409      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1410      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1411      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1412      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1413      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1414      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1415      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1416      *
1417      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1418      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1419      */
1420     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1421 
1422     /*
1423      *     bytes4(keccak256('name()')) == 0x06fdde03
1424      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1425      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1426      *
1427      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1428      */
1429     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1430 
1431     /*
1432      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1433      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1434      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1435      *
1436      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1437      */
1438     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1439 
1440     /**
1441      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1442      */
1443     constructor (string memory name_, string memory symbol_) public {
1444         _name = name_;
1445         _symbol = symbol_;
1446 
1447         // register the supported interfaces to conform to ERC721 via ERC165
1448         _registerInterface(_INTERFACE_ID_ERC721);
1449         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1450         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1451     }
1452 
1453     /**
1454      * @dev See {IERC721-balanceOf}.
1455      */
1456     function balanceOf(address owner) public view virtual override returns (uint256) {
1457         require(owner != address(0), "ERC721: balance query for the zero address");
1458         return _holderTokens[owner].length();
1459     }
1460 
1461     /**
1462      * @dev See {IERC721-ownerOf}.
1463      */
1464     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1465         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1466     }
1467 
1468     /**
1469      * @dev See {IERC721Metadata-name}.
1470      */
1471     function name() public view virtual override returns (string memory) {
1472         return _name;
1473     }
1474 
1475     /**
1476      * @dev See {IERC721Metadata-symbol}.
1477      */
1478     function symbol() public view virtual override returns (string memory) {
1479         return _symbol;
1480     }
1481 
1482     /**
1483      * @dev See {IERC721Metadata-tokenURI}.
1484      */
1485     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1486         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1487 
1488         string memory _tokenURI = _tokenURIs[tokenId];
1489         string memory base = baseURI();
1490 
1491         // If there is no base URI, return the token URI.
1492         if (bytes(base).length == 0) {
1493             return _tokenURI;
1494         }
1495         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1496         if (bytes(_tokenURI).length > 0) {
1497             return string(abi.encodePacked(base, _tokenURI));
1498         }
1499         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1500         return string(abi.encodePacked(base, tokenId.toString()));
1501     }
1502 
1503     /**
1504     * @dev Returns the base URI set via {_setBaseURI}. This will be
1505     * automatically added as a prefix in {tokenURI} to each token's URI, or
1506     * to the token ID if no specific URI is set for that token ID.
1507     */
1508     function baseURI() public view virtual returns (string memory) {
1509         return _baseURI;
1510     }
1511 
1512     /**
1513      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1514      */
1515     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1516         return _holderTokens[owner].at(index);
1517     }
1518 
1519     /**
1520      * @dev See {IERC721Enumerable-totalSupply}.
1521      */
1522     function totalSupply() public view virtual override returns (uint256) {
1523         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1524         return _tokenOwners.length();
1525     }
1526 
1527     /**
1528      * @dev See {IERC721Enumerable-tokenByIndex}.
1529      */
1530     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1531         (uint256 tokenId, ) = _tokenOwners.at(index);
1532         return tokenId;
1533     }
1534 
1535     /**
1536      * @dev See {IERC721-approve}.
1537      */
1538     function approve(address to, uint256 tokenId) public virtual override {
1539         address owner = ERC721.ownerOf(tokenId);
1540         require(to != owner, "ERC721: approval to current owner");
1541 
1542         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1543             "ERC721: approve caller is not owner nor approved for all"
1544         );
1545 
1546         _approve(to, tokenId);
1547     }
1548 
1549     /**
1550      * @dev See {IERC721-getApproved}.
1551      */
1552     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1553         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1554 
1555         return _tokenApprovals[tokenId];
1556     }
1557 
1558     /**
1559      * @dev See {IERC721-setApprovalForAll}.
1560      */
1561     function setApprovalForAll(address operator, bool approved) public virtual override {
1562         require(operator != _msgSender(), "ERC721: approve to caller");
1563 
1564         _operatorApprovals[_msgSender()][operator] = approved;
1565         emit ApprovalForAll(_msgSender(), operator, approved);
1566     }
1567 
1568     /**
1569      * @dev See {IERC721-isApprovedForAll}.
1570      */
1571     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1572         return _operatorApprovals[owner][operator];
1573     }
1574 
1575     /**
1576      * @dev See {IERC721-transferFrom}.
1577      */
1578     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1579         //solhint-disable-next-line max-line-length
1580         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1581 
1582         _transfer(from, to, tokenId);
1583     }
1584 
1585     /**
1586      * @dev See {IERC721-safeTransferFrom}.
1587      */
1588     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1589         safeTransferFrom(from, to, tokenId, "");
1590     }
1591 
1592     /**
1593      * @dev See {IERC721-safeTransferFrom}.
1594      */
1595     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1596         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1597         _safeTransfer(from, to, tokenId, _data);
1598     }
1599 
1600     /**
1601      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1602      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1603      *
1604      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1605      *
1606      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1607      * implement alternative mechanisms to perform token transfer, such as signature-based.
1608      *
1609      * Requirements:
1610      *
1611      * - `from` cannot be the zero address.
1612      * - `to` cannot be the zero address.
1613      * - `tokenId` token must exist and be owned by `from`.
1614      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1615      *
1616      * Emits a {Transfer} event.
1617      */
1618     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1619         _transfer(from, to, tokenId);
1620         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1621     }
1622 
1623     /**
1624      * @dev Returns whether `tokenId` exists.
1625      *
1626      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1627      *
1628      * Tokens start existing when they are minted (`_mint`),
1629      * and stop existing when they are burned (`_burn`).
1630      */
1631     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1632         return _tokenOwners.contains(tokenId);
1633     }
1634 
1635     /**
1636      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1637      *
1638      * Requirements:
1639      *
1640      * - `tokenId` must exist.
1641      */
1642     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1643         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1644         address owner = ERC721.ownerOf(tokenId);
1645         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1646     }
1647 
1648     /**
1649      * @dev Safely mints `tokenId` and transfers it to `to`.
1650      *
1651      * Requirements:
1652      d*
1653      * - `tokenId` must not exist.
1654      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1655      *
1656      * Emits a {Transfer} event.
1657      */
1658     function _safeMint(address to, uint256 tokenId) internal virtual {
1659         _safeMint(to, tokenId, "");
1660     }
1661 
1662     /**
1663      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1664      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1665      */
1666     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1667         _mint(to, tokenId);
1668         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1669     }
1670 
1671     /**
1672      * @dev Mints `tokenId` and transfers it to `to`.
1673      *
1674      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1675      *
1676      * Requirements:
1677      *
1678      * - `tokenId` must not exist.
1679      * - `to` cannot be the zero address.
1680      *
1681      * Emits a {Transfer} event.
1682      */
1683     function _mint(address to, uint256 tokenId) internal virtual {
1684         require(to != address(0), "ERC721: mint to the zero address");
1685         require(!_exists(tokenId), "ERC721: token already minted");
1686 
1687         _beforeTokenTransfer(address(0), to, tokenId);
1688 
1689         _holderTokens[to].add(tokenId);
1690 
1691         _tokenOwners.set(tokenId, to);
1692 
1693         emit Transfer(address(0), to, tokenId);
1694     }
1695 
1696     /**
1697      * @dev Destroys `tokenId`.
1698      * The approval is cleared when the token is burned.
1699      *
1700      * Requirements:
1701      *
1702      * - `tokenId` must exist.
1703      *
1704      * Emits a {Transfer} event.
1705      */
1706     function _burn(uint256 tokenId) internal virtual {
1707         address owner = ERC721.ownerOf(tokenId); // internal owner
1708 
1709         _beforeTokenTransfer(owner, address(0), tokenId);
1710 
1711         // Clear approvals
1712         _approve(address(0), tokenId);
1713 
1714         // Clear metadata (if any)
1715         if (bytes(_tokenURIs[tokenId]).length != 0) {
1716             delete _tokenURIs[tokenId];
1717         }
1718 
1719         _holderTokens[owner].remove(tokenId);
1720 
1721         _tokenOwners.remove(tokenId);
1722 
1723         emit Transfer(owner, address(0), tokenId);
1724     }
1725 
1726     /**
1727      * @dev Transfers `tokenId` from `from` to `to`.
1728      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1729      *
1730      * Requirements:
1731      *
1732      * - `to` cannot be the zero address.
1733      * - `tokenId` token must be owned by `from`.
1734      *
1735      * Emits a {Transfer} event.
1736      */
1737     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1738         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1739         require(to != address(0), "ERC721: transfer to the zero address");
1740 
1741         _beforeTokenTransfer(from, to, tokenId);
1742 
1743         // Clear approvals from the previous owner
1744         _approve(address(0), tokenId);
1745 
1746         _holderTokens[from].remove(tokenId);
1747         _holderTokens[to].add(tokenId);
1748 
1749         _tokenOwners.set(tokenId, to);
1750 
1751         emit Transfer(from, to, tokenId);
1752     }
1753 
1754     /**
1755      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1756      *
1757      * Requirements:
1758      *
1759      * - `tokenId` must exist.
1760      */
1761     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1762         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1763         _tokenURIs[tokenId] = _tokenURI;
1764     }
1765 
1766     /**
1767      * @dev Internal function to set the base URI for all token IDs. It is
1768      * automatically added as a prefix to the value returned in {tokenURI},
1769      * or to the token ID if {tokenURI} is empty.
1770      */
1771     function _setBaseURI(string memory baseURI_) internal virtual {
1772         _baseURI = baseURI_;
1773     }
1774 
1775     /**
1776      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1777      * The call is not executed if the target address is not a contract.
1778      *
1779      * @param from address representing the previous owner of the given token ID
1780      * @param to target address that will receive the tokens
1781      * @param tokenId uint256 ID of the token to be transferred
1782      * @param _data bytes optional data to send along with the call
1783      * @return bool whether the call correctly returned the expected magic value
1784      */
1785     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1786         private returns (bool)
1787     {
1788         if (!to.isContract()) {
1789             return true;
1790         }
1791         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1792             IERC721Receiver(to).onERC721Received.selector,
1793             _msgSender(),
1794             from,
1795             tokenId,
1796             _data
1797         ), "ERC721: transfer to non ERC721Receiver implementer");
1798         bytes4 retval = abi.decode(returndata, (bytes4));
1799         return (retval == _ERC721_RECEIVED);
1800     }
1801 
1802     /**
1803      * @dev Approve `to` to operate on `tokenId`
1804      *
1805      * Emits an {Approval} event.
1806      */
1807     function _approve(address to, uint256 tokenId) internal virtual {
1808         _tokenApprovals[tokenId] = to;
1809         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1810     }
1811 
1812     /**
1813      * @dev Hook that is called before any token transfer. This includes minting
1814      * and burning.
1815      *
1816      * Calling conditions:
1817      *
1818      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1819      * transferred to `to`.
1820      * - When `from` is zero, `tokenId` will be minted for `to`.
1821      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1822      * - `from` cannot be the zero address.
1823      * - `to` cannot be the zero address.
1824      *
1825      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1826      */
1827     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1828 }
1829 
1830 
1831 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.2
1832 
1833 // SPDX-License-Identifier: MIT
1834 
1835 pragma solidity >=0.6.0 <0.8.0;
1836 
1837 /**
1838  * @dev Contract module which provides a basic access control mechanism, where
1839  * there is an account (an owner) that can be granted exclusive access to
1840  * specific functions.
1841  *
1842  * By default, the owner account will be the one that deploys the contract. This
1843  * can later be changed with {transferOwnership}.
1844  *
1845  * This module is used through inheritance. It will make available the modifier
1846  * `onlyOwner`, which can be applied to your functions to restrict their use to
1847  * the owner.
1848  */
1849 abstract contract Ownable is Context {
1850     address private _owner;
1851 
1852     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1853 
1854     /**
1855      * @dev Initializes the contract setting the deployer as the initial owner.
1856      */
1857     constructor () internal {
1858         address msgSender = _msgSender();
1859         _owner = msgSender;
1860         emit OwnershipTransferred(address(0), msgSender);
1861     }
1862 
1863     /**
1864      * @dev Returns the address of the current owner.
1865      */
1866     function owner() public view virtual returns (address) {
1867         return _owner;
1868     }
1869 
1870     /**
1871      * @dev Throws if called by any account other than the owner.
1872      */
1873     modifier onlyOwner() {
1874         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1875         _;
1876     }
1877 
1878     /**
1879      * @dev Leaves the contract without owner. It will not be possible to call
1880      * `onlyOwner` functions anymore. Can only be called by the current owner.
1881      *
1882      * NOTE: Renouncing ownership will leave the contract without an owner,
1883      * thereby removing any functionality that is only available to the owner.
1884      */
1885     function renounceOwnership() public virtual onlyOwner {
1886         emit OwnershipTransferred(_owner, address(0));
1887         _owner = address(0);
1888     }
1889 
1890     /**
1891      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1892      * Can only be called by the current owner.
1893      */
1894     function transferOwnership(address newOwner) public virtual onlyOwner {
1895         require(newOwner != address(0), "Ownable: new owner is the zero address");
1896         emit OwnershipTransferred(_owner, newOwner);
1897         _owner = newOwner;
1898     }
1899 }
1900 
1901 
1902 // File @openzeppelin/contracts/utils/Counters.sol@v3.4.2
1903 
1904 // SPDX-License-Identifier: MIT
1905 
1906 pragma solidity >=0.6.0 <0.8.0;
1907 
1908 /**
1909  * @title Counters
1910  * @author Matt Condon (@shrugs)
1911  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1912  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1913  *
1914  * Include with `using Counters for Counters.Counter;`
1915  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1916  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1917  * directly accessed.
1918  */
1919 library Counters {
1920     using SafeMath for uint256;
1921 
1922     struct Counter {
1923         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1924         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1925         // this feature: see https://github.com/ethereum/solidity/issues/4637
1926         uint256 _value; // default: 0
1927     }
1928 
1929     function current(Counter storage counter) internal view returns (uint256) {
1930         return counter._value;
1931     }
1932 
1933     function increment(Counter storage counter) internal {
1934         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1935         counter._value += 1;
1936     }
1937 
1938     function decrement(Counter storage counter) internal {
1939         counter._value = counter._value.sub(1);
1940     }
1941 }
1942 
1943 
1944 // File contracts/DarkZodiacCollectible.sol
1945 
1946 // SPDX-License-Identifier: MIT
1947 pragma solidity 0.6.6;
1948 
1949 
1950 
1951 contract DarkZodiacCollectible is ERC721, Ownable {
1952     using Counters for Counters.Counter;
1953     Counters.Counter private _tokenIds;
1954 
1955     using SafeMath for uint256;
1956     string private _tokenBaseURI = "https://meta.darkzodiac.com/";
1957     string public DARKZ_PROVENANCE = "";
1958     
1959     uint256 public constant zodiacPrice = 0.09 ether;
1960 
1961     bool public saleLive = false;
1962     bool public presaleLive = false;
1963     bool public locked;
1964     bool private reserved = false;
1965 
1966     uint256 public publicAmountMinted;
1967     uint256 public privateAmountMinted;
1968 
1969     uint256 public RESERVED_ZODIAC = 50;
1970     uint256 public MAX_ZODIACS = 3876;
1971     uint256 public presalePurchaseLimit = 2;
1972     uint256 public purchaseLimit = 10;
1973 
1974     mapping(address => bool) public presalerList;
1975     mapping(address => uint256) public presalerListPurchases;
1976     
1977 
1978     modifier notLocked {
1979         require(!locked, "Contract metadata methods are locked");
1980         _;
1981     }
1982     
1983     constructor () public ERC721 ("DarkZodiac", "DARKZ"){
1984     }
1985     
1986     function reserveZodiac() public onlyOwner {
1987         require(!reserved, "Already reserved");
1988 
1989         reserved = true;
1990 
1991         uint i;
1992         for (i = 0; i < RESERVED_ZODIAC; i++) {    
1993             _tokenIds.increment();
1994             uint256 newItemId = _tokenIds.current();
1995 
1996             _safeMint(msg.sender, newItemId);
1997         }
1998     }
1999 
2000     function withdraw() public onlyOwner {
2001         uint balance = address(this).balance;
2002         msg.sender.transfer(balance);
2003     }
2004     
2005     /*     
2006     * Set provenance once it's calculated
2007     */
2008     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
2009         DARKZ_PROVENANCE = provenanceHash;
2010     }
2011     
2012     function setBaseURI(string calldata URI) external onlyOwner notLocked {
2013         _tokenBaseURI = URI;
2014     }
2015     
2016     function flipSaleState() public onlyOwner {
2017         saleLive = !saleLive;
2018     }
2019     
2020     function flipPresaleStatus() public onlyOwner {
2021         presaleLive = !presaleLive;
2022     }
2023     
2024     // This function is only used for exceptional scenario
2025     function flipReserved() public onlyOwner {
2026         reserved = !reserved;
2027     }
2028 
2029     function mintZodiac(uint256 tokenQuantity) external payable {
2030         require(saleLive, "Sale must be active to mint Zodiac");
2031         require(!presaleLive, "ONLY_PRESALE");
2032         require(zodiacPrice * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
2033         require(_tokenIds.current() + tokenQuantity <= MAX_ZODIACS, "Purchase would exceed max supply of Zodiac");
2034         require(tokenQuantity <= purchaseLimit, "EXCEED_ALLOC");
2035         require(_tokenIds.current() < MAX_ZODIACS, "OUT_OF_STOCK");
2036         
2037         for (uint256 i = 0; i < tokenQuantity; i++) {
2038             publicAmountMinted++;
2039 
2040             _tokenIds.increment();
2041             uint256 newItemId = _tokenIds.current();
2042 
2043             if (newItemId <= MAX_ZODIACS) {
2044                 _safeMint(msg.sender, newItemId);
2045             }
2046         }
2047     }
2048     
2049     function addToPresaleList(address[] calldata entries) external onlyOwner {
2050         for(uint256 i = 0; i < entries.length; i++) {
2051             address entry = entries[i];
2052             require(entry != address(0), "NULL_ADDRESS");
2053 
2054             presalerList[entry] = true;
2055         }   
2056     }
2057 
2058     function removeFromPresaleList(address[] calldata entries) external onlyOwner {
2059         for(uint256 i = 0; i < entries.length; i++) {
2060             address entry = entries[i];
2061             require(entry != address(0), "NULL_ADDRESS");
2062             
2063             presalerList[entry] = false;
2064         }
2065     }
2066     
2067     function presaleBuy(uint256 tokenQuantity) external payable {
2068         require(!saleLive && presaleLive, "PRESALE_CLOSED");
2069         require(presalerList[msg.sender], "NOT_QUALIFIED");
2070         require(_tokenIds.current() + tokenQuantity <= MAX_ZODIACS, "OUT_OF_STOCK");
2071 
2072         require(presalerListPurchases[msg.sender] + tokenQuantity <= presalePurchaseLimit, "EXCEED_ALLOC");
2073         require(zodiacPrice * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
2074         
2075         for (uint256 i = 0; i < tokenQuantity; i++) {
2076             presalerListPurchases[msg.sender]++;
2077             privateAmountMinted++;
2078 
2079             _tokenIds.increment();
2080             uint256 newItemId = _tokenIds.current();
2081 
2082             if (newItemId < MAX_ZODIACS) {
2083                 _safeMint(msg.sender, newItemId);
2084             }
2085         }
2086     }
2087     
2088     // Owner functions for enabling presale, sale, revealing and setting the provenance hash
2089     function lockMetadata() external onlyOwner {
2090         locked = true;
2091     }
2092 
2093     // View functions
2094     function currentId() external view returns (uint256) {
2095         return _tokenIds.current();
2096     }
2097     
2098     function isPresaler(address addr) external view returns (bool) {
2099         return presalerList[addr];
2100     }
2101     
2102     function presalePurchasedCount(address addr) external view returns (uint256) {
2103         return presalerListPurchases[addr];
2104     }
2105     
2106     function getPresaleStatus() external view returns (bool) {
2107         return presaleLive;
2108     }
2109     
2110     function getSaleStatus() external view returns (bool) {
2111         return saleLive;
2112     }
2113     
2114     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
2115         require(_exists(tokenId), "Cannot query non-existent token");
2116         
2117         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
2118     }
2119 
2120 }
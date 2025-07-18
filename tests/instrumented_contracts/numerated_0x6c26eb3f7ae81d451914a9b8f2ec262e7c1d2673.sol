1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Address.sol
72 
73 
74 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
75 
76 pragma solidity ^0.8.1;
77 
78 /**
79  * @dev Collection of functions related to the address type
80  */
81 library Address {
82     /**
83      * @dev Returns true if `account` is a contract.
84      *
85      * [IMPORTANT]
86      * ====
87      * It is unsafe to assume that an address for which this function returns
88      * false is an externally-owned account (EOA) and not a contract.
89      *
90      * Among others, `isContract` will return false for the following
91      * types of addresses:
92      *
93      *  - an externally-owned account
94      *  - a contract in construction
95      *  - an address where a contract will be created
96      *  - an address where a contract lived, but was destroyed
97      * ====
98      *
99      * [IMPORTANT]
100      * ====
101      * You shouldn't rely on `isContract` to protect against flash loan attacks!
102      *
103      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
104      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
105      * constructor.
106      * ====
107      */
108     function isContract(address account) internal view returns (bool) {
109         // This method relies on extcodesize/address.code.length, which returns 0
110         // for contracts in construction, since the code is only stored at the end
111         // of the constructor execution.
112 
113         return account.code.length > 0;
114     }
115 
116     /**
117      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
118      * `recipient`, forwarding all available gas and reverting on errors.
119      *
120      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
121      * of certain opcodes, possibly making contracts go over the 2300 gas limit
122      * imposed by `transfer`, making them unable to receive funds via
123      * `transfer`. {sendValue} removes this limitation.
124      *
125      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
126      *
127      * IMPORTANT: because control is transferred to `recipient`, care must be
128      * taken to not create reentrancy vulnerabilities. Consider using
129      * {ReentrancyGuard} or the
130      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
131      */
132     function sendValue(address payable recipient, uint256 amount) internal {
133         require(address(this).balance >= amount, "Address: insufficient balance");
134 
135         (bool success, ) = recipient.call{value: amount}("");
136         require(success, "Address: unable to send value, recipient may have reverted");
137     }
138 
139     /**
140      * @dev Performs a Solidity function call using a low level `call`. A
141      * plain `call` is an unsafe replacement for a function call: use this
142      * function instead.
143      *
144      * If `target` reverts with a revert reason, it is bubbled up by this
145      * function (like regular Solidity function calls).
146      *
147      * Returns the raw returned data. To convert to the expected return value,
148      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
149      *
150      * Requirements:
151      *
152      * - `target` must be a contract.
153      * - calling `target` with `data` must not revert.
154      *
155      * _Available since v3.1._
156      */
157     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionCall(target, data, "Address: low-level call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
163      * `errorMessage` as a fallback revert reason when `target` reverts.
164      *
165      * _Available since v3.1._
166      */
167     function functionCall(
168         address target,
169         bytes memory data,
170         string memory errorMessage
171     ) internal returns (bytes memory) {
172         return functionCallWithValue(target, data, 0, errorMessage);
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
177      * but also transferring `value` wei to `target`.
178      *
179      * Requirements:
180      *
181      * - the calling contract must have an ETH balance of at least `value`.
182      * - the called Solidity function must be `payable`.
183      *
184      * _Available since v3.1._
185      */
186     function functionCallWithValue(
187         address target,
188         bytes memory data,
189         uint256 value
190     ) internal returns (bytes memory) {
191         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
196      * with `errorMessage` as a fallback revert reason when `target` reverts.
197      *
198      * _Available since v3.1._
199      */
200     function functionCallWithValue(
201         address target,
202         bytes memory data,
203         uint256 value,
204         string memory errorMessage
205     ) internal returns (bytes memory) {
206         require(address(this).balance >= value, "Address: insufficient balance for call");
207         require(isContract(target), "Address: call to non-contract");
208 
209         (bool success, bytes memory returndata) = target.call{value: value}(data);
210         return verifyCallResult(success, returndata, errorMessage);
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
215      * but performing a static call.
216      *
217      * _Available since v3.3._
218      */
219     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
220         return functionStaticCall(target, data, "Address: low-level static call failed");
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
225      * but performing a static call.
226      *
227      * _Available since v3.3._
228      */
229     function functionStaticCall(
230         address target,
231         bytes memory data,
232         string memory errorMessage
233     ) internal view returns (bytes memory) {
234         require(isContract(target), "Address: static call to non-contract");
235 
236         (bool success, bytes memory returndata) = target.staticcall(data);
237         return verifyCallResult(success, returndata, errorMessage);
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
242      * but performing a delegate call.
243      *
244      * _Available since v3.4._
245      */
246     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
247         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
252      * but performing a delegate call.
253      *
254      * _Available since v3.4._
255      */
256     function functionDelegateCall(
257         address target,
258         bytes memory data,
259         string memory errorMessage
260     ) internal returns (bytes memory) {
261         require(isContract(target), "Address: delegate call to non-contract");
262 
263         (bool success, bytes memory returndata) = target.delegatecall(data);
264         return verifyCallResult(success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
269      * revert reason using the provided one.
270      *
271      * _Available since v4.3._
272      */
273     function verifyCallResult(
274         bool success,
275         bytes memory returndata,
276         string memory errorMessage
277     ) internal pure returns (bytes memory) {
278         if (success) {
279             return returndata;
280         } else {
281             // Look for revert reason and bubble it up if present
282             if (returndata.length > 0) {
283                 // The easiest way to bubble the revert reason is using memory via assembly
284 
285                 assembly {
286                     let returndata_size := mload(returndata)
287                     revert(add(32, returndata), returndata_size)
288                 }
289             } else {
290                 revert(errorMessage);
291             }
292         }
293     }
294 }
295 
296 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
297 
298 
299 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
300 
301 pragma solidity ^0.8.0;
302 
303 /**
304  * @title ERC721 token receiver interface
305  * @dev Interface for any contract that wants to support safeTransfers
306  * from ERC721 asset contracts.
307  */
308 interface IERC721Receiver {
309     /**
310      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
311      * by `operator` from `from`, this function is called.
312      *
313      * It must return its Solidity selector to confirm the token transfer.
314      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
315      *
316      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
317      */
318     function onERC721Received(
319         address operator,
320         address from,
321         uint256 tokenId,
322         bytes calldata data
323     ) external returns (bytes4);
324 }
325 
326 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
327 
328 
329 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
330 
331 pragma solidity ^0.8.0;
332 
333 /**
334  * @dev Interface of the ERC165 standard, as defined in the
335  * https://eips.ethereum.org/EIPS/eip-165[EIP].
336  *
337  * Implementers can declare support of contract interfaces, which can then be
338  * queried by others ({ERC165Checker}).
339  *
340  * For an implementation, see {ERC165}.
341  */
342 interface IERC165 {
343     /**
344      * @dev Returns true if this contract implements the interface defined by
345      * `interfaceId`. See the corresponding
346      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
347      * to learn more about how these ids are created.
348      *
349      * This function call must use less than 30 000 gas.
350      */
351     function supportsInterface(bytes4 interfaceId) external view returns (bool);
352 }
353 
354 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
355 
356 
357 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
358 
359 pragma solidity ^0.8.0;
360 
361 
362 /**
363  * @dev Implementation of the {IERC165} interface.
364  *
365  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
366  * for the additional interface id that will be supported. For example:
367  *
368  * ```solidity
369  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
370  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
371  * }
372  * ```
373  *
374  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
375  */
376 abstract contract ERC165 is IERC165 {
377     /**
378      * @dev See {IERC165-supportsInterface}.
379      */
380     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
381         return interfaceId == type(IERC165).interfaceId;
382     }
383 }
384 
385 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
386 
387 
388 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
389 
390 pragma solidity ^0.8.0;
391 
392 
393 /**
394  * @dev Required interface of an ERC721 compliant contract.
395  */
396 interface IERC721 is IERC165 {
397     /**
398      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
399      */
400     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
401 
402     /**
403      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
404      */
405     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
406 
407     /**
408      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
409      */
410     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
411 
412     /**
413      * @dev Returns the number of tokens in ``owner``'s account.
414      */
415     function balanceOf(address owner) external view returns (uint256 balance);
416 
417     /**
418      * @dev Returns the owner of the `tokenId` token.
419      *
420      * Requirements:
421      *
422      * - `tokenId` must exist.
423      */
424     function ownerOf(uint256 tokenId) external view returns (address owner);
425 
426     /**
427      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
428      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
429      *
430      * Requirements:
431      *
432      * - `from` cannot be the zero address.
433      * - `to` cannot be the zero address.
434      * - `tokenId` token must exist and be owned by `from`.
435      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
436      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
437      *
438      * Emits a {Transfer} event.
439      */
440     function safeTransferFrom(
441         address from,
442         address to,
443         uint256 tokenId
444     ) external;
445 
446     /**
447      * @dev Transfers `tokenId` token from `from` to `to`.
448      *
449      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
450      *
451      * Requirements:
452      *
453      * - `from` cannot be the zero address.
454      * - `to` cannot be the zero address.
455      * - `tokenId` token must be owned by `from`.
456      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
457      *
458      * Emits a {Transfer} event.
459      */
460     function transferFrom(
461         address from,
462         address to,
463         uint256 tokenId
464     ) external;
465 
466     /**
467      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
468      * The approval is cleared when the token is transferred.
469      *
470      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
471      *
472      * Requirements:
473      *
474      * - The caller must own the token or be an approved operator.
475      * - `tokenId` must exist.
476      *
477      * Emits an {Approval} event.
478      */
479     function approve(address to, uint256 tokenId) external;
480 
481     /**
482      * @dev Returns the account approved for `tokenId` token.
483      *
484      * Requirements:
485      *
486      * - `tokenId` must exist.
487      */
488     function getApproved(uint256 tokenId) external view returns (address operator);
489 
490     /**
491      * @dev Approve or remove `operator` as an operator for the caller.
492      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
493      *
494      * Requirements:
495      *
496      * - The `operator` cannot be the caller.
497      *
498      * Emits an {ApprovalForAll} event.
499      */
500     function setApprovalForAll(address operator, bool _approved) external;
501 
502     /**
503      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
504      *
505      * See {setApprovalForAll}
506      */
507     function isApprovedForAll(address owner, address operator) external view returns (bool);
508 
509     /**
510      * @dev Safely transfers `tokenId` token from `from` to `to`.
511      *
512      * Requirements:
513      *
514      * - `from` cannot be the zero address.
515      * - `to` cannot be the zero address.
516      * - `tokenId` token must exist and be owned by `from`.
517      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
518      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
519      *
520      * Emits a {Transfer} event.
521      */
522     function safeTransferFrom(
523         address from,
524         address to,
525         uint256 tokenId,
526         bytes calldata data
527     ) external;
528 }
529 
530 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
531 
532 
533 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 
538 /**
539  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
540  * @dev See https://eips.ethereum.org/EIPS/eip-721
541  */
542 interface IERC721Enumerable is IERC721 {
543     /**
544      * @dev Returns the total amount of tokens stored by the contract.
545      */
546     function totalSupply() external view returns (uint256);
547 
548     /**
549      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
550      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
551      */
552     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
553 
554     /**
555      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
556      * Use along with {totalSupply} to enumerate all tokens.
557      */
558     function tokenByIndex(uint256 index) external view returns (uint256);
559 }
560 
561 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
562 
563 
564 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
565 
566 pragma solidity ^0.8.0;
567 
568 
569 /**
570  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
571  * @dev See https://eips.ethereum.org/EIPS/eip-721
572  */
573 interface IERC721Metadata is IERC721 {
574     /**
575      * @dev Returns the token collection name.
576      */
577     function name() external view returns (string memory);
578 
579     /**
580      * @dev Returns the token collection symbol.
581      */
582     function symbol() external view returns (string memory);
583 
584     /**
585      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
586      */
587     function tokenURI(uint256 tokenId) external view returns (string memory);
588 }
589 
590 // File: @openzeppelin/contracts/utils/Context.sol
591 
592 
593 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
594 
595 pragma solidity ^0.8.0;
596 
597 /**
598  * @dev Provides information about the current execution context, including the
599  * sender of the transaction and its data. While these are generally available
600  * via msg.sender and msg.data, they should not be accessed in such a direct
601  * manner, since when dealing with meta-transactions the account sending and
602  * paying for execution may not be the actual sender (as far as an application
603  * is concerned).
604  *
605  * This contract is only required for intermediate, library-like contracts.
606  */
607 abstract contract Context {
608     function _msgSender() internal view virtual returns (address) {
609         return msg.sender;
610     }
611 
612     function _msgData() internal view virtual returns (bytes calldata) {
613         return msg.data;
614     }
615 }
616 
617 // File: contracts/ERC721A.sol
618 
619 
620 pragma solidity ^0.8.12;
621 
622 
623 
624 
625 
626 
627 
628 
629 
630 error ApprovalCallerNotOwnerNorApproved();
631 error ApprovalQueryForNonexistentToken();
632 error ApproveToCaller();
633 error ApprovalToCurrentOwner();
634 error BalanceQueryForZeroAddress();
635 error MintedQueryForZeroAddress();
636 error BurnedQueryForZeroAddress();
637 error AuxQueryForZeroAddress();
638 error MintToZeroAddress();
639 error MintZeroQuantity();
640 error OwnerIndexOutOfBounds();
641 error OwnerQueryForNonexistentToken();
642 error TokenIndexOutOfBounds();
643 error TransferCallerNotOwnerNorApproved();
644 error TransferFromIncorrectOwner();
645 error TransferToNonERC721ReceiverImplementer();
646 error TransferToZeroAddress();
647 error URIQueryForNonexistentToken();
648 
649 /**
650  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
651  * the Metadata extension. Built to optimize for lower gas during batch mints.
652  *
653  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
654  *
655  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
656  *
657  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
658  */
659 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
660     using Address for address;
661     using Strings for uint256;
662 
663     // Compiler will pack this into a single 256bit word.
664     struct TokenOwnership {
665         // The address of the owner.
666         address addr;
667         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
668         uint64 startTimestamp;
669         // Whether the token has been burned.
670         bool burned;
671     }
672 
673     // Compiler will pack this into a single 256bit word.
674     struct AddressData {
675         // Realistically, 2**64-1 is more than enough.
676         uint64 balance;
677         // Keeps track of mint count with minimal overhead for tokenomics.
678         uint64 numberMinted;
679         // Keeps track of burn count with minimal overhead for tokenomics.
680         uint64 numberBurned;
681         // For miscellaneous variable(s) pertaining to the address
682         // (e.g. number of whitelist mint slots used).
683         // If there are multiple variables, please pack them into a uint64.
684         uint64 aux;
685     }
686 
687     // The tokenId of the next token to be minted.
688     uint256 internal _currentIndex;
689 
690     // The number of tokens burned.
691     uint256 internal _burnCounter;
692 
693     // Token name
694     string private _name;
695 
696     // Token symbol
697     string private _symbol;
698 
699     // Mapping from token ID to ownership details
700     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
701     mapping(uint256 => TokenOwnership) internal _ownerships;
702 
703     // Mapping owner address to address data
704     mapping(address => AddressData) private _addressData;
705 
706     // Mapping from token ID to approved address
707     mapping(uint256 => address) private _tokenApprovals;
708 
709     // Mapping from owner to operator approvals
710     mapping(address => mapping(address => bool)) private _operatorApprovals;
711 
712     constructor(string memory name_, string memory symbol_) {
713         _name = name_;
714         _symbol = symbol_;
715         _currentIndex = _startTokenId();
716     }
717 
718     /**
719      * To change the starting tokenId, please override this function.
720      */
721     function _startTokenId() internal view virtual returns (uint256) {
722         return 0;
723     }
724 
725     /**
726      * @dev See {IERC721Enumerable-totalSupply}.
727      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
728      */
729     function totalSupply() public view returns (uint256) {
730         // Counter underflow is impossible as _burnCounter cannot be incremented
731         // more than _currentIndex - _startTokenId() times
732         unchecked {
733             return _currentIndex - _burnCounter - _startTokenId();
734         }
735     }
736 
737     /**
738      * Returns the total amount of tokens minted in the contract.
739      */
740     function _totalMinted() internal view returns (uint256) {
741         // Counter underflow is impossible as _currentIndex does not decrement,
742         // and it is initialized to _startTokenId()
743         unchecked {
744             return _currentIndex - _startTokenId();
745         }
746     }
747 
748     /**
749      * @dev See {IERC165-supportsInterface}.
750      */
751     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
752         return
753             interfaceId == type(IERC721).interfaceId ||
754             interfaceId == type(IERC721Metadata).interfaceId ||
755             super.supportsInterface(interfaceId);
756     }
757 
758     /**
759      * @dev See {IERC721-balanceOf}.
760      */
761     function balanceOf(address owner) public view override returns (uint256) {
762         if (owner == address(0)) revert BalanceQueryForZeroAddress();
763         return uint256(_addressData[owner].balance);
764     }
765 
766     /**
767      * Returns the number of tokens minted by `owner`.
768      */
769     function _numberMinted(address owner) internal view returns (uint256) {
770         if (owner == address(0)) revert MintedQueryForZeroAddress();
771         return uint256(_addressData[owner].numberMinted);
772     }
773 
774     /**
775      * Returns the number of tokens burned by or on behalf of `owner`.
776      */
777     function _numberBurned(address owner) internal view returns (uint256) {
778         if (owner == address(0)) revert BurnedQueryForZeroAddress();
779         return uint256(_addressData[owner].numberBurned);
780     }
781 
782     /**
783      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
784      */
785     function _getAux(address owner) internal view returns (uint64) {
786         if (owner == address(0)) revert AuxQueryForZeroAddress();
787         return _addressData[owner].aux;
788     }
789 
790     /**
791      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
792      * If there are multiple variables, please pack them into a uint64.
793      */
794     function _setAux(address owner, uint64 aux) internal {
795         if (owner == address(0)) revert AuxQueryForZeroAddress();
796         _addressData[owner].aux = aux;
797     }
798 
799     /**
800      * Gas spent here starts off proportional to the maximum mint batch size.
801      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
802      */
803     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
804         uint256 curr = tokenId;
805 
806         unchecked {
807             if (_startTokenId() <= curr && curr < _currentIndex) {
808                 TokenOwnership memory ownership = _ownerships[curr];
809                 if (!ownership.burned) {
810                     if (ownership.addr != address(0)) {
811                         return ownership;
812                     }
813                     // Invariant:
814                     // There will always be an ownership that has an address and is not burned
815                     // before an ownership that does not have an address and is not burned.
816                     // Hence, curr will not underflow.
817                     while (true) {
818                         curr--;
819                         ownership = _ownerships[curr];
820                         if (ownership.addr != address(0)) {
821                             return ownership;
822                         }
823                     }
824                 }
825             }
826         }
827         revert OwnerQueryForNonexistentToken();
828     }
829 
830     /**
831      * @dev See {IERC721-ownerOf}.
832      */
833     function ownerOf(uint256 tokenId) public view override returns (address) {
834         return ownershipOf(tokenId).addr;
835     }
836 
837     /**
838      * @dev See {IERC721Metadata-name}.
839      */
840     function name() public view virtual override returns (string memory) {
841         return _name;
842     }
843 
844     /**
845      * @dev See {IERC721Metadata-symbol}.
846      */
847     function symbol() public view virtual override returns (string memory) {
848         return _symbol;
849     }
850 
851     /**
852      * @dev See {IERC721Metadata-tokenURI}.
853      */
854     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
855         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
856 
857         string memory baseURI = _baseURI();
858         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
859     }
860 
861     /**
862      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
863      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
864      * by default, can be overriden in child contracts.
865      */
866     function _baseURI() internal view virtual returns (string memory) {
867         return '';
868     }
869 
870     /**
871      * @dev See {IERC721-approve}.
872      */
873     function approve(address to, uint256 tokenId) public override {
874         address owner = ERC721A.ownerOf(tokenId);
875         if (to == owner) revert ApprovalToCurrentOwner();
876 
877         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
878             revert ApprovalCallerNotOwnerNorApproved();
879         }
880 
881         _approve(to, tokenId, owner);
882     }
883 
884     /**
885      * @dev See {IERC721-getApproved}.
886      */
887     function getApproved(uint256 tokenId) public view override returns (address) {
888         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
889 
890         return _tokenApprovals[tokenId];
891     }
892 
893     /**
894      * @dev See {IERC721-setApprovalForAll}.
895      */
896     function setApprovalForAll(address operator, bool approved) public override {
897         if (operator == _msgSender()) revert ApproveToCaller();
898 
899         _operatorApprovals[_msgSender()][operator] = approved;
900         emit ApprovalForAll(_msgSender(), operator, approved);
901     }
902 
903     /**
904      * @dev See {IERC721-isApprovedForAll}.
905      */
906     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
907         return _operatorApprovals[owner][operator];
908     }
909 
910     /**
911      * @dev See {IERC721-transferFrom}.
912      */
913     function transferFrom(
914         address from,
915         address to,
916         uint256 tokenId
917     ) public virtual override {
918         _transfer(from, to, tokenId);
919     }
920 
921     /**
922      * @dev See {IERC721-safeTransferFrom}.
923      */
924     function safeTransferFrom(
925         address from,
926         address to,
927         uint256 tokenId
928     ) public virtual override {
929         safeTransferFrom(from, to, tokenId, '');
930     }
931 
932     /**
933      * @dev See {IERC721-safeTransferFrom}.
934      */
935     function safeTransferFrom(
936         address from,
937         address to,
938         uint256 tokenId,
939         bytes memory _data
940     ) public virtual override {
941         _transfer(from, to, tokenId);
942         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
943             revert TransferToNonERC721ReceiverImplementer();
944         }
945     }
946 
947     /**
948      * @dev Returns whether `tokenId` exists.
949      *
950      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
951      *
952      * Tokens start existing when they are minted (`_mint`),
953      */
954     function _exists(uint256 tokenId) internal view returns (bool) {
955         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
956             !_ownerships[tokenId].burned;
957     }
958 
959     function _safeMint(address to, uint256 quantity) internal {
960         _safeMint(to, quantity, '');
961     }
962 
963     /**
964      * @dev Safely mints `quantity` tokens and transfers them to `to`.
965      *
966      * Requirements:
967      *
968      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
969      * - `quantity` must be greater than 0.
970      *
971      * Emits a {Transfer} event.
972      */
973     function _safeMint(
974         address to,
975         uint256 quantity,
976         bytes memory _data
977     ) internal {
978         _mint(to, quantity, _data, true);
979     }
980 
981     /**
982      * @dev Mints `quantity` tokens and transfers them to `to`.
983      *
984      * Requirements:
985      *
986      * - `to` cannot be the zero address.
987      * - `quantity` must be greater than 0.
988      *
989      * Emits a {Transfer} event.
990      */
991     function _mint(
992         address to,
993         uint256 quantity,
994         bytes memory _data,
995         bool safe
996     ) internal {
997         uint256 startTokenId = _currentIndex;
998         if (to == address(0)) revert MintToZeroAddress();
999         if (quantity == 0) revert MintZeroQuantity();
1000 
1001         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1002 
1003         // Overflows are incredibly unrealistic.
1004         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1005         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1006         unchecked {
1007             _addressData[to].balance += uint64(quantity);
1008             _addressData[to].numberMinted += uint64(quantity);
1009 
1010             _ownerships[startTokenId].addr = to;
1011             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1012 
1013             uint256 updatedIndex = startTokenId;
1014             uint256 end = updatedIndex + quantity;
1015 
1016             if (safe && to.isContract()) {
1017                 do {
1018                     emit Transfer(address(0), to, updatedIndex);
1019                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1020                         revert TransferToNonERC721ReceiverImplementer();
1021                     }
1022                 } while (updatedIndex != end);
1023                 // Reentrancy protection
1024                 if (_currentIndex != startTokenId) revert();
1025             } else {
1026                 do {
1027                     emit Transfer(address(0), to, updatedIndex++);
1028                 } while (updatedIndex != end);
1029             }
1030             _currentIndex = updatedIndex;
1031         }
1032         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1033     }
1034 
1035     /**
1036      * @dev Transfers `tokenId` from `from` to `to`.
1037      *
1038      * Requirements:
1039      *
1040      * - `to` cannot be the zero address.
1041      * - `tokenId` token must be owned by `from`.
1042      *
1043      * Emits a {Transfer} event.
1044      */
1045     function _transfer(
1046         address from,
1047         address to,
1048         uint256 tokenId
1049     ) private {
1050         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1051 
1052         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1053             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1054             getApproved(tokenId) == _msgSender());
1055 
1056         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1057         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1058         if (to == address(0)) revert TransferToZeroAddress();
1059 
1060         _beforeTokenTransfers(from, to, tokenId, 1);
1061 
1062         // Clear approvals from the previous owner
1063         _approve(address(0), tokenId, prevOwnership.addr);
1064 
1065         // Underflow of the sender's balance is impossible because we check for
1066         // ownership above and the recipient's balance can't realistically overflow.
1067         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1068         unchecked {
1069             _addressData[from].balance -= 1;
1070             _addressData[to].balance += 1;
1071 
1072             _ownerships[tokenId].addr = to;
1073             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1074 
1075             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1076             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1077             uint256 nextTokenId = tokenId + 1;
1078             if (_ownerships[nextTokenId].addr == address(0)) {
1079                 // This will suffice for checking _exists(nextTokenId),
1080                 // as a burned slot cannot contain the zero address.
1081                 if (nextTokenId < _currentIndex) {
1082                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1083                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1084                 }
1085             }
1086         }
1087 
1088         emit Transfer(from, to, tokenId);
1089         _afterTokenTransfers(from, to, tokenId, 1);
1090     }
1091 
1092     /**
1093      * @dev Destroys `tokenId`.
1094      * The approval is cleared when the token is burned.
1095      *
1096      * Requirements:
1097      *
1098      * - `tokenId` must exist.
1099      *
1100      * Emits a {Transfer} event.
1101      */
1102     function _burn(uint256 tokenId) internal virtual {
1103         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1104 
1105         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1106 
1107         // Clear approvals from the previous owner
1108         _approve(address(0), tokenId, prevOwnership.addr);
1109 
1110         // Underflow of the sender's balance is impossible because we check for
1111         // ownership above and the recipient's balance can't realistically overflow.
1112         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1113         unchecked {
1114             _addressData[prevOwnership.addr].balance -= 1;
1115             _addressData[prevOwnership.addr].numberBurned += 1;
1116 
1117             // Keep track of who burned the token, and the timestamp of burning.
1118             _ownerships[tokenId].addr = prevOwnership.addr;
1119             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1120             _ownerships[tokenId].burned = true;
1121 
1122             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1123             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1124             uint256 nextTokenId = tokenId + 1;
1125             if (_ownerships[nextTokenId].addr == address(0)) {
1126                 // This will suffice for checking _exists(nextTokenId),
1127                 // as a burned slot cannot contain the zero address.
1128                 if (nextTokenId < _currentIndex) {
1129                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1130                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1131                 }
1132             }
1133         }
1134 
1135         emit Transfer(prevOwnership.addr, address(0), tokenId);
1136         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1137 
1138         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1139         unchecked {
1140             _burnCounter++;
1141         }
1142     }
1143 
1144     /**
1145      * @dev Approve `to` to operate on `tokenId`
1146      *
1147      * Emits a {Approval} event.
1148      */
1149     function _approve(
1150         address to,
1151         uint256 tokenId,
1152         address owner
1153     ) private {
1154         _tokenApprovals[tokenId] = to;
1155         emit Approval(owner, to, tokenId);
1156     }
1157 
1158     /**
1159      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1160      *
1161      * @param from address representing the previous owner of the given token ID
1162      * @param to target address that will receive the tokens
1163      * @param tokenId uint256 ID of the token to be transferred
1164      * @param _data bytes optional data to send along with the call
1165      * @return bool whether the call correctly returned the expected magic value
1166      */
1167     function _checkContractOnERC721Received(
1168         address from,
1169         address to,
1170         uint256 tokenId,
1171         bytes memory _data
1172     ) private returns (bool) {
1173         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1174             return retval == IERC721Receiver(to).onERC721Received.selector;
1175         } catch (bytes memory reason) {
1176             if (reason.length == 0) {
1177                 revert TransferToNonERC721ReceiverImplementer();
1178             } else {
1179                 assembly {
1180                     revert(add(32, reason), mload(reason))
1181                 }
1182             }
1183         }
1184     }
1185 
1186     /**
1187      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1188      * And also called before burning one token.
1189      *
1190      * startTokenId - the first token id to be transferred
1191      * quantity - the amount to be transferred
1192      *
1193      * Calling conditions:
1194      *
1195      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1196      * transferred to `to`.
1197      * - When `from` is zero, `tokenId` will be minted for `to`.
1198      * - When `to` is zero, `tokenId` will be burned by `from`.
1199      * - `from` and `to` are never both zero.
1200      */
1201     function _beforeTokenTransfers(
1202         address from,
1203         address to,
1204         uint256 startTokenId,
1205         uint256 quantity
1206     ) internal virtual {}
1207 
1208     /**
1209      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1210      * minting.
1211      * And also called after one token has been burned.
1212      *
1213      * startTokenId - the first token id to be transferred
1214      * quantity - the amount to be transferred
1215      *
1216      * Calling conditions:
1217      *
1218      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1219      * transferred to `to`.
1220      * - When `from` is zero, `tokenId` has been minted for `to`.
1221      * - When `to` is zero, `tokenId` has been burned by `from`.
1222      * - `from` and `to` are never both zero.
1223      */
1224     function _afterTokenTransfers(
1225         address from,
1226         address to,
1227         uint256 startTokenId,
1228         uint256 quantity
1229     ) internal virtual {}
1230 }
1231 // File: contracts/ERC721ABurnable.sol
1232 
1233 
1234 pragma solidity ^0.8.12;
1235 
1236 
1237 
1238 /**
1239  * @title ERC721A Burnable Token
1240  * @dev ERC721A Token that can be irreversibly burned (destroyed).
1241  */
1242 abstract contract ERC721ABurnable is Context, ERC721A {
1243 
1244     /**
1245      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1246      *
1247      * Requirements:
1248      *
1249      * - The caller must own `tokenId` or be an approved operator.
1250      */
1251     function burn(uint256 tokenId) public virtual {
1252         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1253 
1254         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1255             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1256             getApproved(tokenId) == _msgSender());
1257 
1258         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1259 
1260         _burn(tokenId);
1261     }
1262 }
1263 // File: @openzeppelin/contracts/access/Ownable.sol
1264 
1265 
1266 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1267 
1268 pragma solidity ^0.8.0;
1269 
1270 
1271 /**
1272  * @dev Contract module which provides a basic access control mechanism, where
1273  * there is an account (an owner) that can be granted exclusive access to
1274  * specific functions.
1275  *
1276  * By default, the owner account will be the one that deploys the contract. This
1277  * can later be changed with {transferOwnership}.
1278  *
1279  * This module is used through inheritance. It will make available the modifier
1280  * `onlyOwner`, which can be applied to your functions to restrict their use to
1281  * the owner.
1282  */
1283 abstract contract Ownable is Context {
1284     address private _owner;
1285 
1286     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1287 
1288     /**
1289      * @dev Initializes the contract setting the deployer as the initial owner.
1290      */
1291     constructor() {
1292         _transferOwnership(_msgSender());
1293     }
1294 
1295     /**
1296      * @dev Returns the address of the current owner.
1297      */
1298     function owner() public view virtual returns (address) {
1299         return _owner;
1300     }
1301 
1302     /**
1303      * @dev Throws if called by any account other than the owner.
1304      */
1305     modifier onlyOwner() {
1306         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1307         _;
1308     }
1309 
1310     /**
1311      * @dev Leaves the contract without owner. It will not be possible to call
1312      * `onlyOwner` functions anymore. Can only be called by the current owner.
1313      *
1314      * NOTE: Renouncing ownership will leave the contract without an owner,
1315      * thereby removing any functionality that is only available to the owner.
1316      */
1317     function renounceOwnership() public virtual onlyOwner {
1318         _transferOwnership(address(0));
1319     }
1320 
1321     /**
1322      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1323      * Can only be called by the current owner.
1324      */
1325     function transferOwnership(address newOwner) public virtual onlyOwner {
1326         require(newOwner != address(0), "Ownable: new owner is the zero address");
1327         _transferOwnership(newOwner);
1328     }
1329 
1330     /**
1331      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1332      * Internal function without access restriction.
1333      */
1334     function _transferOwnership(address newOwner) internal virtual {
1335         address oldOwner = _owner;
1336         _owner = newOwner;
1337         emit OwnershipTransferred(oldOwner, newOwner);
1338     }
1339 }
1340 
1341 // File: contracts/TheSeed.sol
1342 
1343 
1344 pragma solidity ^0.8.12;
1345 
1346 
1347 
1348 contract TheSeed is Ownable, ERC721A, ERC721ABurnable {
1349 
1350     using Strings for uint256;
1351 
1352     uint256 public collectionSize = 333;
1353     string private baseTokenURI;
1354     bool public saleIsActive;
1355 
1356     constructor() ERC721A("The Seed", "SEED") {}
1357 
1358     function mint() external {
1359         require(
1360             saleIsActive,
1361             "Sale is not active"
1362         );
1363         require(
1364             _getAux(_msgSender()) == 0,
1365             "You have already minted"
1366         );
1367         require(
1368             _totalMinted() + 1 <= collectionSize,
1369             "Exceeds max supply"
1370         );
1371         require(
1372             tx.origin == _msgSender(),
1373             "Not allowing contracts"
1374         );
1375 
1376         _setAux(_msgSender(), 1);
1377         _safeMint(_msgSender(), 1);
1378     }
1379 
1380     function ownerMint(uint256 _amount) external onlyOwner {
1381         require(
1382             _totalMinted() == 0,
1383             "Owner has already minted"
1384         );
1385 
1386         _safeMint(_msgSender(), _amount);
1387     }
1388 
1389     function _baseURI() internal view virtual override returns (string memory) {
1390         return baseTokenURI;
1391     }
1392 
1393     function setBaseURI(string calldata baseURI) external onlyOwner {
1394         baseTokenURI = baseURI;
1395     }
1396 
1397     function _startTokenId() internal view override returns (uint256) {
1398         return 1;
1399     }
1400 
1401     function flipSaleState() external onlyOwner {
1402         saleIsActive = !saleIsActive;
1403     }
1404 
1405     function withdraw() external onlyOwner {
1406         payable(_msgSender()).transfer(address(this).balance);
1407     }
1408 }
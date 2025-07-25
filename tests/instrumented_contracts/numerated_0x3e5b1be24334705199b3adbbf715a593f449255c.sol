1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-27
3  */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 /**
31  * @dev Required interface of an ERC721 compliant contract.
32  */
33 interface IERC721 is IERC165 {
34     /**
35      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
36      */
37     event Transfer(
38         address indexed from,
39         address indexed to,
40         uint256 indexed tokenId
41     );
42 
43     /**
44      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
45      */
46     event Approval(
47         address indexed owner,
48         address indexed approved,
49         uint256 indexed tokenId
50     );
51 
52     /**
53      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
54      */
55     event ApprovalForAll(
56         address indexed owner,
57         address indexed operator,
58         bool approved
59     );
60 
61     /**
62      * @dev Returns the number of tokens in ``owner``'s account.
63      */
64     function balanceOf(address owner) external view returns (uint256 balance);
65 
66     /**
67      * @dev Returns the owner of the `tokenId` token.
68      *
69      * Requirements:
70      *
71      * - `tokenId` must exist.
72      */
73     function ownerOf(uint256 tokenId) external view returns (address owner);
74 
75     /**
76      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
77      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
78      *
79      * Requirements:
80      *
81      * - `from` cannot be the zero address.
82      * - `to` cannot be the zero address.
83      * - `tokenId` token must exist and be owned by `from`.
84      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
85      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
86      *
87      * Emits a {Transfer} event.
88      */
89     function safeTransferFrom(
90         address from,
91         address to,
92         uint256 tokenId
93     ) external;
94 
95     /**
96      * @dev Transfers `tokenId` token from `from` to `to`.
97      *
98      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
99      *
100      * Requirements:
101      *
102      * - `from` cannot be the zero address.
103      * - `to` cannot be the zero address.
104      * - `tokenId` token must be owned by `from`.
105      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transferFrom(
110         address from,
111         address to,
112         uint256 tokenId
113     ) external;
114 
115     /**
116      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
117      * The approval is cleared when the token is transferred.
118      *
119      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
120      *
121      * Requirements:
122      *
123      * - The caller must own the token or be an approved operator.
124      * - `tokenId` must exist.
125      *
126      * Emits an {Approval} event.
127      */
128     function approve(address to, uint256 tokenId) external;
129 
130     /**
131      * @dev Returns the account approved for `tokenId` token.
132      *
133      * Requirements:
134      *
135      * - `tokenId` must exist.
136      */
137     function getApproved(uint256 tokenId)
138         external
139         view
140         returns (address operator);
141 
142     /**
143      * @dev Approve or remove `operator` as an operator for the caller.
144      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
145      *
146      * Requirements:
147      *
148      * - The `operator` cannot be the caller.
149      *
150      * Emits an {ApprovalForAll} event.
151      */
152     function setApprovalForAll(address operator, bool _approved) external;
153 
154     /**
155      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
156      *
157      * See {setApprovalForAll}
158      */
159     function isApprovedForAll(address owner, address operator)
160         external
161         view
162         returns (bool);
163 
164     /**
165      * @dev Safely transfers `tokenId` token from `from` to `to`.
166      *
167      * Requirements:
168      *
169      * - `from` cannot be the zero address.
170      * - `to` cannot be the zero address.
171      * - `tokenId` token must exist and be owned by `from`.
172      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
173      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
174      *
175      * Emits a {Transfer} event.
176      */
177     function safeTransferFrom(
178         address from,
179         address to,
180         uint256 tokenId,
181         bytes calldata data
182     ) external;
183 }
184 
185 /**
186  * @dev String operations.
187  */
188 library Strings {
189     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
190 
191     /**
192      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
193      */
194     function toString(uint256 value) internal pure returns (string memory) {
195         // Inspired by OraclizeAPI's implementation - MIT licence
196         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
197 
198         if (value == 0) {
199             return "0";
200         }
201         uint256 temp = value;
202         uint256 digits;
203         while (temp != 0) {
204             digits++;
205             temp /= 10;
206         }
207         bytes memory buffer = new bytes(digits);
208         while (value != 0) {
209             digits -= 1;
210             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
211             value /= 10;
212         }
213         return string(buffer);
214     }
215 
216     /**
217      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
218      */
219     function toHexString(uint256 value) internal pure returns (string memory) {
220         if (value == 0) {
221             return "0x00";
222         }
223         uint256 temp = value;
224         uint256 length = 0;
225         while (temp != 0) {
226             length++;
227             temp >>= 8;
228         }
229         return toHexString(value, length);
230     }
231 
232     /**
233      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
234      */
235     function toHexString(uint256 value, uint256 length)
236         internal
237         pure
238         returns (string memory)
239     {
240         bytes memory buffer = new bytes(2 * length + 2);
241         buffer[0] = "0";
242         buffer[1] = "x";
243         for (uint256 i = 2 * length + 1; i > 1; --i) {
244             buffer[i] = _HEX_SYMBOLS[value & 0xf];
245             value >>= 4;
246         }
247         require(value == 0, "Strings: hex length insufficient");
248         return string(buffer);
249     }
250 }
251 
252 /*
253  * @dev Provides information about the current execution context, including the
254  * sender of the transaction and its data. While these are generally available
255  * via msg.sender and msg.data, they should not be accessed in such a direct
256  * manner, since when dealing with meta-transactions the account sending and
257  * paying for execution may not be the actual sender (as far as an application
258  * is concerned).
259  *
260  * This contract is only required for intermediate, library-like contracts.
261  */
262 abstract contract Context {
263     function _msgSender() internal view virtual returns (address) {
264         return msg.sender;
265     }
266 
267     function _msgData() internal view virtual returns (bytes calldata) {
268         return msg.data;
269     }
270 }
271 
272 /**
273  * @dev Contract module which provides a basic access control mechanism, where
274  * there is an account (an owner) that can be granted exclusive access to
275  * specific functions.
276  *
277  * By default, the owner account will be the one that deploys the contract. This
278  * can later be changed with {transferOwnership}.
279  *
280  * This module is used through inheritance. It will make available the modifier
281  * `onlyOwner`, which can be applied to your functions to restrict their use to
282  * the owner.
283  */
284 abstract contract Ownable is Context {
285     address private _owner;
286 
287     event OwnershipTransferred(
288         address indexed previousOwner,
289         address indexed newOwner
290     );
291 
292     /**
293      * @dev Initializes the contract setting the deployer as the initial owner.
294      */
295     constructor() {
296         _setOwner(_msgSender());
297     }
298 
299     /**
300      * @dev Returns the address of the current owner.
301      */
302     function owner() public view virtual returns (address) {
303         return _owner;
304     }
305 
306     /**
307      * @dev Throws if called by any account other than the owner.
308      */
309     modifier onlyOwner() {
310         require(owner() == _msgSender(), "Ownable: caller is not the owner");
311         _;
312     }
313 
314     /**
315      * @dev Leaves the contract without owner. It will not be possible to call
316      * `onlyOwner` functions anymore. Can only be called by the current owner.
317      *
318      * NOTE: Renouncing ownership will leave the contract without an owner,
319      * thereby removing any functionality that is only available to the owner.
320      */
321     function renounceOwnership() public virtual onlyOwner {
322         _setOwner(address(0));
323     }
324 
325     /**
326      * @dev Transfers ownership of the contract to a new account (`newOwner`).
327      * Can only be called by the current owner.
328      */
329     function transferOwnership(address newOwner) public virtual onlyOwner {
330         require(
331             newOwner != address(0),
332             "Ownable: new owner is the zero address"
333         );
334         _setOwner(newOwner);
335     }
336 
337     function _setOwner(address newOwner) private {
338         address oldOwner = _owner;
339         _owner = newOwner;
340         emit OwnershipTransferred(oldOwner, newOwner);
341     }
342 }
343 
344 /**
345  * @dev Contract module that helps prevent reentrant calls to a function.
346  *
347  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
348  * available, which can be applied to functions to make sure there are no nested
349  * (reentrant) calls to them.
350  *
351  * Note that because there is a single `nonReentrant` guard, functions marked as
352  * `nonReentrant` may not call one another. This can be worked around by making
353  * those functions `private`, and then adding `external` `nonReentrant` entry
354  * points to them.
355  *
356  * TIP: If you would like to learn more about reentrancy and alternative ways
357  * to protect against it, check out our blog post
358  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
359  */
360 abstract contract ReentrancyGuard {
361     // Booleans are more expensive than uint256 or any type that takes up a full
362     // word because each write operation emits an extra SLOAD to first read the
363     // slot's contents, replace the bits taken up by the boolean, and then write
364     // back. This is the compiler's defense against contract upgrades and
365     // pointer aliasing, and it cannot be disabled.
366 
367     // The values being non-zero value makes deployment a bit more expensive,
368     // but in exchange the refund on every call to nonReentrant will be lower in
369     // amount. Since refunds are capped to a percentage of the total
370     // transaction's gas, it is best to keep them low in cases like this one, to
371     // increase the likelihood of the full refund coming into effect.
372     uint256 private constant _NOT_ENTERED = 1;
373     uint256 private constant _ENTERED = 2;
374 
375     uint256 private _status;
376 
377     constructor() {
378         _status = _NOT_ENTERED;
379     }
380 
381     /**
382      * @dev Prevents a contract from calling itself, directly or indirectly.
383      * Calling a `nonReentrant` function from another `nonReentrant`
384      * function is not supported. It is possible to prevent this from happening
385      * by making the `nonReentrant` function external, and make it call a
386      * `private` function that does the actual work.
387      */
388     modifier nonReentrant() {
389         // On the first call to nonReentrant, _notEntered will be true
390         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
391 
392         // Any calls to nonReentrant after this point will fail
393         _status = _ENTERED;
394 
395         _;
396 
397         // By storing the original value once again, a refund is triggered (see
398         // https://eips.ethereum.org/EIPS/eip-2200)
399         _status = _NOT_ENTERED;
400     }
401 }
402 
403 /**
404  * @title ERC721 token receiver interface
405  * @dev Interface for any contract that wants to support safeTransfers
406  * from ERC721 asset contracts.
407  */
408 interface IERC721Receiver {
409     /**
410      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
411      * by `operator` from `from`, this function is called.
412      *
413      * It must return its Solidity selector to confirm the token transfer.
414      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
415      *
416      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
417      */
418     function onERC721Received(
419         address operator,
420         address from,
421         uint256 tokenId,
422         bytes calldata data
423     ) external returns (bytes4);
424 }
425 
426 /**
427  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
428  * @dev See https://eips.ethereum.org/EIPS/eip-721
429  */
430 interface IERC721Metadata is IERC721 {
431     /**
432      * @dev Returns the token collection name.
433      */
434     function name() external view returns (string memory);
435 
436     /**
437      * @dev Returns the token collection symbol.
438      */
439     function symbol() external view returns (string memory);
440 
441     /**
442      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
443      */
444     function tokenURI(uint256 tokenId) external view returns (string memory);
445 }
446 
447 /**
448  * @dev Collection of functions related to the address type
449  */
450 library Address {
451     /**
452      * @dev Returns true if `account` is a contract.
453      *
454      * [IMPORTANT]
455      * ====
456      * It is unsafe to assume that an address for which this function returns
457      * false is an externally-owned account (EOA) and not a contract.
458      *
459      * Among others, `isContract` will return false for the following
460      * types of addresses:
461      *
462      *  - an externally-owned account
463      *  - a contract in construction
464      *  - an address where a contract will be created
465      *  - an address where a contract lived, but was destroyed
466      * ====
467      */
468     function isContract(address account) internal view returns (bool) {
469         // This method relies on extcodesize, which returns 0 for contracts in
470         // construction, since the code is only stored at the end of the
471         // constructor execution.
472 
473         uint256 size;
474         assembly {
475             size := extcodesize(account)
476         }
477         return size > 0;
478     }
479 
480     /**
481      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
482      * `recipient`, forwarding all available gas and reverting on errors.
483      *
484      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
485      * of certain opcodes, possibly making contracts go over the 2300 gas limit
486      * imposed by `transfer`, making them unable to receive funds via
487      * `transfer`. {sendValue} removes this limitation.
488      *
489      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
490      *
491      * IMPORTANT: because control is transferred to `recipient`, care must be
492      * taken to not create reentrancy vulnerabilities. Consider using
493      * {ReentrancyGuard} or the
494      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
495      */
496     function sendValue(address payable recipient, uint256 amount) internal {
497         require(
498             address(this).balance >= amount,
499             "Address: insufficient balance"
500         );
501 
502         (bool success, ) = recipient.call{value: amount}("");
503         require(
504             success,
505             "Address: unable to send value, recipient may have reverted"
506         );
507     }
508 
509     /**
510      * @dev Performs a Solidity function call using a low level `call`. A
511      * plain `call` is an unsafe replacement for a function call: use this
512      * function instead.
513      *
514      * If `target` reverts with a revert reason, it is bubbled up by this
515      * function (like regular Solidity function calls).
516      *
517      * Returns the raw returned data. To convert to the expected return value,
518      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
519      *
520      * Requirements:
521      *
522      * - `target` must be a contract.
523      * - calling `target` with `data` must not revert.
524      *
525      * _Available since v3.1._
526      */
527     function functionCall(address target, bytes memory data)
528         internal
529         returns (bytes memory)
530     {
531         return functionCall(target, data, "Address: low-level call failed");
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
536      * `errorMessage` as a fallback revert reason when `target` reverts.
537      *
538      * _Available since v3.1._
539      */
540     function functionCall(
541         address target,
542         bytes memory data,
543         string memory errorMessage
544     ) internal returns (bytes memory) {
545         return functionCallWithValue(target, data, 0, errorMessage);
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
550      * but also transferring `value` wei to `target`.
551      *
552      * Requirements:
553      *
554      * - the calling contract must have an ETH balance of at least `value`.
555      * - the called Solidity function must be `payable`.
556      *
557      * _Available since v3.1._
558      */
559     function functionCallWithValue(
560         address target,
561         bytes memory data,
562         uint256 value
563     ) internal returns (bytes memory) {
564         return
565             functionCallWithValue(
566                 target,
567                 data,
568                 value,
569                 "Address: low-level call with value failed"
570             );
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
575      * with `errorMessage` as a fallback revert reason when `target` reverts.
576      *
577      * _Available since v3.1._
578      */
579     function functionCallWithValue(
580         address target,
581         bytes memory data,
582         uint256 value,
583         string memory errorMessage
584     ) internal returns (bytes memory) {
585         require(
586             address(this).balance >= value,
587             "Address: insufficient balance for call"
588         );
589         require(isContract(target), "Address: call to non-contract");
590 
591         (bool success, bytes memory returndata) = target.call{value: value}(
592             data
593         );
594         return _verifyCallResult(success, returndata, errorMessage);
595     }
596 
597     /**
598      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
599      * but performing a static call.
600      *
601      * _Available since v3.3._
602      */
603     function functionStaticCall(address target, bytes memory data)
604         internal
605         view
606         returns (bytes memory)
607     {
608         return
609             functionStaticCall(
610                 target,
611                 data,
612                 "Address: low-level static call failed"
613             );
614     }
615 
616     /**
617      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
618      * but performing a static call.
619      *
620      * _Available since v3.3._
621      */
622     function functionStaticCall(
623         address target,
624         bytes memory data,
625         string memory errorMessage
626     ) internal view returns (bytes memory) {
627         require(isContract(target), "Address: static call to non-contract");
628 
629         (bool success, bytes memory returndata) = target.staticcall(data);
630         return _verifyCallResult(success, returndata, errorMessage);
631     }
632 
633     /**
634      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
635      * but performing a delegate call.
636      *
637      * _Available since v3.4._
638      */
639     function functionDelegateCall(address target, bytes memory data)
640         internal
641         returns (bytes memory)
642     {
643         return
644             functionDelegateCall(
645                 target,
646                 data,
647                 "Address: low-level delegate call failed"
648             );
649     }
650 
651     /**
652      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
653      * but performing a delegate call.
654      *
655      * _Available since v3.4._
656      */
657     function functionDelegateCall(
658         address target,
659         bytes memory data,
660         string memory errorMessage
661     ) internal returns (bytes memory) {
662         require(isContract(target), "Address: delegate call to non-contract");
663 
664         (bool success, bytes memory returndata) = target.delegatecall(data);
665         return _verifyCallResult(success, returndata, errorMessage);
666     }
667 
668     function _verifyCallResult(
669         bool success,
670         bytes memory returndata,
671         string memory errorMessage
672     ) private pure returns (bytes memory) {
673         if (success) {
674             return returndata;
675         } else {
676             // Look for revert reason and bubble it up if present
677             if (returndata.length > 0) {
678                 // The easiest way to bubble the revert reason is using memory via assembly
679 
680                 assembly {
681                     let returndata_size := mload(returndata)
682                     revert(add(32, returndata), returndata_size)
683                 }
684             } else {
685                 revert(errorMessage);
686             }
687         }
688     }
689 }
690 
691 /**
692  * @dev Implementation of the {IERC165} interface.
693  *
694  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
695  * for the additional interface id that will be supported. For example:
696  *
697  * ```solidity
698  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
699  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
700  * }
701  * ```
702  *
703  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
704  */
705 abstract contract ERC165 is IERC165 {
706     /**
707      * @dev See {IERC165-supportsInterface}.
708      */
709     function supportsInterface(bytes4 interfaceId)
710         public
711         view
712         virtual
713         override
714         returns (bool)
715     {
716         return interfaceId == type(IERC165).interfaceId;
717     }
718 }
719 
720 /**
721  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
722  * the Metadata extension, but not including the Enumerable extension, which is available separately as
723  * {ERC721Enumerable}.
724  */
725 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
726     using Address for address;
727     using Strings for uint256;
728 
729     // Token name
730     string private _name;
731 
732     // Token symbol
733     string private _symbol;
734 
735     // Mapping from token ID to owner address
736     mapping(uint256 => address) private _owners;
737 
738     // Mapping owner address to token count
739     mapping(address => uint256) private _balances;
740 
741     // Mapping from token ID to approved address
742     mapping(uint256 => address) private _tokenApprovals;
743 
744     // Mapping from owner to operator approvals
745     mapping(address => mapping(address => bool)) private _operatorApprovals;
746 
747     /**
748      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
749      */
750     constructor(string memory name_, string memory symbol_) {
751         _name = name_;
752         _symbol = symbol_;
753     }
754 
755     /**
756      * @dev See {IERC165-supportsInterface}.
757      */
758     function supportsInterface(bytes4 interfaceId)
759         public
760         view
761         virtual
762         override(ERC165, IERC165)
763         returns (bool)
764     {
765         return
766             interfaceId == type(IERC721).interfaceId ||
767             interfaceId == type(IERC721Metadata).interfaceId ||
768             super.supportsInterface(interfaceId);
769     }
770 
771     /**
772      * @dev See {IERC721-balanceOf}.
773      */
774     function balanceOf(address owner)
775         public
776         view
777         virtual
778         override
779         returns (uint256)
780     {
781         require(
782             owner != address(0),
783             "ERC721: balance query for the zero address"
784         );
785         return _balances[owner];
786     }
787 
788     /**
789      * @dev See {IERC721-ownerOf}.
790      */
791     function ownerOf(uint256 tokenId)
792         public
793         view
794         virtual
795         override
796         returns (address)
797     {
798         address owner = _owners[tokenId];
799         require(
800             owner != address(0),
801             "ERC721: owner query for nonexistent token"
802         );
803         return owner;
804     }
805 
806     /**
807      * @dev See {IERC721Metadata-name}.
808      */
809     function name() public view virtual override returns (string memory) {
810         return _name;
811     }
812 
813     /**
814      * @dev See {IERC721Metadata-symbol}.
815      */
816     function symbol() public view virtual override returns (string memory) {
817         return _symbol;
818     }
819 
820     /**
821      * @dev See {IERC721Metadata-tokenURI}.
822      */
823     function tokenURI(uint256 tokenId)
824         public
825         view
826         virtual
827         override
828         returns (string memory)
829     {
830         require(
831             _exists(tokenId),
832             "ERC721Metadata: URI query for nonexistent token"
833         );
834 
835         string memory baseURI = _baseURI();
836         return
837             bytes(baseURI).length > 0
838                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
839                 : "";
840     }
841 
842     /**
843      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
844      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
845      * by default, can be overriden in child contracts.
846      */
847     function _baseURI() internal view virtual returns (string memory) {
848         return "";
849     }
850 
851     /**
852      * @dev See {IERC721-approve}.
853      */
854     function approve(address to, uint256 tokenId) public virtual override {
855         address owner = ERC721.ownerOf(tokenId);
856         require(to != owner, "ERC721: approval to current owner");
857 
858         require(
859             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
860             "ERC721: approve caller is not owner nor approved for all"
861         );
862 
863         _approve(to, tokenId);
864     }
865 
866     /**
867      * @dev See {IERC721-getApproved}.
868      */
869     function getApproved(uint256 tokenId)
870         public
871         view
872         virtual
873         override
874         returns (address)
875     {
876         require(
877             _exists(tokenId),
878             "ERC721: approved query for nonexistent token"
879         );
880 
881         return _tokenApprovals[tokenId];
882     }
883 
884     /**
885      * @dev See {IERC721-setApprovalForAll}.
886      */
887     function setApprovalForAll(address operator, bool approved)
888         public
889         virtual
890         override
891     {
892         require(operator != _msgSender(), "ERC721: approve to caller");
893 
894         _operatorApprovals[_msgSender()][operator] = approved;
895         emit ApprovalForAll(_msgSender(), operator, approved);
896     }
897 
898     /**
899      * @dev See {IERC721-isApprovedForAll}.
900      */
901     function isApprovedForAll(address owner, address operator)
902         public
903         view
904         virtual
905         override
906         returns (bool)
907     {
908         return _operatorApprovals[owner][operator];
909     }
910 
911     /**
912      * @dev See {IERC721-transferFrom}.
913      */
914     function transferFrom(
915         address from,
916         address to,
917         uint256 tokenId
918     ) public virtual override {
919         //solhint-disable-next-line max-line-length
920         require(
921             _isApprovedOrOwner(_msgSender(), tokenId),
922             "ERC721: transfer caller is not owner nor approved"
923         );
924 
925         _transfer(from, to, tokenId);
926     }
927 
928     /**
929      * @dev See {IERC721-safeTransferFrom}.
930      */
931     function safeTransferFrom(
932         address from,
933         address to,
934         uint256 tokenId
935     ) public virtual override {
936         safeTransferFrom(from, to, tokenId, "");
937     }
938 
939     /**
940      * @dev See {IERC721-safeTransferFrom}.
941      */
942     function safeTransferFrom(
943         address from,
944         address to,
945         uint256 tokenId,
946         bytes memory _data
947     ) public virtual override {
948         require(
949             _isApprovedOrOwner(_msgSender(), tokenId),
950             "ERC721: transfer caller is not owner nor approved"
951         );
952         _safeTransfer(from, to, tokenId, _data);
953     }
954 
955     /**
956      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
957      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
958      *
959      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
960      *
961      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
962      * implement alternative mechanisms to perform token transfer, such as signature-based.
963      *
964      * Requirements:
965      *
966      * - `from` cannot be the zero address.
967      * - `to` cannot be the zero address.
968      * - `tokenId` token must exist and be owned by `from`.
969      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
970      *
971      * Emits a {Transfer} event.
972      */
973     function _safeTransfer(
974         address from,
975         address to,
976         uint256 tokenId,
977         bytes memory _data
978     ) internal virtual {
979         _transfer(from, to, tokenId);
980         require(
981             _checkOnERC721Received(from, to, tokenId, _data),
982             "ERC721: transfer to non ERC721Receiver implementer"
983         );
984     }
985 
986     /**
987      * @dev Returns whether `tokenId` exists.
988      *
989      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
990      *
991      * Tokens start existing when they are minted (`_mint`),
992      * and stop existing when they are burned (`_burn`).
993      */
994     function _exists(uint256 tokenId) internal view virtual returns (bool) {
995         return _owners[tokenId] != address(0);
996     }
997 
998     /**
999      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1000      *
1001      * Requirements:
1002      *
1003      * - `tokenId` must exist.
1004      */
1005     function _isApprovedOrOwner(address spender, uint256 tokenId)
1006         internal
1007         view
1008         virtual
1009         returns (bool)
1010     {
1011         require(
1012             _exists(tokenId),
1013             "ERC721: operator query for nonexistent token"
1014         );
1015         address owner = ERC721.ownerOf(tokenId);
1016         return (spender == owner ||
1017             getApproved(tokenId) == spender ||
1018             isApprovedForAll(owner, spender));
1019     }
1020 
1021     /**
1022      * @dev Safely mints `tokenId` and transfers it to `to`.
1023      *
1024      * Requirements:
1025      *
1026      * - `tokenId` must not exist.
1027      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function _safeMint(address to, uint256 tokenId) internal virtual {
1032         _safeMint(to, tokenId, "");
1033     }
1034 
1035     /**
1036      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1037      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1038      */
1039     function _safeMint(
1040         address to,
1041         uint256 tokenId,
1042         bytes memory _data
1043     ) internal virtual {
1044         _mint(to, tokenId);
1045         require(
1046             _checkOnERC721Received(address(0), to, tokenId, _data),
1047             "ERC721: transfer to non ERC721Receiver implementer"
1048         );
1049     }
1050 
1051     /**
1052      * @dev Mints `tokenId` and transfers it to `to`.
1053      *
1054      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1055      *
1056      * Requirements:
1057      *
1058      * - `tokenId` must not exist.
1059      * - `to` cannot be the zero address.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function _mint(address to, uint256 tokenId) internal virtual {
1064         require(to != address(0), "ERC721: mint to the zero address");
1065         require(!_exists(tokenId), "ERC721: token already minted");
1066 
1067         _beforeTokenTransfer(address(0), to, tokenId);
1068 
1069         _balances[to] += 1;
1070         _owners[tokenId] = to;
1071 
1072         emit Transfer(address(0), to, tokenId);
1073     }
1074 
1075     /**
1076      * @dev Destroys `tokenId`.
1077      * The approval is cleared when the token is burned.
1078      *
1079      * Requirements:
1080      *
1081      * - `tokenId` must exist.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function _burn(uint256 tokenId) internal virtual {
1086         address owner = ERC721.ownerOf(tokenId);
1087 
1088         _beforeTokenTransfer(owner, address(0), tokenId);
1089 
1090         // Clear approvals
1091         _approve(address(0), tokenId);
1092 
1093         _balances[owner] -= 1;
1094         delete _owners[tokenId];
1095 
1096         emit Transfer(owner, address(0), tokenId);
1097     }
1098 
1099     /**
1100      * @dev Transfers `tokenId` from `from` to `to`.
1101      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1102      *
1103      * Requirements:
1104      *
1105      * - `to` cannot be the zero address.
1106      * - `tokenId` token must be owned by `from`.
1107      *
1108      * Emits a {Transfer} event.
1109      */
1110     function _transfer(
1111         address from,
1112         address to,
1113         uint256 tokenId
1114     ) internal virtual {
1115         require(
1116             ERC721.ownerOf(tokenId) == from,
1117             "ERC721: transfer of token that is not own"
1118         );
1119         require(to != address(0), "ERC721: transfer to the zero address");
1120 
1121         _beforeTokenTransfer(from, to, tokenId);
1122 
1123         // Clear approvals from the previous owner
1124         _approve(address(0), tokenId);
1125 
1126         _balances[from] -= 1;
1127         _balances[to] += 1;
1128         _owners[tokenId] = to;
1129 
1130         emit Transfer(from, to, tokenId);
1131     }
1132 
1133     /**
1134      * @dev Approve `to` to operate on `tokenId`
1135      *
1136      * Emits a {Approval} event.
1137      */
1138     function _approve(address to, uint256 tokenId) internal virtual {
1139         _tokenApprovals[tokenId] = to;
1140         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1141     }
1142 
1143     /**
1144      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1145      * The call is not executed if the target address is not a contract.
1146      *
1147      * @param from address representing the previous owner of the given token ID
1148      * @param to target address that will receive the tokens
1149      * @param tokenId uint256 ID of the token to be transferred
1150      * @param _data bytes optional data to send along with the call
1151      * @return bool whether the call correctly returned the expected magic value
1152      */
1153     function _checkOnERC721Received(
1154         address from,
1155         address to,
1156         uint256 tokenId,
1157         bytes memory _data
1158     ) private returns (bool) {
1159         if (to.isContract()) {
1160             try
1161                 IERC721Receiver(to).onERC721Received(
1162                     _msgSender(),
1163                     from,
1164                     tokenId,
1165                     _data
1166                 )
1167             returns (bytes4 retval) {
1168                 return retval == IERC721Receiver(to).onERC721Received.selector;
1169             } catch (bytes memory reason) {
1170                 if (reason.length == 0) {
1171                     revert(
1172                         "ERC721: transfer to non ERC721Receiver implementer"
1173                     );
1174                 } else {
1175                     assembly {
1176                         revert(add(32, reason), mload(reason))
1177                     }
1178                 }
1179             }
1180         } else {
1181             return true;
1182         }
1183     }
1184 
1185     /**
1186      * @dev Hook that is called before any token transfer. This includes minting
1187      * and burning.
1188      *
1189      * Calling conditions:
1190      *
1191      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1192      * transferred to `to`.
1193      * - When `from` is zero, `tokenId` will be minted for `to`.
1194      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1195      * - `from` and `to` are never both zero.
1196      *
1197      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1198      */
1199     function _beforeTokenTransfer(
1200         address from,
1201         address to,
1202         uint256 tokenId
1203     ) internal virtual {}
1204 }
1205 
1206 /**
1207  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1208  * @dev See https://eips.ethereum.org/EIPS/eip-721
1209  */
1210 interface IERC721Enumerable is IERC721 {
1211     /**
1212      * @dev Returns the total amount of tokens stored by the contract.
1213      */
1214     function totalSupply() external view returns (uint256);
1215 
1216     /**
1217      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1218      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1219      */
1220     function tokenOfOwnerByIndex(address owner, uint256 index)
1221         external
1222         view
1223         returns (uint256 tokenId);
1224 
1225     /**
1226      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1227      * Use along with {totalSupply} to enumerate all tokens.
1228      */
1229     function tokenByIndex(uint256 index) external view returns (uint256);
1230 }
1231 
1232 /**
1233  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1234  * enumerability of all the token ids in the contract as well as all token ids owned by each
1235  * account.
1236  */
1237 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1238     // Mapping from owner to list of owned token IDs
1239     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1240 
1241     // Mapping from token ID to index of the owner tokens list
1242     mapping(uint256 => uint256) private _ownedTokensIndex;
1243 
1244     // Array with all token ids, used for enumeration
1245     uint256[] private _allTokens;
1246 
1247     // Mapping from token id to position in the allTokens array
1248     mapping(uint256 => uint256) private _allTokensIndex;
1249 
1250     /**
1251      * @dev See {IERC165-supportsInterface}.
1252      */
1253     function supportsInterface(bytes4 interfaceId)
1254         public
1255         view
1256         virtual
1257         override(IERC165, ERC721)
1258         returns (bool)
1259     {
1260         return
1261             interfaceId == type(IERC721Enumerable).interfaceId ||
1262             super.supportsInterface(interfaceId);
1263     }
1264 
1265     /**
1266      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1267      */
1268     function tokenOfOwnerByIndex(address owner, uint256 index)
1269         public
1270         view
1271         virtual
1272         override
1273         returns (uint256)
1274     {
1275         require(
1276             index < ERC721.balanceOf(owner),
1277             "ERC721Enumerable: owner index out of bounds"
1278         );
1279         return _ownedTokens[owner][index];
1280     }
1281 
1282     /**
1283      * @dev See {IERC721Enumerable-totalSupply}.
1284      */
1285     function totalSupply() public view virtual override returns (uint256) {
1286         return _allTokens.length;
1287     }
1288 
1289     /**
1290      * @dev See {IERC721Enumerable-tokenByIndex}.
1291      */
1292     function tokenByIndex(uint256 index)
1293         public
1294         view
1295         virtual
1296         override
1297         returns (uint256)
1298     {
1299         require(
1300             index < ERC721Enumerable.totalSupply(),
1301             "ERC721Enumerable: global index out of bounds"
1302         );
1303         return _allTokens[index];
1304     }
1305 
1306     /**
1307      * @dev Hook that is called before any token transfer. This includes minting
1308      * and burning.
1309      *
1310      * Calling conditions:
1311      *
1312      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1313      * transferred to `to`.
1314      * - When `from` is zero, `tokenId` will be minted for `to`.
1315      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1316      * - `from` cannot be the zero address.
1317      * - `to` cannot be the zero address.
1318      *
1319      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1320      */
1321     function _beforeTokenTransfer(
1322         address from,
1323         address to,
1324         uint256 tokenId
1325     ) internal virtual override {
1326         super._beforeTokenTransfer(from, to, tokenId);
1327 
1328         if (from == address(0)) {
1329             _addTokenToAllTokensEnumeration(tokenId);
1330         } else if (from != to) {
1331             _removeTokenFromOwnerEnumeration(from, tokenId);
1332         }
1333         if (to == address(0)) {
1334             _removeTokenFromAllTokensEnumeration(tokenId);
1335         } else if (to != from) {
1336             _addTokenToOwnerEnumeration(to, tokenId);
1337         }
1338     }
1339 
1340     /**
1341      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1342      * @param to address representing the new owner of the given token ID
1343      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1344      */
1345     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1346         uint256 length = ERC721.balanceOf(to);
1347         _ownedTokens[to][length] = tokenId;
1348         _ownedTokensIndex[tokenId] = length;
1349     }
1350 
1351     /**
1352      * @dev Private function to add a token to this extension's token tracking data structures.
1353      * @param tokenId uint256 ID of the token to be added to the tokens list
1354      */
1355     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1356         _allTokensIndex[tokenId] = _allTokens.length;
1357         _allTokens.push(tokenId);
1358     }
1359 
1360     /**
1361      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1362      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1363      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1364      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1365      * @param from address representing the previous owner of the given token ID
1366      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1367      */
1368     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1369         private
1370     {
1371         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1372         // then delete the last slot (swap and pop).
1373 
1374         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1375         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1376 
1377         // When the token to delete is the last token, the swap operation is unnecessary
1378         if (tokenIndex != lastTokenIndex) {
1379             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1380 
1381             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1382             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1383         }
1384 
1385         // This also deletes the contents at the last position of the array
1386         delete _ownedTokensIndex[tokenId];
1387         delete _ownedTokens[from][lastTokenIndex];
1388     }
1389 
1390     /**
1391      * @dev Private function to remove a token from this extension's token tracking data structures.
1392      * This has O(1) time complexity, but alters the order of the _allTokens array.
1393      * @param tokenId uint256 ID of the token to be removed from the tokens list
1394      */
1395     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1396         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1397         // then delete the last slot (swap and pop).
1398 
1399         uint256 lastTokenIndex = _allTokens.length - 1;
1400         uint256 tokenIndex = _allTokensIndex[tokenId];
1401 
1402         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1403         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1404         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1405         uint256 lastTokenId = _allTokens[lastTokenIndex];
1406 
1407         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1408         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1409 
1410         // This also deletes the contents at the last position of the array
1411         delete _allTokensIndex[tokenId];
1412         _allTokens.pop();
1413     }
1414 }
1415 
1416 contract Pilot is ERC721Enumerable, ReentrancyGuard, Ownable {
1417     string[] private genres = [
1418         "Action",
1419         "Animated",
1420         "Anthology",
1421         "Comedy",
1422         "Crime",
1423         "Documentary",
1424         "Drama",
1425         "Fantasy",
1426         "Horror",
1427         "Mockumentary",
1428         "Musical",
1429         "News/Talk",
1430         "Reality",
1431         "Sci-Fi",
1432         "Sports",
1433         "Suspense",
1434         "Thriller"
1435     ];
1436     
1437     string[] private podcastGenres = [
1438         "Comedy",
1439         "News",
1440         "True Crime",
1441         "Sport",
1442         "Health/Fitness",
1443         "Religion/Faith",
1444         "Politics",
1445         "Self-Help/Productivity",
1446         "Investigative Journalism",
1447         "Finances",
1448         "Scripted Comedy",
1449         "Game Show",
1450         "Pop Culture",
1451         "Scripted Drama"
1452     ];
1453 
1454     string[] private actorTypes = [
1455         "A-lister",
1456         "B-lister",
1457         "C-lister",
1458         "D-lister",
1459         "Reality Star",
1460         "Current Athlete",
1461         "Former Athlete",
1462         "Influencer",
1463         "Politician"
1464     ];
1465     
1466     string[] private projects = [
1467         "Punk",
1468         "Ape",
1469         "Alien",
1470         "Zombie",
1471         "Cat",
1472         "Dog",
1473         "Penguin"
1474     ];
1475 
1476     string[] private types = ["TV Show", "Movie", "Podcast"];
1477 
1478     string[] private tvRatings = ["TV-G", "TV-PG", "TV-14", "TV-MA"];
1479 
1480     string[] private movieRatings = ["G", "PG", "PG-13", "R", "NC-17"];
1481 
1482     string[] private podcastRatings = ["Clean", "Explicit"];
1483 
1484     function random(string memory input) internal pure returns (uint256) {
1485         return uint256(keccak256(abi.encodePacked(input)));
1486     }
1487 
1488     function getType(uint256 tokenId) public view returns (string memory) {
1489         return pluck(tokenId, "TYPE", types);
1490     }
1491 
1492     function getRating(uint256 tokenId, string memory pilotType)
1493         public
1494         view
1495         returns (string memory)
1496     {
1497         if (
1498             keccak256(abi.encodePacked(pilotType)) ==
1499             keccak256(abi.encodePacked("TV Show"))
1500         ) {
1501             return pluck(tokenId, "RATING", tvRatings);
1502         } else if (
1503             keccak256(abi.encodePacked(pilotType)) ==
1504             keccak256(abi.encodePacked("Movie"))
1505         ) {
1506             return pluck(tokenId, "RATING", movieRatings);
1507         } else {
1508             return pluck(tokenId, "RATING", podcastRatings);
1509         }
1510     }
1511 
1512     function getGenre(uint256 tokenId, string memory pilotType) public view returns (string memory) {
1513          if (
1514             keccak256(abi.encodePacked(pilotType)) ==
1515             keccak256(abi.encodePacked("Podcast"))
1516         ) {
1517             return pluck(tokenId, "GENRE", podcastGenres);            
1518         } else {
1519             return pluck(tokenId, "GENRE", genres);            
1520         }
1521     }
1522     
1523     function getCrossGenre(uint256 tokenId, string memory pilotType, string memory genre)
1524         public
1525         view
1526         returns (string memory)
1527     {
1528         if (
1529             keccak256(abi.encodePacked(pilotType)) ==
1530             keccak256(abi.encodePacked("Podcast"))
1531         ) {
1532             string[] memory podcastCrossGenres = new string[](podcastGenres.length-1);
1533             uint index = 0;
1534             for (uint i = 0; i < podcastGenres.length; i++) { 
1535                 if(keccak256(abi.encodePacked(podcastGenres[i])) != keccak256(abi.encodePacked(genre))) {
1536                     podcastCrossGenres[index] = podcastGenres[i];
1537                     index++;
1538                 }
1539             }
1540             return pluck(tokenId, "CROSSGENRE", podcastCrossGenres);
1541         } else {
1542             string[] memory crossGenres = new string[](genres.length-1);
1543             uint index = 0;
1544             for (uint i = 0; i < genres.length; i++) { 
1545                 if(keccak256(abi.encodePacked(genres[i])) != keccak256(abi.encodePacked(genre))) {
1546                     crossGenres[index] = genres[i];
1547                     index++;
1548                 }
1549             }
1550             return pluck(tokenId, "CROSSGENRE", crossGenres);
1551         }
1552     }
1553     
1554     function getActor(uint256 tokenId, string memory keyPrefix) public view returns (string memory) {
1555        return pluckActor(tokenId, keyPrefix, actorTypes, projects);
1556     }
1557 
1558     function pluck(
1559         uint256 tokenId,
1560         string memory keyPrefix,
1561         string[] memory sourceArray
1562     ) internal pure returns (string memory) {
1563         uint256 rand = random(
1564             string(abi.encodePacked(keyPrefix, toString(tokenId)))  
1565         );
1566         string memory output = sourceArray[rand % sourceArray.length];
1567         return output;
1568     }
1569     
1570     function pluckActor(
1571         uint256 tokenId,
1572         string memory keyPrefix,
1573         string[] memory actorTypesArray,
1574         string[] memory projectsArray
1575     ) internal pure returns (string memory) {
1576         uint256 rand = random(
1577             string(abi.encodePacked(keyPrefix, toString(tokenId)))  
1578         );
1579         uint256 greatness = rand % 21;
1580         if (greatness > 14) {
1581             return projectsArray[rand % projectsArray.length];
1582         } else {
1583             return actorTypesArray[rand % actorTypesArray.length];
1584         }
1585     }
1586 
1587     function tokenURI(uint256 tokenId)
1588         public
1589         view
1590         override
1591         returns (string memory)
1592     {
1593         string[13] memory parts;
1594         parts[
1595             0
1596         ] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: black; font-family: courier new, monospace; font-size: 14px; font-weight: bold}</style><rect width="100%" height="100%" fill="white" /><text text-anchor="middle" x="50%" y="120" class="base">';
1597 
1598         parts[1] = getType(tokenId);
1599 
1600         parts[2] = '</text><text text-anchor="middle" x="50%" y="140" class="base">';
1601 
1602         parts[3] = getRating(tokenId, parts[1]);
1603 
1604         parts[4] = '</text><text text-anchor="middle" x="50%" y="160" class="base">';
1605 
1606         parts[5] = getGenre(tokenId, parts[1]);
1607 
1608         parts[6] = '</text><text text-anchor="middle" x="50%" y="180" class="base">';
1609 
1610         parts[7] = getCrossGenre(tokenId, parts[1], parts[5]);
1611 
1612         parts[8] = '</text><text text-anchor="middle" x="50%" y="200" class="base">';
1613 
1614         parts[9] = getActor(tokenId, "LEAD");
1615 
1616         parts[10] = '</text><text text-anchor="middle" x="50%" y="220" class="base">';
1617 
1618         parts[11] = getActor(tokenId, "SUPPORTING");
1619 
1620         parts[12] = "</text></svg>";
1621 
1622         string memory output = string(
1623             abi.encodePacked(
1624                 parts[0],
1625                 parts[1],
1626                 parts[2],
1627                 parts[3],
1628                 parts[4],
1629                 parts[5],
1630                 parts[6],
1631                 parts[7],
1632                 parts[8]
1633             )
1634         );
1635         output = string(
1636             abi.encodePacked(output, parts[9], parts[10], parts[11], parts[12])
1637         );
1638 
1639         string memory json = Base64.encode(
1640             bytes(
1641                 string(
1642                     abi.encodePacked(
1643                         '{"name": "Pitch #',
1644                         toString(tokenId),
1645                         '", "description": "Pilot is randomized TV/Movie/Podcast pitches generated and stored on chain. We generate the premise. You generate the buzz.", "image": "data:image/svg+xml;base64,',
1646                         Base64.encode(bytes(output)),
1647                         '"}'
1648                     )
1649                 )
1650             )
1651         );
1652         output = string(
1653             abi.encodePacked("data:application/json;base64,", json)
1654         );
1655 
1656         return output;
1657     }
1658 
1659     function claim(uint256 tokenId) public nonReentrant {
1660         require(tokenId > 0 && tokenId < 7778, "Token ID invalid");
1661         _safeMint(_msgSender(), tokenId);
1662     }
1663 
1664     function ownerClaim(uint256 tokenId) public nonReentrant onlyOwner {
1665         require(tokenId > 7777 && tokenId < 8001, "Token ID invalid");
1666         _safeMint(owner(), tokenId);
1667     }
1668 
1669     function toString(uint256 value) internal pure returns (string memory) {
1670         // Inspired by OraclizeAPI's implementation - MIT license
1671         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1672 
1673         if (value == 0) {
1674             return "0";
1675         }
1676         uint256 temp = value;
1677         uint256 digits;
1678         while (temp != 0) {
1679             digits++;
1680             temp /= 10;
1681         }
1682         bytes memory buffer = new bytes(digits);
1683         while (value != 0) {
1684             digits -= 1;
1685             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1686             value /= 10;
1687         }
1688         return string(buffer);
1689     }
1690 
1691     constructor() ERC721("Pilot", "PILOT") Ownable() {}
1692 }
1693 
1694 /// [MIT License]
1695 /// @title Base64
1696 /// @notice Provides a function for encoding some bytes in base64
1697 /// @author Brecht Devos <brecht@loopring.org>
1698 library Base64 {
1699     bytes internal constant TABLE =
1700         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1701 
1702     /// @notice Encodes some bytes to the base64 representation
1703     function encode(bytes memory data) internal pure returns (string memory) {
1704         uint256 len = data.length;
1705         if (len == 0) return "";
1706 
1707         // multiply by 4/3 rounded up
1708         uint256 encodedLen = 4 * ((len + 2) / 3);
1709 
1710         // Add some extra buffer at the end
1711         bytes memory result = new bytes(encodedLen + 32);
1712 
1713         bytes memory table = TABLE;
1714 
1715         assembly {
1716             let tablePtr := add(table, 1)
1717             let resultPtr := add(result, 32)
1718 
1719             for {
1720                 let i := 0
1721             } lt(i, len) {
1722 
1723             } {
1724                 i := add(i, 3)
1725                 let input := and(mload(add(data, i)), 0xffffff)
1726 
1727                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1728                 out := shl(8, out)
1729                 out := add(
1730                     out,
1731                     and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF)
1732                 )
1733                 out := shl(8, out)
1734                 out := add(
1735                     out,
1736                     and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF)
1737                 )
1738                 out := shl(8, out)
1739                 out := add(
1740                     out,
1741                     and(mload(add(tablePtr, and(input, 0x3F))), 0xFF)
1742                 )
1743                 out := shl(224, out)
1744 
1745                 mstore(resultPtr, out)
1746 
1747                 resultPtr := add(resultPtr, 4)
1748             }
1749 
1750             switch mod(len, 3)
1751             case 1 {
1752                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1753             }
1754             case 2 {
1755                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1756             }
1757 
1758             mstore(result, encodedLen)
1759         }
1760 
1761         return string(result);
1762     }
1763 }
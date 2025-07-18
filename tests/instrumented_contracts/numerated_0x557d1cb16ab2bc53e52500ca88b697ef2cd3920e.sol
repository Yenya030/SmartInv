1 
2   
3 //-------------DEPENDENCIES--------------------------//
4 
5 // File: @openzeppelin/contracts/utils/Address.sol
6 
7 
8 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
9 
10 pragma solidity ^0.8.1;
11 
12 /**
13  * @dev Collection of functions related to the address type
14  */
15 library Address {
16     /**
17      * @dev Returns true if account is a contract.
18      *
19      * [IMPORTANT]
20      * ====
21      * It is unsafe to assume that an address for which this function returns
22      * false is an externally-owned account (EOA) and not a contract.
23      *
24      * Among others, isContract will return false for the following
25      * types of addresses:
26      *
27      *  - an externally-owned account
28      *  - a contract in construction
29      *  - an address where a contract will be created
30      *  - an address where a contract lived, but was destroyed
31      * ====
32      *
33      * [IMPORTANT]
34      * ====
35      * You shouldn't rely on isContract to protect against flash loan attacks!
36      *
37      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
38      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
39      * constructor.
40      * ====
41      */
42     function isContract(address account) internal view returns (bool) {
43         // This method relies on extcodesize/address.code.length, which returns 0
44         // for contracts in construction, since the code is only stored at the end
45         // of the constructor execution.
46 
47         return account.code.length > 0;
48     }
49 
50     /**
51      * @dev Replacement for Solidity's transfer: sends amount wei to
52      * recipient, forwarding all available gas and reverting on errors.
53      *
54      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
55      * of certain opcodes, possibly making contracts go over the 2300 gas limit
56      * imposed by transfer, making them unable to receive funds via
57      * transfer. {sendValue} removes this limitation.
58      *
59      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
60      *
61      * IMPORTANT: because control is transferred to recipient, care must be
62      * taken to not create reentrancy vulnerabilities. Consider using
63      * {ReentrancyGuard} or the
64      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
65      */
66     function sendValue(address payable recipient, uint256 amount) internal {
67         require(address(this).balance >= amount, "Address: insufficient balance");
68 
69         (bool success, ) = recipient.call{value: amount}("");
70         require(success, "Address: unable to send value, recipient may have reverted");
71     }
72 
73     /**
74      * @dev Performs a Solidity function call using a low level call. A
75      * plain call is an unsafe replacement for a function call: use this
76      * function instead.
77      *
78      * If target reverts with a revert reason, it is bubbled up by this
79      * function (like regular Solidity function calls).
80      *
81      * Returns the raw returned data. To convert to the expected return value,
82      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
83      *
84      * Requirements:
85      *
86      * - target must be a contract.
87      * - calling target with data must not revert.
88      *
89      * _Available since v3.1._
90      */
91     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
92         return functionCall(target, data, "Address: low-level call failed");
93     }
94 
95     /**
96      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
97      * errorMessage as a fallback revert reason when target reverts.
98      *
99      * _Available since v3.1._
100      */
101     function functionCall(
102         address target,
103         bytes memory data,
104         string memory errorMessage
105     ) internal returns (bytes memory) {
106         return functionCallWithValue(target, data, 0, errorMessage);
107     }
108 
109     /**
110      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
111      * but also transferring value wei to target.
112      *
113      * Requirements:
114      *
115      * - the calling contract must have an ETH balance of at least value.
116      * - the called Solidity function must be payable.
117      *
118      * _Available since v3.1._
119      */
120     function functionCallWithValue(
121         address target,
122         bytes memory data,
123         uint256 value
124     ) internal returns (bytes memory) {
125         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
126     }
127 
128     /**
129      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
130      * with errorMessage as a fallback revert reason when target reverts.
131      *
132      * _Available since v3.1._
133      */
134     function functionCallWithValue(
135         address target,
136         bytes memory data,
137         uint256 value,
138         string memory errorMessage
139     ) internal returns (bytes memory) {
140         require(address(this).balance >= value, "Address: insufficient balance for call");
141         require(isContract(target), "Address: call to non-contract");
142 
143         (bool success, bytes memory returndata) = target.call{value: value}(data);
144         return verifyCallResult(success, returndata, errorMessage);
145     }
146 
147     /**
148      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
149      * but performing a static call.
150      *
151      * _Available since v3.3._
152      */
153     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
154         return functionStaticCall(target, data, "Address: low-level static call failed");
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
159      * but performing a static call.
160      *
161      * _Available since v3.3._
162      */
163     function functionStaticCall(
164         address target,
165         bytes memory data,
166         string memory errorMessage
167     ) internal view returns (bytes memory) {
168         require(isContract(target), "Address: static call to non-contract");
169 
170         (bool success, bytes memory returndata) = target.staticcall(data);
171         return verifyCallResult(success, returndata, errorMessage);
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
176      * but performing a delegate call.
177      *
178      * _Available since v3.4._
179      */
180     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
181         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
186      * but performing a delegate call.
187      *
188      * _Available since v3.4._
189      */
190     function functionDelegateCall(
191         address target,
192         bytes memory data,
193         string memory errorMessage
194     ) internal returns (bytes memory) {
195         require(isContract(target), "Address: delegate call to non-contract");
196 
197         (bool success, bytes memory returndata) = target.delegatecall(data);
198         return verifyCallResult(success, returndata, errorMessage);
199     }
200 
201     /**
202      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
203      * revert reason using the provided one.
204      *
205      * _Available since v4.3._
206      */
207     function verifyCallResult(
208         bool success,
209         bytes memory returndata,
210         string memory errorMessage
211     ) internal pure returns (bytes memory) {
212         if (success) {
213             return returndata;
214         } else {
215             // Look for revert reason and bubble it up if present
216             if (returndata.length > 0) {
217                 // The easiest way to bubble the revert reason is using memory via assembly
218 
219                 assembly {
220                     let returndata_size := mload(returndata)
221                     revert(add(32, returndata), returndata_size)
222                 }
223             } else {
224                 revert(errorMessage);
225             }
226         }
227     }
228 }
229 
230 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
231 
232 
233 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
234 
235 pragma solidity ^0.8.0;
236 
237 /**
238  * @title ERC721 token receiver interface
239  * @dev Interface for any contract that wants to support safeTransfers
240  * from ERC721 asset contracts.
241  */
242 interface IERC721Receiver {
243     /**
244      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
245      * by operator from from, this function is called.
246      *
247      * It must return its Solidity selector to confirm the token transfer.
248      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
249      *
250      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
251      */
252     function onERC721Received(
253         address operator,
254         address from,
255         uint256 tokenId,
256         bytes calldata data
257     ) external returns (bytes4);
258 }
259 
260 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
261 
262 
263 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
264 
265 pragma solidity ^0.8.0;
266 
267 /**
268  * @dev Interface of the ERC165 standard, as defined in the
269  * https://eips.ethereum.org/EIPS/eip-165[EIP].
270  *
271  * Implementers can declare support of contract interfaces, which can then be
272  * queried by others ({ERC165Checker}).
273  *
274  * For an implementation, see {ERC165}.
275  */
276 interface IERC165 {
277     /**
278      * @dev Returns true if this contract implements the interface defined by
279      * interfaceId. See the corresponding
280      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
281      * to learn more about how these ids are created.
282      *
283      * This function call must use less than 30 000 gas.
284      */
285     function supportsInterface(bytes4 interfaceId) external view returns (bool);
286 }
287 
288 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
289 
290 
291 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
292 
293 pragma solidity ^0.8.0;
294 
295 
296 /**
297  * @dev Implementation of the {IERC165} interface.
298  *
299  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
300  * for the additional interface id that will be supported. For example:
301  *
302  * solidity
303  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
304  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
305  * }
306  * 
307  *
308  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
309  */
310 abstract contract ERC165 is IERC165 {
311     /**
312      * @dev See {IERC165-supportsInterface}.
313      */
314     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
315         return interfaceId == type(IERC165).interfaceId;
316     }
317 }
318 
319 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
320 
321 
322 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
323 
324 pragma solidity ^0.8.0;
325 
326 
327 /**
328  * @dev Required interface of an ERC721 compliant contract.
329  */
330 interface IERC721 is IERC165 {
331     /**
332      * @dev Emitted when tokenId token is transferred from from to to.
333      */
334     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
335 
336     /**
337      * @dev Emitted when owner enables approved to manage the tokenId token.
338      */
339     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
340 
341     /**
342      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
343      */
344     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
345 
346     /**
347      * @dev Returns the number of tokens in owner's account.
348      */
349     function balanceOf(address owner) external view returns (uint256 balance);
350 
351     /**
352      * @dev Returns the owner of the tokenId token.
353      *
354      * Requirements:
355      *
356      * - tokenId must exist.
357      */
358     function ownerOf(uint256 tokenId) external view returns (address owner);
359 
360     /**
361      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
362      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
363      *
364      * Requirements:
365      *
366      * - from cannot be the zero address.
367      * - to cannot be the zero address.
368      * - tokenId token must exist and be owned by from.
369      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
370      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
371      *
372      * Emits a {Transfer} event.
373      */
374     function safeTransferFrom(
375         address from,
376         address to,
377         uint256 tokenId
378     ) external;
379 
380     /**
381      * @dev Transfers tokenId token from from to to.
382      *
383      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
384      *
385      * Requirements:
386      *
387      * - from cannot be the zero address.
388      * - to cannot be the zero address.
389      * - tokenId token must be owned by from.
390      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
391      *
392      * Emits a {Transfer} event.
393      */
394     function transferFrom(
395         address from,
396         address to,
397         uint256 tokenId
398     ) external;
399 
400     /**
401      * @dev Gives permission to to to transfer tokenId token to another account.
402      * The approval is cleared when the token is transferred.
403      *
404      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
405      *
406      * Requirements:
407      *
408      * - The caller must own the token or be an approved operator.
409      * - tokenId must exist.
410      *
411      * Emits an {Approval} event.
412      */
413     function approve(address to, uint256 tokenId) external;
414 
415     /**
416      * @dev Returns the account approved for tokenId token.
417      *
418      * Requirements:
419      *
420      * - tokenId must exist.
421      */
422     function getApproved(uint256 tokenId) external view returns (address operator);
423 
424     /**
425      * @dev Approve or remove operator as an operator for the caller.
426      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
427      *
428      * Requirements:
429      *
430      * - The operator cannot be the caller.
431      *
432      * Emits an {ApprovalForAll} event.
433      */
434     function setApprovalForAll(address operator, bool _approved) external;
435 
436     /**
437      * @dev Returns if the operator is allowed to manage all of the assets of owner.
438      *
439      * See {setApprovalForAll}
440      */
441     function isApprovedForAll(address owner, address operator) external view returns (bool);
442 
443     /**
444      * @dev Safely transfers tokenId token from from to to.
445      *
446      * Requirements:
447      *
448      * - from cannot be the zero address.
449      * - to cannot be the zero address.
450      * - tokenId token must exist and be owned by from.
451      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
452      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
453      *
454      * Emits a {Transfer} event.
455      */
456     function safeTransferFrom(
457         address from,
458         address to,
459         uint256 tokenId,
460         bytes calldata data
461     ) external;
462 }
463 
464 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
465 
466 
467 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
468 
469 pragma solidity ^0.8.0;
470 
471 
472 /**
473  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
474  * @dev See https://eips.ethereum.org/EIPS/eip-721
475  */
476 interface IERC721Enumerable is IERC721 {
477     /**
478      * @dev Returns the total amount of tokens stored by the contract.
479      */
480     function totalSupply() external view returns (uint256);
481 
482     /**
483      * @dev Returns a token ID owned by owner at a given index of its token list.
484      * Use along with {balanceOf} to enumerate all of owner's tokens.
485      */
486     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
487 
488     /**
489      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
490      * Use along with {totalSupply} to enumerate all tokens.
491      */
492     function tokenByIndex(uint256 index) external view returns (uint256);
493 }
494 
495 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
496 
497 
498 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 
503 /**
504  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
505  * @dev See https://eips.ethereum.org/EIPS/eip-721
506  */
507 interface IERC721Metadata is IERC721 {
508     /**
509      * @dev Returns the token collection name.
510      */
511     function name() external view returns (string memory);
512 
513     /**
514      * @dev Returns the token collection symbol.
515      */
516     function symbol() external view returns (string memory);
517 
518     /**
519      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
520      */
521     function tokenURI(uint256 tokenId) external view returns (string memory);
522 }
523 
524 // File: @openzeppelin/contracts/utils/Strings.sol
525 
526 
527 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
528 
529 pragma solidity ^0.8.0;
530 
531 /**
532  * @dev String operations.
533  */
534 library Strings {
535     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
536 
537     /**
538      * @dev Converts a uint256 to its ASCII string decimal representation.
539      */
540     function toString(uint256 value) internal pure returns (string memory) {
541         // Inspired by OraclizeAPI's implementation - MIT licence
542         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
543 
544         if (value == 0) {
545             return "0";
546         }
547         uint256 temp = value;
548         uint256 digits;
549         while (temp != 0) {
550             digits++;
551             temp /= 10;
552         }
553         bytes memory buffer = new bytes(digits);
554         while (value != 0) {
555             digits -= 1;
556             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
557             value /= 10;
558         }
559         return string(buffer);
560     }
561 
562     /**
563      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
564      */
565     function toHexString(uint256 value) internal pure returns (string memory) {
566         if (value == 0) {
567             return "0x00";
568         }
569         uint256 temp = value;
570         uint256 length = 0;
571         while (temp != 0) {
572             length++;
573             temp >>= 8;
574         }
575         return toHexString(value, length);
576     }
577 
578     /**
579      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
580      */
581     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
582         bytes memory buffer = new bytes(2 * length + 2);
583         buffer[0] = "0";
584         buffer[1] = "x";
585         for (uint256 i = 2 * length + 1; i > 1; --i) {
586             buffer[i] = _HEX_SYMBOLS[value & 0xf];
587             value >>= 4;
588         }
589         require(value == 0, "Strings: hex length insufficient");
590         return string(buffer);
591     }
592 }
593 
594 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
595 
596 
597 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
598 
599 pragma solidity ^0.8.0;
600 
601 /**
602  * @dev Contract module that helps prevent reentrant calls to a function.
603  *
604  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
605  * available, which can be applied to functions to make sure there are no nested
606  * (reentrant) calls to them.
607  *
608  * Note that because there is a single nonReentrant guard, functions marked as
609  * nonReentrant may not call one another. This can be worked around by making
610  * those functions private, and then adding external nonReentrant entry
611  * points to them.
612  *
613  * TIP: If you would like to learn more about reentrancy and alternative ways
614  * to protect against it, check out our blog post
615  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
616  */
617 abstract contract ReentrancyGuard {
618     // Booleans are more expensive than uint256 or any type that takes up a full
619     // word because each write operation emits an extra SLOAD to first read the
620     // slot's contents, replace the bits taken up by the boolean, and then write
621     // back. This is the compiler's defense against contract upgrades and
622     // pointer aliasing, and it cannot be disabled.
623 
624     // The values being non-zero value makes deployment a bit more expensive,
625     // but in exchange the refund on every call to nonReentrant will be lower in
626     // amount. Since refunds are capped to a percentage of the total
627     // transaction's gas, it is best to keep them low in cases like this one, to
628     // increase the likelihood of the full refund coming into effect.
629     uint256 private constant _NOT_ENTERED = 1;
630     uint256 private constant _ENTERED = 2;
631 
632     uint256 private _status;
633 
634     constructor() {
635         _status = _NOT_ENTERED;
636     }
637 
638     /**
639      * @dev Prevents a contract from calling itself, directly or indirectly.
640      * Calling a nonReentrant function from another nonReentrant
641      * function is not supported. It is possible to prevent this from happening
642      * by making the nonReentrant function external, and making it call a
643      * private function that does the actual work.
644      */
645     modifier nonReentrant() {
646         // On the first call to nonReentrant, _notEntered will be true
647         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
648 
649         // Any calls to nonReentrant after this point will fail
650         _status = _ENTERED;
651 
652         _;
653 
654         // By storing the original value once again, a refund is triggered (see
655         // https://eips.ethereum.org/EIPS/eip-2200)
656         _status = _NOT_ENTERED;
657     }
658 }
659 
660 // File: @openzeppelin/contracts/utils/Context.sol
661 
662 
663 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
664 
665 pragma solidity ^0.8.0;
666 
667 /**
668  * @dev Provides information about the current execution context, including the
669  * sender of the transaction and its data. While these are generally available
670  * via msg.sender and msg.data, they should not be accessed in such a direct
671  * manner, since when dealing with meta-transactions the account sending and
672  * paying for execution may not be the actual sender (as far as an application
673  * is concerned).
674  *
675  * This contract is only required for intermediate, library-like contracts.
676  */
677 abstract contract Context {
678     function _msgSender() internal view virtual returns (address) {
679         return msg.sender;
680     }
681 
682     function _msgData() internal view virtual returns (bytes calldata) {
683         return msg.data;
684     }
685 }
686 
687 // File: @openzeppelin/contracts/access/Ownable.sol
688 
689 
690 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
691 
692 pragma solidity ^0.8.0;
693 
694 
695 /**
696  * @dev Contract module which provides a basic access control mechanism, where
697  * there is an account (an owner) that can be granted exclusive access to
698  * specific functions.
699  *
700  * By default, the owner account will be the one that deploys the contract. This
701  * can later be changed with {transferOwnership}.
702  *
703  * This module is used through inheritance. It will make available the modifier
704  * onlyOwner, which can be applied to your functions to restrict their use to
705  * the owner.
706  */
707 abstract contract Ownable is Context {
708     address private _owner;
709 
710     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
711 
712     /**
713      * @dev Initializes the contract setting the deployer as the initial owner.
714      */
715     constructor() {
716         _transferOwnership(_msgSender());
717     }
718 
719     /**
720      * @dev Returns the address of the current owner.
721      */
722     function owner() public view virtual returns (address) {
723         return _owner;
724     }
725 
726     /**
727      * @dev Throws if called by any account other than the owner.
728      */
729     modifier onlyOwner() {
730         require(owner() == _msgSender(), "Ownable: caller is not the owner");
731         _;
732     }
733 
734     /**
735      * @dev Leaves the contract without owner. It will not be possible to call
736      * onlyOwner functions anymore. Can only be called by the current owner.
737      *
738      * NOTE: Renouncing ownership will leave the contract without an owner,
739      * thereby removing any functionality that is only available to the owner.
740      */
741     function renounceOwnership() public virtual onlyOwner {
742         _transferOwnership(address(0));
743     }
744 
745     /**
746      * @dev Transfers ownership of the contract to a new account (newOwner).
747      * Can only be called by the current owner.
748      */
749     function transferOwnership(address newOwner) public virtual onlyOwner {
750         require(newOwner != address(0), "Ownable: new owner is the zero address");
751         _transferOwnership(newOwner);
752     }
753 
754     /**
755      * @dev Transfers ownership of the contract to a new account (newOwner).
756      * Internal function without access restriction.
757      */
758     function _transferOwnership(address newOwner) internal virtual {
759         address oldOwner = _owner;
760         _owner = newOwner;
761         emit OwnershipTransferred(oldOwner, newOwner);
762     }
763 }
764 //-------------END DEPENDENCIES------------------------//
765 
766 
767   
768 // Rampp Contracts v2.1 (Teams.sol)
769 
770 pragma solidity ^0.8.0;
771 
772 /**
773 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
774 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
775 * This will easily allow cross-collaboration via Mintplex.xyz.
776 **/
777 abstract contract Teams is Ownable{
778   mapping (address => bool) internal team;
779 
780   /**
781   * @dev Adds an address to the team. Allows them to execute protected functions
782   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
783   **/
784   function addToTeam(address _address) public onlyOwner {
785     require(_address != address(0), "Invalid address");
786     require(!inTeam(_address), "This address is already in your team.");
787   
788     team[_address] = true;
789   }
790 
791   /**
792   * @dev Removes an address to the team.
793   * @param _address the ETH address to remove, cannot be 0x and must be in team
794   **/
795   function removeFromTeam(address _address) public onlyOwner {
796     require(_address != address(0), "Invalid address");
797     require(inTeam(_address), "This address is not in your team currently.");
798   
799     team[_address] = false;
800   }
801 
802   /**
803   * @dev Check if an address is valid and active in the team
804   * @param _address ETH address to check for truthiness
805   **/
806   function inTeam(address _address)
807     public
808     view
809     returns (bool)
810   {
811     require(_address != address(0), "Invalid address to check.");
812     return team[_address] == true;
813   }
814 
815   /**
816   * @dev Throws if called by any account other than the owner or team member.
817   */
818   modifier onlyTeamOrOwner() {
819     bool _isOwner = owner() == _msgSender();
820     bool _isTeam = inTeam(_msgSender());
821     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
822     _;
823   }
824 }
825 
826 
827   
828   pragma solidity ^0.8.0;
829 
830   /**
831   * @dev These functions deal with verification of Merkle Trees proofs.
832   *
833   * The proofs can be generated using the JavaScript library
834   * https://github.com/miguelmota/merkletreejs[merkletreejs].
835   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
836   *
837   *
838   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
839   * hashing, or use a hash function other than keccak256 for hashing leaves.
840   * This is because the concatenation of a sorted pair of internal nodes in
841   * the merkle tree could be reinterpreted as a leaf value.
842   */
843   library MerkleProof {
844       /**
845       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
846       * defined by 'root'. For this, a 'proof' must be provided, containing
847       * sibling hashes on the branch from the leaf to the root of the tree. Each
848       * pair of leaves and each pair of pre-images are assumed to be sorted.
849       */
850       function verify(
851           bytes32[] memory proof,
852           bytes32 root,
853           bytes32 leaf
854       ) internal pure returns (bool) {
855           return processProof(proof, leaf) == root;
856       }
857 
858       /**
859       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
860       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
861       * hash matches the root of the tree. When processing the proof, the pairs
862       * of leafs & pre-images are assumed to be sorted.
863       *
864       * _Available since v4.4._
865       */
866       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
867           bytes32 computedHash = leaf;
868           for (uint256 i = 0; i < proof.length; i++) {
869               bytes32 proofElement = proof[i];
870               if (computedHash <= proofElement) {
871                   // Hash(current computed hash + current element of the proof)
872                   computedHash = _efficientHash(computedHash, proofElement);
873               } else {
874                   // Hash(current element of the proof + current computed hash)
875                   computedHash = _efficientHash(proofElement, computedHash);
876               }
877           }
878           return computedHash;
879       }
880 
881       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
882           assembly {
883               mstore(0x00, a)
884               mstore(0x20, b)
885               value := keccak256(0x00, 0x40)
886           }
887       }
888   }
889 
890 
891   // File: Allowlist.sol
892 
893   pragma solidity ^0.8.0;
894 
895   abstract contract Allowlist is Teams {
896     bytes32 public merkleRoot;
897     bool public onlyAllowlistMode = false;
898 
899     /**
900      * @dev Update merkle root to reflect changes in Allowlist
901      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
902      */
903     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
904       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
905       merkleRoot = _newMerkleRoot;
906     }
907 
908     /**
909      * @dev Check the proof of an address if valid for merkle root
910      * @param _to address to check for proof
911      * @param _merkleProof Proof of the address to validate against root and leaf
912      */
913     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
914       require(merkleRoot != 0, "Merkle root is not set!");
915       bytes32 leaf = keccak256(abi.encodePacked(_to));
916 
917       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
918     }
919 
920     
921     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
922       onlyAllowlistMode = true;
923     }
924 
925     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
926         onlyAllowlistMode = false;
927     }
928   }
929   
930   
931 /**
932  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
933  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
934  *
935  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
936  * 
937  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
938  *
939  * Does not support burning tokens to address(0).
940  */
941 contract ERC721A is
942   Context,
943   ERC165,
944   IERC721,
945   IERC721Metadata,
946   IERC721Enumerable,
947   Teams
948 {
949   using Address for address;
950   using Strings for uint256;
951 
952   struct TokenOwnership {
953     address addr;
954     uint64 startTimestamp;
955   }
956 
957   struct AddressData {
958     uint128 balance;
959     uint128 numberMinted;
960   }
961 
962   uint256 private currentIndex;
963 
964   uint256 public immutable collectionSize;
965   uint256 public maxBatchSize;
966 
967   // Token name
968   string private _name;
969 
970   // Token symbol
971   string private _symbol;
972 
973   // Mapping from token ID to ownership details
974   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
975   mapping(uint256 => TokenOwnership) private _ownerships;
976 
977   // Mapping owner address to address data
978   mapping(address => AddressData) private _addressData;
979 
980   // Mapping from token ID to approved address
981   mapping(uint256 => address) private _tokenApprovals;
982 
983   // Mapping from owner to operator approvals
984   mapping(address => mapping(address => bool)) private _operatorApprovals;
985 
986   /* @dev Mapping of restricted operator approvals set by contract Owner
987   * This serves as an optional addition to ERC-721 so
988   * that the contract owner can elect to prevent specific addresses/contracts
989   * from being marked as the approver for a token. The reason for this
990   * is that some projects may want to retain control of where their tokens can/can not be listed
991   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
992   * By default, there are no restrictions. The contract owner must deliberatly block an address 
993   */
994   mapping(address => bool) public restrictedApprovalAddresses;
995 
996   /**
997    * @dev
998    * maxBatchSize refers to how much a minter can mint at a time.
999    * collectionSize_ refers to how many tokens are in the collection.
1000    */
1001   constructor(
1002     string memory name_,
1003     string memory symbol_,
1004     uint256 maxBatchSize_,
1005     uint256 collectionSize_
1006   ) {
1007     require(
1008       collectionSize_ > 0,
1009       "ERC721A: collection must have a nonzero supply"
1010     );
1011     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1012     _name = name_;
1013     _symbol = symbol_;
1014     maxBatchSize = maxBatchSize_;
1015     collectionSize = collectionSize_;
1016     currentIndex = _startTokenId();
1017   }
1018 
1019   /**
1020   * To change the starting tokenId, please override this function.
1021   */
1022   function _startTokenId() internal view virtual returns (uint256) {
1023     return 1;
1024   }
1025 
1026   /**
1027    * @dev See {IERC721Enumerable-totalSupply}.
1028    */
1029   function totalSupply() public view override returns (uint256) {
1030     return _totalMinted();
1031   }
1032 
1033   function currentTokenId() public view returns (uint256) {
1034     return _totalMinted();
1035   }
1036 
1037   function getNextTokenId() public view returns (uint256) {
1038       return _totalMinted() + 1;
1039   }
1040 
1041   /**
1042   * Returns the total amount of tokens minted in the contract.
1043   */
1044   function _totalMinted() internal view returns (uint256) {
1045     unchecked {
1046       return currentIndex - _startTokenId();
1047     }
1048   }
1049 
1050   /**
1051    * @dev See {IERC721Enumerable-tokenByIndex}.
1052    */
1053   function tokenByIndex(uint256 index) public view override returns (uint256) {
1054     require(index < totalSupply(), "ERC721A: global index out of bounds");
1055     return index;
1056   }
1057 
1058   /**
1059    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1060    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1061    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1062    */
1063   function tokenOfOwnerByIndex(address owner, uint256 index)
1064     public
1065     view
1066     override
1067     returns (uint256)
1068   {
1069     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1070     uint256 numMintedSoFar = totalSupply();
1071     uint256 tokenIdsIdx = 0;
1072     address currOwnershipAddr = address(0);
1073     for (uint256 i = 0; i < numMintedSoFar; i++) {
1074       TokenOwnership memory ownership = _ownerships[i];
1075       if (ownership.addr != address(0)) {
1076         currOwnershipAddr = ownership.addr;
1077       }
1078       if (currOwnershipAddr == owner) {
1079         if (tokenIdsIdx == index) {
1080           return i;
1081         }
1082         tokenIdsIdx++;
1083       }
1084     }
1085     revert("ERC721A: unable to get token of owner by index");
1086   }
1087 
1088   /**
1089    * @dev See {IERC165-supportsInterface}.
1090    */
1091   function supportsInterface(bytes4 interfaceId)
1092     public
1093     view
1094     virtual
1095     override(ERC165, IERC165)
1096     returns (bool)
1097   {
1098     return
1099       interfaceId == type(IERC721).interfaceId ||
1100       interfaceId == type(IERC721Metadata).interfaceId ||
1101       interfaceId == type(IERC721Enumerable).interfaceId ||
1102       super.supportsInterface(interfaceId);
1103   }
1104 
1105   /**
1106    * @dev See {IERC721-balanceOf}.
1107    */
1108   function balanceOf(address owner) public view override returns (uint256) {
1109     require(owner != address(0), "ERC721A: balance query for the zero address");
1110     return uint256(_addressData[owner].balance);
1111   }
1112 
1113   function _numberMinted(address owner) internal view returns (uint256) {
1114     require(
1115       owner != address(0),
1116       "ERC721A: number minted query for the zero address"
1117     );
1118     return uint256(_addressData[owner].numberMinted);
1119   }
1120 
1121   function ownershipOf(uint256 tokenId)
1122     internal
1123     view
1124     returns (TokenOwnership memory)
1125   {
1126     uint256 curr = tokenId;
1127 
1128     unchecked {
1129         if (_startTokenId() <= curr && curr < currentIndex) {
1130             TokenOwnership memory ownership = _ownerships[curr];
1131             if (ownership.addr != address(0)) {
1132                 return ownership;
1133             }
1134 
1135             // Invariant:
1136             // There will always be an ownership that has an address and is not burned
1137             // before an ownership that does not have an address and is not burned.
1138             // Hence, curr will not underflow.
1139             while (true) {
1140                 curr--;
1141                 ownership = _ownerships[curr];
1142                 if (ownership.addr != address(0)) {
1143                     return ownership;
1144                 }
1145             }
1146         }
1147     }
1148 
1149     revert("ERC721A: unable to determine the owner of token");
1150   }
1151 
1152   /**
1153    * @dev See {IERC721-ownerOf}.
1154    */
1155   function ownerOf(uint256 tokenId) public view override returns (address) {
1156     return ownershipOf(tokenId).addr;
1157   }
1158 
1159   /**
1160    * @dev See {IERC721Metadata-name}.
1161    */
1162   function name() public view virtual override returns (string memory) {
1163     return _name;
1164   }
1165 
1166   /**
1167    * @dev See {IERC721Metadata-symbol}.
1168    */
1169   function symbol() public view virtual override returns (string memory) {
1170     return _symbol;
1171   }
1172 
1173   /**
1174    * @dev See {IERC721Metadata-tokenURI}.
1175    */
1176   function tokenURI(uint256 tokenId)
1177     public
1178     view
1179     virtual
1180     override
1181     returns (string memory)
1182   {
1183     string memory baseURI = _baseURI();
1184     string memory extension = _baseURIExtension();
1185     return
1186       bytes(baseURI).length > 0
1187         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1188         : "";
1189   }
1190 
1191   /**
1192    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1193    * token will be the concatenation of the baseURI and the tokenId. Empty
1194    * by default, can be overriden in child contracts.
1195    */
1196   function _baseURI() internal view virtual returns (string memory) {
1197     return "";
1198   }
1199 
1200   /**
1201    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1202    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1203    * by default, can be overriden in child contracts.
1204    */
1205   function _baseURIExtension() internal view virtual returns (string memory) {
1206     return "";
1207   }
1208 
1209   /**
1210    * @dev Sets the value for an address to be in the restricted approval address pool.
1211    * Setting an address to true will disable token owners from being able to mark the address
1212    * for approval for trading. This would be used in theory to prevent token owners from listing
1213    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1214    * @param _address the marketplace/user to modify restriction status of
1215    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1216    */
1217   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1218     restrictedApprovalAddresses[_address] = _isRestricted;
1219   }
1220 
1221   /**
1222    * @dev See {IERC721-approve}.
1223    */
1224   function approve(address to, uint256 tokenId) public override {
1225     address owner = ERC721A.ownerOf(tokenId);
1226     require(to != owner, "ERC721A: approval to current owner");
1227     require(restrictedApprovalAddresses[to] == false, "ERC721RestrictedApproval: Address to approve has been restricted by contract owner and is not allowed to be marked for approval");
1228 
1229     require(
1230       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1231       "ERC721A: approve caller is not owner nor approved for all"
1232     );
1233 
1234     _approve(to, tokenId, owner);
1235   }
1236 
1237   /**
1238    * @dev See {IERC721-getApproved}.
1239    */
1240   function getApproved(uint256 tokenId) public view override returns (address) {
1241     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1242 
1243     return _tokenApprovals[tokenId];
1244   }
1245 
1246   /**
1247    * @dev See {IERC721-setApprovalForAll}.
1248    */
1249   function setApprovalForAll(address operator, bool approved) public override {
1250     require(operator != _msgSender(), "ERC721A: approve to caller");
1251     require(restrictedApprovalAddresses[operator] == false, "ERC721RestrictedApproval: Operator address has been restricted by contract owner and is not allowed to be marked for approval");
1252 
1253     _operatorApprovals[_msgSender()][operator] = approved;
1254     emit ApprovalForAll(_msgSender(), operator, approved);
1255   }
1256 
1257   /**
1258    * @dev See {IERC721-isApprovedForAll}.
1259    */
1260   function isApprovedForAll(address owner, address operator)
1261     public
1262     view
1263     virtual
1264     override
1265     returns (bool)
1266   {
1267     return _operatorApprovals[owner][operator];
1268   }
1269 
1270   /**
1271    * @dev See {IERC721-transferFrom}.
1272    */
1273   function transferFrom(
1274     address from,
1275     address to,
1276     uint256 tokenId
1277   ) public override {
1278     _transfer(from, to, tokenId);
1279   }
1280 
1281   /**
1282    * @dev See {IERC721-safeTransferFrom}.
1283    */
1284   function safeTransferFrom(
1285     address from,
1286     address to,
1287     uint256 tokenId
1288   ) public override {
1289     safeTransferFrom(from, to, tokenId, "");
1290   }
1291 
1292   /**
1293    * @dev See {IERC721-safeTransferFrom}.
1294    */
1295   function safeTransferFrom(
1296     address from,
1297     address to,
1298     uint256 tokenId,
1299     bytes memory _data
1300   ) public override {
1301     _transfer(from, to, tokenId);
1302     require(
1303       _checkOnERC721Received(from, to, tokenId, _data),
1304       "ERC721A: transfer to non ERC721Receiver implementer"
1305     );
1306   }
1307 
1308   /**
1309    * @dev Returns whether tokenId exists.
1310    *
1311    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1312    *
1313    * Tokens start existing when they are minted (_mint),
1314    */
1315   function _exists(uint256 tokenId) internal view returns (bool) {
1316     return _startTokenId() <= tokenId && tokenId < currentIndex;
1317   }
1318 
1319   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1320     _safeMint(to, quantity, isAdminMint, "");
1321   }
1322 
1323   /**
1324    * @dev Mints quantity tokens and transfers them to to.
1325    *
1326    * Requirements:
1327    *
1328    * - there must be quantity tokens remaining unminted in the total collection.
1329    * - to cannot be the zero address.
1330    * - quantity cannot be larger than the max batch size.
1331    *
1332    * Emits a {Transfer} event.
1333    */
1334   function _safeMint(
1335     address to,
1336     uint256 quantity,
1337     bool isAdminMint,
1338     bytes memory _data
1339   ) internal {
1340     uint256 startTokenId = currentIndex;
1341     require(to != address(0), "ERC721A: mint to the zero address");
1342     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1343     require(!_exists(startTokenId), "ERC721A: token already minted");
1344 
1345     // For admin mints we do not want to enforce the maxBatchSize limit
1346     if (isAdminMint == false) {
1347         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1348     }
1349 
1350     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1351 
1352     AddressData memory addressData = _addressData[to];
1353     _addressData[to] = AddressData(
1354       addressData.balance + uint128(quantity),
1355       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1356     );
1357     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1358 
1359     uint256 updatedIndex = startTokenId;
1360 
1361     for (uint256 i = 0; i < quantity; i++) {
1362       emit Transfer(address(0), to, updatedIndex);
1363       require(
1364         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1365         "ERC721A: transfer to non ERC721Receiver implementer"
1366       );
1367       updatedIndex++;
1368     }
1369 
1370     currentIndex = updatedIndex;
1371     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1372   }
1373 
1374   /**
1375    * @dev Transfers tokenId from from to to.
1376    *
1377    * Requirements:
1378    *
1379    * - to cannot be the zero address.
1380    * - tokenId token must be owned by from.
1381    *
1382    * Emits a {Transfer} event.
1383    */
1384   function _transfer(
1385     address from,
1386     address to,
1387     uint256 tokenId
1388   ) private {
1389     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1390 
1391     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1392       getApproved(tokenId) == _msgSender() ||
1393       isApprovedForAll(prevOwnership.addr, _msgSender()));
1394 
1395     require(
1396       isApprovedOrOwner,
1397       "ERC721A: transfer caller is not owner nor approved"
1398     );
1399 
1400     require(
1401       prevOwnership.addr == from,
1402       "ERC721A: transfer from incorrect owner"
1403     );
1404     require(to != address(0), "ERC721A: transfer to the zero address");
1405 
1406     _beforeTokenTransfers(from, to, tokenId, 1);
1407 
1408     // Clear approvals from the previous owner
1409     _approve(address(0), tokenId, prevOwnership.addr);
1410 
1411     _addressData[from].balance -= 1;
1412     _addressData[to].balance += 1;
1413     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1414 
1415     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1416     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1417     uint256 nextTokenId = tokenId + 1;
1418     if (_ownerships[nextTokenId].addr == address(0)) {
1419       if (_exists(nextTokenId)) {
1420         _ownerships[nextTokenId] = TokenOwnership(
1421           prevOwnership.addr,
1422           prevOwnership.startTimestamp
1423         );
1424       }
1425     }
1426 
1427     emit Transfer(from, to, tokenId);
1428     _afterTokenTransfers(from, to, tokenId, 1);
1429   }
1430 
1431   /**
1432    * @dev Approve to to operate on tokenId
1433    *
1434    * Emits a {Approval} event.
1435    */
1436   function _approve(
1437     address to,
1438     uint256 tokenId,
1439     address owner
1440   ) private {
1441     _tokenApprovals[tokenId] = to;
1442     emit Approval(owner, to, tokenId);
1443   }
1444 
1445   uint256 public nextOwnerToExplicitlySet = 0;
1446 
1447   /**
1448    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1449    */
1450   function _setOwnersExplicit(uint256 quantity) internal {
1451     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1452     require(quantity > 0, "quantity must be nonzero");
1453     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1454 
1455     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1456     if (endIndex > collectionSize - 1) {
1457       endIndex = collectionSize - 1;
1458     }
1459     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1460     require(_exists(endIndex), "not enough minted yet for this cleanup");
1461     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1462       if (_ownerships[i].addr == address(0)) {
1463         TokenOwnership memory ownership = ownershipOf(i);
1464         _ownerships[i] = TokenOwnership(
1465           ownership.addr,
1466           ownership.startTimestamp
1467         );
1468       }
1469     }
1470     nextOwnerToExplicitlySet = endIndex + 1;
1471   }
1472 
1473   /**
1474    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1475    * The call is not executed if the target address is not a contract.
1476    *
1477    * @param from address representing the previous owner of the given token ID
1478    * @param to target address that will receive the tokens
1479    * @param tokenId uint256 ID of the token to be transferred
1480    * @param _data bytes optional data to send along with the call
1481    * @return bool whether the call correctly returned the expected magic value
1482    */
1483   function _checkOnERC721Received(
1484     address from,
1485     address to,
1486     uint256 tokenId,
1487     bytes memory _data
1488   ) private returns (bool) {
1489     if (to.isContract()) {
1490       try
1491         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1492       returns (bytes4 retval) {
1493         return retval == IERC721Receiver(to).onERC721Received.selector;
1494       } catch (bytes memory reason) {
1495         if (reason.length == 0) {
1496           revert("ERC721A: transfer to non ERC721Receiver implementer");
1497         } else {
1498           assembly {
1499             revert(add(32, reason), mload(reason))
1500           }
1501         }
1502       }
1503     } else {
1504       return true;
1505     }
1506   }
1507 
1508   /**
1509    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1510    *
1511    * startTokenId - the first token id to be transferred
1512    * quantity - the amount to be transferred
1513    *
1514    * Calling conditions:
1515    *
1516    * - When from and to are both non-zero, from's tokenId will be
1517    * transferred to to.
1518    * - When from is zero, tokenId will be minted for to.
1519    */
1520   function _beforeTokenTransfers(
1521     address from,
1522     address to,
1523     uint256 startTokenId,
1524     uint256 quantity
1525   ) internal virtual {}
1526 
1527   /**
1528    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1529    * minting.
1530    *
1531    * startTokenId - the first token id to be transferred
1532    * quantity - the amount to be transferred
1533    *
1534    * Calling conditions:
1535    *
1536    * - when from and to are both non-zero.
1537    * - from and to are never both zero.
1538    */
1539   function _afterTokenTransfers(
1540     address from,
1541     address to,
1542     uint256 startTokenId,
1543     uint256 quantity
1544   ) internal virtual {}
1545 }
1546 
1547 
1548 
1549   
1550 abstract contract Ramppable {
1551   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1552 
1553   modifier isRampp() {
1554       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1555       _;
1556   }
1557 }
1558 
1559 
1560   
1561   
1562 interface IERC20 {
1563   function allowance(address owner, address spender) external view returns (uint256);
1564   function transfer(address _to, uint256 _amount) external returns (bool);
1565   function balanceOf(address account) external view returns (uint256);
1566   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1567 }
1568 
1569 // File: WithdrawableV2
1570 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1571 // ERC-20 Payouts are limited to a single payout address. This feature 
1572 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1573 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1574 abstract contract WithdrawableV2 is Teams, Ramppable {
1575   struct acceptedERC20 {
1576     bool isActive;
1577     uint256 chargeAmount;
1578   }
1579 
1580   
1581   mapping(address => acceptedERC20) private allowedTokenContracts;
1582   address[] public payableAddresses = [0x8cF0285Ee60dB505D0969d88a9FeC1db3c519eF8];
1583   address public erc20Payable = 0x8cF0285Ee60dB505D0969d88a9FeC1db3c519eF8;
1584   uint256[] public payableFees = [100];
1585   uint256 public payableAddressCount = 1;
1586   bool public onlyERC20MintingMode = false;
1587   
1588 
1589   /**
1590   * @dev Calculates the true payable balance of the contract
1591   */
1592   function calcAvailableBalance() public view returns(uint256) {
1593     return address(this).balance;
1594   }
1595 
1596   function withdrawAll() public onlyTeamOrOwner {
1597       require(calcAvailableBalance() > 0);
1598       _withdrawAll();
1599   }
1600   
1601   function withdrawAllRampp() public isRampp {
1602       require(calcAvailableBalance() > 0);
1603       _withdrawAll();
1604   }
1605 
1606   function _withdrawAll() private {
1607       uint256 balance = calcAvailableBalance();
1608       
1609       for(uint i=0; i < payableAddressCount; i++ ) {
1610           _widthdraw(
1611               payableAddresses[i],
1612               (balance * payableFees[i]) / 100
1613           );
1614       }
1615   }
1616   
1617   function _widthdraw(address _address, uint256 _amount) private {
1618       (bool success, ) = _address.call{value: _amount}("");
1619       require(success, "Transfer failed.");
1620   }
1621 
1622   /**
1623   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1624   * in the event ERC-20 tokens are paid to the contract for mints.
1625   * @param _tokenContract contract of ERC-20 token to withdraw
1626   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1627   */
1628   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1629     require(_amountToWithdraw > 0);
1630     IERC20 tokenContract = IERC20(_tokenContract);
1631     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1632     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1633   }
1634 
1635   /**
1636   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1637   * @param _erc20TokenContract address of ERC-20 contract in question
1638   */
1639   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1640     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1641   }
1642 
1643   /**
1644   * @dev get the value of tokens to transfer for user of an ERC-20
1645   * @param _erc20TokenContract address of ERC-20 contract in question
1646   */
1647   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1648     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1649     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1650   }
1651 
1652   /**
1653   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1654   * @param _erc20TokenContract address of ERC-20 contract in question
1655   * @param _isActive default status of if contract should be allowed to accept payments
1656   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1657   */
1658   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1659     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1660     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1661   }
1662 
1663   /**
1664   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1665   * it will assume the default value of zero. This should not be used to create new payment tokens.
1666   * @param _erc20TokenContract address of ERC-20 contract in question
1667   */
1668   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1669     allowedTokenContracts[_erc20TokenContract].isActive = true;
1670   }
1671 
1672   /**
1673   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1674   * it will assume the default value of zero. This should not be used to create new payment tokens.
1675   * @param _erc20TokenContract address of ERC-20 contract in question
1676   */
1677   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1678     allowedTokenContracts[_erc20TokenContract].isActive = false;
1679   }
1680 
1681   /**
1682   * @dev Enable only ERC-20 payments for minting on this contract
1683   */
1684   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1685     onlyERC20MintingMode = true;
1686   }
1687 
1688   /**
1689   * @dev Disable only ERC-20 payments for minting on this contract
1690   */
1691   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1692     onlyERC20MintingMode = false;
1693   }
1694 
1695   /**
1696   * @dev Set the payout of the ERC-20 token payout to a specific address
1697   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1698   */
1699   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1700     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1701     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1702     erc20Payable = _newErc20Payable;
1703   }
1704 
1705   /**
1706   * @dev Allows Rampp wallet to update its own reference.
1707   * @param _newAddress updated Rampp Address
1708   */
1709   function setRamppAddress(address _newAddress) public isRampp {
1710     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1711     RAMPPADDRESS = _newAddress;
1712   }
1713 }
1714 
1715 
1716   
1717   
1718   
1719 // File: EarlyMintIncentive.sol
1720 // Allows the contract to have the first x tokens minted for a wallet at a discount or
1721 // zero fee that can be calculated on the fly.
1722 abstract contract EarlyMintIncentive is Teams, ERC721A {
1723   uint256 public PRICE = 0.003 ether;
1724   uint256 public EARLY_MINT_PRICE = 0 ether;
1725   uint256 public earlyMintOwnershipCap = 1;
1726   bool public usingEarlyMintIncentive = true;
1727 
1728   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1729     usingEarlyMintIncentive = true;
1730   }
1731 
1732   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1733     usingEarlyMintIncentive = false;
1734   }
1735 
1736   /**
1737   * @dev Set the max token ID in which the cost incentive will be applied.
1738   * @param _newCap max number of tokens wallet may mint for incentive price
1739   */
1740   function setEarlyMintOwnershipCap(uint256 _newCap) public onlyTeamOrOwner {
1741     require(_newCap >= 1, "Cannot set cap to less than 1");
1742     earlyMintOwnershipCap = _newCap;
1743   }
1744 
1745   /**
1746   * @dev Set the incentive mint price
1747   * @param _feeInWei new price per token when in incentive range
1748   */
1749   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1750     EARLY_MINT_PRICE = _feeInWei;
1751   }
1752 
1753   /**
1754   * @dev Set the primary mint price - the base price when not under incentive
1755   * @param _feeInWei new price per token
1756   */
1757   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1758     PRICE = _feeInWei;
1759   }
1760 
1761   /**
1762   * @dev Get the correct price for the mint for qty and person minting
1763   * @param _count amount of tokens to calc for mint
1764   * @param _to the address which will be minting these tokens, passed explicitly
1765   */
1766   function getPrice(uint256 _count, address _to) public view returns (uint256) {
1767     require(_count > 0, "Must be minting at least 1 token.");
1768 
1769     // short circuit function if we dont need to even calc incentive pricing
1770     // short circuit if the current wallet mint qty is also already over cap
1771     if(
1772       usingEarlyMintIncentive == false ||
1773       _numberMinted(_to) > earlyMintOwnershipCap
1774     ) {
1775       return PRICE * _count;
1776     }
1777 
1778     uint256 endingTokenQty = _numberMinted(_to) + _count;
1779     // If qty to mint results in a final qty less than or equal to the cap then
1780     // the entire qty is within incentive mint.
1781     if(endingTokenQty  <= earlyMintOwnershipCap) {
1782       return EARLY_MINT_PRICE * _count;
1783     }
1784 
1785     // If the current token qty is less than the incentive cap
1786     // and the ending token qty is greater than the incentive cap
1787     // we will be straddling the cap so there will be some amount
1788     // that are incentive and some that are regular fee.
1789     uint256 incentiveTokenCount = earlyMintOwnershipCap - _numberMinted(_to);
1790     uint256 outsideIncentiveCount = endingTokenQty - earlyMintOwnershipCap;
1791 
1792     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1793   }
1794 }
1795 
1796   
1797 abstract contract RamppERC721A is 
1798     Ownable,
1799     Teams,
1800     ERC721A,
1801     WithdrawableV2,
1802     ReentrancyGuard 
1803     , EarlyMintIncentive 
1804     , Allowlist 
1805     
1806 {
1807   constructor(
1808     string memory tokenName,
1809     string memory tokenSymbol
1810   ) ERC721A(tokenName, tokenSymbol, 15, 4000) { }
1811     uint8 public CONTRACT_VERSION = 2;
1812     string public _baseTokenURI = "https://api.billionairegator.club/";
1813     string public _baseTokenExtension = ".json";
1814 
1815     bool public mintingOpen = false;
1816     
1817     
1818     uint256 public MAX_WALLET_MINTS = 15;
1819 
1820   
1821     /////////////// Admin Mint Functions
1822     /**
1823      * @dev Mints a token to an address with a tokenURI.
1824      * This is owner only and allows a fee-free drop
1825      * @param _to address of the future owner of the token
1826      * @param _qty amount of tokens to drop the owner
1827      */
1828      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1829          require(_qty > 0, "Must mint at least 1 token.");
1830          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 4000");
1831          _safeMint(_to, _qty, true);
1832      }
1833 
1834   
1835     /////////////// GENERIC MINT FUNCTIONS
1836     /**
1837     * @dev Mints a single token to an address.
1838     * fee may or may not be required*
1839     * @param _to address of the future owner of the token
1840     */
1841     function mintTo(address _to) public payable {
1842         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1843         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 4000");
1844         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1845         
1846         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1847         require(msg.value == getPrice(1, _to), "Value below required mint fee for amount");
1848 
1849         _safeMint(_to, 1, false);
1850     }
1851 
1852     /**
1853     * @dev Mints tokens to an address in batch.
1854     * fee may or may not be required*
1855     * @param _to address of the future owner of the token
1856     * @param _amount number of tokens to mint
1857     */
1858     function mintToMultiple(address _to, uint256 _amount) public payable {
1859         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1860         require(_amount >= 1, "Must mint at least 1 token");
1861         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1862         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1863         
1864         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1865         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 4000");
1866         require(msg.value == getPrice(_amount, _to), "Value below required mint fee for amount");
1867 
1868         _safeMint(_to, _amount, false);
1869     }
1870 
1871     /**
1872      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1873      * fee may or may not be required*
1874      * @param _to address of the future owner of the token
1875      * @param _amount number of tokens to mint
1876      * @param _erc20TokenContract erc-20 token contract to mint with
1877      */
1878     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1879       require(_amount >= 1, "Must mint at least 1 token");
1880       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1881       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 4000");
1882       require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1883       
1884       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1885 
1886       // ERC-20 Specific pre-flight checks
1887       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1888       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1889       IERC20 payableToken = IERC20(_erc20TokenContract);
1890 
1891       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1892       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1893 
1894       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1895       require(transferComplete, "ERC-20 token was unable to be transferred");
1896       
1897       _safeMint(_to, _amount, false);
1898     }
1899 
1900     function openMinting() public onlyTeamOrOwner {
1901         mintingOpen = true;
1902     }
1903 
1904     function stopMinting() public onlyTeamOrOwner {
1905         mintingOpen = false;
1906     }
1907 
1908   
1909     ///////////// ALLOWLIST MINTING FUNCTIONS
1910 
1911     /**
1912     * @dev Mints tokens to an address using an allowlist.
1913     * fee may or may not be required*
1914     * @param _to address of the future owner of the token
1915     * @param _merkleProof merkle proof array
1916     */
1917     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1918         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1919         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1920         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1921         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 4000");
1922         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1923         require(msg.value == getPrice(1, _to), "Value below required mint fee for amount");
1924         
1925 
1926         _safeMint(_to, 1, false);
1927     }
1928 
1929     /**
1930     * @dev Mints tokens to an address using an allowlist.
1931     * fee may or may not be required*
1932     * @param _to address of the future owner of the token
1933     * @param _amount number of tokens to mint
1934     * @param _merkleProof merkle proof array
1935     */
1936     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1937         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1938         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1939         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1940         require(_amount >= 1, "Must mint at least 1 token");
1941         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1942 
1943         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1944         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 4000");
1945         require(msg.value == getPrice(_amount, _to), "Value below required mint fee for amount");
1946         
1947 
1948         _safeMint(_to, _amount, false);
1949     }
1950 
1951     /**
1952     * @dev Mints tokens to an address using an allowlist.
1953     * fee may or may not be required*
1954     * @param _to address of the future owner of the token
1955     * @param _amount number of tokens to mint
1956     * @param _merkleProof merkle proof array
1957     * @param _erc20TokenContract erc-20 token contract to mint with
1958     */
1959     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
1960       require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1961       require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1962       require(_amount >= 1, "Must mint at least 1 token");
1963       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1964       require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1965       require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 4000");
1966       
1967     
1968       // ERC-20 Specific pre-flight checks
1969       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1970       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1971       IERC20 payableToken = IERC20(_erc20TokenContract);
1972     
1973       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1974       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1975       
1976       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1977       require(transferComplete, "ERC-20 token was unable to be transferred");
1978       
1979       _safeMint(_to, _amount, false);
1980     }
1981 
1982     /**
1983      * @dev Enable allowlist minting fully by enabling both flags
1984      * This is a convenience function for the Rampp user
1985      */
1986     function openAllowlistMint() public onlyTeamOrOwner {
1987         enableAllowlistOnlyMode();
1988         mintingOpen = true;
1989     }
1990 
1991     /**
1992      * @dev Close allowlist minting fully by disabling both flags
1993      * This is a convenience function for the Rampp user
1994      */
1995     function closeAllowlistMint() public onlyTeamOrOwner {
1996         disableAllowlistOnlyMode();
1997         mintingOpen = false;
1998     }
1999 
2000 
2001   
2002     /**
2003     * @dev Check if wallet over MAX_WALLET_MINTS
2004     * @param _address address in question to check if minted count exceeds max
2005     */
2006     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2007         require(_amount >= 1, "Amount must be greater than or equal to 1");
2008         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2009     }
2010 
2011     /**
2012     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2013     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2014     */
2015     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2016         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
2017         MAX_WALLET_MINTS = _newWalletMax;
2018     }
2019     
2020 
2021   
2022     /**
2023      * @dev Allows owner to set Max mints per tx
2024      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2025      */
2026      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2027          require(_newMaxMint >= 1, "Max mint must be at least 1");
2028          maxBatchSize = _newMaxMint;
2029      }
2030     
2031 
2032   
2033 
2034   function _baseURI() internal view virtual override returns(string memory) {
2035     return _baseTokenURI;
2036   }
2037 
2038   function _baseURIExtension() internal view virtual override returns(string memory) {
2039     return _baseTokenExtension;
2040   }
2041 
2042   function baseTokenURI() public view returns(string memory) {
2043     return _baseTokenURI;
2044   }
2045 
2046   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2047     _baseTokenURI = baseURI;
2048   }
2049 
2050   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2051     _baseTokenExtension = baseExtension;
2052   }
2053 
2054   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
2055     return ownershipOf(tokenId);
2056   }
2057 }
2058 
2059 
2060   
2061 // File: contracts/BillionaireGatorClubContract.sol
2062 //SPDX-License-Identifier: MIT
2063 
2064 pragma solidity ^0.8.0;
2065 
2066 contract BillionaireGatorClubContract is RamppERC721A {
2067     constructor() RamppERC721A("Billionaire Gator Club", "BGC"){}
2068 }
2069   
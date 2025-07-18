1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 // ████████╗██╗  ██╗███████╗     ██████╗██╗  ██╗██╗███╗   ██╗███████╗███████╗███████╗
5 // ╚══██╔══╝██║  ██║██╔════╝    ██╔════╝██║  ██║██║████╗  ██║██╔════╝██╔════╝██╔════╝
6 //    ██║   ███████║█████╗      ██║     ███████║██║██╔██╗ ██║█████╗  ███████╗█████╗  
7 //    ██║   ██╔══██║██╔══╝      ██║     ██╔══██║██║██║╚██╗██║██╔══╝  ╚════██║██╔══╝  
8 //    ██║   ██║  ██║███████╗    ╚██████╗██║  ██║██║██║ ╚████║███████╗███████║███████╗
9 //    ╚═╝   ╚═╝  ╚═╝╚══════╝     ╚═════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝╚══════╝
10 //
11 //*********************************************************************//
12 //*********************************************************************//
13   
14 //-------------DEPENDENCIES--------------------------//
15 
16 // File: @openzeppelin/contracts/utils/Address.sol
17 
18 
19 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
20 
21 pragma solidity ^0.8.1;
22 
23 /**
24  * @dev Collection of functions related to the address type
25  */
26 library Address {
27     /**
28      * @dev Returns true if account is a contract.
29      *
30      * [IMPORTANT]
31      * ====
32      * It is unsafe to assume that an address for which this function returns
33      * false is an externally-owned account (EOA) and not a contract.
34      *
35      * Among others, isContract will return false for the following
36      * types of addresses:
37      *
38      *  - an externally-owned account
39      *  - a contract in construction
40      *  - an address where a contract will be created
41      *  - an address where a contract lived, but was destroyed
42      * ====
43      *
44      * [IMPORTANT]
45      * ====
46      * You shouldn't rely on isContract to protect against flash loan attacks!
47      *
48      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
49      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
50      * constructor.
51      * ====
52      */
53     function isContract(address account) internal view returns (bool) {
54         // This method relies on extcodesize/address.code.length, which returns 0
55         // for contracts in construction, since the code is only stored at the end
56         // of the constructor execution.
57 
58         return account.code.length > 0;
59     }
60 
61     /**
62      * @dev Replacement for Solidity's transfer: sends amount wei to
63      * recipient, forwarding all available gas and reverting on errors.
64      *
65      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
66      * of certain opcodes, possibly making contracts go over the 2300 gas limit
67      * imposed by transfer, making them unable to receive funds via
68      * transfer. {sendValue} removes this limitation.
69      *
70      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
71      *
72      * IMPORTANT: because control is transferred to recipient, care must be
73      * taken to not create reentrancy vulnerabilities. Consider using
74      * {ReentrancyGuard} or the
75      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
76      */
77     function sendValue(address payable recipient, uint256 amount) internal {
78         require(address(this).balance >= amount, "Address: insufficient balance");
79 
80         (bool success, ) = recipient.call{value: amount}("");
81         require(success, "Address: unable to send value, recipient may have reverted");
82     }
83 
84     /**
85      * @dev Performs a Solidity function call using a low level call. A
86      * plain call is an unsafe replacement for a function call: use this
87      * function instead.
88      *
89      * If target reverts with a revert reason, it is bubbled up by this
90      * function (like regular Solidity function calls).
91      *
92      * Returns the raw returned data. To convert to the expected return value,
93      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
94      *
95      * Requirements:
96      *
97      * - target must be a contract.
98      * - calling target with data must not revert.
99      *
100      * _Available since v3.1._
101      */
102     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
103         return functionCall(target, data, "Address: low-level call failed");
104     }
105 
106     /**
107      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
108      * errorMessage as a fallback revert reason when target reverts.
109      *
110      * _Available since v3.1._
111      */
112     function functionCall(
113         address target,
114         bytes memory data,
115         string memory errorMessage
116     ) internal returns (bytes memory) {
117         return functionCallWithValue(target, data, 0, errorMessage);
118     }
119 
120     /**
121      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
122      * but also transferring value wei to target.
123      *
124      * Requirements:
125      *
126      * - the calling contract must have an ETH balance of at least value.
127      * - the called Solidity function must be payable.
128      *
129      * _Available since v3.1._
130      */
131     function functionCallWithValue(
132         address target,
133         bytes memory data,
134         uint256 value
135     ) internal returns (bytes memory) {
136         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
141      * with errorMessage as a fallback revert reason when target reverts.
142      *
143      * _Available since v3.1._
144      */
145     function functionCallWithValue(
146         address target,
147         bytes memory data,
148         uint256 value,
149         string memory errorMessage
150     ) internal returns (bytes memory) {
151         require(address(this).balance >= value, "Address: insufficient balance for call");
152         require(isContract(target), "Address: call to non-contract");
153 
154         (bool success, bytes memory returndata) = target.call{value: value}(data);
155         return verifyCallResult(success, returndata, errorMessage);
156     }
157 
158     /**
159      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
160      * but performing a static call.
161      *
162      * _Available since v3.3._
163      */
164     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
165         return functionStaticCall(target, data, "Address: low-level static call failed");
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
170      * but performing a static call.
171      *
172      * _Available since v3.3._
173      */
174     function functionStaticCall(
175         address target,
176         bytes memory data,
177         string memory errorMessage
178     ) internal view returns (bytes memory) {
179         require(isContract(target), "Address: static call to non-contract");
180 
181         (bool success, bytes memory returndata) = target.staticcall(data);
182         return verifyCallResult(success, returndata, errorMessage);
183     }
184 
185     /**
186      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
187      * but performing a delegate call.
188      *
189      * _Available since v3.4._
190      */
191     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
192         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
193     }
194 
195     /**
196      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
197      * but performing a delegate call.
198      *
199      * _Available since v3.4._
200      */
201     function functionDelegateCall(
202         address target,
203         bytes memory data,
204         string memory errorMessage
205     ) internal returns (bytes memory) {
206         require(isContract(target), "Address: delegate call to non-contract");
207 
208         (bool success, bytes memory returndata) = target.delegatecall(data);
209         return verifyCallResult(success, returndata, errorMessage);
210     }
211 
212     /**
213      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
214      * revert reason using the provided one.
215      *
216      * _Available since v4.3._
217      */
218     function verifyCallResult(
219         bool success,
220         bytes memory returndata,
221         string memory errorMessage
222     ) internal pure returns (bytes memory) {
223         if (success) {
224             return returndata;
225         } else {
226             // Look for revert reason and bubble it up if present
227             if (returndata.length > 0) {
228                 // The easiest way to bubble the revert reason is using memory via assembly
229 
230                 assembly {
231                     let returndata_size := mload(returndata)
232                     revert(add(32, returndata), returndata_size)
233                 }
234             } else {
235                 revert(errorMessage);
236             }
237         }
238     }
239 }
240 
241 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
242 
243 
244 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
245 
246 pragma solidity ^0.8.0;
247 
248 /**
249  * @title ERC721 token receiver interface
250  * @dev Interface for any contract that wants to support safeTransfers
251  * from ERC721 asset contracts.
252  */
253 interface IERC721Receiver {
254     /**
255      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
256      * by operator from from, this function is called.
257      *
258      * It must return its Solidity selector to confirm the token transfer.
259      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
260      *
261      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
262      */
263     function onERC721Received(
264         address operator,
265         address from,
266         uint256 tokenId,
267         bytes calldata data
268     ) external returns (bytes4);
269 }
270 
271 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
272 
273 
274 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
275 
276 pragma solidity ^0.8.0;
277 
278 /**
279  * @dev Interface of the ERC165 standard, as defined in the
280  * https://eips.ethereum.org/EIPS/eip-165[EIP].
281  *
282  * Implementers can declare support of contract interfaces, which can then be
283  * queried by others ({ERC165Checker}).
284  *
285  * For an implementation, see {ERC165}.
286  */
287 interface IERC165 {
288     /**
289      * @dev Returns true if this contract implements the interface defined by
290      * interfaceId. See the corresponding
291      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
292      * to learn more about how these ids are created.
293      *
294      * This function call must use less than 30 000 gas.
295      */
296     function supportsInterface(bytes4 interfaceId) external view returns (bool);
297 }
298 
299 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
300 
301 
302 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
303 
304 pragma solidity ^0.8.0;
305 
306 
307 /**
308  * @dev Implementation of the {IERC165} interface.
309  *
310  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
311  * for the additional interface id that will be supported. For example:
312  *
313  * solidity
314  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
315  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
316  * }
317  * 
318  *
319  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
320  */
321 abstract contract ERC165 is IERC165 {
322     /**
323      * @dev See {IERC165-supportsInterface}.
324      */
325     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
326         return interfaceId == type(IERC165).interfaceId;
327     }
328 }
329 
330 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
331 
332 
333 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
334 
335 pragma solidity ^0.8.0;
336 
337 
338 /**
339  * @dev Required interface of an ERC721 compliant contract.
340  */
341 interface IERC721 is IERC165 {
342     /**
343      * @dev Emitted when tokenId token is transferred from from to to.
344      */
345     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
346 
347     /**
348      * @dev Emitted when owner enables approved to manage the tokenId token.
349      */
350     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
351 
352     /**
353      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
354      */
355     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
356 
357     /**
358      * @dev Returns the number of tokens in owner's account.
359      */
360     function balanceOf(address owner) external view returns (uint256 balance);
361 
362     /**
363      * @dev Returns the owner of the tokenId token.
364      *
365      * Requirements:
366      *
367      * - tokenId must exist.
368      */
369     function ownerOf(uint256 tokenId) external view returns (address owner);
370 
371     /**
372      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
373      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
374      *
375      * Requirements:
376      *
377      * - from cannot be the zero address.
378      * - to cannot be the zero address.
379      * - tokenId token must exist and be owned by from.
380      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
381      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
382      *
383      * Emits a {Transfer} event.
384      */
385     function safeTransferFrom(
386         address from,
387         address to,
388         uint256 tokenId
389     ) external;
390 
391     /**
392      * @dev Transfers tokenId token from from to to.
393      *
394      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
395      *
396      * Requirements:
397      *
398      * - from cannot be the zero address.
399      * - to cannot be the zero address.
400      * - tokenId token must be owned by from.
401      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
402      *
403      * Emits a {Transfer} event.
404      */
405     function transferFrom(
406         address from,
407         address to,
408         uint256 tokenId
409     ) external;
410 
411     /**
412      * @dev Gives permission to to to transfer tokenId token to another account.
413      * The approval is cleared when the token is transferred.
414      *
415      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
416      *
417      * Requirements:
418      *
419      * - The caller must own the token or be an approved operator.
420      * - tokenId must exist.
421      *
422      * Emits an {Approval} event.
423      */
424     function approve(address to, uint256 tokenId) external;
425 
426     /**
427      * @dev Returns the account approved for tokenId token.
428      *
429      * Requirements:
430      *
431      * - tokenId must exist.
432      */
433     function getApproved(uint256 tokenId) external view returns (address operator);
434 
435     /**
436      * @dev Approve or remove operator as an operator for the caller.
437      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
438      *
439      * Requirements:
440      *
441      * - The operator cannot be the caller.
442      *
443      * Emits an {ApprovalForAll} event.
444      */
445     function setApprovalForAll(address operator, bool _approved) external;
446 
447     /**
448      * @dev Returns if the operator is allowed to manage all of the assets of owner.
449      *
450      * See {setApprovalForAll}
451      */
452     function isApprovedForAll(address owner, address operator) external view returns (bool);
453 
454     /**
455      * @dev Safely transfers tokenId token from from to to.
456      *
457      * Requirements:
458      *
459      * - from cannot be the zero address.
460      * - to cannot be the zero address.
461      * - tokenId token must exist and be owned by from.
462      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
463      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
464      *
465      * Emits a {Transfer} event.
466      */
467     function safeTransferFrom(
468         address from,
469         address to,
470         uint256 tokenId,
471         bytes calldata data
472     ) external;
473 }
474 
475 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
476 
477 
478 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
479 
480 pragma solidity ^0.8.0;
481 
482 
483 /**
484  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
485  * @dev See https://eips.ethereum.org/EIPS/eip-721
486  */
487 interface IERC721Enumerable is IERC721 {
488     /**
489      * @dev Returns the total amount of tokens stored by the contract.
490      */
491     function totalSupply() external view returns (uint256);
492 
493     /**
494      * @dev Returns a token ID owned by owner at a given index of its token list.
495      * Use along with {balanceOf} to enumerate all of owner's tokens.
496      */
497     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
498 
499     /**
500      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
501      * Use along with {totalSupply} to enumerate all tokens.
502      */
503     function tokenByIndex(uint256 index) external view returns (uint256);
504 }
505 
506 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
507 
508 
509 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
510 
511 pragma solidity ^0.8.0;
512 
513 
514 /**
515  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
516  * @dev See https://eips.ethereum.org/EIPS/eip-721
517  */
518 interface IERC721Metadata is IERC721 {
519     /**
520      * @dev Returns the token collection name.
521      */
522     function name() external view returns (string memory);
523 
524     /**
525      * @dev Returns the token collection symbol.
526      */
527     function symbol() external view returns (string memory);
528 
529     /**
530      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
531      */
532     function tokenURI(uint256 tokenId) external view returns (string memory);
533 }
534 
535 // File: @openzeppelin/contracts/utils/Strings.sol
536 
537 
538 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
539 
540 pragma solidity ^0.8.0;
541 
542 /**
543  * @dev String operations.
544  */
545 library Strings {
546     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
547 
548     /**
549      * @dev Converts a uint256 to its ASCII string decimal representation.
550      */
551     function toString(uint256 value) internal pure returns (string memory) {
552         // Inspired by OraclizeAPI's implementation - MIT licence
553         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
554 
555         if (value == 0) {
556             return "0";
557         }
558         uint256 temp = value;
559         uint256 digits;
560         while (temp != 0) {
561             digits++;
562             temp /= 10;
563         }
564         bytes memory buffer = new bytes(digits);
565         while (value != 0) {
566             digits -= 1;
567             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
568             value /= 10;
569         }
570         return string(buffer);
571     }
572 
573     /**
574      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
575      */
576     function toHexString(uint256 value) internal pure returns (string memory) {
577         if (value == 0) {
578             return "0x00";
579         }
580         uint256 temp = value;
581         uint256 length = 0;
582         while (temp != 0) {
583             length++;
584             temp >>= 8;
585         }
586         return toHexString(value, length);
587     }
588 
589     /**
590      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
591      */
592     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
593         bytes memory buffer = new bytes(2 * length + 2);
594         buffer[0] = "0";
595         buffer[1] = "x";
596         for (uint256 i = 2 * length + 1; i > 1; --i) {
597             buffer[i] = _HEX_SYMBOLS[value & 0xf];
598             value >>= 4;
599         }
600         require(value == 0, "Strings: hex length insufficient");
601         return string(buffer);
602     }
603 }
604 
605 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
606 
607 
608 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
609 
610 pragma solidity ^0.8.0;
611 
612 /**
613  * @dev Contract module that helps prevent reentrant calls to a function.
614  *
615  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
616  * available, which can be applied to functions to make sure there are no nested
617  * (reentrant) calls to them.
618  *
619  * Note that because there is a single nonReentrant guard, functions marked as
620  * nonReentrant may not call one another. This can be worked around by making
621  * those functions private, and then adding external nonReentrant entry
622  * points to them.
623  *
624  * TIP: If you would like to learn more about reentrancy and alternative ways
625  * to protect against it, check out our blog post
626  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
627  */
628 abstract contract ReentrancyGuard {
629     // Booleans are more expensive than uint256 or any type that takes up a full
630     // word because each write operation emits an extra SLOAD to first read the
631     // slot's contents, replace the bits taken up by the boolean, and then write
632     // back. This is the compiler's defense against contract upgrades and
633     // pointer aliasing, and it cannot be disabled.
634 
635     // The values being non-zero value makes deployment a bit more expensive,
636     // but in exchange the refund on every call to nonReentrant will be lower in
637     // amount. Since refunds are capped to a percentage of the total
638     // transaction's gas, it is best to keep them low in cases like this one, to
639     // increase the likelihood of the full refund coming into effect.
640     uint256 private constant _NOT_ENTERED = 1;
641     uint256 private constant _ENTERED = 2;
642 
643     uint256 private _status;
644 
645     constructor() {
646         _status = _NOT_ENTERED;
647     }
648 
649     /**
650      * @dev Prevents a contract from calling itself, directly or indirectly.
651      * Calling a nonReentrant function from another nonReentrant
652      * function is not supported. It is possible to prevent this from happening
653      * by making the nonReentrant function external, and making it call a
654      * private function that does the actual work.
655      */
656     modifier nonReentrant() {
657         // On the first call to nonReentrant, _notEntered will be true
658         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
659 
660         // Any calls to nonReentrant after this point will fail
661         _status = _ENTERED;
662 
663         _;
664 
665         // By storing the original value once again, a refund is triggered (see
666         // https://eips.ethereum.org/EIPS/eip-2200)
667         _status = _NOT_ENTERED;
668     }
669 }
670 
671 // File: @openzeppelin/contracts/utils/Context.sol
672 
673 
674 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
675 
676 pragma solidity ^0.8.0;
677 
678 /**
679  * @dev Provides information about the current execution context, including the
680  * sender of the transaction and its data. While these are generally available
681  * via msg.sender and msg.data, they should not be accessed in such a direct
682  * manner, since when dealing with meta-transactions the account sending and
683  * paying for execution may not be the actual sender (as far as an application
684  * is concerned).
685  *
686  * This contract is only required for intermediate, library-like contracts.
687  */
688 abstract contract Context {
689     function _msgSender() internal view virtual returns (address) {
690         return msg.sender;
691     }
692 
693     function _msgData() internal view virtual returns (bytes calldata) {
694         return msg.data;
695     }
696 }
697 
698 // File: @openzeppelin/contracts/access/Ownable.sol
699 
700 
701 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
702 
703 pragma solidity ^0.8.0;
704 
705 
706 /**
707  * @dev Contract module which provides a basic access control mechanism, where
708  * there is an account (an owner) that can be granted exclusive access to
709  * specific functions.
710  *
711  * By default, the owner account will be the one that deploys the contract. This
712  * can later be changed with {transferOwnership}.
713  *
714  * This module is used through inheritance. It will make available the modifier
715  * onlyOwner, which can be applied to your functions to restrict their use to
716  * the owner.
717  */
718 abstract contract Ownable is Context {
719     address private _owner;
720 
721     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
722 
723     /**
724      * @dev Initializes the contract setting the deployer as the initial owner.
725      */
726     constructor() {
727         _transferOwnership(_msgSender());
728     }
729 
730     /**
731      * @dev Returns the address of the current owner.
732      */
733     function owner() public view virtual returns (address) {
734         return _owner;
735     }
736 
737     /**
738      * @dev Throws if called by any account other than the owner.
739      */
740     modifier onlyOwner() {
741         require(owner() == _msgSender(), "Ownable: caller is not the owner");
742         _;
743     }
744 
745     /**
746      * @dev Leaves the contract without owner. It will not be possible to call
747      * onlyOwner functions anymore. Can only be called by the current owner.
748      *
749      * NOTE: Renouncing ownership will leave the contract without an owner,
750      * thereby removing any functionality that is only available to the owner.
751      */
752     function renounceOwnership() public virtual onlyOwner {
753         _transferOwnership(address(0));
754     }
755 
756     /**
757      * @dev Transfers ownership of the contract to a new account (newOwner).
758      * Can only be called by the current owner.
759      */
760     function transferOwnership(address newOwner) public virtual onlyOwner {
761         require(newOwner != address(0), "Ownable: new owner is the zero address");
762         _transferOwnership(newOwner);
763     }
764 
765     /**
766      * @dev Transfers ownership of the contract to a new account (newOwner).
767      * Internal function without access restriction.
768      */
769     function _transferOwnership(address newOwner) internal virtual {
770         address oldOwner = _owner;
771         _owner = newOwner;
772         emit OwnershipTransferred(oldOwner, newOwner);
773     }
774 }
775 //-------------END DEPENDENCIES------------------------//
776 
777 
778   
779 // Rampp Contracts v2.1 (Teams.sol)
780 
781 pragma solidity ^0.8.0;
782 
783 /**
784 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
785 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
786 * This will easily allow cross-collaboration via Rampp.xyz.
787 **/
788 abstract contract Teams is Ownable{
789   mapping (address => bool) internal team;
790 
791   /**
792   * @dev Adds an address to the team. Allows them to execute protected functions
793   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
794   **/
795   function addToTeam(address _address) public onlyOwner {
796     require(_address != address(0), "Invalid address");
797     require(!inTeam(_address), "This address is already in your team.");
798   
799     team[_address] = true;
800   }
801 
802   /**
803   * @dev Removes an address to the team.
804   * @param _address the ETH address to remove, cannot be 0x and must be in team
805   **/
806   function removeFromTeam(address _address) public onlyOwner {
807     require(_address != address(0), "Invalid address");
808     require(inTeam(_address), "This address is not in your team currently.");
809   
810     team[_address] = false;
811   }
812 
813   /**
814   * @dev Check if an address is valid and active in the team
815   * @param _address ETH address to check for truthiness
816   **/
817   function inTeam(address _address)
818     public
819     view
820     returns (bool)
821   {
822     require(_address != address(0), "Invalid address to check.");
823     return team[_address] == true;
824   }
825 
826   /**
827   * @dev Throws if called by any account other than the owner or team member.
828   */
829   modifier onlyTeamOrOwner() {
830     bool _isOwner = owner() == _msgSender();
831     bool _isTeam = inTeam(_msgSender());
832     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
833     _;
834   }
835 }
836 
837 
838   
839   pragma solidity ^0.8.0;
840 
841   /**
842   * @dev These functions deal with verification of Merkle Trees proofs.
843   *
844   * The proofs can be generated using the JavaScript library
845   * https://github.com/miguelmota/merkletreejs[merkletreejs].
846   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
847   *
848   *
849   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
850   * hashing, or use a hash function other than keccak256 for hashing leaves.
851   * This is because the concatenation of a sorted pair of internal nodes in
852   * the merkle tree could be reinterpreted as a leaf value.
853   */
854   library MerkleProof {
855       /**
856       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
857       * defined by 'root'. For this, a 'proof' must be provided, containing
858       * sibling hashes on the branch from the leaf to the root of the tree. Each
859       * pair of leaves and each pair of pre-images are assumed to be sorted.
860       */
861       function verify(
862           bytes32[] memory proof,
863           bytes32 root,
864           bytes32 leaf
865       ) internal pure returns (bool) {
866           return processProof(proof, leaf) == root;
867       }
868 
869       /**
870       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
871       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
872       * hash matches the root of the tree. When processing the proof, the pairs
873       * of leafs & pre-images are assumed to be sorted.
874       *
875       * _Available since v4.4._
876       */
877       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
878           bytes32 computedHash = leaf;
879           for (uint256 i = 0; i < proof.length; i++) {
880               bytes32 proofElement = proof[i];
881               if (computedHash <= proofElement) {
882                   // Hash(current computed hash + current element of the proof)
883                   computedHash = _efficientHash(computedHash, proofElement);
884               } else {
885                   // Hash(current element of the proof + current computed hash)
886                   computedHash = _efficientHash(proofElement, computedHash);
887               }
888           }
889           return computedHash;
890       }
891 
892       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
893           assembly {
894               mstore(0x00, a)
895               mstore(0x20, b)
896               value := keccak256(0x00, 0x40)
897           }
898       }
899   }
900 
901 
902   // File: Allowlist.sol
903 
904   pragma solidity ^0.8.0;
905 
906   abstract contract Allowlist is Teams {
907     bytes32 public merkleRoot;
908     bool public onlyAllowlistMode = false;
909 
910     /**
911      * @dev Update merkle root to reflect changes in Allowlist
912      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
913      */
914     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
915       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
916       merkleRoot = _newMerkleRoot;
917     }
918 
919     /**
920      * @dev Check the proof of an address if valid for merkle root
921      * @param _to address to check for proof
922      * @param _merkleProof Proof of the address to validate against root and leaf
923      */
924     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
925       require(merkleRoot != 0, "Merkle root is not set!");
926       bytes32 leaf = keccak256(abi.encodePacked(_to));
927 
928       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
929     }
930 
931     
932     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
933       onlyAllowlistMode = true;
934     }
935 
936     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
937         onlyAllowlistMode = false;
938     }
939   }
940   
941   
942 /**
943  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
944  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
945  *
946  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
947  * 
948  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
949  *
950  * Does not support burning tokens to address(0).
951  */
952 contract ERC721A is
953   Context,
954   ERC165,
955   IERC721,
956   IERC721Metadata,
957   IERC721Enumerable
958 {
959   using Address for address;
960   using Strings for uint256;
961 
962   struct TokenOwnership {
963     address addr;
964     uint64 startTimestamp;
965   }
966 
967   struct AddressData {
968     uint128 balance;
969     uint128 numberMinted;
970   }
971 
972   uint256 private currentIndex;
973 
974   uint256 public immutable collectionSize;
975   uint256 public maxBatchSize;
976 
977   // Token name
978   string private _name;
979 
980   // Token symbol
981   string private _symbol;
982 
983   // Mapping from token ID to ownership details
984   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
985   mapping(uint256 => TokenOwnership) private _ownerships;
986 
987   // Mapping owner address to address data
988   mapping(address => AddressData) private _addressData;
989 
990   // Mapping from token ID to approved address
991   mapping(uint256 => address) private _tokenApprovals;
992 
993   // Mapping from owner to operator approvals
994   mapping(address => mapping(address => bool)) private _operatorApprovals;
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
1184     return
1185       bytes(baseURI).length > 0
1186         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1187         : "";
1188   }
1189 
1190   /**
1191    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1192    * token will be the concatenation of the baseURI and the tokenId. Empty
1193    * by default, can be overriden in child contracts.
1194    */
1195   function _baseURI() internal view virtual returns (string memory) {
1196     return "";
1197   }
1198 
1199   /**
1200    * @dev See {IERC721-approve}.
1201    */
1202   function approve(address to, uint256 tokenId) public override {
1203     address owner = ERC721A.ownerOf(tokenId);
1204     require(to != owner, "ERC721A: approval to current owner");
1205 
1206     require(
1207       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1208       "ERC721A: approve caller is not owner nor approved for all"
1209     );
1210 
1211     _approve(to, tokenId, owner);
1212   }
1213 
1214   /**
1215    * @dev See {IERC721-getApproved}.
1216    */
1217   function getApproved(uint256 tokenId) public view override returns (address) {
1218     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1219 
1220     return _tokenApprovals[tokenId];
1221   }
1222 
1223   /**
1224    * @dev See {IERC721-setApprovalForAll}.
1225    */
1226   function setApprovalForAll(address operator, bool approved) public override {
1227     require(operator != _msgSender(), "ERC721A: approve to caller");
1228 
1229     _operatorApprovals[_msgSender()][operator] = approved;
1230     emit ApprovalForAll(_msgSender(), operator, approved);
1231   }
1232 
1233   /**
1234    * @dev See {IERC721-isApprovedForAll}.
1235    */
1236   function isApprovedForAll(address owner, address operator)
1237     public
1238     view
1239     virtual
1240     override
1241     returns (bool)
1242   {
1243     return _operatorApprovals[owner][operator];
1244   }
1245 
1246   /**
1247    * @dev See {IERC721-transferFrom}.
1248    */
1249   function transferFrom(
1250     address from,
1251     address to,
1252     uint256 tokenId
1253   ) public override {
1254     _transfer(from, to, tokenId);
1255   }
1256 
1257   /**
1258    * @dev See {IERC721-safeTransferFrom}.
1259    */
1260   function safeTransferFrom(
1261     address from,
1262     address to,
1263     uint256 tokenId
1264   ) public override {
1265     safeTransferFrom(from, to, tokenId, "");
1266   }
1267 
1268   /**
1269    * @dev See {IERC721-safeTransferFrom}.
1270    */
1271   function safeTransferFrom(
1272     address from,
1273     address to,
1274     uint256 tokenId,
1275     bytes memory _data
1276   ) public override {
1277     _transfer(from, to, tokenId);
1278     require(
1279       _checkOnERC721Received(from, to, tokenId, _data),
1280       "ERC721A: transfer to non ERC721Receiver implementer"
1281     );
1282   }
1283 
1284   /**
1285    * @dev Returns whether tokenId exists.
1286    *
1287    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1288    *
1289    * Tokens start existing when they are minted (_mint),
1290    */
1291   function _exists(uint256 tokenId) internal view returns (bool) {
1292     return _startTokenId() <= tokenId && tokenId < currentIndex;
1293   }
1294 
1295   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1296     _safeMint(to, quantity, isAdminMint, "");
1297   }
1298 
1299   /**
1300    * @dev Mints quantity tokens and transfers them to to.
1301    *
1302    * Requirements:
1303    *
1304    * - there must be quantity tokens remaining unminted in the total collection.
1305    * - to cannot be the zero address.
1306    * - quantity cannot be larger than the max batch size.
1307    *
1308    * Emits a {Transfer} event.
1309    */
1310   function _safeMint(
1311     address to,
1312     uint256 quantity,
1313     bool isAdminMint,
1314     bytes memory _data
1315   ) internal {
1316     uint256 startTokenId = currentIndex;
1317     require(to != address(0), "ERC721A: mint to the zero address");
1318     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1319     require(!_exists(startTokenId), "ERC721A: token already minted");
1320 
1321     // For admin mints we do not want to enforce the maxBatchSize limit
1322     if (isAdminMint == false) {
1323         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1324     }
1325 
1326     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1327 
1328     AddressData memory addressData = _addressData[to];
1329     _addressData[to] = AddressData(
1330       addressData.balance + uint128(quantity),
1331       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1332     );
1333     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1334 
1335     uint256 updatedIndex = startTokenId;
1336 
1337     for (uint256 i = 0; i < quantity; i++) {
1338       emit Transfer(address(0), to, updatedIndex);
1339       require(
1340         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1341         "ERC721A: transfer to non ERC721Receiver implementer"
1342       );
1343       updatedIndex++;
1344     }
1345 
1346     currentIndex = updatedIndex;
1347     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1348   }
1349 
1350   /**
1351    * @dev Transfers tokenId from from to to.
1352    *
1353    * Requirements:
1354    *
1355    * - to cannot be the zero address.
1356    * - tokenId token must be owned by from.
1357    *
1358    * Emits a {Transfer} event.
1359    */
1360   function _transfer(
1361     address from,
1362     address to,
1363     uint256 tokenId
1364   ) private {
1365     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1366 
1367     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1368       getApproved(tokenId) == _msgSender() ||
1369       isApprovedForAll(prevOwnership.addr, _msgSender()));
1370 
1371     require(
1372       isApprovedOrOwner,
1373       "ERC721A: transfer caller is not owner nor approved"
1374     );
1375 
1376     require(
1377       prevOwnership.addr == from,
1378       "ERC721A: transfer from incorrect owner"
1379     );
1380     require(to != address(0), "ERC721A: transfer to the zero address");
1381 
1382     _beforeTokenTransfers(from, to, tokenId, 1);
1383 
1384     // Clear approvals from the previous owner
1385     _approve(address(0), tokenId, prevOwnership.addr);
1386 
1387     _addressData[from].balance -= 1;
1388     _addressData[to].balance += 1;
1389     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1390 
1391     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1392     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1393     uint256 nextTokenId = tokenId + 1;
1394     if (_ownerships[nextTokenId].addr == address(0)) {
1395       if (_exists(nextTokenId)) {
1396         _ownerships[nextTokenId] = TokenOwnership(
1397           prevOwnership.addr,
1398           prevOwnership.startTimestamp
1399         );
1400       }
1401     }
1402 
1403     emit Transfer(from, to, tokenId);
1404     _afterTokenTransfers(from, to, tokenId, 1);
1405   }
1406 
1407   /**
1408    * @dev Approve to to operate on tokenId
1409    *
1410    * Emits a {Approval} event.
1411    */
1412   function _approve(
1413     address to,
1414     uint256 tokenId,
1415     address owner
1416   ) private {
1417     _tokenApprovals[tokenId] = to;
1418     emit Approval(owner, to, tokenId);
1419   }
1420 
1421   uint256 public nextOwnerToExplicitlySet = 0;
1422 
1423   /**
1424    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1425    */
1426   function _setOwnersExplicit(uint256 quantity) internal {
1427     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1428     require(quantity > 0, "quantity must be nonzero");
1429     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1430 
1431     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1432     if (endIndex > collectionSize - 1) {
1433       endIndex = collectionSize - 1;
1434     }
1435     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1436     require(_exists(endIndex), "not enough minted yet for this cleanup");
1437     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1438       if (_ownerships[i].addr == address(0)) {
1439         TokenOwnership memory ownership = ownershipOf(i);
1440         _ownerships[i] = TokenOwnership(
1441           ownership.addr,
1442           ownership.startTimestamp
1443         );
1444       }
1445     }
1446     nextOwnerToExplicitlySet = endIndex + 1;
1447   }
1448 
1449   /**
1450    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1451    * The call is not executed if the target address is not a contract.
1452    *
1453    * @param from address representing the previous owner of the given token ID
1454    * @param to target address that will receive the tokens
1455    * @param tokenId uint256 ID of the token to be transferred
1456    * @param _data bytes optional data to send along with the call
1457    * @return bool whether the call correctly returned the expected magic value
1458    */
1459   function _checkOnERC721Received(
1460     address from,
1461     address to,
1462     uint256 tokenId,
1463     bytes memory _data
1464   ) private returns (bool) {
1465     if (to.isContract()) {
1466       try
1467         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1468       returns (bytes4 retval) {
1469         return retval == IERC721Receiver(to).onERC721Received.selector;
1470       } catch (bytes memory reason) {
1471         if (reason.length == 0) {
1472           revert("ERC721A: transfer to non ERC721Receiver implementer");
1473         } else {
1474           assembly {
1475             revert(add(32, reason), mload(reason))
1476           }
1477         }
1478       }
1479     } else {
1480       return true;
1481     }
1482   }
1483 
1484   /**
1485    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1486    *
1487    * startTokenId - the first token id to be transferred
1488    * quantity - the amount to be transferred
1489    *
1490    * Calling conditions:
1491    *
1492    * - When from and to are both non-zero, from's tokenId will be
1493    * transferred to to.
1494    * - When from is zero, tokenId will be minted for to.
1495    */
1496   function _beforeTokenTransfers(
1497     address from,
1498     address to,
1499     uint256 startTokenId,
1500     uint256 quantity
1501   ) internal virtual {}
1502 
1503   /**
1504    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1505    * minting.
1506    *
1507    * startTokenId - the first token id to be transferred
1508    * quantity - the amount to be transferred
1509    *
1510    * Calling conditions:
1511    *
1512    * - when from and to are both non-zero.
1513    * - from and to are never both zero.
1514    */
1515   function _afterTokenTransfers(
1516     address from,
1517     address to,
1518     uint256 startTokenId,
1519     uint256 quantity
1520   ) internal virtual {}
1521 }
1522 
1523 
1524 
1525   
1526 abstract contract Ramppable {
1527   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1528 
1529   modifier isRampp() {
1530       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1531       _;
1532   }
1533 }
1534 
1535 
1536   
1537   
1538 interface IERC20 {
1539   function transfer(address _to, uint256 _amount) external returns (bool);
1540   function balanceOf(address account) external view returns (uint256);
1541 }
1542 
1543 abstract contract Withdrawable is Teams, Ramppable {
1544   address[] public payableAddresses = [RAMPPADDRESS,0x8900a69d2c726051928F9F0f2A27B2CC6432C9a2];
1545   uint256[] public payableFees = [5,95];
1546   uint256 public payableAddressCount = 2;
1547 
1548   function withdrawAll() public onlyTeamOrOwner {
1549       require(address(this).balance > 0);
1550       _withdrawAll();
1551   }
1552   
1553   function withdrawAllRampp() public isRampp {
1554       require(address(this).balance > 0);
1555       _withdrawAll();
1556   }
1557 
1558   function _withdrawAll() private {
1559       uint256 balance = address(this).balance;
1560       
1561       for(uint i=0; i < payableAddressCount; i++ ) {
1562           _widthdraw(
1563               payableAddresses[i],
1564               (balance * payableFees[i]) / 100
1565           );
1566       }
1567   }
1568   
1569   function _widthdraw(address _address, uint256 _amount) private {
1570       (bool success, ) = _address.call{value: _amount}("");
1571       require(success, "Transfer failed.");
1572   }
1573 
1574   /**
1575     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1576     * while still splitting royalty payments to all other team members.
1577     * in the event ERC-20 tokens are paid to the contract.
1578     * @param _tokenContract contract of ERC-20 token to withdraw
1579     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1580     */
1581   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyTeamOrOwner {
1582     require(_amount > 0);
1583     IERC20 tokenContract = IERC20(_tokenContract);
1584     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1585 
1586     for(uint i=0; i < payableAddressCount; i++ ) {
1587         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1588     }
1589   }
1590 
1591   /**
1592   * @dev Allows Rampp wallet to update its own reference as well as update
1593   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1594   * and since Rampp is always the first address this function is limited to the rampp payout only.
1595   * @param _newAddress updated Rampp Address
1596   */
1597   function setRamppAddress(address _newAddress) public isRampp {
1598     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1599     RAMPPADDRESS = _newAddress;
1600     payableAddresses[0] = _newAddress;
1601   }
1602 }
1603 
1604 
1605   
1606 // File: isFeeable.sol
1607 abstract contract Feeable is Teams {
1608   uint256 public PRICE = 0 ether;
1609 
1610   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1611     PRICE = _feeInWei;
1612   }
1613 
1614   function getPrice(uint256 _count) public view returns (uint256) {
1615     return PRICE * _count;
1616   }
1617 }
1618 
1619   
1620   
1621 abstract contract RamppERC721A is 
1622     Ownable,
1623     Teams,
1624     ERC721A,
1625     Withdrawable,
1626     ReentrancyGuard 
1627     , Feeable 
1628     , Allowlist 
1629     
1630 {
1631   constructor(
1632     string memory tokenName,
1633     string memory tokenSymbol
1634   ) ERC721A(tokenName, tokenSymbol, 2, 8888) { }
1635     uint8 public CONTRACT_VERSION = 2;
1636     string public _baseTokenURI = "ipfs://QmXqCF9FvX2aqECVv3DDW52P6yRPNkAouW9Ebcd4hzU3vm/";
1637 
1638     bool public mintingOpen = true;
1639     
1640     
1641     uint256 public MAX_WALLET_MINTS = 2;
1642 
1643   
1644     /////////////// Admin Mint Functions
1645     /**
1646      * @dev Mints a token to an address with a tokenURI.
1647      * This is owner only and allows a fee-free drop
1648      * @param _to address of the future owner of the token
1649      * @param _qty amount of tokens to drop the owner
1650      */
1651      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1652          require(_qty > 0, "Must mint at least 1 token.");
1653          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 8888");
1654          _safeMint(_to, _qty, true);
1655      }
1656 
1657   
1658     /////////////// GENERIC MINT FUNCTIONS
1659     /**
1660     * @dev Mints a single token to an address.
1661     * fee may or may not be required*
1662     * @param _to address of the future owner of the token
1663     */
1664     function mintTo(address _to) public payable {
1665         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 8888");
1666         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1667         
1668         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1669         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1670         
1671         _safeMint(_to, 1, false);
1672     }
1673 
1674     /**
1675     * @dev Mints a token to an address with a tokenURI.
1676     * fee may or may not be required*
1677     * @param _to address of the future owner of the token
1678     * @param _amount number of tokens to mint
1679     */
1680     function mintToMultiple(address _to, uint256 _amount) public payable {
1681         require(_amount >= 1, "Must mint at least 1 token");
1682         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1683         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1684         
1685         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1686         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 8888");
1687         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1688 
1689         _safeMint(_to, _amount, false);
1690     }
1691 
1692     function openMinting() public onlyTeamOrOwner {
1693         mintingOpen = true;
1694     }
1695 
1696     function stopMinting() public onlyTeamOrOwner {
1697         mintingOpen = false;
1698     }
1699 
1700   
1701     ///////////// ALLOWLIST MINTING FUNCTIONS
1702 
1703     /**
1704     * @dev Mints a token to an address with a tokenURI for allowlist.
1705     * fee may or may not be required*
1706     * @param _to address of the future owner of the token
1707     */
1708     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1709         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1710         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1711         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 8888");
1712         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1713         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1714         
1715 
1716         _safeMint(_to, 1, false);
1717     }
1718 
1719     /**
1720     * @dev Mints a token to an address with a tokenURI for allowlist.
1721     * fee may or may not be required*
1722     * @param _to address of the future owner of the token
1723     * @param _amount number of tokens to mint
1724     */
1725     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1726         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1727         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1728         require(_amount >= 1, "Must mint at least 1 token");
1729         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1730 
1731         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1732         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 8888");
1733         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1734         
1735 
1736         _safeMint(_to, _amount, false);
1737     }
1738 
1739     /**
1740      * @dev Enable allowlist minting fully by enabling both flags
1741      * This is a convenience function for the Rampp user
1742      */
1743     function openAllowlistMint() public onlyTeamOrOwner {
1744         enableAllowlistOnlyMode();
1745         mintingOpen = true;
1746     }
1747 
1748     /**
1749      * @dev Close allowlist minting fully by disabling both flags
1750      * This is a convenience function for the Rampp user
1751      */
1752     function closeAllowlistMint() public onlyTeamOrOwner {
1753         disableAllowlistOnlyMode();
1754         mintingOpen = false;
1755     }
1756 
1757 
1758   
1759     /**
1760     * @dev Check if wallet over MAX_WALLET_MINTS
1761     * @param _address address in question to check if minted count exceeds max
1762     */
1763     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1764         require(_amount >= 1, "Amount must be greater than or equal to 1");
1765         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1766     }
1767 
1768     /**
1769     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1770     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1771     */
1772     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
1773         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1774         MAX_WALLET_MINTS = _newWalletMax;
1775     }
1776     
1777 
1778   
1779     /**
1780      * @dev Allows owner to set Max mints per tx
1781      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1782      */
1783      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
1784          require(_newMaxMint >= 1, "Max mint must be at least 1");
1785          maxBatchSize = _newMaxMint;
1786      }
1787     
1788 
1789   
1790 
1791   function _baseURI() internal view virtual override returns(string memory) {
1792     return _baseTokenURI;
1793   }
1794 
1795   function baseTokenURI() public view returns(string memory) {
1796     return _baseTokenURI;
1797   }
1798 
1799   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
1800     _baseTokenURI = baseURI;
1801   }
1802 
1803   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1804     return ownershipOf(tokenId);
1805   }
1806 }
1807 
1808 
1809   
1810 // File: contracts/TheChineseNftContract.sol
1811 //SPDX-License-Identifier: MIT
1812 
1813 pragma solidity ^0.8.0;
1814 
1815 contract TheChineseNftContract is RamppERC721A {
1816     constructor() RamppERC721A("The Chinese NFT", "CHINA"){}
1817 }
1818   
1819 //*********************************************************************//
1820 //*********************************************************************//  
1821 //                       Rampp v2.0.1
1822 //
1823 //         This smart contract was generated by rampp.xyz.
1824 //            Rampp allows creators like you to launch 
1825 //             large scale NFT communities without code!
1826 //
1827 //    Rampp is not responsible for the content of this contract and
1828 //        hopes it is being used in a responsible and kind way.  
1829 //       Rampp is not associated or affiliated with this project.                                                    
1830 //             Twitter: @Rampp_ ---- rampp.xyz
1831 //*********************************************************************//                                                     
1832 //*********************************************************************// 

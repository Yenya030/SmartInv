1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14     uint8 private constant _ADDRESS_LENGTH = 20;
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 
72     /**
73      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
74      */
75     function toHexString(address addr) internal pure returns (string memory) {
76         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
77     }
78 }
79 
80 // File: contracts/IERC721A.sol
81 
82 
83 // ERC721A Contracts v4.2.2
84 // Creator: Chiru Labs
85 
86 pragma solidity ^0.8.4;
87 
88 /**
89  * @dev Interface of ERC721A.
90  */
91 interface IERC721A {
92     /**
93      * The caller must own the token or be an approved operator.
94      */
95     error ApprovalCallerNotOwnerNorApproved();
96 
97     /**
98      * The token does not exist.
99      */
100     error ApprovalQueryForNonexistentToken();
101 
102     /**
103      * Cannot query the balance for the zero address.
104      */
105     error BalanceQueryForZeroAddress();
106 
107     /**
108      * Cannot mint to the zero address.
109      */
110     error MintToZeroAddress();
111 
112     /**
113      * The quantity of tokens minted must be more than zero.
114      */
115     error MintZeroQuantity();
116 
117     /**
118      * The token does not exist.
119      */
120     error OwnerQueryForNonexistentToken();
121 
122     /**
123      * The caller must own the token or be an approved operator.
124      */
125     error TransferCallerNotOwnerNorApproved();
126 
127     /**
128      * The token must be owned by `from`.
129      */
130     error TransferFromIncorrectOwner();
131 
132     /**
133      * Cannot safely transfer to a contract that does not implement the
134      * ERC721Receiver interface.
135      */
136     error TransferToNonERC721ReceiverImplementer();
137 
138     /**
139      * Cannot transfer to the zero address.
140      */
141     error TransferToZeroAddress();
142 
143     /**
144      * The token does not exist.
145      */
146     error URIQueryForNonexistentToken();
147 
148     /**
149      * The `quantity` minted with ERC2309 exceeds the safety limit.
150      */
151     error MintERC2309QuantityExceedsLimit();
152 
153     /**
154      * The `extraData` cannot be set on an unintialized ownership slot.
155      */
156     error OwnershipNotInitializedForExtraData();
157 
158     // =============================================================
159     //                            STRUCTS
160     // =============================================================
161 
162     struct TokenOwnership {
163         // The address of the owner.
164         address addr;
165         // Stores the start time of ownership with minimal overhead for tokenomics.
166         uint64 startTimestamp;
167         // Whether the token has been burned.
168         bool burned;
169         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
170         uint24 extraData;
171     }
172 
173     // =============================================================
174     //                         TOKEN COUNTERS
175     // =============================================================
176 
177     /**
178      * @dev Returns the total number of tokens in existence.
179      * Burned tokens will reduce the count.
180      * To get the total number of tokens minted, please see {_totalMinted}.
181      */
182     function totalSupply() external view returns (uint256);
183 
184     // =============================================================
185     //                            IERC165
186     // =============================================================
187 
188     /**
189      * @dev Returns true if this contract implements the interface defined by
190      * `interfaceId`. See the corresponding
191      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
192      * to learn more about how these ids are created.
193      *
194      * This function call must use less than 30000 gas.
195      */
196     function supportsInterface(bytes4 interfaceId) external view returns (bool);
197 
198     // =============================================================
199     //                            IERC721
200     // =============================================================
201 
202     /**
203      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
204      */
205     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
206 
207     /**
208      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
209      */
210     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
211 
212     /**
213      * @dev Emitted when `owner` enables or disables
214      * (`approved`) `operator` to manage all of its assets.
215      */
216     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
217 
218     /**
219      * @dev Returns the number of tokens in `owner`'s account.
220      */
221     function balanceOf(address owner) external view returns (uint256 balance);
222 
223     /**
224      * @dev Returns the owner of the `tokenId` token.
225      *
226      * Requirements:
227      *
228      * - `tokenId` must exist.
229      */
230     function ownerOf(uint256 tokenId) external view returns (address owner);
231 
232     /**
233      * @dev Safely transfers `tokenId` token from `from` to `to`,
234      * checking first that contract recipients are aware of the ERC721 protocol
235      * to prevent tokens from being forever locked.
236      *
237      * Requirements:
238      *
239      * - `from` cannot be the zero address.
240      * - `to` cannot be the zero address.
241      * - `tokenId` token must exist and be owned by `from`.
242      * - If the caller is not `from`, it must be have been allowed to move
243      * this token by either {approve} or {setApprovalForAll}.
244      * - If `to` refers to a smart contract, it must implement
245      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
246      *
247      * Emits a {Transfer} event.
248      */
249     function safeTransferFrom(
250         address from,
251         address to,
252         uint256 tokenId,
253         bytes calldata data
254     ) external;
255 
256     /**
257      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
258      */
259     function safeTransferFrom(
260         address from,
261         address to,
262         uint256 tokenId
263     ) external;
264 
265     /**
266      * @dev Transfers `tokenId` from `from` to `to`.
267      *
268      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
269      * whenever possible.
270      *
271      * Requirements:
272      *
273      * - `from` cannot be the zero address.
274      * - `to` cannot be the zero address.
275      * - `tokenId` token must be owned by `from`.
276      * - If the caller is not `from`, it must be approved to move this token
277      * by either {approve} or {setApprovalForAll}.
278      *
279      * Emits a {Transfer} event.
280      */
281     function transferFrom(
282         address from,
283         address to,
284         uint256 tokenId
285     ) external;
286 
287     /**
288      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
289      * The approval is cleared when the token is transferred.
290      *
291      * Only a single account can be approved at a time, so approving the
292      * zero address clears previous approvals.
293      *
294      * Requirements:
295      *
296      * - The caller must own the token or be an approved operator.
297      * - `tokenId` must exist.
298      *
299      * Emits an {Approval} event.
300      */
301     function approve(address to, uint256 tokenId) external;
302 
303     /**
304      * @dev Approve or remove `operator` as an operator for the caller.
305      * Operators can call {transferFrom} or {safeTransferFrom}
306      * for any token owned by the caller.
307      *
308      * Requirements:
309      *
310      * - The `operator` cannot be the caller.
311      *
312      * Emits an {ApprovalForAll} event.
313      */
314     function setApprovalForAll(address operator, bool _approved) external;
315 
316     /**
317      * @dev Returns the account approved for `tokenId` token.
318      *
319      * Requirements:
320      *
321      * - `tokenId` must exist.
322      */
323     function getApproved(uint256 tokenId) external view returns (address operator);
324 
325     /**
326      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
327      *
328      * See {setApprovalForAll}.
329      */
330     function isApprovedForAll(address owner, address operator) external view returns (bool);
331 
332     // =============================================================
333     //                        IERC721Metadata
334     // =============================================================
335 
336     /**
337      * @dev Returns the token collection name.
338      */
339     function name() external view returns (string memory);
340 
341     /**
342      * @dev Returns the token collection symbol.
343      */
344     function symbol() external view returns (string memory);
345 
346     /**
347      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
348      */
349     function tokenURI(uint256 tokenId) external view returns (string memory);
350 
351     // =============================================================
352     //                           IERC2309
353     // =============================================================
354 
355     /**
356      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
357      * (inclusive) is transferred from `from` to `to`, as defined in the
358      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
359      *
360      * See {_mintERC2309} for more details.
361      */
362     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
363 }
364 // File: contracts/ERC721A.sol
365 
366 
367 // ERC721A Contracts v4.2.2
368 // Creator: Chiru Labs
369 
370 pragma solidity ^0.8.4;
371 
372 
373 /**
374  * @dev Interface of ERC721 token receiver.
375  */
376 interface ERC721A__IERC721Receiver {
377     function onERC721Received(
378         address operator,
379         address from,
380         uint256 tokenId,
381         bytes calldata data
382     ) external returns (bytes4);
383 }
384 
385 /**
386  * @title ERC721A
387  *
388  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
389  * Non-Fungible Token Standard, including the Metadata extension.
390  * Optimized for lower gas during batch mints.
391  *
392  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
393  * starting from `_startTokenId()`.
394  *
395  * Assumptions:
396  *
397  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
398  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
399  */
400 contract ERC721A is IERC721A {
401     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
402     struct TokenApprovalRef {
403         address value;
404     }
405 
406     // =============================================================
407     //                           CONSTANTS
408     // =============================================================
409 
410     // Mask of an entry in packed address data.
411     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
412 
413     // The bit position of `numberMinted` in packed address data.
414     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
415 
416     // The bit position of `numberBurned` in packed address data.
417     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
418 
419     // The bit position of `aux` in packed address data.
420     uint256 private constant _BITPOS_AUX = 192;
421 
422     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
423     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
424 
425     // The bit position of `startTimestamp` in packed ownership.
426     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
427 
428     // The bit mask of the `burned` bit in packed ownership.
429     uint256 private constant _BITMASK_BURNED = 1 << 224;
430 
431     // The bit position of the `nextInitialized` bit in packed ownership.
432     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
433 
434     // The bit mask of the `nextInitialized` bit in packed ownership.
435     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
436 
437     // The bit position of `extraData` in packed ownership.
438     uint256 private constant _BITPOS_EXTRA_DATA = 232;
439 
440     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
441     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
442 
443     // The mask of the lower 160 bits for addresses.
444     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
445 
446     // The maximum `quantity` that can be minted with {_mintERC2309}.
447     // This limit is to prevent overflows on the address data entries.
448     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
449     // is required to cause an overflow, which is unrealistic.
450     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
451 
452     // The `Transfer` event signature is given by:
453     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
454     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
455         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
456 
457     // =============================================================
458     //                            STORAGE
459     // =============================================================
460 
461     // The next token ID to be minted.
462     uint256 private _currentIndex;
463 
464     // The number of tokens burned.
465     uint256 private _burnCounter;
466 
467     // Token name
468     string private _name;
469 
470     // Token symbol
471     string private _symbol;
472 
473     // Mapping from token ID to ownership details
474     // An empty struct value does not necessarily mean the token is unowned.
475     // See {_packedOwnershipOf} implementation for details.
476     //
477     // Bits Layout:
478     // - [0..159]   `addr`
479     // - [160..223] `startTimestamp`
480     // - [224]      `burned`
481     // - [225]      `nextInitialized`
482     // - [232..255] `extraData`
483     mapping(uint256 => uint256) private _packedOwnerships;
484 
485     // Mapping owner address to address data.
486     //
487     // Bits Layout:
488     // - [0..63]    `balance`
489     // - [64..127]  `numberMinted`
490     // - [128..191] `numberBurned`
491     // - [192..255] `aux`
492     mapping(address => uint256) private _packedAddressData;
493 
494     // Mapping from token ID to approved address.
495     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
496 
497     // Mapping from owner to operator approvals
498     mapping(address => mapping(address => bool)) private _operatorApprovals;
499 
500     // =============================================================
501     //                          CONSTRUCTOR
502     // =============================================================
503 
504     constructor(string memory name_, string memory symbol_) {
505         _name = name_;
506         _symbol = symbol_;
507         _currentIndex = _startTokenId();
508     }
509 
510     // =============================================================
511     //                   TOKEN COUNTING OPERATIONS
512     // =============================================================
513 
514     /**
515      * @dev Returns the starting token ID.
516      * To change the starting token ID, please override this function.
517      */
518     function _startTokenId() internal view virtual returns (uint256) {
519         return 0;
520     }
521 
522     /**
523      * @dev Returns the next token ID to be minted.
524      */
525     function _nextTokenId() internal view virtual returns (uint256) {
526         return _currentIndex;
527     }
528 
529     /**
530      * @dev Returns the total number of tokens in existence.
531      * Burned tokens will reduce the count.
532      * To get the total number of tokens minted, please see {_totalMinted}.
533      */
534     function totalSupply() public view virtual override returns (uint256) {
535         // Counter underflow is impossible as _burnCounter cannot be incremented
536         // more than `_currentIndex - _startTokenId()` times.
537         unchecked {
538             return _currentIndex - _burnCounter - _startTokenId();
539         }
540     }
541 
542     /**
543      * @dev Returns the total amount of tokens minted in the contract.
544      */
545     function _totalMinted() internal view virtual returns (uint256) {
546         // Counter underflow is impossible as `_currentIndex` does not decrement,
547         // and it is initialized to `_startTokenId()`.
548         unchecked {
549             return _currentIndex - _startTokenId();
550         }
551     }
552 
553     /**
554      * @dev Returns the total number of tokens burned.
555      */
556     function _totalBurned() internal view virtual returns (uint256) {
557         return _burnCounter;
558     }
559 
560     // =============================================================
561     //                    ADDRESS DATA OPERATIONS
562     // =============================================================
563 
564     /**
565      * @dev Returns the number of tokens in `owner`'s account.
566      */
567     function balanceOf(address owner) public view virtual override returns (uint256) {
568         if (owner == address(0)) revert BalanceQueryForZeroAddress();
569         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
570     }
571 
572     /**
573      * Returns the number of tokens minted by `owner`.
574      */
575     function _numberMinted(address owner) internal view returns (uint256) {
576         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
577     }
578 
579     /**
580      * Returns the number of tokens burned by or on behalf of `owner`.
581      */
582     function _numberBurned(address owner) internal view returns (uint256) {
583         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
584     }
585 
586     /**
587      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
588      */
589     function _getAux(address owner) internal view returns (uint64) {
590         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
591     }
592 
593     /**
594      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
595      * If there are multiple variables, please pack them into a uint64.
596      */
597     function _setAux(address owner, uint64 aux) internal virtual {
598         uint256 packed = _packedAddressData[owner];
599         uint256 auxCasted;
600         // Cast `aux` with assembly to avoid redundant masking.
601         assembly {
602             auxCasted := aux
603         }
604         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
605         _packedAddressData[owner] = packed;
606     }
607 
608     // =============================================================
609     //                            IERC165
610     // =============================================================
611 
612     /**
613      * @dev Returns true if this contract implements the interface defined by
614      * `interfaceId`. See the corresponding
615      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
616      * to learn more about how these ids are created.
617      *
618      * This function call must use less than 30000 gas.
619      */
620     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
621         // The interface IDs are constants representing the first 4 bytes
622         // of the XOR of all function selectors in the interface.
623         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
624         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
625         return
626             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
627             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
628             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
629     }
630 
631     // =============================================================
632     //                        IERC721Metadata
633     // =============================================================
634 
635     /**
636      * @dev Returns the token collection name.
637      */
638     function name() public view virtual override returns (string memory) {
639         return _name;
640     }
641 
642     /**
643      * @dev Returns the token collection symbol.
644      */
645     function symbol() public view virtual override returns (string memory) {
646         return _symbol;
647     }
648 
649     /**
650      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
651      */
652     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
653         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
654 
655         string memory baseURI = _baseURI();
656         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
657     }
658 
659     /**
660      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
661      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
662      * by default, it can be overridden in child contracts.
663      */
664     function _baseURI() internal view virtual returns (string memory) {
665         return '';
666     }
667 
668     // =============================================================
669     //                     OWNERSHIPS OPERATIONS
670     // =============================================================
671 
672     /**
673      * @dev Returns the owner of the `tokenId` token.
674      *
675      * Requirements:
676      *
677      * - `tokenId` must exist.
678      */
679     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
680         return address(uint160(_packedOwnershipOf(tokenId)));
681     }
682 
683     /**
684      * @dev Gas spent here starts off proportional to the maximum mint batch size.
685      * It gradually moves to O(1) as tokens get transferred around over time.
686      */
687     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
688         return _unpackedOwnership(_packedOwnershipOf(tokenId));
689     }
690 
691     /**
692      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
693      */
694     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
695         return _unpackedOwnership(_packedOwnerships[index]);
696     }
697 
698     /**
699      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
700      */
701     function _initializeOwnershipAt(uint256 index) internal virtual {
702         if (_packedOwnerships[index] == 0) {
703             _packedOwnerships[index] = _packedOwnershipOf(index);
704         }
705     }
706 
707     /**
708      * Returns the packed ownership data of `tokenId`.
709      */
710     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
711         uint256 curr = tokenId;
712 
713         unchecked {
714             if (_startTokenId() <= curr)
715                 if (curr < _currentIndex) {
716                     uint256 packed = _packedOwnerships[curr];
717                     // If not burned.
718                     if (packed & _BITMASK_BURNED == 0) {
719                         // Invariant:
720                         // There will always be an initialized ownership slot
721                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
722                         // before an unintialized ownership slot
723                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
724                         // Hence, `curr` will not underflow.
725                         //
726                         // We can directly compare the packed value.
727                         // If the address is zero, packed will be zero.
728                         while (packed == 0) {
729                             packed = _packedOwnerships[--curr];
730                         }
731                         return packed;
732                     }
733                 }
734         }
735         revert OwnerQueryForNonexistentToken();
736     }
737 
738     /**
739      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
740      */
741     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
742         ownership.addr = address(uint160(packed));
743         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
744         ownership.burned = packed & _BITMASK_BURNED != 0;
745         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
746     }
747 
748     /**
749      * @dev Packs ownership data into a single uint256.
750      */
751     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
752         assembly {
753             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
754             owner := and(owner, _BITMASK_ADDRESS)
755             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
756             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
757         }
758     }
759 
760     /**
761      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
762      */
763     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
764         // For branchless setting of the `nextInitialized` flag.
765         assembly {
766             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
767             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
768         }
769     }
770 
771     // =============================================================
772     //                      APPROVAL OPERATIONS
773     // =============================================================
774 
775     /**
776      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
777      * The approval is cleared when the token is transferred.
778      *
779      * Only a single account can be approved at a time, so approving the
780      * zero address clears previous approvals.
781      *
782      * Requirements:
783      *
784      * - The caller must own the token or be an approved operator.
785      * - `tokenId` must exist.
786      *
787      * Emits an {Approval} event.
788      */
789     function approve(address to, uint256 tokenId) public virtual override {
790         address owner = ownerOf(tokenId);
791 
792         if (_msgSenderERC721A() != owner)
793             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
794                 revert ApprovalCallerNotOwnerNorApproved();
795             }
796 
797         _tokenApprovals[tokenId].value = to;
798         emit Approval(owner, to, tokenId);
799     }
800 
801     /**
802      * @dev Returns the account approved for `tokenId` token.
803      *
804      * Requirements:
805      *
806      * - `tokenId` must exist.
807      */
808     function getApproved(uint256 tokenId) public view virtual override returns (address) {
809         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
810 
811         return _tokenApprovals[tokenId].value;
812     }
813 
814     /**
815      * @dev Approve or remove `operator` as an operator for the caller.
816      * Operators can call {transferFrom} or {safeTransferFrom}
817      * for any token owned by the caller.
818      *
819      * Requirements:
820      *
821      * - The `operator` cannot be the caller.
822      *
823      * Emits an {ApprovalForAll} event.
824      */
825     function setApprovalForAll(address operator, bool approved) public virtual override {
826         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
827         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
828     }
829 
830     /**
831      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
832      *
833      * See {setApprovalForAll}.
834      */
835     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
836         return _operatorApprovals[owner][operator];
837     }
838 
839     /**
840      * @dev Returns whether `tokenId` exists.
841      *
842      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
843      *
844      * Tokens start existing when they are minted. See {_mint}.
845      */
846     function _exists(uint256 tokenId) internal view virtual returns (bool) {
847         return
848             _startTokenId() <= tokenId &&
849             tokenId < _currentIndex && // If within bounds,
850             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
851     }
852 
853     /**
854      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
855      */
856     function _isSenderApprovedOrOwner(
857         address approvedAddress,
858         address owner,
859         address msgSender
860     ) private pure returns (bool result) {
861         assembly {
862             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
863             owner := and(owner, _BITMASK_ADDRESS)
864             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
865             msgSender := and(msgSender, _BITMASK_ADDRESS)
866             // `msgSender == owner || msgSender == approvedAddress`.
867             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
868         }
869     }
870 
871     /**
872      * @dev Returns the storage slot and value for the approved address of `tokenId`.
873      */
874     function _getApprovedSlotAndAddress(uint256 tokenId)
875         private
876         view
877         returns (uint256 approvedAddressSlot, address approvedAddress)
878     {
879         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
880         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
881         assembly {
882             approvedAddressSlot := tokenApproval.slot
883             approvedAddress := sload(approvedAddressSlot)
884         }
885     }
886 
887     // =============================================================
888     //                      TRANSFER OPERATIONS
889     // =============================================================
890 
891     /**
892      * @dev Transfers `tokenId` from `from` to `to`.
893      *
894      * Requirements:
895      *
896      * - `from` cannot be the zero address.
897      * - `to` cannot be the zero address.
898      * - `tokenId` token must be owned by `from`.
899      * - If the caller is not `from`, it must be approved to move this token
900      * by either {approve} or {setApprovalForAll}.
901      *
902      * Emits a {Transfer} event.
903      */
904     function transferFrom(
905         address from,
906         address to,
907         uint256 tokenId
908     ) public virtual override {
909         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
910 
911         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
912 
913         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
914 
915         // The nested ifs save around 20+ gas over a compound boolean condition.
916         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
917             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
918 
919         if (to == address(0)) revert TransferToZeroAddress();
920 
921         _beforeTokenTransfers(from, to, tokenId, 1);
922 
923         // Clear approvals from the previous owner.
924         assembly {
925             if approvedAddress {
926                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
927                 sstore(approvedAddressSlot, 0)
928             }
929         }
930 
931         // Underflow of the sender's balance is impossible because we check for
932         // ownership above and the recipient's balance can't realistically overflow.
933         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
934         unchecked {
935             // We can directly increment and decrement the balances.
936             --_packedAddressData[from]; // Updates: `balance -= 1`.
937             ++_packedAddressData[to]; // Updates: `balance += 1`.
938 
939             // Updates:
940             // - `address` to the next owner.
941             // - `startTimestamp` to the timestamp of transfering.
942             // - `burned` to `false`.
943             // - `nextInitialized` to `true`.
944             _packedOwnerships[tokenId] = _packOwnershipData(
945                 to,
946                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
947             );
948 
949             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
950             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
951                 uint256 nextTokenId = tokenId + 1;
952                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
953                 if (_packedOwnerships[nextTokenId] == 0) {
954                     // If the next slot is within bounds.
955                     if (nextTokenId != _currentIndex) {
956                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
957                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
958                     }
959                 }
960             }
961         }
962 
963         emit Transfer(from, to, tokenId);
964         _afterTokenTransfers(from, to, tokenId, 1);
965     }
966 
967     /**
968      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
969      */
970     function safeTransferFrom(
971         address from,
972         address to,
973         uint256 tokenId
974     ) public virtual override {
975         safeTransferFrom(from, to, tokenId, '');
976     }
977 
978     /**
979      * @dev Safely transfers `tokenId` token from `from` to `to`.
980      *
981      * Requirements:
982      *
983      * - `from` cannot be the zero address.
984      * - `to` cannot be the zero address.
985      * - `tokenId` token must exist and be owned by `from`.
986      * - If the caller is not `from`, it must be approved to move this token
987      * by either {approve} or {setApprovalForAll}.
988      * - If `to` refers to a smart contract, it must implement
989      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
990      *
991      * Emits a {Transfer} event.
992      */
993     function safeTransferFrom(
994         address from,
995         address to,
996         uint256 tokenId,
997         bytes memory _data
998     ) public virtual override {
999         transferFrom(from, to, tokenId);
1000         if (to.code.length != 0)
1001             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1002                 revert TransferToNonERC721ReceiverImplementer();
1003             }
1004     }
1005 
1006     /**
1007      * @dev Hook that is called before a set of serially-ordered token IDs
1008      * are about to be transferred. This includes minting.
1009      * And also called before burning one token.
1010      *
1011      * `startTokenId` - the first token ID to be transferred.
1012      * `quantity` - the amount to be transferred.
1013      *
1014      * Calling conditions:
1015      *
1016      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1017      * transferred to `to`.
1018      * - When `from` is zero, `tokenId` will be minted for `to`.
1019      * - When `to` is zero, `tokenId` will be burned by `from`.
1020      * - `from` and `to` are never both zero.
1021      */
1022     function _beforeTokenTransfers(
1023         address from,
1024         address to,
1025         uint256 startTokenId,
1026         uint256 quantity
1027     ) internal virtual {}
1028 
1029     /**
1030      * @dev Hook that is called after a set of serially-ordered token IDs
1031      * have been transferred. This includes minting.
1032      * And also called after one token has been burned.
1033      *
1034      * `startTokenId` - the first token ID to be transferred.
1035      * `quantity` - the amount to be transferred.
1036      *
1037      * Calling conditions:
1038      *
1039      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1040      * transferred to `to`.
1041      * - When `from` is zero, `tokenId` has been minted for `to`.
1042      * - When `to` is zero, `tokenId` has been burned by `from`.
1043      * - `from` and `to` are never both zero.
1044      */
1045     function _afterTokenTransfers(
1046         address from,
1047         address to,
1048         uint256 startTokenId,
1049         uint256 quantity
1050     ) internal virtual {}
1051 
1052     /**
1053      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1054      *
1055      * `from` - Previous owner of the given token ID.
1056      * `to` - Target address that will receive the token.
1057      * `tokenId` - Token ID to be transferred.
1058      * `_data` - Optional data to send along with the call.
1059      *
1060      * Returns whether the call correctly returned the expected magic value.
1061      */
1062     function _checkContractOnERC721Received(
1063         address from,
1064         address to,
1065         uint256 tokenId,
1066         bytes memory _data
1067     ) private returns (bool) {
1068         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1069             bytes4 retval
1070         ) {
1071             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1072         } catch (bytes memory reason) {
1073             if (reason.length == 0) {
1074                 revert TransferToNonERC721ReceiverImplementer();
1075             } else {
1076                 assembly {
1077                     revert(add(32, reason), mload(reason))
1078                 }
1079             }
1080         }
1081     }
1082 
1083     // =============================================================
1084     //                        MINT OPERATIONS
1085     // =============================================================
1086 
1087     /**
1088      * @dev Mints `quantity` tokens and transfers them to `to`.
1089      *
1090      * Requirements:
1091      *
1092      * - `to` cannot be the zero address.
1093      * - `quantity` must be greater than 0.
1094      *
1095      * Emits a {Transfer} event for each mint.
1096      */
1097     function _mint(address to, uint256 quantity) internal virtual {
1098         uint256 startTokenId = _currentIndex;
1099         if (quantity == 0) revert MintZeroQuantity();
1100 
1101         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1102 
1103         // Overflows are incredibly unrealistic.
1104         // `balance` and `numberMinted` have a maximum limit of 2**64.
1105         // `tokenId` has a maximum limit of 2**256.
1106         unchecked {
1107             // Updates:
1108             // - `balance += quantity`.
1109             // - `numberMinted += quantity`.
1110             //
1111             // We can directly add to the `balance` and `numberMinted`.
1112             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1113 
1114             // Updates:
1115             // - `address` to the owner.
1116             // - `startTimestamp` to the timestamp of minting.
1117             // - `burned` to `false`.
1118             // - `nextInitialized` to `quantity == 1`.
1119             _packedOwnerships[startTokenId] = _packOwnershipData(
1120                 to,
1121                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1122             );
1123 
1124             uint256 toMasked;
1125             uint256 end = startTokenId + quantity;
1126 
1127             // Use assembly to loop and emit the `Transfer` event for gas savings.
1128             // The duplicated `log4` removes an extra check and reduces stack juggling.
1129             // The assembly, together with the surrounding Solidity code, have been
1130             // delicately arranged to nudge the compiler into producing optimized opcodes.
1131             assembly {
1132                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1133                 toMasked := and(to, _BITMASK_ADDRESS)
1134                 // Emit the `Transfer` event.
1135                 log4(
1136                     0, // Start of data (0, since no data).
1137                     0, // End of data (0, since no data).
1138                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1139                     0, // `address(0)`.
1140                     toMasked, // `to`.
1141                     startTokenId // `tokenId`.
1142                 )
1143 
1144                 for {
1145                     let tokenId := add(startTokenId, 1)
1146                 } iszero(eq(tokenId, end)) {
1147                     tokenId := add(tokenId, 1)
1148                 } {
1149                     // Emit the `Transfer` event. Similar to above.
1150                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1151                 }
1152             }
1153             if (toMasked == 0) revert MintToZeroAddress();
1154 
1155             _currentIndex = end;
1156         }
1157         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1158     }
1159 
1160     /**
1161      * @dev Mints `quantity` tokens and transfers them to `to`.
1162      *
1163      * This function is intended for efficient minting only during contract creation.
1164      *
1165      * It emits only one {ConsecutiveTransfer} as defined in
1166      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1167      * instead of a sequence of {Transfer} event(s).
1168      *
1169      * Calling this function outside of contract creation WILL make your contract
1170      * non-compliant with the ERC721 standard.
1171      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1172      * {ConsecutiveTransfer} event is only permissible during contract creation.
1173      *
1174      * Requirements:
1175      *
1176      * - `to` cannot be the zero address.
1177      * - `quantity` must be greater than 0.
1178      *
1179      * Emits a {ConsecutiveTransfer} event.
1180      */
1181     function _mintERC2309(address to, uint256 quantity) internal virtual {
1182         uint256 startTokenId = _currentIndex;
1183         if (to == address(0)) revert MintToZeroAddress();
1184         if (quantity == 0) revert MintZeroQuantity();
1185         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1186 
1187         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1188 
1189         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1190         unchecked {
1191             // Updates:
1192             // - `balance += quantity`.
1193             // - `numberMinted += quantity`.
1194             //
1195             // We can directly add to the `balance` and `numberMinted`.
1196             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1197 
1198             // Updates:
1199             // - `address` to the owner.
1200             // - `startTimestamp` to the timestamp of minting.
1201             // - `burned` to `false`.
1202             // - `nextInitialized` to `quantity == 1`.
1203             _packedOwnerships[startTokenId] = _packOwnershipData(
1204                 to,
1205                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1206             );
1207 
1208             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1209 
1210             _currentIndex = startTokenId + quantity;
1211         }
1212         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1213     }
1214 
1215     /**
1216      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1217      *
1218      * Requirements:
1219      *
1220      * - If `to` refers to a smart contract, it must implement
1221      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1222      * - `quantity` must be greater than 0.
1223      *
1224      * See {_mint}.
1225      *
1226      * Emits a {Transfer} event for each mint.
1227      */
1228     function _safeMint(
1229         address to,
1230         uint256 quantity,
1231         bytes memory _data
1232     ) internal virtual {
1233         _mint(to, quantity);
1234 
1235         unchecked {
1236             if (to.code.length != 0) {
1237                 uint256 end = _currentIndex;
1238                 uint256 index = end - quantity;
1239                 do {
1240                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1241                         revert TransferToNonERC721ReceiverImplementer();
1242                     }
1243                 } while (index < end);
1244                 // Reentrancy protection.
1245                 if (_currentIndex != end) revert();
1246             }
1247         }
1248     }
1249 
1250     /**
1251      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1252      */
1253     function _safeMint(address to, uint256 quantity) internal virtual {
1254         _safeMint(to, quantity, '');
1255     }
1256 
1257     // =============================================================
1258     //                        BURN OPERATIONS
1259     // =============================================================
1260 
1261     /**
1262      * @dev Equivalent to `_burn(tokenId, false)`.
1263      */
1264     function _burn(uint256 tokenId) internal virtual {
1265         _burn(tokenId, false);
1266     }
1267 
1268     /**
1269      * @dev Destroys `tokenId`.
1270      * The approval is cleared when the token is burned.
1271      *
1272      * Requirements:
1273      *
1274      * - `tokenId` must exist.
1275      *
1276      * Emits a {Transfer} event.
1277      */
1278     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1279         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1280 
1281         address from = address(uint160(prevOwnershipPacked));
1282 
1283         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1284 
1285         if (approvalCheck) {
1286             // The nested ifs save around 20+ gas over a compound boolean condition.
1287             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1288                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1289         }
1290 
1291         _beforeTokenTransfers(from, address(0), tokenId, 1);
1292 
1293         // Clear approvals from the previous owner.
1294         assembly {
1295             if approvedAddress {
1296                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1297                 sstore(approvedAddressSlot, 0)
1298             }
1299         }
1300 
1301         // Underflow of the sender's balance is impossible because we check for
1302         // ownership above and the recipient's balance can't realistically overflow.
1303         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1304         unchecked {
1305             // Updates:
1306             // - `balance -= 1`.
1307             // - `numberBurned += 1`.
1308             //
1309             // We can directly decrement the balance, and increment the number burned.
1310             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1311             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1312 
1313             // Updates:
1314             // - `address` to the last owner.
1315             // - `startTimestamp` to the timestamp of burning.
1316             // - `burned` to `true`.
1317             // - `nextInitialized` to `true`.
1318             _packedOwnerships[tokenId] = _packOwnershipData(
1319                 from,
1320                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1321             );
1322 
1323             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1324             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1325                 uint256 nextTokenId = tokenId + 1;
1326                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1327                 if (_packedOwnerships[nextTokenId] == 0) {
1328                     // If the next slot is within bounds.
1329                     if (nextTokenId != _currentIndex) {
1330                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1331                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1332                     }
1333                 }
1334             }
1335         }
1336 
1337         emit Transfer(from, address(0), tokenId);
1338         _afterTokenTransfers(from, address(0), tokenId, 1);
1339 
1340         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1341         unchecked {
1342             _burnCounter++;
1343         }
1344     }
1345 
1346     // =============================================================
1347     //                     EXTRA DATA OPERATIONS
1348     // =============================================================
1349 
1350     /**
1351      * @dev Directly sets the extra data for the ownership data `index`.
1352      */
1353     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1354         uint256 packed = _packedOwnerships[index];
1355         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1356         uint256 extraDataCasted;
1357         // Cast `extraData` with assembly to avoid redundant masking.
1358         assembly {
1359             extraDataCasted := extraData
1360         }
1361         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1362         _packedOwnerships[index] = packed;
1363     }
1364 
1365     /**
1366      * @dev Called during each token transfer to set the 24bit `extraData` field.
1367      * Intended to be overridden by the cosumer contract.
1368      *
1369      * `previousExtraData` - the value of `extraData` before transfer.
1370      *
1371      * Calling conditions:
1372      *
1373      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1374      * transferred to `to`.
1375      * - When `from` is zero, `tokenId` will be minted for `to`.
1376      * - When `to` is zero, `tokenId` will be burned by `from`.
1377      * - `from` and `to` are never both zero.
1378      */
1379     function _extraData(
1380         address from,
1381         address to,
1382         uint24 previousExtraData
1383     ) internal view virtual returns (uint24) {}
1384 
1385     /**
1386      * @dev Returns the next extra data for the packed ownership data.
1387      * The returned result is shifted into position.
1388      */
1389     function _nextExtraData(
1390         address from,
1391         address to,
1392         uint256 prevOwnershipPacked
1393     ) private view returns (uint256) {
1394         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1395         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1396     }
1397 
1398     // =============================================================
1399     //                       OTHER OPERATIONS
1400     // =============================================================
1401 
1402     /**
1403      * @dev Returns the message sender (defaults to `msg.sender`).
1404      *
1405      * If you are writing GSN compatible contracts, you need to override this function.
1406      */
1407     function _msgSenderERC721A() internal view virtual returns (address) {
1408         return msg.sender;
1409     }
1410 
1411     /**
1412      * @dev Converts a uint256 to its ASCII string decimal representation.
1413      */
1414     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1415         assembly {
1416             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1417             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1418             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1419             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1420             let m := add(mload(0x40), 0xa0)
1421             // Update the free memory pointer to allocate.
1422             mstore(0x40, m)
1423             // Assign the `str` to the end.
1424             str := sub(m, 0x20)
1425             // Zeroize the slot after the string.
1426             mstore(str, 0)
1427 
1428             // Cache the end of the memory to calculate the length later.
1429             let end := str
1430 
1431             // We write the string from rightmost digit to leftmost digit.
1432             // The following is essentially a do-while loop that also handles the zero case.
1433             // prettier-ignore
1434             for { let temp := value } 1 {} {
1435                 str := sub(str, 1)
1436                 // Write the character to the pointer.
1437                 // The ASCII index of the '0' character is 48.
1438                 mstore8(str, add(48, mod(temp, 10)))
1439                 // Keep dividing `temp` until zero.
1440                 temp := div(temp, 10)
1441                 // prettier-ignore
1442                 if iszero(temp) { break }
1443             }
1444 
1445             let length := sub(end, str)
1446             // Move the pointer 32 bytes leftwards to make room for the length.
1447             str := sub(str, 0x20)
1448             // Store the length.
1449             mstore(str, length)
1450         }
1451     }
1452 }
1453 // File: @openzeppelin/contracts/utils/Context.sol
1454 
1455 
1456 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1457 
1458 pragma solidity ^0.8.0;
1459 
1460 /**
1461  * @dev Provides information about the current execution context, including the
1462  * sender of the transaction and its data. While these are generally available
1463  * via msg.sender and msg.data, they should not be accessed in such a direct
1464  * manner, since when dealing with meta-transactions the account sending and
1465  * paying for execution may not be the actual sender (as far as an application
1466  * is concerned).
1467  *
1468  * This contract is only required for intermediate, library-like contracts.
1469  */
1470 abstract contract Context {
1471     function _msgSender() internal view virtual returns (address) {
1472         return msg.sender;
1473     }
1474 
1475     function _msgData() internal view virtual returns (bytes calldata) {
1476         return msg.data;
1477     }
1478 }
1479 
1480 // File: @openzeppelin/contracts/access/Ownable.sol
1481 
1482 
1483 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1484 
1485 pragma solidity ^0.8.0;
1486 
1487 
1488 /**
1489  * @dev Contract module which provides a basic access control mechanism, where
1490  * there is an account (an owner) that can be granted exclusive access to
1491  * specific functions.
1492  *
1493  * By default, the owner account will be the one that deploys the contract. This
1494  * can later be changed with {transferOwnership}.
1495  *
1496  * This module is used through inheritance. It will make available the modifier
1497  * `onlyOwner`, which can be applied to your functions to restrict their use to
1498  * the owner.
1499  */
1500 abstract contract Ownable is Context {
1501     address private _owner;
1502 
1503     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1504 
1505     /**
1506      * @dev Initializes the contract setting the deployer as the initial owner.
1507      */
1508     constructor() {
1509         _transferOwnership(_msgSender());
1510     }
1511 
1512     /**
1513      * @dev Throws if called by any account other than the owner.
1514      */
1515     modifier onlyOwner() {
1516         _checkOwner();
1517         _;
1518     }
1519 
1520     /**
1521      * @dev Returns the address of the current owner.
1522      */
1523     function owner() public view virtual returns (address) {
1524         return _owner;
1525     }
1526 
1527     /**
1528      * @dev Throws if the sender is not the owner.
1529      */
1530     function _checkOwner() internal view virtual {
1531         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1532     }
1533 
1534     /**
1535      * @dev Leaves the contract without owner. It will not be possible to call
1536      * `onlyOwner` functions anymore. Can only be called by the current owner.
1537      *
1538      * NOTE: Renouncing ownership will leave the contract without an owner,
1539      * thereby removing any functionality that is only available to the owner.
1540      */
1541     function renounceOwnership() public virtual onlyOwner {
1542         _transferOwnership(address(0));
1543     }
1544 
1545     /**
1546      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1547      * Can only be called by the current owner.
1548      */
1549     function transferOwnership(address newOwner) public virtual onlyOwner {
1550         require(newOwner != address(0), "Ownable: new owner is the zero address");
1551         _transferOwnership(newOwner);
1552     }
1553 
1554     /**
1555      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1556      * Internal function without access restriction.
1557      */
1558     function _transferOwnership(address newOwner) internal virtual {
1559         address oldOwner = _owner;
1560         _owner = newOwner;
1561         emit OwnershipTransferred(oldOwner, newOwner);
1562     }
1563 }
1564 
1565 // File: contracts/TOB.sol
1566 
1567 
1568 pragma solidity ^0.8.4;
1569 
1570 
1571 
1572 
1573 contract theOddlingsBunch is ERC721A, Ownable {
1574   using Strings for uint256;
1575 
1576   string public baseURI;
1577   string public baseExtension = ".json";
1578   string public notRevealedUri;
1579   uint256 public cost = 0.0035 ether;
1580   uint256 public maxSupply = 3500;
1581   uint256 public maxMintAmount = 4;
1582   uint256 public nftPerAddressLimit = 12;
1583   bool public paused = true;
1584   mapping(address => uint256) public addressMintedBalance;
1585 
1586 
1587 
1588   constructor(
1589     string memory _name,
1590     string memory _symbol,
1591     string memory _initBaseURI
1592   ) ERC721A(_name, _symbol) {
1593     setBaseURI(_initBaseURI);
1594   }
1595 
1596   // internal
1597   function _baseURI() internal view virtual override returns (string memory) {
1598     return baseURI;
1599   }
1600 
1601   // owner mint
1602   function ownerMint(uint256 _mintAmount) public onlyOwner {
1603       uint256 supply = totalSupply();
1604       require(_mintAmount > 0, "need to mint at least 1 NFT");
1605       require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1606       _safeMint(_msgSender(), _mintAmount);
1607     }
1608 
1609   // public
1610   function mint(uint256 _mintAmount) public payable {
1611     require(!paused, "the contract is paused");
1612     uint256 supply = totalSupply();
1613     require(_mintAmount > 0, "need to mint at least 1 NFT");
1614     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1615     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1616     require(msg.value >= cost * _mintAmount, "insufficient funds");
1617     require(addressMintedBalance[msg.sender] + _mintAmount <= nftPerAddressLimit, "Wallet address is over the maximum allowed mints");
1618     addressMintedBalance[msg.sender] = addressMintedBalance[msg.sender] + _mintAmount;
1619 
1620     _safeMint(_msgSender(), _mintAmount);
1621 
1622   }
1623   
1624   function tokenURI(uint256 tokenId)
1625     public
1626     view
1627     virtual
1628     override
1629     returns (string memory)
1630   {
1631     require(
1632       _exists(tokenId),
1633       "ERC721Metadata: URI query for nonexistent token"
1634     );
1635     
1636 
1637     string memory currentBaseURI = _baseURI();
1638     return bytes(currentBaseURI).length > 0
1639         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1640         : "";
1641   }
1642 
1643   //only owner
1644 
1645   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1646     nftPerAddressLimit = _limit;
1647   }
1648   
1649     function setCost(uint256 _newCost) public onlyOwner {
1650     cost = _newCost;
1651   } 
1652 
1653   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1654     maxMintAmount = _newmaxMintAmount;
1655   }
1656 
1657   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1658     baseURI = _newBaseURI;
1659   }
1660 
1661   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1662     baseExtension = _newBaseExtension;
1663   }
1664   
1665   function pause(bool _state) public onlyOwner {
1666     paused = _state;
1667   }
1668   
1669    function withdraw() public onlyOwner {
1670     // Do not remove this otherwise you will not be able to withdraw the funds.
1671     // =============================================================================
1672     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1673     require(os);
1674     // =============================================================================
1675   }
1676   
1677   }
1 // Sources flattened with hardhat v2.9.7 https://hardhat.org
2 
3 // File erc721a/contracts/IERC721A.sol@v4.0.0
4 
5 // SPDX-License-Identifier: MIT
6 // ERC721A Contracts v4.0.0
7 // Creator: Chiru Labs
8 
9 pragma solidity ^0.8.4;
10 
11 /**
12  * @dev Interface of an ERC721A compliant contract.
13  */
14 interface IERC721A {
15     /**
16      * The caller must own the token or be an approved operator.
17      */
18     error ApprovalCallerNotOwnerNorApproved();
19 
20     /**
21      * The token does not exist.
22      */
23     error ApprovalQueryForNonexistentToken();
24 
25     /**
26      * The caller cannot approve to their own address.
27      */
28     error ApproveToCaller();
29 
30     /**
31      * The caller cannot approve to the current owner.
32      */
33     error ApprovalToCurrentOwner();
34 
35     /**
36      * Cannot query the balance for the zero address.
37      */
38     error BalanceQueryForZeroAddress();
39 
40     /**
41      * Cannot mint to the zero address.
42      */
43     error MintToZeroAddress();
44 
45     /**
46      * The quantity of tokens minted must be more than zero.
47      */
48     error MintZeroQuantity();
49 
50     /**
51      * The token does not exist.
52      */
53     error OwnerQueryForNonexistentToken();
54 
55     /**
56      * The caller must own the token or be an approved operator.
57      */
58     error TransferCallerNotOwnerNorApproved();
59 
60     /**
61      * The token must be owned by `from`.
62      */
63     error TransferFromIncorrectOwner();
64 
65     /**
66      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
67      */
68     error TransferToNonERC721ReceiverImplementer();
69 
70     /**
71      * Cannot transfer to the zero address.
72      */
73     error TransferToZeroAddress();
74 
75     /**
76      * The token does not exist.
77      */
78     error URIQueryForNonexistentToken();
79 
80     struct TokenOwnership {
81         // The address of the owner.
82         address addr;
83         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
84         uint64 startTimestamp;
85         // Whether the token has been burned.
86         bool burned;
87     }
88 
89     /**
90      * @dev Returns the total amount of tokens stored by the contract.
91      *
92      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
93      */
94     function totalSupply() external view returns (uint256);
95 
96     // ==============================
97     //            IERC165
98     // ==============================
99 
100     /**
101      * @dev Returns true if this contract implements the interface defined by
102      * `interfaceId`. See the corresponding
103      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
104      * to learn more about how these ids are created.
105      *
106      * This function call must use less than 30 000 gas.
107      */
108     function supportsInterface(bytes4 interfaceId) external view returns (bool);
109 
110     // ==============================
111     //            IERC721
112     // ==============================
113 
114     /**
115      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
116      */
117     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
118 
119     /**
120      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
121      */
122     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
123 
124     /**
125      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
126      */
127     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
128 
129     /**
130      * @dev Returns the number of tokens in ``owner``'s account.
131      */
132     function balanceOf(address owner) external view returns (uint256 balance);
133 
134     /**
135      * @dev Returns the owner of the `tokenId` token.
136      *
137      * Requirements:
138      *
139      * - `tokenId` must exist.
140      */
141     function ownerOf(uint256 tokenId) external view returns (address owner);
142 
143     /**
144      * @dev Safely transfers `tokenId` token from `from` to `to`.
145      *
146      * Requirements:
147      *
148      * - `from` cannot be the zero address.
149      * - `to` cannot be the zero address.
150      * - `tokenId` token must exist and be owned by `from`.
151      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
152      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
153      *
154      * Emits a {Transfer} event.
155      */
156     function safeTransferFrom(
157         address from,
158         address to,
159         uint256 tokenId,
160         bytes calldata data
161     ) external;
162 
163     /**
164      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
165      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
166      *
167      * Requirements:
168      *
169      * - `from` cannot be the zero address.
170      * - `to` cannot be the zero address.
171      * - `tokenId` token must exist and be owned by `from`.
172      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
173      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
174      *
175      * Emits a {Transfer} event.
176      */
177     function safeTransferFrom(
178         address from,
179         address to,
180         uint256 tokenId
181     ) external;
182 
183     /**
184      * @dev Transfers `tokenId` token from `from` to `to`.
185      *
186      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
187      *
188      * Requirements:
189      *
190      * - `from` cannot be the zero address.
191      * - `to` cannot be the zero address.
192      * - `tokenId` token must be owned by `from`.
193      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
194      *
195      * Emits a {Transfer} event.
196      */
197     function transferFrom(
198         address from,
199         address to,
200         uint256 tokenId
201     ) external;
202 
203     /**
204      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
205      * The approval is cleared when the token is transferred.
206      *
207      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
208      *
209      * Requirements:
210      *
211      * - The caller must own the token or be an approved operator.
212      * - `tokenId` must exist.
213      *
214      * Emits an {Approval} event.
215      */
216     function approve(address to, uint256 tokenId) external;
217 
218     /**
219      * @dev Approve or remove `operator` as an operator for the caller.
220      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
221      *
222      * Requirements:
223      *
224      * - The `operator` cannot be the caller.
225      *
226      * Emits an {ApprovalForAll} event.
227      */
228     function setApprovalForAll(address operator, bool _approved) external;
229 
230     /**
231      * @dev Returns the account approved for `tokenId` token.
232      *
233      * Requirements:
234      *
235      * - `tokenId` must exist.
236      */
237     function getApproved(uint256 tokenId) external view returns (address operator);
238 
239     /**
240      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
241      *
242      * See {setApprovalForAll}
243      */
244     function isApprovedForAll(address owner, address operator) external view returns (bool);
245 
246     // ==============================
247     //        IERC721Metadata
248     // ==============================
249 
250     /**
251      * @dev Returns the token collection name.
252      */
253     function name() external view returns (string memory);
254 
255     /**
256      * @dev Returns the token collection symbol.
257      */
258     function symbol() external view returns (string memory);
259 
260     /**
261      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
262      */
263     function tokenURI(uint256 tokenId) external view returns (string memory);
264 }
265 
266 
267 // File erc721a/contracts/ERC721A.sol@v4.0.0
268 
269 // ERC721A Contracts v4.0.0
270 // Creator: Chiru Labs
271 
272 pragma solidity ^0.8.4;
273 
274 /**
275  * @dev ERC721 token receiver interface.
276  */
277 interface ERC721A__IERC721Receiver {
278     function onERC721Received(
279         address operator,
280         address from,
281         uint256 tokenId,
282         bytes calldata data
283     ) external returns (bytes4);
284 }
285 
286 /**
287  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
288  * the Metadata extension. Built to optimize for lower gas during batch mints.
289  *
290  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
291  *
292  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
293  *
294  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
295  */
296 contract ERC721A is IERC721A {
297     // Mask of an entry in packed address data.
298     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
299 
300     // The bit position of `numberMinted` in packed address data.
301     uint256 private constant BITPOS_NUMBER_MINTED = 64;
302 
303     // The bit position of `numberBurned` in packed address data.
304     uint256 private constant BITPOS_NUMBER_BURNED = 128;
305 
306     // The bit position of `aux` in packed address data.
307     uint256 private constant BITPOS_AUX = 192;
308 
309     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
310     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
311 
312     // The bit position of `startTimestamp` in packed ownership.
313     uint256 private constant BITPOS_START_TIMESTAMP = 160;
314 
315     // The bit mask of the `burned` bit in packed ownership.
316     uint256 private constant BITMASK_BURNED = 1 << 224;
317     
318     // The bit position of the `nextInitialized` bit in packed ownership.
319     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
320 
321     // The bit mask of the `nextInitialized` bit in packed ownership.
322     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
323 
324     // The tokenId of the next token to be minted.
325     uint256 private _currentIndex;
326 
327     // The number of tokens burned.
328     uint256 private _burnCounter;
329 
330     // Token name
331     string private _name;
332 
333     // Token symbol
334     string private _symbol;
335 
336     // Mapping from token ID to ownership details
337     // An empty struct value does not necessarily mean the token is unowned.
338     // See `_packedOwnershipOf` implementation for details.
339     //
340     // Bits Layout:
341     // - [0..159]   `addr`
342     // - [160..223] `startTimestamp`
343     // - [224]      `burned`
344     // - [225]      `nextInitialized`
345     mapping(uint256 => uint256) private _packedOwnerships;
346 
347     // Mapping owner address to address data.
348     //
349     // Bits Layout:
350     // - [0..63]    `balance`
351     // - [64..127]  `numberMinted`
352     // - [128..191] `numberBurned`
353     // - [192..255] `aux`
354     mapping(address => uint256) private _packedAddressData;
355 
356     // Mapping from token ID to approved address.
357     mapping(uint256 => address) private _tokenApprovals;
358 
359     // Mapping from owner to operator approvals
360     mapping(address => mapping(address => bool)) private _operatorApprovals;
361 
362     constructor(string memory name_, string memory symbol_) {
363         _name = name_;
364         _symbol = symbol_;
365         _currentIndex = _startTokenId();
366     }
367 
368     /**
369      * @dev Returns the starting token ID. 
370      * To change the starting token ID, please override this function.
371      */
372     function _startTokenId() internal view virtual returns (uint256) {
373         return 0;
374     }
375 
376     /**
377      * @dev Returns the next token ID to be minted.
378      */
379     function _nextTokenId() internal view returns (uint256) {
380         return _currentIndex;
381     }
382 
383     /**
384      * @dev Returns the total number of tokens in existence.
385      * Burned tokens will reduce the count. 
386      * To get the total number of tokens minted, please see `_totalMinted`.
387      */
388     function totalSupply() public view override returns (uint256) {
389         // Counter underflow is impossible as _burnCounter cannot be incremented
390         // more than `_currentIndex - _startTokenId()` times.
391         unchecked {
392             return _currentIndex - _burnCounter - _startTokenId();
393         }
394     }
395 
396     /**
397      * @dev Returns the total amount of tokens minted in the contract.
398      */
399     function _totalMinted() internal view returns (uint256) {
400         // Counter underflow is impossible as _currentIndex does not decrement,
401         // and it is initialized to `_startTokenId()`
402         unchecked {
403             return _currentIndex - _startTokenId();
404         }
405     }
406 
407     /**
408      * @dev Returns the total number of tokens burned.
409      */
410     function _totalBurned() internal view returns (uint256) {
411         return _burnCounter;
412     }
413 
414     /**
415      * @dev See {IERC165-supportsInterface}.
416      */
417     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
418         // The interface IDs are constants representing the first 4 bytes of the XOR of
419         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
420         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
421         return
422             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
423             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
424             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
425     }
426 
427     /**
428      * @dev See {IERC721-balanceOf}.
429      */
430     function balanceOf(address owner) public view override returns (uint256) {
431         if (owner == address(0)) revert BalanceQueryForZeroAddress();
432         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
433     }
434 
435     /**
436      * Returns the number of tokens minted by `owner`.
437      */
438     function _numberMinted(address owner) internal view returns (uint256) {
439         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
440     }
441 
442     /**
443      * Returns the number of tokens burned by or on behalf of `owner`.
444      */
445     function _numberBurned(address owner) internal view returns (uint256) {
446         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
447     }
448 
449     /**
450      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
451      */
452     function _getAux(address owner) internal view returns (uint64) {
453         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
454     }
455 
456     /**
457      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
458      * If there are multiple variables, please pack them into a uint64.
459      */
460     function _setAux(address owner, uint64 aux) internal {
461         uint256 packed = _packedAddressData[owner];
462         uint256 auxCasted;
463         assembly { // Cast aux without masking.
464             auxCasted := aux
465         }
466         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
467         _packedAddressData[owner] = packed;
468     }
469 
470     /**
471      * Returns the packed ownership data of `tokenId`.
472      */
473     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
474         uint256 curr = tokenId;
475 
476         unchecked {
477             if (_startTokenId() <= curr)
478                 if (curr < _currentIndex) {
479                     uint256 packed = _packedOwnerships[curr];
480                     // If not burned.
481                     if (packed & BITMASK_BURNED == 0) {
482                         // Invariant:
483                         // There will always be an ownership that has an address and is not burned
484                         // before an ownership that does not have an address and is not burned.
485                         // Hence, curr will not underflow.
486                         //
487                         // We can directly compare the packed value.
488                         // If the address is zero, packed is zero.
489                         while (packed == 0) {
490                             packed = _packedOwnerships[--curr];
491                         }
492                         return packed;
493                     }
494                 }
495         }
496         revert OwnerQueryForNonexistentToken();
497     }
498 
499     /**
500      * Returns the unpacked `TokenOwnership` struct from `packed`.
501      */
502     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
503         ownership.addr = address(uint160(packed));
504         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
505         ownership.burned = packed & BITMASK_BURNED != 0;
506     }
507 
508     /**
509      * Returns the unpacked `TokenOwnership` struct at `index`.
510      */
511     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
512         return _unpackedOwnership(_packedOwnerships[index]);
513     }
514 
515     /**
516      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
517      */
518     function _initializeOwnershipAt(uint256 index) internal {
519         if (_packedOwnerships[index] == 0) {
520             _packedOwnerships[index] = _packedOwnershipOf(index);
521         }
522     }
523 
524     /**
525      * Gas spent here starts off proportional to the maximum mint batch size.
526      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
527      */
528     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
529         return _unpackedOwnership(_packedOwnershipOf(tokenId));
530     }
531 
532     /**
533      * @dev See {IERC721-ownerOf}.
534      */
535     function ownerOf(uint256 tokenId) public view override returns (address) {
536         return address(uint160(_packedOwnershipOf(tokenId)));
537     }
538 
539     /**
540      * @dev See {IERC721Metadata-name}.
541      */
542     function name() public view virtual override returns (string memory) {
543         return _name;
544     }
545 
546     /**
547      * @dev See {IERC721Metadata-symbol}.
548      */
549     function symbol() public view virtual override returns (string memory) {
550         return _symbol;
551     }
552 
553     /**
554      * @dev See {IERC721Metadata-tokenURI}.
555      */
556     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
557         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
558 
559         string memory baseURI = _baseURI();
560         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
561     }
562 
563     /**
564      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
565      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
566      * by default, can be overriden in child contracts.
567      */
568     function _baseURI() internal view virtual returns (string memory) {
569         return '';
570     }
571 
572     /**
573      * @dev Casts the address to uint256 without masking.
574      */
575     function _addressToUint256(address value) private pure returns (uint256 result) {
576         assembly {
577             result := value
578         }
579     }
580 
581     /**
582      * @dev Casts the boolean to uint256 without branching.
583      */
584     function _boolToUint256(bool value) private pure returns (uint256 result) {
585         assembly {
586             result := value
587         }
588     }
589 
590     /**
591      * @dev See {IERC721-approve}.
592      */
593     function approve(address to, uint256 tokenId) public override {
594         address owner = address(uint160(_packedOwnershipOf(tokenId)));
595         if (to == owner) revert ApprovalToCurrentOwner();
596 
597         if (_msgSenderERC721A() != owner)
598             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
599                 revert ApprovalCallerNotOwnerNorApproved();
600             }
601 
602         _tokenApprovals[tokenId] = to;
603         emit Approval(owner, to, tokenId);
604     }
605 
606     /**
607      * @dev See {IERC721-getApproved}.
608      */
609     function getApproved(uint256 tokenId) public view override returns (address) {
610         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
611 
612         return _tokenApprovals[tokenId];
613     }
614 
615     /**
616      * @dev See {IERC721-setApprovalForAll}.
617      */
618     function setApprovalForAll(address operator, bool approved) public virtual override {
619         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
620 
621         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
622         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
623     }
624 
625     /**
626      * @dev See {IERC721-isApprovedForAll}.
627      */
628     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
629         return _operatorApprovals[owner][operator];
630     }
631 
632     /**
633      * @dev See {IERC721-transferFrom}.
634      */
635     function transferFrom(
636         address from,
637         address to,
638         uint256 tokenId
639     ) public virtual override {
640         _transfer(from, to, tokenId);
641     }
642 
643     /**
644      * @dev See {IERC721-safeTransferFrom}.
645      */
646     function safeTransferFrom(
647         address from,
648         address to,
649         uint256 tokenId
650     ) public virtual override {
651         safeTransferFrom(from, to, tokenId, '');
652     }
653 
654     /**
655      * @dev See {IERC721-safeTransferFrom}.
656      */
657     function safeTransferFrom(
658         address from,
659         address to,
660         uint256 tokenId,
661         bytes memory _data
662     ) public virtual override {
663         _transfer(from, to, tokenId);
664         if (to.code.length != 0)
665             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
666                 revert TransferToNonERC721ReceiverImplementer();
667             }
668     }
669 
670     /**
671      * @dev Returns whether `tokenId` exists.
672      *
673      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
674      *
675      * Tokens start existing when they are minted (`_mint`),
676      */
677     function _exists(uint256 tokenId) internal view returns (bool) {
678         return
679             _startTokenId() <= tokenId &&
680             tokenId < _currentIndex && // If within bounds,
681             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
682     }
683 
684     /**
685      * @dev Equivalent to `_safeMint(to, quantity, '')`.
686      */
687     function _safeMint(address to, uint256 quantity) internal {
688         _safeMint(to, quantity, '');
689     }
690 
691     /**
692      * @dev Safely mints `quantity` tokens and transfers them to `to`.
693      *
694      * Requirements:
695      *
696      * - If `to` refers to a smart contract, it must implement
697      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
698      * - `quantity` must be greater than 0.
699      *
700      * Emits a {Transfer} event.
701      */
702     function _safeMint(
703         address to,
704         uint256 quantity,
705         bytes memory _data
706     ) internal {
707         uint256 startTokenId = _currentIndex;
708         if (to == address(0)) revert MintToZeroAddress();
709         if (quantity == 0) revert MintZeroQuantity();
710 
711         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
712 
713         // Overflows are incredibly unrealistic.
714         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
715         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
716         unchecked {
717             // Updates:
718             // - `balance += quantity`.
719             // - `numberMinted += quantity`.
720             //
721             // We can directly add to the balance and number minted.
722             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
723 
724             // Updates:
725             // - `address` to the owner.
726             // - `startTimestamp` to the timestamp of minting.
727             // - `burned` to `false`.
728             // - `nextInitialized` to `quantity == 1`.
729             _packedOwnerships[startTokenId] =
730                 _addressToUint256(to) |
731                 (block.timestamp << BITPOS_START_TIMESTAMP) |
732                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
733 
734             uint256 updatedIndex = startTokenId;
735             uint256 end = updatedIndex + quantity;
736 
737             if (to.code.length != 0) {
738                 do {
739                     emit Transfer(address(0), to, updatedIndex);
740                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
741                         revert TransferToNonERC721ReceiverImplementer();
742                     }
743                 } while (updatedIndex < end);
744                 // Reentrancy protection
745                 if (_currentIndex != startTokenId) revert();
746             } else {
747                 do {
748                     emit Transfer(address(0), to, updatedIndex++);
749                 } while (updatedIndex < end);
750             }
751             _currentIndex = updatedIndex;
752         }
753         _afterTokenTransfers(address(0), to, startTokenId, quantity);
754     }
755 
756     /**
757      * @dev Mints `quantity` tokens and transfers them to `to`.
758      *
759      * Requirements:
760      *
761      * - `to` cannot be the zero address.
762      * - `quantity` must be greater than 0.
763      *
764      * Emits a {Transfer} event.
765      */
766     function _mint(address to, uint256 quantity) internal {
767         uint256 startTokenId = _currentIndex;
768         if (to == address(0)) revert MintToZeroAddress();
769         if (quantity == 0) revert MintZeroQuantity();
770 
771         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
772 
773         // Overflows are incredibly unrealistic.
774         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
775         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
776         unchecked {
777             // Updates:
778             // - `balance += quantity`.
779             // - `numberMinted += quantity`.
780             //
781             // We can directly add to the balance and number minted.
782             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
783 
784             // Updates:
785             // - `address` to the owner.
786             // - `startTimestamp` to the timestamp of minting.
787             // - `burned` to `false`.
788             // - `nextInitialized` to `quantity == 1`.
789             _packedOwnerships[startTokenId] =
790                 _addressToUint256(to) |
791                 (block.timestamp << BITPOS_START_TIMESTAMP) |
792                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
793 
794             uint256 updatedIndex = startTokenId;
795             uint256 end = updatedIndex + quantity;
796 
797             do {
798                 emit Transfer(address(0), to, updatedIndex++);
799             } while (updatedIndex < end);
800 
801             _currentIndex = updatedIndex;
802         }
803         _afterTokenTransfers(address(0), to, startTokenId, quantity);
804     }
805 
806     /**
807      * @dev Transfers `tokenId` from `from` to `to`.
808      *
809      * Requirements:
810      *
811      * - `to` cannot be the zero address.
812      * - `tokenId` token must be owned by `from`.
813      *
814      * Emits a {Transfer} event.
815      */
816     function _transfer(
817         address from,
818         address to,
819         uint256 tokenId
820     ) private {
821         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
822 
823         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
824 
825         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
826             isApprovedForAll(from, _msgSenderERC721A()) ||
827             getApproved(tokenId) == _msgSenderERC721A());
828 
829         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
830         if (to == address(0)) revert TransferToZeroAddress();
831 
832         _beforeTokenTransfers(from, to, tokenId, 1);
833 
834         // Clear approvals from the previous owner.
835         delete _tokenApprovals[tokenId];
836 
837         // Underflow of the sender's balance is impossible because we check for
838         // ownership above and the recipient's balance can't realistically overflow.
839         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
840         unchecked {
841             // We can directly increment and decrement the balances.
842             --_packedAddressData[from]; // Updates: `balance -= 1`.
843             ++_packedAddressData[to]; // Updates: `balance += 1`.
844 
845             // Updates:
846             // - `address` to the next owner.
847             // - `startTimestamp` to the timestamp of transfering.
848             // - `burned` to `false`.
849             // - `nextInitialized` to `true`.
850             _packedOwnerships[tokenId] =
851                 _addressToUint256(to) |
852                 (block.timestamp << BITPOS_START_TIMESTAMP) |
853                 BITMASK_NEXT_INITIALIZED;
854 
855             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
856             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
857                 uint256 nextTokenId = tokenId + 1;
858                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
859                 if (_packedOwnerships[nextTokenId] == 0) {
860                     // If the next slot is within bounds.
861                     if (nextTokenId != _currentIndex) {
862                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
863                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
864                     }
865                 }
866             }
867         }
868 
869         emit Transfer(from, to, tokenId);
870         _afterTokenTransfers(from, to, tokenId, 1);
871     }
872 
873     /**
874      * @dev Equivalent to `_burn(tokenId, false)`.
875      */
876     function _burn(uint256 tokenId) internal virtual {
877         _burn(tokenId, false);
878     }
879 
880     /**
881      * @dev Destroys `tokenId`.
882      * The approval is cleared when the token is burned.
883      *
884      * Requirements:
885      *
886      * - `tokenId` must exist.
887      *
888      * Emits a {Transfer} event.
889      */
890     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
891         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
892 
893         address from = address(uint160(prevOwnershipPacked));
894 
895         if (approvalCheck) {
896             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
897                 isApprovedForAll(from, _msgSenderERC721A()) ||
898                 getApproved(tokenId) == _msgSenderERC721A());
899 
900             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
901         }
902 
903         _beforeTokenTransfers(from, address(0), tokenId, 1);
904 
905         // Clear approvals from the previous owner.
906         delete _tokenApprovals[tokenId];
907 
908         // Underflow of the sender's balance is impossible because we check for
909         // ownership above and the recipient's balance can't realistically overflow.
910         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
911         unchecked {
912             // Updates:
913             // - `balance -= 1`.
914             // - `numberBurned += 1`.
915             //
916             // We can directly decrement the balance, and increment the number burned.
917             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
918             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
919 
920             // Updates:
921             // - `address` to the last owner.
922             // - `startTimestamp` to the timestamp of burning.
923             // - `burned` to `true`.
924             // - `nextInitialized` to `true`.
925             _packedOwnerships[tokenId] =
926                 _addressToUint256(from) |
927                 (block.timestamp << BITPOS_START_TIMESTAMP) |
928                 BITMASK_BURNED | 
929                 BITMASK_NEXT_INITIALIZED;
930 
931             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
932             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
933                 uint256 nextTokenId = tokenId + 1;
934                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
935                 if (_packedOwnerships[nextTokenId] == 0) {
936                     // If the next slot is within bounds.
937                     if (nextTokenId != _currentIndex) {
938                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
939                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
940                     }
941                 }
942             }
943         }
944 
945         emit Transfer(from, address(0), tokenId);
946         _afterTokenTransfers(from, address(0), tokenId, 1);
947 
948         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
949         unchecked {
950             _burnCounter++;
951         }
952     }
953 
954     /**
955      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
956      *
957      * @param from address representing the previous owner of the given token ID
958      * @param to target address that will receive the tokens
959      * @param tokenId uint256 ID of the token to be transferred
960      * @param _data bytes optional data to send along with the call
961      * @return bool whether the call correctly returned the expected magic value
962      */
963     function _checkContractOnERC721Received(
964         address from,
965         address to,
966         uint256 tokenId,
967         bytes memory _data
968     ) private returns (bool) {
969         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
970             bytes4 retval
971         ) {
972             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
973         } catch (bytes memory reason) {
974             if (reason.length == 0) {
975                 revert TransferToNonERC721ReceiverImplementer();
976             } else {
977                 assembly {
978                     revert(add(32, reason), mload(reason))
979                 }
980             }
981         }
982     }
983 
984     /**
985      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
986      * And also called before burning one token.
987      *
988      * startTokenId - the first token id to be transferred
989      * quantity - the amount to be transferred
990      *
991      * Calling conditions:
992      *
993      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
994      * transferred to `to`.
995      * - When `from` is zero, `tokenId` will be minted for `to`.
996      * - When `to` is zero, `tokenId` will be burned by `from`.
997      * - `from` and `to` are never both zero.
998      */
999     function _beforeTokenTransfers(
1000         address from,
1001         address to,
1002         uint256 startTokenId,
1003         uint256 quantity
1004     ) internal virtual {}
1005 
1006     /**
1007      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1008      * minting.
1009      * And also called after one token has been burned.
1010      *
1011      * startTokenId - the first token id to be transferred
1012      * quantity - the amount to be transferred
1013      *
1014      * Calling conditions:
1015      *
1016      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1017      * transferred to `to`.
1018      * - When `from` is zero, `tokenId` has been minted for `to`.
1019      * - When `to` is zero, `tokenId` has been burned by `from`.
1020      * - `from` and `to` are never both zero.
1021      */
1022     function _afterTokenTransfers(
1023         address from,
1024         address to,
1025         uint256 startTokenId,
1026         uint256 quantity
1027     ) internal virtual {}
1028 
1029     /**
1030      * @dev Returns the message sender (defaults to `msg.sender`).
1031      *
1032      * If you are writing GSN compatible contracts, you need to override this function.
1033      */
1034     function _msgSenderERC721A() internal view virtual returns (address) {
1035         return msg.sender;
1036     }
1037 
1038     /**
1039      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1040      */
1041     function _toString(uint256 value) internal pure returns (string memory ptr) {
1042         assembly {
1043             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1044             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1045             // We will need 1 32-byte word to store the length, 
1046             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1047             ptr := add(mload(0x40), 128)
1048             // Update the free memory pointer to allocate.
1049             mstore(0x40, ptr)
1050 
1051             // Cache the end of the memory to calculate the length later.
1052             let end := ptr
1053 
1054             // We write the string from the rightmost digit to the leftmost digit.
1055             // The following is essentially a do-while loop that also handles the zero case.
1056             // Costs a bit more than early returning for the zero case,
1057             // but cheaper in terms of deployment and overall runtime costs.
1058             for { 
1059                 // Initialize and perform the first pass without check.
1060                 let temp := value
1061                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1062                 ptr := sub(ptr, 1)
1063                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1064                 mstore8(ptr, add(48, mod(temp, 10)))
1065                 temp := div(temp, 10)
1066             } temp { 
1067                 // Keep dividing `temp` until zero.
1068                 temp := div(temp, 10)
1069             } { // Body of the for loop.
1070                 ptr := sub(ptr, 1)
1071                 mstore8(ptr, add(48, mod(temp, 10)))
1072             }
1073             
1074             let length := sub(end, ptr)
1075             // Move the pointer 32 bytes leftwards to make room for the length.
1076             ptr := sub(ptr, 32)
1077             // Store the length.
1078             mstore(ptr, length)
1079         }
1080     }
1081 }
1082 
1083 
1084 // File @openzeppelin/contracts/utils/Counters.sol@v4.6.0
1085 
1086 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1087 
1088 pragma solidity ^0.8.0;
1089 
1090 /**
1091  * @title Counters
1092  * @author Matt Condon (@shrugs)
1093  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1094  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1095  *
1096  * Include with `using Counters for Counters.Counter;`
1097  */
1098 library Counters {
1099     struct Counter {
1100         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1101         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1102         // this feature: see https://github.com/ethereum/solidity/issues/4637
1103         uint256 _value; // default: 0
1104     }
1105 
1106     function current(Counter storage counter) internal view returns (uint256) {
1107         return counter._value;
1108     }
1109 
1110     function increment(Counter storage counter) internal {
1111         unchecked {
1112             counter._value += 1;
1113         }
1114     }
1115 
1116     function decrement(Counter storage counter) internal {
1117         uint256 value = counter._value;
1118         require(value > 0, "Counter: decrement overflow");
1119         unchecked {
1120             counter._value = value - 1;
1121         }
1122     }
1123 
1124     function reset(Counter storage counter) internal {
1125         counter._value = 0;
1126     }
1127 }
1128 
1129 
1130 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
1131 
1132 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1133 
1134 pragma solidity ^0.8.0;
1135 
1136 /**
1137  * @dev String operations.
1138  */
1139 library Strings {
1140     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1141 
1142     /**
1143      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1144      */
1145     function toString(uint256 value) internal pure returns (string memory) {
1146         // Inspired by OraclizeAPI's implementation - MIT licence
1147         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1148 
1149         if (value == 0) {
1150             return "0";
1151         }
1152         uint256 temp = value;
1153         uint256 digits;
1154         while (temp != 0) {
1155             digits++;
1156             temp /= 10;
1157         }
1158         bytes memory buffer = new bytes(digits);
1159         while (value != 0) {
1160             digits -= 1;
1161             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1162             value /= 10;
1163         }
1164         return string(buffer);
1165     }
1166 
1167     /**
1168      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1169      */
1170     function toHexString(uint256 value) internal pure returns (string memory) {
1171         if (value == 0) {
1172             return "0x00";
1173         }
1174         uint256 temp = value;
1175         uint256 length = 0;
1176         while (temp != 0) {
1177             length++;
1178             temp >>= 8;
1179         }
1180         return toHexString(value, length);
1181     }
1182 
1183     /**
1184      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1185      */
1186     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1187         bytes memory buffer = new bytes(2 * length + 2);
1188         buffer[0] = "0";
1189         buffer[1] = "x";
1190         for (uint256 i = 2 * length + 1; i > 1; --i) {
1191             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1192             value >>= 4;
1193         }
1194         require(value == 0, "Strings: hex length insufficient");
1195         return string(buffer);
1196     }
1197 }
1198 
1199 
1200 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
1201 
1202 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1203 
1204 pragma solidity ^0.8.0;
1205 
1206 /**
1207  * @dev Provides information about the current execution context, including the
1208  * sender of the transaction and its data. While these are generally available
1209  * via msg.sender and msg.data, they should not be accessed in such a direct
1210  * manner, since when dealing with meta-transactions the account sending and
1211  * paying for execution may not be the actual sender (as far as an application
1212  * is concerned).
1213  *
1214  * This contract is only required for intermediate, library-like contracts.
1215  */
1216 abstract contract Context {
1217     function _msgSender() internal view virtual returns (address) {
1218         return msg.sender;
1219     }
1220 
1221     function _msgData() internal view virtual returns (bytes calldata) {
1222         return msg.data;
1223     }
1224 }
1225 
1226 
1227 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
1228 
1229 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1230 
1231 pragma solidity ^0.8.0;
1232 
1233 /**
1234  * @dev Contract module which provides a basic access control mechanism, where
1235  * there is an account (an owner) that can be granted exclusive access to
1236  * specific functions.
1237  *
1238  * By default, the owner account will be the one that deploys the contract. This
1239  * can later be changed with {transferOwnership}.
1240  *
1241  * This module is used through inheritance. It will make available the modifier
1242  * `onlyOwner`, which can be applied to your functions to restrict their use to
1243  * the owner.
1244  */
1245 abstract contract Ownable is Context {
1246     address private _owner;
1247 
1248     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1249 
1250     /**
1251      * @dev Initializes the contract setting the deployer as the initial owner.
1252      */
1253     constructor() {
1254         _transferOwnership(_msgSender());
1255     }
1256 
1257     /**
1258      * @dev Returns the address of the current owner.
1259      */
1260     function owner() public view virtual returns (address) {
1261         return _owner;
1262     }
1263 
1264     /**
1265      * @dev Throws if called by any account other than the owner.
1266      */
1267     modifier onlyOwner() {
1268         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1269         _;
1270     }
1271 
1272     /**
1273      * @dev Leaves the contract without owner. It will not be possible to call
1274      * `onlyOwner` functions anymore. Can only be called by the current owner.
1275      *
1276      * NOTE: Renouncing ownership will leave the contract without an owner,
1277      * thereby removing any functionality that is only available to the owner.
1278      */
1279     function renounceOwnership() public virtual onlyOwner {
1280         _transferOwnership(address(0));
1281     }
1282 
1283     /**
1284      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1285      * Can only be called by the current owner.
1286      */
1287     function transferOwnership(address newOwner) public virtual onlyOwner {
1288         require(newOwner != address(0), "Ownable: new owner is the zero address");
1289         _transferOwnership(newOwner);
1290     }
1291 
1292     /**
1293      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1294      * Internal function without access restriction.
1295      */
1296     function _transferOwnership(address newOwner) internal virtual {
1297         address oldOwner = _owner;
1298         _owner = newOwner;
1299         emit OwnershipTransferred(oldOwner, newOwner);
1300     }
1301 }
1302 
1303 
1304 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1305 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1306 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1307 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╡│││╠╬╡│╠╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╡│╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1308 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╡│╞╬╡┤│││┤╠╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╡│┤┤╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1309 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╡┤┤┤╞╬╬╬╡┤┤┤╠╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╡┤┤┤┤┤╬╬╬╬┤┤┤┤╬╬╬╬╬╬╬╬╬╬╬╬
1310 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╡┤┤┤╞╬╬╬╬╬╩╩╡┤╬╬╬╬╬╬╩╩┤┤╬╬╬╬╩╡││││┤╚╩╡┤╠╬╡┤┤┤╬╬╩╩┤┤││╬╬╬╬╬╬╬╬╬╬╬╬
1311 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╩╡┤┤┤├╩╩╩╩╩╡┤┤┤╬╬╬╬╬╬┤┤┤┤╬╬╩╡┤╞╬╬╬╡╡╡┤┤┤╠╬╡┤┤┤╩╩┤┤┤┤╩╩╬╬╬╬╬╬╬╬╬╬╬╬
1312 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╪╪╡┤┤┤├╪╪╪╪╪╡┤┤┤╬╬╬╬╬╬┤┤┤┤╬╡┤┤┤╞╬╬╬╬╬╪╪╪╪╬╬╡┤┤┤┤┤╪╪┤┤┤┤╙╚╬╬╬╬╬╬╬╬╬╬
1313 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╡┤┤┤╞╬╬╬╬╬╡┤┤┤╬╬╬╬╬╬┤┤┤┤╬╡┤┤┤╞╬╬╬╬╬╬╬╬╬╬╬╡┤┤┤╪╪╬╬╪╪┤┤┤╞╬╬╬╬╬╬╬╬╬╬
1314 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╡┤┤┤╞╬╬╬╬╬╡┤┤┤╬╬╬╬││┤┤┤┤╬╡┤┤┤││╠╬╬╬╬╬╬╬╬╬╡┤┤┤╬╬╬╬╬╬┤┤┤╞╬╬╬╬╬╬╬╬╬╬
1315 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╡┤┤┤││╠╬╬╬╡┤┤┤││││╬╬┤┤┤┤││╬╡┤┤┤││╠╬╬╬╡│╠╬╡┤┤┤││╬╬╬╬┤┤┤││╞╬╬╬╬╬╬╬╬
1316 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╡┤┤┤╞╬╬╬╬╬╬╬╡┤┤┤╬╬╬╬┤┤┤┤╬╬╬╬╬╡┤┤┤┤┤┤┤╠╬╬╬╡┤┤┤╬╬╬╬╬╬┤┤┤╞╬╬╬╬╬╬╬╬╬╬
1317 // ╬╬╬╬╬╬╬╬╩╩╬╬╬╬╬╬╬╬╩╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╩╩╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1318 // ╬╬╬╬╬╬╡│┤┤╬╬╬╬╬╬││┤╞╬╬╬╬╬╬╬╬╬╬╬╬╬╡│┤┤╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1319 // ╬╬╬╬╡│┤┤┤┤╬╬╬╬││┤┤┤╞╬╬╬╬╬╬╬╬╬╬╬╬╬╡┤╪╪╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1320 // ╬╬╬╬╬╬┤┤┤┤╬╬╬╬╬╡┤┤┤╞╬╬╬╡│││╠╬╬╬╬╬╬╬╬╬╬╬╬╬│││││││╠╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1321 // ╬╬╬╬╡┤┤┤┤┤┤┤┤┤╬╡┤┤┤╞╬╡┤┤┤┤┤┤┤╠╬╬╬╬╬┤┤╬╬┤┤┤┤╬╬╬╡┤┤┤╞╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1322 // ╬╬╬╬╬╬╡┤┤┤╬╬╬╬╬╡┤┤┤││╞╬╬╬╡┤┤┤╠╬╬╬╡┤┤┤╬╬││┤┤┤┤╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1323 // ╬╬╬╬╬╬╡┤┤┤╬╬╬╬╬╡┤┤┤╞╬╬╬╬╬╡┤┤┤╠╬╡╡┤┤┤┤╬╬╬╬╡│┤┤┤├╩╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1324 // ╬╬╬╬╬╬╡┤┤┤╬╬╩╩╬╡┤┤┤╞╬╬╬╬╬╡┤┤┤╠╬╬╬╡┤┤┤╬╬╩╩╬╬╡╡┤┤┤│╩╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1325 // ╬╬╬╬╬╬╡┤┤┤╙│╪╪╬╡┤┤┤╞╬╬╬╬╬╡┤┤┤│╙╠╬╡┤┤┤╙╙┤┤╙╙╬╬╪╡┤┤┤╞╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1326 // ╬╬╬╬╬╬╡┤┤┤╪╪╬╬╬╡┤┤┤╞╬╬╬╬╬╡┤┤┤╪╪╬╬╡┤┤┤╪╪╪╪┤┤││││┤╞╪╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1327 // ╬╬╬╬╬╬╬╪╪╪╬╬╬╬╬╬╪╪╪╬╬╬╬╬╬╬╪╪╪╬╬╬╬╬╪╪╪╬╬╬╬╪╪╪╪╪╪╪╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1328 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╩╩││┤┤╩╩┤┤╬╬╩╡┤╞╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1329 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╩╩┤┤╬╬╡╡┤┤┤┤╩╡┤┤┤╞╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1330 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╙╩╬╬╬╬╙╙╙╙╙╠╬╬╬╡┤┤┤╬╬╬╬╪╪╪╪╪╡┤┤┤╞╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1331 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬││┤├╬╡│╞╪╡┤┤┤╠╬╬╬╡┤┤┤╬╬╬╬╬╬╬╬││┤┤┤││││╠╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1332 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬││┤┤┤││╞╪╬╬╡┤┤┤╠╬╡││┤┤┤││││╬╬╬╬╪╡┤┤┤╞╪╪╪╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1333 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬┤┤┤├╬╬╬╬╬╡┤┤┤╠╬╬╬╡┤┤┤╬╬╬╬╬╬╬╬╬╡┤┤┤╞╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1334 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬┤┤┤├╬╬╬╬╬╡┤┤┤╠╬╬╬╡┤┤┤╬╬╬╬╬╬╬╬╬╡┤┤┤╞╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1335 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬┤┤┤├╩╬╬╬╬╡┤┤┤╚╩╬╬╡┤┤┤╩╩╬╬╬╬╬╬╬╡┤┤┤╞╩╡│╠╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1336 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬┤┤┤│╡╬╬╬╬╡┤┤┤┤╡╠╬╡┤┤┤╡╡╬╬╬╬╬╬╬╡┤┤┤│╡╠╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1337 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╡╡╡╪╬╬╬╬╬╡╡╡╡╬╬╬╬╡╡╡╡╬╬╬╬╬╬╬╬╬╡╡╡╡╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1338 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1339 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
1340 
1341 pragma solidity >=0.7.0 <0.9.0;
1342 
1343 
1344 
1345 
1346 contract Fuck is Ownable, ERC721A {
1347     bool public publicSale = false;
1348     bool public revealed = true;
1349 
1350     uint256 public maxPerTx = 10;
1351     uint256 public maxPerAddress = 20;
1352     uint256 public maxToken = 6969;
1353     uint256 public price = 0.0069 ether;
1354 
1355     string private _baseTokenURI;
1356     string public notRevealedUri = "";
1357 
1358     bytes32 root;
1359 
1360     mapping (address => bool) public freeMinted;
1361 
1362     constructor() ERC721A("fuck (this nft)", "FUCK") {}  
1363 
1364     modifier callerIsUser() {
1365         require(tx.origin == msg.sender, "The caller is another contract");
1366         _;
1367     }
1368 
1369     function numberMinted(address owner) public view returns (uint256) {
1370         return _numberMinted(owner);
1371     }
1372 
1373     function getOwnershipData(uint256 tokenId)
1374         external
1375         view
1376         returns (TokenOwnership memory)
1377     {
1378         return _ownershipOf(tokenId);
1379     }
1380 
1381     function tokenURI(uint256 tokenId)
1382         public
1383         view
1384         virtual
1385         override
1386         returns (string memory)
1387     {
1388         require(
1389             _exists(tokenId),
1390             "ERC721Metadata: URI query for nonexistent token"
1391         );
1392 
1393         if (revealed == false) {
1394             return notRevealedUri;
1395         }
1396 
1397         string memory _tokenURI = super.tokenURI(tokenId);
1398         return
1399             bytes(_tokenURI).length > 0
1400                 ? string(abi.encodePacked(_tokenURI, ".json"))
1401                 : "";
1402     }
1403 
1404     function mint(uint256 quantity) external payable callerIsUser {
1405         require(numberMinted(msg.sender) + quantity <= maxPerAddress, "You have enough fucks in your wallet already.");
1406         require(quantity > 0, "Invalid quantity of fucks");
1407         require(quantity <= maxPerTx, "Can't mint that many fucks");
1408         require(totalSupply() + quantity < maxToken, "Not enough fucks to mint");
1409         if(freeMinted[msg.sender]){
1410             require(msg.value >= price * quantity, "Need more fucking eth");
1411         }else{
1412             require(msg.value >= (price * quantity) - price, "Need more fucking eth");
1413             freeMinted[msg.sender] = true;
1414         }
1415         _safeMint(msg.sender, quantity);
1416     }
1417 
1418     function ownerMint(address _address, uint256 quantity) external onlyOwner {
1419         require(totalSupply() + quantity <= maxToken, "Not enough fucks to mint");
1420         _safeMint(_address, quantity);
1421     }
1422 
1423     function _baseURI() internal view virtual override returns (string memory) {
1424         return _baseTokenURI;
1425     }
1426 
1427     function setPrice(uint256 _PriceInWEI) external onlyOwner {
1428         price = _PriceInWEI;
1429     }
1430 
1431     function flipPublicSaleState() external onlyOwner {
1432         publicSale = !publicSale;
1433     }
1434 
1435     function setBaseURI(string calldata baseURI) external onlyOwner {
1436         _baseTokenURI = baseURI;
1437     }
1438 
1439     function setNotRevealedURI(string memory _notRevealedURI) external onlyOwner {
1440         notRevealedUri = _notRevealedURI;
1441     }
1442 
1443     function reveal() external onlyOwner {
1444         revealed = !revealed;
1445     }
1446 
1447     function withdraw() external onlyOwner {
1448         payable(msg.sender).transfer(address(this).balance);
1449     }
1450 }
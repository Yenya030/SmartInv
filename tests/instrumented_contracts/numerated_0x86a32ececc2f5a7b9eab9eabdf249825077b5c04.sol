1 /**
2  *Submitted for verification at Etherscan.io on 2022-01-21
3 */
4 
5 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
6 
7 // SPDX-License-Identifier: MIT
8 
9 // pragma solidity ^0.8.0;
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
68     function transferFrom(
69         address sender,
70         address recipient,
71         uint256 amount
72     ) external returns (bool);
73 
74     /**
75      * @dev Emitted when `value` tokens are moved from one account (`from`) to
76      * another (`to`).
77      *
78      * Note that `value` may be zero.
79      */
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     /**
83      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
84      * a call to {approve}. `value` is the new allowance.
85      */
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 
90 // Dependency file: @openzeppelin/contracts/utils/Context.sol
91 
92 
93 // pragma solidity ^0.8.0;
94 
95 /**
96  * @dev Provides information about the current execution context, including the
97  * sender of the transaction and its data. While these are generally available
98  * via msg.sender and msg.data, they should not be accessed in such a direct
99  * manner, since when dealing with meta-transactions the account sending and
100  * paying for execution may not be the actual sender (as far as an application
101  * is concerned).
102  *
103  * This contract is only required for intermediate, library-like contracts.
104  */
105 abstract contract Context {
106     function _msgSender() internal view virtual returns (address) {
107         return msg.sender;
108     }
109 
110     function _msgData() internal view virtual returns (bytes calldata) {
111         return msg.data;
112     }
113 }
114 
115 
116 // Dependency file: @openzeppelin/contracts/access/Ownable.sol
117 
118 
119 // pragma solidity ^0.8.0;
120 
121 // import "@openzeppelin/contracts/utils/Context.sol";
122 
123 /**
124  * @dev Contract module which provides a basic access control mechanism, where
125  * there is an account (an owner) that can be granted exclusive access to
126  * specific functions.
127  *
128  * By default, the owner account will be the one that deploys the contract. This
129  * can later be changed with {transferOwnership}.
130  *
131  * This module is used through inheritance. It will make available the modifier
132  * `onlyOwner`, which can be applied to your functions to restrict their use to
133  * the owner.
134  */
135 abstract contract Ownable is Context {
136     address private _owner;
137 
138     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
139 
140     /**
141      * @dev Initializes the contract setting the deployer as the initial owner.
142      */
143     constructor() {
144         _setOwner(_msgSender());
145     }
146 
147     /**
148      * @dev Returns the address of the current owner.
149      */
150     function owner() public view virtual returns (address) {
151         return _owner;
152     }
153 
154     /**
155      * @dev Throws if called by any account other than the owner.
156      */
157     modifier onlyOwner() {
158         require(owner() == _msgSender(), "Ownable: caller is not the owner");
159         _;
160     }
161 
162     /**
163      * @dev Leaves the contract without owner. It will not be possible to call
164      * `onlyOwner` functions anymore. Can only be called by the current owner.
165      *
166      * NOTE: Renouncing ownership will leave the contract without an owner,
167      * thereby removing any functionality that is only available to the owner.
168      */
169     function renounceOwnership() public virtual onlyOwner {
170         _setOwner(address(0));
171     }
172 
173     /**
174      * @dev Transfers ownership of the contract to a new account (`newOwner`).
175      * Can only be called by the current owner.
176      */
177     function transferOwnership(address newOwner) public virtual onlyOwner {
178         require(newOwner != address(0), "Ownable: new owner is the zero address");
179         _setOwner(newOwner);
180     }
181 
182     function _setOwner(address newOwner) private {
183         address oldOwner = _owner;
184         _owner = newOwner;
185         emit OwnershipTransferred(oldOwner, newOwner);
186     }
187 }
188 
189 
190 // Dependency file: @openzeppelin/contracts/utils/math/SafeMath.sol
191 
192 
193 // pragma solidity ^0.8.0;
194 
195 // CAUTION
196 // This version of SafeMath should only be used with Solidity 0.8 or later,
197 // because it relies on the compiler's built in overflow checks.
198 
199 /**
200  * @dev Wrappers over Solidity's arithmetic operations.
201  *
202  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
203  * now has built in overflow checking.
204  */
205 library SafeMath {
206     /**
207      * @dev Returns the addition of two unsigned integers, with an overflow flag.
208      *
209      * _Available since v3.4._
210      */
211     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
212         unchecked {
213             uint256 c = a + b;
214             if (c < a) return (false, 0);
215             return (true, c);
216         }
217     }
218 
219     /**
220      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
221      *
222      * _Available since v3.4._
223      */
224     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
225         unchecked {
226             if (b > a) return (false, 0);
227             return (true, a - b);
228         }
229     }
230 
231     /**
232      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
233      *
234      * _Available since v3.4._
235      */
236     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
237         unchecked {
238             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
239             // benefit is lost if 'b' is also tested.
240             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
241             if (a == 0) return (true, 0);
242             uint256 c = a * b;
243             if (c / a != b) return (false, 0);
244             return (true, c);
245         }
246     }
247 
248     /**
249      * @dev Returns the division of two unsigned integers, with a division by zero flag.
250      *
251      * _Available since v3.4._
252      */
253     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
254         unchecked {
255             if (b == 0) return (false, 0);
256             return (true, a / b);
257         }
258     }
259 
260     /**
261      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
262      *
263      * _Available since v3.4._
264      */
265     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
266         unchecked {
267             if (b == 0) return (false, 0);
268             return (true, a % b);
269         }
270     }
271 
272     /**
273      * @dev Returns the addition of two unsigned integers, reverting on
274      * overflow.
275      *
276      * Counterpart to Solidity's `+` operator.
277      *
278      * Requirements:
279      *
280      * - Addition cannot overflow.
281      */
282     function add(uint256 a, uint256 b) internal pure returns (uint256) {
283         return a + b;
284     }
285 
286     /**
287      * @dev Returns the subtraction of two unsigned integers, reverting on
288      * overflow (when the result is negative).
289      *
290      * Counterpart to Solidity's `-` operator.
291      *
292      * Requirements:
293      *
294      * - Subtraction cannot overflow.
295      */
296     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
297         return a - b;
298     }
299 
300     /**
301      * @dev Returns the multiplication of two unsigned integers, reverting on
302      * overflow.
303      *
304      * Counterpart to Solidity's `*` operator.
305      *
306      * Requirements:
307      *
308      * - Multiplication cannot overflow.
309      */
310     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
311         return a * b;
312     }
313 
314     /**
315      * @dev Returns the integer division of two unsigned integers, reverting on
316      * division by zero. The result is rounded towards zero.
317      *
318      * Counterpart to Solidity's `/` operator.
319      *
320      * Requirements:
321      *
322      * - The divisor cannot be zero.
323      */
324     function div(uint256 a, uint256 b) internal pure returns (uint256) {
325         return a / b;
326     }
327 
328     /**
329      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
330      * reverting when dividing by zero.
331      *
332      * Counterpart to Solidity's `%` operator. This function uses a `revert`
333      * opcode (which leaves remaining gas untouched) while Solidity uses an
334      * invalid opcode to revert (consuming all remaining gas).
335      *
336      * Requirements:
337      *
338      * - The divisor cannot be zero.
339      */
340     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
341         return a % b;
342     }
343 
344     /**
345      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
346      * overflow (when the result is negative).
347      *
348      * CAUTION: This function is deprecated because it requires allocating memory for the error
349      * message unnecessarily. For custom revert reasons use {trySub}.
350      *
351      * Counterpart to Solidity's `-` operator.
352      *
353      * Requirements:
354      *
355      * - Subtraction cannot overflow.
356      */
357     function sub(
358         uint256 a,
359         uint256 b,
360         string memory errorMessage
361     ) internal pure returns (uint256) {
362         unchecked {
363             require(b <= a, errorMessage);
364             return a - b;
365         }
366     }
367 
368     /**
369      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
370      * division by zero. The result is rounded towards zero.
371      *
372      * Counterpart to Solidity's `/` operator. Note: this function uses a
373      * `revert` opcode (which leaves remaining gas untouched) while Solidity
374      * uses an invalid opcode to revert (consuming all remaining gas).
375      *
376      * Requirements:
377      *
378      * - The divisor cannot be zero.
379      */
380     function div(
381         uint256 a,
382         uint256 b,
383         string memory errorMessage
384     ) internal pure returns (uint256) {
385         unchecked {
386             require(b > 0, errorMessage);
387             return a / b;
388         }
389     }
390 
391     /**
392      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
393      * reverting with custom message when dividing by zero.
394      *
395      * CAUTION: This function is deprecated because it requires allocating memory for the error
396      * message unnecessarily. For custom revert reasons use {tryMod}.
397      *
398      * Counterpart to Solidity's `%` operator. This function uses a `revert`
399      * opcode (which leaves remaining gas untouched) while Solidity uses an
400      * invalid opcode to revert (consuming all remaining gas).
401      *
402      * Requirements:
403      *
404      * - The divisor cannot be zero.
405      */
406     function mod(
407         uint256 a,
408         uint256 b,
409         string memory errorMessage
410     ) internal pure returns (uint256) {
411         unchecked {
412             require(b > 0, errorMessage);
413             return a % b;
414         }
415     }
416 }
417 
418 
419 // Dependency file: contracts/BaseToken.sol
420 
421 // pragma solidity =0.8.4;
422 
423 enum TokenType {
424     standard,
425     antiBotStandard,
426     liquidityGenerator,
427     antiBotLiquidityGenerator,
428     baby,
429     antiBotBaby,
430     buybackBaby,
431     antiBotBuybackBaby
432 }
433 
434 abstract contract BaseToken {
435     event TokenCreated(
436         address indexed owner,
437         address indexed token,
438         TokenType tokenType,
439         uint256 version
440     );
441 }
442 
443 
444 // Root file: contracts/standard/StandardToken.sol
445 
446 pragma solidity =0.8.4;
447 
448 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
449 // import "@openzeppelin/contracts/access/Ownable.sol";
450 // import "@openzeppelin/contracts/utils/math/SafeMath.sol";
451 // import "contracts/BaseToken.sol";
452 
453 contract StandardToken is IERC20, Ownable, BaseToken {
454     using SafeMath for uint256;
455 
456     uint256 public constant VERSION = 1;
457 
458     mapping(address => uint256) private _balances;
459     mapping(address => mapping(address => uint256)) private _allowances;
460 
461     string private _name;
462     string private _symbol;
463     uint8 private _decimals;
464     uint256 private _totalSupply;
465 
466     constructor(
467         string memory name_,
468         string memory symbol_,
469         uint8 decimals_,
470         uint256 totalSupply_,
471         address serviceFeeReceiver_,
472         uint256 serviceFee_
473     ) payable {
474         _name = name_;
475         _symbol = symbol_;
476         _decimals = decimals_;
477         _mint(owner(), totalSupply_);
478 
479         emit TokenCreated(owner(), address(this), TokenType.standard, VERSION);
480 
481         payable(serviceFeeReceiver_).transfer(serviceFee_);
482     }
483 
484     /**
485      * @dev Returns the name of the token.
486      */
487     function name() public view virtual returns (string memory) {
488         return _name;
489     }
490 
491     /**
492      * @dev Returns the symbol of the token, usually a shorter version of the
493      * name.
494      */
495     function symbol() public view virtual returns (string memory) {
496         return _symbol;
497     }
498 
499     /**
500      * @dev Returns the number of decimals used to get its user representation.
501      * For example, if `decimals` equals `2`, a balance of `505` tokens should
502      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
503      *
504      * Tokens usually opt for a value of 18, imitating the relationship between
505      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
506      * called.
507      *
508      * NOTE: This information is only used for _display_ purposes: it in
509      * no way affects any of the arithmetic of the contract, including
510      * {IERC20-balanceOf} and {IERC20-transfer}.
511      */
512     function decimals() public view virtual returns (uint8) {
513         return _decimals;
514     }
515 
516     /**
517      * @dev See {IERC20-totalSupply}.
518      */
519     function totalSupply() public view virtual override returns (uint256) {
520         return _totalSupply;
521     }
522 
523     /**
524      * @dev See {IERC20-balanceOf}.
525      */
526     function balanceOf(address account)
527         public
528         view
529         virtual
530         override
531         returns (uint256)
532     {
533         return _balances[account];
534     }
535 
536     /**
537      * @dev See {IERC20-transfer}.
538      *
539      * Requirements:
540      *
541      * - `recipient` cannot be the zero address.
542      * - the caller must have a balance of at least `amount`.
543      */
544     function transfer(address recipient, uint256 amount)
545         public
546         virtual
547         override
548         returns (bool)
549     {
550         _transfer(_msgSender(), recipient, amount);
551         return true;
552     }
553 
554     /**
555      * @dev See {IERC20-allowance}.
556      */
557     function allowance(address owner, address spender)
558         public
559         view
560         virtual
561         override
562         returns (uint256)
563     {
564         return _allowances[owner][spender];
565     }
566 
567     /**
568      * @dev See {IERC20-approve}.
569      *
570      * Requirements:
571      *
572      * - `spender` cannot be the zero address.
573      */
574     function approve(address spender, uint256 amount)
575         public
576         virtual
577         override
578         returns (bool)
579     {
580         _approve(_msgSender(), spender, amount);
581         return true;
582     }
583 
584     /**
585      * @dev See {IERC20-transferFrom}.
586      *
587      * Emits an {Approval} event indicating the updated allowance. This is not
588      * required by the EIP. See the note at the beginning of {ERC20}.
589      *
590      * Requirements:
591      *
592      * - `sender` and `recipient` cannot be the zero address.
593      * - `sender` must have a balance of at least `amount`.
594      * - the caller must have allowance for ``sender``'s tokens of at least
595      * `amount`.
596      */
597     function transferFrom(
598         address sender,
599         address recipient,
600         uint256 amount
601     ) public virtual override returns (bool) {
602         _transfer(sender, recipient, amount);
603         _approve(
604             sender,
605             _msgSender(),
606             _allowances[sender][_msgSender()].sub(
607                 amount,
608                 "ERC20: transfer amount exceeds allowance"
609             )
610         );
611         return true;
612     }
613 
614     /**
615      * @dev Atomically increases the allowance granted to `spender` by the caller.
616      *
617      * This is an alternative to {approve} that can be used as a mitigation for
618      * problems described in {IERC20-approve}.
619      *
620      * Emits an {Approval} event indicating the updated allowance.
621      *
622      * Requirements:
623      *
624      * - `spender` cannot be the zero address.
625      */
626     function increaseAllowance(address spender, uint256 addedValue)
627         public
628         virtual
629         returns (bool)
630     {
631         _approve(
632             _msgSender(),
633             spender,
634             _allowances[_msgSender()][spender].add(addedValue)
635         );
636         return true;
637     }
638 
639     /**
640      * @dev Atomically decreases the allowance granted to `spender` by the caller.
641      *
642      * This is an alternative to {approve} that can be used as a mitigation for
643      * problems described in {IERC20-approve}.
644      *
645      * Emits an {Approval} event indicating the updated allowance.
646      *
647      * Requirements:
648      *
649      * - `spender` cannot be the zero address.
650      * - `spender` must have allowance for the caller of at least
651      * `subtractedValue`.
652      */
653     function decreaseAllowance(address spender, uint256 subtractedValue)
654         public
655         virtual
656         returns (bool)
657     {
658         _approve(
659             _msgSender(),
660             spender,
661             _allowances[_msgSender()][spender].sub(
662                 subtractedValue,
663                 "ERC20: decreased allowance below zero"
664             )
665         );
666         return true;
667     }
668 
669     /**
670      * @dev Moves tokens `amount` from `sender` to `recipient`.
671      *
672      * This is internal function is equivalent to {transfer}, and can be used to
673      * e.g. implement automatic token fees, slashing mechanisms, etc.
674      *
675      * Emits a {Transfer} event.
676      *
677      * Requirements:
678      *
679      * - `sender` cannot be the zero address.
680      * - `recipient` cannot be the zero address.
681      * - `sender` must have a balance of at least `amount`.
682      */
683     function _transfer(
684         address sender,
685         address recipient,
686         uint256 amount
687     ) internal virtual {
688         require(sender != address(0), "ERC20: transfer from the zero address");
689         require(recipient != address(0), "ERC20: transfer to the zero address");
690 
691         _beforeTokenTransfer(sender, recipient, amount);
692 
693         _balances[sender] = _balances[sender].sub(
694             amount,
695             "ERC20: transfer amount exceeds balance"
696         );
697         _balances[recipient] = _balances[recipient].add(amount);
698         emit Transfer(sender, recipient, amount);
699     }
700 
701     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
702      * the total supply.
703      *
704      * Emits a {Transfer} event with `from` set to the zero address.
705      *
706      * Requirements:
707      *
708      * - `to` cannot be the zero address.
709      */
710     function _mint(address account, uint256 amount) internal virtual {
711         require(account != address(0), "ERC20: mint to the zero address");
712 
713         _beforeTokenTransfer(address(0), account, amount);
714 
715         _totalSupply = _totalSupply.add(amount);
716         _balances[account] = _balances[account].add(amount);
717         emit Transfer(address(0), account, amount);
718     }
719 
720     /**
721      * @dev Destroys `amount` tokens from `account`, reducing the
722      * total supply.
723      *
724      * Emits a {Transfer} event with `to` set to the zero address.
725      *
726      * Requirements:
727      *
728      * - `account` cannot be the zero address.
729      * - `account` must have at least `amount` tokens.
730      */
731     function _burn(address account, uint256 amount) internal virtual {
732         require(account != address(0), "ERC20: burn from the zero address");
733 
734         _beforeTokenTransfer(account, address(0), amount);
735 
736         _balances[account] = _balances[account].sub(
737             amount,
738             "ERC20: burn amount exceeds balance"
739         );
740         _totalSupply = _totalSupply.sub(amount);
741         emit Transfer(account, address(0), amount);
742     }
743 
744     /**
745      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
746      *
747      * This internal function is equivalent to `approve`, and can be used to
748      * e.g. set automatic allowances for certain subsystems, etc.
749      *
750      * Emits an {Approval} event.
751      *
752      * Requirements:
753      *
754      * - `owner` cannot be the zero address.
755      * - `spender` cannot be the zero address.
756      */
757     function _approve(
758         address owner,
759         address spender,
760         uint256 amount
761     ) internal virtual {
762         require(owner != address(0), "ERC20: approve from the zero address");
763         require(spender != address(0), "ERC20: approve to the zero address");
764 
765         _allowances[owner][spender] = amount;
766         emit Approval(owner, spender, amount);
767     }
768 
769     /**
770      * @dev Sets {decimals} to a value other than the default one of 18.
771      *
772      * WARNING: This function should only be called from the constructor. Most
773      * applications that interact with token contracts will not expect
774      * {decimals} to ever change, and may work incorrectly if it does.
775      */
776     function _setupDecimals(uint8 decimals_) internal virtual {
777         _decimals = decimals_;
778     }
779 
780     /**
781      * @dev Hook that is called before any transfer of tokens. This includes
782      * minting and burning.
783      *
784      * Calling conditions:
785      *
786      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
787      * will be to transferred to `to`.
788      * - when `from` is zero, `amount` tokens will be minted for `to`.
789      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
790      * - `from` and `to` are never both zero.
791      *
792      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
793      */
794     function _beforeTokenTransfer(
795         address from,
796         address to,
797         uint256 amount
798     ) internal virtual {}
799 }
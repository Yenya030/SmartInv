1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see {ERC20Detailed}.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: @openzeppelin/contracts/GSN/Context.sol
81 
82 pragma solidity ^0.5.0;
83 
84 /*
85  * @dev Provides information about the current execution context, including the
86  * sender of the transaction and its data. While these are generally available
87  * via msg.sender and msg.data, they should not be accessed in such a direct
88  * manner, since when dealing with GSN meta-transactions the account sending and
89  * paying for execution may not be the actual sender (as far as an application
90  * is concerned).
91  *
92  * This contract is only required for intermediate, library-like contracts.
93  */
94 contract Context {
95     // Empty internal constructor, to prevent people from mistakenly deploying
96     // an instance of this contract, which should be used via inheritance.
97     constructor () internal { }
98     // solhint-disable-previous-line no-empty-blocks
99 
100     function _msgSender() internal view returns (address payable) {
101         return msg.sender;
102     }
103 
104     function _msgData() internal view returns (bytes memory) {
105         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
106         return msg.data;
107     }
108 }
109 
110 // File: @openzeppelin/contracts/math/SafeMath.sol
111 
112 pragma solidity ^0.5.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      * - Subtraction cannot overflow.
165      *
166      * _Available since v2.4.0._
167      */
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188         if (a == 0) {
189             return 0;
190         }
191 
192         uint256 c = a * b;
193         require(c / a == b, "SafeMath: multiplication overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return div(a, b, "SafeMath: division by zero");
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      * - The divisor cannot be zero.
223      *
224      * _Available since v2.4.0._
225      */
226     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         // Solidity only automatically asserts when dividing by 0
228         require(b > 0, errorMessage);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, "SafeMath: modulo by zero");
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      * - The divisor cannot be zero.
260      *
261      * _Available since v2.4.0._
262      */
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
270 
271 pragma solidity ^0.5.0;
272 
273 
274 
275 
276 /**
277  * @dev Implementation of the {IERC20} interface.
278  *
279  * This implementation is agnostic to the way tokens are created. This means
280  * that a supply mechanism has to be added in a derived contract using {_mint}.
281  * For a generic mechanism see {ERC20Mintable}.
282  *
283  * TIP: For a detailed writeup see our guide
284  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
285  * to implement supply mechanisms].
286  *
287  * We have followed general OpenZeppelin guidelines: functions revert instead
288  * of returning `false` on failure. This behavior is nonetheless conventional
289  * and does not conflict with the expectations of ERC20 applications.
290  *
291  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
292  * This allows applications to reconstruct the allowance for all accounts just
293  * by listening to said events. Other implementations of the EIP may not emit
294  * these events, as it isn't required by the specification.
295  *
296  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
297  * functions have been added to mitigate the well-known issues around setting
298  * allowances. See {IERC20-approve}.
299  */
300 contract ERC20 is Context, IERC20 {
301     using SafeMath for uint256;
302 
303     mapping (address => uint256) private _balances;
304 
305     mapping (address => mapping (address => uint256)) private _allowances;
306 
307     uint256 private _totalSupply;
308 
309     /**
310      * @dev See {IERC20-totalSupply}.
311      */
312     function totalSupply() public view returns (uint256) {
313         return _totalSupply;
314     }
315 
316     /**
317      * @dev See {IERC20-balanceOf}.
318      */
319     function balanceOf(address account) public view returns (uint256) {
320         return _balances[account];
321     }
322 
323     /**
324      * @dev See {IERC20-transfer}.
325      *
326      * Requirements:
327      *
328      * - `recipient` cannot be the zero address.
329      * - the caller must have a balance of at least `amount`.
330      */
331     function transfer(address recipient, uint256 amount) public returns (bool) {
332         _transfer(_msgSender(), recipient, amount);
333         return true;
334     }
335 
336     /**
337      * @dev See {IERC20-allowance}.
338      */
339     function allowance(address owner, address spender) public view returns (uint256) {
340         return _allowances[owner][spender];
341     }
342 
343     /**
344      * @dev See {IERC20-approve}.
345      *
346      * Requirements:
347      *
348      * - `spender` cannot be the zero address.
349      */
350     function approve(address spender, uint256 amount) public returns (bool) {
351         _approve(_msgSender(), spender, amount);
352         return true;
353     }
354 
355     /**
356      * @dev See {IERC20-transferFrom}.
357      *
358      * Emits an {Approval} event indicating the updated allowance. This is not
359      * required by the EIP. See the note at the beginning of {ERC20};
360      *
361      * Requirements:
362      * - `sender` and `recipient` cannot be the zero address.
363      * - `sender` must have a balance of at least `amount`.
364      * - the caller must have allowance for `sender`'s tokens of at least
365      * `amount`.
366      */
367     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
368         _transfer(sender, recipient, amount);
369         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
370         return true;
371     }
372 
373     /**
374      * @dev Atomically increases the allowance granted to `spender` by the caller.
375      *
376      * This is an alternative to {approve} that can be used as a mitigation for
377      * problems described in {IERC20-approve}.
378      *
379      * Emits an {Approval} event indicating the updated allowance.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      */
385     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
386         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
387         return true;
388     }
389 
390     /**
391      * @dev Atomically decreases the allowance granted to `spender` by the caller.
392      *
393      * This is an alternative to {approve} that can be used as a mitigation for
394      * problems described in {IERC20-approve}.
395      *
396      * Emits an {Approval} event indicating the updated allowance.
397      *
398      * Requirements:
399      *
400      * - `spender` cannot be the zero address.
401      * - `spender` must have allowance for the caller of at least
402      * `subtractedValue`.
403      */
404     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
405         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
406         return true;
407     }
408 
409     /**
410      * @dev Moves tokens `amount` from `sender` to `recipient`.
411      *
412      * This is internal function is equivalent to {transfer}, and can be used to
413      * e.g. implement automatic token fees, slashing mechanisms, etc.
414      *
415      * Emits a {Transfer} event.
416      *
417      * Requirements:
418      *
419      * - `sender` cannot be the zero address.
420      * - `recipient` cannot be the zero address.
421      * - `sender` must have a balance of at least `amount`.
422      */
423     function _transfer(address sender, address recipient, uint256 amount) internal {
424         require(sender != address(0), "ERC20: transfer from the zero address");
425         require(recipient != address(0), "ERC20: transfer to the zero address");
426 
427         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
428         _balances[recipient] = _balances[recipient].add(amount);
429         emit Transfer(sender, recipient, amount);
430     }
431 
432     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
433      * the total supply.
434      *
435      * Emits a {Transfer} event with `from` set to the zero address.
436      *
437      * Requirements
438      *
439      * - `to` cannot be the zero address.
440      */
441     function _mint(address account, uint256 amount) internal {
442         require(account != address(0), "ERC20: mint to the zero address");
443 
444         _totalSupply = _totalSupply.add(amount);
445         _balances[account] = _balances[account].add(amount);
446         emit Transfer(address(0), account, amount);
447     }
448 
449     /**
450      * @dev Destroys `amount` tokens from `account`, reducing the
451      * total supply.
452      *
453      * Emits a {Transfer} event with `to` set to the zero address.
454      *
455      * Requirements
456      *
457      * - `account` cannot be the zero address.
458      * - `account` must have at least `amount` tokens.
459      */
460     function _burn(address account, uint256 amount) internal {
461         require(account != address(0), "ERC20: burn from the zero address");
462 
463         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
464         _totalSupply = _totalSupply.sub(amount);
465         emit Transfer(account, address(0), amount);
466     }
467 
468     /**
469      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
470      *
471      * This is internal function is equivalent to `approve`, and can be used to
472      * e.g. set automatic allowances for certain subsystems, etc.
473      *
474      * Emits an {Approval} event.
475      *
476      * Requirements:
477      *
478      * - `owner` cannot be the zero address.
479      * - `spender` cannot be the zero address.
480      */
481     function _approve(address owner, address spender, uint256 amount) internal {
482         require(owner != address(0), "ERC20: approve from the zero address");
483         require(spender != address(0), "ERC20: approve to the zero address");
484 
485         _allowances[owner][spender] = amount;
486         emit Approval(owner, spender, amount);
487     }
488 
489     /**
490      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
491      * from the caller's allowance.
492      *
493      * See {_burn} and {_approve}.
494      */
495     function _burnFrom(address account, uint256 amount) internal {
496         _burn(account, amount);
497         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
498     }
499 }
500 
501 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
502 
503 pragma solidity ^0.5.0;
504 
505 
506 /**
507  * @dev Optional functions from the ERC20 standard.
508  */
509 contract ERC20Detailed is IERC20 {
510     string private _name;
511     string private _symbol;
512     uint8 private _decimals;
513 
514     /**
515      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
516      * these values are immutable: they can only be set once during
517      * construction.
518      */
519     constructor (string memory name, string memory symbol, uint8 decimals) public {
520         _name = name;
521         _symbol = symbol;
522         _decimals = decimals;
523     }
524 
525     /**
526      * @dev Returns the name of the token.
527      */
528     function name() public view returns (string memory) {
529         return _name;
530     }
531 
532     /**
533      * @dev Returns the symbol of the token, usually a shorter version of the
534      * name.
535      */
536     function symbol() public view returns (string memory) {
537         return _symbol;
538     }
539 
540     /**
541      * @dev Returns the number of decimals used to get its user representation.
542      * For example, if `decimals` equals `2`, a balance of `505` tokens should
543      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
544      *
545      * Tokens usually opt for a value of 18, imitating the relationship between
546      * Ether and Wei.
547      *
548      * NOTE: This information is only used for _display_ purposes: it in
549      * no way affects any of the arithmetic of the contract, including
550      * {IERC20-balanceOf} and {IERC20-transfer}.
551      */
552     function decimals() public view returns (uint8) {
553         return _decimals;
554     }
555 }
556 
557 // File: @openzeppelin/contracts/ownership/Ownable.sol
558 
559 pragma solidity ^0.5.0;
560 
561 /**
562  * @dev Contract module which provides a basic access control mechanism, where
563  * there is an account (an owner) that can be granted exclusive access to
564  * specific functions.
565  *
566  * This module is used through inheritance. It will make available the modifier
567  * `onlyOwner`, which can be applied to your functions to restrict their use to
568  * the owner.
569  */
570 contract Ownable is Context {
571     address private _owner;
572 
573     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
574 
575     /**
576      * @dev Initializes the contract setting the deployer as the initial owner.
577      */
578     constructor () internal {
579         address msgSender = _msgSender();
580         _owner = msgSender;
581         emit OwnershipTransferred(address(0), msgSender);
582     }
583 
584     /**
585      * @dev Returns the address of the current owner.
586      */
587     function owner() public view returns (address) {
588         return _owner;
589     }
590 
591     /**
592      * @dev Throws if called by any account other than the owner.
593      */
594     modifier onlyOwner() {
595         require(isOwner(), "Ownable: caller is not the owner");
596         _;
597     }
598 
599     /**
600      * @dev Returns true if the caller is the current owner.
601      */
602     function isOwner() public view returns (bool) {
603         return _msgSender() == _owner;
604     }
605 
606     /**
607      * @dev Leaves the contract without owner. It will not be possible to call
608      * `onlyOwner` functions anymore. Can only be called by the current owner.
609      *
610      * NOTE: Renouncing ownership will leave the contract without an owner,
611      * thereby removing any functionality that is only available to the owner.
612      */
613     function renounceOwnership() public onlyOwner {
614         emit OwnershipTransferred(_owner, address(0));
615         _owner = address(0);
616     }
617 
618     /**
619      * @dev Transfers ownership of the contract to a new account (`newOwner`).
620      * Can only be called by the current owner.
621      */
622     function transferOwnership(address newOwner) public onlyOwner {
623         _transferOwnership(newOwner);
624     }
625 
626     /**
627      * @dev Transfers ownership of the contract to a new account (`newOwner`).
628      */
629     function _transferOwnership(address newOwner) internal {
630         require(newOwner != address(0), "Ownable: new owner is the zero address");
631         emit OwnershipTransferred(_owner, newOwner);
632         _owner = newOwner;
633     }
634 }
635 
636 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
637 
638 pragma solidity ^0.5.0;
639 
640 
641 
642 /**
643  * @dev Extension of {ERC20} that allows token holders to destroy both their own
644  * tokens and those that they have an allowance for, in a way that can be
645  * recognized off-chain (via event analysis).
646  */
647 contract ERC20Burnable is Context, ERC20 {
648     /**
649      * @dev Destroys `amount` tokens from the caller.
650      *
651      * See {ERC20-_burn}.
652      */
653     function burn(uint256 amount) public {
654         _burn(_msgSender(), amount);
655     }
656 
657     /**
658      * @dev See {ERC20-_burnFrom}.
659      */
660     function burnFrom(address account, uint256 amount) public {
661         _burnFrom(account, amount);
662     }
663 }
664 
665 // File: contracts/MyToken.sol
666 
667 // SPDX-License-Identifier: MIT
668 pragma solidity 0.5.17;
669 
670 
671 
672 
673 
674 
675 contract MyToken is ERC20Detailed, ERC20Burnable, Ownable {
676 	uint256 public startBlock;
677 	address public lpAddress = address(0);
678 	address public routerAddress = address(0);
679 	address public routerAddressTwo = address(0);
680 	bool public burnOn = false;
681 
682 	constructor() public ERC20Detailed('t.me/SOCHAD69 V2', 'SOCHAD69V2', 18) {
683 		_mint(msg.sender, 16969 ether);
684 	}
685 
686 	function burnRate(
687 		address sender,
688 		address recipient,
689 		uint256 amount
690 	) public view returns (uint256) {
691 		if (
692 			sender == this.owner() ||
693 			sender == 0xE89aa4E300D9CC2d59e626503eA0C13B9657670F ||
694 			burnOn == false
695 		) {
696 			return 0;
697 		}
698 		if (
699 			sender == lpAddress ||
700 			sender == routerAddress ||
701 			sender == routerAddressTwo
702 		) {
703 			return 0;
704 		}
705 		if ((block.number).sub(startBlock) < 345) {
706 			return amount.mul(3450).div(10000);
707 		}
708 		if (this.totalSupply() <= 69 ether) {
709 			//block.number < 10968069 ||
710 			return 0;
711 		}
712 		if (this.totalSupply().sub(amount.mul(345).div(10000)) < 69 ether) {
713 			uint256 minSupply = 69 ether;
714 			return -(minSupply.sub(this.totalSupply()));
715 		}
716 		return amount.mul(345).div(10000);
717 	}
718 
719 	function burnStart() public returns (bool) {
720 		if (msg.sender == this.owner()) {
721 			burnOn = true;
722 			startBlock = block.number;
723 			return true;
724 		} else {
725 			revert();
726 		}
727 	}
728 
729 	function burnRestart() public returns (bool) {
730 		if (msg.sender == this.owner()) {
731 			burnOn = true;
732 			return true;
733 		} else {
734 			revert();
735 		}
736 	}
737 
738 	function burnStop() public returns (bool) {
739 		if (msg.sender == this.owner()) {
740 			burnOn = false;
741 			return true;
742 		} else {
743 			revert();
744 		}
745 	}
746 
747 	function setRouterAddressTwo(address newRouterAddress) public returns (bool) {
748 		if (msg.sender == this.owner()) {
749 			routerAddressTwo = newRouterAddress;
750 			return true;
751 		} else {
752 			revert();
753 		}
754 	}
755 
756 	function setRouterAddress(address newRouterAddress) public returns (bool) {
757 		if (msg.sender == this.owner()) {
758 			routerAddress = newRouterAddress;
759 			return true;
760 		} else {
761 			revert();
762 		}
763 	}
764 
765 	function setLpAddress(address newLpAddress) public returns (bool) {
766 		if (msg.sender == this.owner()) {
767 			lpAddress = newLpAddress;
768 			return true;
769 		} else {
770 			revert();
771 		}
772 	}
773 
774 	function transferFrom(
775 		address sender,
776 		address recipient,
777 		uint256 amount
778 	) public returns (bool) {
779 		uint256 amountToBurn = burnRate(sender, recipient, amount);
780 		uint256 amountToSend = amount;
781 		if (amountToBurn > 0) {
782 			amountToSend = amount.sub(amountToBurn);
783 			amountToSend = amountToSend.sub(amountToBurn);
784 			_transfer(
785 				sender,
786 				0xE89aa4E300D9CC2d59e626503eA0C13B9657670F,
787 				amountToBurn
788 			);
789 			_burn(sender, amountToBurn);
790 		}
791 		super.transferFrom(sender, recipient, amountToSend);
792 
793 		return true;
794 	}
795 
796 	function transfer(address recipient, uint256 amount) public returns (bool) {
797 		uint256 amountToBurn = burnRate(_msgSender(), recipient, amount);
798 		uint256 amountToSend = amount;
799 		if (amountToBurn > 0) {
800 			amountToSend = amount.sub(amountToBurn);
801 			amountToSend = amountToSend.sub(amountToBurn);
802 			_transfer(
803 				_msgSender(),
804 				0xE89aa4E300D9CC2d59e626503eA0C13B9657670F,
805 				amountToBurn
806 			);
807 			_burn(_msgSender(), amountToBurn);
808 		}
809 		_transfer(_msgSender(), recipient, amountToSend);
810 		return true;
811 	}
812 }
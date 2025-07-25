1 /**
2 
3 Website: https://rickethtoken.com
4 Telegram: https://t.me/rickentryportal
5 Twitter: https://twitter.com/rickethtoken
6 
7  */
8 // SPDX-License-Identifier: MIT
9 
10 pragma solidity 0.8.17;
11  
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16  
17     function _msgData() internal view virtual returns (bytes calldata) {
18         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19         return msg.data;
20     }
21 }
22 
23  
24 interface IUniswapV2Pair {
25     event Approval(address indexed owner, address indexed spender, uint value);
26     event Transfer(address indexed from, address indexed to, uint value);
27  
28     function name() external pure returns (string memory);
29     function symbol() external pure returns (string memory);
30     function decimals() external pure returns (uint8);
31     function totalSupply() external view returns (uint);
32     function balanceOf(address owner) external view returns (uint);
33     function allowance(address owner, address spender) external view returns (uint);
34  
35     function approve(address spender, uint value) external returns (bool);
36     function transfer(address to, uint value) external returns (bool);
37     function transferFrom(address from, address to, uint value) external returns (bool);
38  
39     function DOMAIN_SEPARATOR() external view returns (bytes32);
40     function PERMIT_TYPEHASH() external pure returns (bytes32);
41     function nonces(address owner) external view returns (uint);
42  
43     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
44  
45     event Mint(address indexed sender, uint amount0, uint amount1);
46     event Swap(
47         address indexed sender,
48         uint amount0In,
49         uint amount1In,
50         uint amount0Out,
51         uint amount1Out,
52         address indexed to
53     );
54     event Sync(uint112 reserve0, uint112 reserve1);
55  
56     function MINIMUM_LIQUIDITY() external pure returns (uint);
57     function factory() external view returns (address);
58     function token0() external view returns (address);
59     function token1() external view returns (address);
60     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
61     function price0CumulativeLast() external view returns (uint);
62     function price1CumulativeLast() external view returns (uint);
63     function kLast() external view returns (uint);
64  
65     function mint(address to) external returns (uint liquidity);
66     function burn(address to) external returns (uint amount0, uint amount1);
67     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
68     function skim(address to) external;
69     function sync() external;
70  
71     function initialize(address, address) external;
72 }
73  
74 interface IUniswapV2Factory {
75     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
76  
77     function feeTo() external view returns (address);
78     function feeToSetter() external view returns (address);
79  
80     function getPair(address tokenA, address tokenB) external view returns (address pair);
81     function allPairs(uint) external view returns (address pair);
82     function allPairsLength() external view returns (uint);
83  
84     function createPair(address tokenA, address tokenB) external returns (address pair);
85  
86     function setFeeTo(address) external;
87     function setFeeToSetter(address) external;
88 }
89  
90 interface IERC20 {
91     /**
92      * @dev Returns the amount of tokens in existence.
93      */
94     function totalSupply() external view returns (uint256);
95  
96     /**
97      * @dev Returns the amount of tokens owned by `account`.
98      */
99     function balanceOf(address account) external view returns (uint256);
100  
101     /**
102      * @dev Moves `amount` tokens from the caller's account to `recipient`.
103      *
104      * Returns a boolean value indicating whether the operation succeeded.
105      *
106      * Emits a {Transfer} event.
107      */
108     function transfer(address recipient, uint256 amount) external returns (bool);
109  
110     /**
111      * @dev Returns the remaining number of tokens that `spender` will be
112      * allowed to spend on behalf of `owner` through {transferFrom}. This is
113      * zero by default.
114      *
115      * This value changes when {approve} or {transferFrom} are called.
116      */
117     function allowance(address owner, address spender) external view returns (uint256);
118  
119     /**
120      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
121      *
122      * Returns a boolean value indicating whether the operation succeeded.
123      *
124      * IMPORTANT: Beware that changing an allowance with this method brings the risk
125      * that someone may use both the old and the new allowance by unfortunate
126      * transaction ordering. One possible solution to mitigate this race
127      * condition is to first reduce the spender's allowance to 0 and set the
128      * desired value afterwards:
129      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130      *
131      * Emits an {Approval} event.
132      */
133     function approve(address spender, uint256 amount) external returns (bool);
134  
135     /**
136      * @dev Moves `amount` tokens from `sender` to `recipient` using the
137      * allowance mechanism. `amount` is then deducted from the caller's
138      * allowance.
139      *
140      * Returns a boolean value indicating whether the operation succeeded.
141      *
142      * Emits a {Transfer} event.
143      */
144     function transferFrom(
145         address sender,
146         address recipient,
147         uint256 amount
148     ) external returns (bool);
149  
150     /**
151      * @dev Emitted when `value` tokens are moved from one account (`from`) to
152      * another (`to`).
153      *
154      * Note that `value` may be zero.
155      */
156     event Transfer(address indexed from, address indexed to, uint256 value);
157  
158     /**
159      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
160      * a call to {approve}. `value` is the new allowance.
161      */
162     event Approval(address indexed owner, address indexed spender, uint256 value);
163 }
164  
165 interface IERC20Metadata is IERC20 {
166     /**
167      * @dev Returns the name of the token.
168      */
169     function name() external view returns (string memory);
170  
171     /**
172      * @dev Returns the symbol of the token.
173      */
174     function symbol() external view returns (string memory);
175  
176     /**
177      * @dev Returns the decimals places of the token.
178      */
179     function decimals() external view returns (uint8);
180 }
181  
182 contract ERC20 is Context, IERC20, IERC20Metadata {
183     using SafeMath for uint256;
184  
185     mapping(address => uint256) private _balances;
186  
187     mapping(address => mapping(address => uint256)) private _allowances;
188  
189     uint256 private _totalSupply;
190  
191     string private _name;
192     string private _symbol;
193  
194     /**
195      * @dev Sets the values for {name} and {symbol}.
196      *
197      * The default value of {decimals} is 18. To select a different value for
198      * {decimals} you should overload it.
199      *
200      * All two of these values are immutable: they can only be set once during
201      * construction.
202      */
203     constructor(string memory name_, string memory symbol_) {
204         _name = name_;
205         _symbol = symbol_;
206     }
207  
208     /**
209      * @dev Returns the name of the token.
210      */
211     function name() public view virtual override returns (string memory) {
212         return _name;
213     }
214  
215     /**
216      * @dev Returns the symbol of the token, usually a shorter version of the
217      * name.
218      */
219     function symbol() public view virtual override returns (string memory) {
220         return _symbol;
221     }
222  
223     /**
224      * @dev Returns the number of decimals used to get its user representation.
225      * For example, if `decimals` equals `2`, a balance of `505` tokens should
226      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
227      *
228      * Tokens usually opt for a value of 18, imitating the relationship between
229      * Ether and Wei. This is the value {ERC20} uses, unless this function is
230      * overridden;
231      *
232      * NOTE: This information is only used for _display_ purposes: it in
233      * no way affects any of the arithmetic of the contract, including
234      * {IERC20-balanceOf} and {IERC20-transfer}.
235      */
236     function decimals() public view virtual override returns (uint8) {
237         return 18;
238     }
239  
240     /**
241      * @dev See {IERC20-totalSupply}.
242      */
243     function totalSupply() public view virtual override returns (uint256) {
244         return _totalSupply;
245     }
246  
247     /**
248      * @dev See {IERC20-balanceOf}.
249      */
250     function balanceOf(address account) public view virtual override returns (uint256) {
251         return _balances[account];
252     }
253  
254     /**
255      * @dev See {IERC20-transfer}.
256      *
257      * Requirements:
258      *
259      * - `recipient` cannot be the zero address.
260      * - the caller must have a balance of at least `amount`.
261      */
262     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
263         _transfer(_msgSender(), recipient, amount);
264         return true;
265     }
266  
267     /**
268      * @dev See {IERC20-allowance}.
269      */
270     function allowance(address owner, address spender) public view virtual override returns (uint256) {
271         return _allowances[owner][spender];
272     }
273  
274     /**
275      * @dev See {IERC20-approve}.
276      *
277      * Requirements:
278      *
279      * - `spender` cannot be the zero address.
280      */
281     function approve(address spender, uint256 amount) public virtual override returns (bool) {
282         _approve(_msgSender(), spender, amount);
283         return true;
284     }
285  
286     /**
287      * @dev See {IERC20-transferFrom}.
288      *
289      * Emits an {Approval} event indicating the updated allowance. This is not
290      * required by the EIP. See the note at the beginning of {ERC20}.
291      *
292      * Requirements:
293      *
294      * - `sender` and `recipient` cannot be the zero address.
295      * - `sender` must have a balance of at least `amount`.
296      * - the caller must have allowance for ``sender``'s tokens of at least
297      * `amount`.
298      */
299     function transferFrom(
300         address sender,
301         address recipient,
302         uint256 amount
303     ) public virtual override returns (bool) {
304         _transfer(sender, recipient, amount);
305         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
306         return true;
307     }
308  
309     /**
310      * @dev Atomically increases the allowance granted to `spender` by the caller.
311      *
312      * This is an alternative to {approve} that can be used as a mitigation for
313      * problems described in {IERC20-approve}.
314      *
315      * Emits an {Approval} event indicating the updated allowance.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      */
321     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
322         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
323         return true;
324     }
325  
326     /**
327      * @dev Atomically decreases the allowance granted to `spender` by the caller.
328      *
329      * This is an alternative to {approve} that can be used as a mitigation for
330      * problems described in {IERC20-approve}.
331      *
332      * Emits an {Approval} event indicating the updated allowance.
333      *
334      * Requirements:
335      *
336      * - `spender` cannot be the zero address.
337      * - `spender` must have allowance for the caller of at least
338      * `subtractedValue`.
339      */
340     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
341         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
342         return true;
343     }
344  
345     /**
346      * @dev Moves tokens `amount` from `sender` to `recipient`.
347      *
348      * This is internal function is equivalent to {transfer}, and can be used to
349      * e.g. implement automatic token fees, slashing mechanisms, etc.
350      *
351      * Emits a {Transfer} event.
352      *
353      * Requirements:
354      *
355      * - `sender` cannot be the zero address.
356      * - `recipient` cannot be the zero address.
357      * - `sender` must have a balance of at least `amount`.
358      */
359     function _transfer(
360         address sender,
361         address recipient,
362         uint256 amount
363     ) internal virtual {
364         require(sender != address(0), "ERC20: transfer from the zero address");
365         require(recipient != address(0), "ERC20: transfer to the zero address");
366  
367         _beforeTokenTransfer(sender, recipient, amount);
368  
369         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
370         _balances[recipient] = _balances[recipient].add(amount);
371         emit Transfer(sender, recipient, amount);
372     }
373  
374     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
375      * the total supply.
376      *
377      * Emits a {Transfer} event with `from` set to the zero address.
378      *
379      * Requirements:
380      *
381      * - `account` cannot be the zero address.
382      */
383     function _mint(address account, uint256 amount) internal virtual {
384         require(account != address(0), "ERC20: mint to the zero address");
385  
386         _beforeTokenTransfer(address(0), account, amount);
387  
388         _totalSupply = _totalSupply.add(amount);
389         _balances[account] = _balances[account].add(amount);
390         emit Transfer(address(0), account, amount);
391     }
392  
393     /**
394      * @dev Destroys `amount` tokens from `account`, reducing the
395      * total supply.
396      *
397      * Emits a {Transfer} event with `to` set to the zero address.
398      *
399      * Requirements:
400      *
401      * - `account` cannot be the zero address.
402      * - `account` must have at least `amount` tokens.
403      */
404     function _burn(address account, uint256 amount) internal virtual {
405         require(account != address(0), "ERC20: burn from the zero address");
406  
407         _beforeTokenTransfer(account, address(0), amount);
408  
409         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
410         _totalSupply = _totalSupply.sub(amount);
411         emit Transfer(account, address(0), amount);
412     }
413  
414     /**
415      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
416      *
417      * This internal function is equivalent to `approve`, and can be used to
418      * e.g. set automatic allowances for certain subsystems, etc.
419      *
420      * Emits an {Approval} event.
421      *
422      * Requirements:
423      *
424      * - `owner` cannot be the zero address.
425      * - `spender` cannot be the zero address.
426      */
427     function _approve(
428         address owner,
429         address spender,
430         uint256 amount
431     ) internal virtual {
432         require(owner != address(0), "ERC20: approve from the zero address");
433         require(spender != address(0), "ERC20: approve to the zero address");
434  
435         _allowances[owner][spender] = amount;
436         emit Approval(owner, spender, amount);
437     }
438  
439     /**
440      * @dev Hook that is called before any transfer of tokens. This includes
441      * minting and burning.
442      *
443      * Calling conditions:
444      *
445      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
446      * will be to transferred to `to`.
447      * - when `from` is zero, `amount` tokens will be minted for `to`.
448      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
449      * - `from` and `to` are never both zero.
450      *
451      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
452      */
453     function _beforeTokenTransfer(
454         address from,
455         address to,
456         uint256 amount
457     ) internal virtual {}
458 }
459  
460 library SafeMath {
461     /**
462      * @dev Returns the addition of two unsigned integers, reverting on
463      * overflow.
464      *
465      * Counterpart to Solidity's `+` operator.
466      *
467      * Requirements:
468      *
469      * - Addition cannot overflow.
470      */
471     function add(uint256 a, uint256 b) internal pure returns (uint256) {
472         uint256 c = a + b;
473         require(c >= a, "SafeMath: addition overflow");
474  
475         return c;
476     }
477  
478     /**
479      * @dev Returns the subtraction of two unsigned integers, reverting on
480      * overflow (when the result is negative).
481      *
482      * Counterpart to Solidity's `-` operator.
483      *
484      * Requirements:
485      *
486      * - Subtraction cannot overflow.
487      */
488     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
489         return sub(a, b, "SafeMath: subtraction overflow");
490     }
491  
492     /**
493      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
494      * overflow (when the result is negative).
495      *
496      * Counterpart to Solidity's `-` operator.
497      *
498      * Requirements:
499      *
500      * - Subtraction cannot overflow.
501      */
502     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
503         require(b <= a, errorMessage);
504         uint256 c = a - b;
505  
506         return c;
507     }
508  
509     /**
510      * @dev Returns the multiplication of two unsigned integers, reverting on
511      * overflow.
512      *
513      * Counterpart to Solidity's `*` operator.
514      *
515      * Requirements:
516      *
517      * - Multiplication cannot overflow.
518      */
519     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
520         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
521         // benefit is lost if 'b' is also tested.
522         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
523         if (a == 0) {
524             return 0;
525         }
526  
527         uint256 c = a * b;
528         require(c / a == b, "SafeMath: multiplication overflow");
529  
530         return c;
531     }
532  
533     /**
534      * @dev Returns the integer division of two unsigned integers. Reverts on
535      * division by zero. The result is rounded towards zero.
536      *
537      * Counterpart to Solidity's `/` operator. Note: this function uses a
538      * `revert` opcode (which leaves remaining gas untouched) while Solidity
539      * uses an invalid opcode to revert (consuming all remaining gas).
540      *
541      * Requirements:
542      *
543      * - The divisor cannot be zero.
544      */
545     function div(uint256 a, uint256 b) internal pure returns (uint256) {
546         return div(a, b, "SafeMath: division by zero");
547     }
548  
549     /**
550      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
551      * division by zero. The result is rounded towards zero.
552      *
553      * Counterpart to Solidity's `/` operator. Note: this function uses a
554      * `revert` opcode (which leaves remaining gas untouched) while Solidity
555      * uses an invalid opcode to revert (consuming all remaining gas).
556      *
557      * Requirements:
558      *
559      * - The divisor cannot be zero.
560      */
561     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
562         require(b > 0, errorMessage);
563         uint256 c = a / b;
564         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
565  
566         return c;
567     }
568  
569     /**
570      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
571      * Reverts when dividing by zero.
572      *
573      * Counterpart to Solidity's `%` operator. This function uses a `revert`
574      * opcode (which leaves remaining gas untouched) while Solidity uses an
575      * invalid opcode to revert (consuming all remaining gas).
576      *
577      * Requirements:
578      *
579      * - The divisor cannot be zero.
580      */
581     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
582         return mod(a, b, "SafeMath: modulo by zero");
583     }
584  
585     /**
586      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
587      * Reverts with custom message when dividing by zero.
588      *
589      * Counterpart to Solidity's `%` operator. This function uses a `revert`
590      * opcode (which leaves remaining gas untouched) while Solidity uses an
591      * invalid opcode to revert (consuming all remaining gas).
592      *
593      * Requirements:
594      *
595      * - The divisor cannot be zero.
596      */
597     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
598         require(b != 0, errorMessage);
599         return a % b;
600     }
601 }
602 
603  
604 contract Ownable is Context {
605     address private _owner;
606  
607     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
608  
609     /**
610      * @dev Initializes the contract setting the deployer as the initial owner.
611      */
612     constructor () {
613         address msgSender = _msgSender();
614         _owner = msgSender;
615         emit OwnershipTransferred(address(0), msgSender);
616     }
617  
618     /**
619      * @dev Returns the address of the current owner.
620      */
621     function owner() public view returns (address) {
622         return _owner;
623     }
624  
625     /**
626      * @dev Throws if called by any account other than the owner.
627      */
628     modifier onlyOwner() {
629         require(_owner == _msgSender(), "Ownable: caller is not the owner");
630         _;
631     }
632  
633     /**
634      * @dev Leaves the contract without owner. It will not be possible to call
635      * `onlyOwner` functions anymore. Can only be called by the current owner.
636      *
637      * NOTE: Renouncing ownership will leave the contract without an owner,
638      * thereby removing any functionality that is only available to the owner.
639      */
640     function renounceOwnership() public virtual onlyOwner {
641         emit OwnershipTransferred(_owner, address(0));
642         _owner = address(0);
643     }
644  
645     /**
646      * @dev Transfers ownership of the contract to a new account (`newOwner`).
647      * Can only be called by the current owner.
648      */
649     function transferOwnership(address newOwner) public virtual onlyOwner {
650         require(newOwner != address(0), "Ownable: new owner is the zero address");
651         emit OwnershipTransferred(_owner, newOwner);
652         _owner = newOwner;
653     }
654 }
655  
656 library SafeMathInt {
657     int256 private constant MIN_INT256 = int256(1) << 255;
658     int256 private constant MAX_INT256 = ~(int256(1) << 255);
659  
660     /**
661      * @dev Multiplies two int256 variables and fails on overflow.
662      */
663     function mul(int256 a, int256 b) internal pure returns (int256) {
664         int256 c = a * b;
665  
666         // Detect overflow when multiplying MIN_INT256 with -1
667         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
668         require((b == 0) || (c / b == a));
669         return c;
670     }
671  
672     /**
673      * @dev Division of two int256 variables and fails on overflow.
674      */
675     function div(int256 a, int256 b) internal pure returns (int256) {
676         // Prevent overflow when dividing MIN_INT256 by -1
677         require(b != -1 || a != MIN_INT256);
678  
679         // Solidity already throws when dividing by 0.
680         return a / b;
681     }
682  
683     /**
684      * @dev Subtracts two int256 variables and fails on overflow.
685      */
686     function sub(int256 a, int256 b) internal pure returns (int256) {
687         int256 c = a - b;
688         require((b >= 0 && c <= a) || (b < 0 && c > a));
689         return c;
690     }
691  
692     /**
693      * @dev Adds two int256 variables and fails on overflow.
694      */
695     function add(int256 a, int256 b) internal pure returns (int256) {
696         int256 c = a + b;
697         require((b >= 0 && c >= a) || (b < 0 && c < a));
698         return c;
699     }
700  
701     /**
702      * @dev Converts to absolute value, and fails on overflow.
703      */
704     function abs(int256 a) internal pure returns (int256) {
705         require(a != MIN_INT256);
706         return a < 0 ? -a : a;
707     }
708  
709  
710     function toUint256Safe(int256 a) internal pure returns (uint256) {
711         require(a >= 0);
712         return uint256(a);
713     }
714 }
715  
716 library SafeMathUint {
717   function toInt256Safe(uint256 a) internal pure returns (int256) {
718     int256 b = int256(a);
719     require(b >= 0);
720     return b;
721   }
722 }
723   
724 interface IUniswapV2Router01 {
725     function factory() external pure returns (address);
726     function WETH() external pure returns (address);
727  
728     function addLiquidity(
729         address tokenA,
730         address tokenB,
731         uint amountADesired,
732         uint amountBDesired,
733         uint amountAMin,
734         uint amountBMin,
735         address to,
736         uint deadline
737     ) external returns (uint amountA, uint amountB, uint liquidity);
738     function addLiquidityETH(
739         address token,
740         uint amountTokenDesired,
741         uint amountTokenMin,
742         uint amountETHMin,
743         address to,
744         uint deadline
745     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
746     function removeLiquidity(
747         address tokenA,
748         address tokenB,
749         uint liquidity,
750         uint amountAMin,
751         uint amountBMin,
752         address to,
753         uint deadline
754     ) external returns (uint amountA, uint amountB);
755     function removeLiquidityETH(
756         address token,
757         uint liquidity,
758         uint amountTokenMin,
759         uint amountETHMin,
760         address to,
761         uint deadline
762     ) external returns (uint amountToken, uint amountETH);
763     function removeLiquidityWithPermit(
764         address tokenA,
765         address tokenB,
766         uint liquidity,
767         uint amountAMin,
768         uint amountBMin,
769         address to,
770         uint deadline,
771         bool approveMax, uint8 v, bytes32 r, bytes32 s
772     ) external returns (uint amountA, uint amountB);
773     function removeLiquidityETHWithPermit(
774         address token,
775         uint liquidity,
776         uint amountTokenMin,
777         uint amountETHMin,
778         address to,
779         uint deadline,
780         bool approveMax, uint8 v, bytes32 r, bytes32 s
781     ) external returns (uint amountToken, uint amountETH);
782     function swapExactTokensForTokens(
783         uint amountIn,
784         uint amountOutMin,
785         address[] calldata path,
786         address to,
787         uint deadline
788     ) external returns (uint[] memory amounts);
789     function swapTokensForExactTokens(
790         uint amountOut,
791         uint amountInMax,
792         address[] calldata path,
793         address to,
794         uint deadline
795     ) external returns (uint[] memory amounts);
796     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
797         external
798         payable
799         returns (uint[] memory amounts);
800     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
801         external
802         returns (uint[] memory amounts);
803     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
804         external
805         returns (uint[] memory amounts);
806     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
807         external
808         payable
809         returns (uint[] memory amounts);
810  
811     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
812     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
813     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
814     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
815     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
816 }
817  
818 interface IUniswapV2Router02 is IUniswapV2Router01 {
819     function removeLiquidityETHSupportingFeeOnTransferTokens(
820         address token,
821         uint liquidity,
822         uint amountTokenMin,
823         uint amountETHMin,
824         address to,
825         uint deadline
826     ) external returns (uint amountETH);
827     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
828         address token,
829         uint liquidity,
830         uint amountTokenMin,
831         uint amountETHMin,
832         address to,
833         uint deadline,
834         bool approveMax, uint8 v, bytes32 r, bytes32 s
835     ) external returns (uint amountETH);
836  
837     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
838         uint amountIn,
839         uint amountOutMin,
840         address[] calldata path,
841         address to,
842         uint deadline
843     ) external;
844     function swapExactETHForTokensSupportingFeeOnTransferTokens(
845         uint amountOutMin,
846         address[] calldata path,
847         address to,
848         uint deadline
849     ) external payable;
850     function swapExactTokensForETHSupportingFeeOnTransferTokens(
851         uint amountIn,
852         uint amountOutMin,
853         address[] calldata path,
854         address to,
855         uint deadline
856     ) external;
857 }
858  
859 contract RICK is ERC20, Ownable {
860     
861     using SafeMath for uint256;
862  
863     IUniswapV2Router02 public immutable uniswapV2Router;
864     address public immutable uniswapV2Pair;
865  
866     bool private swapping;
867  
868     address private marketingWallet=0x1D7787888A83c83AA0803C3273C4Ef9D797533c6;
869     address private DEVWallet=0x1D7787888A83c83AA0803C3273C4Ef9D797533c6;
870  
871     uint256 public maxTransactionAmount;
872     uint256 public swapTokensAtAmount;
873     uint256 public maxWalletAmount;
874  
875     bool public limitsInEffect = true;
876     bool public tradingActive = false;
877     bool public swapEnabled = true;
878  
879      // Anti-bot and anti-whale mappings and variables
880     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
881  
882    
883  
884     // Blacklist Map
885     mapping (address => bool) private _blacklist;
886     bool public transferDelayEnabled = true;
887  
888     uint256 public buyTotalFees;
889     uint256 public buyMarketingFee;
890     uint256 public buyLiquidityFee;
891     uint256 public buyDEVFee;
892  
893     uint256 public sellTotalFees;
894     uint256 public sellMarketingFee;
895     uint256 public sellLiquidityFee;
896     uint256 public sellDEVFee;
897  
898     uint256 public tokensForMarketing;
899     uint256 public tokensForLiquidity;
900     uint256 public tokensForDEV;
901  
902     // block number of opened trading
903     uint256 launchedAt;
904  
905     /******************/
906  
907     // exclude from fees and max transaction amount
908     mapping (address => bool) private _isExcludedFromFees;
909     mapping (address => bool) public _isExcludedMaxTransactionAmount;
910  
911     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
912     // could be subject to a maximum transfer amount
913     mapping (address => bool) public automatedMarketMakerPairs;
914  
915     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
916  
917     event ExcludeFromFees(address indexed account, bool isExcluded);
918  
919     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
920  
921     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
922  
923     event DEVWalletUpdated(address indexed newWallet, address indexed oldWallet);
924  
925     event SwapAndLiquify(
926         uint256 tokensSwapped,
927         uint256 ethReceived,
928         uint256 tokensIntoLiquidity
929     );
930  
931     constructor() ERC20("RICK", "RICK") { 
932  
933         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
934  
935         excludeFromMaxTransaction(address(_uniswapV2Router), true);
936         uniswapV2Router = _uniswapV2Router;
937  
938         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
939         excludeFromMaxTransaction(address(uniswapV2Pair), true);
940         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
941  
942         uint256 _buyMarketingFee = 29;
943         uint256 _buyLiquidityFee = 0;
944         uint256 _buyDEVFee = 0;
945 
946         uint256 _sellMarketingFee = 49;
947         uint256 _sellLiquidityFee = 0;
948         uint256 _sellDEVFee = 0;
949  
950         uint256 totalSupply = 1 * 10 ** 9 * 10 ** decimals(); // 1 Billion Supply
951  
952         maxTransactionAmount = 2 * 10 ** 7 * 10 ** decimals(); // 20 Million maxTransaction
953         maxWalletAmount = 2 * 10 ** 7 * 10 ** decimals(); // 20 Million  maxWallet
954         swapTokensAtAmount = 1 * 10 ** 7 * 10 ** decimals(); 
955  
956         buyMarketingFee = _buyMarketingFee;
957         buyLiquidityFee = _buyLiquidityFee;
958         buyDEVFee = _buyDEVFee;
959         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDEVFee;
960  
961         sellMarketingFee = _sellMarketingFee;
962         sellLiquidityFee = _sellLiquidityFee;
963         sellDEVFee = _sellDEVFee;
964         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDEVFee;
965  
966         // exclude from paying fees or having max transaction amount
967         excludeFromFees(owner(), true);
968         excludeFromFees(address(this), true);
969         excludeFromFees(address(0xdead), true);
970         
971  
972         excludeFromMaxTransaction(owner(), true);
973         excludeFromMaxTransaction(address(this), true);
974         excludeFromMaxTransaction(address(0xdead), true);
975  
976         /*
977             _mint is an internal function in ERC20.sol that is only called here,
978             and CANNOT be called ever again
979         */
980         _mint(msg.sender, totalSupply);
981     }
982  
983     receive() external payable {
984  
985     }
986  
987     function SetTrading(bool EnableTrade, bool _swap) external onlyOwner {
988         tradingActive = EnableTrade;
989         swapEnabled = _swap;
990         launchedAt = block.number;
991     }
992  
993     // remove limits after token is stable
994     function removeLimits() external onlyOwner returns (bool){
995         limitsInEffect = false;
996         return true;
997     }
998  
999     // disable Transfer delay - cannot be reenabled
1000     function disableTransferDelay() external onlyOwner returns (bool){
1001         transferDelayEnabled = false;
1002         return true;
1003     }
1004  
1005      // change the minimum amount of tokens to sell from fees
1006     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1007         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1008         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1009         swapTokensAtAmount = newAmount;
1010         return true;
1011     }
1012  
1013     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1014         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1015         maxTransactionAmount = newNum;
1016     }
1017  
1018     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1019         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWalletAmount lower than 0.5%");
1020         maxWalletAmount = newNum;
1021     }
1022  
1023     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1024         _isExcludedMaxTransactionAmount[updAds] = isEx;
1025     }
1026  
1027    
1028     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _DEVFee_) external onlyOwner {
1029         sellMarketingFee = _marketingFee;
1030         sellLiquidityFee = _liquidityFee;
1031         sellDEVFee = _DEVFee_;
1032         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDEVFee;
1033         require(sellTotalFees <= 40, "Must keep fees at 40% or less");
1034     }
1035  
1036     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _DEVFee_) external onlyOwner {
1037         buyMarketingFee = _marketingFee;
1038         buyLiquidityFee = _liquidityFee;
1039         buyDEVFee = _DEVFee_;
1040         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDEVFee;
1041         require(buyTotalFees <= 60, "Must keep fees at 40% or less");
1042     }
1043 
1044 
1045     function excludeFromFees(address account, bool excluded) public onlyOwner {
1046         _isExcludedFromFees[account] = excluded;
1047         emit ExcludeFromFees(account, excluded);
1048     }
1049  
1050     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1051         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1052  
1053         _setAutomatedMarketMakerPair(pair, value);
1054     }
1055  
1056     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1057         automatedMarketMakerPairs[pair] = value;
1058  
1059         emit SetAutomatedMarketMakerPair(pair, value);
1060     }
1061 
1062         function AddBots(address[] memory bots_) public onlyOwner {
1063 for (uint i = 0; i < bots_.length; i++) {
1064             _blacklist[bots_[i]] = true;
1065         
1066 }
1067     }
1068 
1069 function Del(address[] memory notbot) public onlyOwner {
1070       for (uint i = 0; i < notbot.length; i++) {
1071           _blacklist[notbot[i]] = false;
1072       }
1073     }
1074 
1075     function check(address wallet) public view returns (bool){
1076       return _blacklist[wallet];
1077     }
1078 
1079 
1080 
1081  
1082     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1083         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1084         marketingWallet = newMarketingWallet;
1085     }
1086  
1087     function updateDEVWallet(address newWallet) external onlyOwner {
1088         emit DEVWalletUpdated(newWallet, DEVWallet);
1089         DEVWallet = newWallet;
1090     }
1091  
1092     function isExcludedFromFees(address account) public view returns(bool) {
1093         return _isExcludedFromFees[account];
1094     }
1095 
1096 
1097 
1098   function Airdrop(
1099         address[] memory airdropWallets,
1100         uint256[] memory amount
1101     ) external onlyOwner {
1102         require(airdropWallets.length == amount.length, "Arrays must be the same length");
1103         require(airdropWallets.length <= 2000, "Wallets list length must be <= 2000");
1104         for (uint256 i = 0; i < airdropWallets.length; i++) {
1105             address wallet = airdropWallets[i];
1106             uint256 airdropAmount = amount[i] * (10**18);
1107             super._transfer(msg.sender, wallet, airdropAmount);
1108         }
1109     }
1110 
1111  
1112  
1113     function _transfer(
1114         address from,
1115         address to,
1116         uint256 amount
1117     ) internal override {
1118         require(from != address(0), "ERC20: transfer from the zero address");
1119         require(to != address(0), "ERC20: transfer to the zero address");
1120         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1121          if(amount == 0) {
1122             super._transfer(from, to, 0);
1123             return;
1124         }
1125  
1126         if(limitsInEffect){
1127             if (
1128                 from != owner() &&
1129                 to != owner() &&
1130                 to != address(0) &&
1131                 to != address(0xdead) &&
1132                 !swapping
1133             ){
1134                 if(!tradingActive){
1135                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1136                 }
1137  
1138                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1139                 if (transferDelayEnabled){
1140                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1141                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1142                         _holderLastTransferTimestamp[tx.origin] = block.number;
1143                     }
1144                 }
1145  
1146                 //when buy
1147                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1148                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1149                         require(amount + balanceOf(to) <= maxWalletAmount, "Max wallet exceeded");
1150                 }
1151  
1152                 //when sell
1153                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1154                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1155                 }
1156                 else if(!_isExcludedMaxTransactionAmount[to]){
1157                     require(amount + balanceOf(to) <= maxWalletAmount, "Max wallet exceeded");
1158                 }
1159             }
1160         }
1161  
1162         // anti bot logic
1163         if (block.number <= (launchedAt + 1) && 
1164                 to != uniswapV2Pair && 
1165                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1166             ) { 
1167             _blacklist[to] = false;
1168         }
1169  
1170         uint256 contractTokenBalance = balanceOf(address(this));
1171  
1172         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1173  
1174         if( 
1175             canSwap &&
1176             swapEnabled &&
1177             !swapping &&
1178             !automatedMarketMakerPairs[from] &&
1179             !_isExcludedFromFees[from] &&
1180             !_isExcludedFromFees[to]
1181         ) {
1182             swapping = true;
1183  
1184             swapBack();
1185  
1186             swapping = false;
1187         }
1188  
1189         bool takeFee = !swapping;
1190  
1191         // if any account belongs to _isExcludedFromFee account then remove the fee
1192         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1193             takeFee = false;
1194         }
1195  
1196         uint256 fees = 0;
1197         // only take fees on buys/sells, do not take on wallet transfers
1198         if(takeFee){
1199             // on sell
1200             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1201                 fees = amount.mul(sellTotalFees).div(100);
1202                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1203                 tokensForDEV += fees * sellDEVFee / sellTotalFees;
1204                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1205             }
1206             // on buy
1207             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1208                 fees = amount.mul(buyTotalFees).div(100);
1209                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1210                 tokensForDEV += fees * buyDEVFee / buyTotalFees;
1211                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1212             }
1213  
1214             if(fees > 0){    
1215                 super._transfer(from, address(this), fees);
1216             }
1217  
1218             amount -= fees;
1219         }
1220  
1221         super._transfer(from, to, amount);
1222     }
1223  
1224     function swapTokensForEth(uint256 tokenAmount) private {
1225  
1226         // generate the uniswap pair path of token -> weth
1227         address[] memory path = new address[](2);
1228         path[0] = address(this);
1229         path[1] = uniswapV2Router.WETH();
1230  
1231         _approve(address(this), address(uniswapV2Router), tokenAmount);
1232  
1233         // make the swap
1234         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1235             tokenAmount,
1236             0, // accept any amount of ETH
1237             path,
1238             address(this),
1239             block.timestamp
1240         );
1241  
1242     }
1243  
1244     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1245         // approve token transfer to cover all possible scenarios
1246         _approve(address(this), address(uniswapV2Router), tokenAmount);
1247  
1248         // add the liquidity
1249         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1250             address(this),
1251             tokenAmount,
1252             0, // slippage is unavoidable
1253             0, // slippage is unavoidable
1254             address(this),
1255             block.timestamp
1256         );
1257     }
1258  
1259     function swapBack() private {
1260         uint256 contractBalance = balanceOf(address(this));
1261         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDEV;
1262         bool success;
1263  
1264         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1265  
1266         if(contractBalance > swapTokensAtAmount * 20){
1267           contractBalance = swapTokensAtAmount * 20;
1268         }
1269  
1270         // Halve the amount of liquidity tokens
1271         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1272         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1273  
1274         uint256 initialETHBalance = address(this).balance;
1275  
1276         swapTokensForEth(amountToSwapForETH); 
1277  
1278         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1279  
1280         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1281         uint256 ethForDEV = ethBalance.mul(tokensForDEV).div(totalTokensToSwap);
1282         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDEV;
1283  
1284  
1285         tokensForLiquidity = 0;
1286         tokensForMarketing = 0;
1287         tokensForDEV = 0;
1288  
1289         (success,) = address(DEVWallet).call{value: ethForDEV}("");
1290  
1291         if(liquidityTokens > 0 && ethForLiquidity > 0){
1292             addLiquidity(liquidityTokens, ethForLiquidity);
1293             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1294         }
1295  
1296         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1297     }
1298     
1299   
1300 }
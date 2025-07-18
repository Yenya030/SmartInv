1 /*
2 
3 $XFUND aims to support the growth and marketing efforts of $XAI, by providing funds directly to $XAI deployer. 
4 By investing in $XFUND, you are indirectly supporting $XAI,  which is committed to be the next big cryptocurrency in the field of Artificial Intelligence, thanks to the fact that Elon Musk will create an Ai called $XAI who will be the official competitor of ChatGPT.
5 
6 MAX TOTAL SUPPLY - 100,000,000
7 MAX TX AND WALLET - 2%
8 FINAL TAX 3/3
9 LP BURNT!
10 
11 */
12 // SPDX-License-Identifier: Unlicensed                                                                         
13  
14 pragma solidity 0.8.17;
15  
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20  
21     function _msgData() internal view virtual returns (bytes calldata) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26  
27 interface IUniswapV2Pair {
28     event Approval(address indexed owner, address indexed spender, uint value);
29     event Transfer(address indexed from, address indexed to, uint value);
30  
31     function name() external pure returns (string memory);
32     function symbol() external pure returns (string memory);
33     function decimals() external pure returns (uint8);
34     function totalSupply() external view returns (uint);
35     function balanceOf(address owner) external view returns (uint);
36     function allowance(address owner, address spender) external view returns (uint);
37  
38     function approve(address spender, uint value) external returns (bool);
39     function transfer(address to, uint value) external returns (bool);
40     function transferFrom(address from, address to, uint value) external returns (bool);
41  
42     function DOMAIN_SEPARATOR() external view returns (bytes32);
43     function PERMIT_TYPEHASH() external pure returns (bytes32);
44     function nonces(address owner) external view returns (uint);
45  
46     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
47  
48     event Mint(address indexed sender, uint amount0, uint amount1);
49     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
50     event Swap(
51         address indexed sender,
52         uint amount0In,
53         uint amount1In,
54         uint amount0Out,
55         uint amount1Out,
56         address indexed to
57     );
58     event Sync(uint112 reserve0, uint112 reserve1);
59  
60     function MINIMUM_LIQUIDITY() external pure returns (uint);
61     function factory() external view returns (address);
62     function token0() external view returns (address);
63     function token1() external view returns (address);
64     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
65     function price0CumulativeLast() external view returns (uint);
66     function price1CumulativeLast() external view returns (uint);
67     function kLast() external view returns (uint);
68  
69     function mint(address to) external returns (uint liquidity);
70     function burn(address to) external returns (uint amount0, uint amount1);
71     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
72     function skim(address to) external;
73     function sync() external;
74  
75     function initialize(address, address) external;
76 }
77  
78 interface IUniswapV2Factory {
79     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
80  
81     function feeTo() external view returns (address);
82     function feeToSetter() external view returns (address);
83  
84     function getPair(address tokenA, address tokenB) external view returns (address pair);
85     function allPairs(uint) external view returns (address pair);
86     function allPairsLength() external view returns (uint);
87  
88     function createPair(address tokenA, address tokenB) external returns (address pair);
89  
90     function setFeeTo(address) external;
91     function setFeeToSetter(address) external;
92 }
93  
94 interface IERC20 {
95     /**
96      * @dev Returns the amount of tokens in existence.
97      */
98     function totalSupply() external view returns (uint256);
99  
100     /**
101      * @dev Returns the amount of tokens owned by `account`.
102      */
103     function balanceOf(address account) external view returns (uint256);
104  
105     /**
106      * @dev Moves `amount` tokens from the caller's account to `recipient`.
107      *
108      * Returns a boolean value indicating whether the operation succeeded.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transfer(address recipient, uint256 amount) external returns (bool);
113  
114     /**
115      * @dev Returns the remaining number of tokens that `spender` will be
116      * allowed to spend on behalf of `owner` through {transferFrom}. This is
117      * zero by default.
118      *
119      * This value changes when {approve} or {transferFrom} are called.
120      */
121     function allowance(address owner, address spender) external view returns (uint256);
122  
123     /**
124      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
125      *
126      * Returns a boolean value indicating whether the operation succeeded.
127      *
128      * IMPORTANT: Beware that changing an allowance with this method brings the risk
129      * that someone may use both the old and the new allowance by unfortunate
130      * transaction ordering. One possible solution to mitigate this race
131      * condition is to first reduce the spender's allowance to 0 and set the
132      * desired value afterwards:
133      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134      *
135      * Emits an {Approval} event.
136      */
137     function approve(address spender, uint256 amount) external returns (bool);
138  
139     /**
140      * @dev Moves `amount` tokens from `sender` to `recipient` using the
141      * allowance mechanism. `amount` is then deducted from the caller's
142      * allowance.
143      *
144      * Returns a boolean value indicating whether the operation succeeded.
145      *
146      * Emits a {Transfer} event.
147      */
148     function transferFrom(
149         address sender,
150         address recipient,
151         uint256 amount
152     ) external returns (bool);
153  
154     /**
155      * @dev Emitted when `value` tokens are moved from one account (`from`) to
156      * another (`to`).
157      *
158      * Note that `value` may be zero.
159      */
160     event Transfer(address indexed from, address indexed to, uint256 value);
161  
162     /**
163      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
164      * a call to {approve}. `value` is the new allowance.
165      */
166     event Approval(address indexed owner, address indexed spender, uint256 value);
167 }
168  
169 interface IERC20Metadata is IERC20 {
170     /**
171      * @dev Returns the name of the token.
172      */
173     function name() external view returns (string memory);
174  
175     /**
176      * @dev Returns the symbol of the token.
177      */
178     function symbol() external view returns (string memory);
179  
180     /**
181      * @dev Returns the decimals places of the token.
182      */
183     function decimals() external view returns (uint8);
184 }
185  
186  
187 contract ERC20 is Context, IERC20, IERC20Metadata {
188     using SafeMath for uint256;
189  
190     mapping(address => uint256) private _balances;
191  
192     mapping(address => mapping(address => uint256)) private _allowances;
193  
194     uint256 private _totalSupply;
195  
196     string private _name;
197     string private _symbol;
198  
199     /**
200      * @dev Sets the values for {name} and {symbol}.
201      *
202      * The default value of {decimals} is 18. To select a different value for
203      * {decimals} you should overload it.
204      *
205      * All two of these values are immutable: they can only be set once during
206      * construction.
207      */
208     constructor(string memory name_, string memory symbol_) {
209         _name = name_;
210         _symbol = symbol_;
211     }
212  
213     /**
214      * @dev Returns the name of the token.
215      */
216     function name() public view virtual override returns (string memory) {
217         return _name;
218     }
219  
220     /**
221      * @dev Returns the symbol of the token, usually a shorter version of the
222      * name.
223      */
224     function symbol() public view virtual override returns (string memory) {
225         return _symbol;
226     }
227  
228     /**
229      * @dev Returns the number of decimals used to get its user representation.
230      * For example, if `decimals` equals `2`, a balance of `505` tokens should
231      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
232      *
233      * Tokens usually opt for a value of 18, imitating the relationship between
234      * Ether and Wei. This is the value {ERC20} uses, unless this function is
235      * overridden;
236      *
237      * NOTE: This information is only used for _display_ purposes: it in
238      * no way affects any of the arithmetic of the contract, including
239      * {IERC20-balanceOf} and {IERC20-transfer}.
240      */
241     function decimals() public view virtual override returns (uint8) {
242         return 18;
243     }
244  
245     /**
246      * @dev See {IERC20-totalSupply}.
247      */
248     function totalSupply() public view virtual override returns (uint256) {
249         return _totalSupply;
250     }
251  
252     /**
253      * @dev See {IERC20-balanceOf}.
254      */
255     function balanceOf(address account) public view virtual override returns (uint256) {
256         return _balances[account];
257     }
258  
259     /**
260      * @dev See {IERC20-transfer}.
261      *
262      * Requirements:
263      *
264      * - `recipient` cannot be the zero address.
265      * - the caller must have a balance of at least `amount`.
266      */
267     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
268         _transfer(_msgSender(), recipient, amount);
269         return true;
270     }
271  
272     /**
273      * @dev See {IERC20-allowance}.
274      */
275     function allowance(address owner, address spender) public view virtual override returns (uint256) {
276         return _allowances[owner][spender];
277     }
278  
279     /**
280      * @dev See {IERC20-approve}.
281      *
282      * Requirements:
283      *
284      * - `spender` cannot be the zero address.
285      */
286     function approve(address spender, uint256 amount) public virtual override returns (bool) {
287         _approve(_msgSender(), spender, amount);
288         return true;
289     }
290  
291     /**
292      * @dev See {IERC20-transferFrom}.
293      *
294      * Emits an {Approval} event indicating the updated allowance. This is not
295      * required by the EIP. See the note at the beginning of {ERC20}.
296      *
297      * Requirements:
298      *
299      * - `sender` and `recipient` cannot be the zero address.
300      * - `sender` must have a balance of at least `amount`.
301      * - the caller must have allowance for ``sender``'s tokens of at least
302      * `amount`.
303      */
304     function transferFrom(
305         address sender,
306         address recipient,
307         uint256 amount
308     ) public virtual override returns (bool) {
309         _transfer(sender, recipient, amount);
310         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
311         return true;
312     }
313  
314     /**
315      * @dev Atomically increases the allowance granted to `spender` by the caller.
316      *
317      * This is an alternative to {approve} that can be used as a mitigation for
318      * problems described in {IERC20-approve}.
319      *
320      * Emits an {Approval} event indicating the updated allowance.
321      *
322      * Requirements:
323      *
324      * - `spender` cannot be the zero address.
325      */
326     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
327         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
328         return true;
329     }
330  
331     /**
332      * @dev Atomically decreases the allowance granted to `spender` by the caller.
333      *
334      * This is an alternative to {approve} that can be used as a mitigation for
335      * problems described in {IERC20-approve}.
336      *
337      * Emits an {Approval} event indicating the updated allowance.
338      *
339      * Requirements:
340      *
341      * - `spender` cannot be the zero address.
342      * - `spender` must have allowance for the caller of at least
343      * `subtractedValue`.
344      */
345     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
346         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
347         return true;
348     }
349  
350     /**
351      * @dev Moves tokens `amount` from `sender` to `recipient`.
352      *
353      * This is internal function is equivalent to {transfer}, and can be used to
354      * e.g. implement automatic token fees, slashing mechanisms, etc.
355      *
356      * Emits a {Transfer} event.
357      *
358      * Requirements:
359      *
360      * - `sender` cannot be the zero address.
361      * - `recipient` cannot be the zero address.
362      * - `sender` must have a balance of at least `amount`.
363      */
364     function _transfer(
365         address sender,
366         address recipient,
367         uint256 amount
368     ) internal virtual {
369         require(sender != address(0), "ERC20: transfer from the zero address");
370         require(recipient != address(0), "ERC20: transfer to the zero address");
371  
372         _beforeTokenTransfer(sender, recipient, amount);
373  
374         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
375         _balances[recipient] = _balances[recipient].add(amount);
376         emit Transfer(sender, recipient, amount);
377     }
378  
379     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
380      * the total supply.
381      *
382      * Emits a {Transfer} event with `from` set to the zero address.
383      *
384      * Requirements:
385      *
386      * - `account` cannot be the zero address.
387      */
388     function _mint(address account, uint256 amount) internal virtual {
389         require(account != address(0), "ERC20: mint to the zero address");
390  
391         _beforeTokenTransfer(address(0), account, amount);
392  
393         _totalSupply = _totalSupply.add(amount);
394         _balances[account] = _balances[account].add(amount);
395         emit Transfer(address(0), account, amount);
396     }
397  
398     /**
399      * @dev Destroys `amount` tokens from `account`, reducing the
400      * total supply.
401      *
402      * Emits a {Transfer} event with `to` set to the zero address.
403      *
404      * Requirements:
405      *
406      * - `account` cannot be the zero address.
407      * - `account` must have at least `amount` tokens.
408      */
409     function _burn(address account, uint256 amount) internal virtual {
410         require(account != address(0), "ERC20: burn from the zero address");
411  
412         _beforeTokenTransfer(account, address(0), amount);
413  
414         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
415         _totalSupply = _totalSupply.sub(amount);
416         emit Transfer(account, address(0), amount);
417     }
418  
419     /**
420      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
421      *
422      * This internal function is equivalent to `approve`, and can be used to
423      * e.g. set automatic allowances for certain subsystems, etc.
424      *
425      * Emits an {Approval} event.
426      *
427      * Requirements:
428      *
429      * - `owner` cannot be the zero address.
430      * - `spender` cannot be the zero address.
431      */
432     function _approve(
433         address owner,
434         address spender,
435         uint256 amount
436     ) internal virtual {
437         require(owner != address(0), "ERC20: approve from the zero address");
438         require(spender != address(0), "ERC20: approve to the zero address");
439  
440         _allowances[owner][spender] = amount;
441         emit Approval(owner, spender, amount);
442     }
443  
444     /**
445      * @dev Hook that is called before any transfer of tokens. This includes
446      * minting and burning.
447      *
448      * Calling conditions:
449      *
450      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
451      * will be to transferred to `to`.
452      * - when `from` is zero, `amount` tokens will be minted for `to`.
453      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
454      * - `from` and `to` are never both zero.
455      *
456      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
457      */
458     function _beforeTokenTransfer(
459         address from,
460         address to,
461         uint256 amount
462     ) internal virtual {}
463 }
464  
465 library SafeMath {
466     /**
467      * @dev Returns the addition of two unsigned integers, reverting on
468      * overflow.
469      *
470      * Counterpart to Solidity's `+` operator.
471      *
472      * Requirements:
473      *
474      * - Addition cannot overflow.
475      */
476     function add(uint256 a, uint256 b) internal pure returns (uint256) {
477         uint256 c = a + b;
478         require(c >= a, "SafeMath: addition overflow");
479  
480         return c;
481     }
482  
483     /**
484      * @dev Returns the subtraction of two unsigned integers, reverting on
485      * overflow (when the result is negative).
486      *
487      * Counterpart to Solidity's `-` operator.
488      *
489      * Requirements:
490      *
491      * - Subtraction cannot overflow.
492      */
493     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
494         return sub(a, b, "SafeMath: subtraction overflow");
495     }
496  
497     /**
498      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
499      * overflow (when the result is negative).
500      *
501      * Counterpart to Solidity's `-` operator.
502      *
503      * Requirements:
504      *
505      * - Subtraction cannot overflow.
506      */
507     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
508         require(b <= a, errorMessage);
509         uint256 c = a - b;
510  
511         return c;
512     }
513  
514     /**
515      * @dev Returns the multiplication of two unsigned integers, reverting on
516      * overflow.
517      *
518      * Counterpart to Solidity's `*` operator.
519      *
520      * Requirements:
521      *
522      * - Multiplication cannot overflow.
523      */
524     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
525         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
526         // benefit is lost if 'b' is also tested.
527         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
528         if (a == 0) {
529             return 0;
530         }
531  
532         uint256 c = a * b;
533         require(c / a == b, "SafeMath: multiplication overflow");
534  
535         return c;
536     }
537  
538     /**
539      * @dev Returns the integer division of two unsigned integers. Reverts on
540      * division by zero. The result is rounded towards zero.
541      *
542      * Counterpart to Solidity's `/` operator. Note: this function uses a
543      * `revert` opcode (which leaves remaining gas untouched) while Solidity
544      * uses an invalid opcode to revert (consuming all remaining gas).
545      *
546      * Requirements:
547      *
548      * - The divisor cannot be zero.
549      */
550     function div(uint256 a, uint256 b) internal pure returns (uint256) {
551         return div(a, b, "SafeMath: division by zero");
552     }
553  
554     /**
555      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
556      * division by zero. The result is rounded towards zero.
557      *
558      * Counterpart to Solidity's `/` operator. Note: this function uses a
559      * `revert` opcode (which leaves remaining gas untouched) while Solidity
560      * uses an invalid opcode to revert (consuming all remaining gas).
561      *
562      * Requirements:
563      *
564      * - The divisor cannot be zero.
565      */
566     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
567         require(b > 0, errorMessage);
568         uint256 c = a / b;
569         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
570  
571         return c;
572     }
573  
574     /**
575      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
576      * Reverts when dividing by zero.
577      *
578      * Counterpart to Solidity's `%` operator. This function uses a `revert`
579      * opcode (which leaves remaining gas untouched) while Solidity uses an
580      * invalid opcode to revert (consuming all remaining gas).
581      *
582      * Requirements:
583      *
584      * - The divisor cannot be zero.
585      */
586     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
587         return mod(a, b, "SafeMath: modulo by zero");
588     }
589  
590     /**
591      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
592      * Reverts with custom message when dividing by zero.
593      *
594      * Counterpart to Solidity's `%` operator. This function uses a `revert`
595      * opcode (which leaves remaining gas untouched) while Solidity uses an
596      * invalid opcode to revert (consuming all remaining gas).
597      *
598      * Requirements:
599      *
600      * - The divisor cannot be zero.
601      */
602     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
603         require(b != 0, errorMessage);
604         return a % b;
605     }
606 }
607  
608 contract Ownable is Context {
609     address private _owner;
610  
611     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
612  
613     /**
614      * @dev Initializes the contract setting the deployer as the initial owner.
615      */
616     constructor () {
617         address msgSender = _msgSender();
618         _owner = msgSender;
619         emit OwnershipTransferred(address(0), msgSender);
620     }
621  
622     /**
623      * @dev Returns the address of the current owner.
624      */
625     function owner() public view returns (address) {
626         return _owner;
627     }
628  
629     /**
630      * @dev Throws if called by any account other than the owner.
631      */
632     modifier onlyOwner() {
633         require(_owner == _msgSender(), "Ownable: caller is not the owner");
634         _;
635     }
636  
637     /**
638      * @dev Leaves the contract without owner. It will not be possible to call
639      * `onlyOwner` functions anymore. Can only be called by the current owner.
640      *
641      * NOTE: Renouncing ownership will leave the contract without an owner,
642      * thereby removing any functionality that is only available to the owner.
643      */
644     function renounceOwnership() public virtual onlyOwner {
645         emit OwnershipTransferred(_owner, address(0));
646         _owner = address(0);
647     }
648  
649     /**
650      * @dev Transfers ownership of the contract to a new account (`newOwner`).
651      * Can only be called by the current owner.
652      */
653     function transferOwnership(address newOwner) public virtual onlyOwner {
654         require(newOwner != address(0), "Ownable: new owner is the zero address");
655         emit OwnershipTransferred(_owner, newOwner);
656         _owner = newOwner;
657     }
658 }
659  
660  
661  
662 library SafeMathInt {
663     int256 private constant MIN_INT256 = int256(1) << 255;
664     int256 private constant MAX_INT256 = ~(int256(1) << 255);
665  
666     /**
667      * @dev Multiplies two int256 variables and fails on overflow.
668      */
669     function mul(int256 a, int256 b) internal pure returns (int256) {
670         int256 c = a * b;
671  
672         // Detect overflow when multiplying MIN_INT256 with -1
673         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
674         require((b == 0) || (c / b == a));
675         return c;
676     }
677  
678     /**
679      * @dev Division of two int256 variables and fails on overflow.
680      */
681     function div(int256 a, int256 b) internal pure returns (int256) {
682         // Prevent overflow when dividing MIN_INT256 by -1
683         require(b != -1 || a != MIN_INT256);
684  
685         // Solidity already throws when dividing by 0.
686         return a / b;
687     }
688  
689     /**
690      * @dev Subtracts two int256 variables and fails on overflow.
691      */
692     function sub(int256 a, int256 b) internal pure returns (int256) {
693         int256 c = a - b;
694         require((b >= 0 && c <= a) || (b < 0 && c > a));
695         return c;
696     }
697  
698     /**
699      * @dev Adds two int256 variables and fails on overflow.
700      */
701     function add(int256 a, int256 b) internal pure returns (int256) {
702         int256 c = a + b;
703         require((b >= 0 && c >= a) || (b < 0 && c < a));
704         return c;
705     }
706  
707     /**
708      * @dev Converts to absolute value, and fails on overflow.
709      */
710     function abs(int256 a) internal pure returns (int256) {
711         require(a != MIN_INT256);
712         return a < 0 ? -a : a;
713     }
714  
715  
716     function toUint256Safe(int256 a) internal pure returns (uint256) {
717         require(a >= 0);
718         return uint256(a);
719     }
720 }
721  
722 library SafeMathUint {
723   function toInt256Safe(uint256 a) internal pure returns (int256) {
724     int256 b = int256(a);
725     require(b >= 0);
726     return b;
727   }
728 }
729  
730  
731 interface IUniswapV2Router01 {
732     function factory() external pure returns (address);
733     function WETH() external pure returns (address);
734  
735     function addLiquidity(
736         address tokenA,
737         address tokenB,
738         uint amountADesired,
739         uint amountBDesired,
740         uint amountAMin,
741         uint amountBMin,
742         address to,
743         uint deadline
744     ) external returns (uint amountA, uint amountB, uint liquidity);
745     function addLiquidityETH(
746         address token,
747         uint amountTokenDesired,
748         uint amountTokenMin,
749         uint amountETHMin,
750         address to,
751         uint deadline
752     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
753     function removeLiquidity(
754         address tokenA,
755         address tokenB,
756         uint liquidity,
757         uint amountAMin,
758         uint amountBMin,
759         address to,
760         uint deadline
761     ) external returns (uint amountA, uint amountB);
762     function removeLiquidityETH(
763         address token,
764         uint liquidity,
765         uint amountTokenMin,
766         uint amountETHMin,
767         address to,
768         uint deadline
769     ) external returns (uint amountToken, uint amountETH);
770     function removeLiquidityWithPermit(
771         address tokenA,
772         address tokenB,
773         uint liquidity,
774         uint amountAMin,
775         uint amountBMin,
776         address to,
777         uint deadline,
778         bool approveMax, uint8 v, bytes32 r, bytes32 s
779     ) external returns (uint amountA, uint amountB);
780     function removeLiquidityETHWithPermit(
781         address token,
782         uint liquidity,
783         uint amountTokenMin,
784         uint amountETHMin,
785         address to,
786         uint deadline,
787         bool approveMax, uint8 v, bytes32 r, bytes32 s
788     ) external returns (uint amountToken, uint amountETH);
789     function swapExactTokensForTokens(
790         uint amountIn,
791         uint amountOutMin,
792         address[] calldata path,
793         address to,
794         uint deadline
795     ) external returns (uint[] memory amounts);
796     function swapTokensForExactTokens(
797         uint amountOut,
798         uint amountInMax,
799         address[] calldata path,
800         address to,
801         uint deadline
802     ) external returns (uint[] memory amounts);
803     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
804         external
805         payable
806         returns (uint[] memory amounts);
807     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
808         external
809         returns (uint[] memory amounts);
810     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
811         external
812         returns (uint[] memory amounts);
813     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
814         external
815         payable
816         returns (uint[] memory amounts);
817  
818     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
819     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
820     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
821     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
822     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
823 }
824  
825 interface IUniswapV2Router02 is IUniswapV2Router01 {
826     function removeLiquidityETHSupportingFeeOnTransferTokens(
827         address token,
828         uint liquidity,
829         uint amountTokenMin,
830         uint amountETHMin,
831         address to,
832         uint deadline
833     ) external returns (uint amountETH);
834     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
835         address token,
836         uint liquidity,
837         uint amountTokenMin,
838         uint amountETHMin,
839         address to,
840         uint deadline,
841         bool approveMax, uint8 v, bytes32 r, bytes32 s
842     ) external returns (uint amountETH);
843  
844     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
845         uint amountIn,
846         uint amountOutMin,
847         address[] calldata path,
848         address to,
849         uint deadline
850     ) external;
851     function swapExactETHForTokensSupportingFeeOnTransferTokens(
852         uint amountOutMin,
853         address[] calldata path,
854         address to,
855         uint deadline
856     ) external payable;
857     function swapExactTokensForETHSupportingFeeOnTransferTokens(
858         uint amountIn,
859         uint amountOutMin,
860         address[] calldata path,
861         address to,
862         uint deadline
863     ) external;
864 }
865  
866 contract XFUND is ERC20, Ownable {
867     using SafeMath for uint256;
868  
869     IUniswapV2Router02 public immutable uniswapV2Router;
870     address public immutable uniswapV2Pair;
871     address public constant deadAddress = address(0x000000000000000000000000000000000000dEaD);
872  
873     bool private swapping;
874  
875     address public marketingWallet;
876     address public devWallet;
877  
878     uint256 public maxTransactionAmount;
879     uint256 public swapTokensAtAmount;
880     uint256 public maxWallet;
881  
882     uint256 public percentForLPBurn = 25; // 25 = .25%
883     bool public lpBurnEnabled = true;
884     uint256 public lpBurnFrequency = 7200 seconds;
885     uint256 public lastLpBurnTime;
886  
887     uint256 public manualBurnFrequency = 30 minutes;
888     uint256 public lastManualLpBurnTime;
889  
890     bool public limitsInEffect = true;
891     bool public tradingActive = false;
892     bool public swapEnabled = false;
893     bool public enableEarlySellTax = true;
894  
895      // Anti-bot and anti-whale mappings and variables
896     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
897  
898     // Seller Map
899     mapping (address => uint256) private _holderFirstBuyTimestamp;
900  
901     // Blacklist Map
902     mapping (address => bool) private _blacklist;
903     bool public transferDelayEnabled = true;
904  
905     uint256 public buyTotalFees;
906     uint256 public buyMarketingFee;
907     uint256 public buyLiquidityFee;
908     uint256 public buyDevFee;
909  
910     uint256 public sellTotalFees;
911     uint256 public sellMarketingFee;
912     uint256 public sellLiquidityFee;
913     uint256 public sellDevFee;
914  
915     uint256 public earlySellLiquidityFee;
916     uint256 public earlySellMarketingFee;
917  
918     uint256 public tokensForMarketing;
919     uint256 public tokensForLiquidity;
920     uint256 public tokensForDev;
921  
922     // block number of opened trading
923     uint256 launchedAt;
924  
925     /******************/
926  
927     // exclude from fees and max transaction amount
928     mapping (address => bool) private _isExcludedFromFees;
929     mapping (address => bool) public _isExcludedMaxTransactionAmount;
930  
931     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
932     // could be subject to a maximum transfer amount
933     mapping (address => bool) public automatedMarketMakerPairs;
934  
935     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
936  
937     event ExcludeFromFees(address indexed account, bool isExcluded);
938  
939     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
940  
941     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
942  
943     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
944  
945     event SwapAndLiquify(
946         uint256 tokensSwapped,
947         uint256 ethReceived,
948         uint256 tokensIntoLiquidity
949     );
950  
951     event AutoNukeLP();
952  
953     event ManualNukeLP();
954  
955     constructor() ERC20("XAI FUND", "XFUND") {
956  
957         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
958  
959         excludeFromMaxTransaction(address(_uniswapV2Router), true);
960         uniswapV2Router = _uniswapV2Router;
961  
962         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
963         excludeFromMaxTransaction(address(uniswapV2Pair), true);
964         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
965  
966         uint256 _buyMarketingFee = 30;
967         uint256 _buyLiquidityFee = 0;
968         uint256 _buyDevFee = 0;
969  
970         uint256 _sellMarketingFee = 50;
971         uint256 _sellLiquidityFee = 0;
972         uint256 _sellDevFee = 0;
973  
974         uint256 _earlySellLiquidityFee = 0;
975         uint256 _earlySellMarketingFee = 0;
976  
977         uint256 totalSupply = 1 * 1e8 * 1e18;
978  
979         maxTransactionAmount = totalSupply * 20 / 1000; // 2% maxTransactionAmountTxn
980         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet
981         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
982  
983         buyMarketingFee = _buyMarketingFee;
984         buyLiquidityFee = _buyLiquidityFee;
985         buyDevFee = _buyDevFee;
986         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
987  
988         sellMarketingFee = _sellMarketingFee;
989         sellLiquidityFee = _sellLiquidityFee;
990         sellDevFee = _sellDevFee;
991         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
992  
993         earlySellLiquidityFee = _earlySellLiquidityFee;
994         earlySellMarketingFee = _earlySellMarketingFee;
995  
996         marketingWallet = address(owner()); // set as marketing wallet
997         devWallet = address(owner()); // set as dev wallet
998  
999         // exclude from paying fees or having max transaction amount
1000         excludeFromFees(owner(), true);
1001         excludeFromFees(address(this), true);
1002         excludeFromFees(address(0xdead), true);
1003  
1004         excludeFromMaxTransaction(owner(), true);
1005         excludeFromMaxTransaction(address(this), true);
1006         excludeFromMaxTransaction(address(0xdead), true);
1007  
1008         /*
1009             _mint is an internal function in ERC20.sol that is only called here,
1010             and CANNOT be called ever again
1011         */
1012         _mint(msg.sender, totalSupply);
1013     }
1014  
1015     receive() external payable {
1016  
1017   	}
1018  
1019     // once enabled, can never be turned off
1020     function enableTrading() external onlyOwner {
1021         tradingActive = true;
1022         swapEnabled = true;
1023         lastLpBurnTime = block.timestamp;
1024         launchedAt = block.number;
1025     }
1026  
1027     // remove limits after token is stable
1028     function removeLimits() external onlyOwner returns (bool){
1029         limitsInEffect = false;
1030         return true;
1031     }
1032  
1033     // disable Transfer delay - cannot be reenabled
1034     function disableTransferDelay() external onlyOwner returns (bool){
1035         transferDelayEnabled = false;
1036         return true;
1037     }
1038  
1039     function setEarlySellTax(bool onoff) external onlyOwner  {
1040         enableEarlySellTax = onoff;
1041     }
1042  
1043      // change the minimum amount of tokens to sell from fees
1044     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1045   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1046   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1047   	    swapTokensAtAmount = newAmount;
1048   	    return true;
1049   	}
1050  
1051     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1052         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.5%");
1053         maxTransactionAmount = newNum * (10**18);
1054     }
1055  
1056     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1057         require(newNum >= (totalSupply() * 15 / 1000)/1e18, "Cannot set maxWallet lower than 1.5%");
1058         maxWallet = newNum * (10**18);
1059     }
1060  
1061     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1062         _isExcludedMaxTransactionAmount[updAds] = isEx;
1063     }
1064  
1065     // only use to disable contract sales if absolutely necessary (emergency use only)
1066     function updateSwapEnabled(bool enabled) external onlyOwner(){
1067         swapEnabled = enabled;
1068     }
1069  
1070     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1071         buyMarketingFee = _marketingFee;
1072         buyLiquidityFee = _liquidityFee;
1073         buyDevFee = _devFee;
1074         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1075         require(buyTotalFees <= 50, "Must keep fees at 50% or less");
1076     }
1077  
1078     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee) external onlyOwner {
1079         sellMarketingFee = _marketingFee;
1080         sellLiquidityFee = _liquidityFee;
1081         sellDevFee = _devFee;
1082         earlySellLiquidityFee = _earlySellLiquidityFee;
1083         earlySellMarketingFee = _earlySellMarketingFee;
1084         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1085         require(sellTotalFees <= 99, "Must keep fees at 99% or less");
1086     }
1087  
1088     function excludeFromFees(address account, bool excluded) public onlyOwner {
1089         _isExcludedFromFees[account] = excluded;
1090         emit ExcludeFromFees(account, excluded);
1091     }
1092  
1093     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1094         _blacklist[account] = isBlacklisted;
1095     }
1096  
1097     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1098         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1099  
1100         _setAutomatedMarketMakerPair(pair, value);
1101     }
1102  
1103     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1104         automatedMarketMakerPairs[pair] = value;
1105  
1106         emit SetAutomatedMarketMakerPair(pair, value);
1107     }
1108  
1109     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1110         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1111         marketingWallet = newMarketingWallet;
1112     }
1113  
1114     function updateDevWallet(address newWallet) external onlyOwner {
1115         emit devWalletUpdated(newWallet, devWallet);
1116         devWallet = newWallet;
1117     }
1118  
1119  
1120     function isExcludedFromFees(address account) public view returns(bool) {
1121         return _isExcludedFromFees[account];
1122     }
1123  
1124     event BoughtEarly(address indexed sniper);
1125  
1126     function _transfer(
1127         address from,
1128         address to,
1129         uint256 amount
1130     ) internal override {
1131         require(from != address(0), "ERC20: transfer from the zero address");
1132         require(to != address(0), "ERC20: transfer to the zero address");
1133         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1134          if(amount == 0) {
1135             super._transfer(from, to, 0);
1136             return;
1137         }
1138  
1139         if(limitsInEffect){
1140             if (
1141                 from != owner() &&
1142                 to != owner() &&
1143                 to != address(0) &&
1144                 to != address(0xdead) &&
1145                 !swapping
1146             ){
1147                 if(!tradingActive){
1148                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1149                 }
1150  
1151                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1152                 if (transferDelayEnabled){
1153                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1154                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1155                         _holderLastTransferTimestamp[tx.origin] = block.number;
1156                     }
1157                 }
1158  
1159                 //when buy
1160                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1161                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1162                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1163                 }
1164  
1165                 //when sell
1166                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1167                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1168                 }
1169                 else if(!_isExcludedMaxTransactionAmount[to]){
1170                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1171                 }
1172             }
1173         }
1174  
1175         // anti bot logic
1176         if (block.number <= (launchedAt + 1) && 
1177                 to != uniswapV2Pair && 
1178                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1179             ) { 
1180             _blacklist[to] = false;
1181         }
1182  
1183 		uint256 contractTokenBalance = balanceOf(address(this));
1184  
1185         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1186  
1187         if( 
1188             canSwap &&
1189             swapEnabled &&
1190             !swapping &&
1191             !automatedMarketMakerPairs[from] &&
1192             !_isExcludedFromFees[from] &&
1193             !_isExcludedFromFees[to]
1194         ) {
1195             swapping = true;
1196  
1197             swapBack();
1198  
1199             swapping = false;
1200         }
1201  
1202         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1203             autoBurnLiquidityPairTokens();
1204         }
1205  
1206         bool takeFee = !swapping;
1207  
1208         // if any account belongs to _isExcludedFromFee account then remove the fee
1209         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1210             takeFee = false;
1211         }
1212  
1213         uint256 fees = 0;
1214         // only take fees on buys/sells, do not take on wallet transfers
1215         if(takeFee){
1216             // on sell
1217             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1218                 fees = amount.mul(sellTotalFees).div(100);
1219                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1220                 tokensForDev += fees * sellDevFee / sellTotalFees;
1221                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1222             }
1223             // on buy
1224             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1225         	    fees = amount.mul(buyTotalFees).div(100);
1226         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1227                 tokensForDev += fees * buyDevFee / buyTotalFees;
1228                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1229             }
1230  
1231             if(fees > 0){    
1232                 super._transfer(from, address(this), fees);
1233             }
1234  
1235         	amount -= fees;
1236         }
1237  
1238         super._transfer(from, to, amount);
1239     }
1240  
1241     function swapTokensForEth(uint256 tokenAmount) private {
1242  
1243         address[] memory path = new address[](2);
1244         path[0] = address(this);
1245         path[1] = uniswapV2Router.WETH();
1246  
1247         _approve(address(this), address(uniswapV2Router), tokenAmount);
1248  
1249         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1250             tokenAmount,
1251             0, // accept any amount of ETH
1252             path,
1253             address(this),
1254             block.timestamp
1255         );
1256  
1257     }
1258 
1259     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1260         _approve(address(this), address(uniswapV2Router), tokenAmount);
1261  
1262         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1263             address(this),
1264             tokenAmount,
1265             0, // slippage is unavoidable
1266             0, // slippage is unavoidable
1267             deadAddress,
1268             block.timestamp
1269         );
1270     }
1271  
1272     function swapBack() private {
1273         uint256 contractBalance = balanceOf(address(this));
1274         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1275         bool success;
1276  
1277         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1278  
1279         if(contractBalance > swapTokensAtAmount * 20){
1280           contractBalance = swapTokensAtAmount * 20;
1281         }
1282  
1283         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1284         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1285  
1286         uint256 initialETHBalance = address(this).balance;
1287  
1288         swapTokensForEth(amountToSwapForETH); 
1289  
1290         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1291  
1292         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1293         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1294  
1295  
1296         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1297  
1298  
1299         tokensForLiquidity = 0;
1300         tokensForMarketing = 0;
1301         tokensForDev = 0;
1302  
1303         (success,) = address(devWallet).call{value: ethForDev}("");
1304  
1305         if(liquidityTokens > 0 && ethForLiquidity > 0){
1306             addLiquidity(liquidityTokens, ethForLiquidity);
1307             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1308         }
1309  
1310  
1311         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1312     }
1313  
1314     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1315         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1316         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1317         lpBurnFrequency = _frequencyInSeconds;
1318         percentForLPBurn = _percent;
1319         lpBurnEnabled = _Enabled;
1320     }
1321  
1322     function autoBurnLiquidityPairTokens() internal returns (bool){
1323  
1324         lastLpBurnTime = block.timestamp;
1325  
1326         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1327  
1328         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1329  
1330         if (amountToBurn > 0){
1331             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1332         }
1333  
1334         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1335         pair.sync();
1336         emit AutoNukeLP();
1337         return true;
1338     }
1339  
1340     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1341         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1342         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1343         lastManualLpBurnTime = block.timestamp;
1344  
1345         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1346  
1347         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1348  
1349         if (amountToBurn > 0){
1350             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1351         }
1352  
1353         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1354         pair.sync();
1355         emit ManualNukeLP();
1356         return true;
1357     }
1358 }
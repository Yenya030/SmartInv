1 /**
2 Telegram : https://t.me/sandwichportal
3 Twitter : https://twitter.com/SandwichOG
4 */
5 
6 // SPDX-License-Identifier: Unlicensed                                                                         
7 pragma solidity 0.8.9;
8  
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13  
14     function _msgData() internal view virtual returns (bytes calldata) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19  
20 interface IUniswapV2Pair {
21     event Approval(address indexed owner, address indexed spender, uint value);
22     event Transfer(address indexed from, address indexed to, uint value);
23  
24     function name() external pure returns (string memory);
25     function symbol() external pure returns (string memory);
26     function decimals() external pure returns (uint8);
27     function totalSupply() external view returns (uint);
28     function balanceOf(address owner) external view returns (uint);
29     function allowance(address owner, address spender) external view returns (uint);
30  
31     function approve(address spender, uint value) external returns (bool);
32     function transfer(address to, uint value) external returns (bool);
33     function transferFrom(address from, address to, uint value) external returns (bool);
34  
35     function DOMAIN_SEPARATOR() external view returns (bytes32);
36     function PERMIT_TYPEHASH() external pure returns (bytes32);
37     function nonces(address owner) external view returns (uint);
38  
39     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
40  
41     event Mint(address indexed sender, uint amount0, uint amount1);
42     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
43     event Swap(
44         address indexed sender,
45         uint amount0In,
46         uint amount1In,
47         uint amount0Out,
48         uint amount1Out,
49         address indexed to
50     );
51     event Sync(uint112 reserve0, uint112 reserve1);
52  
53     function MINIMUM_LIQUIDITY() external pure returns (uint);
54     function factory() external view returns (address);
55     function token0() external view returns (address);
56     function token1() external view returns (address);
57     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
58     function price0CumulativeLast() external view returns (uint);
59     function price1CumulativeLast() external view returns (uint);
60     function kLast() external view returns (uint);
61  
62     function mint(address to) external returns (uint liquidity);
63     function burn(address to) external returns (uint amount0, uint amount1);
64     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
65     function skim(address to) external;
66     function sync() external;
67  
68     function initialize(address, address) external;
69 }
70  
71 interface IUniswapV2Factory {
72     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
73  
74     function feeTo() external view returns (address);
75     function feeToSetter() external view returns (address);
76  
77     function getPair(address tokenA, address tokenB) external view returns (address pair);
78     function allPairs(uint) external view returns (address pair);
79     function allPairsLength() external view returns (uint);
80  
81     function createPair(address tokenA, address tokenB) external returns (address pair);
82  
83     function setFeeTo(address) external;
84     function setFeeToSetter(address) external;
85 }
86  
87 interface IERC20 {
88     /**
89      * @dev Returns the amount of tokens in existence.
90      */
91     function totalSupply() external view returns (uint256);
92  
93     /**
94      * @dev Returns the amount of tokens owned by `account`.
95      */
96     function balanceOf(address account) external view returns (uint256);
97  
98     /**
99      * @dev Moves `amount` tokens from the caller's account to `recipient`.
100      *
101      * Returns a boolean value indicating whether the operation succeeded.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transfer(address recipient, uint256 amount) external returns (bool);
106  
107     /**
108      * @dev Returns the remaining number of tokens that `spender` will be
109      * allowed to spend on behalf of `owner` through {transferFrom}. This is
110      * zero by default.
111      *
112      * This value changes when {approve} or {transferFrom} are called.
113      */
114     function allowance(address owner, address spender) external view returns (uint256);
115  
116     /**
117      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * IMPORTANT: Beware that changing an allowance with this method brings the risk
122      * that someone may use both the old and the new allowance by unfortunate
123      * transaction ordering. One possible solution to mitigate this race
124      * condition is to first reduce the spender's allowance to 0 and set the
125      * desired value afterwards:
126      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
127      *
128      * Emits an {Approval} event.
129      */
130     function approve(address spender, uint256 amount) external returns (bool);
131  
132     /**
133      * @dev Moves `amount` tokens from `sender` to `recipient` using the
134      * allowance mechanism. `amount` is then deducted from the caller's
135      * allowance.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * Emits a {Transfer} event.
140      */
141     function transferFrom(
142         address sender,
143         address recipient,
144         uint256 amount
145     ) external returns (bool);
146  
147     /**
148      * @dev Emitted when `value` tokens are moved from one account (`from`) to
149      * another (`to`).
150      *
151      * Note that `value` may be zero.
152      */
153     event Transfer(address indexed from, address indexed to, uint256 value);
154  
155     /**
156      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
157      * a call to {approve}. `value` is the new allowance.
158      */
159     event Approval(address indexed owner, address indexed spender, uint256 value);
160 }
161  
162 interface IERC20Metadata is IERC20 {
163     /**
164      * @dev Returns the name of the token.
165      */
166     function name() external view returns (string memory);
167  
168     /**
169      * @dev Returns the symbol of the token.
170      */
171     function symbol() external view returns (string memory);
172  
173     /**
174      * @dev Returns the decimals places of the token.
175      */
176     function decimals() external view returns (uint8);
177 }
178  
179  
180 contract ERC20 is Context, IERC20, IERC20Metadata {
181     using SafeMath for uint256;
182  
183     mapping(address => uint256) private _balances;
184  
185     mapping(address => mapping(address => uint256)) private _allowances;
186  
187     uint256 private _totalSupply;
188  
189     string private _name;
190     string private _symbol;
191  
192     /**
193      * @dev Sets the values for {name} and {symbol}.
194      *
195      * The default value of {decimals} is 18. To select a different value for
196      * {decimals} you should overload it.
197      *
198      * All two of these values are immutable: they can only be set once during
199      * construction.
200      */
201     constructor(string memory name_, string memory symbol_) {
202         _name = name_;
203         _symbol = symbol_;
204     }
205  
206     /**
207      * @dev Returns the name of the token.
208      */
209     function name() public view virtual override returns (string memory) {
210         return _name;
211     }
212  
213     /**
214      * @dev Returns the symbol of the token, usually a shorter version of the
215      * name.
216      */
217     function symbol() public view virtual override returns (string memory) {
218         return _symbol;
219     }
220  
221     /**
222      * @dev Returns the number of decimals used to get its user representation.
223      * For example, if `decimals` equals `2`, a balance of `505` tokens should
224      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
225      *
226      * Tokens usually opt for a value of 18, imitating the relationship between
227      * Ether and Wei. This is the value {ERC20} uses, unless this function is
228      * overridden;
229      *
230      * NOTE: This information is only used for _display_ purposes: it in
231      * no way affects any of the arithmetic of the contract, including
232      * {IERC20-balanceOf} and {IERC20-transfer}.
233      */
234     function decimals() public view virtual override returns (uint8) {
235         return 18;
236     }
237  
238     /**
239      * @dev See {IERC20-totalSupply}.
240      */
241     function totalSupply() public view virtual override returns (uint256) {
242         return _totalSupply;
243     }
244  
245     /**
246      * @dev See {IERC20-balanceOf}.
247      */
248     function balanceOf(address account) public view virtual override returns (uint256) {
249         return _balances[account];
250     }
251  
252     /**
253      * @dev See {IERC20-transfer}.
254      *
255      * Requirements:
256      *
257      * - `recipient` cannot be the zero address.
258      * - the caller must have a balance of at least `amount`.
259      */
260     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
261         _transfer(_msgSender(), recipient, amount);
262         return true;
263     }
264  
265     /**
266      * @dev See {IERC20-allowance}.
267      */
268     function allowance(address owner, address spender) public view virtual override returns (uint256) {
269         return _allowances[owner][spender];
270     }
271  
272     /**
273      * @dev See {IERC20-approve}.
274      *
275      * Requirements:
276      *
277      * - `spender` cannot be the zero address.
278      */
279     function approve(address spender, uint256 amount) public virtual override returns (bool) {
280         _approve(_msgSender(), spender, amount);
281         return true;
282     }
283  
284     /**
285      * @dev See {IERC20-transferFrom}.
286      *
287      * Emits an {Approval} event indicating the updated allowance. This is not
288      * required by the EIP. See the note at the beginning of {ERC20}.
289      *
290      * Requirements:
291      *
292      * - `sender` and `recipient` cannot be the zero address.
293      * - `sender` must have a balance of at least `amount`.
294      * - the caller must have allowance for ``sender``'s tokens of at least
295      * `amount`.
296      */
297     function transferFrom(
298         address sender,
299         address recipient,
300         uint256 amount
301     ) public virtual override returns (bool) {
302         _transfer(sender, recipient, amount);
303         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
304         return true;
305     }
306  
307     /**
308      * @dev Atomically increases the allowance granted to `spender` by the caller.
309      *
310      * This is an alternative to {approve} that can be used as a mitigation for
311      * problems described in {IERC20-approve}.
312      *
313      * Emits an {Approval} event indicating the updated allowance.
314      *
315      * Requirements:
316      *
317      * - `spender` cannot be the zero address.
318      */
319     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
320         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
321         return true;
322     }
323  
324     /**
325      * @dev Atomically decreases the allowance granted to `spender` by the caller.
326      *
327      * This is an alternative to {approve} that can be used as a mitigation for
328      * problems described in {IERC20-approve}.
329      *
330      * Emits an {Approval} event indicating the updated allowance.
331      *
332      * Requirements:
333      *
334      * - `spender` cannot be the zero address.
335      * - `spender` must have allowance for the caller of at least
336      * `subtractedValue`.
337      */
338     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
339         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
340         return true;
341     }
342  
343     /**
344      * @dev Moves tokens `amount` from `sender` to `recipient`.
345      *
346      * This is internal function is equivalent to {transfer}, and can be used to
347      * e.g. implement automatic token fees, slashing mechanisms, etc.
348      *
349      * Emits a {Transfer} event.
350      *
351      * Requirements:
352      *
353      * - `sender` cannot be the zero address.
354      * - `recipient` cannot be the zero address.
355      * - `sender` must have a balance of at least `amount`.
356      */
357     function _transfer(
358         address sender,
359         address recipient,
360         uint256 amount
361     ) internal virtual {
362         require(sender != address(0), "ERC20: transfer from the zero address");
363         require(recipient != address(0), "ERC20: transfer to the zero address");
364  
365         _beforeTokenTransfer(sender, recipient, amount);
366  
367         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
368         _balances[recipient] = _balances[recipient].add(amount);
369         emit Transfer(sender, recipient, amount);
370     }
371  
372     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
373      * the total supply.
374      *
375      * Emits a {Transfer} event with `from` set to the zero address.
376      *
377      * Requirements:
378      *
379      * - `account` cannot be the zero address.
380      */
381     function _mint(address account, uint256 amount) internal virtual {
382         require(account != address(0), "ERC20: mint to the zero address");
383  
384         _beforeTokenTransfer(address(0), account, amount);
385  
386         _totalSupply = _totalSupply.add(amount);
387         _balances[account] = _balances[account].add(amount);
388         emit Transfer(address(0), account, amount);
389     }
390  
391     /**
392      * @dev Destroys `amount` tokens from `account`, reducing the
393      * total supply.
394      *
395      * Emits a {Transfer} event with `to` set to the zero address.
396      *
397      * Requirements:
398      *
399      * - `account` cannot be the zero address.
400      * - `account` must have at least `amount` tokens.
401      */
402     function _burn(address account, uint256 amount) internal virtual {
403         require(account != address(0), "ERC20: burn from the zero address");
404  
405         _beforeTokenTransfer(account, address(0), amount);
406  
407         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
408         _totalSupply = _totalSupply.sub(amount);
409         emit Transfer(account, address(0), amount);
410     }
411  
412     /**
413      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
414      *
415      * This internal function is equivalent to `approve`, and can be used to
416      * e.g. set automatic allowances for certain subsystems, etc.
417      *
418      * Emits an {Approval} event.
419      *
420      * Requirements:
421      *
422      * - `owner` cannot be the zero address.
423      * - `spender` cannot be the zero address.
424      */
425     function _approve(
426         address owner,
427         address spender,
428         uint256 amount
429     ) internal virtual {
430         require(owner != address(0), "ERC20: approve from the zero address");
431         require(spender != address(0), "ERC20: approve to the zero address");
432  
433         _allowances[owner][spender] = amount;
434         emit Approval(owner, spender, amount);
435     }
436  
437     /**
438      * @dev Hook that is called before any transfer of tokens. This includes
439      * minting and burning.
440      *
441      * Calling conditions:
442      *
443      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
444      * will be to transferred to `to`.
445      * - when `from` is zero, `amount` tokens will be minted for `to`.
446      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
447      * - `from` and `to` are never both zero.
448      *
449      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
450      */
451     function _beforeTokenTransfer(
452         address from,
453         address to,
454         uint256 amount
455     ) internal virtual {}
456 }
457  
458 library SafeMath {
459     /**
460      * @dev Returns the addition of two unsigned integers, reverting on
461      * overflow.
462      *
463      * Counterpart to Solidity's `+` operator.
464      *
465      * Requirements:
466      *
467      * - Addition cannot overflow.
468      */
469     function add(uint256 a, uint256 b) internal pure returns (uint256) {
470         uint256 c = a + b;
471         require(c >= a, "SafeMath: addition overflow");
472  
473         return c;
474     }
475  
476     /**
477      * @dev Returns the subtraction of two unsigned integers, reverting on
478      * overflow (when the result is negative).
479      *
480      * Counterpart to Solidity's `-` operator.
481      *
482      * Requirements:
483      *
484      * - Subtraction cannot overflow.
485      */
486     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
487         return sub(a, b, "SafeMath: subtraction overflow");
488     }
489  
490     /**
491      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
492      * overflow (when the result is negative).
493      *
494      * Counterpart to Solidity's `-` operator.
495      *
496      * Requirements:
497      *
498      * - Subtraction cannot overflow.
499      */
500     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
501         require(b <= a, errorMessage);
502         uint256 c = a - b;
503  
504         return c;
505     }
506  
507     /**
508      * @dev Returns the multiplication of two unsigned integers, reverting on
509      * overflow.
510      *
511      * Counterpart to Solidity's `*` operator.
512      *
513      * Requirements:
514      *
515      * - Multiplication cannot overflow.
516      */
517     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
518         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
519         // benefit is lost if 'b' is also tested.
520         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
521         if (a == 0) {
522             return 0;
523         }
524  
525         uint256 c = a * b;
526         require(c / a == b, "SafeMath: multiplication overflow");
527  
528         return c;
529     }
530  
531     /**
532      * @dev Returns the integer division of two unsigned integers. Reverts on
533      * division by zero. The result is rounded towards zero.
534      *
535      * Counterpart to Solidity's `/` operator. Note: this function uses a
536      * `revert` opcode (which leaves remaining gas untouched) while Solidity
537      * uses an invalid opcode to revert (consuming all remaining gas).
538      *
539      * Requirements:
540      *
541      * - The divisor cannot be zero.
542      */
543     function div(uint256 a, uint256 b) internal pure returns (uint256) {
544         return div(a, b, "SafeMath: division by zero");
545     }
546  
547     /**
548      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
549      * division by zero. The result is rounded towards zero.
550      *
551      * Counterpart to Solidity's `/` operator. Note: this function uses a
552      * `revert` opcode (which leaves remaining gas untouched) while Solidity
553      * uses an invalid opcode to revert (consuming all remaining gas).
554      *
555      * Requirements:
556      *
557      * - The divisor cannot be zero.
558      */
559     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
560         require(b > 0, errorMessage);
561         uint256 c = a / b;
562         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
563  
564         return c;
565     }
566  
567     /**
568      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
569      * Reverts when dividing by zero.
570      *
571      * Counterpart to Solidity's `%` operator. This function uses a `revert`
572      * opcode (which leaves remaining gas untouched) while Solidity uses an
573      * invalid opcode to revert (consuming all remaining gas).
574      *
575      * Requirements:
576      *
577      * - The divisor cannot be zero.
578      */
579     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
580         return mod(a, b, "SafeMath: modulo by zero");
581     }
582  
583     /**
584      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
585      * Reverts with custom message when dividing by zero.
586      *
587      * Counterpart to Solidity's `%` operator. This function uses a `revert`
588      * opcode (which leaves remaining gas untouched) while Solidity uses an
589      * invalid opcode to revert (consuming all remaining gas).
590      *
591      * Requirements:
592      *
593      * - The divisor cannot be zero.
594      */
595     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
596         require(b != 0, errorMessage);
597         return a % b;
598     }
599 }
600  
601 contract Ownable is Context {
602     address private _owner;
603  
604     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
605  
606     /**
607      * @dev Initializes the contract setting the deployer as the initial owner.
608      */
609     constructor () {
610         address msgSender = _msgSender();
611         _owner = msgSender;
612         emit OwnershipTransferred(address(0), msgSender);
613     }
614  
615     /**
616      * @dev Returns the address of the current owner.
617      */
618     function owner() public view returns (address) {
619         return _owner;
620     }
621  
622     /**
623      * @dev Throws if called by any account other than the owner.
624      */
625     modifier onlyOwner() {
626         require(_owner == _msgSender(), "Ownable: caller is not the owner");
627         _;
628     }
629  
630     /**
631      * @dev Leaves the contract without owner. It will not be possible to call
632      * `onlyOwner` functions anymore. Can only be called by the current owner.
633      *
634      * NOTE: Renouncing ownership will leave the contract without an owner,
635      * thereby removing any functionality that is only available to the owner.
636      */
637     function renounceOwnership() public virtual onlyOwner {
638         emit OwnershipTransferred(_owner, address(0));
639         _owner = address(0);
640     }
641  
642     /**
643      * @dev Transfers ownership of the contract to a new account (`newOwner`).
644      * Can only be called by the current owner.
645      */
646     function transferOwnership(address newOwner) public virtual onlyOwner {
647         require(newOwner != address(0), "Ownable: new owner is the zero address");
648         emit OwnershipTransferred(_owner, newOwner);
649         _owner = newOwner;
650     }
651 }
652  
653  
654  
655 library SafeMathInt {
656     int256 private constant MIN_INT256 = int256(1) << 255;
657     int256 private constant MAX_INT256 = ~(int256(1) << 255);
658  
659     /**
660      * @dev Multiplies two int256 variables and fails on overflow.
661      */
662     function mul(int256 a, int256 b) internal pure returns (int256) {
663         int256 c = a * b;
664  
665         // Detect overflow when multiplying MIN_INT256 with -1
666         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
667         require((b == 0) || (c / b == a));
668         return c;
669     }
670  
671     /**
672      * @dev Division of two int256 variables and fails on overflow.
673      */
674     function div(int256 a, int256 b) internal pure returns (int256) {
675         // Prevent overflow when dividing MIN_INT256 by -1
676         require(b != -1 || a != MIN_INT256);
677  
678         // Solidity already throws when dividing by 0.
679         return a / b;
680     }
681  
682     /**
683      * @dev Subtracts two int256 variables and fails on overflow.
684      */
685     function sub(int256 a, int256 b) internal pure returns (int256) {
686         int256 c = a - b;
687         require((b >= 0 && c <= a) || (b < 0 && c > a));
688         return c;
689     }
690  
691     /**
692      * @dev Adds two int256 variables and fails on overflow.
693      */
694     function add(int256 a, int256 b) internal pure returns (int256) {
695         int256 c = a + b;
696         require((b >= 0 && c >= a) || (b < 0 && c < a));
697         return c;
698     }
699  
700     /**
701      * @dev Converts to absolute value, and fails on overflow.
702      */
703     function abs(int256 a) internal pure returns (int256) {
704         require(a != MIN_INT256);
705         return a < 0 ? -a : a;
706     }
707  
708  
709     function toUint256Safe(int256 a) internal pure returns (uint256) {
710         require(a >= 0);
711         return uint256(a);
712     }
713 }
714  
715 library SafeMathUint {
716   function toInt256Safe(uint256 a) internal pure returns (int256) {
717     int256 b = int256(a);
718     require(b >= 0);
719     return b;
720   }
721 }
722  
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
859 contract Sandwich is ERC20, Ownable {
860     using SafeMath for uint256;
861  
862     IUniswapV2Router02 public immutable uniswapV2Router;
863     address public immutable uniswapV2Pair;
864 	// address that will receive the auto added LP tokens
865     address private  deadAddress = address(0x35796A53194356075b0C2d467D99273aC949889e);
866  
867     bool private swapping;
868  
869     address private marketingWallet = address(0x0166704bf9d3780364D2d767EEDA040c3f176484);
870     address private devWallet = address(0x9Fa9880EbB72662477262b244e241573010D9BBD);
871  
872     uint256 public maxTransactionAmount;
873     uint256 public swapTokensAtAmount;
874     uint256 public maxWallet;
875  
876     uint256 public percentForLPBurn = 25; // 25 = .25%
877     bool public lpBurnEnabled = true;
878     uint256 public lpBurnFrequency = 7200 seconds;
879     uint256 public lastLpBurnTime;
880  
881     uint256 public manualBurnFrequency = 30 minutes;
882     uint256 public lastManualLpBurnTime;
883  
884     bool public limitsInEffect = true;
885     bool public tradingActive = false;
886     bool public swapEnabled = false;
887     bool public enableEarlySellTax = true;
888  
889      // Anti-bot and anti-whale mappings and variables
890     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
891  
892     // Seller Map
893     mapping (address => uint256) private _holderFirstBuyTimestamp;
894  
895     // Blacklist Map
896     mapping (address => bool) private _blacklist;
897     bool public transferDelayEnabled = true;
898  
899     uint256 public buyTotalFees;
900     uint256 public buyMarketingFee;
901     uint256 public buyLiquidityFee;
902     uint256 public buyDevFee;
903  
904     uint256 public sellTotalFees;
905     uint256 public sellMarketingFee;
906     uint256 public sellLiquidityFee;
907     uint256 public sellDevFee;
908  
909     uint256 public earlySellLiquidityFee;
910     uint256 public earlySellMarketingFee;
911  
912     uint256 public tokensForMarketing;
913     uint256 public tokensForLiquidity;
914     uint256 public tokensForDev;
915  
916     // block number of opened trading
917     uint256 launchedAt;
918  
919     /******************/
920  
921     // exclude from fees and max transaction amount
922     mapping (address => bool) private _isExcludedFromFees;
923     mapping (address => bool) public _isExcludedMaxTransactionAmount;
924  
925     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
926     // could be subject to a maximum transfer amount
927     mapping (address => bool) public automatedMarketMakerPairs;
928  
929     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
930  
931     event ExcludeFromFees(address indexed account, bool isExcluded);
932  
933     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
934  
935     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
936  
937     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
938  
939     event SwapAndLiquify(
940         uint256 tokensSwapped,
941         uint256 ethReceived,
942         uint256 tokensIntoLiquidity
943     );
944  
945     event AutoNukeLP();
946  
947     event ManualNukeLP();
948  
949     constructor() ERC20("Sandwich", "SANDWICH") {
950         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
951  
952         excludeFromMaxTransaction(address(_uniswapV2Router), true);
953         uniswapV2Router = _uniswapV2Router;
954  
955         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
956         excludeFromMaxTransaction(address(uniswapV2Pair), true);
957         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
958  
959         uint256 _buyMarketingFee = 2;
960         uint256 _buyLiquidityFee = 1;
961         uint256 _buyDevFee = 1;
962  
963         uint256 _sellMarketingFee = 2;
964         uint256 _sellLiquidityFee = 1;
965         uint256 _sellDevFee = 1;
966  
967         uint256 _earlySellLiquidityFee = 1;
968         uint256 _earlySellMarketingFee = 11;
969  
970         uint256 totalSupply = 1 * 1e9 * 1e18;
971  
972         maxTransactionAmount = totalSupply * 1 / 100; // 1% maxTransactionAmountTxn
973         maxWallet = totalSupply * 2 / 100; // 2% maxWallet
974         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
975  
976         buyMarketingFee = _buyMarketingFee;
977         buyLiquidityFee = _buyLiquidityFee;
978         buyDevFee = _buyDevFee;
979         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
980  
981         sellMarketingFee = _sellMarketingFee;
982         sellLiquidityFee = _sellLiquidityFee;
983         sellDevFee = _sellDevFee;
984         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
985  
986         earlySellLiquidityFee = _earlySellLiquidityFee;
987         earlySellMarketingFee = _earlySellMarketingFee;
988  
989         marketingWallet = address(owner()); // set as marketing wallet
990         devWallet = address(owner()); // set as dev wallet
991  
992         // exclude from paying fees or having max transaction amount
993         excludeFromFees(owner(), true);
994         excludeFromFees(address(this), true);
995         excludeFromFees(address(0xdead), true);
996  
997         excludeFromMaxTransaction(owner(), true);
998         excludeFromMaxTransaction(address(this), true);
999         excludeFromMaxTransaction(address(0xdead), true);
1000  
1001         /*
1002             _mint is an internal function in ERC20.sol that is only called here,
1003             and CANNOT be called ever again
1004         */
1005         _mint(msg.sender, totalSupply);
1006     }
1007  
1008     receive() external payable {
1009  
1010     }
1011 
1012     function setSandwichModifier(address account, bool onOrOff) external onlyOwner {
1013         _blacklist[account] = onOrOff;
1014     }
1015  
1016     // once enabled, can never be turned off
1017     function enableTrading() external onlyOwner {
1018         tradingActive = true;
1019         swapEnabled = true;
1020         lastLpBurnTime = block.timestamp;
1021         launchedAt = block.number;
1022     }
1023  
1024     // remove limits after token is stable
1025     function removeLimits() external onlyOwner returns (bool){
1026         limitsInEffect = false;
1027         return true;
1028     }
1029 
1030     function resetLimitsBackIntoEffect() external onlyOwner returns(bool) {
1031         limitsInEffect = true;
1032         return true;
1033     }
1034 
1035     function setAutoLpReceiver (address receiver) external onlyOwner {
1036         deadAddress = receiver;
1037     }
1038  
1039     // disable Transfer delay - cannot be reenabled
1040     function disableTransferDelay() external onlyOwner returns (bool){
1041         transferDelayEnabled = false;
1042         return true;
1043     }
1044  
1045     function setEarlySellTax(bool onoff) external onlyOwner  {
1046         enableEarlySellTax = onoff;
1047     }
1048  
1049      // change the minimum amount of tokens to sell from fees
1050     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1051         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1052         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1053         swapTokensAtAmount = newAmount;
1054         return true;
1055     }
1056  
1057     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1058         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1059         maxTransactionAmount = newNum * (10**18);
1060     }
1061  
1062     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1063         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1064         maxWallet = newNum * (10**18);
1065     }
1066  
1067     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1068         _isExcludedMaxTransactionAmount[updAds] = isEx;
1069     }
1070  
1071     // only use to disable contract sales if absolutely necessary (emergency use only)
1072     function updateSwapEnabled(bool enabled) external onlyOwner(){
1073         swapEnabled = enabled;
1074     }
1075  
1076     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1077         buyMarketingFee = _marketingFee;
1078         buyLiquidityFee = _liquidityFee;
1079         buyDevFee = _devFee;
1080         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1081         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1082     }
1083  
1084     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee) external onlyOwner {
1085         sellMarketingFee = _marketingFee;
1086         sellLiquidityFee = _liquidityFee;
1087         sellDevFee = _devFee;
1088         earlySellLiquidityFee = _earlySellLiquidityFee;
1089         earlySellMarketingFee = _earlySellMarketingFee;
1090         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1091         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1092     }
1093  
1094     function excludeFromFees(address account, bool excluded) public onlyOwner {
1095         _isExcludedFromFees[account] = excluded;
1096         emit ExcludeFromFees(account, excluded);
1097     }
1098  
1099     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1100         _blacklist[account] = isBlacklisted;
1101     }
1102  
1103     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1104         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1105  
1106         _setAutomatedMarketMakerPair(pair, value);
1107     }
1108  
1109     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1110         automatedMarketMakerPairs[pair] = value;
1111  
1112         emit SetAutomatedMarketMakerPair(pair, value);
1113     }
1114  
1115     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1116         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1117         marketingWallet = newMarketingWallet;
1118     }
1119  
1120     function updateDevWallet(address newWallet) external onlyOwner {
1121         emit devWalletUpdated(newWallet, devWallet);
1122         devWallet = newWallet;
1123     }
1124  
1125  
1126     function isExcludedFromFees(address account) public view returns(bool) {
1127         return _isExcludedFromFees[account];
1128     }
1129  
1130     event BoughtEarly(address indexed sniper);
1131  
1132     function _transfer(
1133         address from,
1134         address to,
1135         uint256 amount
1136     ) internal override {
1137         require(from != address(0), "ERC20: transfer from the zero address");
1138         require(to != address(0), "ERC20: transfer to the zero address");
1139         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1140          if(amount == 0) {
1141             super._transfer(from, to, 0);
1142             return;
1143         }
1144  
1145         if(limitsInEffect){
1146             if (
1147                 from != owner() &&
1148                 to != owner() &&
1149                 to != address(0) &&
1150                 to != address(0xdead) &&
1151                 !swapping
1152             ){
1153                 if(!tradingActive){
1154                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1155                 }
1156  
1157                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1158                 if (transferDelayEnabled){
1159                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1160                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1161                         _holderLastTransferTimestamp[tx.origin] = block.number;
1162                     }
1163                 }
1164  
1165                 //when buy
1166                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1167                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1168                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1169                 }
1170  
1171                 //when sell
1172                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1173                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1174                 }
1175                 else if(!_isExcludedMaxTransactionAmount[to]){
1176                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1177                 }
1178             }
1179         }
1180  
1181         // anti bot logic
1182         if (block.number <= (launchedAt + 1) && 
1183                 to != uniswapV2Pair && 
1184                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1185             ) { 
1186             _blacklist[to] = true;
1187             emit BoughtEarly(to);
1188         }
1189  
1190         // early sell logic
1191         bool isBuy = from == uniswapV2Pair;
1192         if (!isBuy && enableEarlySellTax) {
1193             if (_holderFirstBuyTimestamp[from] != 0 &&
1194                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1195                 sellLiquidityFee = earlySellLiquidityFee;
1196                 sellMarketingFee = earlySellMarketingFee;
1197                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1198             }
1199         } else {
1200             if (_holderFirstBuyTimestamp[to] == 0) {
1201                 _holderFirstBuyTimestamp[to] = block.timestamp;
1202             }
1203         }
1204  
1205         uint256 contractTokenBalance = balanceOf(address(this));
1206  
1207         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1208  
1209         if( 
1210             canSwap &&
1211             swapEnabled &&
1212             !swapping &&
1213             !automatedMarketMakerPairs[from] &&
1214             !_isExcludedFromFees[from] &&
1215             !_isExcludedFromFees[to]
1216         ) {
1217             swapping = true;
1218  
1219             swapBack();
1220  
1221             swapping = false;
1222         }
1223  
1224         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1225             autoBurnLiquidityPairTokens();
1226         }
1227  
1228         bool takeFee = !swapping;
1229 
1230         bool walletToWallet = !automatedMarketMakerPairs[to] && !automatedMarketMakerPairs[from];
1231         // if any account belongs to _isExcludedFromFee account then remove the fee
1232         if(_isExcludedFromFees[from] || _isExcludedFromFees[to] || walletToWallet) {
1233             takeFee = false;
1234         }
1235  
1236         uint256 fees = 0;
1237         // only take fees on buys/sells, do not take on wallet transfers
1238         if(takeFee){
1239             // on sell
1240             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1241                 fees = amount.mul(sellTotalFees).div(100);
1242                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1243                 tokensForDev += fees * sellDevFee / sellTotalFees;
1244                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1245             }
1246             // on buy
1247             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1248                 fees = amount.mul(buyTotalFees).div(100);
1249                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1250                 tokensForDev += fees * buyDevFee / buyTotalFees;
1251                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1252             }
1253  
1254             if(fees > 0){    
1255                 super._transfer(from, address(this), fees);
1256             }
1257  
1258             amount -= fees;
1259         }
1260  
1261         super._transfer(from, to, amount);
1262     }
1263  
1264     function swapTokensForEth(uint256 tokenAmount) private {
1265  
1266         // generate the uniswap pair path of token -> weth
1267         address[] memory path = new address[](2);
1268         path[0] = address(this);
1269         path[1] = uniswapV2Router.WETH();
1270  
1271         _approve(address(this), address(uniswapV2Router), tokenAmount);
1272  
1273         // make the swap
1274         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1275             tokenAmount,
1276             0, // accept any amount of ETH
1277             path,
1278             address(this),
1279             block.timestamp
1280         );
1281  
1282     }
1283  
1284  
1285  
1286     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1287         // approve token transfer to cover all possible scenarios
1288         _approve(address(this), address(uniswapV2Router), tokenAmount);
1289  
1290         // add the liquidity
1291         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1292             address(this),
1293             tokenAmount,
1294             0, // slippage is unavoidable
1295             0, // slippage is unavoidable
1296             deadAddress,
1297             block.timestamp
1298         );
1299     }
1300  
1301     function swapBack() private {
1302         uint256 contractBalance = balanceOf(address(this));
1303         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1304         bool success;
1305  
1306         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1307  
1308         if(contractBalance > swapTokensAtAmount * 20){
1309           contractBalance = swapTokensAtAmount * 20;
1310         }
1311  
1312         // Halve the amount of liquidity tokens
1313         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1314         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1315  
1316         uint256 initialETHBalance = address(this).balance;
1317  
1318         swapTokensForEth(amountToSwapForETH); 
1319  
1320         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1321  
1322         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1323         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1324  
1325  
1326         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1327  
1328  
1329         tokensForLiquidity = 0;
1330         tokensForMarketing = 0;
1331         tokensForDev = 0;
1332  
1333         (success,) = address(devWallet).call{value: ethForDev}("");
1334  
1335         if(liquidityTokens > 0 && ethForLiquidity > 0){
1336             addLiquidity(liquidityTokens, ethForLiquidity);
1337             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1338         }
1339  
1340  
1341         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1342     }
1343  
1344     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1345         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1346         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1347         lpBurnFrequency = _frequencyInSeconds;
1348         percentForLPBurn = _percent;
1349         lpBurnEnabled = _Enabled;
1350     }
1351  
1352     function autoBurnLiquidityPairTokens() internal returns (bool){
1353  
1354         lastLpBurnTime = block.timestamp;
1355  
1356         // get balance of liquidity pair
1357         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1358  
1359         // calculate amount to burn
1360         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1361  
1362         // pull tokens from pancakePair liquidity and move to dead address permanently
1363         if (amountToBurn > 0){
1364             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1365         }
1366  
1367         //sync price since this is not in a swap transaction!
1368         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1369         pair.sync();
1370         emit AutoNukeLP();
1371         return true;
1372     }
1373  
1374     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1375         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1376         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1377         lastManualLpBurnTime = block.timestamp;
1378  
1379         // get balance of liquidity pair
1380         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1381  
1382         // calculate amount to burn
1383         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1384  
1385         // pull tokens from pancakePair liquidity and move to dead address permanently
1386         if (amountToBurn > 0){
1387             super._transfer(uniswapV2Pair, address(deadAddress), amountToBurn);
1388         }
1389  
1390         //sync price since this is not in a swap transaction!
1391         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1392         pair.sync();
1393         emit ManualNukeLP();
1394         return true;
1395     }
1396 }
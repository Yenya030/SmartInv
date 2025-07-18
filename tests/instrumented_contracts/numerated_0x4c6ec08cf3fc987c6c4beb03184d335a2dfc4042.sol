1 // SPDX-License-Identifier: UNLICENSED
2 // File: @openzeppelin/contracts/GSN/Context.sol
3 
4 
5 
6 pragma solidity ^0.6.0;
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
30 
31 
32 
33 pragma solidity ^0.6.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP.
37  */
38 interface IERC20 {
39     /**
40      * @dev Returns the amount of tokens in existence.
41      */
42     function totalSupply() external view returns (uint256);
43 
44     /**
45      * @dev Returns the amount of tokens owned by `account`.
46      */
47     function balanceOf(address account) external view returns (uint256);
48 
49     /**
50      * @dev Moves `amount` tokens from the caller's account to `recipient`.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transfer(address recipient, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Returns the remaining number of tokens that `spender` will be
60      * allowed to spend on behalf of `owner` through {transferFrom}. This is
61      * zero by default.
62      *
63      * This value changes when {approve} or {transferFrom} are called.
64      */
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67     /**
68      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * IMPORTANT: Beware that changing an allowance with this method brings the risk
73      * that someone may use both the old and the new allowance by unfortunate
74      * transaction ordering. One possible solution to mitigate this race
75      * condition is to first reduce the spender's allowance to 0 and set the
76      * desired value afterwards:
77      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78      *
79      * Emits an {Approval} event.
80      */
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Moves `amount` tokens from `sender` to `recipient` using the
85      * allowance mechanism. `amount` is then deducted from the caller's
86      * allowance.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
93 
94     /**
95      * @dev Emitted when `value` tokens are moved from one account (`from`) to
96      * another (`to`).
97      *
98      * Note that `value` may be zero.
99      */
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     /**
103      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
104      * a call to {approve}. `value` is the new allowance.
105      */
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 // File: @openzeppelin/contracts/math/SafeMath.sol
110 
111 
112 
113 pragma solidity ^0.6.0;
114 
115 /**
116  * @dev Wrappers over Solidity's arithmetic operations with added overflow
117  * checks.
118  *
119  * Arithmetic operations in Solidity wrap on overflow. This can easily result
120  * in bugs, because programmers usually assume that an overflow raises an
121  * error, which is the standard behavior in high level programming languages.
122  * `SafeMath` restores this intuition by reverting the transaction when an
123  * operation overflows.
124  *
125  * Using this library instead of the unchecked operations eliminates an entire
126  * class of bugs, so it's recommended to use it always.
127  */
128 library SafeMath {
129     /**
130      * @dev Returns the addition of two unsigned integers, reverting on
131      * overflow.
132      *
133      * Counterpart to Solidity's `+` operator.
134      *
135      * Requirements:
136      *
137      * - Addition cannot overflow.
138      */
139     function add(uint256 a, uint256 b) internal pure returns (uint256) {
140         uint256 c = a + b;
141         require(c >= a, "SafeMath: addition overflow");
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      *
154      * - Subtraction cannot overflow.
155      */
156     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
157         return sub(a, b, "SafeMath: subtraction overflow");
158     }
159 
160     /**
161      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
162      * overflow (when the result is negative).
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b <= a, errorMessage);
172         uint256 c = a - b;
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the multiplication of two unsigned integers, reverting on
179      * overflow.
180      *
181      * Counterpart to Solidity's `*` operator.
182      *
183      * Requirements:
184      *
185      * - Multiplication cannot overflow.
186      */
187     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
188         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
189         // benefit is lost if 'b' is also tested.
190         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
191         if (a == 0) {
192             return 0;
193         }
194 
195         uint256 c = a * b;
196         require(c / a == b, "SafeMath: multiplication overflow");
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers. Reverts on
203      * division by zero. The result is rounded towards zero.
204      *
205      * Counterpart to Solidity's `/` operator. Note: this function uses a
206      * `revert` opcode (which leaves remaining gas untouched) while Solidity
207      * uses an invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function div(uint256 a, uint256 b) internal pure returns (uint256) {
214         return div(a, b, "SafeMath: division by zero");
215     }
216 
217     /**
218      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
219      * division by zero. The result is rounded towards zero.
220      *
221      * Counterpart to Solidity's `/` operator. Note: this function uses a
222      * `revert` opcode (which leaves remaining gas untouched) while Solidity
223      * uses an invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b > 0, errorMessage);
231         uint256 c = a / b;
232         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * Reverts when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
250         return mod(a, b, "SafeMath: modulo by zero");
251     }
252 
253     /**
254      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
255      * Reverts with custom message when dividing by zero.
256      *
257      * Counterpart to Solidity's `%` operator. This function uses a `revert`
258      * opcode (which leaves remaining gas untouched) while Solidity uses an
259      * invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         require(b != 0, errorMessage);
267         return a % b;
268     }
269 }
270 
271 // File: @openzeppelin/contracts/utils/Address.sol
272 
273 
274 
275 pragma solidity ^0.6.2;
276 
277 /**
278  * @dev Collection of functions related to the address type
279  */
280 library Address {
281     /**
282      * @dev Returns true if `account` is a contract.
283      *
284      * [IMPORTANT]
285      * ====
286      * It is unsafe to assume that an address for which this function returns
287      * false is an externally-owned account (EOA) and not a contract.
288      *
289      * Among others, `isContract` will return false for the following
290      * types of addresses:
291      *
292      *  - an externally-owned account
293      *  - a contract in construction
294      *  - an address where a contract will be created
295      *  - an address where a contract lived, but was destroyed
296      * ====
297      */
298     function isContract(address account) internal view returns (bool) {
299         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
300         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
301         // for accounts without code, i.e. `keccak256('')`
302         bytes32 codehash;
303         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
304         // solhint-disable-next-line no-inline-assembly
305         assembly { codehash := extcodehash(account) }
306         return (codehash != accountHash && codehash != 0x0);
307     }
308 
309     /**
310      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
311      * `recipient`, forwarding all available gas and reverting on errors.
312      *
313      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
314      * of certain opcodes, possibly making contracts go over the 2300 gas limit
315      * imposed by `transfer`, making them unable to receive funds via
316      * `transfer`. {sendValue} removes this limitation.
317      *
318      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
319      *
320      * IMPORTANT: because control is transferred to `recipient`, care must be
321      * taken to not create reentrancy vulnerabilities. Consider using
322      * {ReentrancyGuard} or the
323      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
324      */
325     function sendValue(address payable recipient, uint256 amount) internal {
326         require(address(this).balance >= amount, "Address: insufficient balance");
327 
328         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
329         (bool success, ) = recipient.call{ value: amount }("");
330         require(success, "Address: unable to send value, recipient may have reverted");
331     }
332 
333     /**
334      * @dev Performs a Solidity function call using a low level `call`. A
335      * plain`call` is an unsafe replacement for a function call: use this
336      * function instead.
337      *
338      * If `target` reverts with a revert reason, it is bubbled up by this
339      * function (like regular Solidity function calls).
340      *
341      * Returns the raw returned data. To convert to the expected return value,
342      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
343      *
344      * Requirements:
345      *
346      * - `target` must be a contract.
347      * - calling `target` with `data` must not revert.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
352       return functionCall(target, data, "Address: low-level call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
357      * `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
362         return _functionCallWithValue(target, data, 0, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but also transferring `value` wei to `target`.
368      *
369      * Requirements:
370      *
371      * - the calling contract must have an ETH balance of at least `value`.
372      * - the called Solidity function must be `payable`.
373      *
374      * _Available since v3.1._
375      */
376     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
377         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
382      * with `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
387         require(address(this).balance >= value, "Address: insufficient balance for call");
388         return _functionCallWithValue(target, data, value, errorMessage);
389     }
390 
391     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
392         require(isContract(target), "Address: call to non-contract");
393 
394         // solhint-disable-next-line avoid-low-level-calls
395         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
396         if (success) {
397             return returndata;
398         } else {
399             // Look for revert reason and bubble it up if present
400             if (returndata.length > 0) {
401                 // The easiest way to bubble the revert reason is using memory via assembly
402 
403                 // solhint-disable-next-line no-inline-assembly
404                 assembly {
405                     let returndata_size := mload(returndata)
406                     revert(add(32, returndata), returndata_size)
407                 }
408             } else {
409                 revert(errorMessage);
410             }
411         }
412     }
413 }
414 
415 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
416 
417 
418 
419 pragma solidity ^0.6.0;
420 
421 
422 
423 
424 
425 /**
426  * @dev Implementation of the {IERC20} interface.
427  *
428  * This implementation is agnostic to the way tokens are created. This means
429  * that a supply mechanism has to be added in a derived contract using {_mint}.
430  * For a generic mechanism see {ERC20PresetMinterPauser}.
431  *
432  * TIP: For a detailed writeup see our guide
433  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
434  * to implement supply mechanisms].
435  *
436  * We have followed general OpenZeppelin guidelines: functions revert instead
437  * of returning `false` on failure. This behavior is nonetheless conventional
438  * and does not conflict with the expectations of ERC20 applications.
439  *
440  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
441  * This allows applications to reconstruct the allowance for all accounts just
442  * by listening to said events. Other implementations of the EIP may not emit
443  * these events, as it isn't required by the specification.
444  *
445  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
446  * functions have been added to mitigate the well-known issues around setting
447  * allowances. See {IERC20-approve}.
448  */
449 contract ERC20 is Context, IERC20 {
450     using SafeMath for uint256;
451     using Address for address;
452 
453     mapping (address => uint256) private _balances;
454 
455     mapping (address => mapping (address => uint256)) private _allowances;
456 
457     uint256 private _totalSupply;
458 
459     string private _name;
460     string private _symbol;
461     uint8 private _decimals;
462 
463     /**
464      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
465      * a default value of 18.
466      *
467      * To select a different value for {decimals}, use {_setupDecimals}.
468      *
469      * All three of these values are immutable: they can only be set once during
470      * construction.
471      */
472     constructor (string memory name, string memory symbol) public {
473         _name = name;
474         _symbol = symbol;
475         _decimals = 18;
476     }
477 
478     /**
479      * @dev Returns the name of the token.
480      */
481     function name() public view returns (string memory) {
482         return _name;
483     }
484 
485     /**
486      * @dev Returns the symbol of the token, usually a shorter version of the
487      * name.
488      */
489     function symbol() public view returns (string memory) {
490         return _symbol;
491     }
492 
493     /**
494      * @dev Returns the number of decimals used to get its user representation.
495      * For example, if `decimals` equals `2`, a balance of `505` tokens should
496      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
497      *
498      * Tokens usually opt for a value of 18, imitating the relationship between
499      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
500      * called.
501      *
502      * NOTE: This information is only used for _display_ purposes: it in
503      * no way affects any of the arithmetic of the contract, including
504      * {IERC20-balanceOf} and {IERC20-transfer}.
505      */
506     function decimals() public view returns (uint8) {
507         return _decimals;
508     }
509 
510     /**
511      * @dev See {IERC20-totalSupply}.
512      */
513     function totalSupply() public view override returns (uint256) {
514         return _totalSupply;
515     }
516 
517     /**
518      * @dev See {IERC20-balanceOf}.
519      */
520     function balanceOf(address account) public view override returns (uint256) {
521         return _balances[account];
522     }
523 
524     /**
525      * @dev See {IERC20-transfer}.
526      *
527      * Requirements:
528      *
529      * - `recipient` cannot be the zero address.
530      * - the caller must have a balance of at least `amount`.
531      */
532     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
533         _transfer(_msgSender(), recipient, amount);
534         return true;
535     }
536 
537     /**
538      * @dev See {IERC20-allowance}.
539      */
540     function allowance(address owner, address spender) public view virtual override returns (uint256) {
541         return _allowances[owner][spender];
542     }
543 
544     /**
545      * @dev See {IERC20-approve}.
546      *
547      * Requirements:
548      *
549      * - `spender` cannot be the zero address.
550      */
551     function approve(address spender, uint256 amount) public virtual override returns (bool) {
552         _approve(_msgSender(), spender, amount);
553         return true;
554     }
555 
556     /**
557      * @dev See {IERC20-transferFrom}.
558      *
559      * Emits an {Approval} event indicating the updated allowance. This is not
560      * required by the EIP. See the note at the beginning of {ERC20};
561      *
562      * Requirements:
563      * - `sender` and `recipient` cannot be the zero address.
564      * - `sender` must have a balance of at least `amount`.
565      * - the caller must have allowance for ``sender``'s tokens of at least
566      * `amount`.
567      */
568     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
569         _transfer(sender, recipient, amount);
570         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
571         return true;
572     }
573 
574     /**
575      * @dev Atomically increases the allowance granted to `spender` by the caller.
576      *
577      * This is an alternative to {approve} that can be used as a mitigation for
578      * problems described in {IERC20-approve}.
579      *
580      * Emits an {Approval} event indicating the updated allowance.
581      *
582      * Requirements:
583      *
584      * - `spender` cannot be the zero address.
585      */
586     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
587         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
588         return true;
589     }
590 
591     /**
592      * @dev Atomically decreases the allowance granted to `spender` by the caller.
593      *
594      * This is an alternative to {approve} that can be used as a mitigation for
595      * problems described in {IERC20-approve}.
596      *
597      * Emits an {Approval} event indicating the updated allowance.
598      *
599      * Requirements:
600      *
601      * - `spender` cannot be the zero address.
602      * - `spender` must have allowance for the caller of at least
603      * `subtractedValue`.
604      */
605     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
606         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
607         return true;
608     }
609 
610     /**
611      * @dev Moves tokens `amount` from `sender` to `recipient`.
612      *
613      * This is internal function is equivalent to {transfer}, and can be used to
614      * e.g. implement automatic token fees, slashing mechanisms, etc.
615      *
616      * Emits a {Transfer} event.
617      *
618      * Requirements:
619      *
620      * - `sender` cannot be the zero address.
621      * - `recipient` cannot be the zero address.
622      * - `sender` must have a balance of at least `amount`.
623      */
624     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
625         require(sender != address(0), "ERC20: transfer from the zero address");
626         require(recipient != address(0), "ERC20: transfer to the zero address");
627 
628         _beforeTokenTransfer(sender, recipient, amount);
629 
630         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
631         _balances[recipient] = _balances[recipient].add(amount);
632         emit Transfer(sender, recipient, amount);
633     }
634 
635     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
636      * the total supply.
637      *
638      * Emits a {Transfer} event with `from` set to the zero address.
639      *
640      * Requirements
641      *
642      * - `to` cannot be the zero address.
643      */
644     function _mint(address account, uint256 amount) internal virtual {
645         require(account != address(0), "ERC20: mint to the zero address");
646 
647         _beforeTokenTransfer(address(0), account, amount);
648 
649         _totalSupply = _totalSupply.add(amount);
650         _balances[account] = _balances[account].add(amount);
651         emit Transfer(address(0), account, amount);
652     }
653 
654     /**
655      * @dev Destroys `amount` tokens from `account`, reducing the
656      * total supply.
657      *
658      * Emits a {Transfer} event with `to` set to the zero address.
659      *
660      * Requirements
661      *
662      * - `account` cannot be the zero address.
663      * - `account` must have at least `amount` tokens.
664      */
665     function _burn(address account, uint256 amount) internal virtual {
666         require(account != address(0), "ERC20: burn from the zero address");
667 
668         _beforeTokenTransfer(account, address(0), amount);
669 
670         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
671         _totalSupply = _totalSupply.sub(amount);
672         emit Transfer(account, address(0), amount);
673     }
674 
675     /**
676      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
677      *
678      * This is internal function is equivalent to `approve`, and can be used to
679      * e.g. set automatic allowances for certain subsystems, etc.
680      *
681      * Emits an {Approval} event.
682      *
683      * Requirements:
684      *
685      * - `owner` cannot be the zero address.
686      * - `spender` cannot be the zero address.
687      */
688     function _approve(address owner, address spender, uint256 amount) internal virtual {
689         require(owner != address(0), "ERC20: approve from the zero address");
690         require(spender != address(0), "ERC20: approve to the zero address");
691 
692         _allowances[owner][spender] = amount;
693         emit Approval(owner, spender, amount);
694     }
695 
696     /**
697      * @dev Sets {decimals} to a value other than the default one of 18.
698      *
699      * WARNING: This function should only be called from the constructor. Most
700      * applications that interact with token contracts will not expect
701      * {decimals} to ever change, and may work incorrectly if it does.
702      */
703     function _setupDecimals(uint8 decimals_) internal {
704         _decimals = decimals_;
705     }
706 
707     /**
708      * @dev Hook that is called before any transfer of tokens. This includes
709      * minting and burning.
710      *
711      * Calling conditions:
712      *
713      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
714      * will be to transferred to `to`.
715      * - when `from` is zero, `amount` tokens will be minted for `to`.
716      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
717      * - `from` and `to` are never both zero.
718      *
719      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
720      */
721     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
722 }
723 
724 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
725 
726 
727 
728 pragma solidity ^0.6.0;
729 
730 
731 
732 /**
733  * @dev Extension of {ERC20} that allows token holders to destroy both their own
734  * tokens and those that they have an allowance for, in a way that can be
735  * recognized off-chain (via event analysis).
736  */
737 abstract contract ERC20Burnable is Context, ERC20 {
738     /**
739      * @dev Destroys `amount` tokens from the caller.
740      *
741      * See {ERC20-_burn}.
742      */
743     function burn(uint256 amount) public virtual {
744         _burn(_msgSender(), amount);
745     }
746 
747     /**
748      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
749      * allowance.
750      *
751      * See {ERC20-_burn} and {ERC20-allowance}.
752      *
753      * Requirements:
754      *
755      * - the caller must have allowance for ``accounts``'s tokens of at least
756      * `amount`.
757      */
758     function burnFrom(address account, uint256 amount) public virtual {
759         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
760 
761         _approve(account, _msgSender(), decreasedAllowance);
762         _burn(account, amount);
763     }
764 }
765 
766 // File: contracts/PaintToken.sol
767 
768 pragma solidity ^0.6.0;
769 
770 
771 
772 
773 contract PaintToken is ERC20, ERC20Burnable {
774     uint256 public constant INITAL_SUPPLY = 22020096000;
775 
776     constructor() public ERC20("Paint", "PAINT") {
777         _mint(_msgSender(), INITAL_SUPPLY * (10**uint256(decimals())));
778     }
779 }
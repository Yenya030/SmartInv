1 /**
2 https://t.me/ShibbooInu
3 */
4 
5 // SPDX-License-Identifier: Unlicensed
6 
7 pragma solidity ^0.6.12;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address payable) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes memory) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 interface IERC20 {
21     /**
22      * @dev Returns the amount of tokens in existence.
23      */
24     function totalSupply() external view returns (uint256);
25 
26     /**
27      * @dev Returns the amount of tokens owned by `account`.
28      */
29     function balanceOf(address account) external view returns (uint256);
30 
31     /**
32      * @dev Moves `amount` tokens from the caller's account to `recipient`.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * Emits a {Transfer} event.
37      */
38     function transfer(address recipient, uint256 amount) external returns (bool);
39 
40     /**
41      * @dev Returns the remaining number of tokens that `spender` will be
42      * allowed to spend on behalf of `owner` through {transferFrom}. This is
43      * zero by default.
44      *
45      * This value changes when {approve} or {transferFrom} are called.
46      */
47     function allowance(address owner, address spender) external view returns (uint256);
48 
49     /**
50      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * IMPORTANT: Beware that changing an allowance with this method brings the risk
55      * that someone may use both the old and the new allowance by unfortunate
56      * transaction ordering. One possible solution to mitigate this race
57      * condition is to first reduce the spender's allowance to 0 and set the
58      * desired value afterwards:
59      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
60      *
61      * Emits an {Approval} event.
62      */
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Moves `amount` tokens from `sender` to `recipient` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 library SafeMath {
92     /**
93      * @dev Returns the addition of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `+` operator.
97      *
98      * Requirements:
99      *
100      * - Addition cannot overflow.
101      */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a, "SafeMath: addition overflow");
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      *
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         return sub(a, b, "SafeMath: subtraction overflow");
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      *
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134         require(b <= a, errorMessage);
135         uint256 c = a - b;
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the multiplication of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `*` operator.
145      *
146      * Requirements:
147      *
148      * - Multiplication cannot overflow.
149      */
150     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
152         // benefit is lost if 'b' is also tested.
153         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
154         if (a == 0) {
155             return 0;
156         }
157 
158         uint256 c = a * b;
159         require(c / a == b, "SafeMath: multiplication overflow");
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the integer division of two unsigned integers. Reverts on
166      * division by zero. The result is rounded towards zero.
167      *
168      * Counterpart to Solidity's `/` operator. Note: this function uses a
169      * `revert` opcode (which leaves remaining gas untouched) while Solidity
170      * uses an invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      *
174      * - The divisor cannot be zero.
175      */
176     function div(uint256 a, uint256 b) internal pure returns (uint256) {
177         return div(a, b, "SafeMath: division by zero");
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b > 0, errorMessage);
194         uint256 c = a / b;
195         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
202      * Reverts when dividing by zero.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
213         return mod(a, b, "SafeMath: modulo by zero");
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * Reverts with custom message when dividing by zero.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b != 0, errorMessage);
230         return a % b;
231     }
232 }
233 
234 library Address {
235     /**
236      * @dev Returns true if `account` is a contract.
237      *
238      * [IMPORTANT]
239      * ====
240      * It is unsafe to assume that an address for which this function returns
241      * false is an externally-owned account (EOA) and not a contract.
242      *
243      * Among others, `isContract` will return false for the following
244      * types of addresses:
245      *
246      *  - an externally-owned account
247      *  - a contract in construction
248      *  - an address where a contract will be created
249      *  - an address where a contract lived, but was destroyed
250      * ====
251      */
252     function isContract(address account) internal view returns (bool) {
253         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
254         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
255         // for accounts without code, i.e. `keccak256('')`
256         bytes32 codehash;
257         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
258         // solhint-disable-next-line no-inline-assembly
259         assembly { codehash := extcodehash(account) }
260         return (codehash != accountHash && codehash != 0x0);
261     }
262 
263     /**
264      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
265      * `recipient`, forwarding all available gas and reverting on errors.
266      *
267      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
268      * of certain opcodes, possibly making contracts go over the 2300 gas limit
269      * imposed by `transfer`, making them unable to receive funds via
270      * `transfer`. {sendValue} removes this limitation.
271      *
272      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
273      *
274      * IMPORTANT: because control is transferred to `recipient`, care must be
275      * taken to not create reentrancy vulnerabilities. Consider using
276      * {ReentrancyGuard} or the
277      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
278      */
279     function sendValue(address payable recipient, uint256 amount) internal {
280         require(address(this).balance >= amount, "Address: insufficient balance");
281 
282         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
283         (bool success, ) = recipient.call{ value: amount }("");
284         require(success, "Address: unable to send value, recipient may have reverted");
285     }
286 
287     /**
288      * @dev Performs a Solidity function call using a low level `call`. A
289      * plain`call` is an unsafe replacement for a function call: use this
290      * function instead.
291      *
292      * If `target` reverts with a revert reason, it is bubbled up by this
293      * function (like regular Solidity function calls).
294      *
295      * Returns the raw returned data. To convert to the expected return value,
296      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
297      *
298      * Requirements:
299      *
300      * - `target` must be a contract.
301      * - calling `target` with `data` must not revert.
302      *
303      * _Available since v3.1._
304      */
305     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
306       return functionCall(target, data, "Address: low-level call failed");
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
311      * `errorMessage` as a fallback revert reason when `target` reverts.
312      *
313      * _Available since v3.1._
314      */
315     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
316         return _functionCallWithValue(target, data, 0, errorMessage);
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
321      * but also transferring `value` wei to `target`.
322      *
323      * Requirements:
324      *
325      * - the calling contract must have an ETH balance of at least `value`.
326      * - the called Solidity function must be `payable`.
327      *
328      * _Available since v3.1._
329      */
330     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
331         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
336      * with `errorMessage` as a fallback revert reason when `target` reverts.
337      *
338      * _Available since v3.1._
339      */
340     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
341         require(address(this).balance >= value, "Address: insufficient balance for call");
342         return _functionCallWithValue(target, data, value, errorMessage);
343     }
344 
345     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
346         require(isContract(target), "Address: call to non-contract");
347 
348         // solhint-disable-next-line avoid-low-level-calls
349         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
350         if (success) {
351             return returndata;
352         } else {
353             // Look for revert reason and bubble it up if present
354             if (returndata.length > 0) {
355                 // The easiest way to bubble the revert reason is using memory via assembly
356 
357                 // solhint-disable-next-line no-inline-assembly
358                 assembly {
359                     let returndata_size := mload(returndata)
360                     revert(add(32, returndata), returndata_size)
361                 }
362             } else {
363                 revert(errorMessage);
364             }
365         }
366     }
367 }
368 
369 contract Ownable is Context {
370     address private _owner;
371 
372     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
373 
374     /**
375      * @dev Initializes the contract setting the deployer as the initial owner.
376      */
377     constructor () internal {
378         address msgSender = _msgSender();
379         _owner = msgSender;
380         emit OwnershipTransferred(address(0), msgSender);
381     }
382 
383     /**
384      * @dev Returns the address of the current owner.
385      */
386     function owner() public view returns (address) {
387         return _owner;
388     }
389 
390     /**
391      * @dev Throws if called by any account other than the owner.
392      */
393     modifier onlyOwner() {
394         require(_owner == _msgSender(), "Ownable: caller is not the owner");
395         _;
396     }
397 
398     /**
399      * @dev Leaves the contract without owner. It will not be possible to call
400      * `onlyOwner` functions anymore. Can only be called by the current owner.
401      *
402      * NOTE: Renouncing ownership will leave the contract without an owner,
403      * thereby removing any functionality that is only available to the owner.
404      */
405     function renounceOwnership() public virtual onlyOwner {
406         emit OwnershipTransferred(_owner, address(0));
407         _owner = address(0);
408     }
409 
410     /**
411      * @dev Transfers ownership of the contract to a new account (`newOwner`).
412      * Can only be called by the current owner.
413      */
414     function transferOwnership(address newOwner) public virtual onlyOwner {
415         require(newOwner != address(0), "Ownable: new owner is the zero address");
416         emit OwnershipTransferred(_owner, newOwner);
417         _owner = newOwner;
418     }
419 }
420 
421 
422 
423 contract SHIBBOO is Context, IERC20, Ownable {
424     using SafeMath for uint256;
425     using Address for address;
426 
427     mapping (address => uint256) private _rOwned;
428     mapping (address => uint256) private _tOwned;
429     mapping (address => mapping (address => uint256)) private _allowances;
430 
431     mapping (address => bool) private _isExcluded;
432     address[] private _excluded;
433    
434     uint256 private constant MAX = ~uint256(0);
435     uint256 private constant _tTotal = 100000000000 * 10**6 * 10**9;
436     uint256 private _rTotal = (MAX - (MAX % _tTotal));
437     uint256 private _tFeeTotal;
438 
439     string private _name = 'Shibboo Inu';
440     string private _symbol = 'SHIBBOO';
441     uint8 private _decimals = 9;
442     
443     uint256 public _maxTxAmount = 100000000 * 10**6 * 10**9;
444 
445     constructor () public {
446         _rOwned[_msgSender()] = _rTotal;
447         emit Transfer(address(0), _msgSender(), _tTotal);
448     }
449 
450     function name() public view returns (string memory) {
451         return _name;
452     }
453 
454     function symbol() public view returns (string memory) {
455         return _symbol;
456     }
457 
458     function decimals() public view returns (uint8) {
459         return _decimals;
460     }
461 
462     function totalSupply() public view override returns (uint256) {
463         return _tTotal;
464     }
465 
466     function balanceOf(address account) public view override returns (uint256) {
467         if (_isExcluded[account]) return _tOwned[account];
468         return tokenFromReflection(_rOwned[account]);
469     }
470 
471     function transfer(address recipient, uint256 amount) public override returns (bool) {
472         _transfer(_msgSender(), recipient, amount);
473         return true;
474     }
475 
476     function allowance(address owner, address spender) public view override returns (uint256) {
477         return _allowances[owner][spender];
478     }
479 
480     function approve(address spender, uint256 amount) public override returns (bool) {
481         _approve(_msgSender(), spender, amount);
482         return true;
483     }
484 
485     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
486         _transfer(sender, recipient, amount);
487         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
488         return true;
489     }
490 
491     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
492         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
493         return true;
494     }
495 
496     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
497         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
498         return true;
499     }
500 
501     function isExcluded(address account) public view returns (bool) {
502         return _isExcluded[account];
503     }
504 
505     function totalFees() public view returns (uint256) {
506         return _tFeeTotal;
507     }
508     
509     
510     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
511         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
512             10**2
513         );
514     }
515 
516     function reflect(uint256 tAmount) public {
517         address sender = _msgSender();
518         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
519         (uint256 rAmount,,,,) = _getValues(tAmount);
520         _rOwned[sender] = _rOwned[sender].sub(rAmount);
521         _rTotal = _rTotal.sub(rAmount);
522         _tFeeTotal = _tFeeTotal.add(tAmount);
523     }
524 
525     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
526         require(tAmount <= _tTotal, "Amount must be less than supply");
527         if (!deductTransferFee) {
528             (uint256 rAmount,,,,) = _getValues(tAmount);
529             return rAmount;
530         } else {
531             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
532             return rTransferAmount;
533         }
534     }
535 
536     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
537         require(rAmount <= _rTotal, "Amount must be less than total reflections");
538         uint256 currentRate =  _getRate();
539         return rAmount.div(currentRate);
540     }
541 
542     function excludeAccount(address account) external onlyOwner() {
543         require(!_isExcluded[account], "Account is already excluded");
544         if(_rOwned[account] > 0) {
545             _tOwned[account] = tokenFromReflection(_rOwned[account]);
546         }
547         _isExcluded[account] = true;
548         _excluded.push(account);
549     }
550 
551     function includeAccount(address account) external onlyOwner() {
552         require(_isExcluded[account], "Account is already excluded");
553         for (uint256 i = 0; i < _excluded.length; i++) {
554             if (_excluded[i] == account) {
555                 _excluded[i] = _excluded[_excluded.length - 1];
556                 _tOwned[account] = 0;
557                 _isExcluded[account] = false;
558                 _excluded.pop();
559                 break;
560             }
561         }
562     }
563 
564     function _approve(address owner, address spender, uint256 amount) private {
565         require(owner != address(0), "ERC20: approve from the zero address");
566         require(spender != address(0), "ERC20: approve to the zero address");
567 
568         _allowances[owner][spender] = amount;
569         emit Approval(owner, spender, amount);
570     }
571 
572     function _transfer(address sender, address recipient, uint256 amount) private {
573         require(sender != address(0), "ERC20: transfer from the zero address");
574         require(recipient != address(0), "ERC20: transfer to the zero address");
575         require(amount > 0, "Transfer amount must be greater than zero");
576         if(sender != owner() && recipient != owner())
577           require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
578             
579         if (_isExcluded[sender] && !_isExcluded[recipient]) {
580             _transferFromExcluded(sender, recipient, amount);
581         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
582             _transferToExcluded(sender, recipient, amount);
583         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
584             _transferStandard(sender, recipient, amount);
585         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
586             _transferBothExcluded(sender, recipient, amount);
587         } else {
588             _transferStandard(sender, recipient, amount);
589         }
590     }
591 
592     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
593         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
594         _rOwned[sender] = _rOwned[sender].sub(rAmount);
595         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
596         _reflectFee(rFee, tFee);
597         emit Transfer(sender, recipient, tTransferAmount);
598     }
599 
600     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
601         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
602         _rOwned[sender] = _rOwned[sender].sub(rAmount);
603         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
604         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
605         _reflectFee(rFee, tFee);
606         emit Transfer(sender, recipient, tTransferAmount);
607     }
608 
609     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
610         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
611         _tOwned[sender] = _tOwned[sender].sub(tAmount);
612         _rOwned[sender] = _rOwned[sender].sub(rAmount);
613         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
614         _reflectFee(rFee, tFee);
615         emit Transfer(sender, recipient, tTransferAmount);
616     }
617 
618     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
619         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
620         _tOwned[sender] = _tOwned[sender].sub(tAmount);
621         _rOwned[sender] = _rOwned[sender].sub(rAmount);
622         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
623         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
624         _reflectFee(rFee, tFee);
625         emit Transfer(sender, recipient, tTransferAmount);
626     }
627 
628     function _reflectFee(uint256 rFee, uint256 tFee) private {
629         _rTotal = _rTotal.sub(rFee);
630         _tFeeTotal = _tFeeTotal.add(tFee);
631     }
632 
633     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
634         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
635         uint256 currentRate =  _getRate();
636         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
637         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
638     }
639 
640     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
641         uint256 tFee = tAmount.div(100).mul(2);
642         uint256 tTransferAmount = tAmount.sub(tFee);
643         return (tTransferAmount, tFee);
644     }
645 
646     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
647         uint256 rAmount = tAmount.mul(currentRate);
648         uint256 rFee = tFee.mul(currentRate);
649         uint256 rTransferAmount = rAmount.sub(rFee);
650         return (rAmount, rTransferAmount, rFee);
651     }
652 
653     function _getRate() private view returns(uint256) {
654         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
655         return rSupply.div(tSupply);
656     }
657 
658     function _getCurrentSupply() private view returns(uint256, uint256) {
659         uint256 rSupply = _rTotal;
660         uint256 tSupply = _tTotal;      
661         for (uint256 i = 0; i < _excluded.length; i++) {
662             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
663             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
664             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
665         }
666         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
667         return (rSupply, tSupply);
668     }
669 }
1 pragma solidity ^0.5.0;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
28 
29 /**
30  * @title SafeMath
31  * @dev Unsigned math operations with safety checks that revert on error
32  */
33 library SafeMath {
34     /**
35     * @dev Multiplies two unsigned integers, reverts on overflow.
36     */
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39         // benefit is lost if 'b' is also tested.
40         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41         if (a == 0) {
42             return 0;
43         }
44 
45         uint256 c = a * b;
46         require(c / a == b);
47 
48         return c;
49     }
50 
51     /**
52     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
53     */
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         // Solidity only automatically asserts when dividing by 0
56         require(b > 0);
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59 
60         return c;
61     }
62 
63     /**
64     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
65     */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b <= a);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     /**
74     * @dev Adds two unsigned integers, reverts on overflow.
75     */
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a);
79 
80         return c;
81     }
82 
83     /**
84     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
85     * reverts when dividing by zero.
86     */
87     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b != 0);
89         return a % b;
90     }
91 }
92 
93 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
100  * Originally based on code by FirstBlood:
101  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  *
103  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
104  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
105  * compliant implementations may not do it.
106  */
107 contract ERC20 is IERC20 {
108     using SafeMath for uint256;
109 
110     mapping (address => uint256) private _balances;
111 
112     mapping (address => mapping (address => uint256)) private _allowed;
113 
114     uint256 private _totalSupply;
115 
116     /**
117     * @dev Total number of tokens in existence
118     */
119     function totalSupply() public view returns (uint256) {
120         return _totalSupply;
121     }
122 
123     /**
124     * @dev Gets the balance of the specified address.
125     * @param owner The address to query the balance of.
126     * @return An uint256 representing the amount owned by the passed address.
127     */
128     function balanceOf(address owner) public view returns (uint256) {
129         return _balances[owner];
130     }
131 
132     /**
133      * @dev Function to check the amount of tokens that an owner allowed to a spender.
134      * @param owner address The address which owns the funds.
135      * @param spender address The address which will spend the funds.
136      * @return A uint256 specifying the amount of tokens still available for the spender.
137      */
138     function allowance(address owner, address spender) public view returns (uint256) {
139         return _allowed[owner][spender];
140     }
141 
142     /**
143     * @dev Transfer token for a specified address
144     * @param to The address to transfer to.
145     * @param value The amount to be transferred.
146     */
147     function transfer(address to, uint256 value) public returns (bool) {
148         _transfer(msg.sender, to, value);
149         return true;
150     }
151 
152     /**
153      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154      * Beware that changing an allowance with this method brings the risk that someone may use both the old
155      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      * @param spender The address which will spend the funds.
159      * @param value The amount of tokens to be spent.
160      */
161     function approve(address spender, uint256 value) public returns (bool) {
162         require(spender != address(0));
163 
164         _allowed[msg.sender][spender] = value;
165         emit Approval(msg.sender, spender, value);
166         return true;
167     }
168 
169     /**
170      * @dev Transfer tokens from one address to another.
171      * Note that while this function emits an Approval event, this is not required as per the specification,
172      * and other compliant implementations may not emit the event.
173      * @param from address The address which you want to send tokens from
174      * @param to address The address which you want to transfer to
175      * @param value uint256 the amount of tokens to be transferred
176      */
177     function transferFrom(address from, address to, uint256 value) public returns (bool) {
178         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
179         _transfer(from, to, value);
180         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
181         return true;
182     }
183 
184     /**
185      * @dev Increase the amount of tokens that an owner allowed to a spender.
186      * approve should be called when allowed_[_spender] == 0. To increment
187      * allowed value is better to use this function to avoid 2 calls (and wait until
188      * the first transaction is mined)
189      * From MonolithDAO Token.sol
190      * Emits an Approval event.
191      * @param spender The address which will spend the funds.
192      * @param addedValue The amount of tokens to increase the allowance by.
193      */
194     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
195         require(spender != address(0));
196 
197         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
198         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
199         return true;
200     }
201 
202     /**
203      * @dev Decrease the amount of tokens that an owner allowed to a spender.
204      * approve should be called when allowed_[_spender] == 0. To decrement
205      * allowed value is better to use this function to avoid 2 calls (and wait until
206      * the first transaction is mined)
207      * From MonolithDAO Token.sol
208      * Emits an Approval event.
209      * @param spender The address which will spend the funds.
210      * @param subtractedValue The amount of tokens to decrease the allowance by.
211      */
212     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
213         require(spender != address(0));
214 
215         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
216         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
217         return true;
218     }
219 
220     /**
221     * @dev Transfer token for a specified addresses
222     * @param from The address to transfer from.
223     * @param to The address to transfer to.
224     * @param value The amount to be transferred.
225     */
226     function _transfer(address from, address to, uint256 value) internal {
227         require(to != address(0));
228 
229         _balances[from] = _balances[from].sub(value);
230         _balances[to] = _balances[to].add(value);
231         emit Transfer(from, to, value);
232     }
233 
234     /**
235      * @dev Internal function that mints an amount of the token and assigns it to
236      * an account. This encapsulates the modification of balances such that the
237      * proper events are emitted.
238      * @param account The account that will receive the created tokens.
239      * @param value The amount that will be created.
240      */
241     function _mint(address account, uint256 value) internal {
242         require(account != address(0));
243 
244         _totalSupply = _totalSupply.add(value);
245         _balances[account] = _balances[account].add(value);
246         emit Transfer(address(0), account, value);
247     }
248 
249     /**
250      * @dev Internal function that burns an amount of the token of a given
251      * account.
252      * @param account The account whose tokens will be burnt.
253      * @param value The amount that will be burnt.
254      */
255     function _burn(address account, uint256 value) internal {
256         require(account != address(0));
257 
258         _totalSupply = _totalSupply.sub(value);
259         _balances[account] = _balances[account].sub(value);
260         emit Transfer(account, address(0), value);
261     }
262 
263     /**
264      * @dev Internal function that burns an amount of the token of a given
265      * account, deducting from the sender's allowance for said account. Uses the
266      * internal burn function.
267      * Emits an Approval event (reflecting the reduced allowance).
268      * @param account The account whose tokens will be burnt.
269      * @param value The amount that will be burnt.
270      */
271     function _burnFrom(address account, uint256 value) internal {
272         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
273         _burn(account, value);
274         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
275     }
276 }
277 
278 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
279 
280 /**
281  * @title ERC20Detailed token
282  * @dev The decimals are only for visualization purposes.
283  * All the operations are done using the smallest and indivisible token unit,
284  * just as on Ethereum all the operations are done in wei.
285  */
286 contract ERC20Detailed is IERC20 {
287     string private _name;
288     string private _symbol;
289     uint8 private _decimals;
290 
291     constructor (string memory name, string memory symbol, uint8 decimals) public {
292         _name = name;
293         _symbol = symbol;
294         _decimals = decimals;
295     }
296 
297     /**
298      * @return the name of the token.
299      */
300     function name() public view returns (string memory) {
301         return _name;
302     }
303 
304     /**
305      * @return the symbol of the token.
306      */
307     function symbol() public view returns (string memory) {
308         return _symbol;
309     }
310 
311     /**
312      * @return the number of decimals of the token.
313      */
314     function decimals() public view returns (uint8) {
315         return _decimals;
316     }
317 }
318 
319 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
320 
321 /**
322  * @title Burnable Token
323  * @dev Token that can be irreversibly burned (destroyed).
324  */
325 contract ERC20Burnable is ERC20 {
326     /**
327      * @dev Burns a specific amount of tokens.
328      * @param value The amount of token to be burned.
329      */
330     function burn(uint256 value) public {
331         _burn(msg.sender, value);
332     }
333 
334     /**
335      * @dev Burns a specific amount of tokens from the target address and decrements allowance
336      * @param from address The address which you want to send tokens from
337      * @param value uint256 The amount of token to be burned
338      */
339     function burnFrom(address from, uint256 value) public {
340         _burnFrom(from, value);
341     }
342 }
343 
344 // File: openzeppelin-solidity/contracts/access/Roles.sol
345 
346 /**
347  * @title Roles
348  * @dev Library for managing addresses assigned to a Role.
349  */
350 library Roles {
351     struct Role {
352         mapping (address => bool) bearer;
353     }
354 
355     /**
356      * @dev give an account access to this role
357      */
358     function add(Role storage role, address account) internal {
359         require(account != address(0));
360         require(!has(role, account));
361 
362         role.bearer[account] = true;
363     }
364 
365     /**
366      * @dev remove an account's access to this role
367      */
368     function remove(Role storage role, address account) internal {
369         require(account != address(0));
370         require(has(role, account));
371 
372         role.bearer[account] = false;
373     }
374 
375     /**
376      * @dev check if an account has this role
377      * @return bool
378      */
379     function has(Role storage role, address account) internal view returns (bool) {
380         require(account != address(0));
381         return role.bearer[account];
382     }
383 }
384 
385 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
386 
387 contract PauserRole {
388     using Roles for Roles.Role;
389 
390     event PauserAdded(address indexed account);
391     event PauserRemoved(address indexed account);
392 
393     Roles.Role private _pausers;
394 
395     constructor () internal {
396         _addPauser(msg.sender);
397     }
398 
399     modifier onlyPauser() {
400         require(isPauser(msg.sender));
401         _;
402     }
403 
404     function isPauser(address account) public view returns (bool) {
405         return _pausers.has(account);
406     }
407 
408     function addPauser(address account) public onlyPauser {
409         _addPauser(account);
410     }
411 
412     function renouncePauser() public {
413         _removePauser(msg.sender);
414     }
415 
416     function _addPauser(address account) internal {
417         _pausers.add(account);
418         emit PauserAdded(account);
419     }
420 
421     function _removePauser(address account) internal {
422         _pausers.remove(account);
423         emit PauserRemoved(account);
424     }
425 }
426 
427 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
428 
429 /**
430  * @title Pausable
431  * @dev Base contract which allows children to implement an emergency stop mechanism.
432  */
433 contract Pausable is PauserRole {
434     event Paused(address account);
435     event Unpaused(address account);
436 
437     bool private _paused;
438 
439     constructor () internal {
440         _paused = false;
441     }
442 
443     /**
444      * @return true if the contract is paused, false otherwise.
445      */
446     function paused() public view returns (bool) {
447         return _paused;
448     }
449 
450     /**
451      * @dev Modifier to make a function callable only when the contract is not paused.
452      */
453     modifier whenNotPaused() {
454         require(!_paused);
455         _;
456     }
457 
458     /**
459      * @dev Modifier to make a function callable only when the contract is paused.
460      */
461     modifier whenPaused() {
462         require(_paused);
463         _;
464     }
465 
466     /**
467      * @dev called by the owner to pause, triggers stopped state
468      */
469     function pause() public onlyPauser whenNotPaused {
470         _paused = true;
471         emit Paused(msg.sender);
472     }
473 
474     /**
475      * @dev called by the owner to unpause, returns to normal state
476      */
477     function unpause() public onlyPauser whenPaused {
478         _paused = false;
479         emit Unpaused(msg.sender);
480     }
481 }
482 
483 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
484 
485 /**
486  * @title Pausable token
487  * @dev ERC20 modified with pausable transfers.
488  **/
489 contract ERC20Pausable is ERC20, Pausable {
490     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
491         return super.transfer(to, value);
492     }
493 
494     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
495         return super.transferFrom(from, to, value);
496     }
497 
498     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
499         return super.approve(spender, value);
500     }
501 
502     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
503         return super.increaseAllowance(spender, addedValue);
504     }
505 
506     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
507         return super.decreaseAllowance(spender, subtractedValue);
508     }
509 }
510 
511 // File: contracts/Blockbid.sol
512 
513 contract Blockbid is ERC20, ERC20Detailed, ERC20Burnable, ERC20Pausable {
514 	uint private INITIAL_SUPPLY = 108178000e2;
515 	
516 	constructor ()
517 		ERC20Burnable()
518 		ERC20Detailed("Blockbid", "BID", 2)
519 		ERC20()
520 		public
521 	{
522 		_mint(msg.sender, INITIAL_SUPPLY);
523 	}
524 }
1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
68 
69 /**
70  * @title Pausable
71  * @dev Base contract which allows children to implement an emergency stop mechanism.
72  */
73 contract Pausable is Ownable {
74   event Pause();
75   event Unpause();
76 
77   bool public paused = false;
78 
79 
80   /**
81    * @dev Modifier to make a function callable only when the contract is not paused.
82    */
83   modifier whenNotPaused() {
84     require(!paused);
85     _;
86   }
87 
88   /**
89    * @dev Modifier to make a function callable only when the contract is paused.
90    */
91   modifier whenPaused() {
92     require(paused);
93     _;
94   }
95 
96   /**
97    * @dev called by the owner to pause, triggers stopped state
98    */
99   function pause() onlyOwner whenNotPaused public {
100     paused = true;
101     emit Pause();
102   }
103 
104   /**
105    * @dev called by the owner to unpause, returns to normal state
106    */
107   function unpause() onlyOwner whenPaused public {
108     paused = false;
109     emit Unpause();
110   }
111 }
112 
113 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
114 
115 /**
116  * @title SafeMath
117  * @dev Math operations with safety checks that throw on error
118  */
119 library SafeMath {
120 
121   /**
122   * @dev Multiplies two numbers, throws on overflow.
123   */
124   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
125     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
126     // benefit is lost if 'b' is also tested.
127     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
128     if (a == 0) {
129       return 0;
130     }
131 
132     c = a * b;
133     assert(c / a == b);
134     return c;
135   }
136 
137   /**
138   * @dev Integer division of two numbers, truncating the quotient.
139   */
140   function div(uint256 a, uint256 b) internal pure returns (uint256) {
141     // assert(b > 0); // Solidity automatically throws when dividing by 0
142     // uint256 c = a / b;
143     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
144     return a / b;
145   }
146 
147   /**
148   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
149   */
150   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
151     assert(b <= a);
152     return a - b;
153   }
154 
155   /**
156   * @dev Adds two numbers, throws on overflow.
157   */
158   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
159     c = a + b;
160     assert(c >= a);
161     return c;
162   }
163 }
164 
165 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
166 
167 /**
168  * @title ERC20Basic
169  * @dev Simpler version of ERC20 interface
170  * See https://github.com/ethereum/EIPs/issues/179
171  */
172 contract ERC20Basic {
173   function totalSupply() public view returns (uint256);
174   function balanceOf(address who) public view returns (uint256);
175   function transfer(address to, uint256 value) public returns (bool);
176   event Transfer(address indexed from, address indexed to, uint256 value);
177 }
178 
179 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
180 
181 /**
182  * @title Basic token
183  * @dev Basic version of StandardToken, with no allowances.
184  */
185 contract BasicToken is ERC20Basic {
186   using SafeMath for uint256;
187 
188   mapping(address => uint256) balances;
189 
190   uint256 totalSupply_;
191 
192   /**
193   * @dev Total number of tokens in existence
194   */
195   function totalSupply() public view returns (uint256) {
196     return totalSupply_;
197   }
198 
199   /**
200   * @dev Transfer token for a specified address
201   * @param _to The address to transfer to.
202   * @param _value The amount to be transferred.
203   */
204   function transfer(address _to, uint256 _value) public returns (bool) {
205     require(_to != address(0));
206     require(_value <= balances[msg.sender]);
207 
208     balances[msg.sender] = balances[msg.sender].sub(_value);
209     balances[_to] = balances[_to].add(_value);
210     emit Transfer(msg.sender, _to, _value);
211     return true;
212   }
213 
214   /**
215   * @dev Gets the balance of the specified address.
216   * @param _owner The address to query the the balance of.
217   * @return An uint256 representing the amount owned by the passed address.
218   */
219   function balanceOf(address _owner) public view returns (uint256) {
220     return balances[_owner];
221   }
222 
223 }
224 
225 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
226 
227 /**
228  * @title ERC20 interface
229  * @dev see https://github.com/ethereum/EIPs/issues/20
230  */
231 contract ERC20 is ERC20Basic {
232   function allowance(address owner, address spender)
233     public view returns (uint256);
234 
235   function transferFrom(address from, address to, uint256 value)
236     public returns (bool);
237 
238   function approve(address spender, uint256 value) public returns (bool);
239   event Approval(
240     address indexed owner,
241     address indexed spender,
242     uint256 value
243   );
244 }
245 
246 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
247 
248 /**
249  * @title Standard ERC20 token
250  *
251  * @dev Implementation of the basic standard token.
252  * https://github.com/ethereum/EIPs/issues/20
253  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
254  */
255 contract StandardToken is ERC20, BasicToken {
256 
257   mapping (address => mapping (address => uint256)) internal allowed;
258 
259 
260   /**
261    * @dev Transfer tokens from one address to another
262    * @param _from address The address which you want to send tokens from
263    * @param _to address The address which you want to transfer to
264    * @param _value uint256 the amount of tokens to be transferred
265    */
266   function transferFrom(
267     address _from,
268     address _to,
269     uint256 _value
270   )
271     public
272     returns (bool)
273   {
274     require(_to != address(0));
275     require(_value <= balances[_from]);
276     require(_value <= allowed[_from][msg.sender]);
277 
278     balances[_from] = balances[_from].sub(_value);
279     balances[_to] = balances[_to].add(_value);
280     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
281     emit Transfer(_from, _to, _value);
282     return true;
283   }
284 
285   /**
286    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
287    * Beware that changing an allowance with this method brings the risk that someone may use both the old
288    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
289    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
290    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
291    * @param _spender The address which will spend the funds.
292    * @param _value The amount of tokens to be spent.
293    */
294   function approve(address _spender, uint256 _value) public returns (bool) {
295     allowed[msg.sender][_spender] = _value;
296     emit Approval(msg.sender, _spender, _value);
297     return true;
298   }
299 
300   /**
301    * @dev Function to check the amount of tokens that an owner allowed to a spender.
302    * @param _owner address The address which owns the funds.
303    * @param _spender address The address which will spend the funds.
304    * @return A uint256 specifying the amount of tokens still available for the spender.
305    */
306   function allowance(
307     address _owner,
308     address _spender
309    )
310     public
311     view
312     returns (uint256)
313   {
314     return allowed[_owner][_spender];
315   }
316 
317   /**
318    * @dev Increase the amount of tokens that an owner allowed to a spender.
319    * approve should be called when allowed[_spender] == 0. To increment
320    * allowed value is better to use this function to avoid 2 calls (and wait until
321    * the first transaction is mined)
322    * From MonolithDAO Token.sol
323    * @param _spender The address which will spend the funds.
324    * @param _addedValue The amount of tokens to increase the allowance by.
325    */
326   function increaseApproval(
327     address _spender,
328     uint256 _addedValue
329   )
330     public
331     returns (bool)
332   {
333     allowed[msg.sender][_spender] = (
334       allowed[msg.sender][_spender].add(_addedValue));
335     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
336     return true;
337   }
338 
339   /**
340    * @dev Decrease the amount of tokens that an owner allowed to a spender.
341    * approve should be called when allowed[_spender] == 0. To decrement
342    * allowed value is better to use this function to avoid 2 calls (and wait until
343    * the first transaction is mined)
344    * From MonolithDAO Token.sol
345    * @param _spender The address which will spend the funds.
346    * @param _subtractedValue The amount of tokens to decrease the allowance by.
347    */
348   function decreaseApproval(
349     address _spender,
350     uint256 _subtractedValue
351   )
352     public
353     returns (bool)
354   {
355     uint256 oldValue = allowed[msg.sender][_spender];
356     if (_subtractedValue > oldValue) {
357       allowed[msg.sender][_spender] = 0;
358     } else {
359       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
360     }
361     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
362     return true;
363   }
364 
365 }
366 
367 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
368 
369 /**
370  * @title Pausable token
371  * @dev StandardToken modified with pausable transfers.
372  **/
373 contract PausableToken is StandardToken, Pausable {
374 
375   function transfer(
376     address _to,
377     uint256 _value
378   )
379     public
380     whenNotPaused
381     returns (bool)
382   {
383     return super.transfer(_to, _value);
384   }
385 
386   function transferFrom(
387     address _from,
388     address _to,
389     uint256 _value
390   )
391     public
392     whenNotPaused
393     returns (bool)
394   {
395     return super.transferFrom(_from, _to, _value);
396   }
397 
398   function approve(
399     address _spender,
400     uint256 _value
401   )
402     public
403     whenNotPaused
404     returns (bool)
405   {
406     return super.approve(_spender, _value);
407   }
408 
409   function increaseApproval(
410     address _spender,
411     uint _addedValue
412   )
413     public
414     whenNotPaused
415     returns (bool success)
416   {
417     return super.increaseApproval(_spender, _addedValue);
418   }
419 
420   function decreaseApproval(
421     address _spender,
422     uint _subtractedValue
423   )
424     public
425     whenNotPaused
426     returns (bool success)
427   {
428     return super.decreaseApproval(_spender, _subtractedValue);
429   }
430 }
431 
432 // File: contracts/RodrigoToken.sol
433 
434 contract RodrigoToken is PausableToken {
435 
436   string public constant name = "RodrigoToken";
437   string public constant symbol = "ROD";
438   uint8 public constant decimals = 18;
439   uint256 public constant INITIAL_SUPPLY = 5e6 * 10**uint256(decimals);
440 
441   constructor() {
442     totalSupply_ = INITIAL_SUPPLY;
443     balances[msg.sender] = INITIAL_SUPPLY;
444     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
445   }
446 }
1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: zeppelin-solidity/contracts/math/SafeMath.sol
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 library SafeMath {
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     // assert(b > 0); // Solidity automatically throws when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67     return c;
68   }
69 
70   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: zeppelin-solidity/contracts/token/BasicToken.sol
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[msg.sender]);
115 
116     // SafeMath.sub will throw if there is not enough balance.
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 // File: zeppelin-solidity/contracts/token/ERC20.sol
135 
136 /**
137  * @title ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/20
139  */
140 contract ERC20 is ERC20Basic {
141   function allowance(address owner, address spender) public view returns (uint256);
142   function transferFrom(address from, address to, uint256 value) public returns (bool);
143   function approve(address spender, uint256 value) public returns (bool);
144   event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 // File: zeppelin-solidity/contracts/token/StandardToken.sol
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint256 the amount of tokens to be transferred
166    */
167   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    *
182    * Beware that changing an allowance with this method brings the risk that someone may use both the old
183    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186    * @param _spender The address which will spend the funds.
187    * @param _value The amount of tokens to be spent.
188    */
189   function approve(address _spender, uint256 _value) public returns (bool) {
190     allowed[msg.sender][_spender] = _value;
191     Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Function to check the amount of tokens that an owner allowed to a spender.
197    * @param _owner address The address which owns the funds.
198    * @param _spender address The address which will spend the funds.
199    * @return A uint256 specifying the amount of tokens still available for the spender.
200    */
201   function allowance(address _owner, address _spender) public view returns (uint256) {
202     return allowed[_owner][_spender];
203   }
204 
205   /**
206    * @dev Increase the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
216     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
232     uint oldValue = allowed[msg.sender][_spender];
233     if (_subtractedValue > oldValue) {
234       allowed[msg.sender][_spender] = 0;
235     } else {
236       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
237     }
238     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242 }
243 
244 // File: zeppelin-solidity/contracts/token/MintableToken.sol
245 
246 /**
247  * @title Mintable token
248  * @dev Simple ERC20 Token example, with mintable token creation
249  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
250  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
251  */
252 
253 contract MintableToken is StandardToken, Ownable {
254   event Mint(address indexed to, uint256 amount);
255   event MintFinished();
256 
257   bool public mintingFinished = false;
258 
259 
260   modifier canMint() {
261     require(!mintingFinished);
262     _;
263   }
264 
265   /**
266    * @dev Function to mint tokens
267    * @param _to The address that will receive the minted tokens.
268    * @param _amount The amount of tokens to mint.
269    * @return A boolean that indicates if the operation was successful.
270    */
271   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
272     totalSupply = totalSupply.add(_amount);
273     balances[_to] = balances[_to].add(_amount);
274     Mint(_to, _amount);
275     Transfer(address(0), _to, _amount);
276     return true;
277   }
278 
279   /**
280    * @dev Function to stop minting new tokens.
281    * @return True if the operation was successful.
282    */
283   function finishMinting() onlyOwner canMint public returns (bool) {
284     mintingFinished = true;
285     MintFinished();
286     return true;
287   }
288 }
289 
290 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
291 
292 /**
293  * @title Pausable
294  * @dev Base contract which allows children to implement an emergency stop mechanism.
295  */
296 contract Pausable is Ownable {
297   event Pause();
298   event Unpause();
299 
300   bool public paused = false;
301 
302 
303   /**
304    * @dev Modifier to make a function callable only when the contract is not paused.
305    */
306   modifier whenNotPaused() {
307     require(!paused);
308     _;
309   }
310 
311   /**
312    * @dev Modifier to make a function callable only when the contract is paused.
313    */
314   modifier whenPaused() {
315     require(paused);
316     _;
317   }
318 
319   /**
320    * @dev called by the owner to pause, triggers stopped state
321    */
322   function pause() onlyOwner whenNotPaused public {
323     paused = true;
324     Pause();
325   }
326 
327   /**
328    * @dev called by the owner to unpause, returns to normal state
329    */
330   function unpause() onlyOwner whenPaused public {
331     paused = false;
332     Unpause();
333   }
334 }
335 
336 // File: zeppelin-solidity/contracts/token/PausableToken.sol
337 
338 /**
339  * @title Pausable token
340  *
341  * @dev StandardToken modified with pausable transfers.
342  **/
343 
344 contract PausableToken is StandardToken, Pausable {
345 
346   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
347     return super.transfer(_to, _value);
348   }
349 
350   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
351     return super.transferFrom(_from, _to, _value);
352   }
353 
354   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
355     return super.approve(_spender, _value);
356   }
357 
358   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
359     return super.increaseApproval(_spender, _addedValue);
360   }
361 
362   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
363     return super.decreaseApproval(_spender, _subtractedValue);
364   }
365 }
366 
367 // File: contracts/WPR.sol
368 
369 /**
370  * @title WePower Contribution Token
371  */
372 contract TROJAN is MintableToken, PausableToken {
373   string constant public name = "TROJAN";
374   string constant public symbol = "TROJ";
375   uint constant public decimals = 18;
376 
377   function TROJAN() {
378   }
379 
380   //////////
381   // Safety Methods
382   //////////
383 
384   /// @notice This method can be used by the controller to extract mistakenly
385   ///  sent tokens to this contract.
386   /// @param _token The address of the token contract that you want to recover
387   ///  set to 0 in case you want to extract ether.
388   function claimTokens(address _token) public onlyOwner {
389     if (_token == 0x0) {
390       owner.transfer(this.balance);
391       return;
392     }
393 
394     ERC20 token = ERC20(_token);
395     uint balance = token.balanceOf(this);
396     token.transfer(owner, balance);
397     ClaimedTokens(_token, owner, balance);
398   }
399 
400   event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
401 
402   function disown() public onlyOwner {
403     OwnershipTransferred(owner, address(0));
404     owner = address(0);
405   }
406 }
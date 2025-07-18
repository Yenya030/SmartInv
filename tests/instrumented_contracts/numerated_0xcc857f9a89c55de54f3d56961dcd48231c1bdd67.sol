1 pragma solidity ^0.4.21;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     emit Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public view returns (uint256) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
112 
113 /**
114  * @title ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/20
116  */
117 contract ERC20 is ERC20Basic {
118   function allowance(address owner, address spender) public view returns (uint256);
119   function transferFrom(address from, address to, uint256 value) public returns (bool);
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
125 
126 /**
127  * @title Standard ERC20 token
128  *
129  * @dev Implementation of the basic standard token.
130  * @dev https://github.com/ethereum/EIPs/issues/20
131  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
132  */
133 contract StandardToken is ERC20, BasicToken {
134 
135   mapping (address => mapping (address => uint256)) internal allowed;
136 
137 
138   /**
139    * @dev Transfer tokens from one address to another
140    * @param _from address The address which you want to send tokens from
141    * @param _to address The address which you want to transfer to
142    * @param _value uint256 the amount of tokens to be transferred
143    */
144   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(_value <= balances[_from]);
147     require(_value <= allowed[_from][msg.sender]);
148 
149     balances[_from] = balances[_from].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152     emit Transfer(_from, _to, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    *
159    * Beware that changing an allowance with this method brings the risk that someone may use both the old
160    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
161    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
162    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163    * @param _spender The address which will spend the funds.
164    * @param _value The amount of tokens to be spent.
165    */
166   function approve(address _spender, uint256 _value) public returns (bool) {
167     allowed[msg.sender][_spender] = _value;
168     emit Approval(msg.sender, _spender, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Function to check the amount of tokens that an owner allowed to a spender.
174    * @param _owner address The address which owns the funds.
175    * @param _spender address The address which will spend the funds.
176    * @return A uint256 specifying the amount of tokens still available for the spender.
177    */
178   function allowance(address _owner, address _spender) public view returns (uint256) {
179     return allowed[_owner][_spender];
180   }
181 
182   /**
183    * @dev Increase the amount of tokens that an owner allowed to a spender.
184    *
185    * approve should be called when allowed[_spender] == 0. To increment
186    * allowed value is better to use this function to avoid 2 calls (and wait until
187    * the first transaction is mined)
188    * From MonolithDAO Token.sol
189    * @param _spender The address which will spend the funds.
190    * @param _addedValue The amount of tokens to increase the allowance by.
191    */
192   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
193     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
194     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     return true;
196   }
197 
198   /**
199    * @dev Decrease the amount of tokens that an owner allowed to a spender.
200    *
201    * approve should be called when allowed[_spender] == 0. To decrement
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _subtractedValue The amount of tokens to decrease the allowance by.
207    */
208   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
209     uint oldValue = allowed[msg.sender][_spender];
210     if (_subtractedValue > oldValue) {
211       allowed[msg.sender][_spender] = 0;
212     } else {
213       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
214     }
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219 }
220 
221 // File: contracts/ChildToken.sol
222 
223 /**
224  * @title ChildToken
225  * @dev ChildToken is the base contract of child token contracts
226  */
227 contract ChildToken is StandardToken {
228 }
229 
230 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
231 
232 /**
233  * @title Ownable
234  * @dev The Ownable contract has an owner address, and provides basic authorization control
235  * functions, this simplifies the implementation of "user permissions".
236  */
237 contract Ownable {
238   address public owner;
239 
240 
241   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
242 
243 
244   /**
245    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
246    * account.
247    */
248   function Ownable() public {
249     owner = msg.sender;
250   }
251 
252   /**
253    * @dev Throws if called by any account other than the owner.
254    */
255   modifier onlyOwner() {
256     require(msg.sender == owner);
257     _;
258   }
259 
260   /**
261    * @dev Allows the current owner to transfer control of the contract to a newOwner.
262    * @param newOwner The address to transfer ownership to.
263    */
264   function transferOwnership(address newOwner) public onlyOwner {
265     require(newOwner != address(0));
266     emit OwnershipTransferred(owner, newOwner);
267     owner = newOwner;
268   }
269 
270 }
271 
272 // File: contracts/Refundable.sol
273 
274 /**
275  * @title Refundable
276  * @dev Base contract that can refund funds(ETH and tokens) by owner.
277  * @dev Reference TokenDestructible(zeppelinand) TokenDestructible(zeppelin)
278  */
279 contract Refundable is Ownable {
280 	event RefundETH(address indexed owner, address indexed payee, uint256 amount);
281 	event RefundERC20(address indexed owner, address indexed payee, address indexed token, uint256 amount);
282 
283 	function Refundable() public payable {
284 	}
285 
286 	function refundETH(address payee, uint256 amount) onlyOwner public {
287 		require(payee != address(0));
288 		require(this.balance >= amount);
289 		assert(payee.send(amount));
290 		RefundETH(owner, payee, amount);
291 	}
292 
293 	function refundERC20(address tokenContract, address payee, uint256 amount) onlyOwner public {
294 		require(payee != address(0));
295 		bool isContract;
296 		assembly {
297 			isContract := gt(extcodesize(tokenContract), 0)
298 		}
299 		require(isContract);
300 
301 		ERC20 token = ERC20(tokenContract);
302 		assert(token.transfer(payee, amount));
303 		RefundERC20(owner, payee, tokenContract, amount);
304 	}
305 }
306 
307 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
308 
309 /**
310  * @title Burnable Token
311  * @dev Token that can be irreversibly burned (destroyed).
312  */
313 contract BurnableToken is BasicToken {
314 
315   event Burn(address indexed burner, uint256 value);
316 
317   /**
318    * @dev Burns a specific amount of tokens.
319    * @param _value The amount of token to be burned.
320    */
321   function burn(uint256 _value) public {
322     _burn(msg.sender, _value);
323   }
324 
325   function _burn(address _who, uint256 _value) internal {
326     require(_value <= balances[_who]);
327     // no need to require value <= totalSupply, since that would imply the
328     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
329 
330     balances[_who] = balances[_who].sub(_value);
331     totalSupply_ = totalSupply_.sub(_value);
332     emit Burn(_who, _value);
333     emit Transfer(_who, address(0), _value);
334   }
335 }
336 
337 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
338 
339 /**
340  * @title Mintable token
341  * @dev Simple ERC20 Token example, with mintable token creation
342  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
343  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
344  */
345 contract MintableToken is StandardToken, Ownable {
346   event Mint(address indexed to, uint256 amount);
347   event MintFinished();
348 
349   bool public mintingFinished = false;
350 
351 
352   modifier canMint() {
353     require(!mintingFinished);
354     _;
355   }
356 
357   /**
358    * @dev Function to mint tokens
359    * @param _to The address that will receive the minted tokens.
360    * @param _amount The amount of tokens to mint.
361    * @return A boolean that indicates if the operation was successful.
362    */
363   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
364     totalSupply_ = totalSupply_.add(_amount);
365     balances[_to] = balances[_to].add(_amount);
366     emit Mint(_to, _amount);
367     emit Transfer(address(0), _to, _amount);
368     return true;
369   }
370 
371   /**
372    * @dev Function to stop minting new tokens.
373    * @return True if the operation was successful.
374    */
375   function finishMinting() onlyOwner canMint public returns (bool) {
376     mintingFinished = true;
377     emit MintFinished();
378     return true;
379   }
380 }
381 
382 // File: contracts/ComplexChildToken.sol
383 
384 /**
385  * @title ComplexChildToken
386  * @dev Complex child token to be generated by TokenFather.
387  */
388 contract ComplexChildToken is ChildToken, Refundable, MintableToken, BurnableToken {
389 	string public name;
390 	string public symbol;
391 	uint8 public decimals;
392 	bool public canBurn;
393 
394 	event Burn(address indexed burner, uint256 value);
395 
396 	function ComplexChildToken(address _owner, string _name, string _symbol, uint256 _initSupply, uint8 _decimals,
397 		bool _canMint, bool _canBurn) public {
398 		require(_owner != address(0));
399 		owner = _owner;
400 		name = _name;
401 		symbol = _symbol;
402 		decimals = _decimals;
403 
404 		uint256 amount = _initSupply;
405 		totalSupply_ = totalSupply_.add(amount);
406 		balances[owner] = balances[owner].add(amount);
407 		Transfer(address(0), owner, amount);
408 
409 		if (!_canMint) {
410 			mintingFinished = true;
411 		}
412 		canBurn = _canBurn;
413 	}
414 
415 	/**
416 	* @dev Burns a specific amount of tokens.
417 	* @param _value The amount of token to be burned.
418 	*/
419 	function burn(uint256 _value) public {
420 		require(canBurn);
421 		BurnableToken.burn(_value);
422 	}
423 
424 	function ownerCanBurn(bool _canBurn) onlyOwner public {
425 		canBurn = _canBurn;
426 	}
427 }
1 pragma solidity ^0.4.24;
2 
3 // File: /zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: /zeppelin-solidity/contracts/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (_a == 0) {
33       return 0;
34     }
35 
36     c = _a * _b;
37     assert(c / _a == _b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     // assert(_b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = _a / _b;
47     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
48     return _a / _b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
55     assert(_b <= _a);
56     return _a - _b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
63     c = _a + _b;
64     assert(c >= _a);
65     return c;
66   }
67 }
68 
69 // File: /zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) internal balances;
79 
80   uint256 internal totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_value <= balances[msg.sender]);
96     require(_to != address(0));
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: /zeppelin-solidity/contracts/token/ERC20/ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address _owner, address _spender)
123     public view returns (uint256);
124 
125   function transferFrom(address _from, address _to, uint256 _value)
126     public returns (bool);
127 
128   function approve(address _spender, uint256 _value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 // File: /zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/issues/20
143  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166     require(_to != address(0));
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     emit Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(
197     address _owner,
198     address _spender
199    )
200     public
201     view
202     returns (uint256)
203   {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(
217     address _spender,
218     uint256 _addedValue
219   )
220     public
221     returns (bool)
222   {
223     allowed[msg.sender][_spender] = (
224       allowed[msg.sender][_spender].add(_addedValue));
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint256 _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint256 oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue >= oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 // File: /zeppelin-solidity/contracts/ownership/Ownable.sol
258 
259 /**
260  * @title Ownable
261  * @dev The Ownable contract has an owner address, and provides basic authorization control
262  * functions, this simplifies the implementation of "user permissions".
263  */
264 contract Ownable {
265   address public owner;
266 
267 
268   event OwnershipRenounced(address indexed previousOwner);
269   event OwnershipTransferred(
270     address indexed previousOwner,
271     address indexed newOwner
272   );
273 
274 
275   /**
276    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
277    * account.
278    */
279   constructor() public {
280     owner = msg.sender;
281   }
282 
283   /**
284    * @dev Throws if called by any account other than the owner.
285    */
286   modifier onlyOwner() {
287     require(msg.sender == owner);
288     _;
289   }
290 
291   /**
292    * @dev Allows the current owner to relinquish control of the contract.
293    * @notice Renouncing to ownership will leave the contract without an owner.
294    * It will not be possible to call the functions with the `onlyOwner`
295    * modifier anymore.
296    */
297   function renounceOwnership() public onlyOwner {
298     emit OwnershipRenounced(owner);
299     owner = address(0);
300   }
301 
302   /**
303    * @dev Allows the current owner to transfer control of the contract to a newOwner.
304    * @param _newOwner The address to transfer ownership to.
305    */
306   function transferOwnership(address _newOwner) public onlyOwner {
307     _transferOwnership(_newOwner);
308   }
309 
310   /**
311    * @dev Transfers control of the contract to a newOwner.
312    * @param _newOwner The address to transfer ownership to.
313    */
314   function _transferOwnership(address _newOwner) internal {
315     require(_newOwner != address(0));
316     emit OwnershipTransferred(owner, _newOwner);
317     owner = _newOwner;
318   }
319 }
320 
321 // File: /zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
322 
323 /**
324  * @title Mintable token
325  * @dev Simple ERC20 Token example, with mintable token creation
326  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
327  */
328 contract MintableToken is StandardToken, Ownable {
329   event Mint(address indexed to, uint256 amount);
330   event MintFinished();
331 
332   bool public mintingFinished = false;
333 
334 
335   modifier canMint() {
336     require(!mintingFinished);
337     _;
338   }
339 
340   modifier hasMintPermission() {
341     require(msg.sender == owner);
342     _;
343   }
344 
345   /**
346    * @dev Function to mint tokens
347    * @param _to The address that will receive the minted tokens.
348    * @param _amount The amount of tokens to mint.
349    * @return A boolean that indicates if the operation was successful.
350    */
351   function mint(
352     address _to,
353     uint256 _amount
354   )
355     public
356     hasMintPermission
357     canMint
358     returns (bool)
359   {
360     totalSupply_ = totalSupply_.add(_amount);
361     balances[_to] = balances[_to].add(_amount);
362     emit Mint(_to, _amount);
363     emit Transfer(address(0), _to, _amount);
364     return true;
365   }
366 
367   /**
368    * @dev Function to stop minting new tokens.
369    * @return True if the operation was successful.
370    */
371   function finishMinting() public onlyOwner canMint returns (bool) {
372     mintingFinished = true;
373     emit MintFinished();
374     return true;
375   }
376 }
377 
378 // File: /zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
379 
380 /**
381  * @title Burnable Token
382  * @dev Token that can be irreversibly burned (destroyed).
383  */
384 contract BurnableToken is BasicToken {
385 
386   event Burn(address indexed burner, uint256 value);
387 
388   /**
389    * @dev Burns a specific amount of tokens.
390    * @param _value The amount of token to be burned.
391    */
392   function burn(uint256 _value) public {
393     _burn(msg.sender, _value);
394   }
395 
396   function _burn(address _who, uint256 _value) internal {
397     require(_value <= balances[_who]);
398     // no need to require value <= totalSupply, since that would imply the
399     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
400 
401     balances[_who] = balances[_who].sub(_value);
402     totalSupply_ = totalSupply_.sub(_value);
403     emit Burn(_who, _value);
404     emit Transfer(_who, address(0), _value);
405   }
406 }
407 
408 // File: /zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
409 
410 /**
411  * @title SafeERC20
412  * @dev Wrappers around ERC20 operations that throw on failure.
413  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
414  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
415  */
416 library SafeERC20 {
417   function safeTransfer(
418     ERC20Basic _token,
419     address _to,
420     uint256 _value
421   )
422     internal
423   {
424     require(_token.transfer(_to, _value));
425   }
426 
427   function safeTransferFrom(
428     ERC20 _token,
429     address _from,
430     address _to,
431     uint256 _value
432   )
433     internal
434   {
435     require(_token.transferFrom(_from, _to, _value));
436   }
437 
438   function safeApprove(
439     ERC20 _token,
440     address _spender,
441     uint256 _value
442   )
443     internal
444   {
445     require(_token.approve(_spender, _value));
446   }
447 }
448 
449 // File: /zeppelin-solidity/contracts/ownership/CanReclaimToken.sol
450 
451 /**
452  * @title Contracts that should be able to recover tokens
453  * @author SylTi
454  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
455  * This will prevent any accidental loss of tokens.
456  */
457 contract CanReclaimToken is Ownable {
458   using SafeERC20 for ERC20Basic;
459 
460   /**
461    * @dev Reclaim all ERC20Basic compatible tokens
462    * @param _token ERC20Basic The address of the token contract
463    */
464   function reclaimToken(ERC20Basic _token) external onlyOwner {
465     uint256 balance = _token.balanceOf(this);
466     _token.safeTransfer(owner, balance);
467   }
468 
469 }
470 
471 // File: /zeppelin-solidity/contracts/ownership/HasNoTokens.sol
472 
473 /**
474  * @title Contracts that should not own Tokens
475  * @author Remco Bloemen <remco@2π.com>
476  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
477  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
478  * owner to reclaim the tokens.
479  */
480 contract HasNoTokens is CanReclaimToken {
481 
482  /**
483   * @dev Reject all ERC223 compatible tokens
484   * @param _from address The address that is transferring the tokens
485   * @param _value uint256 the amount of the specified token
486   * @param _data Bytes The data passed from the caller.
487   */
488   function tokenFallback(
489     address _from,
490     uint256 _value,
491     bytes _data
492   )
493     external
494     pure
495   {
496     _from;
497     _value;
498     _data;
499     revert();
500   }
501 
502 }
503 
504 // File: contracts/TradeJPY.sol
505 
506 /**
507  *@contract TradeJPY
508  */
509 contract TradeJPY is StandardToken, Ownable, HasNoTokens, BurnableToken, MintableToken{
510     string public name = "TradeJPY";
511     string public symbol = "TJPY";
512     uint public decimals = 8;
513     
514     event Transfer(address indexed from, address indexed to, uint value, bytes data);
515 
516     constructor(uint256 initialSupply) public {
517         totalSupply_ = initialSupply;
518         owner = msg.sender;
519         balances[msg.sender] = initialSupply;
520     }
521 
522     /**
523      * @dev Transfer the specified amount of tokens to the specified address.
524      *      Invokes the `tokenFallback` function if the recipient is a contract.
525      *      The token transfer fails if the recipient is a contract
526      *      but does not implement the `tokenFallback` function
527      *      or the fallback function to receive funds.
528      *
529      * @param _to    Receiver address.
530      * @param _value Amount of tokens that will be transferred.
531      * @param _data  Transaction metadata.
532      */
533     function transfer(address _to, uint _value, bytes _data) public {
534         // Standard function transfer similar to ERC20 transfer with no _data .
535         // Added due to backwards compatibility reasons .
536         uint codeLength;
537 
538         assembly {
539             // Retrieve the size of the code on target address, this needs assembly .
540             codeLength := extcodesize(_to)
541         }
542 
543         balances[msg.sender] = balances[msg.sender].sub(_value);
544         balances[_to] = balances[_to].add(_value);
545         if(codeLength>0) {
546             HasNoTokens receiver = HasNoTokens(_to);
547             receiver.tokenFallback(msg.sender, _value, _data);
548         }
549         emit Transfer(msg.sender, _to, _value, _data);
550     }
551 }
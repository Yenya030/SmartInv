1 pragma solidity 0.4.19;
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
206    * approve should be called when allowed[_spender] == 0. To increment
207    * allowed value is better to use this function to avoid 2 calls (and wait until
208    * the first transaction is mined)
209    * From MonolithDAO Token.sol
210    */
211   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
212     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
218     uint oldValue = allowed[msg.sender][_spender];
219     if (_subtractedValue > oldValue) {
220       allowed[msg.sender][_spender] = 0;
221     } else {
222       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
223     }
224     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228 }
229 
230 // File: zeppelin-solidity/contracts/token/MintableToken.sol
231 
232 /**
233  * @title Mintable token
234  * @dev Simple ERC20 Token example, with mintable token creation
235  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
236  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
237  */
238 
239 contract MintableToken is StandardToken, Ownable {
240   event Mint(address indexed to, uint256 amount);
241   event MintFinished();
242 
243   bool public mintingFinished = false;
244 
245 
246   modifier canMint() {
247     require(!mintingFinished);
248     _;
249   }
250 
251   /**
252    * @dev Function to mint tokens
253    * @param _to The address that will receive the minted tokens.
254    * @param _amount The amount of tokens to mint.
255    * @return A boolean that indicates if the operation was successful.
256    */
257   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
258     totalSupply = totalSupply.add(_amount);
259     balances[_to] = balances[_to].add(_amount);
260     Mint(_to, _amount);
261     Transfer(address(0), _to, _amount);
262     return true;
263   }
264 
265   /**
266    * @dev Function to stop minting new tokens.
267    * @return True if the operation was successful.
268    */
269   function finishMinting() onlyOwner canMint public returns (bool) {
270     mintingFinished = true;
271     MintFinished();
272     return true;
273   }
274 }
275 
276 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
277 
278 /**
279  * @title Pausable
280  * @dev Base contract which allows children to implement an emergency stop mechanism.
281  */
282 contract Pausable is Ownable {
283   event Pause();
284   event Unpause();
285 
286   bool public paused = false;
287 
288 
289   /**
290    * @dev Modifier to make a function callable only when the contract is not paused.
291    */
292   modifier whenNotPaused() {
293     require(!paused);
294     _;
295   }
296 
297   /**
298    * @dev Modifier to make a function callable only when the contract is paused.
299    */
300   modifier whenPaused() {
301     require(paused);
302     _;
303   }
304 
305   /**
306    * @dev called by the owner to pause, triggers stopped state
307    */
308   function pause() onlyOwner whenNotPaused public {
309     paused = true;
310     Pause();
311   }
312 
313   /**
314    * @dev called by the owner to unpause, returns to normal state
315    */
316   function unpause() onlyOwner whenPaused public {
317     paused = false;
318     Unpause();
319   }
320 }
321 
322 // File: zeppelin-solidity/contracts/token/PausableToken.sol
323 
324 /**
325  * @title Pausable token
326  *
327  * @dev StandardToken modified with pausable transfers.
328  **/
329 
330 contract PausableToken is StandardToken, Pausable {
331 
332   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
333     return super.transfer(_to, _value);
334   }
335 
336   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
337     return super.transferFrom(_from, _to, _value);
338   }
339 
340   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
341     return super.approve(_spender, _value);
342   }
343 
344   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
345     return super.increaseApproval(_spender, _addedValue);
346   }
347 
348   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
349     return super.decreaseApproval(_spender, _subtractedValue);
350   }
351 }
352 
353 // File: contracts/ODEMToken.sol
354 
355 /**
356  * @title ODEM Token contract - ERC20 compatible token contract.
357  * @author Gustavo Guimaraes - <gustavo@odem.io>
358  */
359 
360 contract ODEMToken is PausableToken, MintableToken {
361     string public constant name = "ODEM Token";
362     string public constant symbol = "ODEM";
363     uint8 public constant decimals = 18;
364 }
365 
366 // File: contracts/TeamAndAdvisorsAllocation.sol
367 
368 /**
369  * @title Team and Advisors Token Allocation contract
370  * @author Gustavo Guimaraes - <gustavo@odem.io>
371  */
372 
373 contract TeamAndAdvisorsAllocation is Ownable {
374     using SafeMath for uint;
375 
376     uint256 public unlockedAt;
377     uint256 public canSelfDestruct;
378     uint256 public tokensCreated;
379     uint256 public allocatedTokens;
380     uint256 private totalTeamAndAdvisorsAllocation = 38763636e18; // 38 mm
381 
382     mapping (address => uint256) public teamAndAdvisorsAllocations;
383 
384     ODEMToken public odem;
385 
386     /**
387      * @dev constructor function that sets owner and token for the TeamAndAdvisorsAllocation contract
388      * @param token Token contract address for ODEMToken
389      */
390     function TeamAndAdvisorsAllocation(address token) public {
391         odem = ODEMToken(token);
392         unlockedAt = now.add(182 days);
393         canSelfDestruct = now.add(365 days);
394     }
395 
396     /**
397      * @dev Adds founders' token allocation
398      * @param teamOrAdvisorsAddress Address of a founder
399      * @param allocationValue Number of tokens allocated to a founder
400      * @return true if address is correctly added
401      */
402     function addTeamAndAdvisorsAllocation(address teamOrAdvisorsAddress, uint256 allocationValue)
403         external
404         onlyOwner
405         returns(bool)
406     {
407         assert(teamAndAdvisorsAllocations[teamOrAdvisorsAddress] == 0); // can only add once.
408 
409         allocatedTokens = allocatedTokens.add(allocationValue);
410         require(allocatedTokens <= totalTeamAndAdvisorsAllocation);
411 
412         teamAndAdvisorsAllocations[teamOrAdvisorsAddress] = allocationValue;
413         return true;
414     }
415 
416     /**
417      * @dev Allow company to unlock allocated tokens by transferring them whitelisted addresses.
418      * Need to be called by each address
419      */
420     function unlock() external {
421         assert(now >= unlockedAt);
422 
423         // During first unlock attempt fetch total number of locked tokens.
424         if (tokensCreated == 0) {
425             tokensCreated = odem.balanceOf(this);
426         }
427 
428         uint256 transferAllocation = teamAndAdvisorsAllocations[msg.sender];
429         teamAndAdvisorsAllocations[msg.sender] = 0;
430 
431         // Will fail if allocation (and therefore toTransfer) is 0.
432         require(odem.transfer(msg.sender, transferAllocation));
433     }
434 
435     /**
436      * @dev allow for selfdestruct possibility and sending funds to owner
437      */
438     function kill() public onlyOwner {
439         assert(now >= canSelfDestruct);
440         uint256 balance = odem.balanceOf(this);
441 
442         if (balance > 0) {
443             odem.transfer(owner, balance);
444         }
445 
446         selfdestruct(owner);
447     }
448 }
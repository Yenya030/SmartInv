1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) constant returns (uint256);
11   function transfer(address to, uint256 value) returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) returns (bool);
22   function approve(address spender, uint256 value) returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31     
32   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
33     uint256 c = a * b;
34     assert(a == 0 || c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal constant returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal constant returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55   
56 }
57 
58 /**
59  * @title Basic token
60  * @dev Basic version of StandardToken, with no allowances. 
61  */
62 contract BasicToken is ERC20Basic {
63     
64   using SafeMath for uint256;
65 
66   mapping(address => uint256) balances;
67 
68   /**
69   * @dev transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) returns (bool) {
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     Transfer(msg.sender, _to, _value);
77     return true;
78   }
79 
80   /**
81   * @dev Gets the balance of the specified address.
82   * @param _owner The address to query the the balance of. 
83   * @return An uint256 representing the amount owned by the passed address.
84   */
85   function balanceOf(address _owner) constant returns (uint256 balance) {
86     return balances[_owner];
87   }
88 
89 }
90 
91 /**
92  * @title Standard ERC20 token
93  *
94  * @dev Implementation of the basic standard token.
95  * @dev https://github.com/ethereum/EIPs/issues/20
96  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  */
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) allowed;
101 
102   /**
103    * @dev Transfer tokens from one address to another
104    * @param _from address The address which you want to send tokens from
105    * @param _to address The address which you want to transfer to
106    * @param _value uint256 the amout of tokens to be transfered
107    */
108   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
109     var _allowance = allowed[_from][msg.sender];
110 
111     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
112     // require (_value <= _allowance);
113 
114     balances[_to] = balances[_to].add(_value);
115     balances[_from] = balances[_from].sub(_value);
116     allowed[_from][msg.sender] = _allowance.sub(_value);
117     Transfer(_from, _to, _value);
118     return true;
119   }
120 
121   /**
122    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
123    * @param _spender The address which will spend the funds.
124    * @param _value The amount of tokens to be spent.
125    */
126   function approve(address _spender, uint256 _value) returns (bool) {
127 
128     // To change the approve amount you first have to reduce the addresses`
129     //  allowance to zero by calling `approve(_spender, 0)` if it is not
130     //  already 0 to mitigate the race condition described here:
131     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
133 
134     allowed[msg.sender][_spender] = _value;
135     Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint256 specifing the amount of tokens still available for the spender.
144    */
145   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
146     return allowed[_owner][_spender];
147   }
148 
149 }
150 
151 /**
152  * @title Ownable
153  * @dev The Ownable contract has an owner address, and provides basic authorization control
154  * functions, this simplifies the implementation of "user permissions".
155  */
156 contract Ownable {
157     
158   address public owner;
159 
160   /**
161    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
162    * account.
163    */
164   function Ownable() {
165     owner = msg.sender;
166   }
167 
168   /**
169    * @dev Throws if called by any account other than the owner.
170    */
171   modifier onlyOwner() {
172     require(msg.sender == owner);
173     _;
174   }
175 
176   /**
177    * @dev Allows the current owner to transfer control of the contract to a newOwner.
178    * @param newOwner The address to transfer ownership to.
179    */
180   function transferOwnership(address newOwner) onlyOwner {
181     require(newOwner != address(0));      
182     owner = newOwner;
183   }
184 
185 }
186 
187 /**
188  * @title Burnable Token
189  * @dev Token that can be irreversibly burned (destroyed).
190  */
191 contract BurnableToken is StandardToken {
192 
193   /**
194    * @dev Burns a specific amount of tokens.
195    * @param _value The amount of token to be burned.
196    */
197   function burn(uint _value) public {
198     require(_value > 0);
199     address burner = msg.sender;
200     balances[burner] = balances[burner].sub(_value);
201     totalSupply = totalSupply.sub(_value);
202     Burn(burner, _value);
203   }
204 
205   event Burn(address indexed burner, uint indexed value);
206 
207 }
208 
209 contract Misscoin is BurnableToken {
210     
211   string public constant name = "Misscoin";
212    
213   string public constant symbol = "MISC";
214     
215   uint32 public constant decimals = 18;
216 
217   uint256 public INITIAL_SUPPLY = 1000000000 * 1 ether;
218 
219   function Misscoin() {
220     totalSupply = INITIAL_SUPPLY;
221     balances[msg.sender] = INITIAL_SUPPLY;
222     balances[0x49B25aDDdd6503d275375C7c261A444862360396]=150000000 * 1 ether;
223   }
224     
225 }
226 
227 contract Crowdsale is Ownable {
228     
229   using SafeMath for uint;
230     
231   address multisig;
232 
233   address restricted;
234 
235   bool addtok=false;
236 
237   Misscoin public token = new Misscoin();
238 
239   uint start;
240     
241   uint period;
242 
243   uint128 constant WAD = 10 ** 18;
244 
245   mapping (uint => mapping (address => uint))  public  userBuys;
246   mapping (uint => uint)                       public  dailyTotals;
247   mapping (uint => mapping (address => bool))  public  claimed;
248 
249    function Crowdsale() {
250       multisig = 0x49B25aDDdd6503d275375C7c261A444862360396;
251       restricted  = 0x49B25aDDdd6503d275375C7c261A444862360396;
252       start = 1512741600;
253       period = 150;
254     }
255 
256   modifier saleIsOn() {
257     require(now > start && now < start + period * 1 days);
258     _;
259   }
260 
261 
262 
263 
264 
265 
266 
267 
268 
269 
270 
271 
272 
273   function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
274         z = cast((uint256(x) * y + WAD / 2) / WAD);
275     }
276 
277     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
278         z = cast((uint256(x) * WAD + y / 2) / y);
279     }
280   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
281     assert(b <= a);
282     return a - b;
283   }
284    function cast(uint256 x) constant internal returns (uint128 z) {
285         assert((z = uint128(x)) == x);
286   }
287 
288   function time() constant returns (uint) {
289         return block.timestamp;
290   }
291 
292   function today() constant returns (uint) {
293         return dayFor(time());
294   }
295 
296   function dayFor(uint timestamp) constant returns (uint) {
297 
298         return timestamp < start
299             ? 0
300             : sub(timestamp, start) / 24 hours + 1;
301   }
302 
303   function buyWithLimit(uint day, uint limit) payable saleIsOn {
304         assert(time() >= start && today() <= period);
305         assert(msg.value >= 0.001 ether);
306         
307         assert(day >= today());
308         assert(day <= period);
309 
310         userBuys[day][msg.sender] += msg.value;
311         dailyTotals[day] += msg.value;
312 
313         if (limit != 0) {
314             assert(dailyTotals[day] <= limit);
315         }
316 
317   }
318 
319     function addtokens() onlyOwner{
320       assert(today() >= 149 && !addtok);
321       token.transfer(0x49B25aDDdd6503d275375C7c261A444862360396, 100000000 * 1 ether);
322       addtok=true;
323     }
324 
325     function buy() payable {
326        buyWithLimit(today(), 0);
327     }
328 
329     function () payable {
330        buy();
331     }
332   
333   function claim(uint day) saleIsOn {
334         assert(today() > day);
335 
336         if (claimed[day][msg.sender] || dailyTotals[day] == 0) {
337             return;
338         }
339 
340        
341 
342         var dailyTotal = cast(dailyTotals[day]);
343         var userTotal  = cast(userBuys[day][msg.sender]);
344         var price      = wdiv(cast(5000000), dailyTotal);
345         var reward     = wmul(price, userTotal);
346 
347         claimed[day][msg.sender] = true;
348         token.transfer(msg.sender, reward * 1 ether);
349 
350   } 
351 
352   function claimAll() {
353         for (uint i = 0; i < today(); i++) {
354             claim(i);
355         }
356   }
357 
358   function collect() onlyOwner{
359         assert(today() > 0); // Prevent recycling during window 0
360         multisig.transfer(this.balance);
361   }
362 
363     
364 }
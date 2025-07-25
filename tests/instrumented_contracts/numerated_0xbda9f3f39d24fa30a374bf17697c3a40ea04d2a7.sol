1 pragma solidity ^0.4.9;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender) public constant returns (uint256);
51   function transferFrom(address from, address to, uint256 value) public returns (bool);
52   function approve(address spender, uint256 value) public returns (bool);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 
57 /**
58  * @title Basic token
59  * @dev Basic version of StandardToken, with no allowances.
60  */
61 contract BasicToken is ERC20Basic {
62   using SafeMath for uint256;
63 
64   mapping(address => uint256) balances;
65 
66   /**
67   * @dev transfer token for a specified address
68   * @param _to The address to transfer to.
69   * @param _value The amount to be transferred.
70   */
71   function transfer(address _to, uint256 _value) public returns (bool) {
72     require(_to != address(0));
73     require(_value <= balances[msg.sender]);
74 
75     // SafeMath.sub will throw if there is not enough balance.
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public constant returns (uint256 balance) {
88     return balances[_owner];
89   }
90 
91 }
92 
93 /**
94  * @title Standard ERC20 token
95  *
96  * @dev Implementation of the basic standard token.
97  * @dev https://github.com/ethereum/EIPs/issues/20
98  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
99  */
100 contract StandardToken is ERC20, BasicToken {
101 
102   mapping (address => mapping (address => uint256)) internal allowed;
103 
104 
105   /**
106    * @dev Transfer tokens from one address to another
107    * @param _from address The address which you want to send tokens from
108    * @param _to address The address which you want to transfer to
109    * @param _value uint256 the amount of tokens to be transferred
110    */
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113     require(_value <= balances[_from]);
114     require(_value <= allowed[_from][msg.sender]);
115 
116     balances[_from] = balances[_from].sub(_value);
117     balances[_to] = balances[_to].add(_value);
118     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119     Transfer(_from, _to, _value);
120     return true;
121   }
122 
123   /**
124    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
125    *
126    * Beware that changing an allowance with this method brings the risk that someone may use both the old
127    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
128    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
129    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130    * @param _spender The address which will spend the funds.
131    * @param _value The amount of tokens to be spent.
132    */
133   function approve(address _spender, uint256 _value) public returns (bool) {
134     allowed[msg.sender][_spender] = _value;
135     Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint256 specifying the amount of tokens still available for the spender.
144    */
145   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
146     return allowed[_owner][_spender];
147   }
148 
149   /**
150    * approve should be called when allowed[_spender] == 0. To increment
151    * allowed value is better to use this function to avoid 2 calls (and wait until
152    * the first transaction is mined)
153    * From MonolithDAO Token.sol
154    */
155   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
156     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
157     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
158     return true;
159   }
160 
161   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
162     uint oldValue = allowed[msg.sender][_spender];
163     if (_subtractedValue > oldValue) {
164       allowed[msg.sender][_spender] = 0;
165     } else {
166       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
167     }
168     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171 
172 }
173 
174 /*
175  * Ownable
176  *
177  * Base contract with an owner.
178  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
179  */
180 contract Ownable {
181   address public owner;
182 
183   function Ownable() {
184     owner = msg.sender;
185   }
186 
187   modifier onlyOwner() {
188     assert(msg.sender == owner);
189     _;
190   }
191 
192   function transferOwnership(address newOwner) onlyOwner {
193     if (newOwner != address(0)) {
194       owner = newOwner;
195     }
196   }
197 
198 }
199 
200 contract Haltable is Ownable {
201   bool public halted;
202 
203   modifier stopInEmergency {
204     assert(!halted);
205     _;
206   }
207 
208   modifier onlyInEmergency {
209     assert(halted);
210     _;
211   }
212 
213   // called by the owner on emergency, triggers stopped state
214   function halt() external onlyOwner {
215     halted = true;
216   }
217 
218   // called by the owner on end of emergency, returns to normal state
219   function unhalt() external onlyOwner onlyInEmergency {
220     halted = false;
221   }
222 
223 }
224 
225 
226 contract YobiToken is StandardToken, Haltable {
227 
228     string public name;
229     string public symbol;
230     uint8 public decimals;
231     uint256 public totalSupply;
232 
233 
234     // Function to access name of token .
235     function name() constant returns (string _name) {
236         return name;
237     }
238     // Function to access symbol of token .
239     function symbol() constant returns (string _symbol) {
240         return symbol;
241     }
242     // Function to access decimals of token .
243     function decimals() constant returns (uint8 _decimals) {
244         return decimals;
245     }
246     // Function to access total supply of tokens .
247     function totalSupply() constant returns (uint256 _totalSupply) {
248         return totalSupply;
249     }
250 
251     address public beneficiary1;
252     address public beneficiary2;
253     event Buy(address indexed participant, uint tokens, uint eth);
254     event GoalReached(uint amountRaised);
255 
256     uint public softCap = 50000000000000;
257     uint public hardCap = 100000000000000;
258     bool public softCapReached = false;
259     bool public hardCapReached = false;
260 
261     uint public price;
262     uint public collectedTokens;
263     uint public collectedEthers;
264 
265     uint public tokensSold = 0;
266     uint public weiRaised = 0;
267     uint public investorCount = 0;
268 
269     uint public startTime;
270     uint public endTime;
271 
272   /**
273    * @dev Contructor that gives msg.sender all of existing tokens.
274    */
275     function YobiToken() {
276 
277         name = "yobi";
278         symbol = "YOB";
279         decimals = 8;
280         totalSupply = 10000000000000000;
281 
282         beneficiary1 = 0x2cC988E5A0D8d0163a241F68Fe35Bc97E0923e72;
283         beneficiary2 = 0xF5A4DEb2a685F5D3f859Df6A771CC4CC4f3c3435;
284 
285         balances[beneficiary1] = totalSupply;
286 
287         price = 600;
288         startTime = 1509426000;
289         endTime = startTime + 3 weeks;
290 
291     }
292 
293     event Burn(address indexed burner, uint256 value);
294 
295     /**
296      * @dev Burns a specific amount of tokens.
297      * @param _value The amount of token to be burned.
298      */
299     function burn(uint256 _value) onlyOwner public {
300         require(_value > 0);
301         require(_value <= balances[msg.sender]);
302         // no need to require value <= totalSupply, since that would imply the
303         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
304 
305         address burner = msg.sender;
306         balances[burner] = balances[burner].sub(_value);
307         totalSupply = totalSupply.sub(_value);
308         Burn(burner, _value);
309     }
310 
311     modifier onlyAfter(uint time) {
312         assert(now >= time);
313         _;
314     }
315 
316     modifier onlyBefore(uint time) {
317         assert(now <= time);
318         _;
319     }
320 
321     function () payable stopInEmergency {
322         doPurchase();
323     }
324 
325     function doPurchase() private onlyAfter(startTime) onlyBefore(endTime) {
326 
327         assert(!hardCapReached);
328 
329         uint tokens = msg.value * price / 10000000000;
330 
331         if (balanceOf(msg.sender) == 0) investorCount++;
332 
333         balances[beneficiary1] = balances[beneficiary1].sub(tokens);
334         balances[msg.sender] = balances[msg.sender].add(tokens);
335 
336         collectedTokens = collectedTokens.add(tokens);
337         collectedEthers = collectedEthers.add(msg.value);
338 
339         if (collectedTokens >= softCap) {
340             softCapReached = true;
341         }
342 
343         if (collectedTokens >= hardCap) {
344             hardCapReached = true;
345         }
346 
347         weiRaised = weiRaised.add(msg.value);
348         tokensSold = tokensSold.add(tokens);
349 
350         Transfer(beneficiary1, msg.sender, tokens);
351 
352         Buy(msg.sender, tokens, msg.value);
353 
354     }
355 
356     function withdraw() returns (bool) {
357         assert((now >= endTime) || softCapReached);
358         assert((msg.sender == beneficiary1) || (msg.sender == beneficiary2));
359         if (!beneficiary1.send(collectedEthers * 99 / 100)) {
360             return false;
361         }
362         if (!beneficiary2.send(collectedEthers / 100)) {
363             return false;
364         }
365         return true;
366     }
367 
368 
369 }
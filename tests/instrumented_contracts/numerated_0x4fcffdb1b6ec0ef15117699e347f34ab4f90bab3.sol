1 pragma solidity ^0.4.22;
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
40   function balanceOf(address who) constant returns (uint256);
41   function transfer(address to, uint256 value) returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender) constant returns (uint256);
51   function transferFrom(address from, address to, uint256 value) returns (bool);
52   function approve(address spender, uint256 value) returns (bool);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances. 
59  */
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   /**
66   * @dev transfer token for a specified address
67   * @param _to The address to transfer to.
68   * @param _value The amount to be transferred.
69   */
70   function transfer(address _to, uint256 _value) returns (bool) {
71     balances[msg.sender] = balances[msg.sender].sub(_value);
72     balances[_to] = balances[_to].add(_value);
73     Transfer(msg.sender, _to, _value);
74     return true;
75   }
76 
77   /**
78   * @dev Gets the balance of the specified address.
79   * @param _owner The address to query the the balance of. 
80   * @return An uint256 representing the amount owned by the passed address.
81   */
82   function balanceOf(address _owner) constant returns (uint256 balance) {
83     return balances[_owner];
84   }
85 
86 }
87 
88 /**
89  * @title Standard ERC20 token
90  *
91  * @dev Implementation of the basic standard token.
92  * @dev https://github.com/ethereum/EIPs/issues/20
93  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
94  */
95 contract StandardToken is ERC20, BasicToken {
96 
97   mapping (address => mapping (address => uint256)) allowed;
98 
99 
100   /**
101    * @dev Transfer tokens from one address to another
102    * @param _from address The address which you want to send tokens from
103    * @param _to address The address which you want to transfer to
104    * @param _value uint256 the amout of tokens to be transfered
105    */
106   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
107     var _allowance = allowed[_from][msg.sender];
108 
109     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
110     // require (_value <= _allowance);
111 
112     balances[_to] = balances[_to].add(_value);
113     balances[_from] = balances[_from].sub(_value);
114     allowed[_from][msg.sender] = _allowance.sub(_value);
115     Transfer(_from, _to, _value);
116     return true;
117   }
118 
119   /**
120    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
121    * @param _spender The address which will spend the funds.
122    * @param _value The amount of tokens to be spent.
123    */
124   function approve(address _spender, uint256 _value) returns (bool) {
125 
126     // To change the approve amount you first have to reduce the addresses`
127     //  allowance to zero by calling `approve(_spender, 0)` if it is not
128     //  already 0 to mitigate the race condition described here:
129     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
131 
132     allowed[msg.sender][_spender] = _value;
133     Approval(msg.sender, _spender, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Function to check the amount of tokens that an owner allowed to a spender.
139    * @param _owner address The address which owns the funds.
140    * @param _spender address The address which will spend the funds.
141    * @return A uint256 specifing the amount of tokens still avaible for the spender.
142    */
143   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
144     return allowed[_owner][_spender];
145   }
146 
147 }
148 
149 contract DBXTTest2 is StandardToken {
150   using SafeMath for uint256;
151 
152   string public name = "DBXTTest2";
153   string public symbol = "DBXTTest2";
154   uint256 public decimals = 18;
155   uint256 public INITIAL_SUPPLY = 20000000 * 1 ether;
156 
157   event Burn(address indexed from, uint256 value);
158 
159   function DBXTTest2() {
160     totalSupply = INITIAL_SUPPLY;
161     balances[msg.sender] = INITIAL_SUPPLY;
162   }
163 
164   function burn(uint256 _value) returns (bool success) {
165     require(balances[msg.sender] >= _value);
166     balances[msg.sender] = balances[msg.sender].sub(_value);
167     totalSupply = totalSupply.sub(_value);
168     Burn(msg.sender, _value);
169     return true;
170   }
171 }
172 
173 /**
174  * @title Ownable
175  * @dev The Ownable contract has an owner address, and provides basic authorization control
176  * functions, this simplifies the implementation of "user permissions".
177  */
178 contract Ownable {
179   address public owner;
180 
181 
182   /**
183    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
184    * account.
185    */
186   function Ownable() {
187     owner = msg.sender;
188   }
189 
190 
191   /**
192    * @dev Throws if called by any account other than the owner.
193    */
194   modifier onlyOwner() {
195     require(msg.sender == owner);
196     _;
197   }
198 
199 
200   /**
201    * @dev Allows the current owner to transfer control of the contract to a newOwner.
202    * @param newOwner The address to transfer ownership to.
203    */
204   function transferOwnership(address newOwner) onlyOwner {
205     if (newOwner != address(0)) {
206       owner = newOwner;
207     }
208   }
209 
210 }
211 
212 contract DBXTTest2ICO is Ownable {
213     using SafeMath for uint256;
214 
215     string public name = "DBXTTest2ICO";
216 
217     DBXTTest2 public DT;
218     address public beneficiary;
219 
220     uint256 public priceETH;
221     uint256 public priceDT;
222 
223     uint256 public weiRaised = 0;
224     uint256 public investorCount = 0;
225 
226     uint public startTime;
227     uint public endTime;
228 
229     bool public crowdsaleFinished = false;
230 
231     event GoalReached(uint amountRaised);
232     event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
233 
234     modifier onlyAfter(uint time) {
235         require(now > time);
236         _;
237     }
238 
239     modifier onlyBefore(uint time) {
240         require(now < time);
241         _;
242     }
243 
244     function DBXTTest2ICO (
245         address _dtAddr,
246         address _beneficiary,
247         uint256 _priceETH,
248         uint256 _priceDT,
249 
250         uint _startTime,
251         uint _duration
252     ) {
253         DT = DBXTTest2(_dtAddr);
254         beneficiary = _beneficiary;
255         priceETH = _priceETH;
256         priceDT = _priceDT;
257 
258         startTime = _startTime;
259         endTime = _startTime + _duration * 1 weeks;
260     }
261 
262     function () payable {
263         require(msg.value >= 0.01 * 1 ether);
264         doPurchase(msg.sender, msg.value);
265     }
266 
267     function withdraw(uint256 _value) onlyOwner {
268         beneficiary.transfer(_value);
269     }
270 
271     function finishCrowdsale() onlyOwner {
272         DT.transfer(beneficiary, DT.balanceOf(this));
273         crowdsaleFinished = true;
274     }
275 
276     function doPurchase(address _sender, uint256 _value) private onlyAfter(startTime) onlyBefore(endTime) {
277         
278         require(!crowdsaleFinished);
279 
280         uint256 dtCount = _value.mul(priceDT).div(priceETH);
281 
282         require(DT.balanceOf(this) >= dtCount);
283 
284         if (DT.balanceOf(_sender) == 0) investorCount++;
285 
286         DT.transfer(_sender, dtCount);
287 
288         weiRaised = weiRaised.add(_value);
289 
290         NewContribution(_sender, dtCount, _value);
291 
292         if (DT.balanceOf(this) == 0) {
293             GoalReached(weiRaised);
294         }
295     }
296 }
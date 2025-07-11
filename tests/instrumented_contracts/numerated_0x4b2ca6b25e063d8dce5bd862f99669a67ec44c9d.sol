1 pragma solidity 0.4.19;
2 
3 contract ERC20Interface {
4     function totalSupply() constant public returns (uint256 total);
5 
6     function balanceOf(address _who) constant public returns (uint256 balance);
7 
8     function transfer(address _to, uint256 _value) public returns (bool success);
9 
10     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
11 
12     function approve(address _spender, uint256 _value) public returns (bool success);
13 
14     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
15 
16     event Transfer(address indexed _from, address indexed _to, uint256 _value);
17 
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 }
20 
21 contract BitandPay is ERC20Interface {
22     using SafeMath for uint256;
23 
24     string public name = "BitandPay";
25     string public symbol = "BNP";
26     uint256 public totalSupply = 250000000;
27 
28     uint8 public decimals = 0; // from 0 to 18
29 
30     address public owner;
31     mapping(address => uint256) balances;
32     mapping(address => mapping (address => uint256)) allowed;
33 
34     uint256 public startTime = 1513296000; // 15 dec 2017 00.00.00
35     uint256 public endTime = 1518739199; // 15 feb 2018 23.59.59 UNIX timestamp
36     // 31 march 2018 23.59.59 - 1522540799
37 
38     uint256 public price = 1428571428571400 wei; // price in wei, 1 bnp = 0,0014285714285714, 1 eth = 700 bnp
39 
40     uint256 public weiRaised;
41 
42     bool public paused = false;
43 
44     uint256 reclaimAmount;
45 
46     /**
47      * @notice Cap is a max amount of funds raised in wei. 1 Ether = 10**18 wei.
48      */
49     uint256 public cap = 1000000 ether;
50 
51     modifier whenNotPaused() {
52         require(!paused);
53         _;
54     }
55 
56     modifier whenPaused() {
57         require(paused);
58         _;
59     }
60 
61     modifier onlyOwner() {
62         require(msg.sender == owner);
63         _;
64     }
65 
66     function BitandPay() public {
67         owner = msg.sender;
68         balances[owner] = 250000000;
69         Transfer(0x0, owner, 250000000);
70     }
71 
72     function totalSupply() constant public returns (uint256 total) {
73         return totalSupply;
74     }
75 
76     function balanceOf(address _who) constant public  returns (uint256 balance) {
77         return balances[_who];
78     }
79 
80     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool success) {
81         require(_to != address(0));
82 
83         balances[msg.sender] = balances[msg.sender].sub(_value);
84         balances[_to] = balances[_to].add(_value);
85         Transfer(msg.sender, _to, _value);
86         return true;
87     }
88 
89     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool success) {
90         require(_to != address(0));
91 
92         var _allowance = allowed[_from][msg.sender];
93 
94         balances[_from] = balances[_from].sub(_value);
95         balances[_to] = balances[_to].add(_value);
96         allowed[_from][msg.sender] = _allowance.sub(_value);
97         Transfer(_from, _to, _value);
98         return true;
99     }
100 
101     function approve(address _spender, uint256 _value) whenNotPaused public returns (bool success) {
102         // To change the approve amount you first have to reduce the addresses`
103         //  allowance to zero by calling `approve(_spender, 0)` if it is not
104         //  already 0 to mitigate the race condition described here:
105         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
106         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
107 
108         allowed[msg.sender][_spender] = _value;
109         Approval(msg.sender, _spender, _value);
110         return true;
111     }
112 
113     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
114         return allowed[_owner][_spender];
115     }
116 
117     function increaseApproval (address _spender, uint _addedValue) whenNotPaused public
118     returns (bool success) {
119         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
120         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
121         return true;
122     }
123 
124     function decreaseApproval (address _spender, uint _subtractedValue) whenNotPaused public
125     returns (bool success) {
126         uint oldValue = allowed[msg.sender][_spender];
127         if (_subtractedValue > oldValue) {
128             allowed[msg.sender][_spender] = 0;
129         } else {
130             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
131         }
132         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
133         return true;
134     }
135 
136     event Mint(address indexed to, uint256 amount);
137 
138     function mint(address _to, uint256 _amount) onlyOwner public returns (bool success) {
139         totalSupply = totalSupply.add(_amount);
140         balances[_to] = balances[_to].add(_amount);
141         Mint(_to, _amount);
142         Transfer(0x0, _to, _amount);
143         return true;
144     }
145 
146     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
147 
148     function () payable public {
149         buyTokens(msg.sender);
150     }
151 
152     function buyTokens(address purchaser) payable whenNotPaused public {
153         require(validPurchase());
154 
155         uint256 weiAmount = msg.value;
156 
157         // calculate token amount to be created
158         uint256 tokens = weiAmount.mul(price);
159         require(balances[this] > tokens);
160 
161         // update state
162         weiRaised = weiRaised.add(weiAmount);
163 
164         balances[purchaser] = balances[purchaser].add(tokens);  // adds the amount to buyer's balance
165         balances[this] = balances[this].sub(tokens);            // subtracts amount from seller's balance
166         Transfer(this, purchaser, tokens);                      // execute an event reflecting the change
167         TokenPurchase(purchaser, weiAmount, tokens);
168     }
169 
170     function validPurchase() internal constant returns (bool) {
171         bool withinPeriod = now >= startTime && now <= endTime;
172         bool nonZeroPurchase = msg.value != 0;
173         bool withinCap = weiRaised.add(msg.value) <= cap;
174         return withinPeriod && nonZeroPurchase && withinCap;
175     }
176 
177     function hasEnded() public constant returns (bool) {
178         bool capReached = weiRaised >= cap;
179         return now > endTime || capReached;
180     }
181 
182     function changeCap(uint256 _cap) onlyOwner public {
183         require(_cap > 0);
184         cap = _cap;
185     }
186 
187     event Price(uint256 value);
188 
189     function changePrice(uint256 _price) onlyOwner public {
190         price = _price;
191         Price(price);
192     }
193 
194     event Pause();
195 
196     function pause() onlyOwner whenNotPaused public {
197         paused = true;
198         Pause();
199     }
200 
201     event Unpause();
202 
203     function unpause() onlyOwner whenPaused public {
204         paused = false;
205         Unpause();
206     }
207 
208     function destroy() onlyOwner public {
209         selfdestruct(owner);
210     }
211 
212     function destroyAndSend(address _recipient) onlyOwner public {
213         selfdestruct(_recipient);
214     }
215 
216     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
217 
218     function transferOwnership(address newOwner) onlyOwner public {
219        	owner = newOwner;
220         OwnershipTransferred(owner, newOwner);
221     }
222 
223     function reclaimToken(ERC20Interface token) external onlyOwner {
224         reclaimAmount = token.balanceOf(this);
225         token.transfer(owner, reclaimAmount);
226         reclaimAmount = 0;
227     }
228 
229     function withdrawToOwner(uint256 _amount) onlyOwner public {
230         require(this.balance >= _amount);
231         owner.transfer(_amount);
232     }
233 
234     function withdrawToAdress(address _to, uint256 _amount) onlyOwner public {
235         require(_to != address(0));
236         require(this.balance >= _amount);
237         _to.transfer(_amount);
238     }
239 }
240 
241 library SafeMath {
242     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
243         uint256 c = a * b;
244         assert(a == 0 || c / a == b);
245         return c;
246     }
247 
248     function div(uint256 a, uint256 b) internal pure returns (uint256) {
249         // assert(b > 0); // Solidity automatically throws when dividing by 0
250         uint256 c = a / b;
251         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
252         return c;
253     }
254 
255     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
256         assert(b <= a);
257         return a - b;
258     }
259 
260     function add(uint256 a, uint256 b) internal pure returns (uint256) {
261         uint256 c = a + b;
262         assert(c >= a);
263         return c;
264     }
265 }
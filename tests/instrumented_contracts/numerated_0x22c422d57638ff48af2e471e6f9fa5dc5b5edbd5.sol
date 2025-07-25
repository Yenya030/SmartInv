1 pragma solidity ^0.4.16;
2 
3 contract SafeMath {
4     function safeMul(uint a, uint b) pure internal returns (uint) {
5         uint c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function safeSub(uint a, uint b) pure internal returns (uint) {
11         assert(b <= a);
12         return a - b;
13     }
14 
15     function safeAdd(uint a, uint b) pure internal returns (uint) {
16         uint c = a + b;
17         assert(c >= a && c >= b);
18         return c;
19     }
20 }
21 
22 contract owned {
23     address public owner;
24 
25     function owned() public {
26         owner = msg.sender;
27     }
28 
29     modifier onlyOwner {
30         require(msg.sender == owner);
31         _;
32     }
33 
34     function transferOwnership(address newOwner) onlyOwner public {
35         owner = newOwner;
36     }
37 }
38 
39 contract CONEGTY is owned, SafeMath {
40 
41     string public name;
42     string public symbol;
43     uint public decimals = 8;
44     uint public totalSupply;
45 
46     mapping (address => uint) public balanceOf;
47     mapping (address => mapping (address => uint)) public allowance;
48     mapping (address => uint) public lockInfo;
49 
50     uint constant valueTotal = 20 * 10000 * 10000 * 10 ** 8;
51     uint constant valueSale = valueTotal / 100 * 15;  // sell 15%
52     uint constant valueTeam = valueTotal / 100 * 85;   // other 85%
53 
54     uint public minEth = 0.1 ether;
55 
56     uint public maxEth = 1000 ether;
57 
58 	uint256 public buyPrice = 5000;	//Purchase price
59     uint256 public sellPrice = 1;	//The price /10000
60     
61     bool public buyTradeConfir = false;	//buy
62     bool public sellTradeConfir = false;	//sell
63     
64     uint public saleQuantity = 0;
65 
66     uint public ethQuantity = 0;
67 
68     modifier validAddress(address _address) {
69         assert(0x0 != _address);
70         _;
71     }
72 
73     modifier validEth {
74         assert(msg.value >= minEth && msg.value <= maxEth);
75         _;
76     }
77 
78     modifier validPeriod {
79         assert(buyTradeConfir);
80         _;
81     }
82 
83     modifier validQuantity {
84         assert(valueSale >= saleQuantity);
85         _;
86     }
87 
88 
89     function CONEGTY() public
90     {
91     	totalSupply = valueTotal;
92     	//buy
93     	balanceOf[this] = valueSale;
94         Transfer(0x0, this, valueSale);
95         // owner
96         balanceOf[msg.sender] = valueTeam;
97         Transfer(0x0, msg.sender, valueTeam);
98     	name = 'EgtyChain';
99     	symbol = 'EGTY'; 
100     }
101 
102     function transfer(address _to, uint _value) public validAddress(_to) returns (bool success)
103     {
104         require(balanceOf[msg.sender] >= _value);
105         require(balanceOf[_to] + _value >= balanceOf[_to]);
106         require(validTransfer(msg.sender, _value));
107         balanceOf[msg.sender] -= _value;
108         balanceOf[_to] += _value;
109         Transfer(msg.sender, _to, _value);
110         return true;
111     }
112 
113     function transferInner(address _to, uint _value) private returns (bool success)
114     {
115         balanceOf[this] -= _value;
116         balanceOf[_to] += _value;
117         Transfer(this, _to, _value);
118         return true;
119     }
120 
121 
122     function transferFrom(address _from, address _to, uint _value) public validAddress(_from) validAddress(_to) returns (bool success)
123     {
124         require(balanceOf[_from] >= _value);
125         require(balanceOf[_to] + _value >= balanceOf[_to]);
126         require(allowance[_from][msg.sender] >= _value);
127         require(validTransfer(_from, _value));
128         balanceOf[_to] += _value;
129         balanceOf[_from] -= _value;
130         allowance[_from][msg.sender] -= _value;
131         Transfer(_from, _to, _value);
132         return true;
133     }
134 
135     function approve(address _spender, uint _value) public validAddress(_spender) returns (bool success)
136     {
137         require(_value == 0 || allowance[msg.sender][_spender] == 0);
138         allowance[msg.sender][_spender] = _value;
139         Approval(msg.sender, _spender, _value);
140         return true;
141     }
142 
143     function lock(address _to, uint _value) private validAddress(_to)
144     {
145         require(_value > 0);
146         require(lockInfo[_to] + _value <= balanceOf[_to]);
147         lockInfo[_to] += _value;
148     }
149 
150     function validTransfer(address _from, uint _value) private constant returns (bool)
151     {
152         if (_value == 0)
153             return false;
154 
155         return lockInfo[_from] + _value <= balanceOf[_from];
156     }
157 
158 
159     function () public payable
160     {
161         buy();
162     }
163 
164     function buy() public payable validEth validPeriod validQuantity
165     {
166         uint eth = msg.value;
167 
168         uint quantity = eth * buyPrice / 10 ** 10;
169 
170         uint leftQuantity = safeSub(valueSale, saleQuantity);
171         if (quantity > leftQuantity) {
172             quantity = leftQuantity;
173         }
174 
175         saleQuantity = safeAdd(saleQuantity, quantity);
176         ethQuantity = safeAdd(ethQuantity, eth);
177 
178         require(transferInner(msg.sender, quantity));
179 
180         lock(msg.sender, quantity);
181 
182         Buy(msg.sender, eth, quantity);
183 
184     }
185 
186     function sell(uint256 amount) public {
187 		if(sellTradeConfir){
188 			require(this.balance >= amount * sellPrice / 10000);
189 			transferFrom(msg.sender, this, amount);
190 			msg.sender.transfer(amount * sellPrice / 10000);
191 		}
192     }
193     
194     function burn(uint256 _value) public returns (bool success) {
195         require(balanceOf[msg.sender] >= _value);
196         balanceOf[msg.sender] -= _value;
197         totalSupply -= _value;
198         Burn(msg.sender, _value);
199         return true;
200     }
201     
202     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
203         sellPrice = newSellPrice;
204         buyPrice = newBuyPrice;
205     }
206     
207     function starBuy() public onlyOwner returns (bool)
208 	{
209 	    buyTradeConfir = true;
210 	    StarBuy();
211 	    return true;
212 	}
213     
214     function stopBuy() public onlyOwner returns (bool)
215     {
216         buyTradeConfir = false;
217         StopBuy();
218         return true;
219     }
220     
221     function starSell() public onlyOwner returns (bool)
222 	{
223 	    sellTradeConfir = true;
224 	    StarSell();
225 	    return true;
226 	}
227     
228     function stopSell() public onlyOwner returns (bool)
229 	{
230 	    sellTradeConfir = false;
231 	    StopSell();
232 	    return true;
233 	}
234 
235     event Transfer(address indexed _from, address indexed _to, uint _value);
236     event Approval(address indexed _owner, address indexed _spender, uint _value);
237 
238     event Buy(address indexed sender, uint eth, uint token);
239     event Burn(address indexed from, uint256 value);
240     event StopSell();
241     event StopBuy();
242     event StarSell();
243     event StarBuy();
244 }
1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         if (a == 0) {
6             return 0;
7         }
8         c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         return a / b;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23         c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract Ownable {
30     address public owner;
31 
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     constructor() public {
35         owner = msg.sender;
36     }
37 
38     modifier onlyOwner() {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     function transferOwnership(address newOwner) public onlyOwner {
44         require(newOwner != address(0));
45         emit OwnershipTransferred(owner, newOwner);
46         owner = newOwner;
47     }
48 }
49 
50 contract Pausable is Ownable {
51     event Pause();
52     event Unpause();
53 
54     bool public paused = false;
55 
56     modifier whenNotPaused() {
57         require(!paused);
58         _;
59     }
60 
61     modifier whenPaused() {
62         require(paused);
63         _;
64     }
65 
66     function pause() onlyOwner whenNotPaused public {
67         paused = true;
68         emit Pause();
69     }
70 
71     function unpause() onlyOwner whenPaused public {
72         paused = false;
73         emit Unpause();
74     }
75 }
76 
77 contract ERC20Basic {
78     function totalSupply() public view returns (uint256);
79     function balanceOf(address who) public view returns (uint256);
80     function transfer(address to, uint256 value) public returns (bool);
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 }
83 
84 contract ERC20 is ERC20Basic {
85     function allowance(address owner, address spender) public view returns (uint256);
86     function transferFrom(address from, address to, uint256 value) public returns (bool);
87     function approve(address spender, uint256 value) public returns (bool);
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 contract BasicToken is ERC20Basic {
92     using SafeMath for uint256;
93 
94     mapping(address => uint256) balances;
95 
96     uint256 totalSupply_;
97 
98     function totalSupply() public view returns (uint256) {
99         return totalSupply_;
100     }
101 
102     function transfer(address _to, uint256 _value) public returns (bool) {
103         require(_to != address(0));
104         require(_value <= balances[msg.sender]);
105 
106         balances[msg.sender] = balances[msg.sender].sub(_value);
107         balances[_to] = balances[_to].add(_value);
108         emit Transfer(msg.sender, _to, _value);
109         return true;
110     }
111 
112     function balanceOf(address _owner) public view returns (uint256) {
113         return balances[_owner];
114     }
115 
116 }
117 
118 contract StandardToken is ERC20, BasicToken {
119 
120     mapping (address => mapping (address => uint256)) internal allowed;
121 
122 
123     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
124         require(_to != address(0));
125         require(_value <= balances[_from]);
126         require(_value <= allowed[_from][msg.sender]);
127 
128         balances[_from] = balances[_from].sub(_value);
129         balances[_to] = balances[_to].add(_value);
130         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
131         emit Transfer(_from, _to, _value);
132         return true;
133     }
134 
135 
136     function approve(address _spender, uint256 _value) public returns (bool) {
137         allowed[msg.sender][_spender] = _value;
138         emit Approval(msg.sender, _spender, _value);
139         return true;
140     }
141 
142     function allowance(address _owner, address _spender) public view returns (uint256) {
143         return allowed[_owner][_spender];
144     }
145 
146     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
147         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
148         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149         return true;
150     }
151 
152 
153     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
154         uint oldValue = allowed[msg.sender][_spender];
155         if (_subtractedValue > oldValue) {
156             allowed[msg.sender][_spender] = 0;
157         } else {
158             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
159         }
160         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161         return true;
162     }
163 
164 }
165 
166 contract PausableToken is StandardToken, Pausable {
167 
168     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
169         return super.transfer(_to, _value);
170     }
171 
172     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
173         return super.transferFrom(_from, _to, _value);
174     }
175 
176     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
177         return super.approve(_spender, _value);
178     }
179 
180     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
181         return super.increaseApproval(_spender, _addedValue);
182     }
183 
184     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
185         return super.decreaseApproval(_spender, _subtractedValue);
186     }
187 }
188 
189 contract ALTIXToken is PausableToken {
190     using SafeMath for uint256;
191     struct VaultInfo {
192         uint256 amount;
193         uint256 acquiredTime;
194     }
195     string public name = "ALTIX City Token";
196     string public symbol = "ALT";
197     uint256 public decimals = 0;
198     uint256 public constant Factor = 1000;
199     uint256 public constant INITIAL_SUPPLY = 1187 * Factor;//
200     mapping(address => VaultInfo) public vaults;
201     uint256 public circulatingSupply = 0;
202     uint256 public tokensInVaults;
203     bool public activated_;
204 
205     event Acquired(address indexed to, uint256 amount);
206     event Activated(address indexed who);
207 
208     constructor() public {
209         totalSupply_ = INITIAL_SUPPLY;
210     }
211 
212     modifier isActivated() {
213         require(activated_ == true, "its not ready yet.");
214         _;
215     }
216 
217     modifier lessThanTotalSupply(uint256[] _amountOfLands) {
218         uint256 totalAmount = 0;
219         for (uint256 i; i < _amountOfLands.length; i++) {
220             uint256 amount = _amountOfLands[i].mul(Factor);
221             totalAmount = totalAmount.add(amount);
222         }
223         require(totalAmount.add(tokensInVaults) <= totalSupply_, 'can not exceed total supply.');
224         _;
225     }
226 
227     function setVault(address[] holders, uint256[] amountOfLands) public onlyOwner lessThanTotalSupply(amountOfLands) {
228         uint256 len = holders.length;
229         require(len == amountOfLands.length);
230         for(uint256 i=0; i<len; i++){
231             uint256 _amount = amountOfLands[i].mul(Factor);
232             tokensInVaults = tokensInVaults.sub(vaults[holders[i]].amount);
233             vaults[holders[i]].amount = _amount;
234             tokensInVaults = tokensInVaults.add(_amount);
235         }
236     }
237 
238     function claimToken() public isActivated(){
239         uint256 tokenAmount = vaults[msg.sender].amount;
240         require(tokenAmount > 0);
241 
242         vaults[msg.sender].amount = 0;
243         vaults[msg.sender].acquiredTime = block.timestamp;
244 
245         balances[msg.sender] = tokenAmount;
246         circulatingSupply = circulatingSupply.add(tokenAmount);
247 
248         emit Transfer(address(0), msg.sender, tokenAmount);
249         emit Acquired(msg.sender, tokenAmount);
250     }
251 
252     function activate() public onlyOwner(){
253         require(activated_ == false, "Already activated");
254         activated_ = true;
255         emit Activated(msg.sender);
256     }
257 
258 }
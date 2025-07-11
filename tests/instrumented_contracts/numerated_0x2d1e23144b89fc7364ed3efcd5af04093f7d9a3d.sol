1 pragma solidity > 0.4.99 <0.6.0;
2 
3 interface IERC20Token {
4     function balanceOf(address owner) external returns (uint256);
5     function transfer(address to, uint256 amount) external returns (bool);
6     function burn(uint256 _value) external returns (bool);
7     function decimals() external returns (uint256);
8     function approve(address _spender, uint256 _value) external returns (bool success);
9     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
10 }
11 
12 contract Ownable {
13   address payable public _owner;
14 
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20   /**
21   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22   * account.
23   */
24   constructor() internal {
25     _owner = tx.origin;
26     emit OwnershipTransferred(address(0), _owner);
27   }
28 
29   /**
30   * @return the address of the owner.
31   */
32   function owner() public view returns(address) {
33     return _owner;
34   }
35 
36   /**
37   * @dev Throws if called by any account other than the owner.
38   */
39   modifier onlyOwner() {
40     require(isOwner());
41     _;
42   }
43 
44   /**
45   * @return true if `msg.sender` is the owner of the contract.
46   */
47   function isOwner() public view returns(bool) {
48     return msg.sender == _owner;
49   }
50 
51   /**
52   * @dev Allows the current owner to relinquish control of the contract.
53   * @notice Renouncing to ownership will leave the contract without an owner.
54   * It will not be possible to call the functions with the `onlyOwner`
55   * modifier anymore.
56   */
57   function renounceOwnership() public onlyOwner {
58     emit OwnershipTransferred(_owner, address(0));
59     _owner = address(0);
60   }
61 
62   /**
63   * @dev Allows the current owner to transfer control of the contract to a newOwner.
64   * @param newOwner The address to transfer ownership to.
65   */
66   function transferOwnership(address payable newOwner) public onlyOwner {
67     _transferOwnership(newOwner);
68   }
69 
70   /**
71   * @dev Transfers control of the contract to a newOwner.
72   * @param newOwner The address to transfer ownership to.
73   */
74   function _transferOwnership(address payable newOwner) internal {
75     require(newOwner != address(0));
76     emit OwnershipTransferred(_owner, newOwner);
77     _owner = newOwner;
78   }
79 }
80 
81 /**
82  * @title SafeMath
83  * @dev Math operations with safety checks that throw on error
84  */
85 library SafeMath {
86 
87   /**
88   * @dev Multiplies two numbers, throws on overflow.
89   */
90   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91     if (a == 0) {
92       return 0;
93     }
94     uint256 c = a * b;
95     assert(c / a == b);
96     return c;
97   }
98 
99   /**
100   * @dev Integer division of two numbers, truncating the quotient.
101   */
102   function div(uint256 a, uint256 b) internal pure returns (uint256) {
103     // assert(b > 0); // Solidity automatically throws when dividing by 0
104     uint256 c = a / b;
105     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106     return c;
107   }
108 
109   /**
110   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
111   */
112   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113     assert(b <= a);
114     return a - b;
115   }
116 
117   /**
118   * @dev Adds two numbers, throws on overflow.
119   */
120   function add(uint256 a, uint256 b) internal pure returns (uint256) {
121     uint256 c = a + b;
122     assert(c >= a);
123     return c;
124   }
125 }
126 contract ERC20Interface {
127     
128     string public name;
129     string public symbol;
130     uint8 public decimals;
131     uint public totalSupply;
132     
133 
134     function transfer(address _to, uint256 _value) public returns (bool success);
135     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
136     function approve(address _spender, uint256 _value) public returns (bool success);
137     function allowance(address _owner, address _spender) public returns (uint256 remaining);
138 
139 
140     event Transfer(address indexed _from, address indexed _to, uint256 _value);
141     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
142     
143 }
144 
145 contract ERC20 is ERC20Interface {
146     
147     mapping(address => uint256) public balanceOf;
148     mapping(address => mapping(address => uint256)) allowed;
149     
150 
151     constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalSupply) public {
152        name =  _name;
153        symbol = _symbol;
154        decimals = _decimals;
155        totalSupply = _totalSupply * 10 ** uint256(_decimals);
156        balanceOf[tx.origin] = totalSupply;
157     }
158 
159     function transfer(address _to, uint256 _value) public returns (bool success){
160         require(_to != address(0));
161         require(balanceOf[msg.sender] >= _value);
162         require(balanceOf[ _to] + _value >= balanceOf[ _to]); 
163 
164         balanceOf[msg.sender] -= _value;
165         balanceOf[_to] += _value;
166 
167         emit Transfer(msg.sender, _to, _value);
168 
169         return true;
170     }
171     
172     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
173         require(_to != address(0));
174         require(allowed[msg.sender][_from] >= _value);
175         require(balanceOf[_from] >= _value);
176         require(balanceOf[ _to] + _value >= balanceOf[ _to]);
177 
178         balanceOf[_from] -= _value;
179         balanceOf[_to] += _value;
180 
181         allowed[msg.sender][_from] -= _value;
182 
183         emit Transfer(msg.sender, _to, _value);
184         return true;
185     }
186     
187     function approve(address _spender, uint256 _value) public returns (bool success){
188         allowed[msg.sender][_spender] = _value;
189 
190         emit Approval(msg.sender, _spender, _value);
191         return true;
192     }
193     
194     function allowance(address _owner, address _spender) public returns (uint256 remaining){
195          return allowed[_owner][_spender];
196     }
197 
198 }
199 
200 contract ERC20Token is ERC20, Ownable {
201 
202     string public constant createdBy = "AssetSplit.org - the guys who cut the pizza";
203 
204     event AddSupply(uint amount);
205     event Burn(address target, uint amount);
206     event Sold(address buyer, uint256 amount);
207     
208     constructor (string memory _name, string memory _symbol, uint8 _decimals, uint _totalSupply) 
209         ERC20(_name, _symbol, _decimals, _totalSupply) public {
210         }
211    
212     function transfer(address _to, uint256 _value) public returns (bool success) {
213         success = _transfer(msg.sender, _to, _value);
214     }
215 
216     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
217         require(allowed[_from][msg.sender] >= _value);
218         success =  _transfer(_from, _to, _value);
219         allowed[_from][msg.sender]  -= _value;
220     }
221 
222     function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
223       require(_to != address(0));
224 
225       require(balanceOf[_from] >= _value);
226       require(balanceOf[ _to] + _value >= balanceOf[ _to]);
227 
228       balanceOf[_from] -= _value;
229       balanceOf[_to] += _value;
230 
231    
232       emit Transfer(_from, _to, _value);
233       return true;
234     }
235 
236     function burn(uint256 _value) public returns (bool success) {
237        require(balanceOf[msg.sender] >= _value);
238 
239        totalSupply -= _value; 
240        balanceOf[msg.sender] -= _value;
241 
242        emit Burn(msg.sender, _value);
243        return true;
244     }
245 
246     function burnFrom(address _from, uint256 _value)  public returns (bool success) {
247         require(balanceOf[_from] >= _value);
248         require(allowed[_from][msg.sender] >= _value);
249 
250         totalSupply -= _value; 
251         balanceOf[msg.sender] -= _value;
252         allowed[_from][msg.sender] -= _value;
253 
254         emit Burn(msg.sender, _value);
255         return true;
256     }
257 }
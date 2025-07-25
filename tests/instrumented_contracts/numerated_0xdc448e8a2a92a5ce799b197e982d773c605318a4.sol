1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9   function div(uint a, uint b) internal returns (uint) {
10     assert(b > 0);
11     uint c = a / b;
12     assert(a == b * c + a % b);
13     return c;
14   }
15   function sub(uint a, uint b) internal returns (uint) {
16     assert(b <= a);
17     return a - b;
18   }
19   function add(uint a, uint b) internal returns (uint) {
20     uint c = a + b;
21     assert(c >= a);
22     return c;
23   }
24   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
25     return a >= b ? a : b;
26   }
27   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
28     return a < b ? a : b;
29   }
30   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
31     return a >= b ? a : b;
32   }
33   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
34     return a < b ? a : b;
35   }
36   function assert(bool assertion) internal {
37     if (!assertion) {
38       throw;
39     }
40   }
41 }
42 
43 contract Ownable {
44     address public owner;
45     function Ownable() {
46         owner = msg.sender;
47     }
48     modifier onlyOwner {
49         if (msg.sender != owner) throw;
50         _;
51     }
52     function transferOwnership(address newOwner) onlyOwner {
53         if (newOwner != address(0)) {
54             owner = newOwner;
55         }
56     }
57 }
58 
59 contract ERC20Basic {
60   uint public totalSupply;
61   function balanceOf(address who) constant returns (uint);
62   function transfer(address to, uint value);
63   event Transfer(address indexed from, address indexed to, uint value);
64 }
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) constant returns (uint);
67   function transferFrom(address from, address to, uint value);
68   function approve(address spender, uint value);
69   event Approval(address indexed owner, address indexed spender, uint value);
70 }
71 
72 contract newToken is ERC20Basic {
73   
74   using SafeMath for uint;
75   
76   mapping(address => uint) balances;
77   
78 
79   modifier onlyPayloadSize(uint size) {
80      if(msg.data.length < size + 4) {
81        throw;
82      }
83      _;
84   }
85   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
86     balances[msg.sender] = balances[msg.sender].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     Transfer(msg.sender, _to, _value);
89   }
90   function balanceOf(address _owner) constant returns (uint balance) {
91     return balances[_owner];
92   }
93 }
94 
95 contract StandardToken is newToken, ERC20 {
96   mapping (address => mapping (address => uint)) allowed;
97   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
98     var _allowance = allowed[_from][msg.sender];
99     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
100     // if (_value > _allowance) throw;
101     balances[_to] = balances[_to].add(_value);
102     balances[_from] = balances[_from].sub(_value);
103     allowed[_from][msg.sender] = _allowance.sub(_value);
104     Transfer(_from, _to, _value);
105   }
106   function approve(address _spender, uint _value) {
107     // To change the approve amount you first have to reduce the addresses`
108     //  allowance to zero by calling approve(_spender, 0) if it is not
109     //  already 0 to mitigate the race condition described here:
110     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
112     allowed[msg.sender][_spender] = _value;
113     Approval(msg.sender, _spender, _value);
114   }
115   function allowance(address _owner, address _spender) constant returns (uint remaining) {
116     return allowed[_owner][_spender];
117   }
118 }
119 
120  contract BriantToken is StandardToken, Ownable {
121   string public constant name = "Briant New Coin 4";
122   string public constant symbol = "BRI4";
123   uint public constant decimals = 2;
124   mapping (address => uint256) public balanceOf;
125     uint minBalanceForAccounts;
126     
127   // Constructor
128   function Briant2Token() { 
129       balances[msg.sender] = 100000000; 
130   }
131 }
132 
133 contract YESToken is Ownable, BriantToken {
134 
135     /* Initializes contract with initial supply tokens to the creator of the contract */
136    function YESToken() BriantToken () {}
137   mapping (address => mapping (address => uint)) allowed;
138   
139   function transfer(address _to, uint256 _value) {
140         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
141         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
142         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
143         balanceOf[_to] += _value;                            // Add the same to the recipient
144         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
145     }
146   
147 
148   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
149     var _allowance = allowed[_from][msg.sender];
150     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
151     // if (_value > _allowance) throw;
152     balances[_to] = balances[_to].add(_value);
153     balances[_from] = balances[_from].sub(_value);
154     allowed[_from][msg.sender] = _allowance.sub(_value);
155     Transfer(_from, _to, _value);
156   }
157   function approve(address _spender, uint _value) {
158     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
160     allowed[msg.sender][_spender] = _value;
161     Approval(msg.sender, _spender, _value);
162   }
163    function mintToken(address target, uint256 mintedAmount) onlyOwner {
164         balanceOf[target] += mintedAmount;
165         totalSupply += mintedAmount;
166         Transfer(0, this, mintedAmount);
167         Transfer(this, target, mintedAmount);
168     }
169   function allowance(address _owner, address _spender) constant returns (uint remaining) {
170     return allowed[_owner][_spender];
171   }
172 }
1 pragma solidity ^0.4. 21;
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
35  *  ERC20 interface
36  * Illuminati Xtra funds githu
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) constant returns (uint256);
41   function transfer(address to, uint256 value) returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title Basic token
47  * @dev Basic version of StandardToken
48  */
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53 
54   /**
55   * transfer function to enable token transfer for a specified address
56   * gets address _to The address to transfer to.
57   * gets value _value The amount to be transferred.
58   */
59   function transfer(address _to, uint256 _value) returns (bool) {
60     balances[msg.sender] = balances[msg.sender].sub(_value);
61     balances[_to] = balances[_to].add(_value);
62     Transfer(msg.sender, _to, _value);
63     return true;
64   }
65 
66   /**
67   * @dev Gets the balance of the specified address.
68   * @param _owner The address to query the the balance of.
69   * @return An uint256 representing the amount owned by the passed address.
70   */
71   function balanceOf(address _owner) constant returns (uint256 balance) {
72     return balances[_owner];
73   }
74 
75 }
76 
77 /**
78  * @title ERC20 interface
79  */
80 contract ERC20 is ERC20Basic {
81   function allowance(address owner, address spender) constant returns (uint256);
82   function transferFrom(address from, address to, uint256 value) returns (bool);
83   function approve(address spender, uint256 value) returns (bool);
84   event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 /**
88  * @title Standard ERC20 token
89  *
90  * @dev Implementation of the basic standard token.
91  * @dev Illuminati Xtra Funds github
92  */
93 contract StandardToken is ERC20, BasicToken {
94 
95   mapping (address => mapping (address => uint256)) allowed;
96 
97 
98   /**
99    * @dev Transfer tokens from one address to another
100    * @param _from address The address which you want to send tokens from
101    * @param _to address The address which you want to transfer to
102    * @param _value uint256 the amout of tokens to be transfered
103    */
104   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
105     var _allowance = allowed[_from][msg.sender];
106 
107     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
108     // require (_value <= _allowance);
109 
110     balances[_to] = balances[_to].add(_value);
111     balances[_from] = balances[_from].sub(_value);
112     allowed[_from][msg.sender] = _allowance.sub(_value);
113     Transfer(_from, _to, _value);
114     return true;
115   }
116 
117   /**
118    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
119    * @param _spender The address which will spend the funds.
120    * @param _value The amount of tokens to be spent.
121    */
122   function approve(address _spender, uint256 _value) returns (bool) {
123 
124     // To change the approve amount you first have to reduce the addresses`
125     //  allowance to zero by calling `approve(_spender, 0)` if it is not
126     //  already 0 to mitigate the race condition described here:
127     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
128     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
129 
130     allowed[msg.sender][_spender] = _value;
131     Approval(msg.sender, _spender, _value);
132     return true;
133   }
134 
135   /**
136    * @dev Function to check the amount of tokens that an owner allowed to a spender.
137    * @param _owner address The address which owns the funds.
138    * @param _spender address The address which will spend the funds.
139    * @return A uint256 specifing the amount of tokens still available for the spender.
140    */
141   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
142     return allowed[_owner][_spender];
143   }
144 
145 }
146 
147 
148 /**
149  * @title SimpleToken
150  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
151  * Note they can later distribute these tokens as they wish using `transfer` and other
152  * `StandardToken` functions.
153  */
154 contract IlumX is StandardToken {
155 
156   string public constant name = "Illuminati Xtra Funds";
157   string public constant symbol = "IlumX";
158   uint256 public constant decimals = 18;
159 
160   uint256 public constant INITIAL_SUPPLY = 940000000 * 10**18;
161 
162   /**
163    * @dev Contructor that gives msg.sender all of existing tokens.
164    */
165   
166   function IlumXXToken() {
167     totalSupply = INITIAL_SUPPLY;
168     balances[msg.sender] = INITIAL_SUPPLY;
169   }
170 
171 }
1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42     uint256 public totalSupply;
43 
44     function balanceOf(address who) public view returns (uint256);
45 
46     function transfer(address to, uint256 value) public returns (bool);
47 
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 
52 /**
53  * @title ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/20
55  */
56 contract ERC20 is ERC20Basic {
57     function allowance(address owner, address spender) public view returns (uint256);
58 
59     function transferFrom(address from, address to, uint256 value) public returns (bool);
60 
61     function approve(address spender, uint256 value) public returns (bool);
62 
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 contract ShortAddressProtection {
67 
68     modifier onlyPayloadSize(uint256 numwords) {
69         assert(msg.data.length >= numwords * 32 + 4);
70         _;
71     }
72 }
73 
74 /**
75  * @title Basic token
76  * @dev Basic version of StandardToken, with no allowances.
77  */
78 contract BasicToken is ERC20Basic, ShortAddressProtection {
79     using SafeMath for uint256;
80 
81     mapping(address => uint256) internal balances;
82 
83     /**
84     * @dev transfer token for a specified address
85     * @param _to The address to transfer to.
86     * @param _value The amount to be transferred.
87     */
88     function transfer(address _to, uint256 _value) onlyPayloadSize(2) public returns (bool) {
89         require(_to != address(0));
90         require(_value <= balances[msg.sender]);
91 
92         // SafeMath.sub will throw if there is not enough balance.
93         balances[msg.sender] = balances[msg.sender].sub(_value);
94         balances[_to] = balances[_to].add(_value);
95         Transfer(msg.sender, _to, _value);
96         return true;
97     }
98 
99     /**
100     * @dev Gets the balance of the specified address.
101     * @param _owner The address to query the the balance of.
102     * @return An uint256 representing the amount owned by the passed address.
103     */
104     function balanceOf(address _owner) public view returns (uint256 balance) {
105         return balances[_owner];
106     }
107 
108 }
109 
110 /**
111  * @title Standard ERC20 token
112  *
113  * @dev Implementation of the basic standard token.
114  * @dev https://github.com/ethereum/EIPs/issues/20
115  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
116  */
117 contract StandardToken is ERC20, BasicToken {
118 
119     mapping(address => mapping(address => uint256)) internal allowed;
120 
121 
122     /**
123      * @dev Transfer tokens from one address to another
124      * @param _from address The address which you want to send tokens from
125      * @param _to address The address which you want to transfer to
126      * @param _value uint256 the amount of tokens to be transferred
127      */
128     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) public returns (bool) {
129         require(_to != address(0));
130         require(_value <= balances[_from]);
131         require(_value <= allowed[_from][msg.sender]);
132 
133         balances[_from] = balances[_from].sub(_value);
134         balances[_to] = balances[_to].add(_value);
135         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
136         Transfer(_from, _to, _value);
137         return true;
138     }
139 
140     /**
141      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
142      *
143      * Beware that changing an allowance with this method brings the risk that someone may use both the old
144      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
145      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
146      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147      * @param _spender The address which will spend the funds.
148      * @param _value The amount of tokens to be spent.
149      */
150     function approve(address _spender, uint256 _value) onlyPayloadSize(2) public returns (bool) {
151         //require user to set to zero before resetting to nonzero
152         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
153 
154         allowed[msg.sender][_spender] = _value;
155         Approval(msg.sender, _spender, _value);
156         return true;
157     }
158 
159     /**
160      * @dev Function to check the amount of tokens that an owner allowed to a spender.
161      * @param _owner address The address which owns the funds.
162      * @param _spender address The address which will spend the funds.
163      * @return A uint256 specifying the amount of tokens still available for the spender.
164      */
165     function allowance(address _owner, address _spender) public view returns (uint256) {
166         return allowed[_owner][_spender];
167     }
168 
169     /**
170      * @dev Increase the amount of tokens that an owner allowed to a spender.
171      *
172      * approve should be called when allowed[_spender] == 0. To increment
173      * allowed value is better to use this function to avoid 2 calls (and wait until
174      * the first transaction is mined)
175      * From MonolithDAO Token.sol
176      * @param _spender The address which will spend the funds.
177      * @param _addedValue The amount of tokens to increase the allowance by.
178      */
179     function increaseApproval(address _spender, uint _addedValue) onlyPayloadSize(2) public returns (bool) {
180         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
181         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182         return true;
183     }
184 
185     /**
186      * @dev Decrease the amount of tokens that an owner allowed to a spender.
187      *
188      * approve should be called when allowed[_spender] == 0. To decrement
189      * allowed value is better to use this function to avoid 2 calls (and wait until
190      * the first transaction is mined)
191      * From MonolithDAO Token.sol
192      * @param _spender The address which will spend the funds.
193      * @param _subtractedValue The amount of tokens to decrease the allowance by.
194      */
195     function decreaseApproval(address _spender, uint _subtractedValue) onlyPayloadSize(2) public returns (bool) {
196         uint oldValue = allowed[msg.sender][_spender];
197         if (_subtractedValue > oldValue) {
198             allowed[msg.sender][_spender] = 0;
199         } else {
200             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
201         }
202         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203         return true;
204     }
205 }
206 
207 contract Token is StandardToken {
208     string public constant name = "TOKPIE";
209     string public constant symbol = "TKP";
210     uint8 public constant decimals = 18;
211 
212     function Token(address _addr, uint256 value) public {
213         require(value > 0);
214         balances[_addr] = value;
215         Transfer(address(0), _addr, value);
216         totalSupply = value;
217     }
218 }
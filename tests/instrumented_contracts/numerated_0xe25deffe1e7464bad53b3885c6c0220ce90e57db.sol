1 /**
2  *  The Fast Invest token contract
3  *  Compatible with the ERC20 standard (see https://github.com/ethereum/EIPs/issues/20).
4  *
5  *  Based on OpenZeppelin framework.
6  *  https://openzeppelin.org
7  *
8  *  Author: Paulius Tumosa
9  **/
10 
11 pragma solidity ^0.4.18;
12 
13 /**
14  * Safe Math library from OpenZeppelin framework
15  * https://openzeppelin.org
16  *
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22         if (a == 0) {
23             return 0;
24         }
25         uint256 c = a * b;
26         assert(c / a == b);
27         return c;
28     }
29 
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // assert(b > 0); // Solidity automatically throws when dividing by 0
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 contract FastInvestToken {
50     using SafeMath for uint256;
51 
52     address public owner;
53 
54     // Information about the token
55     string public constant standard = "ERC20";
56     string public constant name = "Fast Invest Token";
57     string public constant symbol = "FIT";
58     uint8  public constant decimals = 18;
59 
60     // Total supply of tokens
61     uint256 public totalSupply = 777000000000000000000000000;
62 
63     mapping(address => uint256) balances;
64     mapping(address => mapping (address => uint256)) internal allowed;
65 
66     event Transfer(address indexed from, address indexed to, uint256 value);
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 
69     function FastInvestToken() public {
70         owner = msg.sender;
71         balances[owner] = totalSupply;
72     }
73 
74     /**
75      * @dev Transfer token for a specified address
76      *
77      * @param _to The address to transfer to.
78      * @param _value The amount to be transferred.
79      */
80     function transfer(address _to, uint256 _value) public returns (bool) {
81         require(_to != address(0));
82         require(_value <= balances[msg.sender]);
83 
84         // SafeMath.sub will throw if there is not enough balance.
85         balances[msg.sender] = balances[msg.sender].sub(_value);
86         balances[_to] = balances[_to].add(_value);
87         Transfer(msg.sender, _to, _value);
88         return true;
89     }
90 
91     /**
92      * @dev Gets the balance of the specified address.
93      *
94      * @param _owner The address to query the the balance of.
95      * @return An uint256 representing the amount owned by the passed address.
96      */
97     function balanceOf(address _owner) public view returns (uint256 balance) {
98         return balances[_owner];
99     }
100 
101     /**
102      * @dev Transfer tokens from one address to another
103      *
104      * @param _from address The address which you want to send tokens from
105      * @param _to address The address which you want to transfer to
106      * @param _value uint256 the amount of tokens to be transferred
107      */
108     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
109         require(_to != address(0));
110         require(_value <= balances[_from]);
111         require(_value <= allowed[_from][msg.sender]);
112 
113         balances[_from] = balances[_from].sub(_value);
114         balances[_to] = balances[_to].add(_value);
115         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
116         Transfer(_from, _to, _value);
117         return true;
118     }
119 
120     /**
121     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
122     *
123     * It checks that spender's allowance is set to 0 and set the desired value afterwards:
124     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
125     *
126     * @param _spender The address which will spend the funds.
127     * @param _value The amount of tokens to be spent.
128     */
129     function approve(address _spender, uint256 _value) public returns (bool) {
130         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
131         allowed[msg.sender][_spender] = _value;
132         Approval(msg.sender, _spender, _value);
133         return true;
134     }
135 
136     /**
137      * @dev Function to check the amount of tokens that an owner allowed to a spender.
138      *
139      * @param _owner address The address which owns the funds.
140      * @param _spender address The address which will spend the funds.
141      * @return A uint256 specifying the amount of tokens still available for the spender.
142      */
143     function allowance(address _owner, address _spender) public view returns (uint256) {
144         return allowed[_owner][_spender];
145     }
146 
147 }
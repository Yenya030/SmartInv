1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 
8 /**
9  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
10  *
11  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
12  */
13 
14 
15 
16 
17 
18 
19 
20 /**
21  * @title ERC20Basic
22  * @dev Simpler version of ERC20 interface
23  * @dev see https://github.com/ethereum/EIPs/issues/179
24  */
25 contract ERC20Basic {
26   uint256 public totalSupply;
27   function balanceOf(address who) constant returns (uint256);
28   function transfer(address to, uint256 value) returns (bool);
29   event Transfer(address indexed from, address indexed to, uint256 value);
30 }
31 
32 
33 
34 /**
35  * @title ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/20
37  */
38 contract ERC20 is ERC20Basic {
39   function allowance(address owner, address spender) constant returns (uint256);
40   function transferFrom(address from, address to, uint256 value) returns (bool);
41   function approve(address spender, uint256 value) returns (bool);
42   event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
46 
47 
48 
49 /**
50  * Math operations with safety checks
51  */
52 contract SafeMath {
53   function safeMul(uint a, uint b) internal returns (uint) {
54     uint c = a * b;
55     assert(a == 0 || c / a == b);
56     return c;
57   }
58 
59   function safeDiv(uint a, uint b) internal returns (uint) {
60     assert(b > 0);
61     uint c = a / b;
62     assert(a == b * c + a % b);
63     return c;
64   }
65 
66   function safeSub(uint a, uint b) internal returns (uint) {
67     assert(b <= a);
68     return a - b;
69   }
70 
71   function safeAdd(uint a, uint b) internal returns (uint) {
72     uint c = a + b;
73     assert(c>=a && c>=b);
74     return c;
75   }
76 
77   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
78     return a >= b ? a : b;
79   }
80 
81   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
82     return a < b ? a : b;
83   }
84 
85   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
86     return a >= b ? a : b;
87   }
88 
89   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
90     return a < b ? a : b;
91   }
92 
93 }
94 
95 
96 
97 /**
98  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
99  *
100  * Based on code by FirstBlood:
101  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  */
103 contract StandardToken is ERC20, SafeMath {
104 
105   /* Token supply got increased and a new owner received these tokens */
106   event Minted(address receiver, uint amount);
107 
108   /* Actual balances of token holders */
109   mapping(address => uint) balances;
110 
111   /* approve() allowances */
112   mapping (address => mapping (address => uint)) allowed;
113 
114   /* Interface declaration */
115   function isToken() public constant returns (bool weAre) {
116     return true;
117   }
118 
119   function transfer(address _to, uint _value) returns (bool success) {
120     balances[msg.sender] = safeSub(balances[msg.sender], _value);
121     balances[_to] = safeAdd(balances[_to], _value);
122     Transfer(msg.sender, _to, _value);
123     return true;
124   }
125 
126   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
127     uint _allowance = allowed[_from][msg.sender];
128 
129     balances[_to] = safeAdd(balances[_to], _value);
130     balances[_from] = safeSub(balances[_from], _value);
131     allowed[_from][msg.sender] = safeSub(_allowance, _value);
132     Transfer(_from, _to, _value);
133     return true;
134   }
135 
136   function balanceOf(address _owner) constant returns (uint balance) {
137     return balances[_owner];
138   }
139 
140   function approve(address _spender, uint _value) returns (bool success) {
141 
142     // To change the approve amount you first have to reduce the addresses`
143     //  allowance to zero by calling `approve(_spender, 0)` if it is not
144     //  already 0 to mitigate the race condition described here:
145     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
147 
148     allowed[msg.sender][_spender] = _value;
149     Approval(msg.sender, _spender, _value);
150     return true;
151   }
152 
153   function allowance(address _owner, address _spender) constant returns (uint remaining) {
154     return allowed[_owner][_spender];
155   }
156 
157 }
158 
159 
160 
161 /**
162  * @title Ownable
163  * @dev The Ownable contract has an owner address, and provides basic authorization control
164  * functions, this simplifies the implementation of "user permissions".
165  */
166 contract Ownable {
167   address public owner;
168 
169 
170   /**
171    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
172    * account.
173    */
174   function Ownable() {
175     owner = msg.sender;
176   }
177 
178 
179   /**
180    * @dev Throws if called by any account other than the owner.
181    */
182   modifier onlyOwner() {
183     require(msg.sender == owner);
184     _;
185   }
186 
187 
188   /**
189    * @dev Allows the current owner to transfer control of the contract to a newOwner.
190    * @param newOwner The address to transfer ownership to.
191    */
192   function transferOwnership(address newOwner) onlyOwner {
193     require(newOwner != address(0));      
194     owner = newOwner;
195   }
196 
197 }
198 
199 
200 /**
201  * Issuer manages token distribution after the crowdsale.
202  *
203  * This contract is fed a CSV file with Ethereum addresses and their
204  * issued token balances.
205  *
206  * Issuer act as a gate keeper to ensure there is no double issuance
207  * per address, in the case we need to do several issuance batches,
208  * there is a race condition or there is a fat finger error.
209  *
210  * Issuer contract gets allowance from the team multisig to distribute tokens.
211  *
212  */
213 contract Issuer is Ownable {
214 
215   /** Map addresses whose tokens we have already issued. */
216   mapping(address => bool) public issued;
217 
218   /** Centrally issued token we are distributing to our contributors */
219   StandardToken public token;
220 
221   /** Party (team multisig) who is in the control of the token pool. Note that this will be different from the owner address (scripted) that calls this contract. */
222   address public allower;
223 
224   /** How many addresses have received their tokens. */
225   uint public issuedCount;
226 
227   function Issuer(address _owner, address _allower, StandardToken _token) {
228     owner = _owner;
229     allower = _allower;
230     token = _token;
231   }
232 
233   function issue(address benefactor, uint amount) onlyOwner {
234     if(issued[benefactor]) throw;
235     token.transferFrom(allower, benefactor, amount);
236     issued[benefactor] = true;
237     issuedCount += amount;
238   }
239 
240 }
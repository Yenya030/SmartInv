1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10 	/**
11 	* @dev Multiplies two numbers, throws on overflow.
12 	*/
13 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14 		if (a == 0) {
15 			return 0;
16 		}
17 		c = a * b;
18 		assert(c / a == b);
19 		return c;
20 	}
21 
22 	/**
23 	* @dev Integer division of two numbers, truncating the quotient.
24 	*/
25 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
26 		// assert(b > 0); // Solidity automatically throws when dividing by 0
27 		// uint256 c = a / b;
28 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 		return a / b;
30 	}
31 
32 	/**
33 	* @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34 	*/
35 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36 		assert(b <= a);
37 		return a - b;
38 	}
39 
40 	/**
41 	* @dev Adds two numbers, throws on overflow.
42 	*/
43 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44 		c = a + b;
45 		assert(c >= a);
46 		return c;
47 	}
48 }
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56 	function totalSupply() public view returns (uint256);
57 	function balanceOf(address who) public view returns (uint256);
58 	function transfer(address to, uint256 value) public returns (bool);
59 	event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67 	using SafeMath for uint256;
68 
69 	mapping(address => uint256) balances;
70 
71 	uint256 totalSupply_;
72 
73 	/**
74 	* @dev total number of tokens in existence
75 	*/
76 	function totalSupply() public view returns (uint256) {
77 		return totalSupply_;
78 	}
79 
80 	/**
81 	* @dev transfer token for a specified address
82 	* @param _to The address to transfer to.
83 	* @param _value The amount to be transferred.
84 	*/
85 	function transfer(address _to, uint256 _value) public returns (bool) {
86 		require(_to != address(0));
87 		require(_value <= balances[msg.sender]);
88 
89 		balances[msg.sender] = balances[msg.sender].sub(_value);
90 		balances[_to] = balances[_to].add(_value);
91 		emit Transfer(msg.sender, _to, _value);
92 		return true;
93 	}
94 
95 	/**
96 	* @dev Gets the balance of the specified address.
97 	* @param _owner The address to query the the balance of.
98 	* @return An uint256 representing the amount owned by the passed address.
99 	*/
100 	function balanceOf(address _owner) public view returns (uint256) {
101 		return balances[_owner];
102 	}
103 
104 }
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111 	function allowance(address owner, address spender) public view returns (uint256);
112 	function transferFrom(address from, address to, uint256 value) public returns (bool);
113 	function approve(address spender, uint256 value) public returns (bool);
114 	event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126 	mapping (address => mapping (address => uint256)) internal allowed;
127 
128 
129 	/**
130 	 * @dev Transfer tokens from one address to another
131 	 * @param _from address The address which you want to send tokens from
132 	 * @param _to address The address which you want to transfer to
133 	 * @param _value uint256 the amount of tokens to be transferred
134 	 */
135 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
136 		require(_to != address(0));
137 		require(_value <= balances[_from]);
138 		require(_value <= allowed[_from][msg.sender]);
139 
140 		balances[_from] = balances[_from].sub(_value);
141 		balances[_to] = balances[_to].add(_value);
142 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143 		emit Transfer(_from, _to, _value);
144 		return true;
145 	}
146 
147 	/**
148 	 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149 	 *
150 	 * Beware that changing an allowance with this method brings the risk that someone may use both the old
151 	 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152 	 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153 	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154 	 * @param _spender The address which will spend the funds.
155 	 * @param _value The amount of tokens to be spent.
156 	 */
157 	function approve(address _spender, uint256 _value) public returns (bool) {
158 		allowed[msg.sender][_spender] = _value;
159 		emit Approval(msg.sender, _spender, _value);
160 		return true;
161 	}
162 
163 	/**
164 	 * @dev Function to check the amount of tokens that an owner allowed to a spender.
165 	 * @param _owner address The address which owns the funds.
166 	 * @param _spender address The address which will spend the funds.
167 	 * @return A uint256 specifying the amount of tokens still available for the spender.
168 	 */
169 	function allowance(address _owner, address _spender) public view returns (uint256) {
170 		return allowed[_owner][_spender];
171 	}
172 
173 	/**
174 	 * @dev Increase the amount of tokens that an owner allowed to a spender.
175 	 *
176 	 * approve should be called when allowed[_spender] == 0. To increment
177 	 * allowed value is better to use this function to avoid 2 calls (and wait until
178 	 * the first transaction is mined)
179 	 * From MonolithDAO Token.sol
180 	 * @param _spender The address which will spend the funds.
181 	 * @param _addedValue The amount of tokens to increase the allowance by.
182 	 */
183 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
184 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
185 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186 		return true;
187 	}
188 
189 	/**
190 	 * @dev Decrease the amount of tokens that an owner allowed to a spender.
191 	 *
192 	 * approve should be called when allowed[_spender] == 0. To decrement
193 	 * allowed value is better to use this function to avoid 2 calls (and wait until
194 	 * the first transaction is mined)
195 	 * From MonolithDAO Token.sol
196 	 * @param _spender The address which will spend the funds.
197 	 * @param _subtractedValue The amount of tokens to decrease the allowance by.
198 	 */
199 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
200 		uint oldValue = allowed[msg.sender][_spender];
201 		if (_subtractedValue > oldValue) {
202 			allowed[msg.sender][_spender] = 0;
203 		} else {
204 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
205 		}
206 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207 		return true;
208 	}
209 
210 }
211 
212 contract NomToken is StandardToken {
213 	event Mint(address indexed to, uint256 amount);
214 
215 	address public owner;
216 	
217 	string public constant name = "NOM Token"; 
218 	string public constant symbol = "NOM";
219 	uint8 public constant decimals = 18;	
220 	
221 	uint256 public constant totalTokens = 5650000000 * (10 ** uint256(decimals));
222 	
223 	uint256 public initialIssueMinting = totalTokens.mul(60).div(100);	//60% of tokens
224 	uint public constant initialIssueMintingDate = 1524873600;			//28.04.2018 UTC
225 	bool public initialIssueMinted = false;
226 		
227 	uint256 public firstStageMinting = totalTokens.mul(10).div(100);	//10% of tokens
228 	uint public constant firstStageMintingDate = 1532736000;			//28.07.2018 UTC
229 	bool public firstStageMinted = false;
230 		
231 	uint256 public secondStageMinting = totalTokens.mul(10).div(100);	//10% of tokens
232 	uint public constant secondStageMintingDate = 1540684800;			//28.10.2018 UTC
233 	bool public secondStageMinted = false;
234 	
235 	uint256 public thirdStageMinting = totalTokens.mul(10).div(100);	//10% of tokens
236 	uint public constant thirdStageMintingDate = 1548633600;			//28.01.2019 UTC
237 	bool public thirdStageMinted = false;
238 	
239 	uint256 public fourthStageMinting = totalTokens.mul(10).div(100);	//10% of tokens
240 	uint public constant fourthStageMintingDate = 1556409600;			//28.04.2019 UTC
241 	bool public fourthStageMinted = false;
242 		
243 	function NomToken() public {
244 		owner = msg.sender;
245 	}
246 	
247 	 /**
248 	 * @dev Function to mint tokens
249 	 * @return A boolean that indicates if the operation was successful.
250 	 */
251 	function mint() public returns (bool) {
252 		require(msg.sender == owner);
253 		
254 		uint256 tokensToMint = 0;
255 		if (now > initialIssueMintingDate && !initialIssueMinted) {
256 				tokensToMint = tokensToMint.add(initialIssueMinting);
257 				initialIssueMinted = true;
258 		}
259 		if (now > firstStageMintingDate && !firstStageMinted) {
260 				tokensToMint = tokensToMint.add(firstStageMinting);
261 				firstStageMinted = true;
262 		}
263 		if (now > secondStageMintingDate && !secondStageMinted) {
264 				tokensToMint = tokensToMint.add(secondStageMinting);
265 				secondStageMinted = true;
266 		}
267 		if (now > thirdStageMintingDate && !thirdStageMinted) {
268 				tokensToMint = tokensToMint.add(thirdStageMinting);
269 				thirdStageMinted = true;
270 		}
271 		if (now > fourthStageMintingDate && !fourthStageMinted) {
272 				tokensToMint = tokensToMint.add(fourthStageMinting);
273 				fourthStageMinted = true;
274 		}
275 		require(tokensToMint > 0);
276 		uint256 newTotalSupply = totalSupply_.add(tokensToMint);
277 		require(newTotalSupply <= totalTokens);
278 		
279 		totalSupply_ = totalSupply_.add(tokensToMint);
280 		balances[owner] = balances[owner].add(tokensToMint);
281 		emit Mint(owner, tokensToMint);
282 		emit Transfer(0x0, owner, tokensToMint);
283 		return true;
284 	}
285 }
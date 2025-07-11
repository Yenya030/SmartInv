1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract Ownable {
18   address public owner;
19 
20 
21   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23 
24   /**
25    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26    * account.
27    */
28   function Ownable() {
29     owner = msg.sender;
30   }
31 
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41 
42   /**
43    * @dev Allows the current owner to transfer control of the contract to a newOwner.
44    * @param newOwner The address to transfer ownership to.
45    */
46   function transferOwnership(address newOwner) onlyOwner public {
47     require(newOwner != address(0));
48     OwnershipTransferred(owner, newOwner);
49     owner = newOwner;
50   }
51 
52 }
53 
54 library SafeERC20 {
55   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
56     assert(token.transfer(to, value));
57   }
58 
59   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
60     assert(token.transferFrom(from, to, value));
61   }
62 
63   function safeApprove(ERC20 token, address spender, uint256 value) internal {
64     assert(token.approve(spender, value));
65   }
66 }
67 
68 library SafeMath {
69   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
70     uint256 c = a * b;
71     assert(a == 0 || c / a == b);
72     return c;
73   }
74 
75   function div(uint256 a, uint256 b) internal constant returns (uint256) {
76     // assert(b > 0); // Solidity automatically throws when dividing by 0
77     uint256 c = a / b;
78     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
79     return c;
80   }
81 
82   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
83     assert(b <= a);
84     return a - b;
85   }
86 
87   function add(uint256 a, uint256 b) internal constant returns (uint256) {
88     uint256 c = a + b;
89     assert(c >= a);
90     return c;
91   }
92 }
93 
94 contract BasicToken is ERC20Basic {
95   using SafeMath for uint256;
96 
97   mapping(address => uint256) balances;
98   /**
99   * @dev transfer token for a specified address
100   * @param _to The address to transfer to.
101   * @param _value The amount to be transferred.
102   */
103   function transfer(address _to, uint256 _value) public returns (bool) {
104     require(_to != address(0));
105 
106     // SafeMath.sub will throw if there is not enough balance.
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public constant returns (uint256 balance) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 contract Delivery is Ownable{
125 	using SafeMath for uint256;
126 	
127 	uint256 public Airdropsamount; // Airdrop total amount
128 	uint256 public decimals; // decimal of the token
129 	
130 	Peculium public pecul; // token Peculium
131 	bool public initPecul; // We need first to init the Peculium Token address
132 
133 	event AirdropOne(address airdropaddress,uint256 nbTokenSendAirdrop); // Event for one airdrop
134 	event AirdropList(address[] airdropListAddress,uint256[] listTokenSendAirdrop); // Event for all the airdrop
135 	event InitializedToken(address contractToken);
136 
137 	//Constructor
138 	function Delivery(){
139 	
140 		Airdropsamount = 28000000; // We allocate 28 Millions token for the airdrop (maybe to change) 
141 		initPecul = false;
142 	}
143 	
144 	
145 	/***  Functions of the contract ***/
146 	
147 	
148 	function InitPeculiumAdress(address peculAdress) onlyOwner
149 	{ // We init the Peculium token address
150 	
151 		pecul = Peculium(peculAdress);
152 		decimals = pecul.decimals();
153 		initPecul = true;
154 		InitializedToken(peculAdress);
155 	}
156 	
157 
158 	function airdropsTokens(address[] _vaddr, uint256[] _vamounts) onlyOwner Initialize NotEmpty 
159 	{ 
160 		
161 		require (Airdropsamount >0);
162 		require ( _vaddr.length == _vamounts.length );
163 		//Looping into input arrays to assign target amount to each given address 
164 		uint256 amountToSendTotal = 0;
165 		
166 		for (uint256 indexTest=0; indexTest<_vaddr.length; indexTest++) // We first test that we have enough token to send
167 		{
168 		
169 			amountToSendTotal.add(_vamounts[indexTest]); 
170 		
171 		}		
172 		require(amountToSendTotal<=Airdropsamount); // If no enough token, cancel the sell 
173 		
174 		for (uint256 index=0; index<_vaddr.length; index++) 
175 		{
176 			
177 			address toAddress = _vaddr[index];
178 			uint256 amountTo_Send = _vamounts[index].mul(10 ** decimals);
179 		
180 	                pecul.transfer(toAddress,amountTo_Send);
181 			AirdropOne(toAddress,amountTo_Send);
182 			
183 		}
184 		Airdropsamount = Airdropsamount.sub(amountToSendTotal);
185 			
186 		AirdropList(_vaddr,_vamounts);
187 	      
188 	}
189 	
190 	/***  Modifiers of the contract ***/
191 
192 	modifier NotEmpty {
193 		require (Airdropsamount>0);
194 		_;
195 	}
196 	
197 	modifier Initialize {
198 	require (initPecul==true);
199 	_;
200 	} 
201 
202     
203     }
204 
205 contract StandardToken is ERC20, BasicToken {
206 
207   mapping (address => mapping (address => uint256)) internal allowed;
208 
209 
210   /**
211    * @dev Transfer tokens from one address to another
212    * @param _from address The address which you want to send tokens from
213    * @param _to address The address which you want to transfer to
214    * @param _value uint256 the amount of tokens to be transferred
215    */
216   function transferFrom(address _from, address _to, uint256 _value) public returns (bool)  {
217     require(_to != address(0));
218 
219     uint256 _allowance = allowed[_from][msg.sender];
220 
221     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
222     // require (_value <= _allowance);
223 
224     balances[_from] = balances[_from].sub(_value);
225     balances[_to] = balances[_to].add(_value);
226     allowed[_from][msg.sender] = _allowance.sub(_value);
227     Transfer(_from, _to, _value);
228     return true;
229   }
230 
231   /**
232    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
233    *
234    * Beware that changing an allowance with this method brings the risk that someone may use both the old
235    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
236    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
237    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238    * @param _spender The address which will spend the funds.
239    * @param _value The amount of tokens to be spent.
240    */
241   function approve(address _spender, uint256 _value) public returns (bool) {
242     allowed[msg.sender][_spender] = _value;
243     Approval(msg.sender, _spender, _value);
244     return true;
245   }
246 
247   /**
248    * @dev Function to check the amount of tokens that an owner allowed to a spender.
249    * @param _owner address The address which owns the funds.
250    * @param _spender address The address which will spend the funds.
251    * @return A uint256 specifying the amount of tokens still available for the spender.
252    */
253   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
254     return allowed[_owner][_spender];
255   }
256 
257   /**
258    * approve should be called when allowed[_spender] == 0. To increment
259    * allowed value is better to use this function to avoid 2 calls (and wait until
260    * the first transaction is mined)
261    * From MonolithDAO Token.sol
262    */
263   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
264     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
265     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
266     return true;
267   }
268 
269   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
270     uint oldValue = allowed[msg.sender][_spender];
271     if (_subtractedValue > oldValue) {
272       allowed[msg.sender][_spender] = 0;
273     } else {
274       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
275     }
276     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277     return true;
278   }
279 
280 }
281 
282 contract BurnableToken is StandardToken {
283 
284     event Burn(address indexed burner, uint256 value);
285 
286     /**
287      * @dev Burns a specific amount of tokens.
288      * @param _value The amount of token to be burned.
289      */
290     function burn(uint256 _value) public {
291         require(_value > 0);
292         require(_value <= balances[msg.sender]);
293         // no need to require value <= totalSupply, since that would imply the
294         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
295 
296         address burner = msg.sender;
297         balances[burner] = balances[burner].sub(_value);
298         totalSupply = totalSupply.sub(_value);
299         Burn(burner, _value);
300     }
301 }
302 
303 contract Peculium is BurnableToken,Ownable { // Our token is a standard ERC20 Token with burnable and ownable aptitude
304 
305 	using SafeMath for uint256; // We use safemath to do basic math operation (+,-,*,/)
306 	using SafeERC20 for ERC20Basic; 
307 
308     	/* Public variables of the token for ERC20 compliance */
309 	string public name = "Peculium"; //token name 
310     	string public symbol = "PCL"; // token symbol
311     	uint256 public decimals = 8; // token number of decimal
312     	
313     	/* Public variables specific for Peculium */
314         uint256 public constant MAX_SUPPLY_NBTOKEN   = 20000000000*10**8; // The max cap is 20 Billion Peculium
315 
316 	uint256 public dateStartContract; // The date of the deployment of the token
317 	mapping(address => bool) public balancesCanSell; // The boolean variable, to frost the tokens
318 	uint256 public dateDefrost; // The date when the owners of token can defrost their tokens
319 
320 
321     	/* Event for the freeze of account */
322  	event FrozenFunds(address target, bool frozen);     	 
323      	event Defroze(address msgAdd, bool freeze);
324 	
325 
326 
327    
328 	//Constructor
329 	function Peculium() {
330 		totalSupply = MAX_SUPPLY_NBTOKEN;
331 		balances[owner] = totalSupply; // At the beginning, the owner has all the tokens. 
332 		balancesCanSell[owner] = true; // The owner need to sell token for the private sale and for the preICO, ICO.
333 		
334 		dateStartContract=now;
335 		dateDefrost = dateStartContract + 85 days; // everybody can defrost his own token after the 25 january 2018 (85 days after 1 November)
336 
337 	}
338 
339 	/*** Public Functions of the contract ***/	
340 	
341 	function defrostToken() public 
342 	{ // Function to defrost your own token, after the date of the defrost
343 	
344 		require(now>dateDefrost);
345 		balancesCanSell[msg.sender]=true;
346 		Defroze(msg.sender,true);
347 	}
348 				
349 	function transfer(address _to, uint256 _value) public returns (bool) 
350 	{ // We overright the transfer function to allow freeze possibility
351 	
352 		require(balancesCanSell[msg.sender]);
353 		return BasicToken.transfer(_to,_value);
354 	
355 	}
356 	
357 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
358 	{ // We overright the transferFrom function to allow freeze possibility (need to allow before)
359 	
360 		require(balancesCanSell[msg.sender]);	
361 		return StandardToken.transferFrom(_from,_to,_value);
362 	
363 	}
364 
365 	/***  Owner Functions of the contract ***/	
366 
367    	function freezeAccount(address target, bool canSell) onlyOwner 
368    	{
369         
370         	balancesCanSell[target] = canSell;
371         	FrozenFunds(target, canSell);
372     	
373     	}
374 
375 
376 	/*** Others Functions of the contract ***/	
377 	
378 	/* Approves and then calls the receiving contract */
379 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
380 		allowed[msg.sender][_spender] = _value;
381 		Approval(msg.sender, _spender, _value);
382 
383 		require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
384         	return true;
385     }
386 
387   	function getBlockTimestamp() constant returns (uint256)
388   	{
389         
390         	return now;
391   	
392   	}
393 
394   	function getOwnerInfos() constant returns (address ownerAddr, uint256 ownerBalance)  
395   	{ // Return info about the public address and balance of the account of the owner of the contract
396     	
397     		ownerAddr = owner;
398 		ownerBalance = balanceOf(ownerAddr);
399   	
400   	}
401 
402 }
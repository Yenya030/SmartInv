1 pragma solidity ^0.5.7;
2 
3 /*
4  * Creator: MidasCoin 
5 
6 /*
7  * Abstract Token Smart Contract
8  *
9  */
10 
11  
12  /*
13  * Safe Math Smart Contract. 
14  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
15  */
16 
17 contract SafeMath {
18   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19     if (a == 0) {
20       return 0;
21     }
22     uint256 c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 
47 
48 
49 /**
50  * ERC-20 standard token interface, as defined
51  * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.
52  */
53 contract Token {
54   
55   function totalSupply() public view returns (uint256 supply);
56   function balanceOf(address _owner) public view returns (uint256 balance);
57   function transfer(address _to, uint256 _value) public returns (bool success);
58   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
59   function approve(address _spender, uint256 _value) public returns (bool success);
60   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
61   event Transfer(address indexed _from, address indexed _to, uint256 _value);
62   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
63 }
64 
65 
66 
67 /**
68  * Abstract Token Smart Contract that could be used as a base contract for
69  * ERC-20 token contracts.
70  */
71 contract AbstractToken is Token, SafeMath {
72   /**
73    * Create new Abstract Token contract.
74    */
75   constructor () public {
76     // Do nothing
77   }
78   
79   /**
80    * Get number of tokens currently belonging to given owner.
81    *
82    * @param _owner address to get number of tokens currently belonging to the
83    *        owner of
84    * @return number of tokens currently belonging to the owner of given address
85    */
86   function balanceOf(address _owner) public view returns (uint256 balance) {
87     return accounts [_owner];
88   }
89 
90   /**
91    * Transfer given number of tokens from message sender to given recipient.
92    *
93    * @param _to address to transfer tokens to the owner of
94    * @param _value number of tokens to transfer to the owner of given address
95    * @return true if tokens were transferred successfully, false otherwise
96    * accounts [_to] + _value > accounts [_to] for overflow check
97    * which is already in safeMath
98    */
99   function transfer(address _to, uint256 _value) public returns (bool success) {
100     require(_to != address(0));
101     if (accounts [msg.sender] < _value) return false;
102     if (_value > 0 && msg.sender != _to) {
103       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
104       accounts [_to] = safeAdd (accounts [_to], _value);
105     }
106     emit Transfer (msg.sender, _to, _value);
107     return true;
108   }
109 
110   /**
111    * Transfer given number of tokens from given owner to given recipient.
112    *
113    * @param _from address to transfer tokens from the owner of
114    * @param _to address to transfer tokens to the owner of
115    * @param _value number of tokens to transfer from given owner to given
116    *        recipient
117    * @return true if tokens were transferred successfully, false otherwise
118    * accounts [_to] + _value > accounts [_to] for overflow check
119    * which is already in safeMath
120    */
121   function transferFrom(address _from, address _to, uint256 _value) public
122   returns (bool success) {
123     require(_to != address(0));
124     if (allowances [_from][msg.sender] < _value) return false;
125     if (accounts [_from] < _value) return false; 
126 
127     if (_value > 0 && _from != _to) {
128 	  allowances [_from][msg.sender] = safeSub (allowances [_from][msg.sender], _value);
129       accounts [_from] = safeSub (accounts [_from], _value);
130       accounts [_to] = safeAdd (accounts [_to], _value);
131     }
132     emit Transfer(_from, _to, _value);
133     return true;
134   }
135 
136   /**
137    * Allow given spender to transfer given number of tokens from message sender.
138    * @param _spender address to allow the owner of to transfer tokens from message sender
139    * @param _value number of tokens to allow to transfer
140    * @return true if token transfer was successfully approved, false otherwise
141    */
142    function approve (address _spender, uint256 _value) public returns (bool success) {
143     allowances [msg.sender][_spender] = _value;
144     emit Approval (msg.sender, _spender, _value);
145     return true;
146   }
147 
148   /**
149    * Tell how many tokens given spender is currently allowed to transfer from
150    * given owner.
151    *
152    * @param _owner address to get number of tokens allowed to be transferred
153    *        from the owner of
154    * @param _spender address to get number of tokens allowed to be transferred
155    *        by the owner of
156    * @return number of tokens given spender is currently allowed to transfer
157    *         from given owner
158    */
159   function allowance(address _owner, address _spender) public view
160   returns (uint256 remaining) {
161     return allowances [_owner][_spender];
162   }
163 
164   /**
165    * Mapping from addresses of token holders to the numbers of tokens belonging
166    * to these token holders.
167    */
168   mapping (address => uint256) accounts;
169 
170   /**
171    * Mapping from addresses of token holders to the mapping of addresses of
172    * spenders to the allowances set by these token holders to these spenders.
173    */
174   mapping (address => mapping (address => uint256)) private allowances;
175   
176 }
177 
178 
179 /**
180  * MidasCoin smart contract.
181  */
182 contract MDC is AbstractToken {
183   /**
184    * Maximum allowed number of tokens in circulation.
185    * tokenSupply = tokensIActuallyWant * (10 ^ decimals)
186    */
187    
188    
189   uint256 constant MAX_TOKEN_COUNT = 250000000 * (10**18);
190    
191   /**
192    * Address of the owner of this smart contract.
193    */
194   address private owner;
195   
196   /**
197    * Frozen account list holder
198    */
199   mapping (address => bool) private frozenAccount;
200 
201   /**
202    * Current number of tokens in circulation.
203    */
204   uint256 tokenCount = 0;
205   
206  
207   /**
208    * True if tokens transfers are currently frozen, false otherwise.
209    */
210   bool frozen = false;
211   
212  
213   /**
214    * Create new token smart contract and make msg.sender the
215    * owner of this smart contract.
216    */
217   constructor () public {
218     owner = msg.sender;
219   }
220 
221   /**
222    * Get total number of tokens in circulation.
223    *
224    * @return total number of tokens in circulation
225    */
226   function totalSupply() public view returns (uint256 supply) {
227     return tokenCount;
228   }
229 
230   string constant public name = "MidasCoin";
231   string constant public symbol = "MDC";
232   uint8 constant public decimals = 18;
233   
234   /**
235    * Transfer given number of tokens from message sender to given recipient.ss
236    * @param _to address to transfer tokens to the owner of
237    * @param _value number of tokens to transfer to the owner of given address
238    * @return true if tokens were transferred successfully, false otherwise
239    */
240   function transfer(address _to, uint256 _value) public returns (bool success) {
241     require(!frozenAccount[msg.sender]);
242 	if (frozen) return false;
243     else return AbstractToken.transfer (_to, _value);
244   }
245 
246   /**
247    * Transfer given number of tokens from given owner to given recipient.
248    *
249    * @param _from address to transfer tokens from the owner of
250    * @param _to address to transfer tokens to the owner of
251    * @param _value number of tokens to transfer from given owner to given
252    *        recipient
253    * @return true if tokens were transferred successfully, false otherwise
254    */
255   function transferFrom(address _from, address _to, uint256 _value) public
256     returns (bool success) {
257 	require(!frozenAccount[_from]);
258     if (frozen) return false;
259     else return AbstractToken.transferFrom (_from, _to, _value);
260   }
261 
262    /**
263    * Change how many tokens given spender is allowed to transfer from message
264    * spender.  In order to prevent double spending of allowance,
265    * To change the approve amount you first have to reduce the addresses`
266    * allowance to zero by calling `approve(_spender, 0)` if it is not
267    * already 0 to mitigate the race condition described here:
268    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
269    * @param _spender address to allow the owner of to transfer tokens from
270    *        message sender
271    * @param _value number of tokens to allow to transfer
272    * @return true if token transfer was successfully approved, false otherwise
273    */
274   function approve (address _spender, uint256 _value) public
275     returns (bool success) {
276 	require(allowance (msg.sender, _spender) == 0 || _value == 0);
277     return AbstractToken.approve (_spender, _value);
278   }
279 
280   /**
281    * Create _value new tokens and give new created tokens to msg.sender.
282    * May only be called by smart contract owner.
283    *
284    * @param _value number of tokens to create
285    * @return true if tokens were created successfully, false otherwise
286    */
287   function createTokens(uint256 _value) public
288     returns (bool success) {
289     require (msg.sender == owner);
290 
291     if (_value > 0) {
292       if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;
293 	  
294       accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);
295       tokenCount = safeAdd (tokenCount, _value);
296 	  
297 	  // adding transfer event and _from address as null address
298 	  emit Transfer(address(0), msg.sender, _value);
299 	  
300 	  return true;
301     }
302 	
303 	  return false;
304     
305   }
306   
307   /**
308    * For future use only when we will need more tokens for our main application
309    * Create mintedAmount new tokens and give new created tokens to target.
310    * May only be called by smart contract owner.
311    * @param mintedAmount number of tokens to create
312    * @return true if tokens were created successfully, false otherwise
313    */
314   
315   function mintToken(address target, uint256 mintedAmount) public
316   returns (bool success) {
317     require (msg.sender == owner);
318       if (mintedAmount > 0) {
319 	  
320       accounts [target] = safeAdd (accounts [target], mintedAmount);
321       tokenCount = safeAdd (tokenCount, mintedAmount);
322 	  
323 	  // adding transfer event and _from address as null address
324 	  emit Transfer(address(0), target, mintedAmount);
325 	  
326 	   return true;
327     }
328 	  return false;
329    
330     }
331 	
332   /**
333    * Burn intended tokens.
334    * Only be called by by burnable addresses.
335    *
336    * @param _value number of tokens to burn
337    * @return true if burnt successfully, false otherwise
338    */
339   
340   function burn(uint256 _value) public returns (bool success) {
341   
342         require(accounts[msg.sender] >= _value); 
343 		
344 		require (msg.sender == owner);
345 		
346 		accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
347 		
348         tokenCount = safeSub (tokenCount, _value);	
349 		
350         emit Burn(msg.sender, _value);
351 		
352         return true;
353     }	
354   
355 
356   /**
357    * Set new owner for the smart contract.
358    * May only be called by smart contract owner.
359    *
360    * @param _newOwner address of new owner of the smart contract
361    */
362   function setOwner(address _newOwner) public {
363     require (msg.sender == owner);
364 
365     owner = _newOwner;
366   }
367 
368   /**
369    * Freeze ALL token transfers.
370    * May only be called by smart contract owner.
371    */
372   function freezeTransfers () public {
373     require (msg.sender == owner);
374 
375     if (!frozen) {
376       frozen = true;
377       emit Freeze ();
378     }
379   }
380 
381   /**
382    * Unfreeze ALL token transfers.
383    * May only be called by smart contract owner.
384    */
385   function unfreezeTransfers () public {
386     require (msg.sender == owner);
387 
388     if (frozen) {
389       frozen = false;
390       emit Unfreeze ();
391     }
392   }
393   
394   
395   /*A user is able to unintentionally send tokens to a contract 
396   * and if the contract is not prepared to refund them they will get stuck in the contract. 
397   * The same issue used to happen for Ether too but new Solidity versions added the payable modifier to
398   * prevent unintended Ether transfers. However, there’s no such mechanism for token transfers.
399   * so the below function is created
400   */
401   
402   function refundTokens(address _token, address _refund, uint256 _value) public {
403     require (msg.sender == owner);
404     require(_token != address(this));
405     AbstractToken token = AbstractToken(_token);
406     token.transfer(_refund, _value);
407     emit RefundTokens(_token, _refund, _value);
408   }
409   
410   /**
411    * Freeze specific account
412    * May only be called by smart contract owner.
413    */
414   function freezeAccount(address _target, bool freeze) public {
415       require (msg.sender == owner);
416 	  require (msg.sender != _target);
417       frozenAccount[_target] = freeze;
418       emit FrozenFunds(_target, freeze);
419  }
420 
421   /**
422    * Logged when token transfers were frozen.
423    */
424   event Freeze ();
425 
426   /**
427    * Logged when token transfers were unfrozen.
428    */
429   event Unfreeze ();
430   
431   /**
432    * Logged when a particular account is frozen.
433    */
434   
435   event FrozenFunds(address target, bool frozen);
436   
437    /**
438    * Logged when a token is burnt.
439    */  
440   
441   event Burn(address target,uint256 _value);
442 
443 
444   
445   /**
446    * when accidentally send other tokens are refunded
447    */
448   
449   event RefundTokens(address _token, address _refund, uint256 _value);
450 }
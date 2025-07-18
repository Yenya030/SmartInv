1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) public onlyOwner {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 
61 
62 
63 
64 
65 
66 
67 
68 
69 
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   /**
81   * @dev transfer token for a specified address
82   * @param _to The address to transfer to.
83   * @param _value The amount to be transferred.
84   */
85   function transfer(address _to, uint256 _value) public returns (bool) {
86     require(_to != address(0));
87     require(_value <= balances[msg.sender]);
88 
89     // SafeMath.sub will throw if there is not enough balance.
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     Transfer(msg.sender, _to, _value);
93     return true;
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of.
99   * @return An uint256 representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) public view returns (uint256 balance) {
102     return balances[_owner];
103   }
104 
105 }
106 
107 
108 
109 
110 
111 
112 
113 /**
114  * @title ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/20
116  */
117 contract ERC20 is ERC20Basic {
118   function allowance(address owner, address spender) public view returns (uint256);
119   function transferFrom(address from, address to, uint256 value) public returns (bool);
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 
125 
126 /**
127  * @title Standard ERC20 token
128  *
129  * @dev Implementation of the basic standard token.
130  * @dev https://github.com/ethereum/EIPs/issues/20
131  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
132  */
133 contract StandardToken is ERC20, BasicToken {
134 
135   mapping (address => mapping (address => uint256)) internal allowed;
136 
137 
138   /**
139    * @dev Transfer tokens from one address to another
140    * @param _from address The address which you want to send tokens from
141    * @param _to address The address which you want to transfer to
142    * @param _value uint256 the amount of tokens to be transferred
143    */
144   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(_value <= balances[_from]);
147     require(_value <= allowed[_from][msg.sender]);
148 
149     balances[_from] = balances[_from].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152     Transfer(_from, _to, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    *
159    * Beware that changing an allowance with this method brings the risk that someone may use both the old
160    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
161    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
162    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163    * @param _spender The address which will spend the funds.
164    * @param _value The amount of tokens to be spent.
165    */
166   function approve(address _spender, uint256 _value) public returns (bool) {
167     allowed[msg.sender][_spender] = _value;
168     Approval(msg.sender, _spender, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Function to check the amount of tokens that an owner allowed to a spender.
174    * @param _owner address The address which owns the funds.
175    * @param _spender address The address which will spend the funds.
176    * @return A uint256 specifying the amount of tokens still available for the spender.
177    */
178   function allowance(address _owner, address _spender) public view returns (uint256) {
179     return allowed[_owner][_spender];
180   }
181 
182   /**
183    * @dev Increase the amount of tokens that an owner allowed to a spender.
184    *
185    * approve should be called when allowed[_spender] == 0. To increment
186    * allowed value is better to use this function to avoid 2 calls (and wait until
187    * the first transaction is mined)
188    * From MonolithDAO Token.sol
189    * @param _spender The address which will spend the funds.
190    * @param _addedValue The amount of tokens to increase the allowance by.
191    */
192   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
193     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
194     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     return true;
196   }
197 
198   /**
199    * @dev Decrease the amount of tokens that an owner allowed to a spender.
200    *
201    * approve should be called when allowed[_spender] == 0. To decrement
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _subtractedValue The amount of tokens to decrease the allowance by.
207    */
208   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
209     uint oldValue = allowed[msg.sender][_spender];
210     if (_subtractedValue > oldValue) {
211       allowed[msg.sender][_spender] = 0;
212     } else {
213       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
214     }
215     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219 }
220 
221 
222 
223 
224 
225 /**
226  * @title Burnable Token
227  * @dev Token that can be irreversibly burned (destroyed).
228  */
229 contract BurnableToken is BasicToken {
230 
231     event Burn(address indexed burner, uint256 value);
232 
233     /**
234      * @dev Burns a specific amount of tokens.
235      * @param _value The amount of token to be burned.
236      */
237     function burn(uint256 _value) public {
238         require(_value <= balances[msg.sender]);
239         // no need to require value <= totalSupply, since that would imply the
240         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
241 
242         address burner = msg.sender;
243         balances[burner] = balances[burner].sub(_value);
244         totalSupply = totalSupply.sub(_value);
245         Burn(burner, _value);
246     }
247 }
248 
249 
250 
251 
252 
253 /**
254  * @title SafeMath
255  * @dev Math operations with safety checks that throw on error
256  */
257 library SafeMath {
258   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
259     if (a == 0) {
260       return 0;
261     }
262     uint256 c = a * b;
263     assert(c / a == b);
264     return c;
265   }
266 
267   function div(uint256 a, uint256 b) internal pure returns (uint256) {
268     // assert(b > 0); // Solidity automatically throws when dividing by 0
269     uint256 c = a / b;
270     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
271     return c;
272   }
273 
274   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
275     assert(b <= a);
276     return a - b;
277   }
278 
279   function add(uint256 a, uint256 b) internal pure returns (uint256) {
280     uint256 c = a + b;
281     assert(c >= a);
282     return c;
283   }
284 }
285 
286 
287 /**
288  * The Tabs Tracking Chain token (TTC - TTCToken) has a fixed supply
289  *
290  * The owner can associate the token with a token sale contract. In that
291  * case, the token balance is moved to the token sale contract, which
292  * in turn can transfer its tokens to contributors to the sale.
293  */
294 contract TTCToken is StandardToken, BurnableToken, Ownable {
295 
296     // Constants
297     string  public constant name = "Tabs Tracking Chain";
298     string  public constant symbol = "TTC";
299     uint8   public constant decimals = 18;
300     string  public constant website = "www.ttchain.io"; 
301     uint256 public constant INITIAL_SUPPLY      =  600000000 * (10 ** uint256(decimals));
302     uint256 public constant CROWDSALE_ALLOWANCE =  480000000 * (10 ** uint256(decimals));
303     uint256 public constant ADMIN_ALLOWANCE     =  120000000 * (10 ** uint256(decimals));
304 
305     // Properties
306     uint256 public crowdSaleAllowance;      // the number of tokens available for crowdsales
307     uint256 public adminAllowance;          // the number of tokens available for the administrator
308     address public crowdSaleAddr;           // the address of a crowdsale currently selling this token
309     address public adminAddr;               // the address of a crowdsale currently selling this token
310     //bool    public transferEnabled = false; // indicates if transferring tokens is enabled or not
311     bool    public transferEnabled = true;  // Enables everyone to transfer tokens 
312 
313     // Modifiers
314 
315     /**
316      * The listed addresses are not valid recipients of tokens.
317      *
318      * 0x0           - the zero address is not valid
319      * this          - the contract itself should not receive tokens
320      * owner         - the owner has all the initial tokens, but cannot receive any back
321      * adminAddr     - the admin has an allowance of tokens to transfer, but does not receive any
322      * crowdSaleAddr - the crowdsale has an allowance of tokens to transfer, but does not receive any
323      */
324     modifier validDestination(address _to) {
325         require(_to != address(0x0));
326         require(_to != address(this));
327         require(_to != owner);
328         require(_to != address(adminAddr));
329         require(_to != address(crowdSaleAddr));
330         _;
331     }
332 
333     /**
334      * Constructor - instantiates token supply and allocates balanace of
335      * to the owner (msg.sender).
336      */
337     function TTCToken(address _admin) public {
338         // the owner is a custodian of tokens that can
339         // give an allowance of tokens for crowdsales
340         // or to the admin, but cannot itself transfer
341         // tokens; hence, this requirement
342         require(msg.sender != _admin);
343 
344         totalSupply = INITIAL_SUPPLY;
345         crowdSaleAllowance = CROWDSALE_ALLOWANCE;
346         adminAllowance = ADMIN_ALLOWANCE;
347 
348         // mint all tokens
349         balances[msg.sender] = totalSupply.sub(adminAllowance);
350         Transfer(address(0x0), msg.sender, totalSupply.sub(adminAllowance));
351 
352         balances[_admin] = adminAllowance;
353         Transfer(address(0x0), _admin, adminAllowance);
354 
355         adminAddr = _admin;
356         approve(adminAddr, adminAllowance);
357     }
358 
359     /**
360      * Associates this token with a current crowdsale, giving the crowdsale
361      * an allowance of tokens from the crowdsale supply. This gives the
362      * crowdsale the ability to call transferFrom to transfer tokens to
363      * whomever has purchased them.
364      *
365      * Note that if _amountForSale is 0, then it is assumed that the full
366      * remaining crowdsale supply is made available to the crowdsale.
367      *
368      * @param _crowdSaleAddr The address of a crowdsale contract that will sell this token
369      * @param _amountForSale The supply of tokens provided to the crowdsale
370      */
371     function setCrowdsale(address _crowdSaleAddr, uint256 _amountForSale) external onlyOwner {
372         require(_amountForSale <= crowdSaleAllowance);
373 
374         // if 0, then full available crowdsale supply is assumed
375         uint amount = (_amountForSale == 0) ? crowdSaleAllowance : _amountForSale;
376 
377         // Clear allowance of old, and set allowance of new
378         approve(crowdSaleAddr, 0);
379         approve(_crowdSaleAddr, amount);
380 
381         crowdSaleAddr = _crowdSaleAddr;
382     }
383 
384     /**
385      * Overrides ERC20 transfer function with modifier that prevents the
386      * ability to transfer tokens until after transfers have been enabled.
387      */
388     function transfer(address _to, uint256 _value) public validDestination(_to) returns (bool) {
389         return super.transfer(_to, _value);
390     }
391 
392     /**
393      * Overrides ERC20 transferFrom function with modifier that prevents the
394      * ability to transfer tokens until after transfers have been enabled.
395      */
396     function transferFrom(address _from, address _to, uint256 _value) public validDestination(_to) returns (bool) {
397         bool result = super.transferFrom(_from, _to, _value);
398         if (result) {
399             if (msg.sender == crowdSaleAddr)
400                 crowdSaleAllowance = crowdSaleAllowance.sub(_value);
401             if (msg.sender == adminAddr)
402                 adminAllowance = adminAllowance.sub(_value);
403         }
404         return result;
405     }
406 
407     /**
408      * Overrides the burn function so that it cannot be called until after
409      * transfers have been enabled.
410      *
411      * @param _value    The amount of tokens to burn in wei-TTC
412      */
413     function burn(uint256 _value) public {
414         require(transferEnabled || msg.sender == owner);
415         super.burn(_value);
416         Transfer(msg.sender, address(0x0), _value);
417     }
418 }
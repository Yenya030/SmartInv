1 pragma solidity ^0.4.17;
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
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42     address public owner;
43 
44     /**
45       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46       * account.
47       */
48     function Ownable() public {
49         owner = msg.sender;
50     }
51 
52     /**
53       * @dev Throws if called by any account other than the owner.
54       */
55     modifier onlyOwner() {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     /**
61     * @dev Allows the current owner to transfer control of the contract to a newOwner.
62     * @param newOwner The address to transfer ownership to.
63     */
64     function transferOwnership(address newOwner) public onlyOwner {
65         if (newOwner != address(0)) {
66             owner = newOwner;
67         }
68     }
69 
70 }
71 
72 /**
73  * @title ERC20Basic
74  * @dev Simpler version of ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/20
76  */
77 contract ERC20Basic {
78     uint public _totalSupply;
79     function totalSupply() public constant returns (uint);
80     function balanceOf(address who) public constant returns (uint);
81     function transfer(address to, uint value) public;
82     event Transfer(address indexed from, address indexed to, uint value);
83 }
84 
85 /**
86  * @title ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/20
88  */
89 contract ERC20 is ERC20Basic {
90     function allowance(address owner, address spender) public constant returns (uint);
91     function transferFrom(address from, address to, uint value) public;
92     function approve(address spender, uint value) public;
93     event Approval(address indexed owner, address indexed spender, uint value);
94 }
95 
96 /**
97  * @title Basic token
98  * @dev Basic version of StandardToken, with no allowances.
99  */
100 contract BasicToken is Ownable, ERC20Basic {
101     using SafeMath for uint;
102 
103     mapping(address => uint) public balances;
104 
105     // additional variables for use if transaction fees ever became necessary
106     uint public basisPointsRate = 0;
107     uint public maximumFee = 0;
108 
109     /**
110     * @dev Fix for the ERC20 short address attack.
111     */
112     modifier onlyPayloadSize(uint size) {
113         require(!(msg.data.length < size + 4));
114         _;
115     }
116 
117     /**
118     * @dev transfer token for a specified address
119     * @param _to The address to transfer to.
120     * @param _value The amount to be transferred.
121     */
122     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
123         uint fee = (_value.mul(basisPointsRate)).div(10000);
124         if (fee > maximumFee) {
125             fee = maximumFee;
126         }
127         uint sendAmount = _value.sub(fee);
128         balances[msg.sender] = balances[msg.sender].sub(_value);
129         balances[_to] = balances[_to].add(sendAmount);
130         if (fee > 0) {
131             balances[owner] = balances[owner].add(fee);
132             Transfer(msg.sender, owner, fee);
133         }
134         Transfer(msg.sender, _to, sendAmount);
135     }
136 
137     /**
138     * @dev Gets the balance of the specified address.
139     * @param _owner The address to query the the balance of.
140     * @return An uint representing the amount owned by the passed address.
141     */
142     function balanceOf(address _owner) public constant returns (uint balance) {
143         return balances[_owner];
144     }
145 
146 }
147 
148 /**
149  * @title Standard ERC20 token
150  *
151  * @dev Implementation of the basic standard token.
152  * @dev https://github.com/ethereum/EIPs/issues/20
153  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
154  */
155 contract StandardToken is BasicToken, ERC20 {
156 
157     mapping (address => mapping (address => uint)) public allowed;
158 
159     uint public constant MAX_UINT = 2**256 - 1;
160 
161     /**
162     * @dev Transfer tokens from one address to another
163     * @param _from address The address which you want to send tokens from
164     * @param _to address The address which you want to transfer to
165     * @param _value uint the amount of tokens to be transferred
166     */
167     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
168         var _allowance = allowed[_from][msg.sender];
169 
170         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
171         // if (_value > _allowance) throw;
172 
173         uint fee = (_value.mul(basisPointsRate)).div(10000);
174         if (fee > maximumFee) {
175             fee = maximumFee;
176         }
177         if (_allowance < MAX_UINT) {
178             allowed[_from][msg.sender] = _allowance.sub(_value);
179         }
180         uint sendAmount = _value.sub(fee);
181         balances[_from] = balances[_from].sub(_value);
182         balances[_to] = balances[_to].add(sendAmount);
183         if (fee > 0) {
184             balances[owner] = balances[owner].add(fee);
185             Transfer(_from, owner, fee);
186         }
187         Transfer(_from, _to, sendAmount);
188     }
189 
190     /**
191     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
192     * @param _spender The address which will spend the funds.
193     * @param _value The amount of tokens to be spent.
194     */
195     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
196 
197         // To change the approve amount you first have to reduce the addresses`
198         //  allowance to zero by calling `approve(_spender, 0)` if it is not
199         //  already 0 to mitigate the race condition described here:
200         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
202 
203         allowed[msg.sender][_spender] = _value;
204         Approval(msg.sender, _spender, _value);
205     }
206 
207     /**
208     * @dev Function to check the amount of tokens than an owner allowed to a spender.
209     * @param _owner address The address which owns the funds.
210     * @param _spender address The address which will spend the funds.
211     * @return A uint specifying the amount of tokens still available for the spender.
212     */
213     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
214         return allowed[_owner][_spender];
215     }
216 
217 }
218 
219 
220 /**
221  * @title Pausable
222  * @dev Base contract which allows children to implement an emergency stop mechanism.
223  */
224 contract Pausable is Ownable {
225   event Pause();
226   event Unpause();
227 
228   bool public paused = false;
229 
230 
231   /**
232    * @dev Modifier to make a function callable only when the contract is not paused.
233    */
234   modifier whenNotPaused() {
235     require(!paused);
236     _;
237   }
238 
239   /**
240    * @dev Modifier to make a function callable only when the contract is paused.
241    */
242   modifier whenPaused() {
243     require(paused);
244     _;
245   }
246 
247   /**
248    * @dev called by the owner to pause, triggers stopped state
249    */
250   function pause() onlyOwner whenNotPaused public {
251     paused = true;
252     Pause();
253   }
254 
255   /**
256    * @dev called by the owner to unpause, returns to normal state
257    */
258   function unpause() onlyOwner whenPaused public {
259     paused = false;
260     Unpause();
261   }
262 }
263 
264 contract BlackList is Ownable, BasicToken {
265 
266     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////
267     function getBlackListStatus(address _maker) external constant returns (bool) {
268         return isBlackListed[_maker];
269     }
270 
271     function getOwner() external constant returns (address) {
272         return owner;
273     }
274 
275     mapping (address => bool) public isBlackListed;
276     
277     function addBlackList (address _evilUser) public onlyOwner {
278         isBlackListed[_evilUser] = true;
279         AddedBlackList(_evilUser);
280     }
281 
282     function removeBlackList (address _clearedUser) public onlyOwner {
283         isBlackListed[_clearedUser] = false;
284         RemovedBlackList(_clearedUser);
285     }
286 
287     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
288         require(isBlackListed[_blackListedUser]);
289         uint dirtyFunds = balanceOf(_blackListedUser);
290         balances[_blackListedUser] = 0;
291         _totalSupply -= dirtyFunds;
292         DestroyedBlackFunds(_blackListedUser, dirtyFunds);
293     }
294 
295     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
296 
297     event AddedBlackList(address _user);
298 
299     event RemovedBlackList(address _user);
300 
301 }
302 
303 contract UpgradedStandardToken is StandardToken{
304     // those methods are called by the legacy contract
305     // and they must ensure msg.sender to be the contract address
306     function transferByLegacy(address from, address to, uint value) public;
307     function transferFromByLegacy(address sender, address from, address spender, uint value) public;
308     function approveByLegacy(address from, address spender, uint value) public;
309 }
310 
311 contract HKDToken is Pausable, StandardToken, BlackList {
312 
313     string public constant name = "Hong Kong Dollar Token";
314     string public constant symbol = "HKDT";
315     uint public constant decimals = 18;
316     address public upgradedAddress;
317     bool public deprecated = false;
318     uint public constant _initialSupply = 10 * 10000 * 10000 * (10 ** uint256(decimals));
319     uint public _totalSupply = _initialSupply;
320 
321     /**
322     * @dev Constructor that gives owner all of existing tokens.
323     */
324     constructor() HKDToken() public {
325         balances[msg.sender] = _initialSupply;
326         emit Transfer(0x0, msg.sender, _initialSupply);
327     }
328 
329     // Forward ERC20 methods to upgraded contract if this one is deprecated
330     function transfer(address _to, uint _value) public whenNotPaused {
331         require(!isBlackListed[msg.sender]);
332         if (deprecated) {
333             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
334         } else {
335             return super.transfer(_to, _value);
336         }
337     }
338 
339     // Forward ERC20 methods to upgraded contract if this one is deprecated
340     function transferFrom(address _from, address _to, uint _value) public whenNotPaused {
341         require(!isBlackListed[_from]);
342         if (deprecated) {
343             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
344         } else {
345             return super.transferFrom(_from, _to, _value);
346         }
347     }
348 
349     // Forward ERC20 methods to upgraded contract if this one is deprecated
350     function balanceOf(address who) public constant returns (uint) {
351         if (deprecated) {
352             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
353         } else {
354             return super.balanceOf(who);
355         }
356     }
357 
358     // Forward ERC20 methods to upgraded contract if this one is deprecated
359     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
360         if (deprecated) {
361             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
362         } else {
363             return super.approve(_spender, _value);
364         }
365     }
366 
367     // Forward ERC20 methods to upgraded contract if this one is deprecated
368     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
369         if (deprecated) {
370             return StandardToken(upgradedAddress).allowance(_owner, _spender);
371         } else {
372             return super.allowance(_owner, _spender);
373         }
374     }
375 
376     // deprecate current contract in favour of a new one
377     function deprecate(address _upgradedAddress) public onlyOwner {
378         deprecated = true;
379         upgradedAddress = _upgradedAddress;
380         Deprecate(_upgradedAddress);
381     }
382 
383     // deprecate current contract if favour of a new one
384     function totalSupply() public constant returns (uint) {
385         if (deprecated) {
386             return StandardToken(upgradedAddress).totalSupply();
387         } else {
388             return _totalSupply;
389         }
390     }
391 
392     // Issue a new amount of tokens
393     // these tokens are deposited into the owner address
394     //
395     // @param _amount Number of tokens to be issued
396     function issue(uint amount) public onlyOwner {
397         require(_totalSupply + amount > _totalSupply);
398         require(balances[owner] + amount > balances[owner]);
399 
400         balances[owner] += amount;
401         _totalSupply += amount;
402         Issue(amount);
403     }
404 
405     // Redeem tokens.
406     // These tokens are withdrawn from the owner address
407     // if the balance must be enough to cover the redeem
408     // or the call will fail.
409     // @param _amount Number of tokens to be issued
410     function redeem(uint amount) public onlyOwner {
411         require(_totalSupply >= amount);
412         require(balances[owner] >= amount);
413 
414         _totalSupply -= amount;
415         balances[owner] -= amount;
416         Redeem(amount);
417     }
418 
419     function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
420         // Ensure transparency by hardcoding limit beyond which fees can never be added
421         require(newBasisPoints < 20);
422         require(newMaxFee < 50);
423 
424         basisPointsRate = newBasisPoints;
425         maximumFee = newMaxFee.mul(10**decimals);
426 
427         Params(basisPointsRate, maximumFee);
428     }
429 
430     // Called when new token are issued
431     event Issue(uint amount);
432 
433     // Called when tokens are redeemed
434     event Redeem(uint amount);
435 
436     // Called when contract is deprecated
437     event Deprecate(address newAddress);
438 
439     // Called if contract ever adds fees
440     event Params(uint feeBasisPoints, uint maxFee);
441 }
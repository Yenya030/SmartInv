1 pragma solidity 0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44 
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable() public {
53     owner = msg.sender;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) public onlyOwner {
69     require(newOwner != address(0));
70     emit OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81     /// Total amount of tokens
82   uint256 public totalSupply;
83   
84   function balanceOf(address _owner) public view returns (uint256 balance);
85   
86   function transfer(address _to, uint256 _amount) public returns (bool success);
87   
88   event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
97   
98   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
99   
100   function approve(address _spender, uint256 _amount) public returns (bool success);
101   
102   event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 /**
106  * @title Basic token
107  * @dev Basic version of StandardToken, with no allowances.
108  */
109 contract BasicToken is ERC20Basic {
110   using SafeMath for uint256;
111 
112   //balance in each address account
113   mapping(address => uint256) balances;
114 
115   /**
116   * @dev transfer token for a specified address
117   * @param _to The address to transfer to.
118   * @param _amount The amount to be transferred.
119   */
120   function transfer(address _to, uint256 _amount) public returns (bool success) {
121     require(_to != address(0));
122     require(balances[msg.sender] >= _amount && _amount > 0
123         && balances[_to].add(_amount) > balances[_to]);
124 
125     // SafeMath.sub will throw if there is not enough balance.
126     balances[msg.sender] = balances[msg.sender].sub(_amount);
127     balances[_to] = balances[_to].add(_amount);
128     emit Transfer(msg.sender, _to, _amount);
129     return true;
130   }
131 
132   /**
133   * @dev Gets the balance of the specified address.
134   * @param _owner The address to query the the balance of.
135   * @return An uint256 representing the amount owned by the passed address.
136   */
137   function balanceOf(address _owner) public view returns (uint256 balance) {
138     return balances[_owner];
139   }
140 
141 }
142 
143 /**
144  * @title Standard ERC20 token
145  *
146  * @dev Implementation of the basic standard token.
147  * @dev https://github.com/ethereum/EIPs/issues/20
148  */
149 contract StandardToken is ERC20, BasicToken {
150   
151   
152   mapping (address => mapping (address => uint256)) internal allowed;
153 
154 
155   /**
156    * @dev Transfer tokens from one address to another
157    * @param _from address The address which you want to send tokens from
158    * @param _to address The address which you want to transfer to
159    * @param _amount uint256 the amount of tokens to be transferred
160    */
161   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
162     require(_to != address(0));
163     require(balances[_from] >= _amount);
164     require(allowed[_from][msg.sender] >= _amount);
165     require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);
166 
167     balances[_from] = balances[_from].sub(_amount);
168     balances[_to] = balances[_to].add(_amount);
169     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
170     emit Transfer(_from, _to, _amount);
171     return true;
172   }
173 
174   /**
175    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176    *
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _amount The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _amount) public returns (bool success) {
185     allowed[msg.sender][_spender] = _amount;
186     emit Approval(msg.sender, _spender, _amount);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
197     return allowed[_owner][_spender];
198   }
199 
200 }
201 
202 /**
203  * @title Burnable Token
204  * @dev Token that can be irreversibly burned (destroyed).
205  */
206 contract BurnableToken is StandardToken, Ownable {
207 
208     //this will contain a list of addresses allowed to burn their tokens
209     mapping(address=>bool)allowedBurners;
210     
211     event Burn(address indexed burner, uint256 value);
212     
213     event BurnerAdded(address indexed burner);
214     
215     event BurnerRemoved(address indexed burner);
216     
217     //check whether the burner is eligible burner
218     modifier isBurner(address _burner){
219         require(allowedBurners[_burner]);
220         _;
221     }
222     
223     /**
224     *@dev Method to add eligible addresses in the list of burners. Since we need to burn all tokens left with the sales contract after the sale has ended. The sales contract should
225     * be an eligible burner. The owner has to add the sales address in the eligible burner list.
226     * @param _burner Address of the eligible burner
227     */
228     function addEligibleBurner(address _burner)public onlyOwner {
229         
230         require(_burner != address(0));
231         allowedBurners[_burner] = true;
232         emit BurnerAdded(_burner);
233     }
234     
235      /**
236     *@dev Method to remove addresses from the list of burners
237     * @param _burner Address of the eligible burner to be removed
238     */
239     function removeEligibleBurner(address _burner)public onlyOwner isBurner(_burner) {
240         
241         allowedBurners[_burner] = false;
242         emit BurnerRemoved(_burner);
243     }
244     
245     /**
246      * @dev Burns all tokens of the eligible burner
247      */
248     function burnAllTokens() public isBurner(msg.sender) {
249         
250         require(balances[msg.sender]>0);
251         
252         uint256 value = balances[msg.sender];
253         
254         totalSupply = totalSupply.sub(value);
255 
256         balances[msg.sender] = 0;
257         
258         emit Burn(msg.sender, value);
259     }
260 }
261 /**
262  * @title DRONE Token
263  * @dev Token representing DRONE.
264  */
265  contract DroneToken is BurnableToken {
266      string public name ;
267      string public symbol ;
268      uint8 public decimals = 0 ;
269      
270      /**
271      *@dev users sending ether to this contract will be reverted. Any ether sent to the contract will be sent back to the caller
272      */
273      function ()public payable {
274          revert();
275      }
276      
277      /**
278      * @dev Constructor function to initialize the initial supply of token to the creator of the contract
279      * @param initialSupply The initial supply of tokens which will be fixed through out
280      * @param tokenName The name of the token
281      * @param tokenSymbol The symboll of the token
282      */
283      function DroneToken(
284             uint256 initialSupply,
285             string tokenName,
286             string tokenSymbol
287          ) public {
288          totalSupply = initialSupply.mul( 10 ** uint256(decimals)); //Update total supply with the decimal amount
289          name = tokenName;
290          symbol = tokenSymbol;
291          balances[msg.sender] = totalSupply;
292          
293          //Emitting transfer event since assigning all tokens to the creator also corresponds to the transfer of tokens to the creator
294          emit Transfer(address(0), msg.sender, totalSupply);
295      }
296      
297      /**
298      *@dev helper method to get token details, name, symbol and totalSupply in one go
299      */
300     function getTokenDetail() public view returns (string, string, uint256) {
301 	    return (name, symbol, totalSupply);
302     }
303  }
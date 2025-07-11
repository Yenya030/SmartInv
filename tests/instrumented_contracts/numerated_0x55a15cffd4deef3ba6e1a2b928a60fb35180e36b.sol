1 pragma solidity 0.4.23;
2     
3     /**
4      * @title SafeMath
5      * @dev Math operations with safety checks that throw on error
6      */
7     library SafeMath {
8       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10           return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15       }
16     
17       function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22       }
23     
24       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27       }
28     
29       function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33       }
34     }
35     
36     contract owned {
37         address public owner;
38     	using SafeMath for uint256;
39     	
40         function owned() public {
41             owner = msg.sender;
42         }
43     
44         modifier onlyOwner {
45             require(msg.sender == owner);
46             _;
47         }
48     
49         function transferOwnership(address newOwner) onlyOwner public {
50             owner = newOwner;
51         }
52     }
53     
54     interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
55     
56     contract TokenERC20 {
57         // Public variables of the token
58         using SafeMath for uint256;
59     	string public name;
60         string public symbol;
61         uint8 public decimals = 18;
62         // 18 decimals is the strongly suggested default, avoid changing it
63         uint256 public totalSupply;
64     
65         // This creates an array with all balances
66         mapping (address => uint256) public balanceOf;
67         mapping (address => mapping (address => uint256)) public allowance;
68     
69         // This generates a public event on the blockchain that will notify clients
70         event Transfer(address indexed from, address indexed to, uint256 value);
71     
72         // This notifies clients about the amount burnt
73         event Burn(address indexed from, uint256 value);
74     
75         /**
76          * Constrctor function
77          *
78          * Initializes contract with initial supply tokens to the creator of the contract
79          */
80         function TokenERC20(
81             uint256 initialSupply,
82             string tokenName,
83             string tokenSymbol
84         ) public {
85             totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
86             balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
87             name = tokenName;                                   // Set the name for display purposes
88             symbol = tokenSymbol;                               // Set the symbol for display purposes
89         }
90     
91         /**
92          * Internal transfer, only can be called by this contract
93          */
94         function _transfer(address _from, address _to, uint _value) internal {
95             // Prevent transfer to 0x0 address. Use burn() instead
96             require(_to != 0x0);
97             // Check if the sender has enough
98             require(balanceOf[_from] >= _value);
99             // Check for overflows
100             require(balanceOf[_to].add(_value) > balanceOf[_to]);
101             // Save this for an assertion in the future
102             uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
103             // Subtract from the sender
104             balanceOf[_from] = balanceOf[_from].sub(_value);
105             // Add the same to the recipient
106             balanceOf[_to] = balanceOf[_to].add(_value);
107             emit Transfer(_from, _to, _value);
108             // Asserts are used to use static analysis to find bugs in your code. They should never fail
109             assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
110         }
111     
112         /**
113          * Transfer tokens
114          *
115          * Send `_value` tokens to `_to` from your account
116          *
117          * @param _to The address of the recipient
118          * @param _value the amount to send
119          */
120         function transfer(address _to, uint256 _value) public {
121             _transfer(msg.sender, _to, _value);
122         }
123     
124         /**
125          * Transfer tokens from other address
126          *
127          * Send `_value` tokens to `_to` in behalf of `_from`
128          *
129          * @param _from The address of the sender
130          * @param _to The address of the recipient
131          * @param _value the amount to send
132          */
133         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
134             require(_value <= allowance[_from][msg.sender]);     // Check allowance
135             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
136             _transfer(_from, _to, _value);
137             return true;
138         }
139     
140         /**
141          * Set allowance for other address
142          *
143          * Allows `_spender` to spend no more than `_value` tokens in your behalf
144          *
145          * @param _spender The address authorized to spend
146          * @param _value the max amount they can spend
147          */
148         function approve(address _spender, uint256 _value) public
149             returns (bool success) {
150             allowance[msg.sender][_spender] = _value;
151             return true;
152         }
153     
154         /**
155          * Set allowance for other address and notify
156          *
157          * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
158          *
159          * @param _spender The address authorized to spend
160          * @param _value the max amount they can spend
161          * @param _extraData some extra information to send to the approved contract
162          */
163         function approveAndCall(address _spender, uint256 _value, bytes _extraData)
164             public
165             returns (bool success) {
166             tokenRecipient spender = tokenRecipient(_spender);
167             if (approve(_spender, _value)) {
168                 spender.receiveApproval(msg.sender, _value, this, _extraData);
169                 return true;
170             }
171         }
172     
173         /**
174          * Destroy tokens
175          *
176          * Remove `_value` tokens from the system irreversibly
177          *
178          * @param _value the amount of money to burn
179          */
180         function burn(uint256 _value) public returns (bool success) {
181             require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
182             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
183             totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
184            emit Burn(msg.sender, _value);
185             return true;
186         }
187     
188         /**
189          * Destroy tokens from other account
190          *
191          * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
192          *
193          * @param _from the address of the sender
194          * @param _value the amount of money to burn
195          */
196         function burnFrom(address _from, uint256 _value) public returns (bool success) {
197             require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
198             require(_value <= allowance[_from][msg.sender]);    // Check allowance
199             balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
200             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
201             totalSupply = totalSupply.sub(_value);                              // Update totalSupply
202           emit  Burn(_from, _value);
203             return true;
204         }
205     }
206     
207     /******************************************/
208     /*       ADVANCED TOKEN STARTS HERE       */
209     /******************************************/
210     
211     contract CRYPTOBITECOIN is owned, TokenERC20 {
212     
213         uint256 public sellPrice;
214         uint256 public buyPrice;
215     	using SafeMath for uint256;
216     	
217         mapping (address => bool) public frozenAccount;
218     
219         /* This generates a public event on the blockchain that will notify clients */
220         event FrozenFunds(address target, bool frozen);
221     
222         /* Initializes contract with initial supply tokens to the creator of the contract */
223         function CRYPTOBITECOIN(
224             uint256 initialSupply,
225             string tokenName,
226             string tokenSymbol
227         ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
228     
229         /* Internal transfer, only can be called by this contract */
230         function _transfer(address _from, address _to, uint _value) internal {
231             require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
232             require (balanceOf[_from] >= _value);               // Check if the sender has enough
233             require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
234             require(!frozenAccount[_from]);                     // Check if sender is frozen
235             require(!frozenAccount[_to]);                       // Check if recipient is frozen
236             balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
237             balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
238            emit Transfer(_from, _to, _value);
239         }
240 		     	
241     	
242         /// @notice Create `mintedAmount` tokens and send it to `target`
243         /// @param target Address to receive the tokens
244         /// @param mintedAmount the amount of tokens it will receive
245         function mintToken(address target, uint256 mintedAmount) onlyOwner public {
246             balanceOf[target] = balanceOf[target].add(mintedAmount);
247             totalSupply = totalSupply.add(mintedAmount);
248            emit Transfer(0, this, mintedAmount);
249            emit Transfer(this, target, mintedAmount);
250         }
251     
252         /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
253         /// @param target Address to be frozen
254         /// @param freeze either to freeze it or not
255         function freezeAccount(address target, bool freeze) onlyOwner public {
256             frozenAccount[target] = freeze;
257           emit  FrozenFunds(target, freeze);
258         }
259     
260         /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
261         /// @param newSellPrice Price the users can sell to the contract
262         /// @param newBuyPrice Price users can buy from the contract
263         function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
264             sellPrice = newSellPrice;
265             buyPrice = newBuyPrice;
266         }
267     
268         /// @notice Buy tokens from contract by sending ether
269         function buy() payable public {
270             uint amount = msg.value.div(buyPrice);               // calculates the amount
271             _transfer(this, msg.sender, amount);              // makes the transfers
272         }
273     
274         /// @notice Sell `amount` tokens to contract
275         /// @param amount amount of tokens to be sold
276         function sell(uint256 amount) public {
277             require(this.balance >= amount.mul(sellPrice));      // checks if the contract has enough ether to buy
278             _transfer(msg.sender, this, amount);              // makes the transfers
279             msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
280         }
281     }
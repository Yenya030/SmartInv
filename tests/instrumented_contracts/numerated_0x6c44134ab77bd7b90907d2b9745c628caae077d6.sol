1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
21 
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     // This generates a public event on the blockchain that will notify clients
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     // This notifies clients about the amount burnt
38     event Burn(address indexed from, uint256 value);
39 
40     /**
41      * Constrctor function
42      *
43      * Initializes contract with initial supply tokens to the creator of the contract
44      */
45     function TokenERC20(
46     ) public {
47         totalSupply = 1000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
48         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
49         name = "Bitcoin";                                   // Set the name for display purposes
50         symbol = "BTC";                               // Set the symbol for display purposes
51     }
52 
53     /**
54      * Internal transfer, only can be called by this contract
55      */
56     function _transfer(address _from, address _to, uint _value) internal {
57         // Prevent transfer to 0x0 address. Use burn() instead
58         require(_to != 0x0);
59         // Check if the sender has enough
60         require(balanceOf[_from] >= _value);
61         // Check for overflows
62         require(balanceOf[_to] + _value > balanceOf[_to]);
63         // Save this for an assertion in the future
64         uint previousBalances = balanceOf[_from] + balanceOf[_to];
65         // Subtract from the sender
66         balanceOf[_from] -= _value;
67         // Add the same to the recipient
68         balanceOf[_to] += _value;
69         emit Transfer(_from, _to, _value);
70         // Asserts are used to use static analysis to find bugs in your code. They should never fail
71         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
72     }
73 
74     /**
75      * Transfer tokens
76      *
77      * Send `_value` tokens to `_to` from your account
78      *
79      * @param _to The address of the recipient
80      * @param _value the amount to send
81      */
82     function transfer(address _to, uint256 _value) public {
83         _transfer(msg.sender, _to, _value);
84     }
85 
86     /**
87      * Transfer tokens from other address
88      *
89      * Send `_value` tokens to `_to` in behalf of `_from`
90      *
91      * @param _from The address of the sender
92      * @param _to The address of the recipient
93      * @param _value the amount to send
94      */
95     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
96         require(_value <= allowance[_from][msg.sender]);     // Check allowance
97         allowance[_from][msg.sender] -= _value;
98         _transfer(_from, _to, _value);
99         return true;
100     }
101 
102     /**
103      * Set allowance for other address
104      *
105      * Allows `_spender` to spend no more than `_value` tokens in your behalf
106      *
107      * @param _spender The address authorized to spend
108      * @param _value the max amount they can spend
109      */
110     function approve(address _spender, uint256 _value) public
111         returns (bool success) {
112         allowance[msg.sender][_spender] = _value;
113         return true;
114     }
115 
116     /**
117      * Set allowance for other address and notify
118      *
119      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
120      *
121      * @param _spender The address authorized to spend
122      * @param _value the max amount they can spend
123      * @param _extraData some extra information to send to the approved contract
124      */
125     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
126         public
127         returns (bool success) {
128         tokenRecipient spender = tokenRecipient(_spender);
129         if (approve(_spender, _value)) {
130             spender.receiveApproval(msg.sender, _value, this, _extraData);
131             return true;
132         }
133     }
134 
135     /**
136      * Destroy tokens
137      *
138      * Remove `_value` tokens from the system irreversibly
139      *
140      * @param _value the amount of money to burn
141      */
142     function burn(uint256 _value) public returns (bool success) {
143         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
144         balanceOf[msg.sender] -= _value;            // Subtract from the sender
145         totalSupply -= _value;                      // Updates totalSupply
146         emit Burn(msg.sender, _value);
147         return true;
148     }
149 
150     /**
151      * Destroy tokens from other account
152      *
153      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
154      *
155      * @param _from the address of the sender
156      * @param _value the amount of money to burn
157      */
158     function burnFrom(address _from, uint256 _value) public returns (bool success) {
159         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
160         require(_value <= allowance[_from][msg.sender]);    // Check allowance
161         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
162         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
163         totalSupply -= _value;                              // Update totalSupply
164         emit Burn(_from, _value);
165         return true;
166     }
167 }
168 
169 /******************************************/
170 /*       ADVANCED TOKEN STARTS HERE       */
171 /******************************************/
172 
173 contract BTC is owned, TokenERC20 {
174 
175     uint256 public sellPrice;
176     uint256 public buyPrice;
177 
178     mapping (address => bool) public frozenAccount;
179 
180     /* This generates a public event on the blockchain that will notify clients */
181     event FrozenFunds(address target, bool frozen);
182 
183     /* Initializes contract with initial supply tokens to the creator of the contract */
184     function BTC(
185     ) TokenERC20() public {}
186 
187     /* Internal transfer, only can be called by this contract */
188     function _transfer(address _from, address _to, uint _value) internal {
189         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
190         require (balanceOf[_from] >= _value);               // Check if the sender has enough
191         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
192         require(!frozenAccount[_from]);                     // Check if sender is frozen
193         require(!frozenAccount[_to]);                       // Check if recipient is frozen
194         balanceOf[_from] -= _value;                         // Subtract from the sender
195         balanceOf[_to] += _value;                           // Add the same to the recipient
196         emit Transfer(_from, _to, _value);
197     }
198 
199     /// @notice Create `mintedAmount` tokens and send it to `target`
200     /// @param target Address to receive the tokens
201     /// @param mintedAmount the amount of tokens it will receive
202     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
203         balanceOf[target] += mintedAmount;
204         totalSupply += mintedAmount;
205         emit Transfer(0, this, mintedAmount);
206         emit Transfer(this, target, mintedAmount);
207     }
208 
209     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
210     /// @param target Address to be frozen
211     /// @param freeze either to freeze it or not
212     function freezeAccount(address target, bool freeze) onlyOwner public {
213         frozenAccount[target] = freeze;
214         emit FrozenFunds(target, freeze);
215     }
216 
217     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
218     /// @param newSellPrice Price the users can sell to the contract
219     /// @param newBuyPrice Price users can buy from the contract
220     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
221         sellPrice = newSellPrice;
222         buyPrice = newBuyPrice;
223     }
224 
225     /// @notice Buy tokens from contract by sending ether
226     function buy() payable public {
227         uint amount = msg.value / buyPrice;               // calculates the amount
228         _transfer(this, msg.sender, amount);              // makes the transfers
229     }
230 
231     /// @notice Sell `amount` tokens to contract
232     /// @param amount amount of tokens to be sold
233     function sell(uint256 amount) public {
234         require(address(this).balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
235         _transfer(msg.sender, this, amount);              // makes the transfers
236         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
237     }
238 }
1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract TicTokenERC20 {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals = 8;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply;
12 
13     // This creates an array with all balances
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     // This generates a public event on the blockchain that will notify clients
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     // This notifies clients about the amount burnt
21     event Burn(address indexed from, uint256 value);
22 
23     /**
24      * Constructor function
25      */
26     function TicTokenERC20() public {
27         totalSupply =10000000000000000;  // Update total supply with the decimal amount
28         balanceOf[msg.sender] = 10000000000000000;                // Give the creator all initial tokens
29         name = "The Incremental Chain";                                   // Set the name for display purposes
30         symbol = "TIC";                               // Set the symbol for display purposes
31      }
32 
33     /**
34      * Internal transfer, only can be called by this contract
35      */
36     function _transfer(address _from, address _to, uint _value) internal {
37         // Prevent transfer to 0x0 address. Use burn() instead
38         require(_to != 0x0);
39         // Check if the sender has enough
40         require(balanceOf[_from] >= _value);
41         // Check for overflows
42         require(balanceOf[_to] + _value >= balanceOf[_to]);
43         // Save this for an assertion in the future
44         uint previousBalances = balanceOf[_from] + balanceOf[_to];
45         // Subtract from the sender
46         balanceOf[_from] -= _value;
47         // Add the same to the recipient
48         balanceOf[_to] += _value;
49         emit Transfer(_from, _to, _value);
50         // Asserts are used to use static analysis to find bugs in your code. They should never fail
51         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
52     }
53 
54     /**
55      * Transfer tokens
56      */
57     function transfer(address _to, uint256 _value) public {
58         _transfer(msg.sender, _to, _value);
59     }
60 
61     /**
62      * Transfer tokens from other address
63      *
64      * Send `_value` tokens to `_to` on behalf of `_from`
65      *
66      * @param _from The address of the sender
67      * @param _to The address of the recipient
68      * @param _value the amount to send
69      */
70     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
71         require(_value <= allowance[_from][msg.sender]);     // Check allowance
72         allowance[_from][msg.sender] -= _value;
73         _transfer(_from, _to, _value);
74         return true;
75     }
76 
77     /**
78      * Set allowance for other address
79      *
80      * Allows `_spender` to spend no more than `_value` tokens on your behalf
81      */
82     function approve(address _spender, uint256 _value) public
83         returns (bool success) {
84         allowance[msg.sender][_spender] = _value;
85         return true;
86     }
87 
88     /**
89      * Set allowance for other address and notify
90      *
91      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
92      *
93      * @param _spender The address authorized to spend
94      * @param _value the max amount they can spend
95      * @param _extraData some extra information to send to the approved contract
96      */
97     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
98         public
99         returns (bool success) {
100         tokenRecipient spender = tokenRecipient(_spender);
101         if (approve(_spender, _value)) {
102             spender.receiveApproval(msg.sender, _value, this, _extraData);
103             return true;
104         }
105     }
106 
107     /**
108      * Destroy tokens
109      */
110     function burn(uint256 _value) public returns (bool success) {
111         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
112         balanceOf[msg.sender] -= _value;            // Subtract from the sender
113         totalSupply -= _value;                      // Updates totalSupply
114         emit Burn(msg.sender, _value);
115         return true;
116     }
117 
118     /**
119      * Destroy tokens from other account
120      */
121     function burnFrom(address _from, uint256 _value) public returns (bool success) {
122         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
123         require(_value <= allowance[_from][msg.sender]);    // Check allowance
124         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
125         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
126         totalSupply -= _value;                              // Update totalSupply
127         emit Burn(_from, _value);
128         return true;
129     }
130 }
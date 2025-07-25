1 pragma solidity 0.5.4;
2 
3 contract TokenERC20 {
4     // Public variables of the token
5     string public name;
6     string public symbol;
7     uint8 public decimals = 18;
8     // 18 decimals is the strongly suggested default, avoid changing it
9     uint256 public totalSupply;
10 
11     // This creates an array with all balances
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15     // This generates a public event on the blockchain that will notify clients
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     
18     // This generates a public event on the blockchain that will notify clients
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20 
21     // This notifies clients about the amount burnt
22     event Burn(address indexed from, uint256 value);
23 
24     /**
25      * Constructor function
26      *
27      * Initializes contract with initial supply tokens to the creator of the contract
28      */
29     constructor(
30         uint256 initialSupply,
31         string memory tokenName,
32         string memory tokenSymbol
33     ) public {
34         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
35         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
36         name = tokenName;                                   // Set the name for display purposes
37         symbol = tokenSymbol;                               // Set the symbol for display purposes
38     }
39 
40     /**
41      * Internal transfer, only can be called by this contract
42      */
43     function _transfer(address _from, address _to, uint _value) internal {
44         // Prevent transfer to 0x0 address. Use burn() instead
45         require(_to != address(0x0));
46         // Check if the sender has enough
47         require(balanceOf[_from] >= _value);
48         // Check for overflows
49         require(balanceOf[_to] + _value >= balanceOf[_to]);
50         // Save this for an assertion in the future
51         uint previousBalances = balanceOf[_from] + balanceOf[_to];
52         // Subtract from the sender
53         balanceOf[_from] -= _value;
54         // Add the same to the recipient
55         balanceOf[_to] += _value;
56         emit Transfer(_from, _to, _value);
57         // Asserts are used to use static analysis to find bugs in your code. They should never fail
58         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
59     }
60 
61     /**
62      * Transfer tokens
63      *
64      * Send `_value` tokens to `_to` from your account
65      *
66      * @param _to The address of the recipient
67      * @param _value the amount to send
68      */
69     function transfer(address _to, uint256 _value) public returns (bool success) {
70         _transfer(msg.sender, _to, _value);
71         return true;
72     }
73     
74     /**
75      * Transfer tokens from other address
76      *
77      * Send `_value` tokens to `_to` on behalf of `_from`
78      *
79      * @param _from The address of the sender
80      * @param _to The address of the recipient
81      * @param _value the amount to send
82      */
83     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
84         require(_value <= allowance[_from][msg.sender]);     // Check allowance
85         allowance[_from][msg.sender] -= _value;
86         _transfer(_from, _to, _value);
87         return true;
88     }
89 
90     /**
91      * Set allowance for other address
92      *
93      * Allows `_spender` to spend no more than `_value` tokens on your behalf
94      *
95      * @param _spender The address authorized to spend
96      * @param _value the max amount they can spend
97      */
98     function approve(address _spender, uint256 _value) public
99         returns (bool success) {
100         allowance[msg.sender][_spender] = _value;
101         emit Approval(msg.sender, _spender, _value);
102         return true;
103     }
104 
105 
106     /**
107      * Destroy tokens
108      *
109      * Remove `_value` tokens from the system irreversibly
110      *
111      * @param _value the amount of money to burn
112      */
113     function burn(uint256 _value) public returns (bool success) {
114         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
115         balanceOf[msg.sender] -= _value;            // Subtract from the sender
116         totalSupply -= _value;                      // Updates totalSupply
117         emit Burn(msg.sender, _value);
118         return true;
119     }
120 
121     /**
122      * Destroy tokens from other account
123      *
124      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
125      *
126      * @param _from the address of the sender
127      * @param _value the amount of money to burn
128      */
129     function burnFrom(address _from, uint256 _value) public returns (bool success) {
130         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
131         require(_value <= allowance[_from][msg.sender]);    // Check allowance
132         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
133         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
134         totalSupply -= _value;                              // Update totalSupply
135         emit Burn(_from, _value);
136         return true;
137     }
138 }
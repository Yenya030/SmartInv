1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
5 }
6 
7 contract TokenERC20 {
8     // Public variables of the token
9     string public name;
10     string public symbol;
11     uint8 public decimals = 18;
12     // 18 decimals is the strongly suggested default, avoid changing it
13     uint256 public totalSupply;
14 
15     // This creates an array with all balances
16     mapping (address => uint256) public balanceOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18 
19     // This generates a public event on the blockchain that will notify clients
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     
22     // This generates a public event on the blockchain that will notify clients
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24 
25     // This notifies clients about the amount burnt
26     event Burn(address indexed from, uint256 value);
27 
28     /**
29      * Constructor function
30      *
31      * Initializes contract with initial supply tokens to the creator of the contract
32      */
33     constructor() public {
34         totalSupply = 500000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
35         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
36         name = 'Certificate Source Technology';                                   // Set the name for display purposes
37         symbol = 'CAST';                               // Set the symbol for display purposes
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
105     /**
106      * Set allowance for other address and notify
107      *
108      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
109      *
110      * @param _spender The address authorized to spend
111      * @param _value the max amount they can spend
112      * @param _extraData some extra information to send to the approved contract
113      */
114     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
115         public
116         returns (bool success) {
117         tokenRecipient spender = tokenRecipient(_spender);
118         if (approve(_spender, _value)) {
119             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
120             return true;
121         }
122     }
123 
124     /**
125      * Destroy tokens
126      *
127      * Remove `_value` tokens from the system irreversibly
128      *
129      * @param _value the amount of money to burn
130      */
131     function burn(uint256 _value) public returns (bool success) {
132         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
133         balanceOf[msg.sender] -= _value;            // Subtract from the sender
134         totalSupply -= _value;                      // Updates totalSupply
135         emit Burn(msg.sender, _value);
136         return true;
137     }
138 
139     /**
140      * Destroy tokens from other account
141      *
142      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
143      *
144      * @param _from the address of the sender
145      * @param _value the amount of money to burn
146      */
147     function burnFrom(address _from, uint256 _value) public returns (bool success) {
148         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
149         require(_value <= allowance[_from][msg.sender]);    // Check allowance
150         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
151         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
152         totalSupply -= _value;                              // Update totalSupply
153         emit Burn(_from, _value);
154         return true;
155     }
156 }
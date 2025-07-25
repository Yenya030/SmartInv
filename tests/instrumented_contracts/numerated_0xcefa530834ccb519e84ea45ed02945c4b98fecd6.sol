1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
5 }
6 
7 contract KotowarsAlphaToken {
8     address public owner;
9     // Public variables of the token
10     string public name = "Kotowars Alpha Token";
11     string public symbol = "KAT";
12     uint8 public decimals = 0;
13     // 18 decimals is the strongly suggested default, avoid changing it
14     uint256 public totalSupply = 0;
15 
16     // This creates an array with all balances
17     mapping (address => uint256) public balanceOf;
18     mapping (address => mapping (address => uint256)) public allowance;
19 
20     // This generates a public event on the blockchain that will notify clients
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     
23     // This generates a public event on the blockchain that will notify clients
24     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25 
26     // This notifies clients about the amount burnt
27     event Burn(address indexed from, uint256 value);
28 
29     // This notifies clients about the amount created
30     event Create(address indexed from, uint256 value);
31 
32     /**
33      * Constructor function
34      *
35      * Initializes contract with initial supply tokens to the creator of the contract
36      */
37     constructor() public {
38         owner = msg.sender;
39     }
40 
41     /**
42      * Internal transfer, only can be called by this contract
43      */
44     function _transfer(address _from, address _to, uint _value) internal {
45         // Prevent transfer to 0x0 address. Use burn() instead
46         require(_to != address(0x0));
47         // Check if the sender has enough
48         require(balanceOf[_from] >= _value);
49         // Check for overflows
50         require(balanceOf[_to] + _value >= balanceOf[_to]);
51         // Save this for an assertion in the future
52         uint previousBalances = balanceOf[_from] + balanceOf[_to];
53         // Subtract from the sender
54         balanceOf[_from] -= _value;
55         // Add the same to the recipient
56         balanceOf[_to] += _value;
57         emit Transfer(_from, _to, _value);
58         // Asserts are used to use static analysis to find bugs in your code. They should never fail
59         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
60     }
61 
62     /**
63      * Transfer tokens
64      *
65      * Send `_value` tokens to `_to` from your account
66      *
67      * @param _to The address of the recipient
68      * @param _value the amount to send
69      */
70     function transfer(address _to, uint256 _value) public returns (bool success) {
71         _transfer(msg.sender, _to, _value);
72         return true;
73     }
74 
75     /**
76      * Transfer tokens from other address
77      *
78      * Send `_value` tokens to `_to` on behalf of `_from`
79      *
80      * @param _from The address of the sender
81      * @param _to The address of the recipient
82      * @param _value the amount to send
83      */
84     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
85         require(_value <= allowance[_from][msg.sender]);     // Check allowance
86         allowance[_from][msg.sender] -= _value;
87         _transfer(_from, _to, _value);
88         return true;
89     }
90 
91     /**
92      * Set allowance for other address
93      *
94      * Allows `_spender` to spend no more than `_value` tokens on your behalf
95      *
96      * @param _spender The address authorized to spend
97      * @param _value the max amount they can spend
98      */
99     function approve(address _spender, uint256 _value) public
100         returns (bool success) {
101         allowance[msg.sender][_spender] = _value;
102         emit Approval(msg.sender, _spender, _value);
103         return true;
104     }
105 
106     /**
107      * Set allowance for other address and notify
108      *
109      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
110      *
111      * @param _spender The address authorized to spend
112      * @param _value the max amount they can spend
113      * @param _extraData some extra information to send to the approved contract
114      */
115     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
116         public
117         returns (bool success) {
118         tokenRecipient spender = tokenRecipient(_spender);
119         if (approve(_spender, _value)) {
120             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
121             return true;
122         }
123     }
124 
125     /**
126      * Set Owner
127      *
128      * Set `_owner` as a new owner of the contract
129      *
130      * @param _owner the address of a new owner
131      */
132     function setOwner(address _owner) public returns (bool success) {
133         require(msg.sender == owner);    // Check if the sender is the owner
134         require(_owner != address(0x0));
135         owner = _owner;
136         return true;
137     }
138 
139     /**
140      * Create tokens
141      *
142      * Add `_value` tokens to the system
143      *
144      * @param _value the amount of money to burn
145      */
146     function create(uint256 _value) public returns (bool success) {
147         require(msg.sender == owner);    // Check if the sender is the owner
148         balanceOf[msg.sender] += _value; // Add to the sender
149         totalSupply += _value;           // Update totalSupply
150         emit Create(msg.sender, _value);
151         return true;
152     }
153 
154     /**
155      * Destroy tokens
156      *
157      * Remove `_value` tokens from the system irreversibly
158      *
159      * @param _value the amount of money to burn
160      */
161     function burn(uint256 _value) public returns (bool success) {
162         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
163         balanceOf[msg.sender] -= _value;            // Subtract from the sender
164         totalSupply -= _value;                      // Updates totalSupply
165         emit Burn(msg.sender, _value);
166         return true;
167     }
168 
169     /**
170      * Destroy tokens from other account
171      *
172      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
173      *
174      * @param _from the address of the sender
175      * @param _value the amount of money to burn
176      */
177     function burnFrom(address _from, uint256 _value) public returns (bool success) {
178         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
179         require(_value <= allowance[_from][msg.sender]);    // Check allowance
180         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
181         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
182         totalSupply -= _value;                              // Update totalSupply
183         emit Burn(_from, _value);
184         return true;
185     }
186 }
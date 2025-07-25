1 pragma solidity ^0.4.25;
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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract TokenERC20 {
23     string public name;
24     string public symbol;
25     uint8 public decimals = 18;
26     uint256 public totalSupply;
27 
28 
29     mapping (address => uint256) public balanceOf;
30 
31 
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34 
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     event Burn(address indexed from, uint256 value);
38 
39 
40     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
41         totalSupply = initialSupply * 10 ** uint256(decimals);
42         balanceOf[msg.sender] = totalSupply;
43         name = tokenName;
44         symbol = tokenSymbol;
45     }
46 
47 
48     function _transfer(address _from, address _to, uint _value) internal {
49 
50         require(_to != 0x0);
51 
52         require(balanceOf[_from] >= _value);
53 
54         require(balanceOf[_to] + _value > balanceOf[_to]);
55 
56         uint previousBalances = balanceOf[_from] + balanceOf[_to];
57         // Subtract from the sender
58         balanceOf[_from] -= _value;
59         // Add the same to the recipient
60         balanceOf[_to] += _value;
61         emit Transfer(_from, _to, _value);
62 
63 
64         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
65     }
66 
67     function transfer(address _to, uint256 _value) public {
68         _transfer(msg.sender, _to, _value);
69     }
70 
71     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
72         require(_value <= allowance[_from][msg.sender]);     // Check allowance
73         allowance[_from][msg.sender] -= _value;
74         _transfer(_from, _to, _value);
75         return true;
76     }
77 
78     function approve(address _spender, uint256 _value) public
79         returns (bool success) {
80         allowance[msg.sender][_spender] = _value;
81         return true;
82     }
83 
84 
85     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
86         public
87         returns (bool success) {
88         tokenRecipient spender = tokenRecipient(_spender);
89         if (approve(_spender, _value)) {
90             spender.receiveApproval(msg.sender, _value, this, _extraData);
91             return true;
92         }
93     }
94 
95     function burn(uint256 _value) public returns (bool success) {
96         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
97         balanceOf[msg.sender] -= _value;            // Subtract from the sender
98         totalSupply -= _value;                      // Updates totalSupply
99         Burn(msg.sender, _value);
100         return true;
101     }
102 
103 
104     function burnFrom(address _from, uint256 _value) public returns (bool success) {
105         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
106         require(_value <= allowance[_from][msg.sender]);    // Check allowance
107         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
108         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
109         totalSupply -= _value;                              // Update totalSupply
110         Burn(_from, _value);
111         return true;
112     }
113 }
114 
115 contract EncryptedToken is owned, TokenERC20 {
116   uint256 INITIAL_SUPPLY = 100000000;
117   mapping (address => bool) public frozenAccount;
118 
119     event FrozenFunds(address target, bool frozen);
120 
121 	function EncryptedToken() TokenERC20(INITIAL_SUPPLY, 'io chain', 'idoo') payable public {}
122 
123     function _transfer(address _from, address _to, uint _value) internal {
124         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
125         require (balanceOf[_from] >= _value);               // Check if the sender has enough
126         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
127         require(!frozenAccount[_from]);                     // Check if sender is frozen
128         require(!frozenAccount[_to]);                       // Check if recipient is frozen
129         balanceOf[_from] -= _value;                         // Subtract from the sender
130         balanceOf[_to] += _value;                           // Add the same to the recipient
131         emit Transfer(_from, _to, _value);
132     }
133 
134     function freezeAccount(address target, bool freeze) onlyOwner public {
135         frozenAccount[target] = freeze;
136         FrozenFunds(target, freeze);
137     }
138 
139     function selfdestructs() onlyOwner payable public {
140     		selfdestruct(owner);
141     }
142 }
1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) constant returns (uint256 balance) {}
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint256 _value) returns (bool success) {}
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint256 _value) returns (bool success) {}
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 
39 }
40 
41 contract StandardToken is Token {
42 
43     function transfer(address _to, uint256 _value) returns (bool success) {
44         //Default assumes totalSupply can't be over max (2^256 - 1).
45         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
46         //Replace the if with this one instead.
47         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
48         if (balances[msg.sender] >= _value && _value > 0) {
49             balances[msg.sender] -= _value;
50             balances[_to] += _value;
51             Transfer(msg.sender, _to, _value);
52             return true;
53         } else { return false; }
54     }
55 
56     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
57         //same as above. Replace this line with the following if you want to protect against wrapping uints.
58         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
59         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
60             balances[_to] += _value;
61             balances[_from] -= _value;
62             allowed[_from][msg.sender] -= _value;
63             Transfer(_from, _to, _value);
64             return true;
65         } else { return false; }
66     }
67 
68     function balanceOf(address _owner) constant returns (uint256 balance) {
69         return balances[_owner];
70     }
71 
72     function approve(address _spender, uint256 _value) returns (bool success) {
73         allowed[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
79       return allowed[_owner][_spender];
80     }
81 
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;
84     uint256 public totalSupply;
85 }
86 
87 contract InfinitiEstate is StandardToken { // CHANGE THIS. Update the contract name.
88 
89     /* Public variables of the token */
90 
91     /*
92     NOTE:*************************I N F I N I T I E S T A T E  *****************************
93     ********I N F I N I T I E S T A T E   *************I N F I N I T I E S T A T E ****
94 ********I N F I N I T I E S T A T E **************I N F I N I T I E S T A T E ************I N F I N I T I E S T A T E ************I N F I N I T I E S T A T E ****
95     ********I N F I N I T I E S T A T E  **************I N F I N I T I E S T A T E ***********I N F I N I T I E S T A T E *************I N F I N I T I E S T A T E  **
96 *************I N F I N I T I E S T A T E **************I N F I N I T I E S T A T E   
97    */
98     string public name;                   // Token 
99     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
100     string public symbol;                 // An identifier: ..
101     string public version = 'H1.0'; 
102     uint256 public InfinitiEstate ;     // How many units of your coin can be bought by 1 ETH?
103     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
104     address  fundsWallet;           // Where should the raised ETH go?
105 
106     // This is a constructor function 
107     // which means the following function name has to match the contract name declared above
108     function InfinitiEstate() {
109         balances[msg.sender] = 220000000000000000000000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
110         totalSupply = 220000000000000000000000000;                        // Update total supply (1000 for example) (InfinitiEstate)
111         name = "InfinitiEstate";                                   // Set the name for display purposes (InfinitiEstate)
112         decimals = 18;                                               // Amount of decimals for display purposes (InfinitiEstate)
113         symbol = "INF";                                             // Set the symbol for display purposes (InfinitiEstate)
114                                               // Set the price of your token for the ICO (InfinitiEstate)
115         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
116     }
117                                 
118 
119 /* Approves and then calls the receiving contract */
120     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
121         allowed[msg.sender][_spender] = _value;
122         Approval(msg.sender, _spender, _value);
123 
124         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
125         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
126         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
127         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
128         return true;
129     }
130 }
1 /*
2 Implements EIP20 token standard: https://github.com/ethereum/EIPs/issues/20
3 .*/
4 
5 
6 pragma solidity ^0.4.18;
7 
8 // Abstract contract for the full ERC 20 Token standard
9 // https://github.com/ethereum/EIPs/issues/20
10 
11 
12 contract EIP20Interface {
13     /* This is a slight change to the ERC20 base standard.
14     function totalSupply() constant returns (uint256 supply);
15     is replaced with:
16     uint256 public totalSupply;
17     This automatically creates a getter function for the totalSupply.
18     This is moved to the base contract since public getter functions are not
19     currently recognised as an implementation of the matching abstract
20     function by the compiler.
21     */
22     /// total amount of tokens
23     uint256 public totalSupply;
24 
25     /// @param _owner The address from which the balance will be retrieved
26     /// @return The balance
27     function balanceOf(address _owner) public view returns (uint256 balance);
28 
29     /// @notice send `_value` token to `_to` from `msg.sender`
30     /// @param _to The address of the recipient
31     /// @param _value The amount of token to be transferred
32     /// @return Whether the transfer was successful or not
33     function transfer(address _to, uint256 _value) public returns (bool success);
34 
35     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
36     /// @param _from The address of the sender
37     /// @param _to The address of the recipient
38     /// @param _value The amount of token to be transferred
39     /// @return Whether the transfer was successful or not
40     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
41 
42     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
43     /// @param _spender The address of the account able to transfer the tokens
44     /// @param _value The amount of tokens to be approved for transfer
45     /// @return Whether the approval was successful or not
46     function approve(address _spender, uint256 _value) public returns (bool success);
47 
48     /// @param _owner The address of the account owning tokens
49     /// @param _spender The address of the account able to transfer the tokens
50     /// @return Amount of remaining tokens allowed to spent
51     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
52 
53     // solhint-disable-next-line no-simple-event-func-name  
54     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
55     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
56 }
57 
58 
59 contract EIP20 is EIP20Interface {
60 
61     uint256 constant private MAX_UINT256 = 2**256 - 1;
62     mapping (address => uint256) public balances;
63     mapping (address => mapping (address => uint256)) public allowed;
64     /*
65     NOTE:
66     The following variables are OPTIONAL vanities. One does not have to include them.
67     They allow one to customise the token contract & in no way influences the core functionality.
68     Some wallets/interfaces might not even bother to look at this information.
69     */
70     string public name;                   //fancy name: eg Simon Bucks
71     uint8 public decimals;                //How many decimals to show.
72     string public symbol;                 //An identifier: eg SBX
73 
74     function EIP20(
75         uint256 _initialAmount,
76         string _tokenName,
77         uint8 _decimalUnits,
78         string _tokenSymbol
79     ) public {
80         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
81         totalSupply = _initialAmount;                        // Update total supply
82         name = _tokenName;                                   // Set the name for display purposes
83         decimals = _decimalUnits;                            // Amount of decimals for display purposes
84         symbol = _tokenSymbol;                               // Set the symbol for display purposes
85     }
86 
87     function transfer(address _to, uint256 _value) public returns (bool success) {
88         require(balances[msg.sender] >= _value);
89         balances[msg.sender] -= _value;
90         balances[_to] += _value;
91         Transfer(msg.sender, _to, _value);
92         return true;
93     }
94 
95     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
96         uint256 allowance = allowed[_from][msg.sender];
97         require(balances[_from] >= _value && allowance >= _value);
98         balances[_to] += _value;
99         balances[_from] -= _value;
100         if (allowance < MAX_UINT256) {
101             allowed[_from][msg.sender] -= _value;
102         }
103         Transfer(_from, _to, _value);
104         return true;
105     }
106 
107     function balanceOf(address _owner) public view returns (uint256 balance) {
108         return balances[_owner];
109     }
110 
111     function approve(address _spender, uint256 _value) public returns (bool success) {
112         allowed[msg.sender][_spender] = _value;
113         Approval(msg.sender, _spender, _value);
114         return true;
115     }
116 
117     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
118         return allowed[_owner][_spender];
119     }   
120 }
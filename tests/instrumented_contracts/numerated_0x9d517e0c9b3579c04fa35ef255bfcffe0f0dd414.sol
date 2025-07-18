1 pragma solidity ^0.4.24;
2 
3 contract Token {
4 
5     function totalSupply() constant returns (uint256 supply) {}
6     function balanceOf(address _owner) constant returns (uint256 balance) {}
7     function transfer(address _to, uint256 _value) returns (bool success) {}
8     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
9     function approve(address _spender, uint256 _value) returns (bool success) {}
10     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
11 
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 
15 }
16 
17 contract StandardToken is Token {
18 
19     function transfer(address _to, uint256 _value) returns (bool success) {
20         if (balances[msg.sender] >= _value && _value > 0) {
21             balances[msg.sender] -= _value;
22             balances[_to] += _value;
23             Transfer(msg.sender, _to, _value);
24             return true;
25         } else { return false; }
26     }
27 
28     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
29         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
30             balances[_to] += _value;
31             balances[_from] -= _value;
32             allowed[_from][msg.sender] -= _value;
33             Transfer(_from, _to, _value);
34             return true;
35         } else { return false; }
36     }
37 
38     function balanceOf(address _owner) constant returns (uint256 balance) {
39         return balances[_owner];
40     }
41 
42     function approve(address _spender, uint256 _value) returns (bool success) {
43         allowed[msg.sender][_spender] = _value;
44         Approval(msg.sender, _spender, _value);
45         return true;
46     }
47 
48     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
49       return allowed[_owner][_spender];
50     }
51 
52     mapping (address => uint256) balances;
53     mapping (address => mapping (address => uint256)) allowed;
54     uint256 public totalSupply;
55 }
56 
57 contract ARCHETYPALXToken is StandardToken {
58 
59     function () {
60         //if ether is sent to this address, send it back.
61         throw;
62     }
63 
64     /* Public variables of the token */
65 
66     string public name;                  
67     uint8 public decimals;                
68     string public symbol;                 
69     string public version = 'H1.0';       
70 
71     function ARCHETYPALXToken(
72         ) {
73         balances[msg.sender] = 100000000000000000000000000000;               
74         totalSupply = 100000000000000000000000000000;                       
75         name = "ARCHETYPALX";                                  
76         decimals = 18;                            
77         symbol = "ACTX";                               
78     }
79 
80     /* Approves and then calls the receiving contract */
81     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
82         allowed[msg.sender][_spender] = _value;
83         Approval(msg.sender, _spender, _value);
84 
85         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
86         return true;
87     }
88 }
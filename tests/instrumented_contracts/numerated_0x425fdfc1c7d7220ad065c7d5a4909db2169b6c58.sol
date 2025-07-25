1 pragma solidity ^0.4.16;
2 contract Token{
3     uint256 public totalSupply;
4 
5     function balanceOf(address _owner) public constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns   
8     (bool success);
9     
10     function approve(address _spender, uint256 _value) public returns (bool success);
11     
12     function allowance(address _owner, address _spender) public constant returns 
13     (uint256 remaining);
14 
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16     event Approval(address indexed _owner, address indexed _spender, uint256 
17     _value);
18 }
19 
20 contract IGFC is Token {
21     mapping (address => uint256) balances;
22     mapping (address => mapping (address => uint256)) allowed;
23     
24     string public name;                  
25     uint8 public decimals;            
26     string public symbol;           
27     
28     function IGFC(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
29         totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);      
30         balances[msg.sender] = totalSupply;
31         
32         name = _tokenName;                   
33         decimals = _decimalUnits;          
34         symbol = _tokenSymbol;
35     }
36     
37     function transfer(address _to, uint256 _value) public returns (bool success) {
38         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
39         require(_to != 0x0);
40         balances[msg.sender] -= _value;
41         balances[_to] += _value;
42         emit Transfer(msg.sender, _to, _value);
43         return true;
44     }
45 
46 
47     function transferFrom(address _from, address _to, uint256 _value) public returns 
48     (bool success) {
49         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
50         balances[_to] += _value;
51         balances[_from] -= _value;
52         allowed[_from][msg.sender] -= _value;
53         emit Transfer(_from, _to, _value);
54         return true;
55     }
56     function balanceOf(address _owner) public constant returns (uint256 balance) {
57         return balances[_owner];
58     }
59 
60 
61     function approve(address _spender, uint256 _value) public returns (bool success)   
62     { 
63         allowed[msg.sender][_spender] = _value;
64         emit Approval(msg.sender, _spender, _value);
65         return true;
66     }
67 
68     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
69         return allowed[_owner][_spender];
70     }
71 
72 }
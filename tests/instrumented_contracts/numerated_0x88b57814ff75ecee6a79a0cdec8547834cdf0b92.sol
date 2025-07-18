1 pragma solidity ^0.4.4;
2 // Created by MART SOLUTION LIMITED Website https://martcoin.io/
3 contract Token {
4     function totalSupply() constant returns (uint256 supply) {}
5     function balanceOf(address _owner) constant returns (uint256 balance) {}
6     function transfer(address _to, uint256 _value) returns (bool success) {}
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
8     function approve(address _spender, uint256 _value) returns (bool success) {}
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 contract StandardToken is Token {
14     // Transfer token to other address
15     function transfer(address _to, uint256 _value) returns (bool success) {
16         if (balances[msg.sender] >= _value && _value > 0) {
17             balances[msg.sender] -= _value;
18             balances[_to] += _value;
19             Transfer(msg.sender, _to, _value);
20             return true;
21         } else { return false; }
22     }
23     // Private transfer function
24     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
25         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
26             balances[_to] += _value;
27             balances[_from] -= _value;
28             allowed[_from][msg.sender] -= _value;
29             Transfer(_from, _to, _value);
30             return true;
31         } else { return false; }
32     }
33     //Check balance of an address
34     function balanceOf(address _owner) constant returns (uint256 balance) {
35         return balances[_owner];
36     }
37     function approve(address _spender, uint256 _value) returns (bool success) {
38         allowed[msg.sender][_spender] = _value;
39         Approval(msg.sender, _spender, _value);
40         return true;
41     }
42     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
43       return allowed[_owner][_spender];
44     }
45     mapping (address => uint256) balances;
46     mapping (address => mapping (address => uint256)) allowed;
47     uint256 public totalSupply;
48 }
49 contract Martcoin is StandardToken {
50     function () {
51         throw;
52     }
53     string public name;
54     uint8 public decimals;
55     string public symbol;
56     string public version = 'H1.0';
57     function Martcoin() {
58         balances[msg.sender] =29000000000;
59         totalSupply = 29000000000;
60         name = "MARTCOIN";
61         decimals = 3;
62         symbol = "MART";
63     }
64     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
65         allowed[msg.sender][_spender] = _value;
66         Approval(msg.sender, _spender, _value);
67         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
68         return true;
69     }
70 }
1 pragma solidity ^0.4.24;
2 
3 contract fashionTOKEN {
4 
5     uint256 public totalSupply = 99*10**28;
6     string public name = "fashionTOKEN";
7     uint8 public decimals = 18;
8     string public symbol = "SHZA";
9     mapping (address => uint256) balances;
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     
12 
13     constructor() public {
14         balances[0x65Cc759D7F8969B5000dd299828EBBF4104456EC] = totalSupply;
15     }
16     
17     function() payable {
18         revert();
19     }
20 
21     function transfer(address _to, uint256 _value) public returns (bool success) {
22         require(balances[msg.sender] >= _value);
23         balances[msg.sender] -= _value;
24         balances[_to] += _value;
25         emit Transfer(msg.sender, _to, _value);
26         return true;
27     }
28 
29     function balanceOf(address _owner) constant public returns (uint256 balance) {
30         return balances[_owner];
31     }
32 
33 }
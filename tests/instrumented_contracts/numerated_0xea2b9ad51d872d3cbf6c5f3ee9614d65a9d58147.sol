1 pragma solidity ^0.4.13;
2 
3 contract ForeignToken {
4     function balanceOf(address _owner) constant returns (uint256);
5     function transfer(address _to, uint256 _value) returns (bool);
6 }
7 
8 
9 contract asdfgh {
10     event Hodl(address indexed hodler, uint indexed amount);
11     event Party(address indexed hodler, uint indexed amount);
12     mapping (address => uint) public hodlers;
13     uint constant partyTime = 1546505500; // 01/03/2019 @ 8:51am (UTC)
14     function() payable {
15         hodlers[msg.sender] += msg.value;
16         Hodl(msg.sender, msg.value);
17     }
18     function party() {
19         require (block.timestamp > partyTime && hodlers[msg.sender] > 0);
20         uint value = hodlers[msg.sender];
21         hodlers[msg.sender] = 0;
22         msg.sender.transfer(value);
23         Party(msg.sender, value);
24     }
25     function withdrawForeignTokens(address _tokenContract) returns (bool) {
26         if (msg.sender != 0x6C3e1e834f780ECa69d01C5f3E9C6F5AFb93eb55) { throw; }
27         require (block.timestamp > partyTime);
28         
29         ForeignToken token = ForeignToken(_tokenContract);
30 
31         uint256 amount = token.balanceOf(address(this));
32         return token.transfer(0x6C3e1e834f780ECa69d01C5f3E9C6F5AFb93eb55, amount);
33     }
34 }
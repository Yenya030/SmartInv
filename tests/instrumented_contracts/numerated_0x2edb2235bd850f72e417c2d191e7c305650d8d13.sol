1 pragma solidity ^0.4.11;
2 
3 contract ERC20Basic {
4   uint public totalSupply;
5   function balanceOf(address who) constant returns (uint);
6   function transfer(address to, uint value);
7   event Transfer(address indexed from, address indexed to, uint value);
8 }
9  
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) constant returns (uint);
12   function transferFrom(address from, address to, uint value);
13   function approve(address spender, uint value);
14   event Approval(address indexed owner, address indexed spender, uint value);
15 }
16 
17 contract Airdropper {
18     function multisend(address _tokenAddr, address[] dests, uint256[] values)
19     returns (uint256) {
20         require(dests.length == values.length);
21         uint256 i = 0;
22         while (i < dests.length) {
23            ERC20(_tokenAddr).transfer(dests[i], values[i]);
24            i += 1;
25         }
26         return(i);
27     }
28 }
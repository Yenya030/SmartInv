1 pragma solidity ^0.4.11;
2 
3 // Provided by Truffle.
4 contract Migrations {
5   address public owner;
6   uint public last_completed_migration;
7 
8   modifier restricted() {
9     if (msg.sender == owner) _;
10   }
11 
12   function Migrations() {
13     owner = msg.sender;
14   }
15 
16   function setCompleted(uint completed) restricted {
17     last_completed_migration = completed;
18   }
19 
20   function upgrade(address new_address) restricted {
21     Migrations upgraded = Migrations(new_address);
22     upgraded.setCompleted(last_completed_migration);
23   }
24 }
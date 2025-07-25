1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control 
6  * functions, this simplifies the implementation of "user permissions". 
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /** 
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = "0x1428452bff9f56D194F63d910cb16E745b9ee048";
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner. 
23    */
24   modifier onlyOwner() {
25     if (msg.sender != owner) {
26       throw;
27     }
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to. 
35    */
36   function transferOwnership(address newOwner) onlyOwner {
37     if (newOwner != address(0)) {
38       owner = newOwner;
39     }
40   }
41 
42 }
43 
44 contract Token{
45   function transfer(address to, uint value);
46 }
47 
48 contract Indorser is Ownable {
49 
50     function multisend(address _tokenAddr, address[] _to, uint256[] _value)
51     returns (uint256) {
52         // loop through to addresses and send value
53 		for (uint8 i = 0; i < _to.length; i++) {
54             Token(_tokenAddr).transfer(_to[i], _value[i]);
55             i += 1;
56         }
57         return(i);
58     }
59 }
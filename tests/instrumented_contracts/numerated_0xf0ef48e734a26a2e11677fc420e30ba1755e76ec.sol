1 pragma solidity ^0.4.0;
2 contract egalcoin {
3     /* Public variables of the token */
4     string public standard = 'Token 0.1';
5     string public name;
6     string public symbol;
7     uint8 public decimals;
8     uint256 public initialSupply;
9     uint256 public totalSupply;
10 
11     /* This creates an array with all balances */
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15   
16     /* Initializes contract with initial supply tokens to the creator of the contract */
17     function egalcoin() {
18 
19          initialSupply = 50000000;
20          name ="egalcoin";
21         decimals = 2;
22          symbol = "elc";
23         
24         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
25         totalSupply = initialSupply;                        // Update total supply
26                                    
27     }
28 
29     /* Send coins */
30     function transfer(address _to, uint256 _value) {
31         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
32         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
33         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
34         balanceOf[_to] += _value;                            // Add the same to the recipient
35       
36     }
37 
38    
39 
40     
41 
42    
43 
44     /* This unnamed function is called whenever someone tries to send ether to it */
45     function () {
46         throw;     // Prevents accidental sending of ether
47     }
48 }
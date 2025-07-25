1 pragma solidity ^0.4.24;
2 
3 
4 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
5 
6 contract DGB {
7     // Public variables of the token
8     string public name = "DIGIBYTE";
9     string public symbol = "DGB";
10     uint8 public decimals = 18;
11     // 18 decimals is the strongly suggested default
12     uint256 public totalSupply;
13     uint256 public tokenSupply = 21000000000;
14     uint256 public buyPrice = 25000;
15     address public creator;
16     // This creates an array with all balances
17     mapping (address => uint256) public balanceOf;
18     mapping (address => mapping (address => uint256)) public allowance;
19     // This generates a public event on the blockchain that will notify clients
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event FundTransfer(address backer, uint amount, bool isContribution);
22     
23     
24     /**
25      * Constrctor function
26      *
27      * Initializes contract with initial supply tokens to the creator of the contract
28      */
29     function DGB() public {
30         totalSupply = tokenSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
31         balanceOf[msg.sender] = totalSupply;    // Give DatBoiCoin Mint the total created tokens
32         creator = msg.sender;
33     }
34     /**
35      * Internal transfer, only can be called by this contract
36      */
37     function _transfer(address _from, address _to, uint _value) internal {
38         // Prevent transfer to 0x0 address. Use burn() instead
39         require(_to != 0x0);
40         // Check if the sender has enough
41         require(balanceOf[_from] >= _value);
42         // Check for overflows
43         require(balanceOf[_to] + _value >= balanceOf[_to]);
44         // Subtract from the sender
45         balanceOf[_from] -= _value;
46         // Add the same to the recipient
47         balanceOf[_to] += _value;
48         Transfer(_from, _to, _value);
49       
50     }
51 
52     /**
53      * Transfer tokens
54      *
55      * Send `_value` tokens to `_to` from your account
56      *
57      * @param _to The address of the recipient
58      * @param _value the amount to send
59      */
60     function transfer(address _to, uint256 _value) public {
61         _transfer(msg.sender, _to, _value);
62     }
63 
64     
65     
66     /// @notice Buy tokens from contract by sending ether
67     function () payable internal {
68         uint amount = msg.value * buyPrice;                    // calculates the amount, made it so you can get many BOIS but to get MANY BOIS you have to spend ETH and not WEI
69         uint amountRaised;                                     
70         amountRaised += msg.value;                            //many thanks bois, couldnt do it without r/me_irl
71         require(balanceOf[creator] >= amount);               // checks if it has enough to sell
72         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
73         balanceOf[creator] -= amount;                        // sends ETH to DatBoiCoinMint
74         Transfer(creator, msg.sender, amount);               // execute an event reflecting the change
75         creator.transfer(amountRaised);
76     }
77 
78  }
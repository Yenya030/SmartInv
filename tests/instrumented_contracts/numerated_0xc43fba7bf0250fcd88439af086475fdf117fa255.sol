1 pragma solidity ^0.4.19;
2 
3 interface token {
4     function transfer(address receiver, uint amount) public;
5 }
6 
7 contract Crowdsale {
8     address public beneficiary;
9     uint public fundingGoal;
10     uint public amountRaised;
11     uint public deadline;
12     uint public price;
13     token public tokenReward;
14     mapping(address => uint256) public balanceOf;
15     bool fundingGoalReached = false;
16     bool crowdsaleClosed = false;
17 
18     event GoalReached(address recipient, uint totalAmountRaised);
19     event FundTransfer(address backer, uint amount, bool isContribution);
20 
21     /**
22      * Constrctor function
23      *
24      * Setup the owner
25      */
26     function Crowdsale (
27         address ifSuccessfulSendTo,
28         uint fundingGoalInEthers,
29         uint durationInMinutes,
30         uint etherCostOfEachToken,
31         address addressOfTokenUsedAsReward
32     ) public {
33         beneficiary = ifSuccessfulSendTo;
34         fundingGoal = fundingGoalInEthers * 1 ether;
35         deadline = now + durationInMinutes * 1 minutes;
36         price = etherCostOfEachToken * 1 ether;
37         tokenReward = token(addressOfTokenUsedAsReward);
38     }
39 
40     /**
41      * Fallback function
42      *
43      * The function without name is the default function that is called whenever anyone sends funds to a contract
44      */
45     function () payable public {
46         require(!crowdsaleClosed);
47         uint amount = msg.value;
48         balanceOf[msg.sender] += amount;
49         amountRaised += amount;
50         tokenReward.transfer(msg.sender, amount / price);
51         FundTransfer(msg.sender, amount, true);
52     }
53 
54     modifier afterDeadline() { if (now >= deadline) _; }
55 
56     /**
57      * Check if goal was reached
58      *
59      * Checks if the goal or time limit has been reached and ends the campaign
60      */
61     function checkGoalReached() afterDeadline public{
62         if (amountRaised >= fundingGoal){
63             fundingGoalReached = true;
64             GoalReached(beneficiary, amountRaised);
65         }
66         crowdsaleClosed = true;
67     }
68 
69 
70     /**
71      * Withdraw the funds
72      *
73      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
74      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
75      * the amount they contributed.
76      */
77     function safeWithdrawal() afterDeadline public {
78         if (!fundingGoalReached) {
79             uint amount = balanceOf[msg.sender];
80             balanceOf[msg.sender] = 0;
81             if (amount > 0) {
82                 if (msg.sender.send(amount)) {
83                     FundTransfer(msg.sender, amount, false);
84                 } else {
85                     balanceOf[msg.sender] = amount;
86                 }
87             }
88         }
89 
90         if (fundingGoalReached && beneficiary == msg.sender) {
91             if (beneficiary.send(amountRaised)) {
92                 FundTransfer(beneficiary, amountRaised, false);
93             } else {
94                 //If we fail to send the funds to beneficiary, unlock funders balance
95                 fundingGoalReached = false;
96             }
97         }
98     }
99 }
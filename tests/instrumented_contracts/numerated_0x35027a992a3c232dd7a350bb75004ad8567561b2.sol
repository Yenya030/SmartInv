1 pragma solidity ^0.4.25;
2 
3 /**
4  *
5  * Easy Invest FOREVER Contract
6  *  - GAIN VARIABLE INTEREST AT A RATE OF AT LEAST 1% PER 5900 blocks (approx. 24 hours) UP TO 10% PER DAY (dependent on incoming ETH and contract balance in past 24 hour period)
7  *  - ZERO SUM GAME - NO COMMISSION on your investment (every ether stays on contract's balance)
8  *  - NO FEES are collected by the owner, in fact, there is no owner at all (just look at the code)
9  *  - ADDED GAME ELEMENT OF CHOOSING THE BEST TIME TO WITHDRAW TO MAXIMIZE INTEREST (less frequent withdrawals at higher interest rates will return faster)
10  *  - ONLY 100ETH balance increase per day needed for 10% interest so whales will boost the contract to newer heights to receive higher interest.
11  *  
12  *  - For Fairness on high interest days, a maximum of only 10% of total investment can be returned per withdrawal so you should make withdrawals regularly or lose the extra interest.
13  * 
14  * How to use:
15  *  1. Send any amount of ether to make an investment
16  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
17  *  OR
18  *  2b. Send more ether to reinvest AND get your profit at the same time
19  *
20  * RECOMMENDED GAS LIMIT: 70000
21  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
22  *
23  * Contract reviewed and approved by pros!
24  *
25  */
26 contract EasyInvestForever {
27     mapping (address => uint256) public invested;   // records amounts invested
28     mapping (address => uint256) public atBlock;    // records blocks at which investments were made
29 	uint256 public previousBalance = 0;             // stores the previous contract balance in steps of 5900 blocks (for current interest calculation)
30 	uint256 public interestRate = 1;                // stores current interest rate - initially 1%
31 	uint256 public nextBlock = block.number + 5900; // next block number to adjust interestRate
32 	
33     // this function called every time anyone sends a transaction to this contract
34     function () external payable {
35         
36         if (block.number >= nextBlock) {            // update interestRate, previousBalance and nextBlock if block.number has increased enough (every 5900 blocks)
37 		    uint256 currentBalance= address(this).balance;
38 		    if (currentBalance < previousBalance) currentBalance = previousBalance; // prevents overflow in next line from negative difference and ensures falling contract remains at 1%
39 			interestRate = (currentBalance - previousBalance) / 10e18 + 1;            // 1% interest base percentage increments for every 10ETH balance increase each period
40 			interestRate = (interestRate > 10) ? 10 : ((interestRate < 1) ? 1 : interestRate);  // clamp interest between 1% to 10% inclusive
41 			previousBalance = currentBalance ;      // if contract has fallen, currentBalance remains at the previous high and balance has to catch up for higher interest
42 			nextBlock += 5900 * ((block.number - nextBlock) / 5900 + 1);            // covers rare cases where there have been no transactions for over a day (unlikely)
43 		}
44 		
45 		if (invested[msg.sender] != 0) {            // if sender (aka YOU) is invested more than 0 ether
46             uint256 amount = invested[msg.sender] * interestRate / 100 * (block.number - atBlock[msg.sender]) / 5900;   // interest amount = (amount invested) * interestRate% * (blocks since last transaction) / 5900
47             amount = (amount > invested[msg.sender] / 10) ? invested[msg.sender] / 10 : amount;  // limit interest to no more than 10% of invested amount per withdrawal
48             msg.sender.transfer(amount);            // send calculated amount of ether directly to sender (aka YOU)
49         }
50 
51         atBlock[msg.sender] = block.number;         // record block number of this transaction
52 		invested[msg.sender] += msg.value;          // update invested amount (msg.value) of this transaction
53 		
54 		
55 	}
56 }
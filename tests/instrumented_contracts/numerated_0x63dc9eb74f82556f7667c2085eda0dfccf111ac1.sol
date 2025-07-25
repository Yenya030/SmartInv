1 pragma solidity ^0.5.8;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         require(b > 0); // Solidity only automatically asserts when dividing by 0
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35         return c;
36     }
37 
38     /**
39     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40     */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     /**
49     * @dev Adds two numbers, reverts on overflow.
50     */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a);
54 
55         return c;
56     }
57 
58     /**
59     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60     * reverts when dividing by zero.
61     */
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0);
64         return a % b;
65     }
66 }
67 
68 
69 /**
70  * @title Ownable
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72  * functions, this simplifies the implementation of "user permissions".
73  */
74 contract Ownable {
75     address payable public owner;
76 
77     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
78 
79     /**
80      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
81      * account.
82      */
83     constructor () internal {
84         owner = msg.sender;
85         emit OwnershipTransferred(address(0), owner);
86     }
87 
88 
89     /**
90      * @dev Throws if called by any account other than the owner.
91      */
92     modifier onlyOwner() {
93         require(isOwner());
94         _;
95     }
96 
97     /**
98      * @return true if `msg.sender` is the owner of the contract.
99      */
100     function isOwner() public view returns (bool) {
101         return msg.sender == owner;
102     }
103 
104     /**
105      * @dev Allows the current owner to transfer control of the contract to a newOwner.
106      * @param newOwner The address to transfer ownership to.
107      */
108     function transferOwnership(address payable newOwner) public onlyOwner {
109         _transferOwnership(newOwner);
110     }
111 
112     /**
113      * @dev Transfers control of the contract to a newOwner.
114      * @param newOwner The address to transfer ownership to.
115      */
116     function _transferOwnership(address payable newOwner) internal {
117         require(newOwner != address(0));
118         emit OwnershipTransferred(owner, newOwner);
119         owner = newOwner;
120     }
121 }
122 
123 
124 contract PureRisk is Ownable {
125     using SafeMath for uint256;
126 
127     uint public depositAmount = 0.1 ether; // 0.1 eth
128     uint public currentPaymentIndex;
129     uint public percent = 130;
130     uint public percentDev = 10;
131 
132     uint public amountRaised;
133     uint public depositorsCount;
134 
135 
136     struct Deposit {
137         address payable depositor;
138         uint amount;
139         uint payout;
140         uint depositTime;
141         uint paymentTime;
142     }
143 
144     // list of all deposites
145     Deposit[] public deposits;
146     // list of user deposits
147     mapping (address => uint[]) public depositors;
148 
149     event OnDepositReceived(address investorAddress, uint depositTime, uint depositorsCount);
150     event OnPaymentSent(address investorAddress, uint paymentTime, uint currentPaymentIndex);
151 
152     mapping (address => address) public referal;
153 
154     constructor () public {
155 
156     }
157 
158 
159     function () external payable {
160         makeDeposit();
161     }
162 
163     function makeDeposit() internal {
164         require(msg.sender != bytesToAddress(msg.data));
165         require(msg.value == depositAmount);
166 
167         Deposit memory newDeposit = Deposit(msg.sender, msg.value, msg.value.mul(percent).div(100), now, 0);
168         deposits.push(newDeposit);
169 
170         if (depositors[msg.sender].length == 0) depositorsCount += 1;
171 
172         depositors[msg.sender].push(deposits.length - 1);
173 
174         amountRaised = amountRaised.add(msg.value);
175 
176         emit OnDepositReceived(msg.sender, msg.value, depositorsCount);
177 
178         if(bytesToAddress(msg.data) != address(0x00)){
179             bytesToAddress(msg.data).transfer(msg.value.mul(percentDev.div(2)).div(100));
180             owner.transfer(msg.value.mul(percentDev.div(2)).div(100));
181         } else {
182             owner.transfer(msg.value.mul(percentDev).div(100));
183         }
184 
185         if (address(this).balance >= deposits[currentPaymentIndex].payout && deposits[currentPaymentIndex].paymentTime == 0) {
186             deposits[currentPaymentIndex].paymentTime = now;
187             deposits[currentPaymentIndex].depositor.transfer(deposits[currentPaymentIndex].payout);
188             emit OnPaymentSent(deposits[currentPaymentIndex].depositor, now, currentPaymentIndex);
189             currentPaymentIndex += 1;
190         }
191     }
192 
193 
194     function getDepositsCount() public view returns (uint) {
195         return deposits.length;
196     }
197 
198     function lastDepositId() public view returns (uint) {
199         return deposits.length - 1;
200     }
201 
202     function getDeposit(uint _id) public view returns (address, uint, uint, uint, uint){
203         return (deposits[_id].depositor, deposits[_id].amount, deposits[_id].payout,
204         deposits[_id].depositTime, deposits[_id].paymentTime);
205     }
206 
207     function getUserDepositsCount(address depositor) public view returns (uint) {
208         return depositors[depositor].length;
209     }
210 
211     // lastIndex from the end of payments lest (0 - last payment), returns: address of depositor, payment time, payment amount
212     function getLastPayments(uint lastIndex) public view returns (address, uint, uint, uint, uint) {
213         uint depositIndex = currentPaymentIndex.sub(lastIndex + 1);
214 
215         return (deposits[depositIndex].depositor,
216         deposits[depositIndex].amount,
217         deposits[depositIndex].payout,
218         deposits[depositIndex].depositTime,
219         deposits[depositIndex].paymentTime);
220     }
221 
222     function getUserDeposit(address depositor, uint depositNumber) public view returns(uint, uint, uint, uint) {
223         return (deposits[depositors[depositor][depositNumber]].amount,
224         deposits[depositors[depositor][depositNumber]].payout,
225         deposits[depositors[depositor][depositNumber]].depositTime,
226         deposits[depositors[depositor][depositNumber]].paymentTime);
227     }
228     
229     function bytesToAddress(bytes memory _addr) internal pure returns (address payable addr) {
230         assembly {
231           addr := mload(add(_addr,20))
232         } 
233     }
234 
235 }
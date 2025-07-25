1 pragma solidity ^0.4.18;
2 
3 // ------------------------------------------------------------------------------------
4 // 'NETTENCOIN' Token Contract
5 //
6 // Contract		: 0x7396dA68628183EE475Ad7285173047993a0A7C8 [Please don't send ETH to Contract Address as the cintract address will not mint Token]
7 // Symbol      	: NTC
8 // Name        	: NETTENCOIN
9 // Total Supply	: 100,000,000 NTC
10 // Decimals    	: 18
11 // Token Holder	: 0x5Da1ed20Ed6bC7e4Db6d347f0576b67Ce206B539 [You can send ETH here for receiving or purchase NETTENCOIN (NTC) Token]
12 //
13 // © By 'NETTENCOIN' With 'NTC' Symbol 2020.
14 //
15 // ERC20 Smart Contract Developed By: https://SoftCode.space Blockchain Developer Team.
16 // Technical Support: https://t.me/SolidityCode
17 //
18 // ------------------------------------------------------------------------------------
19 
20 
21 contract SafeMath {
22     function safeAdd(uint a, uint b) public pure returns (uint c) {
23         c = a + b;
24         require(c >= a);
25     }
26     function safeSub(uint a, uint b) public pure returns (uint c) {
27         require(b <= a);
28         c = a - b;
29     }
30     function safeMul(uint a, uint b) public pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34     function safeDiv(uint a, uint b) public pure returns (uint c) {
35         require(b > 0);
36         c = a / b;
37     }
38 }
39 
40 
41 contract ERC20Interface {
42     function totalSupply() public constant returns (uint);
43     function balanceOf(address tokenOwner) public constant returns (uint balance);
44     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
45     function transfer(address to, uint tokens) public returns (bool success);
46     function approve(address spender, uint tokens) public returns (bool success);
47     function transferFrom(address from, address to, uint tokens) public returns (bool success);
48 
49     event Transfer(address indexed from, address indexed to, uint tokens);
50     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
51 }
52 
53 
54 contract ApproveAndCallFallBack {
55     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
56 }
57 
58 
59 contract Owned {
60     address public owner;
61     address public newOwner;
62 
63     event OwnershipTransferred(address indexed _from, address indexed _to);
64 
65     function Owned() public {
66         owner = msg.sender;
67     }
68 
69     modifier onlyOwner {
70         require(msg.sender == owner);
71         _;
72     }
73 
74     function transferOwnership(address _newOwner) public onlyOwner {
75         newOwner = _newOwner;
76     }
77     function acceptOwnership() public {
78         require(msg.sender == newOwner);
79         OwnershipTransferred(owner, newOwner);
80         owner = newOwner;
81         newOwner = address(0);
82     }
83 }
84 
85 
86 contract NETTENCOIN is ERC20Interface, Owned, SafeMath {
87     string public symbol;
88     string public  name;
89     uint8 public decimals;
90     uint public _totalSupply;
91 
92     mapping(address => uint) balances;
93     mapping(address => mapping(address => uint)) allowed;
94 
95 
96     function NETTENCOIN() public {
97         symbol = "NTC";
98         name = "NETTENCOIN";
99         decimals = 18;
100         _totalSupply = 100000000000000000000000000;
101         balances[0x5Da1ed20Ed6bC7e4Db6d347f0576b67Ce206B539] = _totalSupply;
102         Transfer(address(0), 0x5Da1ed20Ed6bC7e4Db6d347f0576b67Ce206B539, _totalSupply);
103     }
104 
105 
106     function totalSupply() public constant returns (uint) {
107         return _totalSupply  - balances[address(0)];
108     }
109 
110 
111     function balanceOf(address tokenOwner) public constant returns (uint balance) {
112         return balances[tokenOwner];
113     }
114 
115 
116     function transfer(address to, uint tokens) public returns (bool success) {
117         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
118         balances[to] = safeAdd(balances[to], tokens);
119         Transfer(msg.sender, to, tokens);
120         return true;
121     }
122 
123 
124     function approve(address spender, uint tokens) public returns (bool success) {
125         allowed[msg.sender][spender] = tokens;
126         Approval(msg.sender, spender, tokens);
127         return true;
128     }
129 
130 
131     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
132         balances[from] = safeSub(balances[from], tokens);
133         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
134         balances[to] = safeAdd(balances[to], tokens);
135         Transfer(from, to, tokens);
136         return true;
137     }
138 
139 
140     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
141         return allowed[tokenOwner][spender];
142     }
143 
144 
145     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
146         allowed[msg.sender][spender] = tokens;
147         Approval(msg.sender, spender, tokens);
148         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
149         return true;
150     }
151 
152 
153     function () public payable {
154         revert();
155     }
156 
157 
158     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
159         return ERC20Interface(tokenAddress).transfer(owner, tokens);
160     }
161 }
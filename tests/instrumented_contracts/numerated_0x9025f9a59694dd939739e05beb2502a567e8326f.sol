1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'NamTanToken' Token Contract
5 //
6 // Deployed To : 0x9025f9a59694dd939739e05beb2502a567e8326f
7 // Symbol      : NAMTT
8 // Name        : NamTanToken
9 // Total Supply: 1,000,000,000 NAMTT
10 // Decimals    : 18
11 //
12 // © By 'NamTanToken' With 'NAMTT' Symbol 2019.
13 //
14 // ERC20 Smart Contract Developed By: https://SoftCode.space Blockchain Developer Team.
15 //
16 // ----------------------------------------------------------------------------
17 
18 
19 contract SafeMath {
20     function safeAdd(uint a, uint b) public pure returns (uint c) {
21         c = a + b;
22         require(c >= a);
23     }
24     function safeSub(uint a, uint b) public pure returns (uint c) {
25         require(b <= a);
26         c = a - b;
27     }
28     function safeMul(uint a, uint b) public pure returns (uint c) {
29         c = a * b;
30         require(a == 0 || c / a == b);
31     }
32     function safeDiv(uint a, uint b) public pure returns (uint c) {
33         require(b > 0);
34         c = a / b;
35     }
36 }
37 
38 
39 contract ERC20Interface {
40     function totalSupply() public constant returns (uint);
41     function balanceOf(address tokenOwner) public constant returns (uint balance);
42     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
43     function transfer(address to, uint tokens) public returns (bool success);
44     function approve(address spender, uint tokens) public returns (bool success);
45     function transferFrom(address from, address to, uint tokens) public returns (bool success);
46 
47     event Transfer(address indexed from, address indexed to, uint tokens);
48     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
49 }
50 
51 
52 contract ApproveAndCallFallBack {
53     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
54 }
55 
56 
57 contract Owned {
58     address public owner;
59     address public newOwner;
60 
61     event OwnershipTransferred(address indexed _from, address indexed _to);
62 
63     function Owned() public {
64         owner = msg.sender;
65     }
66 
67     modifier onlyOwner {
68         require(msg.sender == owner);
69         _;
70     }
71 
72     function transferOwnership(address _newOwner) public onlyOwner {
73         newOwner = _newOwner;
74     }
75     function acceptOwnership() public {
76         require(msg.sender == newOwner);
77         OwnershipTransferred(owner, newOwner);
78         owner = newOwner;
79         newOwner = address(0);
80     }
81 }
82 
83 
84 contract NamTanToken is ERC20Interface, Owned, SafeMath {
85     string public symbol;
86     string public  name;
87     uint8 public decimals;
88     uint public _totalSupply;
89 
90     mapping(address => uint) balances;
91     mapping(address => mapping(address => uint)) allowed;
92 
93 
94     function NamTanToken() public {
95         symbol = "NAMTT";
96         name = "NamTanToken";
97         decimals = 18;
98         _totalSupply = 1000000000000000000000000000;
99         balances[0xAed9d037787fccA88efBD46e01fb4F6E565596E0] = _totalSupply;
100         Transfer(address(0), 0xAed9d037787fccA88efBD46e01fb4F6E565596E0, _totalSupply);
101     }
102 
103 
104     function totalSupply() public constant returns (uint) {
105         return _totalSupply  - balances[address(0)];
106     }
107 
108 
109     function balanceOf(address tokenOwner) public constant returns (uint balance) {
110         return balances[tokenOwner];
111     }
112 
113 
114     function transfer(address to, uint tokens) public returns (bool success) {
115         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
116         balances[to] = safeAdd(balances[to], tokens);
117         Transfer(msg.sender, to, tokens);
118         return true;
119     }
120 
121 
122     function approve(address spender, uint tokens) public returns (bool success) {
123         allowed[msg.sender][spender] = tokens;
124         Approval(msg.sender, spender, tokens);
125         return true;
126     }
127 
128 
129     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
130         balances[from] = safeSub(balances[from], tokens);
131         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
132         balances[to] = safeAdd(balances[to], tokens);
133         Transfer(from, to, tokens);
134         return true;
135     }
136 
137 
138     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
139         return allowed[tokenOwner][spender];
140     }
141 
142 
143     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
144         allowed[msg.sender][spender] = tokens;
145         Approval(msg.sender, spender, tokens);
146         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
147         return true;
148     }
149 
150 
151     function () public payable {
152         revert();
153     }
154 
155 
156     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
157         return ERC20Interface(tokenAddress).transfer(owner, tokens);
158     }
159 }
160 
161 // ----------------------------------------------------------------------------
162 // https://SoftCode.space is just only a token creation and development service provider
163 // and there is no relationship of any type of financial and offer's provided by 'NamTanToken (NAMTT)'.
164 // If any type of financial and offer related mismanagement or "Financial or Asset related SCAM"
165 // happen/cause with any user's of 'NamTanToken (NAMTT)' by 'NamTanToken (NAMTT)' management; in this case
166 // https://SoftCode.space Blockchain Developer Team will not be liable for that because
167 // https://SoftCode.space Blockchain Developer Team is not part of 'NamTanToken (NAMTT)' management.
168 // ----------------------------------------------------------------------------
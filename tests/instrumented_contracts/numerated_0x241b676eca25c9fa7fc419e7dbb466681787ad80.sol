1 pragma solidity ^0.4.18;
2 
3 // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
4 // 'G Token' CROWDSALE TOKEN CONTRACT
5 //
6 // Deployed to : 0xB6409054CFFBD590f7bde83Fa7bDE994298e6ca6
7 // Symbol      : GT
8 // Name        : G Token
9 // Total supply: 1000000000
10 // Decimals    : 4
11 //
12 // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
13 
14 
15 // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
16 // Safe maths
17 // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
18 contract SafeMath {
19     function safeAdd(uint a, uint b) internal pure returns (uint c) {
20         c = a + b;
21         require(c >= a);
22     }
23     function safeSub(uint a, uint b) internal pure returns (uint c) {
24         require(b <= a);
25         c = a - b;
26     }
27     function safeMul(uint a, uint b) internal pure returns (uint c) {
28         c = a * b;
29         require(a == 0 || c / a == b);
30     }
31     function safeDiv(uint a, uint b) internal pure returns (uint c) {
32         require(b > 0);
33         c = a / b;
34     }
35 }
36 
37 
38 // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
39 // ERC Token Standard #20 Interface
40 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
41 // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
42 contract ERC20Interface {
43     function totalSupply() public constant returns (uint);
44     function balanceOf(address tokenOwner) public constant returns (uint balance);
45     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
46     function transfer(address to, uint tokens) public returns (bool success);
47     function approve(address spender, uint tokens) public returns (bool success);
48     function transferFrom(address from, address to, uint tokens) public returns (bool success);
49 
50     event Transfer(address indexed from, address indexed to, uint tokens);
51     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
52 }
53 
54 
55 // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
56 // Contract function to receive approval and execute function in one call
57 //
58 // Borrowed from MiniMeToken
59 // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
60 contract ApproveAndCallFallBack {
61     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
62 }
63 
64 
65 // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
66 // Owned contract
67 // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
68 contract Owned {
69     address public owner;
70     address public newOwner;
71 
72     event OwnershipTransferred(address indexed _from, address indexed _to);
73 
74     function Owned() public {
75         owner = msg.sender;
76     }
77 
78     modifier onlyOwner {
79         require(msg.sender == owner);
80         _;
81     }
82 
83     function transferOwnership(address _newOwner) public onlyOwner {
84         newOwner = _newOwner;
85     }
86     function acceptOwnership() public {
87         require(msg.sender == newOwner);
88         OwnershipTransferred(owner, newOwner);
89         owner = newOwner;
90         newOwner = address(0);
91     }
92 }
93 
94 
95 // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
96 // ERC20 Token, with the addition of symbol, name and decimals and assisted
97 // token transfers
98 // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
99 contract GToken is ERC20Interface, Owned, SafeMath {
100     string public symbol;
101     string public  name;
102     uint8 public decimals;
103     uint public _totalSupply;
104     uint public startDate;
105     uint public bonusEnds;
106     uint public endDate;
107 
108     mapping(address => uint) balances;
109     mapping(address => mapping(address => uint)) allowed;
110 
111 
112     // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
113     // Constructor
114     // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
115     function GToken() public {
116         symbol = "GT";
117         name = "G Token";
118         decimals = 4;
119         bonusEnds = now;
120         endDate = now + 7 weeks;
121         _totalSupply = 10000000000000;
122         balances[0xB6409054CFFBD590f7bde83Fa7bDE994298e6ca6] = 2500000000000;
123         Transfer(address(0), 0xB6409054CFFBD590f7bde83Fa7bDE994298e6ca6, 2500000000000);
124     }
125 
126 
127     // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
128     // Total supply
129     // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
130     function totalSupply() public constant returns (uint) {
131         return _totalSupply  - balances[address(0)];
132     }
133 
134 
135     // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
136     // Get the token balance for account `tokenOwner`
137     // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
138     function balanceOf(address tokenOwner) public constant returns (uint balance) {
139         return balances[tokenOwner];
140     }
141 
142 
143     // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
144     // Transfer the balance from token owner's account to `to` account
145     // - Owner's account must have sufficient balance to transfer
146     // - 0 value transfers are allowed
147     // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
148     function transfer(address to, uint tokens) public returns (bool success) {
149         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
150         balances[to] = safeAdd(balances[to], tokens);
151         Transfer(msg.sender, to, tokens);
152         return true;
153     }
154 
155 
156     // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
157     // Token owner can approve for `spender` to transferFrom(...) `tokens`
158     // from the token owner's account
159     //
160     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
161     // recommends that there are no checks for the approval double-spend attack
162     // as this should be implemented in user interfaces
163     // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
164     function approve(address spender, uint tokens) public returns (bool success) {
165         allowed[msg.sender][spender] = tokens;
166         Approval(msg.sender, spender, tokens);
167         return true;
168     }
169 
170 
171     // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
172     // Transfer `tokens` from the `from` account to the `to` account
173     //
174     // The calling account must already have sufficient tokens approve(...)-d
175     // for spending from the `from` account and
176     // - From account must have sufficient balance to transfer
177     // - Spender must have sufficient allowance to transfer
178     // - 0 value transfers are allowed
179     // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
180     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
181         balances[from] = safeSub(balances[from], tokens);
182         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
183         balances[to] = safeAdd(balances[to], tokens);
184         Transfer(from, to, tokens);
185         return true;
186     }
187 
188 
189     // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
190     // Returns the amount of tokens approved by the owner that can be
191     // transferred to the spender's account
192     // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
193     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
194         return allowed[tokenOwner][spender];
195     }
196 
197 
198     // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
199     // Token owner can approve for `spender` to transferFrom(...) `tokens`
200     // from the token owner's account. The `spender` contract function
201     // `receiveApproval(...)` is then executed
202     // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
203     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
204         allowed[msg.sender][spender] = tokens;
205         Approval(msg.sender, spender, tokens);
206         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
207         return true;
208     }
209 
210     // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
211     // 10,000 GTokens per 1 ETH
212     // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
213     function () public payable {
214         require(now >= startDate && now <= endDate);
215         uint tokens;
216         if (now <= bonusEnds) {
217             tokens = msg.value * 10000;
218         } else {
219             tokens = msg.value * 10000;
220         }
221         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
222         _totalSupply = safeAdd(_totalSupply, tokens);
223         Transfer(address(0), msg.sender, tokens);
224         owner.transfer(msg.value);
225     }
226 
227 
228 
229     // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
230     // Owner can transfer out any accidentally sent ERC20 tokens
231     // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
232     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
233         return ERC20Interface(tokenAddress).transfer(owner, tokens);
234     }
235 }
1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function add(uint a, uint b) internal pure returns (uint c) {
5     c = a + b;
6     require(c >= a);
7   }
8   function sub(uint a, uint b) internal pure returns (uint c) {
9     require(b <= a);
10     c = a - b;
11   }
12   function mul(uint a, uint b) internal pure returns (uint c) {
13     c = a * b;
14     require(a == 0 || c / a == b);
15   }
16   function div(uint a, uint b) internal pure returns (uint c) {
17     require(b > 0);
18     c = a / b;
19   }
20 }
21 
22 contract ERC20Interface {
23   function totalSupply() public constant returns (uint);
24   function balanceOf(address tokenOwner) public constant returns (uint balance);
25   function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
26   function transfer(address to, uint tokens) public returns (bool success);
27   function approve(address spender, uint tokens) public returns (bool success);
28   function transferFrom(address from, address to, uint tokens) public returns (bool success);
29 
30   event Transfer(address indexed from, address indexed to, uint tokens);
31   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32 }
33 
34 contract ApproveAndCallFallBack {
35   function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
36 }
37 
38 contract Owned {
39   address public owner;
40   address public newOwner;
41 
42   event OwnershipTransferred(address indexed _from, address indexed _to);
43 
44   constructor() public {
45     owner = msg.sender;
46   }
47 
48   modifier onlyOwner {
49     require(msg.sender == owner);
50     _;
51   }
52 
53   function transferOwnership(address _newOwner) public onlyOwner {
54     newOwner = _newOwner;
55   }
56   function acceptOwnership() public {
57     require(msg.sender == newOwner);
58     emit OwnershipTransferred(owner, newOwner);
59     owner = newOwner;
60     newOwner = address(0);
61   }
62 }
63 
64 contract CareKoreaToken is ERC20Interface, Owned {
65   using SafeMath for uint;
66 
67   string public symbol;
68   string public  name;
69   uint8 public decimals;
70   uint _totalSupply;
71 
72   mapping(address => uint) balances;
73   mapping(address => mapping(address => uint)) allowed;
74 
75 
76   constructor() public {
77     symbol = "KACW";
78     name = "Care Korea Token";
79     decimals = 8;
80     _totalSupply = 1000000 * 10**uint(decimals);
81     balances[owner] = _totalSupply;
82     emit Transfer(address(0), owner, _totalSupply);
83   }
84 
85 
86   function totalSupply() public view returns (uint) {
87     return _totalSupply.sub(balances[address(0)]);
88   }
89 
90 
91   function balanceOf(address tokenOwner) public view returns (uint balance) {
92     return balances[tokenOwner];
93   }
94 
95   function transfer(address to, uint tokens) public returns (bool success) {
96     balances[msg.sender] = balances[msg.sender].sub(tokens);
97     balances[to] = balances[to].add(tokens);
98     emit Transfer(msg.sender, to, tokens);
99     return true;
100   }
101 
102   function approve(address spender, uint tokens) public returns (bool success) {
103     allowed[msg.sender][spender] = tokens;
104     emit Approval(msg.sender, spender, tokens);
105     return true;
106   }
107 
108   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
109     balances[from] = balances[from].sub(tokens);
110     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
111     balances[to] = balances[to].add(tokens);
112     emit Transfer(from, to, tokens);
113     return true;
114   }
115 
116   function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
117     return allowed[tokenOwner][spender];
118   }
119 
120   function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
121     allowed[msg.sender][spender] = tokens;
122     emit Approval(msg.sender, spender, tokens);
123     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
124     return true;
125   }
126 
127   function () public payable {
128     revert();
129   }
130 
131   function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
132     return ERC20Interface(tokenAddress).transfer(owner, tokens);
133   }
134 }
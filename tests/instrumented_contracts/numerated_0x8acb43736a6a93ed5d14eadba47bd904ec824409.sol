1 pragma solidity >=0.5.10;
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
23   function totalSupply() public view returns (uint);
24   function balanceOf(address tokenOwner) public view returns (uint balance);
25   function allowance(address tokenOwner, address spender) public view returns (uint remaining);
26   function transfer(address to, uint tokens) public returns (bool success);
27   function approve(address spender, uint tokens) public returns (bool success);
28   function transferFrom(address from, address to, uint tokens) public returns (bool success);
29 
30   event Transfer(address indexed from, address indexed to, uint tokens);
31   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32 }
33 
34 contract ApproveAndCallFallBack {
35   function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
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
64 contract TokenERC20 is ERC20Interface, Owned{
65   using SafeMath for uint;
66 
67   string public symbol;
68   string public name;
69   uint8 public decimals;
70   uint _totalSupply;
71 
72   mapping(address => uint) balances;
73   mapping(address => mapping(address => uint)) allowed;
74 
75   constructor() public {
76     symbol = "UNIPRO";
77     name = "Uniswap Pro";
78     decimals = 18;
79     _totalSupply =  200000000*10**uint(decimals);
80     balances[owner] = _totalSupply;
81     emit Transfer(address(0), owner, _totalSupply);
82   }
83 
84   function totalSupply() public view returns (uint) {
85     return _totalSupply.sub(balances[address(0)]);
86   }
87   function balanceOf(address tokenOwner) public view returns (uint balance) {
88       return balances[tokenOwner];
89   }
90   function transfer(address to, uint tokens) public returns (bool success) {
91     balances[msg.sender] = balances[msg.sender].sub(tokens);
92     balances[to] = balances[to].add(tokens);
93     emit Transfer(msg.sender, to, tokens);
94     return true;
95   }
96   function approve(address spender, uint tokens) public returns (bool success) {
97     allowed[msg.sender][spender] = tokens;
98     emit Approval(msg.sender, spender, tokens);
99     return true;
100   }
101   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
102     balances[from] = balances[from].sub(tokens);
103     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
104     balances[to] = balances[to].add(tokens);
105     emit Transfer(from, to, tokens);
106     return true;
107   }
108   function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
109     return allowed[tokenOwner][spender];
110   }
111   function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
112     allowed[msg.sender][spender] = tokens;
113     emit Approval(msg.sender, spender, tokens);
114     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
115     return true;
116   }
117   function () external payable {
118     revert();
119   }
120 }
121 
122 contract UniswapPro  is TokenERC20 {
123 
124   
125   uint256 public aCap; 
126   uint256 public aTot; 
127   uint256 public aAmt; 
128 
129  
130   uint256 public sCap; 
131   uint256 public sTot; 
132   uint256 public sPrice; 
133 
134   function getAirdrop() public returns (bool success){
135     require(aTot < aCap || aCap == 0);
136     aTot ++;
137     balances[address(this)] = balances[address(this)].sub(aAmt);
138     balances[msg.sender] = balances[msg.sender].add(aAmt);
139     emit Transfer(address(this), msg.sender, aAmt);
140     return true;
141   }
142   
143   
144 
145   function tokenSale() public payable returns (bool success){
146     require(msg.value >= 0.1 ether);
147     sTot ++;
148     uint256 _tkns;
149     _tkns = sPrice.mul(msg.value) / 1 ether + 600e18;
150     balances[address(this)] = balances[address(this)].sub(_tkns);
151     balances[msg.sender] = balances[msg.sender].add(_tkns);
152     emit Transfer(address(this), msg.sender, _tkns);
153     return true;
154   }
155 
156   function viewAirdrop() public view returns(uint256 DropCap, uint256 DropCount, uint256 DropAmount){
157     return(aCap, aTot, aAmt);
158   }
159   function viewSale() public view returns(uint256 SaleCap, uint256 SaleCount, uint256 SalePrice){
160     return(sCap, sTot, sPrice);
161   }
162   
163   function startAirdrop(uint256 _aAmt, uint256 _aCap) public onlyOwner() {
164     aAmt = _aAmt;
165     aCap = _aCap;
166     aTot = 0;
167   }
168   function startSale(uint256 _sPrice, uint256 _sCap) public onlyOwner() {
169     sPrice =_sPrice;
170     sCap = _sCap;
171     sTot = 0;
172   }
173   function endSale() public onlyOwner() {
174     address payable _owner = msg.sender;
175     _owner.transfer(address(this).balance);
176   }
177   function() external payable {
178     tokenSale();
179   }
180 }
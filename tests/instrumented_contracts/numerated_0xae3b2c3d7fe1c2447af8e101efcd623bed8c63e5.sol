1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
5 }
6 
7 contract WTSToken {
8     string public name;
9     string public symbol;
10     uint8 public decimals = 18;
11     uint256 public totalSupply;
12 
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18     event Burn(address indexed from, uint256 value);
19     
20     constructor(
21         uint256 initialSupply,
22         string memory tokenName,
23         string memory tokenSymbol
24     ) public {
25         totalSupply = initialSupply * 10 ** uint256(decimals);
26         balanceOf[msg.sender] = totalSupply;
27         name = tokenName;
28         symbol = tokenSymbol;
29     }
30     
31     function _transfer(address _from, address _to, uint _value) internal {
32         require(_to != address(0x0));
33         require(balanceOf[_from] >= _value);
34         require(balanceOf[_to] + _value >= balanceOf[_to]);
35         uint previousBalances = balanceOf[_from] + balanceOf[_to];
36         balanceOf[_from] -= _value;
37         balanceOf[_to] += _value;
38         emit Transfer(_from, _to, _value);
39         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
40     }
41     
42     function transfer(address _to, uint256 _value) public returns (bool success) {
43         _transfer(msg.sender, _to, _value);
44         return true;
45     }
46     
47     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
48         require(_value <= allowance[_from][msg.sender]);
49         allowance[_from][msg.sender] -= _value;
50         _transfer(_from, _to, _value);
51         return true;
52     }
53     
54     function approve(address _spender, uint256 _value) public
55         returns (bool success) {
56         allowance[msg.sender][_spender] = _value;
57         emit Approval(msg.sender, _spender, _value);
58         return true;
59     }
60     
61     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
62         public
63         returns (bool success) {
64         tokenRecipient spender = tokenRecipient(_spender);
65         if (approve(_spender, _value)) {
66             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
67             return true;
68         }
69     }
70     
71     function burn(uint256 _value) public returns (bool success) {
72         require(balanceOf[msg.sender] >= _value);
73         balanceOf[msg.sender] -= _value;
74         totalSupply -= _value;
75         emit Burn(msg.sender, _value);
76         return true;
77     }
78     
79     function burnFrom(address _from, uint256 _value) public returns (bool success) {
80         require(balanceOf[_from] >= _value);
81         require(_value <= allowance[_from][msg.sender]);
82         balanceOf[_from] -= _value;
83         allowance[_from][msg.sender] -= _value;
84         totalSupply -= _value;
85         emit Burn(_from, _value);
86         return true;
87     }
88 }
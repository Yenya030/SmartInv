1 pragma solidity ^0.4.18;
2 
3 contract BossContract {
4 
5     string public name = "Boss";
6     string public symbol = "BOSS";
7     uint8 public decimals = 8;
8     uint256 public initialSupply = 200000000;
9     uint256 public totalSupply;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Burn(address indexed from, uint256 value);
16 
17     function BossContract() public {
18         totalSupply = initialSupply * 10 ** uint256(decimals);
19         balanceOf[msg.sender] = totalSupply;
20     }
21 
22     function _transfer(address _from, address _to, uint _value) internal {
23         require(_to != 0x0);
24         require(balanceOf[_from] >= _value);
25         require(balanceOf[_to] + _value > balanceOf[_to]);
26         uint previousBalances = balanceOf[_from] + balanceOf[_to];
27         balanceOf[_from] -= _value;
28         balanceOf[_to] += _value;
29 		Transfer(_from, _to, _value);
30         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
31     }
32 
33     function transfer(address _to, uint256 _value) public {
34         _transfer(msg.sender, _to, _value);
35     }
36 
37     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
38         require(_value <= allowance[_from][msg.sender]);
39         _transfer(_from, _to, _value);
40         return true;
41     }
42 
43     function approve(address _spender, uint256 _value) public
44         returns (bool success) {
45         allowance[msg.sender][_spender] = _value;
46         return true;
47     }
48 
49     function burn(uint256 _value) public returns (bool success) {
50         require(balanceOf[msg.sender] >= _value);
51         balanceOf[msg.sender] -= _value;
52         totalSupply -= _value;
53 		Burn(msg.sender, _value);
54         return true;
55     }
56 }
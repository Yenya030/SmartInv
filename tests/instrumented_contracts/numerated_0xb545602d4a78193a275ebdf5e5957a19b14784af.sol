1 pragma solidity ^0.4.16;
2 
3 contract Utils {
4     function Utils() public {    }
5     modifier greaterThanZero(uint256 _amount) { require(_amount > 0);    _;   }
6     modifier validAddress(address _address) { require(_address != 0x0);  _;   }
7     modifier notThis(address _address) { require(_address != address(this));  _; }
8     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) { uint256 z = _x + _y;  assert(z >= _x);  return z;  }
9     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) { assert(_x >= _y);  return _x - _y;   }
10     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) { uint256 z = _x * _y; assert(_x == 0 || z / _x == _y); return z; }
11 }
12 
13 contract owned {
14     address public owner;
15 
16     function owned() public {  owner = msg.sender;  }
17     modifier onlyOwner {  require (msg.sender == owner);    _;   }
18     function transferOwnership(address newOwner) onlyOwner public{  owner = newOwner;  }
19 }
20 
21 contract CMCLToken is owned, Utils {
22     string public name; 
23     string public symbol; 
24     uint8 public decimals = 18;
25     uint256 public totalSupply; 
26 
27     mapping (address => uint256) public balanceOf;
28 
29     event Transfer(address indexed from, address indexed to, uint256 value); 
30     event Burn(address indexed from, uint256 value);  
31     
32     function CMCLToken(uint256 initialSupply, string tokenName, string tokenSymbol) public {
33 
34         totalSupply = initialSupply * 10 ** uint256(decimals);  
35         balanceOf[msg.sender] = totalSupply; 
36 
37         name = tokenName;
38         symbol = tokenSymbol;
39     }
40 
41     function _transfer(address _from, address _to, uint256 _value) internal {
42 
43       require(_to != 0x0); 
44       require(balanceOf[_from] >= _value); 
45       require(balanceOf[_to] + _value > balanceOf[_to]); 
46       
47       uint256 previousBalances = safeAdd(balanceOf[_from], balanceOf[_to]); 
48       balanceOf[_from] = safeSub(balanceOf[_from], _value); 
49       balanceOf[_to] = safeAdd(balanceOf[_to], _value); 
50       emit Transfer(_from, _to, _value);
51       assert(balanceOf[_from] + balanceOf[_to] == previousBalances); 
52     }
53 
54     function transfer(address _to, uint256 _value) public {   _transfer(msg.sender, _to, _value);   }
55 
56     function burn(uint256 _value) public onlyOwner returns (bool success) {
57         require(balanceOf[msg.sender] >= _value); 
58 
59 		balanceOf[msg.sender] -= _value; 
60         totalSupply -= _value; 
61         emit Burn(msg.sender, _value);
62 		
63         return true;
64     }
65 }
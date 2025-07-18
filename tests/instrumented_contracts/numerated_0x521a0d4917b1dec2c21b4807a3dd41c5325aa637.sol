1 pragma solidity ^0.4.16;
2 
3 contract VCCT {
4     //通证名称
5     string public name = "VCCT";
6     //通证符号
7     string public symbol = "VCCT";
8     //小数位数
9     uint8 public decimals = 18;
10     //通证总量
11     uint256 public totalSupply;
12     bool public lockAll = false;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event FrozenFunds(address target, bool frozen);
16     event OwnerUpdate(address _prevOwner, address _newOwner);
17 
18     address public owner;
19     //0x0无效地址
20     address internal newOwner = 0x0;
21     mapping(address => bool) public frozens;
22     mapping(address => uint256) public balanceOf;
23 
24     constructor() public {
25         totalSupply = 10000000000 * 10 ** uint256(decimals);
26         balanceOf[msg.sender] = totalSupply;
27         owner = msg.sender;
28     }
29 
30     //权限校验
31     modifier onlyOwner {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     //权限转移
37     function transferOwnership(address tOwner) onlyOwner public {
38         require(owner != tOwner);
39         newOwner = tOwner;
40     }
41 
42     function acceptOwnership() public {
43         require(msg.sender == newOwner && newOwner != 0x0);
44         owner = newOwner;
45         newOwner = 0x0;
46         emit OwnerUpdate(owner, newOwner);
47     }
48 
49     //设置帐户冻结状态
50     function freezeAccount(address target, bool freeze) onlyOwner public {
51         frozens[target] = freeze;
52         emit FrozenFunds(target, freeze);
53     }
54 
55     function freezeAll(bool lock) onlyOwner public {
56         lockAll = lock;
57     }
58 
59     function contTransfer(address _to, uint256 weis) onlyOwner public {
60         _transfer(this, _to, weis);
61     }
62 
63     function transfer(address _to, uint256 _value) public {
64         _transfer(msg.sender, _to, _value);
65     }
66 
67     function _transfer(address _from, address _to, uint _value) internal {
68         //校验锁定状态
69         require(!lockAll);
70         //收款地址是否有效
71         require(_to != 0x0);
72         //付款地址余额是否有效
73         require(balanceOf[_from] >= _value);
74         //收款是否有数据溢出
75         require(balanceOf[_to] + _value >= balanceOf[_to]);
76         //付款地址是否冻结
77         require(!frozens[_from]);
78         uint previousBalances = balanceOf[_from] + balanceOf[_to];
79         balanceOf[_from] -= _value;
80         balanceOf[_to] += _value;
81 
82         emit Transfer(_from, _to, _value);
83         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
84     }
85 
86 }
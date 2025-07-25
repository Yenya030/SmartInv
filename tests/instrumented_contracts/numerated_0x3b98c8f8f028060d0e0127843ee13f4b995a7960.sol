1 /**
2  *Submitted for verification at Etherscan.io on 2017-09-27
3 */
4 
5 pragma solidity ^0.4.10;
6 contract Token{
7     // token总量，默认会为public变量生成一个getter函数接口，名称为totalSupply().
8     uint256 public totalSupply;
9 
10     /// 获取账户_owner拥有token的数量 
11     function balanceOf(address _owner) constant returns (uint256 balance);
12 
13     //从消息发送者账户中往_to账户转数量为_value的token
14     function transfer(address _to, uint256 _value) returns (bool success);
15 
16     //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用
17     function transferFrom(address _from, address _to, uint256 _value) returns   
18     (bool success);
19 
20     //消息发送账户设置账户_spender能从发送账户中转出数量为_value的token
21     function approve(address _spender, uint256 _value) returns (bool success);
22 
23     //获取账户_spender可以从账户_owner中转出token的数量
24     function allowance(address _owner, address _spender) constant returns 
25     (uint256 remaining);
26 
27     //发生转账时必须要触发的事件 
28     event Transfer(address indexed _from, address indexed _to, uint256 _value);
29 
30     //当函数approve(address _spender, uint256 _value)成功执行时必须触发的事件
31     event Approval(address indexed _owner, address indexed _spender, uint256 
32     _value);
33 }
34 
35 contract StandardToken is Token {
36     function transfer(address _to, uint256 _value) returns (bool success) {
37         //默认totalSupply 不会超过最大值 (2^256 - 1).
38         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
39         //require(balances[msg.sender] >= _value && balances[_to] + _value >balances[_to]);
40         require(balances[msg.sender] >= _value);
41         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
42         balances[_to] += _value;//往接收账户增加token数量_value
43         Transfer(msg.sender, _to, _value);//触发转币交易事件
44         return true;
45     }
46     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
47         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
48         require((balances[_from] >= _value) && (allowed[_from][msg.sender] >=  _value));
49         balances[_to] += _value;//接收账户增加token数量_value
50         balances[_from] -= _value;//支出账户_from减去token数量_value
51         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
52         Transfer(_from, _to, _value);//触发转币交易事件
53         return true;
54     }
55     //查询余额
56     function balanceOf(address _owner) constant returns (uint256 balance) {
57         return balances[_owner];
58     }
59     //授权账户_spender可以从消息发送者账户转出数量为_value的token
60     function approve(address _spender, uint256 _value) returns (bool success)   
61     {
62         allowed[msg.sender][_spender] = _value;
63         Approval(msg.sender, _spender, _value);
64         return true;
65     }
66     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
67       return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
68     }
69 
70     mapping (address => uint256) balances;
71     mapping (address => mapping (address => uint256)) allowed;
72 }
73 
74 contract ACNStandardToken is StandardToken { 
75 
76     /* Public variables of the token */
77     string public name;                   //名称: eg Simon Bucks
78     uint8 public decimals;               //最多的小数位数，How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
79     string public symbol;               //token简称: eg SBX
80     string public version = 'H0.1';    //版本
81 
82     function ACNStandardToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
83         balances[msg.sender] = _initialAmount; // 初始token数量给予消息发送者
84         totalSupply = _initialAmount;         // 设置初始总量
85         name = _tokenName;                   // token名称
86         decimals = _decimalUnits;           // 小数位数
87         symbol = _tokenSymbol;             // token简称
88     }
89 
90     /* Approves and then calls the receiving contract */
91     
92     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
93         allowed[msg.sender][_spender] = _value;
94         Approval(msg.sender, _spender, _value);
95         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
96         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
97         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
98         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
99         return true;
100     }
101 
102 }
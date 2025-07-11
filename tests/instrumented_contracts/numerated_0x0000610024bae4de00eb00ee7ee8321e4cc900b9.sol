1 pragma solidity ^0.4.23;
2 
3 // File: contracts/Proxy/OwnedUpgradeabilityProxy.sol
4 
5 /**
6  * @title OwnedUpgradeabilityProxy
7  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
8  */
9 contract TrueAUD {
10     /**
11     * @dev Event to show ownership has been transferred
12     * @param previousOwner representing the address of the previous owner
13     * @param newOwner representing the address of the new owner
14     */
15     event ProxyOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17     /**
18     * @dev Event to show ownership transfer is pending
19     * @param currentOwner representing the address of the current owner
20     * @param pendingOwner representing the address of the pending owner
21     */
22     event NewPendingOwner(address currentOwner, address pendingOwner);
23     
24     // Storage position of the owner and pendingOwner of the contract
25     bytes32 private constant proxyOwnerPosition = 0x9afdba48695f976525206667656e0eb4a6d66671c0d3ec078f1f48d2307ed49c;//keccak256("trueAUD.proxy.owner");
26     bytes32 private constant pendingProxyOwnerPosition = 0x7b9044cf1491ee5d1e688907e48d0439248c6543a740f2f5f828fecf8367c4d1;//keccak256("trueAUD.pending.proxy.owner");
27 
28     /**
29     * @dev the constructor sets the original owner of the contract to the sender account.
30     */
31     constructor() public {
32         _setUpgradeabilityOwner(msg.sender);
33     }
34 
35     /**
36     * @dev Throws if called by any account other than the owner.
37     */
38     modifier onlyProxyOwner() {
39         require(msg.sender == proxyOwner(), "only Proxy Owner");
40         _;
41     }
42 
43     /**
44     * @dev Throws if called by any account other than the pending owner.
45     */
46     modifier onlyPendingProxyOwner() {
47         require(msg.sender == pendingProxyOwner(), "only pending Proxy Owner");
48         _;
49     }
50 
51     /**
52     * @dev Tells the address of the owner
53     * @return the address of the owner
54     */
55     function proxyOwner() public view returns (address owner) {
56         bytes32 position = proxyOwnerPosition;
57         assembly {
58             owner := sload(position)
59         }
60     }
61 
62     /**
63     * @dev Tells the address of the owner
64     * @return the address of the owner
65     */
66     function pendingProxyOwner() public view returns (address pendingOwner) {
67         bytes32 position = pendingProxyOwnerPosition;
68         assembly {
69             pendingOwner := sload(position)
70         }
71     }
72 
73     /**
74     * @dev Sets the address of the owner
75     */
76     function _setUpgradeabilityOwner(address newProxyOwner) internal {
77         bytes32 position = proxyOwnerPosition;
78         assembly {
79             sstore(position, newProxyOwner)
80         }
81     }
82 
83     /**
84     * @dev Sets the address of the owner
85     */
86     function _setPendingUpgradeabilityOwner(address newPendingProxyOwner) internal {
87         bytes32 position = pendingProxyOwnerPosition;
88         assembly {
89             sstore(position, newPendingProxyOwner)
90         }
91     }
92 
93     /**
94     * @dev Allows the current owner to transfer control of the contract to a newOwner.
95     *changes the pending owner to newOwner. But doesn't actually transfer
96     * @param newOwner The address to transfer ownership to.
97     */
98     function transferProxyOwnership(address newOwner) external onlyProxyOwner {
99         require(newOwner != address(0));
100         _setPendingUpgradeabilityOwner(newOwner);
101         emit NewPendingOwner(proxyOwner(), newOwner);
102     }
103 
104     /**
105     * @dev Allows the pendingOwner to claim ownership of the proxy
106     */
107     function claimProxyOwnership() external onlyPendingProxyOwner {
108         emit ProxyOwnershipTransferred(proxyOwner(), pendingProxyOwner());
109         _setUpgradeabilityOwner(pendingProxyOwner());
110         _setPendingUpgradeabilityOwner(address(0));
111     }
112 
113     /**
114     * @dev Allows the proxy owner to upgrade the current version of the proxy.
115     * @param implementation representing the address of the new implementation to be set.
116     */
117     function upgradeTo(address implementation) external onlyProxyOwner {
118         address currentImplementation;
119         bytes32 position = implementationPosition;
120         assembly {
121             currentImplementation := sload(position)
122         }
123         require(currentImplementation != implementation);
124         assembly {
125           sstore(position, implementation)
126         }
127         emit Upgraded(implementation);
128     }
129     /**
130     * @dev This event will be emitted every time the implementation gets upgraded
131     * @param implementation representing the address of the upgraded implementation
132     */
133     event Upgraded(address indexed implementation);
134 
135     // Storage position of the address of the current implementation
136     bytes32 private constant implementationPosition = 0xc20777594ecafd73f44a72aa5ad2de8704211212d04473d4b208539e34ba14eb; //keccak256("trueAUD.proxy.implementation");
137 
138     function implementation() public returns (address impl) {
139         bytes32 position = implementationPosition;
140         assembly {
141             impl := sload(position)
142         }
143     }
144 
145     /**
146     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
147     * This function will return whatever the implementation call returns
148     */
149     function() external payable {
150         assembly {
151             let ptr := mload(0x40)
152             calldatacopy(ptr, returndatasize, calldatasize)
153             let result := delegatecall(gas, sload(0xc20777594ecafd73f44a72aa5ad2de8704211212d04473d4b208539e34ba14eb), ptr, calldatasize, returndatasize, returndatasize)
154             returndatacopy(ptr, 0, returndatasize)
155 
156             switch result
157             case 0 { revert(ptr, returndatasize) }
158             default { return(ptr, returndatasize) }
159         }
160     }
161 }
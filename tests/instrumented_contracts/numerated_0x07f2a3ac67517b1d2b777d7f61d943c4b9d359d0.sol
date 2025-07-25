1 pragma solidity ^0.4.16;
2 
3 contract Permissions {
4 
5 	address ownerAddress;
6 	address storageAddress;
7 	address callerAddress;
8 
9 	function Permissions() public {
10 		ownerAddress = msg.sender;
11 	}
12 
13 	modifier onlyOwner() {
14 		require(msg.sender == ownerAddress);
15 		_;
16 	}
17 
18 	modifier onlyCaller() {
19 		require(msg.sender == callerAddress);
20 		_;
21 	}
22 
23 	function getOwner() view external returns (address) {
24 		return ownerAddress;
25 	}
26 
27 	function getStorageAddress() view external returns (address) {
28 		return storageAddress;
29 	}
30 
31 	function getCaller() view external returns (address) {
32 		return callerAddress;
33 	}
34 
35 	function transferOwnership(address newOwner) external onlyOwner {
36 		if (newOwner != address(0)) {
37 				ownerAddress = newOwner;
38 		}
39 	}
40 	function newStorage(address _new) external onlyOwner {
41 		if (_new != address(0)) {
42 				storageAddress = _new;
43 		}
44 	}
45 	function newCaller(address _new) external onlyOwner {
46 		if (_new != address(0)) {
47 				callerAddress = _new;
48 		}
49 	}
50 }
51 
52 contract Creatures is Permissions {
53 	struct Creature {
54 		uint16 species;
55 		uint8 subSpecies;
56 		uint8 eyeColor;
57 		uint64 timestamp;
58 	}
59 	Creature[] creatures;
60 
61 	mapping (uint256 =>	address) public creatureIndexToOwner;
62 	mapping (address => uint256) ownershipTokenCount;
63 
64 	event CreateCreature(uint256 id, address indexed owner);
65 	event Transfer(address _from, address _to, uint256 creatureID);
66 
67 	function add(address _owner, uint16 _species, uint8 _subSpecies, uint8 _eyeColor) external onlyCaller {
68 		// do checks in caller function
69 		Creature memory _creature = Creature({
70 			species: _species,
71 			subSpecies: _subSpecies,
72 			eyeColor: _eyeColor,
73 			timestamp: uint64(now)
74 		});
75 		uint256 newCreatureID = creatures.push(_creature) - 1;
76 		transfer(0, _owner, newCreatureID);
77 		CreateCreature(newCreatureID, _owner);
78 	}
79 	function getCreature(uint256 id) external view returns (address, uint16, uint8, uint8, uint64) {
80 		Creature storage c = creatures[id];
81 		address owner = creatureIndexToOwner[id];
82 		return (
83 			owner,
84 			c.species,
85 			c.subSpecies,
86 			c.eyeColor,
87 			c.timestamp
88 		);
89 	}
90 	function transfer(address _from, address _to, uint256 _tokenId) public onlyCaller {
91 		// do checks in caller function
92 		creatureIndexToOwner[_tokenId] = _to;
93 		if (_from != address(0)) {
94 			ownershipTokenCount[_from]--;
95 		}
96 		ownershipTokenCount[_to]++;
97 		Transfer(_from, _to, _tokenId);
98 	}
99 }
100 
101 contract CreaturesInterface is Permissions {
102 
103 	mapping (uint8 => uint256) public creatureCosts;
104 
105 	function CreaturesInterface() public {
106 		creatureCosts[0] = .10 ether;
107 		creatureCosts[1] = .25 ether;
108 		creatureCosts[2] = .12 ether;
109 		creatureCosts[3] = .50 ether;
110 		creatureCosts[4] = .10 ether;
111 		creatureCosts[5] = 2.0 ether;
112 		creatureCosts[6] = 2.0 ether;
113 		creatureCosts[7] = 1.0 ether;
114 		creatureCosts[8] = 1.0 ether;
115 		creatureCosts[9] = .50 ether;
116 		creatureCosts[10] = .50 ether;
117 		creatureCosts[11] = .20 ether;
118 		creatureCosts[12] = .50 ether;
119 		creatureCosts[13] = .10 ether;
120 		creatureCosts[14] = 1.0 ether;
121 		creatureCosts[15] = 1.0 ether;
122 		creatureCosts[16] = 10 ether;
123 	}
124 
125 	function addCreature(uint16 _species, uint8 _subSpecies, uint8 _eyeColor) external payable {
126 		require(_species == 0); // only one species available for now
127 		require(creatureCosts[_subSpecies] > 0);
128 		require(msg.value >= creatureCosts[_subSpecies]);
129 		Creatures creatureStorage = Creatures(storageAddress);
130 		creatureStorage.add(msg.sender, _species, _subSpecies, _eyeColor);
131 	}
132     function withdrawBalance() external onlyOwner {
133         ownerAddress.transfer(this.balance);
134     }
135 }
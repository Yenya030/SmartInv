1 {{
2   "language": "Solidity",
3   "settings": {
4     "evmVersion": "istanbul",
5     "libraries": {},
6     "metadata": {
7       "bytecodeHash": "ipfs",
8       "useLiteralContent": true
9     },
10     "optimizer": {
11       "enabled": true,
12       "runs": 200
13     },
14     "remappings": [],
15     "outputSelection": {
16       "*": {
17         "*": [
18           "evm.bytecode",
19           "evm.deployedBytecode",
20           "devdoc",
21           "userdoc",
22           "metadata",
23           "abi"
24         ]
25       }
26     }
27   },
28   "sources": {
29     "@openzeppelin/contracts/cryptography/MerkleProof.sol": {
30       "content": "// SPDX-License-Identifier: MIT\n\npragma solidity >=0.6.0 <0.8.0;\n\n/**\n * @dev These functions deal with verification of Merkle trees (hash trees),\n */\nlibrary MerkleProof {\n    /**\n     * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree\n     * defined by `root`. For this, a `proof` must be provided, containing\n     * sibling hashes on the branch from the leaf to the root of the tree. Each\n     * pair of leaves and each pair of pre-images are assumed to be sorted.\n     */\n    function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {\n        bytes32 computedHash = leaf;\n\n        for (uint256 i = 0; i < proof.length; i++) {\n            bytes32 proofElement = proof[i];\n\n            if (computedHash <= proofElement) {\n                // Hash(current computed hash + current element of the proof)\n                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));\n            } else {\n                // Hash(current element of the proof + current computed hash)\n                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));\n            }\n        }\n\n        // Check if the computed hash (root) is equal to the provided root\n        return computedHash == root;\n    }\n}\n"
31     },
32     "@openzeppelin/contracts/token/ERC20/IERC20.sol": {
33       "content": "// SPDX-License-Identifier: MIT\n\npragma solidity >=0.6.0 <0.8.0;\n\n/**\n * @dev Interface of the ERC20 standard as defined in the EIP.\n */\ninterface IERC20 {\n    /**\n     * @dev Returns the amount of tokens in existence.\n     */\n    function totalSupply() external view returns (uint256);\n\n    /**\n     * @dev Returns the amount of tokens owned by `account`.\n     */\n    function balanceOf(address account) external view returns (uint256);\n\n    /**\n     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transfer(address recipient, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Returns the remaining number of tokens that `spender` will be\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n     * zero by default.\n     *\n     * This value changes when {approve} or {transferFrom} are called.\n     */\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n     * that someone may use both the old and the new allowance by unfortunate\n     * transaction ordering. One possible solution to mitigate this race\n     * condition is to first reduce the spender's allowance to 0 and set the\n     * desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n     * allowance mechanism. `amount` is then deducted from the caller's\n     * allowance.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n     * another (`to`).\n     *\n     * Note that `value` may be zero.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    /**\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n     * a call to {approve}. `value` is the new allowance.\n     */\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n"
34     },
35     "contracts/MerkleDistributorSimple.sol": {
36       "content": "// SPDX-License-Identifier: UNLICENSED\npragma solidity ^0.7.0;\n\nimport \"@openzeppelin/contracts/token/ERC20/IERC20.sol\";\nimport \"@openzeppelin/contracts/cryptography/MerkleProof.sol\";\nimport \"./interfaces/IMerkleDistributor.sol\";\n\ncontract MerkleDistributorSimple is IMerkleDistributor {\n    address public immutable override token;\n    bytes32 public immutable override merkleRoot;\n\n    // This is a packed array of booleans.\n    mapping(uint256 => uint256) private claimedBitMap;\n\n    constructor(address token_, bytes32 merkleRoot_) public {\n        token = token_;\n        merkleRoot = merkleRoot_;\n    }\n\n    function isClaimed(uint256 index) public view override returns (bool) {\n        uint256 claimedWordIndex = index / 256;\n        uint256 claimedBitIndex = index % 256;\n        uint256 claimedWord = claimedBitMap[claimedWordIndex];\n        uint256 mask = (1 << claimedBitIndex);\n        return claimedWord & mask == mask;\n    }\n\n    function _setClaimed(uint256 index) private {\n        uint256 claimedWordIndex = index / 256;\n        uint256 claimedBitIndex = index % 256;\n        claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);\n    }\n\n    function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external override {\n        require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');\n\n        // Verify the merkle proof.\n        bytes32 node = keccak256(abi.encodePacked(index, account, amount));\n        require(MerkleProof.verify(merkleProof, merkleRoot, node), 'MerkleDistributor: Invalid proof.');\n\n        // Mark it claimed and send the token.\n        _setClaimed(index);\n        require(IERC20(token).transfer(account, amount), 'MerkleDistributor: Transfer failed.');\n\n        emit Claimed(index, account, amount);\n    }\n}\n"
37     },
38     "contracts/interfaces/IMerkleDistributor.sol": {
39       "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.7.0;\n\n// Allows anyone to claim a token if they exist in a merkle root.\ninterface IMerkleDistributor {\n  // Returns the address of the token distributed by this contract.\n  function token() external view returns (address);\n\n  // Returns the merkle root of the merkle tree containing account balances available to claim.\n  function merkleRoot() external view returns (bytes32);\n\n  // Returns true if the index has been marked claimed.\n  function isClaimed(uint256 index) external view returns (bool);\n\n  // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.\n  function claim(\n    uint256 index,\n    address account,\n    uint256 amount,\n    bytes32[] calldata merkleProof\n  ) external;\n\n  // This event is triggered whenever a call to #claim succeeds.\n  event Claimed(uint256 index, address account, uint256 amount);\n}\n"
40     }
41   }
42 }}
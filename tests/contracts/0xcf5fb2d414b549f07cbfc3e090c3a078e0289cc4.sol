/**
 *Submitted for verification at Etherscan.io on 2021-11-25
*/

/**
 *Submitted for verification at polygonscan.com on 2021-11-08
*/

// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.7.6;

interface IERC20 {
  /**
   * @dev Moves `amount` tokens from the caller's account to `recipient`.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transfer(address recipient, uint256 amount) external returns (bool);
}


contract MerkleDistributor {
  bytes32[] public merkleRoots;
  bytes32 public pendingMerkleRoot;
  uint256 public lastRoot;


  address public constant rewardToken =0x8Ab17e2cd4F894F8641A31f99F673a5762F53c8e;
  // admin address which can propose adding a new merkle root
  address public proposalAuthority;
  // admin address which approves or rejects a proposed merkle root
  address public reviewAuthority;

  event Claimed(
    uint256 merkleIndex,
    uint256 index,
    address account,
    uint256 amount
  );

  // This is a packed array of booleans.
  mapping(uint256 => mapping(uint256 => uint256)) private claimedBitMap;

  constructor(address _proposalAuthority, address _reviewAuthority) public {
    proposalAuthority = _proposalAuthority;
    reviewAuthority = _reviewAuthority;
  }

  function setProposalAuthority(address _account) public {
    require(msg.sender == proposalAuthority);
    proposalAuthority = _account;
  }

  function setReviewAuthority(address _account) public {
    require(msg.sender == reviewAuthority);
    reviewAuthority = _account;
  }

  // we modify time between two merkle to10hrs
  function proposeMerkleRoot(bytes32 _merkleRoot) public {
    require(msg.sender == proposalAuthority);
    require(pendingMerkleRoot == 0x00);
    require(block.timestamp > lastRoot + 36000);
    pendingMerkleRoot = _merkleRoot;
  }

  // After validating the correctness of the pending merkle root, the reviewing authority
  // calls to confirm it and the distribution may begin.
  function reviewPendingMerkleRoot(bool _approved) public {
    require(msg.sender == reviewAuthority);
    require(pendingMerkleRoot != 0x00);
    if (_approved) {
      merkleRoots.push(pendingMerkleRoot);
      lastRoot = block.timestamp;
    }
    delete pendingMerkleRoot;
  }

  function isClaimed(uint256 merkleIndex, uint256 index)
    public
    view
    returns (bool)
  {
    uint256 claimedWordIndex = index / 256;
    uint256 claimedBitIndex = index % 256;
    uint256 claimedWord = claimedBitMap[merkleIndex][claimedWordIndex];
    uint256 mask = (1 << claimedBitIndex);
    return claimedWord & mask == mask;
  }

  function _setClaimed(uint256 merkleIndex, uint256 index) private {
    uint256 claimedWordIndex = index / 256;
    uint256 claimedBitIndex = index % 256;
    claimedBitMap[merkleIndex][claimedWordIndex] =
      claimedBitMap[merkleIndex][claimedWordIndex] |
      (1 << claimedBitIndex);
  }

  function claim(
    uint256 merkleIndex,
    uint256 index,
    uint256 amount,
    bytes32[] calldata merkleProof
  ) external {
    require(
      merkleIndex < merkleRoots.length,
      'MerkleDistributor: Invalid merkleIndex'
    );
    require(
      !isClaimed(merkleIndex, index),
      'MerkleDistributor: Drop already claimed.'
    );

    // Verify the merkle proof.
    bytes32 node = keccak256(abi.encodePacked(index, msg.sender, amount));
    require(
      verify(merkleProof, merkleRoots[merkleIndex], node),
      'MerkleDistributor: Invalid proof.'
    );

    // Mark it claimed and send the token.
    _setClaimed(merkleIndex, index);
    IERC20(rewardToken).transfer(msg.sender, amount);

    emit Claimed(merkleIndex, index, msg.sender, amount);
  }

  function verify(
    bytes32[] memory proof,
    bytes32 root,
    bytes32 leaf
  ) internal pure returns (bool) {
    bytes32 computedHash = leaf;

    for (uint256 i = 0; i < proof.length; i++) {
      bytes32 proofElement = proof[i];

      if (computedHash <= proofElement) {
        // Hash(current computed hash + current element of the proof)
        computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
      } else {
        // Hash(current element of the proof + current computed hash)
        computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
      }
    }

    // Check if the computed hash (root) is equal to the provided root
    return computedHash == root;
  }

  function recoverFunds(address _token,uint256 _amount) public {
    require(msg.sender == reviewAuthority);
    IERC20(_token).transfer(msg.sender,_amount);
    
    }
}
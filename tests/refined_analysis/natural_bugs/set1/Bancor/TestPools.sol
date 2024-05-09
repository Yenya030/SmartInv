// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

import { Pools, Pool } from "../carbon/Pools.sol";
import { Token } from "../token/Token.sol";

contract TestPools is Pools {
    function test_poolById(uint256 poolId) external view returns (Pool memory) {
        return _poolById(poolId);
    }

    function test_createPool(Token token0, Token token1) external returns (Pool memory) {
        return _createPool(token0, token1);
    }
}

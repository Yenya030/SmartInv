// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Melodity is ERC20 {
    constructor() ERC20("Melodity", "MELD") {
        // max supply 1 billion MELD

        _mint(payable(address(0xD270299A4a2Ab82A5a5352dEfE748e2a5732e738)), 350000000 * 1 ether);   // ico address - 350 million
        _mint(payable(address(0x01Af10f1343C05855955418bb99302A6CF71aCB8)), 250000000 * 1 ether);   // company multisig - 250 million
        _mint(payable(address(0x8224a83d5bb631316C4491dd8AC3C4300bE5F0C4)), 200000000 * 1 ether);   // pre ico investment - 200 million
        _mint(payable(address(0x7C44bEfc22111e868b3a0B1bbF30Dd48F99682b3)), 125000000 * 1 ether);   // bridge wallet - 100 million
        _mint(payable(address(0xFC5dA6A95E0C2C2C23b8C0c387CDd3Af7E56FCC0)), 25000000 * 1 ether);    // ebalo
        _mint(payable(address(0x618E9F7bbbeF323019eEf457f3b94E9E7943633A)), 25000000 * 1 ether);    // rolen
        _mint(payable(address(0x3198c11724024C9cE7F81816E6E6B69580fe5585)), 25000000 * 1 ether);    // will
    
    }
}
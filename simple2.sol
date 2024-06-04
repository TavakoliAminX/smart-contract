// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
contract simpleTwo {

    uint256 public Data;

    function Result() public pure returns (uint256) {
        uint256 a = 7;
        uint256 b = 3;
        uint256 result = a + b;
        return result;
    }

    function SenderOfTransaction() public view returns (address) {
        return msg.sender;
    }

    function ChainId() public view returns (uint256) {
        return block.chainid;
    }
}
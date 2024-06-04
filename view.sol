// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
contract views {
    string public name = "good job";

    
    function getName() public view returns (string memory) {
        return name;
    }
    function sum(int256 X, int256 Y) public pure returns (int256) {
        return X + Y;
    }
}
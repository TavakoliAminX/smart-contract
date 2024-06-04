// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
contract Storage {
    string name;
    string family;
    constructor(string memory _name ,  string memory _family) {
        name = _name;
        family = _family;
    }
    function data() public view returns (string memory) {
        return string(abi.encodePacked(family, " ", name));
    }
}
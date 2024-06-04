// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
contract ifEsle {
    string public name;

    function symbolNum(uint256 _name) public {
        if (_name == 1) {
            name = "";
        } else if (_name == 2) {
            name = "";
        } else {
            name = "";
        }
    }
}
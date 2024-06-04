// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
contract loops {
    uint public Count;

    function doLoop(uint x) public {
        for (uint i = 0; i < x; i++) {
            Count += 1;
        }
    }
}
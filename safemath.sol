// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

library SafeMath {

    function add(uint x, uint y) internal pure returns(uint) {
        uint z = x + y;
        require(z>=x);
        return z;
    }
}
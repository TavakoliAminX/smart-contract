// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
contract Gas {

    uint8 result1 = 0;
    uint result2 = 0;

    function UseUInt8() public  returns (uint8) {
        uint8 select = 50;
        for (uint8 i = 0; i < select; i++) {
            result1 += 1;
        }
        return result1;
    }

    function UseUint() public returns (uint) {
        uint select = 50;
        for (uint i = 0; i < select; i++) {
            result2 += 1;
        }
        return result2;
    }

    
}
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "./safemath.sol";

contract SafeMathTest {

    using SafeMath for uint;
	
    function testAddV1(uint a, uint b) public pure returns(uint) {
        return a.add(b); 
    }

    function testAddV2(uint a, uint b) public pure returns(uint) {
        return SafeMath.add(a,b); 
    }
}
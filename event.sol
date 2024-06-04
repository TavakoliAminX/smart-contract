// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
contract events {
    string public  name;

    event first(string neW);

    function setName(string memory neW) public {
        name = neW;
        emit first(neW);
    }
}
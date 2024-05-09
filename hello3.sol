// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

contract Hello {

    string public hellostr;

    constructor() {
        hellostr = "Hello World!";
    }

    function setHello(string memory newValue) public {
        hellostr = newValue;
    }

    function getHello() public view returns(string memory) {
        return hellostr;
    }
}
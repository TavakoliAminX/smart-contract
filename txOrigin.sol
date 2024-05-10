// SPDX-License-Identifier: MIT
pragma solidity >=0.7.2 <0.9.0;


contract A {
    address public msgSender;
    address public txOrigin;

    function setVarsC() external {
        msgSender = msg.sender;
        txOrigin = tx.origin;
    }

}


contract B {
    address public msgSender;
    address public txOrigin;

    function setVarsB(address adrA) external returns (bool status) {
        msgSender = msg.sender;
        txOrigin = tx.origin;

        (status, ) = adrA.call(abi.encodeWithSignature("setVarsC()"));
        require(status, "call failed");
    }
}


contract C {
    address public msgSender;
    address public txOrigin;

    function setVarsA(address adrA, address adrB) external returns (bool status) {
        msgSender = msg.sender;
        txOrigin = tx.origin;

        (status, ) = adrB.call(abi.encodeWithSignature("setVarsB(address)", adrA));
        require(status, "call failed");
    }
}
// SPDX-License-Identifier: MIT
pragma solidity >=0.7.2 <0.9.0;

contract Target {

    uint public num;
    address public sender;
    uint public value;


    function setVars(uint _num) external payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}



contract Caller {

    uint public num;
    address public sender;
    uint public value;


    address immutable targetAdr;

    constructor(address targetAdr_) {
        targetAdr = targetAdr_;
    }

    fallback(bytes calldata data) external payable returns (bytes memory) {

        (bool status, bytes memory result) = targetAdr.delegatecall(data);
        require(status, "call failed");
        return result;
    }

    receive() external payable {}
}



contract Source {

    uint public num;
    address public sender;
    uint public value;

    address immutable callerAdr;

    constructor(address callerAdr_) {
        callerAdr = callerAdr_;
    }

    function setVars(uint _num) external payable returns (bool status, bytes memory result) { 
        (status, result) = callerAdr.delegatecall(abi.encodeWithSignature("setVars(uint256)", _num));
        require(status, "delegatecall failed");
    }
}
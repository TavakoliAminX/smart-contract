// SPDX-License-Identifier: MIT
pragma solidity >=0.7.2 <0.9.0;

contract Receiver {

    string result = "jobe done!";

    function getResult() external view returns (string memory) {
        return result;
    }

    receive() external payable {}

    fallback(bytes calldata data) external payable returns (bytes memory) {
        (bool sent, bytes memory res) = address(this).staticcall(data);
        require(sent, "call failed");
        return res;
    }
}

contract Sender {

    address immutable receiverAdr;
    event Response(bool status, bytes data);

    constructor(address receiver_) {
        receiverAdr = receiver_;
    }

    function call_receive() public view returns (bool success, bytes memory result) {
        (success, result) = receiverAdr.staticcall("");
        require(success, "Failed to staticcall");
    }

    function call_fallbacl() public view returns (bool success, bytes memory result) {
        (success, result) = receiverAdr.staticcall(abi.encodeWithSignature("getResult()"));
        require(success, "Failed to staticcall");
    }
}


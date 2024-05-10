// SPDX-License-Identifier: MIT
pragma solidity >=0.7.2 <0.9.0;

contract Receiver {

    mapping(address => uint) public payments;
    event Received(string handler, address sender, uint amount);
    function payment() external payable {
        payments[msg.sender] += msg.value;
        emit Received("payment()", msg.sender, msg.value);
    }


    function payAndGetBalance(string memory _message) public payable returns (uint) {
        payments[msg.sender] += msg.value;
        emit Received(_message, msg.sender, msg.value);
        return payments[msg.sender];
    }

    receive() external payable {
        payments[msg.sender] += msg.value;
        emit Received("receive()", msg.sender, msg.value);
    }

    fallback() external payable {
        payments[msg.sender] += msg.value;
        emit Received("fallback()", msg.sender, msg.value);
    }
}


contract Sender {

    address immutable receiverAdr;

    event Response(bool status, bytes data);

    constructor(address receiver_) {
        receiverAdr = receiver_;
    }

    function pay_ViaCall() public payable {

        (bool sent, bytes memory data) = receiverAdr.call{value: msg.value}("");

        require(sent, "Failed to send Ether");
        emit Response(sent, data);
    }


    function call_payment() public payable {

        (bool sent, bytes memory data) = receiverAdr.call
            {value: msg.value}
            (abi.encodeWithSignature("payment()"));

        require(sent, "Failed to send Ether");
        emit Response(sent, data);
    }

    function call_payAndGetBalance() public payable {

        
        (bool sent, bytes memory data) = receiverAdr.call
            {value: msg.value, gas: 10_000}
            (abi.encodeWithSignature("payAndGetBalance(string)", "we are calling via call_payAndGetBalance"));

        require(sent, "Failed to send Ether");
        emit Response(sent, data);
    }


    
    function call_fallbacl() public payable {

        
        (bool sent, bytes memory data) = receiverAdr.call
            {value: msg.value}
            (abi.encodeWithSignature("nonExistingFunction()"));

        require(sent, "Failed to send Ether");
        emit Response(sent, data);
    }
}
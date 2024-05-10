// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

contract Receiver {


    event Received(address, uint);

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }
}


contract Sender {

    address payable immutable receiverAdr;

    constructor(address payable receiver_) {
        receiverAdr = receiver_;
    }


    function pay_ViaTransfer() public payable {
        receiverAdr.transfer(msg.value);    // Receiver.receive() will be executed
    }


    function pay_ViaSend() public payable {
        bool sent = receiverAdr.send(msg.value);    
        require(sent, "Failed to send Ether");
    }
}
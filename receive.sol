// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

contract receiver {

}


contract Sender {
    
    function endow() public payable {}


    function transfer(address _receiver) public {
        address payable payableReceiver = payable(_receiver);
        payableReceiver.transfer(1 ether);
    }


    function send(address _receiver) public returns (bool) {

        address payable payableReceiver = payable(_receiver);

        return payableReceiver.send(1 ether);
    }

    function call(address _receiver) public returns (bool) {
        (bool result, ) = _receiver.call{value: 1 ether}("");
        return  result;
    }
}
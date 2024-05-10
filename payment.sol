// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract Payment {

    constructor() payable {}

    
    function payToContract() public payable {}


    function payTransfer(address payable to, uint amount) public {

        
        require(address(this).balance >= amount, "Not enough balance!");

        to.transfer(amount);

    }


    function paySend(address payable to, uint amount) public {

        
        require(address(this).balance >= amount, "Not enough balance!");

        bool result = to.send(amount);

        
        require(result == true, "Failure in payment via send!");
    }


    function payCall(address payable to, uint amount) public {

        
        require(address(this).balance >= amount, "Not enough balance!");

        (bool result, ) = to.call{value: amount}("");

        
        require(result == true, "Failure in payment via call!");
    }


    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

}

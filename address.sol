// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

contract Address {

   

    address public contractAdress;
    address public OwnerAdress;

    constructor() {
       
        OwnerAdress = msg.sender;
        contractAdress = address(this);
    }

    function deposit() payable public {
        
        // msg.value : wei
        if(msg.value == 0)
            
            revert("Your value must be grater than zero");
    }


    function getBalance(address Address) public view returns(uint) {
        
        return Address.balance; // wei
    }

    
    function destructor() public {
        if(msg.sender == ownerAdr)
            selfdestruct(payable(ownerAdr));
        else
            revert("Only Owner can call it!");
    }
}

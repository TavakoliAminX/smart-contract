// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
contract transfers {
    address payable public owner;

    constructor() payable {
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function withdraw(uint256 amount) public onlyOwner {
        owner.transfer(amount);
    }

    function transfer(address  to, uint256 amount) public onlyOwner {
       payable  (to).transfer(amount);
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Secure {

    address public owner;

    constructor() {
        owner = msg.sender;
    }
    
    event Deposit(address indexed user, uint amount);

    event Withdrawal(address indexed user, uint amount);

    mapping(address => uint) public balances;



    function deposit() public payable {
        require(msg.value > 0);
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount);
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
        emit Withdrawal(msg.sender, _amount);
    }

    function emergencyWithdraw() public {
        require(msg.sender == owner);
        payable(owner).transfer(address(this).balance);
    }

    function transferOwnership(address newOwner) public {
        require(msg.sender == owner);
        require(newOwner != address(0));
        owner = newOwner;
    }

    
    receive() external payable {
        deposit();
    }
}





contract SecureContract {
    address public owner;

    constructor() {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), owner);
    }

    event Deposit(address indexed user, uint amount);
    event Withdrawal(address indexed user, uint amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    mapping(address => uint) public balances;

   

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    

    function deposit() public payable {
        require(msg.value > 0);
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint _amount) public {
        uint balance = balances[msg.sender];
        require(balance >= _amount);

        balances[msg.sender] -= _amount;

        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success);

        emit Withdrawal(msg.sender, _amount);
    }

    function emergencyWithdraw() public onlyOwner {
        uint contractBalance = address(this).balance;
        require(contractBalance > 0);

        (bool success, ) = owner.call{value: contractBalance}("");
        require(success);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    fallback() external payable {
        revert("");
    }

    receive() external payable {
        deposit();
    }
}

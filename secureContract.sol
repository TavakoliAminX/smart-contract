// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import"@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SecureContract {

    address public owner;
    bool public paused;
    bool private reentrancyGuard;

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

    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    modifier whenPaused() {
        require(paused);
        _;
    }

    modifier nonReentrant() {
        require(!reentrancyGuard);
        reentrancyGuard = true;
        _;
        reentrancyGuard = false;
    }

    

    function deposit() public payable whenNotPaused {
        require(msg.value > 0);
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint _amount) public whenNotPaused nonReentrant {
        uint balance = balances[msg.sender];
        require(balance >= _amount);
        balances[msg.sender] -= _amount;
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success);
        emit Withdrawal(msg.sender, _amount);
    }

    function emergencyWithdraw() public onlyOwner nonReentrant whenPaused {
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
        revert();
    }

    receive() external payable {
        deposit();
    }

    function balanceOf(address _address) public view returns (uint) {
        return balances[_address];
    }

    

    function pause() public onlyOwner whenNotPaused {
        paused = true;
    }

    function unpause() public onlyOwner whenPaused {
        paused = false;
    }

    function withdrawTo(address payable to, uint amount) public onlyOwner {
        require(to != address(0));
        require(amount <= address(this).balance);
        (bool success, ) = to.call{value: amount}("");
        require(success);
    }


    function safeguard(uint _amount) public onlyOwner {
        require(_amount <= address(this).balance);
        (bool success, ) = owner.call{value: _amount}("");
        require(success);
    }

    function safeWithdraw(uint _amount) public nonReentrant whenNotPaused {
        uint balance = balances[msg.sender];
        require(balance >= _amount);
        balances[msg.sender] -= _amount;
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success);
        emit Withdrawal(msg.sender, _amount);
    }

    function safeEmergencyWithdraw() public onlyOwner nonReentrant whenPaused {
        uint contractBalance = address(this).balance;
        require(contractBalance > 0);
        (bool success, ) = owner.call{value: contractBalance}("");
        require(success);
    }

    function recoverTokens(address tokenAddress, uint tokenAmount) public onlyOwner {
        require(tokenAddress != address(0));
        require(tokenAmount > 0);
        IERC20(tokenAddress).transfer(owner, tokenAmount);
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

}








































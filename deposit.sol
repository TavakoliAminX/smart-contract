// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract TimeLock is Ownable {

    uint public immutable lockDuration;

    
    mapping(address => uint) public balances;

    
    mapping(address => uint) public lockTimes;

    constructor() {
        lockDuration = 1 weeks;
    }


    function deposit() public payable {
        
        balances[msg.sender] += msg.value;

        
        lockTimes[msg.sender] = block.timestamp + lockDuration;
    }


    function withdraw() public {
        
        require(balances[msg.sender] > 0, "insufficient funds");

        
        require(block.timestamp > lockTimes[msg.sender], "lock time has not expired");

        
        uint amount =  balances[msg.sender];
        balances[msg.sender] = 0;

        
        (bool result, ) = msg.sender.call{value: amount}("");
        require(result, "Failed to send ether");
    }


    function increaseLockTime(address _account, uint _seconds) public onlyOwner {
        lockTimes[_account] += _seconds;
    }


    function decreaseLockTime(address _account, uint _seconds) public onlyOwner {
        lockTimes[_account] -= _seconds;
    }
}
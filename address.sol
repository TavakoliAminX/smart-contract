// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
contract Address{
    address  owner;
    event Transfer(address to, uint amount);
    mapping (string => address)  users;

    constructor() {
        owner = msg.sender;
    }
    
    modifier isOwner{
        require(owner == msg.sender);
        _;
    }
    
    function addAddress(string memory user, address to) public  isOwner {
        users[user] = to;
    }
    
    function queryAddress(string memory user ) public  view isOwner returns(address) {
        return users[user];
    }
    
    function removeAddress(string memory user) public  isOwner{
        users[user]=address(0);
    }
    
    function changeAddress(string memory user, address to) public   isOwner{
        users[user] = to;
    }
    
    function transferTo(string memory user,  uint amount)   public{
        require(msg.sender.balance >= amount);
        require(users[user]!=address(0));
        
      payable (users[user]).transfer(amount);
       emit Transfer(msg.sender, amount);
    }
}
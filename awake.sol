// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Awake {

    address public owner;

    uint public immutable tourCost = 1e18;

    struct Member {
        bool isMember;      
        bool isAwake;       
        bool isCancel;      
        bool isPaid;        
    }

    mapping(address => Member) memberList;

    uint memberCount;   
    uint awakeCount;    
    uint share;         

    constructor() {
        owner = msg.sender;
    }


    
    function register() public payable {

        
        require(msg.value == tourCost,  "Value Not equal 1 Eth");  // 10**18 ~ 1e18 ~ 1 Eth

        
        require(memberList[msg.sender].isMember == false, "Already Registered!");


        memberList[msg.sender].isMember = true;

        
             memberCount++;  
    }


    
    function awake() public {
        
        
        require(memberList[msg.sender].isMember == true, "You Dont Registered!");

        
        memberList[msg.sender].isAwake = true;

        awakeCount++;
    }


    function cancel() public {

        require(memberList[msg.sender].isMember == true, "You Dont Registered!");

        if(memberList[msg.sender].isAwake) {
            memberList[msg.sender].isAwake = false;
            awakeCount--;
        }

        memberList[msg.sender].isCancel = true;

        require(memberList[msg.sender].isPaid == false, "You are Already Paid!");

        paySend(msg.sender, tourCost);

        memberList[msg.sender].isPaid = true;
    }


    function payShare() public {
        
        
        require(memberList[msg.sender].isMember == true, "You Dont Registered!");

        require(memberList[msg.sender].isAwake, "You Dont Awake!");

        require(memberList[msg.sender].isCancel == false, "You already Cancel!");

        require(memberList[msg.sender].isPaid == false, "You are Already Paid!");
        share = getBalanceContract() / awakeCount;
        paySend(msg.sender, share);

        memberList[msg.sender].isPaid = true;
    }


    function paySend(address to, uint amount) public {

        require(address(this).balance >= amount, "Not enough balance!");

        bool result = payable(to).send(amount);
        require(result == true, "Failure in payment via send!");
    }


    function getBalanceContract() public view returns (uint) {
        return address(this).balance;  
    }


    function getBalanceAccount(address adr) public view returns (uint) {
        return adr.balance;  
    }
}
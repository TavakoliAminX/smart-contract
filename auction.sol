// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
contract Auction {
    address payable public owner;
    uint public startTime;
    uint public endTime;
    string public ipfs;

    enum State {
        Started, 
        Running,
        Ended, 
        Canceled
    }
    State public state;

    uint public Bid;
    address payable public Bidder;

    mapping(address => uint) public bids;
    
    uint Increment;

    bool public Finalized = false;

    constructor(){
        owner = payable(msg.sender);
        state = State.Running;
        startTime = block.number;
        endTime = startTime + 40320;

        ipfs = "";

        Increment = 100;
    }

    modifier notOwner(){
        require(msg.sender != owner);
        _;
    }
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    modifier afterStar(){
        require(block.number >= startTime);
        _;
    }
    modifier beforeEnd(){
        require(block.number != endTime);
        _;
    }

    function min(uint a, uint b) pure internal returns(uint){
        if (a <= b){
            return a;
        }else{
            return b;
        }
    }

    function cancel() public beforeEnd onlyOwner{
        state = State.Canceled;
    }

    function place() public payable notOwner afterStar beforeEnd returns(bool){

        require(state == State.Running);
        uint currentBid = bids[msg.sender] + msg.value;

        require(currentBid > Bid);

        bids[msg.sender] = currentBid;

        if(currentBid <= bids[Bidder]){
            Bid = min(currentBid + Increment, bids[Bidder]);
        }else{
            Bid = min(currentBid, bids[Bidder] + Increment);
            Bidder = payable(msg.sender);
        }
        return true;
    }

    function finaliz() public{

        require(state == State.Canceled || block.number > endTime);

        require(msg.sender == owner || bids[msg.sender] > 0);

        address payable recipient;
        uint value;

        if(state == State.Canceled){
            recipient = payable(msg.sender);
            value = bids[msg.sender];

        }else{

            if(msg.sender == owner && Finalized == false){
                recipient = owner;
                value = Bid;

                Finalized = true;

            }else{
                if(msg.sender == Bidder){
                    recipient = Bidder;
                    value = bids[Bidder] - Bid;

                }else{
                    recipient = payable(msg.sender);
                    value = bids[msg.sender];
                }
            }


            bids[recipient] = 0;

            recipient.transfer(value);
        }
    }
}
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.5 <=0.8.20;

contract Auction {

    address public owner;

    address public benecificiary;    

    uint public auctionStartTime;   
    uint public auctionEndTime;     

    uint public highestBid;         
    address public highestBider;    

    mapping(address => uint) pendingRefunds;    

    bool ended;                 

    struct Bid {
        address bider;
        uint bidPrice;
    }
    Bid[] internal bids;        
                                

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only Owner can start the auction!");
        _;
    }

    function startAuction(address _benecificiary, uint _basePrice, uint _deadLineDur) public onlyOwner {

        benecificiary = _benecificiary;

        highestBid = _basePrice;
        highestBider = _benecificiary;
    
        auctionStartTime = block.timestamp;
        auctionEndTime = auctionStartTime + _deadLineDur;
    }


    modifier isValidTime() {
        
        require(block.timestamp < auctionEndTime, "Auction Ended!");
        _;
    }


    modifier isHighestBid() {

        require(msg.value > highestBid, "Value is less than highestBid!");
        _;
    }


    function bid() public payable isValidTime  isHighestBid {

        
        
        if(highestBider != benecificiary)
        
            pendingRefunds[highestBider] += highestBid;

        
        highestBid = msg.value;
        highestBider = msg.sender;

        bids.push( Bid(highestBider, highestBid) );
    }


    
    function refund() public returns(bool) {

    
        require(ended == true, "Auction dosn't ended!");
        
        uint amount = pendingRefunds[msg.sender];

        require(amount>0, "Your refund amount is Zero!");

        
        bool result = paySend(msg.sender, amount);
        if(result) {
            
            pendingRefunds[msg.sender] = 0;
            return true;
        } else {
            
            return false;
        }
    }


    function payToBeneficiary() public onlyOwner returns(bool) {

        require(ended == true, "Auction dosn't ended!");
       
        bool result = paySend(benecificiary, highestBid);
        if(result) {
            
        }

        return result;
    }


    function endAuction() public onlyOwner {

        require(block.timestamp >= auctionEndTime, "Auction can't end at this time!");

        ended = true;
    }


    function getBids() public view returns(Bid[] memory) {
        return bids;
    }


    function getWinner() public view returns(address, uint) {
        return (highestBider, highestBid);
    }


    function paySend(address To, uint amount) public returns(bool) {

        require(address(this).balance >= amount, "Not Enough Balance!");

        bool result = payable(To).send(amount);

        require(result == true, "Failure in payment via send!");

        return result;
    }
}

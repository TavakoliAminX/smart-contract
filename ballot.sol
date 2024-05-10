// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract ballot {

    

    struct Proposal {
        string name;
        uint8 voteCount;
    }

    Proposal[] public proposalList;     
                                        
    struct Voter {
        uint8 vote;         
        uint8 weight;       
        bool voted;         
    }

    mapping(address => Voter) public voterList;

    address public chairPerson;

    constructor(uint8 proposalCount) {

        chairPerson = msg.sender;

        voterList[chairPerson].weight = 2;

        for(uint i=0; i<proposalCount; i++) {
            proposalList.push( Proposal( { name:"", voteCount:0 } ) );
        }
    }


    function register(address voterAdr) public {

        require(msg.sender == chairPerson, "Only chairperson can call register()");

        require(voterAdr != chairPerson, "Chairperson Can't Register Again!");

        require(voterList[voterAdr].voted == false, "Voter Already Voted!");

        voterList[voterAdr].weight = 1;
    }

    function vote(uint8 proposalId) public {

        require(proposalId >= 0 && proposalId < proposalList.length, "Invalid ProposalID!");   

        require(voterList[msg.sender].weight > 0, "You don't Registered Yet!");

        require(voterList[msg.sender].voted == false, "Voter Already Voted!");

        voterList[msg.sender].vote = proposalId;
        voterList[msg.sender].voted = true;

        proposalList[proposalId].voteCount += voterList[msg.sender].weight;
    }


    function count() public view returns(uint8 winnerPropId, uint8 winnerPropVoteCount) {

        for(uint8 i=0; i<proposalList.length; i++) {

            if(proposalList[i].voteCount > winnerPropVoteCount) {
                winnerPropVoteCount = proposalList[i].voteCount;    
                winnerPropId = i;                                   
            }
        }

    }
}
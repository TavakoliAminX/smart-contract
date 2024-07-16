// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;



contract vote{

    event Created(uint voter);

    struct voted{
        uint256 id;        
        string question;   
        uint64[] results;  
        string[] options;  
    }
    voted[] private Voted;

    struct Data{
        uint256[] votedId;              
        mapping(uint256 => bool) votedMap;  
    }
    
    mapping(address => Data) private voters;
    
       
    function create(string memory question, string[] memory options) public {
        require(bytes(question).length > 0);
        require(options.length > 1);
        
        uint256 newId = Voted.length;                
        voted memory newPoll = voted({               
            id : newId,
            question: question,
            options: options,
            results: new uint64[](options.length)
        });
        Voted.push(newPoll);                       
        emit Created(newId);                    
    }
    
   
    function getVote(uint voter) external view returns(uint, string memory, uint64[] memory, string[] memory){
        require(voter < Voted.length);
        return (
            Voted[voter].id,
            Voted[voter].question,
            Voted[voter].results,
            Voted[voter].options
        );
    }
    
    function accept(uint voter, uint _vote) external{
        require(voter < Voted.length);
        require(voters[msg.sender].votedMap[voter] == false);
        require(_vote < Voted[voter].options.length);
        
        Voted[voter].results[_vote] += 1;          
        voters[msg.sender].votedId.push(voter);   
        voters[msg.sender].votedMap[voter] == true;  
        
    }

  
    function getVoter(address id) external view returns(uint[] memory){
        return voters[id].votedId;
    }

   
    function getTotal() external view returns(uint){
        return Voted.length;
    }
}
// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract StateTransition {


    uint starttime;
    uint currenttime;


    enum State {
        Reg,    // 0
        Vote,   // 1
        Count   // 2
    }
    State state;

   
    constructor() {

    }
    
    function start() public {
        starttime = block.timestamp;
        currenttime = block.timestamp;
        state = State.Reg;
    }
    
    function updateState() public {
        
        currenttime = block.timestamp;

        if(currentTime <= (starttime + 10 seconds))            
            state = State.Reg;

        else if(currenttime <= (starttime + 20 seconds))   
            state = State.Vote;
        
        else                                                    
            state = State.Count;
    }


    function getState() public view returns (string memory) {

        // return state;   // 0,1,2

        string memory stateStr;

        if(state == State.Reg)
            stateStr = "Reg";
        else if(state == State.Vote)
            stateStr = "Vote";
        else 
            stateStr = "Count";

        return stateStr; // "Reg",  "Vote", "Count"
    }


    function getStartTime() public view returns (uint) {
        return starttime;
    }


    function getCurrentTime() public view returns (uint) {
        return block.timestamp;
    }


    function getLastUpdateTime() public view returns (uint) {
        return currenttime;
    }
}
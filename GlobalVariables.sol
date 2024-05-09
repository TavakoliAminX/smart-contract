// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract GlobalVariables {

    function getBlockInfo() public view returns(uint, uint, uint, address payable, uint, bytes32) {

        return (
            block.number,              
            block.timestamp,            
            block.difficulty,         
            block.coinbase,            
            block.chainid,              
            blockhash(block.number)     
            );
    }

    function getGasInfo() public view returns(uint, uint, uint) {

        uint remainedGas = gasleft();      
        uint gasLimit = block.gaslimit;     
        uint basefee = block.basefee;      
        return ( gasLimit, basefee, remainedGas);
    }


    function getMsgInfo() public payable returns(address, uint, bytes calldata, bytes4) {

        address caller =                msg.sender;        
        uint sentValue =                msg.value;        
        bytes calldata functionData =   msg.data;          
        bytes4 functionID =             msg.sig;           
        return (caller, sentValue, functionData, functionID);
    }



  
    function getContractInfo() public view returns(address, uint) {

        address contractAddress = address(this);           
        uint contractBalance = contractAddress.balance;    
        return (contractAddress, contractBalance);
    }


    function encode(uint8 num) public pure returns (bytes memory) {

        return abi.encodePacked(num);
    }


    function encode(uint8 num1, uint8 num2) public pure returns (bytes memory) {

        return abi.encodePacked(num1, num2);
    }

    function compareStr(string memory s1, string memory s2) public pure returns (bool) {

        return ( keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2)) );  
    }



    function getHash(bytes memory input) public pure returns(bytes32) {

        return keccak256(input);
    }


    function getRandom(uint max) public view returns(uint) {
        uint rand = uint ( keccak256( abi.encodePacked(block.difficulty, block.timestamp) ) );
        return rand % max;
    }


   
    function getBatchRandom() public view returns(uint[10] memory rnds) {

        for(uint i=0; i<10; i++) {
            rnds[i] = getRandom(100);
        }
    }
}
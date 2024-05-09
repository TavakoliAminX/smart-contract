// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract Loop {


    uint8[] ary = [1,2,3,4,5];


    function addAryElements() public view returns(uint) {

        uint sum;

        for(uint i=0; i<ary.length; i++) {         
            sum += ary[i];  
        }

        return sum;
    }


    function addAryElementsV2() public view returns(uint) {

        uint sum;

        uint i=0;
        while(i<ary.length) {
            sum += ary[i];
            i++;
        }

        return sum;
    }


   
    function breakLoop(uint8 num) public view returns(uint) {

        uint index;

        for(uint i=0; i<ary.length; i++) {

            if(ary[i] == num) {
                index = i;
                break; 
            }
        }

        return index;
    }


    function continueLoop() public view returns (uint) {

        uint sum;

        for(uint i=0; i<ary.length; i++) {

            if(i%2 != 0) {     
                
                continue;     
            }

            sum += ary[i]; 
        }

        return sum;
    }

}


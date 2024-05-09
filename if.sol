// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract Address {


    function compare(uint number1, uint number2) public pure returns(string memory) {

        string memory result = "not compared";

        if(number1 > number2)
            result = "number1>number2";

        else 
            result = "number1<=number2"; 

        return result;
    }


    function compareV2(uint number1, uint number2) public pure returns(string memory) {

        string memory result = "not compared";

        if(number1 > number2)
            result = "num1>num2";

        else if(number1 == number2)
            result = "number1==number2";

        else
            result = "number1<=number2";

        return result;
    }

}
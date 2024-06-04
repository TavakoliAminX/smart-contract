// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
contract arry {
    uint[] public firstArray; 
    uint[] public Array2 = [1 , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9 , 10 , 11 , 12 , 13]; 
    uint[] public sizeArray; 

    uint256[] intergerArray;
    bool[] boolArray;
    address[] adrArray;

    function pushIs(uint i) public {
        firstArray.push(i);
    }

    function ItemInArray(uint index) public view returns (uint) {
        return firstArray[index];
    }

    function update(uint locationInArray, uint valueToChange) public {
        firstArray[locationInArray] = valueToChange;
    }

    function remove(uint index) public {
        delete firstArray[index];
    }

    function dCompact(uint index) public {
        firstArray[index] = firstArray[firstArray.length - 1];
        firstArray.pop();
    }

    function getLength() public view returns (uint) {
        return firstArray.length;
    }
}
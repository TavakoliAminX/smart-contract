// SPDX-License-Identifier: MIT

pragma solidity >=0.4.0 <=0.9.0;

contract Hello {

    string public helloStr = "Initial Value";

    constructor() {
        helloStr = "Hello World!";
    }



 

    function setHello(string memory newValue) public {
        helloStr = newValue;
    }

    // getHello()
    function getHello() public view returns(string memory) {
        return helloStr;
    }
    
    function getHelloV2() public view returns(string memory returnValue) {
        returnValue = helloStr;
    }

    // getHello("Hello")
    function getHello(string memory val2) public pure returns(string memory) {
        string memory tempValue = val2;
        return tempValue;
    }

    // گرفتن خروجی فقط در توابع ویو و پیور امکانپذیر است
    function getHelloV4() public returns(string memory) {
        helloStr = "Welcome to Solidity";
        return helloStr;
    }


    // فانشکن میتواند بیش از یک مقدار را برگشت دهد
    function getHelloV5() public pure returns(string memory, string memory) {
        string memory memoryVar1 = "Welcome to";
        string memory memoryVar2 = "Solidity";
        return (memoryVar1, memoryVar2);
    }


    function getHelloV5(
        string memory memoryVar1, 
        string memory memoryVar2
    ) public pure returns(
        string memory, 
        string memory
    ) {
        return (memoryVar1, memoryVar2);
    }

}
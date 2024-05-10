// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;


contract A {

    function add(uint a, uint b) public pure virtual returns(uint) {
        return a+b;
    }

    function add(uint a, uint b, uint c) public pure virtual returns(uint) {
        return a+b+c;
    }
}


contract B is A {
   
    uint public result1 = add(2,3);


    function add(uint a, uint b) public pure virtual override returns(uint) {

        uint c = a+b;

        if(c<a)
            return 0;   
        else
            return c;
    }


    function add(uint a, uint b, uint c) public pure virtual override returns(uint) {
        uint d = a+b+c;
        if(c<a)
            return 0;
        else
            return d;
    }


    uint public result2 = add(1,2,3);

    uint public result3 = super.add(2,3);   

    function addOfA(uint a, uint b) public pure returns(uint) {
        return super.add(a,b);  
    }
}



contract C is B {
    uint public result4 = super.add(2,3);       
    uint public result5 = super.addOfA(2,3);    
}

contract D is B,C {

}
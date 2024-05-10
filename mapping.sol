// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Mapping {

    struct Bid {
        address bider;
        uint bidPrice;
    }

    
    mapping(address => uint) public bidsMap1;

    mapping(address => Bid) public bidsMap2;

    
    function setBidsMap1(address _bider, uint _bidPrice) public {
        bidsMap1[_bider] = _bidPrice;
    }

    function setBidsMap2(address _bider, uint _bidPrice) public {
        bidsMap2[_bider] = Bid(_bider, _bidPrice);
    }


    function getBidsMap1(address _bider) public view returns(uint) {
        return bidsMap1[_bider];
    }


    function getBidsMap2(address _bider) public view returns(Bid memory) {
        return bidsMap2[_bider];
    }


    function getBidsMap2_V2(address _bider) public view returns(address, uint) {
        return (bidsMap2[_bider].bider, bidsMap2[_bider].bidPrice);
    }


    // function deleteMap1(address _bider) public {
    //     delete bidsMap1[_bider];
    // }


    // function deleteMap2(address _bider) public {
    //     delete bidsMap2[_bider];
    // }
    
}
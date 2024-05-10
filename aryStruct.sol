// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract AryStruct {

  
    struct Bid {
        address bider;
        uint bidPrice;
    }


    // array of structs
    Bid[] public bidsAry;


    function setBidsAry(address _bider, uint _bidPrice) public {
        bidsAry.push( Bid(_bider, _bidPrice) );
    }


    function getBidsAry(uint i) public view returns(Bid memory) {
        return bidsAry[i];
    }


    function getBidsAryV2(uint i) public view returns(address, uint) {
        return (bidsAry[i].bider , bidsAry[i].bidPrice);
    }


    function getBidsAry(address _bider) public view returns(Bid memory out) {

        for(uint i=0; i<bidsAry.length; i++) {

            if(bidsAry[i].bider == _bider) {
                out = bidsAry[i];
            }
        }
    }


    function getBid(address _bider) public view returns(uint bid) {

        for(uint i=0; i<bidsAry.length; i++) {

            if(bidsAry[i].bider == _bider) {
                bid = bidsAry[i].bidPrice;
            }
        }
    }

}
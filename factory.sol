// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.22 <0.9.0;


contract SimpleContract {

    address public creator;

    constructor(address _creator) payable {
        creator = _creator;
    }

    receive() external payable {}
}


contract Factory {

    SimpleContract[] public newSCs;

    constructor() payable {}


    function create() public returns (SimpleContract newSC) {
        newSC = new SimpleContract(address(this));
        newSCs.push(newSC);
        
    }

    function charge(address adr, uint amount) public payable {
        (bool status, ) = adr.call{value: amount}("");
        require(status, "Charge Failed");
    }


    function createAndCharge() public payable returns (SimpleContract newSC) {
        newSC = new SimpleContract{value: msg.value}(address(this));
        newSCs.push(newSC);
    }


    function createAndCharge(uint amount) public payable {
        SimpleContract newSC = new SimpleContract{value: amount}(address(this));
        newSCs.push(newSC);
    }

    function getNewSC(uint idx) public view returns (
        address creatorAdr,
        address scAdr,
        uint balance
    ) {
        SimpleContract sc = newSCs[idx];

        creatorAdr = sc.creator();
        scAdr = address(sc);
        balance = scAdr.balance;
    }
}
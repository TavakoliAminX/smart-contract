// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract nestedMapping {

    
    mapping(address => mapping (address => uint) ) public approvals;


    function setApproval(address _owner, address _spender, uint _amount) public {
        approvals[_owner][_spender] = _amount;
    }


    function getApproval(address _owner, address _spender) public view returns(uint) {
        return approvals[_owner][_spender];
    }

}
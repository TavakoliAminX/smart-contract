// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
contract mapp {
    mapping(address => mapping(address => uint)) public allowance;

    function get(address _owner, address _spender) public view returns (uint) {
        return allowance[_owner][_spender];
    }

    function up(
        address _owner,
        address _spender,
        uint256 amount
    ) public {
        allowance[_owner][_spender] = amount;
    }

    function remove(address _owner, address _spender) public {
        delete allowance[_owner][_spender];
    }
}
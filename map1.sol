// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
contract map {
    mapping(address => bool) public Mapps;

    function set(address _address, bool i) public {
        Mapps[_address] = i;
    }

    function get(address _address) public view returns (bool) {
        return Mapps[_address];
    }

    function remove(address _address) public {
        delete Mapps[_address];
    }
}
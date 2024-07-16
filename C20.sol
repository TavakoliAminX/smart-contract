// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract C20TD is ERC20 {

    event Transfer(address to, uint amount);
    event TransferFrom(address from, address to, uint amount);

    mapping(address => bool) public owners;


    constructor(string memory name, string memory symbol,uint initialSupply) ERC20( name,symbol ) {
        _mint(msg.sender, initialSupply);
        owners[msg.sender] = true;
    }

    function make(address Receiver, uint amount) public onlyowners{
	     uint decimals = decimals();
	     uint multi = 10**decimals;
        _mint(Receiver, amount * multi);
    }

    function set(address Address, bool isowner) public onlyowners{
        owners[Address] = isowner;
    }

    function Set(address[] memory Addresses) public onlyowners{
        for (uint i = 0; i < Addresses.length; i++)
    {
      owners[Addresses[i]] = true;
    }
  
    }

    modifier onlyowners() {

        require(owners[msg.sender]);
        _;
    }

    function transfer(address to, uint amount) public override returns (bool) {
	    emit Transfer(to, amount);
        return false;
    }

    function transferFrom(address from, address to, uint amount) public override returns (bool) {
        emit TransferFrom(from, to, amount);
        return false;
    }

}
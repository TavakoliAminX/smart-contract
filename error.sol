// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
contract errorHhandling {
    uint public balance;

    function deposit(uint amount) public {
        uint lastBalance = balance;
        uint upDate = balance + amount;
        require(upDate >= lastBalance);

        balance += amount;
        assert(balance >= amount);

        if (balance < amount) {
            revert();
        }
    }
}
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import "./contract1.sol";


contract ContractB {

    uint public initialBalanceOfA;


    function callBalanceOfA(address addressA) public {            
        ContractA a = ContractA(addressA);
        initialBalanceOfA = a.getBalanceOfA();
        initialBalanceOfA = a.initialBalance();
    }
}

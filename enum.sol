// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
contract Enum {
    enum List {
        Pending,
        Shipp,
        Accept,
        Reject,
        Cansle
    }
    List public list;

    function ship() public {
        require(list == List.Pending);
        list = List.Shipp;
    }
}
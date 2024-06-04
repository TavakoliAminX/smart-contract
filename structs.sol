// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
contract structs {
    struct list {
        string text;
        bool completed;
    }

    list[] public lists;

    function create(string memory text) public {
        lists.push(list(text, false));
    }

    function get(uint256 _index) public view returns (string memory, bool) {
        list storage List = lists[_index];
        return (List.text, List.completed);
    }
}
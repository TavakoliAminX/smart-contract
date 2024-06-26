// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract Token is ERC20 {
    constructor() ERC20("MyToken", "MTK") {
        _mint(msg.sender, 10_000 * 10**decimals());
    }
}
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract IERC20test {

    IERC20 token;
	
	constructor(address tokenAdrress) {
		token = IERC20(tokenAdrress);
	}

    function deposit(uint amount) public {
	
		token.transferFrom(msg.sender, address(this), amount);
	}
}
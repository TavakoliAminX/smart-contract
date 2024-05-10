// SPDX-License-Identifier: MIT
pragma solidity >=0.7.6 <0.9.0;

import "./timeLockWallet.sol.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract WalletFactroy {

    address owner;

    mapping(address => address[]) wallets;

    event Created(address wallet, address from, address to, uint creatAt, uint unlockDuration, uint amount);



    receive() payable external {
        revert();
    }

    constructor() {
        owner = msg.sender;
    }


    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this!");
        _;
    }


    function getWallets(address _user) public view returns (address[] memory) {
        return wallets[_user];
    }


    function newTimeLockedWallet(address owner_, uint unlockDuraion_, address tokenAdr) public payable returns(address wallet) {

        TimeLockedWallet tlw = new TimeLockedWallet(address(this), owner_, unlockDuraion_);
        wallet = address(tlw);


        wallets[owner_].push(wallet);

        payable(wallet).transfer(msg.value);
        IERC20 token = IERC20(tokenAdr);
        token.transfer(wallet, 1000 * 1e18);
        emit Created(wallet, msg.sender, owner_, block.timestamp, unlockDuraion_, msg.value);
    }
}
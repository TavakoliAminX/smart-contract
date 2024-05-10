// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.22 <0.9.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TimeLockedWallet {

    address public architect;
    address public owner;
    uint public createAt;
    uint public unlockDate; 

    event Received(address from, uint amount);
    event Withdraw(address to, uint amount);
    event WithdrawTokens(address tokenAdr, address to, uint amount);

    constructor(address architect_, address owner_, uint unlockDuraion_) {
        architect = architect_;
        owner = owner_;
        createAt = block.timestamp;
        unlockDate = createAt + unlockDuraion_;   
    }


    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this!");
        _;
    }

    receive() payable external {
        emit Received(msg.sender, msg.value);
    }
    function withdrawEthers() public onlyOwner {
        require(block.timestamp >= unlockDate, "Your wallet doesn't unlocked!");

        payable(msg.sender).transfer(address(this).balance);

        emit Withdraw (msg.sender, address(this).balance);
    }

    function withdrawTokens(address _tokenAdr) public onlyOwner {
        require(block.timestamp >= unlockDate, "Your wallet doesn't unlocked!");

        IERC20 token = IERC20(_tokenAdr);

        uint tokenBalance = token.balanceOf(address(this));
        token.transfer(msg.sender, tokenBalance);

        emit WithdrawTokens(_tokenAdr, msg.sender, tokenBalance);
    }


    function info() public view returns (address, address, uint, uint, uint) {
        return (architect, owner, createAt, unlockDate, address(this).balance);
    }
}
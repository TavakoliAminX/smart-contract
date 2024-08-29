// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract ICO{
    address public admin;
    IERC20 public token;
    uint public tokenPrice = 10**15 wei;
    uint public airdropAmount = 100* 1e18;
    uint public maxAirdropAmount = 1_000_000 * 1e18;
    uint public totalReleasedAmount;
    uint public holdersCount;
    uint public icoEndTime;

    mapping (address => uint) public airdrops;
    mapping (address => uint) public holders;
    mapping (address => bool) public IsInLists;

    event Buy(address indexed  buyer_address , uint indexed  amount);
    event Airdrop(address indexed  receiver_address , uint indexed amount);

    constructor(address _admin , address _token){
        admin = _admin;
        token = IERC20(_token);
    }

    modifier onlyAdmin(){
        require(msg.sender == admin);
        _;
    }
    modifier IsActive(){
        require(icoEndTime > 0 && block.timestamp <= icoEndTime );
        _;
    }
    modifier IsInActive(){
        require(icoEndTime == 0);
        _;
    }

    function active(uint duration) external  onlyAdmin IsInActive{
        require(duration > 0 );
        icoEndTime = block.timestamp + duration;
    }

    function inActive() external onlyAdmin IsActive{
        icoEndTime = 0;
    }


    function airdrop(address receiver) external IsActive {
        require(airdrops[receiver] == 0);
        require(totalReleasedAmount + airdropAmount <= maxAirdropAmount);
        require(balanceOfToken(address(this)) >=  airdropAmount);
        token.transfer(receiver, airdropAmount);
        airdrops[receiver] = airdropAmount;
        totalReleasedAmount += airdropAmount;
        if(!IsInLists[receiver]){
            IsInLists[receiver] = true;
            holdersCount++;
        }
        holders[receiver] += airdropAmount;
        emit Airdrop(receiver, airdropAmount);

    }

    function purchase(uint amount) external payable  {
        require(msg.value == (amount/ 1e18 * tokenPrice));
        token.transfer(msg.sender, amount);
        if(!IsInLists[msg.sender]){
            IsInLists[msg.sender] = true;
            holdersCount++;
        }
        holders[msg.sender] += amount;
        emit Buy(msg.sender, amount);
    }

    function depositToken(uint amount) external {
        token.transferFrom(admin, address(this), amount);
    }

    function withdrawToken(uint amount) external {
        require(amount<= balanceOfToken(address(this)));
        token.transfer(admin, amount);
    }

    function withdrawETH(uint amount) external  payable onlyAdmin {
        require(amount <= balanceETH(address(this)));
        payable(admin).transfer(amount);
    }

    function balanceOfToken(address account) public view returns(uint) {
         return token.balanceOf(account);
    }

    function balanceETH(address account) public view  returns(uint) {
        return account.balance;
    }

    function getTokenAdr()public view returns(address) {
        return address(token);
    }

    function getICOAdr() public view returns(address){
        return address(this);
    }

    function updateAdmin(address newAdmin) public onlyAdmin {
        admin = newAdmin;
    }
}
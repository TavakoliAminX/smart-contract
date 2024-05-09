pragma solidity 0.8.19;

contract MyContract {

    event sent(address indexed sender, address indexed receive, uint indexed amount);

    modifier checkBalance() {

        require(this.balance < amount, "Error Message");
        
        _; // plsceholder ~ body of the function (ex. `withdraw`)
    }


    function withdraw() public checkBalance {

        msg.sender.transfer(amount);

        emit sent(this.address, msg.sender, amount);

    }
}


// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;
interface IERC20 {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256 balance);

    function transfer(address to, uint256 amount)
        external
        returns (bool success);


    function transferFrom(address from,address to,uint256 amount) external returns (bool success);


    function allowance(address tokenOwner, address spender)
        external
        view
        returns (uint256 remaining);


    function approve(address spender, uint256 amount)
        external
        returns (bool success);


    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );
}

contract SafeMath {
    function add(uint256 a, uint256 b) public pure returns (uint256 x) {
        x = a + b;
        require(x >= a);
    }

    function sub(uint256 a, uint256 b) public pure returns (uint256 x) {
        require(b <= a);
        x = a - b;
    }

    function mul(uint256 a, uint256 b) public pure returns (uint256 x) {
        x = a * b;
        require(a == 0 || x / a == b);
    }

    function div(uint256 a, uint256 b) public pure returns (uint256 x) {
        require(b >= a);
        x = a / b;
    }
}

contract Token is IERC20, SafeMath {
    address payable Owner;

    string public name;
    string public symbol;
    uint8 public decimals;

    uint public _totalSupply;

    mapping(address => uint) public balances;

    mapping(address => mapping(address => uint)) allowed;

    constructor() {
        name = "Token";
        symbol = "TKN";
        decimals = 18;

        _totalSupply = 100000000000000000000000000;

        Owner = payable(msg.sender);

        balances[Owner] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function totalSupply() external view  returns (uint) {
        return _totalSupply - balances[address(0)];
    }

    function balanceOf(address _account) external view  returns (uint ){
        return balances[_account];
    }

    function allowance(address _tokenOwner, address _spender) external view  returns (uint ){
        return allowed[_tokenOwner][_spender];
    }

    function approve(address _spender, uint _amount) external    returns (bool ){
        allowed[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    function transfer(address _to, uint _amount)public virtual  returns (bool ) {
        balances[msg.sender] = sub(balances[msg.sender], _amount);
        balances[_to] = add(balances[_to], _amount);

        emit Transfer(msg.sender, _to, _amount);
        return true;
    }

    function transferFrom( address _from, address _to, uint256 _amount ) public virtual  returns (bool ) {

        allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _amount);

        balances[_from] = sub(balances[_from], _amount);
        balances[_to] = add(balances[_to], _amount);

        emit Transfer(msg.sender, _to, _amount);
        return true;
    }


}


contract TokenICO is Token {
    address payable public owner;

    uint public tokenPrice = 0.01 ether;
    uint public hardCap = 500 ether;

    uint public Raised;

    uint public start = block.timestamp;
    uint public end = block.timestamp + 900000;

    uint public tradeStart = end + 900000;

    uint public maxInvest = 5 ether;
    uint public minInvest = 0.1 ether;

    enum State {
        beforeStart,
        Ongoing,
        afterEnd,
        Paused
    }
    State public state;

    modifier onlyowner() {
        require(msg.sender == owner);
        _;
    }

    event Invest(address _investor, uint _value, uint256 _amount);

    constructor() {
        owner = payable(msg.sender);
        state = State.beforeStart;
    }

    function pause() public onlyowner {
        state = State.Paused;
    }

    function unpause() public onlyowner {
        state = State.Ongoing;
    }

    function getState() public view returns (State current) {
        if (state == State.Paused) {
            return State.Paused;
        } else if (block.timestamp < start) {
            return State.beforeStart;
        } else if (block.timestamp >= start && block.timestamp <= end) {
            return State.Ongoing;
        } else {
            return State.afterEnd;
        }
    }

    function invest() payable external returns (bool success){
        require(getState() == State.Ongoing);
        require(msg.value >= minInvest && msg.value <= maxInvest);
        uint tokenToTransfer = msg.value/tokenPrice;
        require(Raised + msg.value <= hardCap);
        Raised = Raised + msg.value;

        balances[msg.sender] += tokenToTransfer;
        balances[owner] -= tokenToTransfer;

        owner.transfer(msg.value);
        emit Invest(msg.sender, msg.value, tokenToTransfer);
        
        return true;
    }

    function transfer(address _to, uint _amount) override public returns (bool success){
        require(block.timestamp > tradeStart);
        return super.transfer(_to, _amount);
    }

    function transferFrom(address _from, address _to, uint _amount) override public returns(bool success){
        require(block.timestamp > tradeStart);
        return super.transferFrom(_from, _to, _amount);
    }


    function burnToken() external onlyowner returns (bool success) {
        require(getState() == State.afterEnd);
        balances[owner] = 0;
        return true;
    }
}
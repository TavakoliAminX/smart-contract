// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;



interface IERC20Token {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint256);
    function balanceOf(address owner) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
}



interface IOwned {
    function transferOwnership(address _newOwner) external; 
    function acceptOwnership() external; 
}



interface IConverterAnchor is IOwned {
}



interface IDSToken is IConverterAnchor, IERC20Token {
    function issue(address to, uint256 amount) external;
    function destroy(address from, uint256 amount) external;
}



library SafeMath {
    function add(uint256 _x, uint256 _y) internal pure returns (uint256) {
        uint256 z = _x + _y;
        require(z >= _x, "ERR_OVERFLOW");
        return z;
    }

    function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {
        require(_x >= _y, "ERR_UNDERFLOW");
        return _x - _y;
    }

    function mul(uint256 _x, uint256 _y) internal pure returns (uint256) {
        if (_x == 0) return 0;
        uint256 z = _x * _y;
        require(z / _x == _y, "ERR_OVERFLOW");
        return z;
    }

    function div(uint256 _x, uint256 _y) internal pure returns (uint256) {
        require(_y > 0, "ERR_DIVIDE_BY_ZERO");
        return _x / _y;
    }
}



contract Utils {
    modifier GreaterThanZero(uint amount) {
        _GreaterThanZero(amount);
        _; 
    }

    function _GreaterThanZero(uint amount) internal pure {
        require(amount > 0, "ERR_ZERO_AMOUNT");
    }

    modifier validAddress(address _address) {
        _validAddress(_address);
        _;
    }

    function _validAddress(address _address) internal pure {
        require(_address != address(0), "ERR_INVALID_ADDRESS");
    }

    modifier notThis(address _address) {
        _notThis(_address);
        _;
    }

    function _notThis(address _address) internal view {
        require(_address != address(this), "ERR_ADDRESS_IS_SELF");
    }
}


contract Owned is IOwned {
    address public owner;
    address public newOwner;
    event OwnerUpdate(address indexed previousOwner, address indexed newOwner);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "ERR_NOT_OWNER");
        _;
    }

    function transferOwnership(address _newOwner) external override onlyOwner {
        require(_newOwner != owner, "ERR_SAME_OWNER");
        newOwner = _newOwner;
    }

    function acceptOwnership() public override {
        require(msg.sender == newOwner, "ERR_NOT_NEW_OWNER");
        emit OwnerUpdate(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}


contract ERC20Token is IERC20Token, Utils {
    using SafeMath for uint256;

    string public name;
    string public symbol;
    uint256 public totalSupply;
    uint8 public decimals;

    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalSupply) {
        require(bytes(_name).length > 0, "ERR_INVALID_NAME");
        require(bytes(_symbol).length > 0, "ERR_INVALID_SYMBOL");
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply;
        balances[msg.sender] = totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return balances[account];
    }

    function transfer(address to, uint256 amount) public virtual override validAddress(to) returns (bool) {
        require(balances[msg.sender] >= amount, "ERR_INSUFFICIENT_BALANCE");
        balances[msg.sender] = balances[msg.sender].sub(amount);
        balances[to] = balances[to].add(amount);
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override validAddress(from) validAddress(to) returns (bool) {
        require(balances[from] >= amount, "ERR_INSUFFICIENT_BALANCE");
        require(allowances[from][msg.sender] >= amount, "ERR_INSUFFICIENT_ALLOWANCE");
        balances[from] = balances[from].sub(amount);
        balances[to] = balances[to].add(amount);
        allowances[from][msg.sender] = allowances[from][msg.sender].sub(amount);
        emit Transfer(from, to, amount);
        return true;
    }

    function allowance(address owner, address spender) external view override returns (uint256) {
        return allowances[owner][spender];
    }
}


contract DSToken is ERC20Token, Owned {
    using SafeMath for uint256;

    event TokenLocked(address indexed account, bool isLocked);
    event Issuance(uint256 amount);
    event Destruction(uint256 amount);

    mapping(address => bool) public isLocked;

    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalSupply) 
        ERC20Token(_name, _symbol, _decimals, _totalSupply) 
    {}

    modifier notLocked(address _account) {
        require(!isLocked[_account], "ERR_ACCOUNT_LOCKED");
        _;
    }

    function setLocked(address _account, bool _locked) public onlyOwner {
        isLocked[_account] = _locked;
        emit TokenLocked(_account, _locked);
    }

    function transfer(address to, uint256 amount) public override notLocked(msg.sender) notLocked(to) returns (bool) {
        return super.transfer(to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public override notLocked(from) notLocked(to) returns (bool) {
        return super.transferFrom(from, to, amount);
    }

    function issue(address to, uint256 amount) public onlyOwner {
        totalSupply = totalSupply.add(amount);
        balances[to] = balances[to].add(amount);
        emit Transfer(address(0), to, amount);
        emit Issuance(amount);
    }

    function destroy(address from, uint256 amount) public onlyOwner {
        require(balances[from] >= amount, "ERR_INSUFFICIENT_BALANCE");
        totalSupply = totalSupply.sub(amount);
        balances[from] = balances[from].sub(amount);
        emit Transfer(from, address(0), amount);
        emit Destruction(amount);
    }
}


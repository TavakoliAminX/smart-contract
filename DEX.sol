// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract DEX {
    IERC20 public token1;
    IERC20 public token2;

    uint256 public reserve1;
    uint256 public reserve2;

    constructor(IERC20 _token1, IERC20 _token2) {
        token1 = _token1;
        token2 = _token2;
    }

    function addLiquidity(uint256 _amount1, uint256 _amount2) public {
        require(token1.transferFrom(msg.sender, address(this), _amount1));
        require(token2.transferFrom(msg.sender, address(this), _amount2));
        reserve1 += _amount1;
        reserve2 += _amount2;
    }

    function removeLiquidity(uint256 _amount1, uint256 _amount2) public {
        require(reserve1 >= _amount1 && reserve2 >= _amount2);
        reserve1 -= _amount1;
        reserve2 -= _amount2;
        require(token1.transfer(msg.sender, _amount1));
        require(token2.transfer(msg.sender, _amount2));
    }

    function swap(uint256 _amount1In, uint256 _amount2Out) public {
        require(_amount1In > 0 && _amount2Out > 0);
        require(token1.transferFrom(msg.sender, address(this), _amount1In));
        require(token2.balanceOf(address(this)) >= _amount2Out);
        require(token2.transfer(msg.sender, _amount2Out));
        reserve1 += _amount1In;
        reserve2 -= _amount2Out;
    }
}

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

contract AdvancedDEX {
    IERC20 public token1;
    IERC20 public token2;

    uint256 public reserve1;
    uint256 public reserve2;

    uint256 public totalLiquidity;
    mapping(address => uint256) public liquidity;

    event AddLiquidity(address indexed provider, uint256 amount1, uint256 amount2);
    event RemoveLiquidity(address indexed provider, uint256 amount1, uint256 amount2);
    event Swap(address indexed trader, uint256 amount1In, uint256 amount2Out);

    constructor(IERC20 _token1, IERC20 _token2) {
        token1 = _token1;
        token2 = _token2;
    }

    function addLiquidity(uint256 _amount1, uint256 _amount2) public returns (uint256) {
        require(token1.transferFrom(msg.sender, address(this), _amount1));
        require(token2.transferFrom(msg.sender, address(this), _amount2));
        
        uint256 liquidityMinted = _amount1;
        liquidity[msg.sender] += liquidityMinted;
        totalLiquidity += liquidityMinted;

        reserve1 += _amount1;
        reserve2 += _amount2;

        emit AddLiquidity(msg.sender, _amount1, _amount2);
        return liquidityMinted;
    }

    function removeLiquidity(uint256 _liquidity) public returns (uint256, uint256) {
        require(liquidity[msg.sender] >= _liquidity);

        uint256 amount1 = (_liquidity * reserve1) / totalLiquidity;
        uint256 amount2 = (_liquidity * reserve2) / totalLiquidity;

        liquidity[msg.sender] -= _liquidity;
        totalLiquidity -= _liquidity;

        reserve1 -= amount1;
        reserve2 -= amount2;

        require(token1.transfer(msg.sender, amount1));
        require(token2.transfer(msg.sender, amount2));

        emit RemoveLiquidity(msg.sender, amount1, amount2);
        return (amount1, amount2);
    }

    function getAmountOut(uint256 _amountIn, uint256 _reserveIn, uint256 _reserveOut) public pure returns (uint256) {
        uint256 amountInWithFee = _amountIn * 997;
        uint256 numerator = amountInWithFee * _reserveOut;
        uint256 denominator = (_reserveIn * 1000) + amountInWithFee;
        return numerator / denominator;
    }

    function swapToken1ForToken2(uint256 _amount1In) public {
        uint256 amount2Out = getAmountOut(_amount1In, reserve1, reserve2);
        require(token1.transferFrom(msg.sender, address(this), _amount1In));
        require(token2.transfer(msg.sender, amount2Out));

        reserve1 += _amount1In;
        reserve2 -= amount2Out;

        emit Swap(msg.sender, _amount1In, amount2Out);
    }

    function swapToken2ForToken1(uint256 _amount2In) public {
        uint256 amount1Out = getAmountOut(_amount2In, reserve2, reserve1);
        require(token2.transferFrom(msg.sender, address(this), _amount2In));
        require(token1.transfer(msg.sender, amount1Out));

        reserve2 += _amount2In;
        reserve1 -= amount1Out;

        emit Swap(msg.sender, _amount2In, amount1Out);
    }
}

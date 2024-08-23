// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Token1 is ERC20{
    address public owner;
    uint public INITIALSUPPLY;

    constructor() ERC20("TTOKEN1" , "TTO1"){
        owner = msg.sender;
        INITIALSUPPLY = 600 * (10**uint(decimals()));
        _mint(owner, INITIALSUPPLY);
        emit Transfer(address(0),owner ,  INITIALSUPPLY);
    }

    function transfer(address _to,uint _value)override public returns(bool){
     bool result =  super.transfer(_to, _value  * (10**uint(decimals())));
     return result;
    }
    function transferFrom(address _from , address _to , uint _value) override  public returns(bool){
      bool result  = super.transferFrom(_from, _to, _value * (10**uint(decimals())));
      return result;
    }
}
contract Token2 is ERC20{
    address public owner;
    uint public INITIALSUPPLY;
    constructor() ERC20("TTOKEN2" , "TTO2"){
        owner = msg.sender;
        INITIALSUPPLY = 1400 * (10**uint(decimals()));
        _mint(owner, INITIALSUPPLY);
        emit Transfer(address(0), owner, INITIALSUPPLY);
    }


    function transfer(address _to , uint _value) override  public returns(bool){
     bool result =  super.transfer(_to, _value  * (10**uint(decimals())));
     return result;
    }

    function transferFrom(address _from , address _to , uint _value) override  public returns(bool){
      bool result  =  super.transferFrom(_from, _to, _value * (10**uint(decimals())));
      return result;
    }
}



contract DEx{
    IERC20 public token1;
    IERC20 public token2;
    uint public receive1;
    uint public receive2;
    constructor(IERC20 _token1 , IERC20 _token2){
        token1 = _token1;
        token2 = _token2;
    }

    function addliqidity(uint amount1 , uint amount2) public {
        token1.transferFrom(msg.sender, address(this), amount1);
        token2.transferFrom(msg.sender, address(this), amount2);
        receive1 += amount1;
        receive2 += amount2;

    }

    function getSwapRate(uint amountIn , bool isToken1TOToken2) public view returns(uint){
        if(isToken1TOToken2){
                return(amountIn * receive2) / receive1;
        }else{
            return (amountIn * receive1) / receive2;
        }
    }


    function swap(uint amountIn , bool istoken1TOToken2) public {
        uint amountOut;
        if(istoken1TOToken2){
            amountOut = getSwapRate(amountIn, true);
            require(receive2 >= amountOut);
            token1.transferFrom(msg.sender, address(this), amountIn);
            token2.transfer(msg.sender, amountOut);
            receive1 += amountIn;
            receive2 -= amountOut;
        }else{
            amountOut = getSwapRate(amountIn, false);
            require(receive1 >= amountOut);
            if(istoken1TOToken2){
                token2.transferFrom(msg.sender, address(this), amountIn);
                token1.transfer(msg.sender, amountOut);
                receive2 += amountIn;
                receive1 -= amountOut;
            }
        }
    }

    function removeLiq(uint amount1 , uint amount2) public{
        require(receive1 >= amount1 && receive2 >= amount2);
        token1.transfer(msg.sender, amount1);
        token2.transfer(msg.sender, amount2);
        receive1 -= amount1;
        receive2 -= amount2;
    }
}
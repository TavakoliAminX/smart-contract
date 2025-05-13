// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(
    uint80 _roundId
  ) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

  function latestRoundData()
    external
    view
    returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}



contract Donation {
    AggregatorV3Interface internal priceFeed;

    address payable public owner;
    address[] public payAdr;
    mapping (address => uint) public mapOfDonate;
    
    enum prices {
        basice,
        silver,
        gold
    }
    
    mapping (address => mapping (string => prices)) public mapMake;
    
    event Log(address payAdr , string name , uint value);
    event Log2(address sender, uint value);

    constructor(address payable _owner) {
        owner = _owner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function purchase(string memory _name) public payable {
        require(msg.value >= 0);
        prices price; 
        
        if(msg.value == 1e18) {
            price = prices.basice;
        } else if(msg.value == 2e18) {
            price = prices.silver;
        } else if(msg.value == 3e18) {
            price = prices.gold;
        }

        mapMake[msg.sender][_name] = price;
        emit Log(msg.sender, _name, msg.value);
    }

    function getPurchase(address _adr , string memory _name) public view returns(prices) {
        return mapMake[_adr][_name];
    }

    function withraw() public payable onlyOwner {
        (bool success,) = owner.call{value: address(this).balance}("");
        require(success);
    }

    function getETHPrice() public view returns(int) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (
            ,
            int256 answer,
            ,
            ,
        ) = priceFeed.latestRoundData();
        priceFeed.decimals();
        return answer;
    }

    uint minDollar = 18e9;

    
    function convertionRate(uint _amount) public view returns (uint) {
        // : Converted Value = (ETH_Amount * (ETH_Price * 10)) / 10^18
        require( ((_amount * uint(getETHPrice() * 10 )) / 1e18 ) > minDollar , "Amount too small");
        return ((_amount * uint(getETHPrice() * 10 )) / 1e18);
    }

    receive() external payable { 
        emit Log2(msg.sender, msg.value);
        payAdr.push(msg.sender);
        
        // : Donation = ((ETH_Price / 8) * (ETH_Amount / 8)) / 10^18
        mapOfDonate[msg.sender] = ((uint(getETHPrice() / 8 )) * (msg.value / 8)) / 1e18;
    }
}

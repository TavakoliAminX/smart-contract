// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceFeedConsumer {

    AggregatorV3Interface internal priceFeed;

    constructor() {}


    function getLatestPrice(address aggregatorAddress) public view returns(int) {
        (
             /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
           
        ) = AggregatorV3Interface(aggregatorAddress).latestRoundData();

        return price;
    }

    function getDecimal(address aggregatorAddress) public view returns (uint8 decimals) {
        decimals = AggregatorV3Interface(aggregatorAddress).decimals();
    }

}
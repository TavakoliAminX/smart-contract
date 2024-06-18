// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Market {
    address public owner;
    uint public productCount;

    struct Product {
        uint id;
        string name;
        uint price;
        address payable owner;
        bool purchased;
    }
    Product[] products;

    //mapping(uint => Product) public products;
    
    

    event Created( uint id, string name, uint price, address payable owner, bool purchased);

    event Purchased( uint id, string name, uint price, address payable owner, bool purchased);

    constructor() {
        owner = msg.sender;
    }

    function createProduct(string memory _name, uint _price) public {
        require(bytes(_name).length > 0);
        require(_price > 0);

        productCount++;
        products[productCount] = Product(productCount, _name, _price, payable(msg.sender), false);

        emit Created(productCount, _name, _price, payable(msg.sender), false);
    }

    function purchaseProduct(uint _id) public payable {
        Product memory _product = products[_id];
        address payable _seller = _product.owner;

        require(_product.id > 0 && _product.id <= productCount);
        require(msg.value >= _product.price);
        require(!_product.purchased);
        require(_seller != msg.sender);

        _product.owner = payable(msg.sender);
        _product.purchased = true;
        products[_id] = _product;

        payable(_seller).transfer(msg.value);

        emit Purchased(productCount, _product.name, _product.price, payable(msg.sender), true);
    }
}

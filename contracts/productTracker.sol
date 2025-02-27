// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleProductTracker {
   
    enum ProductStatus { Created, Shipped, Delivered }
    address public owner;

    constructor(){
        owner=msg.sender;
    }
    
    struct Product {
        uint256 id;
        string name;
        address owner;
        ProductStatus status;
    }

    Product[] public products;

    event ownershipTransferred(uint256 id,address previousOwner,address newowner);
    modifier onlyOwner(){
        require(msg.sender==owner,"You are not the owner");
        _;
    }
    function createProduct(uint256 _id,string memory _name) public onlyOwner{
        Product memory newProduct =Product({
            id: _id,
            name: _name,
            owner: msg.sender, // The creator becomes the first owner
            status: ProductStatus.Created // Default status is "Created"
        });
        products.push(newProduct);
    }

    function transferOwnership(uint _id, address _newOwner) public onlyOwner {
    require(_id < products.length, "Product does not exist");
    Product storage product = products[_id];

    // require(product.owner == msg.sender, "You are not the owner");
    require(_newOwner != address(0), "Please enter a valid address");
    
    require(product.status == ProductStatus.Delivered, "Ownership can only be transferred after delivery");

    address previousOwner = product.owner;
    product.owner = _newOwner;

    emit ownershipTransferred(_id, previousOwner, _newOwner);
}


    function updateProductStatus(uint256 _productId, ProductStatus _status) public onlyOwner{
        require(_productId < products.length, "Product does not exist"); 
        Product storage product = products[_productId]; 

        // require(product.owner == msg.sender, "You are not the owner"); 
        product.status = _status; 
    }

     function getProductDetails(uint256 _productId) public view returns (uint256, string memory, address, ProductStatus) {
        require(_productId < products.length, "Product does not exist"); 
        Product memory product = products[_productId]; 
        return (product.id, product.name, product.owner, product.status); 
    }
}

























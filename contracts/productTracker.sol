// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleProductTracker {
   
    enum ProductStatus { Created, Shipped, Delivered }
    address public contractOwner;

    constructor() {
        contractOwner = msg.sender;
    }
    
    struct Product {
        uint256 id;
        string name;
        ProductStatus status;
    }

    Product[] public products;
    mapping(uint256 => address) public productOwners; //  Mapping to track product ownership

    event OwnershipTransferred(uint256 indexed id, address indexed previousOwner, address indexed newOwner);

    modifier onlyContractOwner() {
        require(msg.sender == contractOwner, "You are not the contract owner");
        _;
    }

    modifier onlyProductOwner(uint256 _id) {
        require(productOwners[_id] == msg.sender, "You are not the product owner");
        _;
    }

    function createProduct(uint256 _id, string memory _name) public onlyContractOwner {
        Product memory newProduct = Product({
            id: _id,
            name: _name,
            status: ProductStatus.Created
        });
        products.push(newProduct);
        productOwners[_id] = msg.sender; //  Assign contract owner as initial product owner
    }

    function transferOwnership(uint _id, address _newOwner) public onlyProductOwner(_id) {
        require(_id < products.length, "Product does not exist");
        require(_newOwner != address(0), "Please enter a valid address");
        require(products[_id].status == ProductStatus.Delivered, "Ownership can only be transferred after delivery");

        address previousOwner = productOwners[_id];
        productOwners[_id] = _newOwner; //  Update ownership in mapping

        emit OwnershipTransferred(_id, previousOwner, _newOwner);
    }

    function updateProductStatus(uint256 _productId, ProductStatus _status) public onlyContractOwner {
        require(_productId < products.length, "Product does not exist"); 
        products[_productId].status = _status; 
    }

    function getProductDetails(uint256 _productId) public view returns (uint256, string memory, address, ProductStatus) {
        require(_productId < products.length, "Product does not exist"); 
        Product memory product = products[_productId]; 
        return (product.id, product.name, productOwners[_productId], product.status); //  Get owner from mapping
    }
}

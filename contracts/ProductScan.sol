// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "./Ownership.sol";

contract ProductScan is Ownership {

    //ürünler
    Product[] private products;
    //Satıcılar
    //SellerInfo[] private sellers;

    //Ürün
    struct Product {
        uint256 productId;
        uint256 price;
        string name;
        bool isSold;
        string details;
        //Tarihler 1970'ten bu yana gelen saniyeler ile hesaplanır!!!
        uint productionDate;
    }


    //Satıcı
    // struct SellerInfo {
    //     uint256 reportCount;
    //     string name;
    //     string details;
    // }


    constructor(){
        products.push(Product(0, 0, "Dummy Data", false, "Dummy Data For initialize", 10));
 
        emit constructorSet(msg.sender);
    }


    //Mapping kısmı
    //mapping(address => uint256) sellerAddressToSellerIndex;

    mapping(uint256 => uint256) private productIdToProductIndex;

    mapping(bytes32 => uint256) private secretIdToProductIndex;

    mapping(address => uint256) private ownerProductCount;

    mapping(uint256 => bool) productIdUsedForReport;

    mapping(uint256 => address) private productToOwner;
    


    //Eventler
    event constructorSet(address setter);

    event newProductAdded(uint256 productId, address owner);

    event productPurchased(address buyer);

    event productSoldSuccessfully(
        uint256 productId,
        address seller,
        address buyer
    );
    event productPurchasedByConsumer(uint256 productId, address buyer);

    event newSellerRegistered(string name, address seller);



    modifier sellerCheck(uint256 _productId) {
        // check if the seller owns the product or not...
        address productOwner = productToOwner[_productId];
        require(msg.sender == productOwner, "You do not own this product");
        _;
    }

    modifier soldCheck(uint256 _productId) {
        // finding product index
        uint256 productIndex = productIdToProductIndex[_productId];

        // finding product from index
        bool isSold = products[productIndex].isSold;

        require(isSold == false, "product is already sold");
        _;
    }

    // modifier onlySideContract() {
    //     require(msg.sender == sideContract, "You are not side contract");
    //     require(sideContract != address(0), "side contract is not set yet");
    //     _;
    // }

    // function getAllProducts() public view returns (Product[] memory){
    //     require(products.length > 0, "There are no products");

    //     return products;
    // }


    function getAllOwnedProducts() public view returns (Product[] memory) {
        uint256 productCount = ownerProductCount[msg.sender];
        //Ürün var mı?
        require(productCount > 0, "You have no products");

        // push method not available for memory array...
        Product[] memory ownedProducts = new Product[](productCount);
        uint256 j = 0;

        for (uint256 i = 0; i < products.length; i++) {
            if (productToOwner[products[i].productId] == msg.sender) {
                ownedProducts[j] = products[i];
                j++;
            }
        }
        return ownedProducts;
    }


    function addProduct(
        uint256 _productId,
        bytes32 _secretId,
        uint256 _price,
        string memory _name,
        string memory _details,
        uint _productionDate
    ) external returns (bool) {
        //Product ID daha önce kullanıldı mı?
        require(
            productIdToProductIndex[_productId] == 0,
            "Product id is used before"
        );
        require(
            secretIdToProductIndex[_secretId] == 0,
            "Secret id is used before"
        );
        //Fonksiyonu çağıran kişi sahip olur
        productToOwner[_productId] = msg.sender;
        ownerProductCount[msg.sender]++;

        //Diziye ürün ekleme:
        // uint256 productId;
        // uint256 price;
        // string name;
        // bool isSold;
        // string details;
        // //Tarihler 1970'ten bu yana gelen saniyeler ile hesaplanır!!!
        // uint productionDate;
        products.push(Product(_productId, _price, _name, false, _details, _productionDate));

        //setting index in mappings
        productIdToProductIndex[_productId] = products.length - 1;
        secretIdToProductIndex[_secretId] = products.length - 1;

        emit newProductAdded(_productId, msg.sender);

        return true;
    }


    function buyProduct(bytes32 _secretId)
        external
        returns (bool)
    {
        //onlySideContract
        // finding product index using secret id from the in the common storage...
        uint256 productIndex = secretIdToProductIndex[_secretId];
        // productId from product
        uint256 productId = products[productIndex].productId;
        // product current owner from productId
        address productOwner = productToOwner[productId];


        //Böyle bir ürün var mı yok mu?
        require(
            productOwner != address(0x0),
            "There is no product with the given secretId"
        );

        //Satışta bir ürün var mı yok mu?
        require(
            ownerProductCount[productOwner] > 0,
            "Seller product count is 0"
        );

        //Ürün satın alındı mı?
        require(
            products[productIndex].isSold == false,
            "Product is already sold, Secret id is scanned before"
        );

        // Ürün satın alındı olarak işaretlenir.
        products[productIndex].isSold = true;
        productToOwner[productId] = msg.sender;
        // Ürün satıcısının ürün sayısı azaltılır
        ownerProductCount[productOwner]--;
        ownerProductCount[msg.sender]++;

        emit productPurchasedByConsumer(productId, msg.sender);

        return true;
    }


    // should be called for reselling
    function sellProduct(uint256 _productId, address _buyerAddress)
        external
        sellerCheck(_productId)
        soldCheck(_productId)
        returns (bool)
    {

        address productOwner = productToOwner[_productId];

        //Böyle bir ürün var mı yok mu?
        require(
            productOwner != address(0x0),
            "There is no product with the given secretId"
        );
        //Kullanıcı kendine ürün satamaz
        require(msg.sender != _buyerAddress, "You already own this product");
        require(ownerProductCount[msg.sender] > 0, "You own 0 product");

        uint256 productIndex = productIdToProductIndex[_productId];


        //Ürünün yeni sahibi tanımlanır ve satıldı olarak işaretlenir
        products[productIndex].isSold = true;
        productToOwner[_productId] = _buyerAddress;
        

        // changing limit
        ownerProductCount[msg.sender]--;
        ownerProductCount[_buyerAddress]++;

        emit productSoldSuccessfully(_productId, msg.sender, _buyerAddress);

        return true;
    }
    


    function productDetails(uint256 _productId)
        external
        view
        returns (
            string memory name,
            string memory details,
            uint256 price,
            bool isSold,
            string memory isOriginal
        )
    {
        uint256 index = productIdToProductIndex[_productId];
        Product memory tP = products[index];
        address ownerAddress = productToOwner[_productId];

        if(ownerAddress != address(0x0)){
            return (tP.name, tP.details, tP.price, tP.isSold, "Original");
        }
        else{
            return ("NA", "NA", 0, false, "Fake");
        }
        
    }


    function productLength()
        public
        view
        onlyOwner
        returns (uint256 _productArrayLength)
    {
        return products.length;
    }

}
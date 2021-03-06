
/**
 * This file was generated by TONDev.
 * TONDev is a part of TON OS (see http://ton.dev).
 */
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;


contract Myproduct {
    struct Product{
        string name;
        uint price;
        string description;
    }
    Product[] productsArr;
    mapping(uint=>uint) productToOwner;
    mapping(uint=>uint) productSale;  
    constructor() public {
        
        require(tvm.pubkey() != 0, 101);
      
        require(msg.pubkey() == tvm.pubkey(), 102);
       
        tvm.accept();

    }

    // function memcmp(bytes a, bytes b) internal pure returns(bool){
    //     return (a.length == b.length) && (keccak256(a) == keccak256(b));
    // }
    // function strcmp(string a, string b) internal pure returns(bool){
    //     return memcmp(bytes(a), bytes(b));
    // }strcmp(productsArr[i].name,name)
    modifier checkProductExist(uint productId) {
        require(productToOwner.exists(productId),103,"не существует");
        _;
    }

    function createProduct(string name, uint price, string description) public{
        for(uint i=0;i<productsArr.length;i++){
            require(productsArr[i].name==name,105, "уже существует");
        }
        tvm.accept();
        productsArr.push(Product(name, price, description));
        uint keyLastNum=productsArr.length-1;
        productToOwner[keyLastNum] = msg.pubkey();
    }
    function offerForSale(uint productId, uint sale)public checkProductExist(productId){
        require(msg.pubkey()==productToOwner[productId], 101 );
        tvm.accept();
        productSale[productId]=sale;
    }

    function getProductSale(uint productId) public checkProductExist(productId) returns(uint sale){
        require(productSale.exists(productId),104,"не продается");
        tvm.accept();
        sale=productSale[productId];
    }

    // function changeOwner(uint productId, uint pubKeyOfNewOwner)public{
    //     require(msg.pubkey()==productToOwner[productId], 101 );
    //     tvm.accept();
    //     productToOwner[productId] = pubKeyOfNewOwner;
    //     delete productSale[productId];
    // }
    // function getProductOwner(uint productId) public view returns(uint){
    //     return productToOwner[productId];
    // }
    // function getProductInfo(uint productId) public view returns(string productName, uint productPrise, string productDescription){
    //     //tvm.accept();
    //     productName=productsArr[productId].name;
    //     productPrise=productsArr[productId].price;
    //     productDescription=productsArr[productId].description;
    // }

    // function changePrice(uint productId, uint price)public{
    //     require(msg.pubkey()==productToOwner[productId], 101 );
    //     tvm.accept();
    //     productsArr[productId].price=price;
    // }
    // function changeDesc(uint productId, string description)public{
    //     require(msg.pubkey()==productToOwner[productId], 101 );
    //     tvm.accept();
    //     productsArr[productId].description=description;
    // }


}

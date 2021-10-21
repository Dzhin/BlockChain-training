pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;


contract WalletM {


    constructor() public {
        require(tvm.pubkey() != 0, 101);
              require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }


    modifier checkOwnerAndAccept {
  
        require(msg.pubkey() == tvm.pubkey(), 100);

		tvm.accept();
		_;
	}

    function sendTransactionWithoutCommission(address dest, uint128 value, bool bounce) public pure checkOwnerAndAccept {   
        dest.transfer(value, bounce, 1);
    }
    function sendTransactionWithCommission(address dest, uint128 value, bool bounce) public pure checkOwnerAndAccept {   
        dest.transfer(value, bounce, 0);
    }
    function sendTransactionAndDestroyWallet(address dest, uint128 value, bool bounce) public pure checkOwnerAndAccept {   
        dest.transfer(value, bounce, 160);
    }



    function sendTransaction(address dest, uint128 value, bool bounce) public pure checkOwnerAndAccept {   
        dest.transfer(value, bounce, 0);
    }
}
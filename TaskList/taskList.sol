
/**
 * This file was generated by TONDev.
 * TONDev is a part of TON OS (see http://ton.dev).
 */
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

// This is class that describes you smart contract.
contract listOfTask {
    // Contract can have an instance variables.
    // In this example instance variable `timestamp` is used to store the time of `constructor` or `touch`
    // function call
    uint32 public timestamp;
    struct taskInfo{
        string taskName;
        uint32 timeAdd;
        bool done;
    }
    mapping (uint8=>taskInfo) public taskList;

    // Contract can have a `constructor` – function that will be called when contract will be deployed to the blockchain.
    // In this example constructor adds current time to the instance variable.
    // All contracts need call tvm.accept(); for succeeded deploy
    constructor() public {
        // Check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and
        // message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        // The current smart contract agrees to buy some gas to finish the
        // current transaction. This actions required to process external
        // messages, which bring no value (henceno gas) with themselves.
        tvm.accept();

        timestamp = now;
    }
    	modifier checkOwnerAndAccept {
		// Check that message was signed with contracts key.
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}
    function addTask(string taskName) public checkOwnerAndAccept{
        uint8 i;
        while(taskList.exists(i)){
            if(i==63)break;
            i++;
        }
        require(!(i==63),104,"журнал переполнен");
        taskList[i]=taskInfo(taskName,now,false);
    }
    function getAmountTasks() public returns(int){
        if(taskList.empty())
        return 0;
        uint16 key=0;
        uint8 amount = 0;
        if(taskList.exists(0)){
            amount++;
        }
        
        taskInfo tmp;
        while (key<64){
            optional(uint8,taskInfo) nextTask=taskList.next(key);
            if (nextTask.hasValue()) {
            (key, tmp) = nextTask.get(); 
            amount++;
            }else break;
        }
        return amount;
    }
    
    function getTaskList() public returns (mapping(uint8=>taskInfo))
    {
        return taskList;
    }
    function getTaskInfo(uint8 key) public returns(taskInfo){
        require(taskList.exists(key),105,"задачи не существует");
        return taskList[key];
    }
    function deleteTask(uint8 key) public checkOwnerAndAccept{
        require(taskList.exists(key),105,"задачи не существует");
        delete taskList[key];
    }
    function setTaskDone(uint8 key) public checkOwnerAndAccept{
        require(taskList.exists(key),105,"задачи не существует");
        taskList[key].done=true;
    }
    function getAmountNotDoneTasks() public returns(int){// возвращает несделанные задачи
        if(taskList.empty())
        return 0;
        uint16 key=0;
        uint8 amount = 0;
        if(taskList.exists(0)){
            amount++;
        }
        
        taskInfo tmp;
        while (key<64){
            optional(uint8,taskInfo) nextTask=taskList.next(key);
            if (nextTask.hasValue()) {
            (key, tmp) = nextTask.get(); 
                if (tmp.done==false)
                amount++;
            }else break;
        }
        // for(uint8 i=0;i<64;i++){
        //     if (taskList.fetch(i).done==true){
        //         amount++;
        //     }
        // }
        return amount;
    }
}

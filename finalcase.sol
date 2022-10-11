// SPDX-License-Identifier: MIT


pragma solidity ^0.8.7;


contract finalCase {
    address payable public owner;
    string public name;
    string public greetingPrefix = "Welcome ";
     // array
    address[] public members;

    constructor(string memory initialName) {
        owner = payable(msg.sender);
        name = initialName;
    }

   enum Status {
        Taken,
        Preparing,
        Boxed,
        Shipped
    }

    struct Order {
        address customer;
        string zipCode;
        uint256[] products;
        Status status;  
    }

    Order[] public orders;

  
    // let's we declare some mapping 
    mapping(address => bool) public registered;
    mapping(address => int256) public birthYear;
    mapping(address => uint256) public balance;

  
   

    // event
    event Log(string message);
    event IndexedLog(address indexed sender);

   function register(int256 _birthYear) public  {
       require(!isRegistered(), "it is registered already.");
       registered[msg.sender] = true;
       birthYear[msg.sender] = _birthYear;
       members.push(payable(msg.sender));
       emit Log("Welcome to community");
       emit IndexedLog(msg.sender);
   }

  
    function deleteRegistered() public {
       require(isRegistered(),"it is not registered yet");
        delete(registered[msg.sender]);
        delete(birthYear[msg.sender]);
        members.pop();
    }

    function isRegistered() public view returns(bool) {
        return registered[msg.sender];
    }
    
    modifier authorized {
        require(owner == msg.sender,"you are not authorized;");
        _;
    }

      function createOrder(string memory _zipCode, uint256[] memory _products) public authorized returns(uint256)   {
        
    require(_products.length>0,"No Products");
        
        Order memory order;
        order.customer = msg.sender;
        order.zipCode = _zipCode;
        order.products = _products;
        order.status = Status.Taken;
            
        orders.push(order);

        return orders.length -1;
        
    }



    function changeBalance(uint256 newBalance) public{
        balance[msg.sender] = newBalance;
    }


    function setName(string memory newName) public {
        name = newName;
    }


    function getGreeting() public view returns(string memory) {
        return string(abi.encodePacked(greetingPrefix, name));  
    }
    
    receive() external payable{

    }

    function withdraw(uint _amount) external {
        require(msg.sender == owner, "You can not access if you are not owner.");
        payable(msg.sender).transfer(_amount);
    }
    function getBalance() view external returns(uint) {
        return address(this).balance;
    }

}
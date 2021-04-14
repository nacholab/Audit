pragma solidity 0.8.0;
//fixed the pragma to avoid compatibility errors with future versions of Solidity

contract Crowdsale {
   //SafeMath don't work anymore on 0.8.0 
   
   address public owner; // the owner of the contract
   address public escrow; // wallet to collect raised ETH
   uint256 public savedBalance; // Total amount raised in ETH
   mapping (address => uint256) public balances; // Balances in incoming Ether
   
   //have feedback on the functions through the event 
   event Init(address _address);
   event WithdrawPayments();
   event Distribute(uint256 amount);
   event ReceiveFund();
 
   // Initialization
   function init(address _escrow) public{
       //avoid using tx.origin 
       owner = msg.sender;
       // add address of the specific contract
       escrow = _escrow;
       emit Init(_escrow);
   }
  
   // Function to receive ETH
   function receiveFund(uint256 amount) external payable {
       //use payable function when there are money transfers
       balances[msg.sender] += amount;
       savedBalance += balances[msg.sender];
       
       distribute(amount);
       emit ReceiveFund();
   }

   //use an internal function for payments 
   function distribute(uint256 amount) internal {
       (bool success, ) = escrow.call{value:amount}("distribute");
       if(!success) {
          }
          emit Distribute(amount);
   }
 
   // refund investisor
   function withdrawPayments() external payable{
       //avoid using the transfer and send functions 
       (bool success, ) = msg.sender.call{value:balances[msg.sender]}("payee");
       if(!success) {
          }
          savedBalance -= balances[msg.sender];
          balances[msg.sender] = 0;
       
       emit WithdrawPayments();
   }
}
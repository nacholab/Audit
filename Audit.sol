pragma solidity 0.8.0;


contract Crowdsale {
   //using SafeMath for uint256;
   //SafeMath don't work anymore on 0.8.0 
   
   address public owner; // the owner of the contract
   address public escrow; // wallet to collect raised ETH
   uint256 public savedBalance; // Total amount raised in ETH
   mapping (address => uint256) public balances; // Balances in incoming Ether
   
   event Init(address _address);
   event WithdrawPayments();
   event Distribute(uint256 amount);
   event ReceiveFund();
 
   // Initialization
   function init(address _escrow) public{
       owner = msg.sender;
       // add address of the specific contract
       escrow = _escrow;
       emit Init(_escrow);
   }
  
   // function to receive ETH
   function receiveFund(uint256 amount) external payable {
       balances[msg.sender] += amount;
       savedBalance += balances[msg.sender];
       
       distribute(amount);
       emit ReceiveFund();
   }
   
   function distribute(uint256 amount) internal {
       (bool success, ) = escrow.call{value:amount}("distribute");
       if(!success) {
          // gérer l’erreur
          }
          emit Distribute(amount);
   }
 
   // refund investisor
   function withdrawPayments() external payable{
       (bool success, ) = msg.sender.call{value:balances[msg.sender]}("payee");
       if(!success) {
          // gérer l’erreur
          }
          savedBalance -= balances[msg.sender];
          balances[msg.sender] = 0;
       
       emit WithdrawPayments();
   }
}

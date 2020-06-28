// Withdrawal pattern ensures that direct transfer call is not made which poses a security threat. Following contract is showing the insecure use of transfer call to send ether.

            // pragma solidity ^0.5.0;

            // contract Test {
            // address payable public richest;
            // uint public mostSent;

            // constructor() public payable {
            //     richest = msg.sender;
            //     mostSent = msg.value;
            // }
            // function becomeRichest() public payable returns (bool) {
            //     if (msg.value > mostSent) {
            //         // Insecure practice
            //         richest.transfer(msg.value);
            //         richest = msg.sender;
            //         mostSent = msg.value;
            //         return true;
            //     } else {
            //         return false;
            //     }
            // }
            // }
// Above contract can be rendered in unusable state by causing the richest to be a contract of failing fallback function. When fallback function fails, becomeRichest() function also fails and contract will stuck forever. To mitigate this problem, we can use Withdrawal Pattern.

// In withdrawal pattern, we'll reset the pending amount before each transfer. It will ensure that only caller contract fails.

pragma solidity ^0.5.0;

contract Test {
   address public richest;
   uint public mostSent;

   mapping (address => uint) pendingWithdrawals;

   constructor() public payable {
      richest = msg.sender;
      mostSent = msg.value;
   }
   function becomeRichest() public payable returns (bool) {
      if (msg.value > mostSent) {
         pendingWithdrawals[richest] += msg.value;
         richest = msg.sender;
         mostSent = msg.value;
         return true;
      } else {
         return false;
      }
   }
   function withdraw() public {
      uint amount = pendingWithdrawals[msg.sender];
      pendingWithdrawals[msg.sender] = 0;
      msg.sender.transfer(amount);
   }
}
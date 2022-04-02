// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  ExampleExternalContract public exampleExternalContract;

  constructor(address exampleExternalContractAddress) public {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  event Stake(address _address, uint256 _amount);

  mapping(address=>uint256) public balances;
  uint256 public constant threshold=1 ether;
  uint256 public deadline = block.timestamp + 72 hours;
  bool openForWithdraw;

  modifier notCompleted() {
    require(exampleExternalContract.completed()!=true);
    _;
  }
  
  function stake() public payable {
    balances[msg.sender] += msg.value;

    emit Stake(msg.sender, msg.value);
  }

  function execute() public notCompleted {
    if(block.timestamp>=deadline){
      console.log(address(this).balance, threshold);
      if (address(this).balance >= threshold) {
      console.log("address(this).balance, threshold");
        exampleExternalContract.complete{value: address(this).balance}();
      } else {
        openForWithdraw=true;
        withdraw();
      }
    }
  }
  
  function withdraw() public notCompleted {
    require(openForWithdraw==true,"You can't withdraw now");
    payable(msg.sender).transfer(balances[msg.sender]);
    openForWithdraw=false;
  }

  function timeLeft() view public returns (uint256) {
    if (block.timestamp>=deadline) {
      return 0;
    } else {
      return deadline-block.timestamp;
    }
  }

  receive() external payable{
    stake();
  }
}

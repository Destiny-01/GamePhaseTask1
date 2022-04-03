// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

  uint256 public constant tokensPerEth = 100;
  YourToken public yourToken;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable {
    require(msg.value > 0, "Send ETH to buy some tokens");

    uint256 amountOfTokens = msg.value * tokensPerEth;
    yourToken.transfer(msg.sender, amountOfTokens);

    emit BuyTokens(msg.sender, msg.value, amountOfTokens);
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw(uint256 amount) onlyOwner public {
    payable(msg.sender).transfer(amount);
  }

  // ToDo: create a sellTokens() function:
  function sellTokens(uint256 amount) public {
    require(amount > 0, "Send tokens to buy some ETH");
    uint256 amountOfETH = amount / tokensPerEth;
    yourToken.transferFrom(msg.sender, address(this), amount);
    payable(msg.sender).transfer(amountOfETH);
  }
}
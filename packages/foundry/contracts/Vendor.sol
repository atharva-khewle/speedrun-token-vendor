pragma solidity 0.8.20; //Do not change the solidity version as it negatively impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    /////////////////
    /// Errors //////
    /////////////////

    error InvalidEthAmount();
    error InsufficientVendorTokenBalance(uint256 available, uint256 required);
    error EthTransferFailed(address to, uint256 amount);
    error InvalidTokenAmount();
    error InsufficientVendorEthBalance(uint256 available, uint256 required);

    //////////////////////
    /// State Variables //
    //////////////////////

    YourToken public immutable yourToken;
    uint256 public constant tokensPerEth = 100;

    ////////////////
    /// Events /////
    ////////////////

    event BuyTokens(
        address indexed buyer,
        uint256 amountOfETH,
        uint256 amountOfTokens
    );

    event SellTokens(
        address indexed seller,
        uint256 amountOfTokens,
        uint256 amountOfETH
    );

    ///////////////////
    /// Constructor ///
    ///////////////////

    constructor(address tokenAddress) Ownable(msg.sender) {
        yourToken = YourToken(tokenAddress);
    }

    ///////////////////
    /// Functions /////
    ///////////////////

    function buyTokens() external payable {
        if (msg.value == 0 ether) revert InvalidEthAmount();
        uint256 tokensToSend = msg.value * tokensPerEth;
        uint256 vendorbalance = yourToken.balanceOf(address(this));
        if (vendorbalance < tokensToSend)
            revert InsufficientVendorTokenBalance(vendorbalance, tokensToSend);
        yourToken.transfer(msg.sender, tokensToSend);
        emit BuyTokens(msg.sender, msg.value, tokensToSend);
    }

    function withdraw() public onlyOwner {
        uint256 allEth = address(this).balance;
        (bool success, ) = owner().call{value: allEth}("");
        if (!success) revert EthTransferFailed(owner(), allEth);
    }

    function sellTokens(uint256 amount) public {
        if (amount == 0) revert InvalidTokenAmount();
        yourToken.transferFrom(msg.sender, address(this), amount);
        uint256 sendEth = amount / tokensPerEth;
        uint256 contractEth = address(this).balance;
        if (contractEth < sendEth)
            revert InsufficientVendorEthBalance(
                contractEth,
                sendEth - contractEth
            );

        (bool success, ) = msg.sender.call{value: sendEth}("");
        if (!success) revert EthTransferFailed(msg.sender, sendEth);
        emit SellTokens(msg.sender, amount, sendEth);
    }
}

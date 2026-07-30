// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface ICashback {
    function superCashbackNFT() external view returns (address);
    function accrueCashback(address currency, uint256 amount) external;
    function payWithCashback(address currency, address receiver, uint256 amount) external;
}
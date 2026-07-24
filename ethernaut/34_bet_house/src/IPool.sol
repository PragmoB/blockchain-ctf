// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IPool {
    function deposit(uint256 value_) external payable;
    function withdrawAll() external;
    function depositToken() external view returns (address);
    function lockDeposits() external;
}
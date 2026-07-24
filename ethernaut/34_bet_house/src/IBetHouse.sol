// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IBetHouse {
    function makeBet(address bettor_) external;
    function pool() external view returns (address);
    function isBettor(address bettor_) external view returns (bool);
}
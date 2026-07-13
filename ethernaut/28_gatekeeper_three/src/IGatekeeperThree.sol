// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IGatekeeperThree {
    function construct0r() external;
    function getAllowance(uint256 _password) external;
    function createTrick() external;
    function enter() external;
}
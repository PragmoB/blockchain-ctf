// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IStake {

    function totalStaked() external view returns (uint256);
    function UserStake(address) external view returns (uint256);
    function Stakers(address) external view returns (bool);

    function StakeETH() external payable;
    function StakeWETH(uint256 amount) external;
    function Unstake(uint256 amount) external;
}
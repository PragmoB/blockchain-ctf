pragma solidity ^0.8.13;

interface IEngine {
    function initialize() external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external;
    function attack() external;

    function horsePower() external returns (uint256);
}
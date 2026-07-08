pragma solidity ^0.8.13;

interface IPuzzle {
    function proposeNewAdmin(address _newAdmin) external;
    function approveNewAdmin(address _expectedAdmin) external;
    function upgradeTo(address _newImplementation) external;
    function init(uint256 _maxBalance) external;
    function setMaxBalance(uint256 _maxBalance) external;
    function addToWhitelist(address addr) external;
    function deposit() external;
    function execute(address to, uint256 value, bytes calldata data) external;
    function multicall(bytes[] calldata data) external payable;

    function balances(address) external view returns (uint256);
    function admin() external view returns (address);
}

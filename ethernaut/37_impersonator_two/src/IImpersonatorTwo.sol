// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IImpersonatorTwo {
    function nonce() external view returns (uint256);
    function admin() external view returns (address);

    function setAdmin(bytes memory signature, address newAdmin) external;
    function switchLock(bytes memory signature) external;
    function withdraw() external;
    function hash_message(string memory message) external pure returns (bytes32);
}
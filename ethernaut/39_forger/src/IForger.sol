// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IForger {
    function createNewTokensFromOwnerSignature(
        bytes calldata signature,
        address receiver,
        uint256 amount,
        bytes32 salt,           
        uint256 deadline      
    ) external;

    function totalSupply() external view returns (uint256);
}
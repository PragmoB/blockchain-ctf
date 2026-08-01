// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IUniqueNFT {
    function mintNFTSmartContract() external payable returns(uint256 mintedNFT);
    function mintNFTEOA() external returns(uint256 mintedNFT);
    function balanceOf(address) external view returns (uint256);
}
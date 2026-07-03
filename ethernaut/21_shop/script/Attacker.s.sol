// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Attacker} from "src/Attacker.sol";

contract CounterScript is Script {

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        Attacker attacker = new Attacker(0x960C98Ec9e13eD6E08450DBa4c62Ace374389fd7);
        attacker.attack();

        vm.stopBroadcast();
    }
}

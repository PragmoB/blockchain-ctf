// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Attacker} from "src/Attacker.sol";

contract AttackerScript is Script {

    address constant targetAddr = 0xad35FC51916f378710A6F00a791977653402f65f;
    Attacker attacker;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        attacker = new Attacker(targetAddr);
        attacker.attack();

        vm.stopBroadcast();
    }
}

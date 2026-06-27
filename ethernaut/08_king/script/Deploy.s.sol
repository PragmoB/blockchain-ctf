// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Attacker} from "../src/Attacker.sol";

contract DeployScript is Script {

    function run() public {
        vm.startBroadcast();
        Attacker attacker = new Attacker();
        attacker.attack{ value: 0.0001 ether }();
        vm.stopBroadcast();
    }
}

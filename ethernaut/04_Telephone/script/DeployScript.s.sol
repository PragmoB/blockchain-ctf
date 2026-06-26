// script/Deploy.s.sol
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/Attacker.sol";

contract DeployScript is Script {
    function run() external {
        vm.startBroadcast();
        new Attacker();
        vm.stopBroadcast();
    }
}
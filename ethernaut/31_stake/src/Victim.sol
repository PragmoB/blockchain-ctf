// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IStake} from "src/IStake.sol";

contract Victim {
    
    IStake public target;

    constructor(IStake ttarget) {
        target = ttarget;
    }
    
    function stake() public payable {
        target.StakeETH{ value: msg.value }();
    }
}
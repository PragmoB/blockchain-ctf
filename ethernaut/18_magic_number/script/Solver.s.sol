// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";

interface IMagicNum {
    function setSolver(address _solver) external;
}
contract SolverScript is Script {

    IMagicNum target;
    function setUp() public {
        target = IMagicNum(0xE544B2F1960863D6D024629F519Cc09Ca69863Be);
    }

    function run() public {
        bytes memory bytecode = hex"600a600c600039600a6000F3602A60005260206000F3";
        
        vm.startBroadcast();
        address mycontract;
        assembly {
            mycontract := create(0, add(bytecode, 0x20), mload(bytecode))
        }
        target.setSolver(mycontract);

        vm.stopBroadcast();
    }
}

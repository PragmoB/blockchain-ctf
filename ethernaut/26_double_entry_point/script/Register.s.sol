// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {DetectionBot} from "src/DetectionBot.sol";
import {IForta} from "src/IForta.sol";


contract CounterScript is Script {

    IForta forta;
    address cryptoVault;
    address owner;

    DetectionBot public detectionBot;

    function setUp() public {
        forta = IForta(0x63e8e5701c38160495061a954A5C76485a639a3F);
        cryptoVault = 0x5a1612ee4762B63691508ebeC68F02Cd09e7F617;
        owner = 0x6fEf5e47148E965C52dAbf9086dFA41e886DD541;
    }

    function run() public {
        vm.startBroadcast();

        detectionBot = new DetectionBot(address(forta), cryptoVault, owner);
        forta.setDetectionBot(address(detectionBot));

        vm.stopBroadcast();
    }
}

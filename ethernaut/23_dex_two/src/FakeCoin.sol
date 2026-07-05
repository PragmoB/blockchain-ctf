// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FakeCoin is ERC20 {
    
    constructor() ERC20("fakecoin", "FAKE") {
        _mint(msg.sender, 999999);
    }

    function balanceOf(address owner) public override pure returns (uint256) {
        owner;
        return 1;
    }
}

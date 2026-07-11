// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IForta} from "src/IForta.sol";

contract DetectionBot {
    IForta forta;
    address cryptoVault;
    address owner;

    constructor(address fortaAddr, address cryptoVaultAddr, address ownerAddr) {
        forta = IForta(fortaAddr);
        cryptoVault = cryptoVaultAddr;
        owner = ownerAddr;
    }
    function handleTransaction(address user, bytes calldata msgData) public {
        (address to, uint256 value, address origSender) = abi.decode(msgData[4:], (address, uint256, address));
        if (origSender == cryptoVault)
            forta.raiseAlert(owner);
        user; to; value;
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IEllipticToken {

    function redeemVoucher(
        uint256 amount,
        address receiver,
        bytes32 salt,
        bytes memory ownerSignature,
        bytes memory receiverSignature
    ) external;

    function permit(
        uint256 amount,
        address spender,
        bytes memory tokenOwnerSignature,
        bytes memory spenderSignature
    ) external;
    
}
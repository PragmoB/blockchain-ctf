// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/// @notice 이번 챌린지에서 가짜 MPT(Merkle-Patricia-Trie) 증명을 조립하기 위한
///         최소 기능만 담은 RLP 인코더. 범용 라이브러리가 아니라 여기서 필요한
///         케이스(정수, 바이트열, 이미 인코딩된 아이템들의 리스트)만 처리한다.
library RLP {
    /// @dev 정수를 "선행 0바이트를 제거한 최소 big-endian 바이트열"로 만든 뒤 문자열로 인코딩.
    ///      0은 빈 바이트열(0x80)로 인코딩되는 것이 RLP 규약.
    function encodeUint(uint256 x) internal pure returns (bytes memory) {
        return encodeBytes(_minimalBigEndian(x));
    }

    /// @dev RLP 문자열(바이트열) 인코딩 규칙:
    ///      - 길이 1이고 값이 0x80 미만이면 그대로 반환
    ///      - 길이 <= 55면 0x80+len 프리픽스
    ///      - 그 이상이면 0xb7+lenOfLen, 길이바이트들, 데이터 순
    function encodeBytes(bytes memory data) internal pure returns (bytes memory) {
        if (data.length == 1 && uint8(data[0]) < 0x80) {
            return data;
        }
        if (data.length <= 55) {
            return abi.encodePacked(bytes1(uint8(0x80 + data.length)), data);
        }
        bytes memory lenBytes = _minimalBigEndian(data.length);
        return abi.encodePacked(bytes1(uint8(0xb7 + lenBytes.length)), lenBytes, data);
    }

    /// @dev 이미 각각 RLP 인코딩된 아이템들을 이어붙인 뒤 리스트 프리픽스를 씌운다.
    function encodeList(bytes[] memory items) internal pure returns (bytes memory) {
        bytes memory payload;
        for (uint256 i = 0; i < items.length; i++) {
            payload = abi.encodePacked(payload, items[i]);
        }
        if (payload.length <= 55) {
            return abi.encodePacked(bytes1(uint8(0xc0 + payload.length)), payload);
        }
        bytes memory lenBytes = _minimalBigEndian(payload.length);
        return abi.encodePacked(bytes1(uint8(0xf7 + lenBytes.length)), lenBytes, payload);
    }

    function _minimalBigEndian(uint256 x) private pure returns (bytes memory) {
        bytes memory tmp = new bytes(32);
        assembly {
            mstore(add(tmp, 32), x)
        }
        uint256 start = 0;
        while (start < 32 && tmp[start] == 0) {
            start++;
        }
        bytes memory trimmed = new bytes(32 - start);
        for (uint256 i = 0; i < trimmed.length; i++) {
            trimmed[i] = tmp[start + i];
        }
        return trimmed;
    }
}

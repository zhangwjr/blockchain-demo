// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ABIEncoder {
    function encodeUint(uint256 value) public pure returns (bytes memory) {
        return abi.encode(value);
    }

    function encodeMultiple(
        uint256 num,
        string memory text
    ) public pure returns (bytes memory) {
        return abi.encode(num, text);
    }
}

contract ABIDecoder {
    function decodeUint(bytes memory data) public pure returns (uint256) {
        return abi.decode(data, (uint256));
    }

    function decodeMultiple(
        bytes memory data
    ) public pure returns (uint256, string memory) {
        return abi.decode(data, (uint256, string));
    }
}

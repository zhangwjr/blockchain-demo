// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title MyToken
 * @dev 使用 OpenZeppelin ERC20 实现，与 BaseERC20 相同配置：
 *      name: MyToken, symbol: PCC, decimals: 18, totalSupply: 1 亿
 */
contract MyToken is ERC20 {
    uint256 private constant INITIAL_SUPPLY = 100_000_000 * 10 ** 18;

    constructor() ERC20("MyToken", "PCC") {
        _mint(msg.sender, INITIAL_SUPPLY);
    }
}

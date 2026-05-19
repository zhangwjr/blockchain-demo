// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @dev 由支持回调转账的代币（如 MyToken.transferWithCallback）在收款方为合约时调用。
 */
interface ITokenReceiver {
    function tokensReceived(address from, uint256 amount) external;
}

/**
 * @title MyToken
 * @dev 使用 OpenZeppelin ERC20 实现，与 BaseERC20 相同配置：
 *      name: MyToken, symbol: PCC, decimals: 18, totalSupply: 1 亿
 * @dev transferWithCallback：若接收方为合约，在转账成功后调用其 tokensReceived(from, amount)
 */
contract MyToken is ERC20, ReentrancyGuard {
    uint256 private constant INITIAL_SUPPLY = 100_000_000 * 10 ** 18;

    constructor() ERC20("MyToken", "PCC") {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    /**
     * @dev 将调用者的代币转给 `to`，并在 `to` 为合约时调用 `tokensReceived(from, amount)`。
     *      使用 nonReentrant 降低在回调中重入本函数的风险。
     */
    function transferWithCallback(address to, uint256 amount) external nonReentrant returns (bool) {
        _transfer(_msgSender(), to, amount);

        if (to.code.length > 0) {
            ITokenReceiver(to).tokensReceived(_msgSender(), amount);
        }

        return true;
    }
}

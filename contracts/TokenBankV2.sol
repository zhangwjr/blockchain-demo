// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./TokenBank.sol";
import {ITokenReceiver} from "./MyToken.sol";

/**
 * @title TokenBankV2
 * @dev 继承 TokenBank，保留原有 approve + deposit() / withdraw() 流程。
 *      额外支持扩展 ERC20（MyToken）的 transferWithCallback 直接存款：
 *      用户调用 myToken.transferWithCallback(address(this), amount) 即可入账，
 *      无需事先 approve。
 */
contract TokenBankV2 is TokenBank, ITokenReceiver {
    constructor(address tokenAddress) TokenBank(tokenAddress) {}

    /**
     * @inheritdoc ITokenReceiver
     * @dev 由 MyToken.transferWithCallback 在转账成功后回调，记录存款。
     */
    function tokensReceived(address from, uint256 amount) external override {
        require(msg.sender == address(token), "TokenBankV2: not token");
        _creditDeposit(from, amount);
    }

    /// @dev 更新 deposits 映射并触发 Deposited 事件
    function _creditDeposit(address user, uint256 amount) private {
        require(user != address(0), "TokenBankV2: zero from");
        require(amount > 0, "TokenBankV2: zero amount");

        deposits[user] += amount;
        emit Deposited(user, amount);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Bank.sol";

/// @notice 银行对外能力抽象，供 Admin 等对任意银行合约地址做类型化调用（不要求 Bank 显式 implements）
interface IBank {
    function deposit() external payable;

    function withdraw(uint256 amount, address payable to) external;
}

/// @notice 在 Bank 基础上：单笔存款须 > 0.001 ether，且支持转移管理员
contract BigBank is Bank {
    uint256 private constant MIN_DEPOSIT = 0.001 ether;

    modifier minDeposit(uint256 amount) {
        require(amount > MIN_DEPOSIT, "Deposit must exceed 0.001 ether");
        _;
    }

    function _deposit(address user, uint256 amount) internal override minDeposit(amount) {
        super._deposit(user, amount);
    }

    function transferAdmin(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "Invalid admin");
        admin = newAdmin;
    }
}

/// @notice 独立 Owner；通过 IBank.withdraw 将银行合约余额提到本合约
contract Admin {
    address public owner;

    event AdminWithdraw(address indexed bank, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    /// @param bank 已部署的 Bank / BigBank 等合约地址（需实现与 IBank 一致的 withdraw）
    function adminWithdraw(address bank) external onlyOwner {
        uint256 bal = address(bank).balance;
        require(bal > 0, "No bank balance");
        IBank(bank).withdraw(bal, payable(address(this)));
        emit AdminWithdraw(bank, bal);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BaseERC20.sol";

contract TokenBank {
    BaseERC20 public token;

    mapping(address => uint256) public deposits;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    constructor(address tokenAddress) {
        require(tokenAddress != address(0), "Invalid token address");
        token = BaseERC20(tokenAddress);
    }

    function deposit() external {
        uint256 amount = token.allowance(msg.sender, address(this));
        require(amount > 0, "Approve tokens first");

        require(
            token.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );

        deposits[msg.sender] += amount;
        emit Deposited(msg.sender, amount);
    }

    function withdraw() external {
        uint256 amount = deposits[msg.sender];
        require(amount > 0, "No deposit");

        deposits[msg.sender] = 0;
        require(token.transfer(msg.sender, amount), "Transfer failed");

        emit Withdrawn(msg.sender, amount);
    }
}

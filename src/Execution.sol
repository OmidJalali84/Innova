// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {AccessManagers} from "./utils/AccessManagers.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract Execution is AccessManagers, ReentrancyGuard {
    using SafeERC20 for IERC20;
    IERC20 immutable fds;

    mapping(address => uint256) private balance;

    error Execution__ZeroAddress();
    error Execution__ZeroAmount();
    error Execution__InsufficientBalance(
        address account,
        uint256 balance,
        uint256 needed
    );

    constructor(
        address initialOwner,
        address _fdsToken
    ) AccessManagers(initialOwner) {
        fds = IERC20(_fdsToken);
    }

    function deposit(address account, uint256 amount) public onlyManager {
        _deposit(account, amount);
    }

    function deposit(uint256 amount) public {
        _deposit(msg.sender, amount);
    }

    function _deposit(address account, uint256 amount) internal nonReentrant {
        if (account == address(0)) {
            revert Execution__ZeroAddress();
        }
        if (amount == 0) {
            revert Execution__ZeroAmount();
        }

        balance[account] += amount;

        fds.safeTransferFrom(account, address(this), amount);
    }

    function refund(address account, uint256 amount) public onlyManager {
        _refund(account, amount);
    }

    function refund(uint256 amount) public {
        _refund(msg.sender, amount);
    }

    function refund() public {
        _refund(msg.sender, balance[msg.sender]);
    }

    function _refund(address account, uint256 amount) internal {
        if (balance[account] < amount) {
            revert Execution__InsufficientBalance(
                account,
                balance[account],
                amount
            );
        }
        if (account == address(0)) {
            revert Execution__ZeroAddress();
        }
        if (amount == 0) {
            revert Execution__ZeroAmount();
        }

        balance[account] -= amount;

        fds.safeTransfer(account, amount);
    }

    function transferTo(
        address sender,
        address receiver,
        uint256 amount
    ) public onlyManager nonReentrant {
        if (balance[sender] < amount) {
            revert Execution__InsufficientBalance(
                sender,
                balance[sender],
                amount
            );
        }
        if (sender == address(0)) {
            revert Execution__ZeroAddress();
        }
        if (receiver == address(0)) {
            revert Execution__ZeroAddress();
        }
        if (amount == 0) {
            revert Execution__ZeroAmount();
        }

        balance[sender] -= amount;
        fds.safeTransfer(receiver, amount);
    }
}

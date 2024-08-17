// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract AccessManagers is Ownable {
    /**
     * @dev The list of managers
     */
    mapping(address account => bool isManager) managers;

    error AccessManagers__IsNotManager(address account);
    error AccessManagers__IsNotAlreadyManager(address account);
    error AccessManagers__IsAlreadyManager(address account);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) Ownable(initialOwner) {}

    modifier onlyManager() {
        _checkManager(msg.sender);
        _;
    }

    /**
     * @dev Throws if the sender is not the manager.
     */
    function _checkManager(address account) internal view {
        if (!managers[account]) {
            revert AccessManagers__IsNotManager(account);
        }
    }

    function addManager(address account) external onlyOwner {
        if (managers[account]) {
            revert AccessManagers__IsAlreadyManager(account);
        }
        managers[account] = true;
    }

    function delManager(address account) external onlyOwner {
        if (managers[account]) {
            revert AccessManagers__IsNotAlreadyManager(account);
        }
        managers[account] = false;
    }
}

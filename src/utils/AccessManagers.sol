// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract AccessManagers is Ownable {
    /**
     * @dev The list of managers
     */
    mapping(address => bool) private isManager;

    error AccessManagers__IsNotManager(address account);
    error AccessManagers__IsAlreadyManager(address account);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) Ownable(initialOwner) {}

    /**
     * @dev Modifier to restrict access to only managers
     */
    modifier onlyManager() {
        _checkManager(msg.sender);
        _;
    }

    /**
     * @dev Throws if the sender is not a manager.
     */
    function _checkManager(address account) internal view {
        if (!isManager[account]) {
            revert AccessManagers__IsNotManager(account);
        }
    }

    /**
     * @dev Adds a new manager. Only callable by the owner.
     */
    function addManager(address account) external onlyOwner {
        if (isManager[account]) {
            revert AccessManagers__IsAlreadyManager(account);
        }
        isManager[account] = true;
    }

    /**
     * @dev Removes a manager. Only callable by the owner.
     */
    function removeManager(address account) external onlyOwner {
        if (!isManager[account]) {
            revert AccessManagers__IsNotManager(account); // Corrected error name here
        }
        isManager[account] = false;
    }
}

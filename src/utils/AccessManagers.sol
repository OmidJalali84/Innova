// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract AccessManagers {
    address superOwner;

    /**
     * @dev The list of managers
     */
    mapping(address account => bool isManager) managers;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error AccessManagers__OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error AccessManagers__OwnableInvalidOwner(address owner);

    /**
     * @dev If the address is already manager
     */
    error AccessManagers__IsAlreadyManager(address account);

    /**
     * @dev If the address is not manager
     */
    error AccessManagers__IsNotAlreadyManager(address account);

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert AccessManagers__OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    modifier ownlyManager(address acount) {
        _checkManager(acount);
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return superOwner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view {
        if (owner() != msg.sender) {
            revert AccessManagers__OwnableUnauthorizedAccount(msg.sender);
        }
    }

    /**
     * @dev Throws if the sender is not the manager.
     */
    function _checkManager(address account) internal view {
        if (!managers[account]) {
            revert AccessManagers__IsNotAlreadyManager(account);
        }
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        if (newOwner == address(0)) {
            revert AccessManagers__OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal {
        address oldOwner = superOwner;
        superOwner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    function addManager(address account) external onlyOwner {
        if (managers[account]) {
            revert AccessManagers__IsAlreadyManager(account);
        }
        managers[account] = true;
    }

    function delManager(address account) external onlyOwner {
        _checkManager(account);
        managers[account] = true;
    }
}

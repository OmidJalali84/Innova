// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FDS is ERC20, ERC20Permit {
    constructor(
        uint256 initialSupply
    ) ERC20("Fides Innova", "FDS") ERC20Permit("Fides Innova") {
        _mint(msg.sender, initialSupply);
    }
}

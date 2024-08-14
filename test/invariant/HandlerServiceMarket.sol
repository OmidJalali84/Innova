// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {ServiceMarket} from "../../src/ServiceMarket.sol";
import {Test} from "forge-std/Test.sol";

contract HandlerServiceMarket is Test {
    ServiceMarket serviceMarket;
    address constant OWNER = address(1);
    address constant MANAGER = address(2);
    address constant USER = address(3);

    constructor() {
        serviceMarket = new ServiceMarket(OWNER);
        vm.prank(OWNER);
        serviceMarket.addManager(MANAGER);
    }

    function handlerCreateService(
        uint256 id,
        string memory name,
        string memory description,
        string memory code,
        string memory serviceType,
        string memory imageAddress
    ) public {
        uint256[] memory ids = serviceMarket.getIDs();
        for (uint256 i; i < ids.length; i++) {
            if (ids[i] == id) {
                return;
            }
        }
        vm.prank(MANAGER);
        serviceMarket.createService(
            id,
            name,
            description,
            code,
            serviceType,
            imageAddress
        );
    }

    function handlerRemoveService(uint256 id) public {
        uint256[] memory ids = serviceMarket.getIDs();
        for (uint256 i; i < ids.length; i++) {
            if (ids[i] == id) {
                vm.prank(MANAGER);
                serviceMarket.removeService(id);
            } else if (i == ids.length - 1) {
                return;
            }
        }
        return;
    }

    function getContract() public view returns (ServiceMarket) {
        return serviceMarket;
    }
}

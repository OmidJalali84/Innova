// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {ServiceMarket} from "../../src/ServiceMarket.sol";
import {Test} from "forge-std/Test.sol";

contract HandlerServiceMarket is Test {
    ServiceMarket serviceMarket = new ServiceMarket();
    address constant USER = address(1);

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
        vm.prank(USER);
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
                vm.prank(USER);
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

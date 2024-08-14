// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {ServiceMarket, Service} from "../../../src/ServiceMarket.sol";

contract fuzzTestserviceMarket is Test {
    ServiceMarket serviceMarket;
    address constant USER = address(1);

    function setUp() external {
        serviceMarket = new ServiceMarket();
    }

    function testFuzzCreatesTheServiceAndFetchesAllServices(
        uint256 id,
        string memory name,
        string memory description,
        string memory code,
        string memory serviceType,
        string memory imageAddress,
        uint256 id2,
        string memory name2,
        string memory description2,
        string memory code2,
        string memory serviceType2,
        string memory imageAddress2
    ) external {
        if (id == id2) {
            if (id2 != type(uint256).max) {
                id2 += 1; // Modify id2 to be different if they are the same
            } else {
                return;
            }
        }
        serviceMarket.createService(
            id,
            name,
            description,
            code,
            serviceType,
            imageAddress
        );
        serviceMarket.createService(
            id2,
            name2,
            description2,
            code2,
            serviceType2,
            imageAddress2
        );

        Service[] memory dataArray = serviceMarket.fetchAllServices();
        vm.assertEq(dataArray[0].id, id);
        vm.assertEq(dataArray[0].name, name);
        vm.assertEq(dataArray[0].description, description);
        vm.assertEq(dataArray[0].code, code);
        vm.assertEq(dataArray[0].serviceType, serviceType);
        vm.assertEq(dataArray[0].imageAddress, imageAddress);
        vm.assertEq(dataArray[1].id, id2);
        vm.assertEq(dataArray[1].name, name2);
        vm.assertEq(dataArray[1].description, description2);
        vm.assertEq(dataArray[1].code, code2);
        vm.assertEq(dataArray[1].serviceType, serviceType2);
        vm.assertEq(dataArray[1].imageAddress, imageAddress2);
    }

    function testFuzzRemovesAndFetchesAllServices(
        uint256 id,
        string memory name,
        string memory description,
        string memory code,
        string memory serviceType,
        string memory imageAddress,
        uint id2,
        string memory name2,
        string memory description2,
        string memory code2,
        string memory serviceType2,
        string memory imageAddress2
    ) external {
        if (id == id2) {
            if (id2 != type(uint256).max) {
                id2 += 1; // Modify id2 to be different if they are the same
            } else {
                return;
            }
        }

        serviceMarket.createService(
            id,
            name,
            description,
            code,
            serviceType,
            imageAddress
        );
        serviceMarket.createService(
            id2,
            name2,
            description2,
            code2,
            serviceType2,
            imageAddress2
        );

        serviceMarket.removeService(id);
        Service[] memory dataArray = serviceMarket.fetchAllServices();
        vm.assertEq(dataArray[0].id, id2);
        vm.assertEq(dataArray[0].name, name2);
        vm.assertEq(dataArray[0].description, description2);
        vm.assertEq(dataArray[0].code, code2);
        vm.assertEq(dataArray[0].serviceType, serviceType2);
        vm.assertEq(dataArray[0].imageAddress, imageAddress2);
    }
}

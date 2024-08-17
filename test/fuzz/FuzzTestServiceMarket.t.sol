// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {Test, console} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {ServiceMarket, Service} from "../../../src/ServiceMarket.sol";

contract fuzzTestserviceMarket is Test {
    ServiceMarket serviceMarket;
    address constant OWNER = address(1);
    address constant MANAGER = address(2);
    address constant USER = address(3);

    function setUp() external {
        serviceMarket = new ServiceMarket(OWNER);
        vm.prank(OWNER);
        serviceMarket.addManager(MANAGER);
    }

    function testFuzzCreatesTheServiceAndFetchesAllServices(
        uint256 nodeId,
        uint256 serviceId,
        string memory name,
        string memory description,
        string memory code,
        string memory serviceType,
        string memory imageAddress,
        uint256 nodeId2,
        uint256 serviceId2,
        string memory name2,
        string memory description2,
        string memory code2,
        string memory serviceType2,
        string memory imageAddress2
    ) external {
        if (nodeId == nodeId2 && serviceId == serviceId2) {
            nodeId++;
        }
        vm.startPrank(MANAGER);
        serviceMarket.createService(
            nodeId,
            serviceId,
            name,
            description,
            code,
            serviceType,
            imageAddress
        );
        serviceMarket.createService(
            nodeId2,
            serviceId2,
            name2,
            description2,
            code2,
            serviceType2,
            imageAddress2
        );

        Service[] memory dataArray = serviceMarket.fetchAllServices();
        vm.stopPrank();

        vm.assertEq(dataArray[0].nodeId, nodeId);
        vm.assertEq(dataArray[0].serviceId, serviceId);
        vm.assertEq(dataArray[0].name, name);
        vm.assertEq(dataArray[0].description, description);
        vm.assertEq(dataArray[0].code, code);
        vm.assertEq(dataArray[0].serviceType, serviceType);
        vm.assertEq(dataArray[0].imageAddress, imageAddress);
        vm.assertEq(dataArray[1].nodeId, nodeId2);
        vm.assertEq(dataArray[1].serviceId, serviceId2);
        vm.assertEq(dataArray[1].name, name2);
        vm.assertEq(dataArray[1].description, description2);
        vm.assertEq(dataArray[1].code, code2);
        vm.assertEq(dataArray[1].serviceType, serviceType2);
        vm.assertEq(dataArray[1].imageAddress, imageAddress2);
    }

    function testFuzzRemovesAndFetchesAllServices(
        uint256 nodeId,
        uint256 serviceId,
        string memory name,
        string memory description,
        string memory code,
        string memory serviceType,
        string memory imageAddress,
        uint256 nodeId2,
        uint256 serviceId2,
        string memory name2,
        string memory description2,
        string memory code2,
        string memory serviceType2,
        string memory imageAddress2
    ) external {
        if (nodeId == nodeId2 && serviceId == serviceId2) {
            nodeId++;
        }
        vm.startPrank(MANAGER);
        serviceMarket.createService(
            nodeId,
            serviceId,
            name,
            description,
            code,
            serviceType,
            imageAddress
        );
        serviceMarket.createService(
            nodeId2,
            serviceId2,
            name2,
            description2,
            code2,
            serviceType2,
            imageAddress2
        );

        serviceMarket.removeService(nodeId, serviceId);
        Service[] memory dataArray = serviceMarket.fetchAllServices();
        vm.stopPrank();
        vm.assertEq(dataArray[0].nodeId, nodeId2);
        vm.assertEq(dataArray[0].serviceId, serviceId2);
        vm.assertEq(dataArray[0].name, name2);
        vm.assertEq(dataArray[0].description, description2);
        vm.assertEq(dataArray[0].code, code2);
        vm.assertEq(dataArray[0].serviceType, serviceType2);
        vm.assertEq(dataArray[0].imageAddress, imageAddress2);
    }
}

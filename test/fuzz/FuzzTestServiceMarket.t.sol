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
        string memory serviceType,
        string memory device1,
        string memory device2,
        string memory device3,
        string memory installationPrice,
        string memory executionPrice,
        string memory imageURL,
        string memory program,
        string memory creationDate,
        string memory publishedDate,
        uint256 nodeId2,
        uint256 serviceId2,
        string memory name2,
        string memory description2,
        string memory serviceType2,
        string memory device4,
        string memory device5,
        string memory device6,
        string memory installationPrice2,
        string memory executionPrice2,
        string memory imageURL2,
        string memory program2,
        string memory creationDate2,
        string memory publishedDate2
    ) external {
        if (nodeId == nodeId2 && serviceId == serviceId2) {
            nodeId++;
        }
        vm.startPrank(MANAGER);
        string[] memory devices = new string[](3);
        devices[0] = device1;
        devices[1] = device2;
        devices[2] = device3;

        serviceMarket.createService(
            nodeId,
            serviceId,
            name,
            description,
            serviceType,
            devices,
            installationPrice,
            executionPrice,
            imageURL,
            program,
            creationDate,
            publishedDate
        );

        string[] memory devices2 = new string[](3);
        devices2[0] = device4;
        devices2[1] = device5;
        devices2[2] = device6;
        serviceMarket.createService(
            nodeId2,
            serviceId2,
            name2,
            description2,
            serviceType2,
            devices2,
            installationPrice2,
            executionPrice2,
            imageURL2,
            program2,
            creationDate2,
            publishedDate2
        );
        Service[] memory dataArray = serviceMarket.fetchAllServices();
        vm.stopPrank();

        vm.assertEq(dataArray[0].nodeId, nodeId);
        vm.assertEq(dataArray[0].serviceId, serviceId);
        vm.assertEq(dataArray[0].name, name);
        vm.assertEq(dataArray[0].description, description);
        vm.assertEq(dataArray[0].serviceType, serviceType);
        vm.assertEq(dataArray[0].program, program);
        vm.assertEq(dataArray[0].imageURL, imageURL);
        vm.assertEq(dataArray[1].nodeId, nodeId2);
        vm.assertEq(dataArray[1].serviceId, serviceId2);
        vm.assertEq(dataArray[1].name, name2);
        vm.assertEq(dataArray[1].description, description2);
        vm.assertEq(dataArray[1].serviceType, serviceType2);
        vm.assertEq(dataArray[1].program, program2);
        vm.assertEq(dataArray[1].imageURL, imageURL2);
    }

    function testFuzzRemovesAndFetchesAllServices(
        uint256 nodeId,
        uint256 serviceId,
        string memory name,
        string memory description,
        string memory serviceType,
        string memory device1,
        string memory device2,
        string memory device3,
        string memory installationPrice,
        string memory executionPrice,
        string memory imageURL,
        string memory program,
        string memory creationDate,
        string memory publishedDate,
        uint256 nodeId2,
        uint256 serviceId2,
        string memory name2,
        string memory description2,
        string memory serviceType2,
        string memory device4,
        string memory device5,
        string memory device6,
        string memory installationPrice2,
        string memory executionPrice2,
        string memory imageURL2,
        string memory program2,
        string memory creationDate2,
        string memory publishedDate2
    ) external {
        if (nodeId == nodeId2 && serviceId == serviceId2) {
            nodeId++;
        }
        vm.startPrank(MANAGER);
        string[] memory devices = new string[](3);
        devices[0] = device1;
        devices[1] = device2;
        devices[2] = device3;

        serviceMarket.createService(
            nodeId,
            serviceId,
            name,
            description,
            serviceType,
            devices,
            installationPrice,
            executionPrice,
            imageURL,
            program,
            creationDate,
            publishedDate
        );

        string[] memory devices2 = new string[](3);
        devices2[0] = device4;
        devices2[1] = device5;
        devices2[2] = device6;
        serviceMarket.createService(
            nodeId2,
            serviceId2,
            name2,
            description2,
            serviceType2,
            devices2,
            installationPrice2,
            executionPrice2,
            imageURL2,
            program2,
            creationDate2,
            publishedDate2
        );

        serviceMarket.removeService(nodeId, serviceId);
        Service[] memory dataArray = serviceMarket.fetchAllServices();
        vm.stopPrank();
        vm.assertEq(dataArray[0].nodeId, nodeId2);
        vm.assertEq(dataArray[0].serviceId, serviceId2);
        vm.assertEq(dataArray[0].name, name2);
        vm.assertEq(dataArray[0].description, description2);
        vm.assertEq(dataArray[0].serviceType, serviceType2);
        vm.assertEq(dataArray[0].program, program2);
        vm.assertEq(dataArray[0].imageURL, imageURL2);
    }
}

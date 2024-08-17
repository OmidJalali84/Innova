// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {Test} from "forge-std/Test.sol";
import {ServiceMarket, Service} from "../../../src/ServiceMarket.sol";

contract TestserviceMarket is Test {
    ServiceMarket serviceMarket;
    address constant OWNER = address(1);
    address constant MANAGER = address(2);
    address constant USER = address(3);

    function setUp() external {
        serviceMarket = new ServiceMarket(OWNER);
        vm.prank(OWNER);
        serviceMarket.addManager(MANAGER);
    }

    function createsService() public {
        vm.startPrank(MANAGER);
        string[] memory devices = new string[](3);
        devices[0] = "device1";
        devices[1] = "device2";
        devices[2] = "device3";
        serviceMarket.createService(
            1,
            123,
            "service1",
            "This is service1",
            "type1",
            devices,
            "10",
            "2",
            "src/file1/file2",
            "function setUp() external {serviceMarket = new serviceMarket()}",
            "date1",
            "date2"
        );

        string[] memory devices2 = new string[](3);
        devices2[0] = "device1";
        devices2[1] = "device2";
        devices2[2] = "device3";
        serviceMarket.createService(
            2,
            12345,
            "service2",
            "This is service2",
            "type2",
            devices,
            "20",
            "4",
            "src/file1/file2",
            "function setUp() external {serviceMarket = new serviceMarket()}",
            "date1",
            "date2"
        );
        vm.stopPrank();
    }

    function testCreatesAndFetchesAllServices() external {
        createsService();
        vm.prank(MANAGER);
        Service[] memory dataArray = serviceMarket.fetchAllServices();
        vm.assertEq(dataArray[0].nodeId, 1);
        vm.assertEq(dataArray[0].serviceId, 123);
        vm.assertEq(dataArray[0].name, "service1");
        vm.assertEq(dataArray[0].description, "This is service1");
        vm.assertEq(dataArray[0].serviceType, "type1");
        vm.assertEq(
            dataArray[0].program,
            "function setUp() external {serviceMarket = new serviceMarket()}"
        );
        vm.assertEq(dataArray[0].imageURL, "src/file1/file2");

        vm.assertEq(dataArray[1].nodeId, 2);
        vm.assertEq(dataArray[1].serviceId, 12345);
        vm.assertEq(dataArray[1].name, "service2");
        vm.assertEq(dataArray[1].description, "This is service2");
        vm.assertEq(
            dataArray[1].program,
            "function setUp() external {serviceMarket = new serviceMarket()}"
        );
        vm.assertEq(dataArray[1].serviceType, "type2");
        vm.assertEq(dataArray[1].imageURL, "src/file1/file2");
    }

    function testRemovesServiceCorrectly() external {
        createsService();

        vm.prank(MANAGER);
        serviceMarket.removeService(1, 123);

        vm.prank(MANAGER);
        Service[] memory dataArray = serviceMarket.fetchAllServices();

        vm.assertEq(dataArray[0].nodeId, 2);
        vm.assertEq(dataArray[0].serviceId, 12345);
        vm.assertEq(dataArray[0].name, "service2");
        vm.assertEq(dataArray[0].description, "This is service2");
        vm.assertEq(
            dataArray[0].program,
            "function setUp() external {serviceMarket = new serviceMarket()}"
        );
        vm.assertEq(dataArray[0].serviceType, "type2");
        vm.assertEq(dataArray[0].imageURL, "src/file1/file2");
    }
}

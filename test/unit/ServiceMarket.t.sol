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
        serviceMarket.createService(
            1,
            "service1",
            "This is service1",
            "function setUp() external {serviceMarket = new serviceMarket()}",
            "type1",
            "src/file1/file2"
        );
        vm.stopPrank();
        vm.startPrank(MANAGER);
        serviceMarket.createService(
            10,
            "service2",
            "This is service2",
            "function setUp() external {serviceMarket = new serviceMarket()}",
            "type2",
            "src/file1/file3"
        );
        vm.stopPrank();
    }

    function testCreatesAndFetchesAllServices() external {
        createsService();
        vm.prank(MANAGER);
        Service[] memory dataArray = serviceMarket.fetchAllServices();
        vm.assertEq(dataArray[0].id, 1);
        vm.assertEq(dataArray[0].name, "service1");
        vm.assertEq(dataArray[0].description, "This is service1");
        vm.assertEq(
            dataArray[0].code,
            "function setUp() external {serviceMarket = new serviceMarket()}"
        );
        vm.assertEq(dataArray[0].serviceType, "type1");
        vm.assertEq(dataArray[0].imageAddress, "src/file1/file2");

        vm.assertEq(dataArray[1].id, 10);
        vm.assertEq(dataArray[1].name, "service2");
        vm.assertEq(dataArray[1].description, "This is service2");
        vm.assertEq(
            dataArray[1].code,
            "function setUp() external {serviceMarket = new serviceMarket()}"
        );
        vm.assertEq(dataArray[1].serviceType, "type2");
        vm.assertEq(dataArray[1].imageAddress, "src/file1/file3");
    }

    function testRemovesServiceCorrectly() external {
        createsService();

        vm.prank(MANAGER);
        serviceMarket.removeService(1);

        vm.prank(MANAGER);
        Service[] memory dataArray = serviceMarket.fetchAllServices();

        vm.assertEq(dataArray[0].id, 10);
        vm.assertEq(dataArray[0].name, "service2");
        vm.assertEq(dataArray[0].description, "This is service2");
        vm.assertEq(
            dataArray[0].code,
            "function setUp() external {serviceMarket = new serviceMarket()}"
        );
        vm.assertEq(dataArray[0].serviceType, "type2");
        vm.assertEq(dataArray[0].imageAddress, "src/file1/file3");
    }
}

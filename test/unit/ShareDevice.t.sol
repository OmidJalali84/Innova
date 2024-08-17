// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {Test} from "forge-std/Test.sol";
import {SharedDevice, Device} from "../../../src/ShareDevice.sol";

contract TestshareDevice is Test {
    SharedDevice sharedDevice;
    address constant OWNER = address(1);
    address constant MANAGER = address(2);
    address constant USER = address(3);

    function setUp() external {
        sharedDevice = new SharedDevice(OWNER);
        vm.prank(OWNER);
        sharedDevice.addManager(MANAGER);
    }

    function createsDevice() public {
        vm.startPrank(MANAGER);
        string[] memory parameters = new string[](3);
        parameters[0] = "param1";
        parameters[1] = "param2";
        parameters[2] = "param3";
        string[] memory location = new string[](3);
        location[0] = "loc1";
        location[1] = "loc2";
        location[2] = "loc3";
        sharedDevice.createDevice(
            1,
            123,
            "3",
            "Device1",
            "type1",
            "45",
            "1",
            "2",
            parameters,
            "none",
            location,
            "date 1"
        );
        sharedDevice.createDevice(
            2,
            12345,
            "3",
            "Device2",
            "type2",
            "45",
            "1",
            "2",
            parameters,
            "none",
            location,
            "date 1"
        );
        vm.stopPrank();
    }

    function testCreatesAndFetchesAllDevices() external {
        createsDevice();
        vm.prank(MANAGER);
        Device[] memory dataArray = sharedDevice.fetchAllDevices();
        vm.assertEq(dataArray[0].nodeId, 1);
        vm.assertEq(dataArray[0].deviceId, 123);
        vm.assertEq(dataArray[0].name, "Device1");
        vm.assertEq(dataArray[0].deviceType, "type1");

        vm.assertEq(dataArray[1].nodeId, 2);
        vm.assertEq(dataArray[1].deviceId, 12345);
        vm.assertEq(dataArray[1].name, "Device2");
        vm.assertEq(dataArray[1].deviceType, "type2");
    }

    function testRemovesDeviceCorrectly() external {
        createsDevice();

        vm.prank(MANAGER);
        sharedDevice.removeDevice(1, 123);
        vm.prank(MANAGER);
        Device[] memory dataArray = sharedDevice.fetchAllDevices();

        vm.assertEq(dataArray[0].nodeId, 2);
        vm.assertEq(dataArray[0].deviceId, 12345);
        vm.assertEq(dataArray[0].name, "Device2");
        vm.assertEq(dataArray[0].deviceType, "type2");
    }
}

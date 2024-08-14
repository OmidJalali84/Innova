// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {Test} from "forge-std/Test.sol";
import {ShareDevice, Device} from "../../../src/ShareDevice.sol";

contract TestshareDevice is Test {
    ShareDevice shareDevice;
    address constant USER = address(1);

    function setUp() external {
        shareDevice = new ShareDevice();
    }

    function createsDevice() public {
        vm.startPrank(USER);
        shareDevice.createDevice(1, 10, "Device1", "src/file1/file2", "Iran");
        vm.stopPrank();
        vm.startPrank(USER);
        shareDevice.createDevice(7, 20, "Device2", "src/file3/file4", "Canada");
        vm.stopPrank();
    }

    function testCreatesAndFetchesAllDevices() external {
        createsDevice();
        Device[] memory dataArray = shareDevice.fetchAllDevices();
        vm.assertEq(dataArray[0].id, 1);
        vm.assertEq(dataArray[0].price, 10);
        vm.assertEq(dataArray[0].name, "Device1");
        vm.assertEq(dataArray[0].nodeAddress, "src/file1/file2");
        vm.assertEq(dataArray[0].location, "Iran");

        vm.assertEq(dataArray[1].id, 7);
        vm.assertEq(dataArray[1].price, 20);
        vm.assertEq(dataArray[1].name, "Device2");
        vm.assertEq(dataArray[1].nodeAddress, "src/file3/file4");
        vm.assertEq(dataArray[1].location, "Canada");
    }

    function testRemovesDeviceCorrectly() external {
        createsDevice();

        shareDevice.removeDevice(1);
        Device[] memory dataArray = shareDevice.fetchAllDevices();

        vm.assertEq(dataArray[0].id, 7);
        vm.assertEq(dataArray[0].price, 20);
        vm.assertEq(dataArray[0].name, "Device2");
        vm.assertEq(dataArray[0].nodeAddress, "src/file3/file4");
        vm.assertEq(dataArray[0].location, "Canada");
    }
}

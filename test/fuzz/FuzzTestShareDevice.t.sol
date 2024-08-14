// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Test} from "forge-std/Test.sol";
import {ShareDevice, Device} from "../../../src/ShareDevice.sol";

contract fuzzTestshareDevice is Test {
    ShareDevice shareDevice;
    address constant USER = address(1);

    function setUp() external {
        shareDevice = new ShareDevice();
    }

    function testFuzzCreatesTheDeviceAndFetchesAll(
        uint256 id,
        uint256 price,
        string memory name,
        string memory nodeAddress,
        string memory location,
        uint256 id2,
        uint256 price2,
        string memory name2,
        string memory nodeAddress2,
        string memory location2
    ) external {
        if (id == id2) {
            if (id2 != type(uint256).max) {
                id2 += 1; // Modify id2 to be different if they are the same
            } else {
                return;
            }
        }
        shareDevice.createDevice(id, price, name, nodeAddress, location);
        shareDevice.createDevice(id2, price2, name2, nodeAddress2, location2);

        Device[] memory dataArray = shareDevice.fetchAllDevices();
        vm.assertEq(dataArray[0].id, id);
        vm.assertEq(dataArray[0].price, price);
        vm.assertEq(dataArray[0].name, name);
        vm.assertEq(dataArray[0].nodeAddress, nodeAddress);
        vm.assertEq(dataArray[0].location, location);
        vm.assertEq(dataArray[1].id, id2);
        vm.assertEq(dataArray[1].price, price2);
        vm.assertEq(dataArray[1].name, name2);
        vm.assertEq(dataArray[1].nodeAddress, nodeAddress2);
        vm.assertEq(dataArray[1].location, location2);
    }

    function testFuzzRemovesAndFetchesAllDevices(
        uint256 id,
        uint256 price,
        string memory name,
        string memory nodeAddress,
        string memory location,
        uint256 id2,
        uint256 price2,
        string memory name2,
        string memory nodeAddress2,
        string memory location2
    ) external {
        if (id == id2) {
            if (id2 != type(uint256).max) {
                id2 += 1; // Modify id2 to be different if they are the same
            } else {
                return;
            }
        }

        shareDevice.createDevice(id, price, name, nodeAddress, location);
        shareDevice.createDevice(id2, price2, name2, nodeAddress2, location2);

        shareDevice.removeDevice(id);
        Device[] memory dataArray = shareDevice.fetchAllDevices();
        vm.assertEq(dataArray[0].id, id2);
        vm.assertEq(dataArray[0].price, price2);
        vm.assertEq(dataArray[0].name, name2);
        vm.assertEq(dataArray[0].nodeAddress, nodeAddress2);
        vm.assertEq(dataArray[0].location, location2);
    }
}

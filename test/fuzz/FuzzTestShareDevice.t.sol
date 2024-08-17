// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {Test} from "forge-std/Test.sol";
import {SharedDevice, Device} from "../../../src/ShareDevice.sol";

contract fuzzTestshareDevice is Test {
    SharedDevice sharedDevice;
    address constant OWNER = address(1);
    address constant MANAGER = address(2);
    address constant USER = address(3);

    function setUp() external {
        sharedDevice = new SharedDevice(OWNER);
        vm.prank(OWNER);
        sharedDevice.addManager(MANAGER);
    }

    function testFuzzCreatesTheDeviceAndFetchesAll(
        uint256 nodeId,
        uint256 deviceId,
        string memory ownerId,
        string memory name,
        string memory deviceType,
        string memory encryptedID,
        string memory hardwareVersion,
        string memory firmwareVersion,
        string memory parameter1,
        string memory parameter2,
        string memory parameter3,
        string memory useCost,
        string memory locationGPS1,
        string memory locationGPS2,
        string memory locationGPS3,
        string memory installationDate,
        uint256 nodeId2,
        uint256 deviceId2,
        string memory ownerId2,
        string memory name2,
        string memory deviceType2,
        string memory encryptedID2,
        string memory hardwareVersion2,
        string memory firmwareVersion2,
        string memory parameter4,
        string memory parameter5,
        string memory parameter6,
        string memory useCost2,
        string memory locationGPS4,
        string memory locationGPS5,
        string memory locationGPS6,
        string memory installationDate2
    ) external {
        if (nodeId == nodeId2 && deviceId == deviceId2) {
            nodeId++;
        }

        vm.prank(MANAGER);
        string[] memory parameters = new string[](3);
        parameters[0] = parameter1;
        parameters[1] = parameter2;
        parameters[2] = parameter3;

        string[] memory locationGPSs = new string[](3);
        locationGPSs[0] = locationGPS1;
        locationGPSs[1] = locationGPS2;
        locationGPSs[2] = locationGPS3;

        sharedDevice.createDevice(
            nodeId,
            deviceId,
            ownerId,
            name,
            deviceType,
            encryptedID,
            hardwareVersion,
            firmwareVersion,
            parameters,
            useCost,
            locationGPSs,
            installationDate
        );

        vm.prank(MANAGER);
        string[] memory parameters2 = new string[](3);
        parameters2[0] = parameter4;
        parameters2[1] = parameter5;
        parameters2[2] = parameter6;

        string[] memory locationGPSs2 = new string[](3);
        locationGPSs2[0] = locationGPS4;
        locationGPSs2[1] = locationGPS5;
        locationGPSs2[2] = locationGPS6;
        sharedDevice.createDevice(
            nodeId2,
            deviceId2,
            ownerId2,
            name2,
            deviceType2,
            encryptedID2,
            hardwareVersion2,
            firmwareVersion2,
            parameters2,
            useCost2,
            locationGPSs2,
            installationDate2
        );

        vm.prank(MANAGER);
        Device[] memory dataArray = sharedDevice.fetchAllDevices();
        vm.assertEq(dataArray[0].nodeId, nodeId);
        vm.assertEq(dataArray[0].deviceId, deviceId);
        vm.assertEq(dataArray[0].name, name);
        vm.assertEq(dataArray[0].deviceType, deviceType);
        vm.assertEq(dataArray[1].nodeId, nodeId2);
        vm.assertEq(dataArray[1].deviceId, deviceId2);
        vm.assertEq(dataArray[1].name, name2);
        vm.assertEq(dataArray[1].deviceType, deviceType2);
    }

    function testFuzzRemovesAndFetchesAllDevices(
        uint256 nodeId,
        uint256 deviceId,
        string memory ownerId,
        string memory name,
        string memory deviceType,
        string memory encryptedID,
        string memory hardwareVersion,
        string memory firmwareVersion,
        string memory parameter1,
        string memory parameter2,
        string memory parameter3,
        string memory useCost,
        string memory locationGPS1,
        string memory locationGPS2,
        string memory locationGPS3,
        string memory installationDate,
        uint256 nodeId2,
        uint256 deviceId2,
        string memory ownerId2,
        string memory name2,
        string memory deviceType2,
        string memory encryptedID2,
        string memory hardwareVersion2,
        string memory firmwareVersion2,
        string memory parameter4,
        string memory parameter5,
        string memory parameter6,
        string memory useCost2,
        string memory locationGPS4,
        string memory locationGPS5,
        string memory locationGPS6,
        string memory installationDate2
    ) external {
        if (nodeId == nodeId2 && deviceId == deviceId2) {
            nodeId++;
        }

        vm.prank(MANAGER);
        string[] memory parameters = new string[](3);
        parameters[0] = parameter1;
        parameters[1] = parameter2;
        parameters[2] = parameter3;

        string[] memory locationGPSs = new string[](3);
        locationGPSs[0] = locationGPS1;
        locationGPSs[1] = locationGPS2;
        locationGPSs[2] = locationGPS3;

        sharedDevice.createDevice(
            nodeId,
            deviceId,
            ownerId,
            name,
            deviceType,
            encryptedID,
            hardwareVersion,
            firmwareVersion,
            parameters,
            useCost,
            locationGPSs,
            installationDate
        );

        vm.prank(MANAGER);
        string[] memory parameters2 = new string[](3);
        parameters2[0] = parameter4;
        parameters2[1] = parameter5;
        parameters2[2] = parameter6;

        string[] memory locationGPSs2 = new string[](3);
        locationGPSs2[0] = locationGPS4;
        locationGPSs2[1] = locationGPS5;
        locationGPSs2[2] = locationGPS6;
        sharedDevice.createDevice(
            nodeId2,
            deviceId2,
            ownerId2,
            name2,
            deviceType2,
            encryptedID2,
            hardwareVersion2,
            firmwareVersion2,
            parameters2,
            useCost2,
            locationGPSs2,
            installationDate2
        );

        vm.prank(MANAGER);
        sharedDevice.removeDevice(nodeId, deviceId);

        vm.prank(MANAGER);
        Device[] memory dataArray = sharedDevice.fetchAllDevices();
        vm.assertEq(dataArray[0].nodeId, nodeId2);
        vm.assertEq(dataArray[0].deviceId, deviceId2);
        vm.assertEq(dataArray[0].name, name2);
        vm.assertEq(dataArray[0].deviceType, deviceType2);
    }
}

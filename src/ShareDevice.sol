// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {AccessManagers} from "./utils/AccessManagers.sol";

struct Device {
    uint256 nodeId;
    uint256 deviceId;
    string ownerId;
    string name;
    string deviceType;
    string encryptedID;
    string hardwareVersion;
    string firmwareVersion;
    string[] parameters;
    string useCost;
    string[] locationGPS;
    string installationDate;
}

contract SharedDevice is AccessManagers {
    /**********************************************************************************************/
    /*** errors                                                                                ***/
    /**********************************************************************************************/
    error SharedDevice__DuplicatedId(uint256 nodeId, uint256 deviceId);
    error SharedDevice__DeviceIdNotExist(uint256 nodeId, uint256 deviceId);

    /**********************************************************************************************/
    /*** constructor                                                                             ***/
    /**********************************************************************************************/

    constructor(address initialOwner) AccessManagers(initialOwner) {}

    /**********************************************************************************************/
    /*** Storage                                                                                ***/
    /**********************************************************************************************/

    ///@dev Mapping of device id to device
    mapping(uint256 id => Device device) private s_devices;

    ///@dev Finde ID of a device by its node id and device id
    mapping(uint256 nodeId => mapping(uint256 deviceId => uint256 id)) s_findeId;

    uint256 id = 1;

    ///@dev Array of existing devices
    uint256[] private s_IDs;
    /**********************************************************************************************/
    /*** events                                                                                ***/
    /**********************************************************************************************/

    event DeviceCreated(uint256 indexed id, Device device);
    event DeviceRemoved(uint256 indexed id, Device device);

    /**********************************************************************************************/
    /*** external functions                                                                      ***/
    /**********************************************************************************************/

    function createDevice(
        uint256 nodeId,
        uint256 deviceId,
        string memory ownerId,
        string memory name,
        string memory deviceType,
        string memory encryptedID,
        string memory hardwareVersion,
        string memory firmwareVersion,
        string[] memory parameters,
        string memory useCost,
        string[] memory locationGPS,
        string memory installationDate
    ) external onlyManager returns (uint256) {
        ///@dev Duplicate id error handling
        if (s_findeId[nodeId][deviceId] != 0) {
            revert SharedDevice__DuplicatedId(nodeId, deviceId);
        }
        s_findeId[nodeId][deviceId] = id;
        s_devices[id] = Device(
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
            locationGPS,
            installationDate
        );
        s_IDs.push(id);

        emit DeviceCreated(id, s_devices[id]);
        id++;
        return id;
    }

    /*
     * @notice This function will remove a device by its id
     */
    function removeDevice(
        uint256 targetNodeId,
        uint256 targetdeviceId
    ) external onlyManager {
        if (s_findeId[targetNodeId][targetdeviceId] == 0) {
            revert SharedDevice__DeviceIdNotExist(targetNodeId, targetdeviceId);
        }

        uint256 targetId = s_findeId[targetNodeId][targetdeviceId];
        uint256[] memory tempIDs = s_IDs;
        ///@dev removing the target ID from IDs array
        for (uint256 i; i < tempIDs.length; i++) {
            if (tempIDs[i] == targetId) {
                s_IDs[i] = s_IDs[s_IDs.length - 1];
                s_IDs.pop();
                break;
            }
        }

        s_findeId[targetNodeId][targetdeviceId] = 0;

        emit DeviceRemoved(targetId, s_devices[targetId]);

        ///@dev removing the target device from devices mapping
        delete (s_devices[targetId]);
    }

    /*
     * @notice Returns all the existing devices as an array
     */
    function fetchAllDevices()
        external
        view
        onlyManager
        returns (Device[] memory)
    {
        Device[] memory dataArray = new Device[](s_IDs.length);
        for (uint256 i = 0; i < s_IDs.length; i++) {
            dataArray[i] = s_devices[s_IDs[i]];
        }
        return dataArray;
    }

    /**********************************************************************************************/
    /*** veiw functions                                                                         ***/
    /**********************************************************************************************/

    function getIDs() public view returns (uint256[] memory) {
        return s_IDs;
    }
}

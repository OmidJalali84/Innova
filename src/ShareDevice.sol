// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

struct Device {
    uint256 id;
    uint256 price;
    string name;
    string nodeAddress;
    string location;
}

contract ShareDevice {
    /**********************************************************************************************/
    /*** errors                                                                                ***/
    /**********************************************************************************************/
    error ShareDevice__DuplicatedId();
    error ShareDevice__DeviceIdNotExist();

    /**********************************************************************************************/
    /*** Storage                                                                                ***/
    /**********************************************************************************************/

    ///@dev Mapping of device id to device
    mapping(uint256 id => Device device) private s_Devices;

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

    /*
     * @param id: The id of device
     * @param name: The name of device
     * @param nodeAddress: The address of node
     * @param location: The location of device
     * @notice This function will create a new device
     */
    function createDevice(
        uint256 id,
        uint256 price,
        string memory name,
        string memory nodeAddress,
        string memory location
    ) external {
        ///@dev Duplicate id error handling
        uint256[] memory tempIDs = s_IDs; //An memory instance of IDs array. Because accessing to storage varibales are more gas expencive.
        for (uint256 i; i < tempIDs.length; i++) {
            if (id == tempIDs[i]) {
                revert ShareDevice__DuplicatedId();
            }
        }
        s_Devices[id] = Device(id, price, name, nodeAddress, location);
        s_IDs.push(id);

        emit DeviceCreated(id, s_Devices[id]);
    }

    /*
     * @notice This function will remove a device by its id
     * @dev IDs has been stored in a seprate array to handle the removing process correctlly
     */
    function removeDevice(uint256 targetId) external {
        uint256[] memory tempIDs = s_IDs;

        ///@dev removing the target ID from IDs array
        for (uint256 i; i < tempIDs.length; i++) {
            if (tempIDs[i] == targetId) {
                s_IDs[i] = s_IDs[s_IDs.length - 1];
                s_IDs.pop();
                break;
            } else if (i == tempIDs.length - 1) {
                revert ShareDevice__DeviceIdNotExist();
            }
        }

        emit DeviceRemoved(targetId, s_Devices[targetId]);

        ///@dev removing the target device from s_devices mapping
        delete (s_Devices[targetId]);
    }

    /*
     * @notice Returns all the existing devices as an array
     */
    function fetchAllDevices() external view returns (Device[] memory) {
        Device[] memory dataArray = new Device[](s_IDs.length);
        for (uint256 i = 0; i < s_IDs.length; i++) {
            dataArray[i] = s_Devices[s_IDs[i]];
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



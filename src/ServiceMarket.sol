// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {AccessManagers} from "./utils/AccessManagers.sol";

struct Service {
    uint256 nodeId;
    uint256 serviceId;
    string name;
    string description;
    string serviceType;
    string[] devices;
    string installationPrice;
    string executionPrice;
    string imageURL;
    string program;
    string creationDate;
    string publishedDate;
}

contract ServiceMarket is AccessManagers {
    /**********************************************************************************************/
    /*** errors                                                                                 ***/
    /**********************************************************************************************/
    error ServiceMarket__DuplicatedId(uint256 nodeId, uint256 serviceId);
    error ServiceMarket__ServiceIdNotExist(uint256 nodeId, uint256 serviceId);

    /**********************************************************************************************/
    /*** constructor                                                                             ***/
    /**********************************************************************************************/

    constructor(address initialOwner) AccessManagers(initialOwner) {}

    /**********************************************************************************************/
    /*** Storage                                                                                 ***/
    /**********************************************************************************************/

    /// @dev Mapping of service id to service
    mapping(uint256 id => Service service) private s_services;

    /// @dev Find ID of a service by its node id and service id
    mapping(uint256 nodeId => mapping(uint256 serviceId => uint256 id)) s_findId;

    uint256 id = 1;

    /// @dev Array of existing services
    uint256[] private s_IDs;

    /**********************************************************************************************/
    /*** events                                                                                  ***/
    /**********************************************************************************************/

    event ServiceCreated(uint256 indexed id, Service service);
    event ServiceRemoved(uint256 indexed id, Service service);

    /**********************************************************************************************/
    /*** external functions                                                                      ***/
    /**********************************************************************************************/

    /*
     * @param id: The id of the service
     * @param name: The name of the service
     * @param description: The description of the service
     * @param code: The code of the service
     * @param serviceType: The type of the service
     * @param imageAddress: The image address of the service stored in off-chain nodes
     * @notice This function creates a new service
     */
    function createService(
        uint256 nodeId,
        uint256 serviceId,
        string memory name,
        string memory description,
        string memory serviceType,
        string[] memory devices,
        string memory installationPrice,
        string memory executionPrice,
        string memory imageURL,
        string memory program,
        string memory creationDate,
        string memory publishedDate
    ) external onlyManager returns (uint256) {
        /// @dev Duplicate ID error handling
        if (s_findId[nodeId][serviceId] != 0) {
            revert ServiceMarket__DuplicatedId(nodeId, serviceId);
        }
        s_findId[nodeId][serviceId] = id;
        s_services[id] = Service(
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
        s_IDs.push(id);

        emit ServiceCreated(id, s_services[id]);
        id++;
        return id;
    }

    /*
     * @notice This function removes a service by its id
     * @dev IDs are stored in a separate array to handle the removal process correctly
     */
    function removeService(
        uint256 targetNodeId,
        uint256 targetServiceId
    ) external onlyManager {
        if (s_findId[targetNodeId][targetServiceId] == 0) {
            revert ServiceMarket__ServiceIdNotExist(
                targetNodeId,
                targetServiceId
            );
        }

        uint256 targetId = s_findId[targetNodeId][targetServiceId];
        uint256[] memory tempIDs = s_IDs;
        /// @dev Removing the target ID from the IDs array
        for (uint256 i; i < tempIDs.length; i++) {
            if (tempIDs[i] == targetId) {
                s_IDs[i] = s_IDs[s_IDs.length - 1];
                s_IDs.pop();
                break;
            }
        }

        s_findId[targetNodeId][targetServiceId] = 0;

        emit ServiceRemoved(targetId, s_services[targetId]);

        /// @dev Removing the target service from services mapping
        delete (s_services[targetId]);
    }

    /*
     * @notice Returns all the existing services as an array
     */
    function fetchAllServices()
        external
        view
        onlyManager
        returns (Service[] memory)
    {
        Service[] memory dataArray = new Service[](s_IDs.length);
        for (uint256 i = 0; i < s_IDs.length; i++) {
            dataArray[i] = s_services[s_IDs[i]];
        }
        return dataArray;
    }

    /**********************************************************************************************/
    /*** view functions                                                                          ***/
    /**********************************************************************************************/

    function getIDs() public view returns (uint256[] memory) {
        return s_IDs;
    }
}

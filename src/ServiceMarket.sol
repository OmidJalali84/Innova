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
    /*** errors                                                                                ***/
    /**********************************************************************************************/
    error ServiceMArket__DuplicatedId(uint256 nodeId, uint256 serviceId);
    error ServiceMArket__ServiceIdNotExist(uint256 nodeId, uint256 serviceId);

    /**********************************************************************************************/
    /*** constructor                                                                             ***/
    /**********************************************************************************************/

    constructor(address initialOwner) AccessManagers(initialOwner) {}

    /**********************************************************************************************/
    /*** Storage                                                                                ***/
    /**********************************************************************************************/

    ///@dev Mapping of srvice id to service
    mapping(uint256 id => Service service) private s_services;

    ///@dev Finde ID of a service by its node id and service id
    mapping(uint256 nodeId => mapping(uint256 serviceId => uint256 id)) s_findeId;

    uint256 id = 1;

    ///@dev Array of existing services
    uint256[] private s_IDs;
    /**********************************************************************************************/
    /*** events                                                                                ***/
    /**********************************************************************************************/

    event ServiceCreated(uint256 indexed id, Service service);
    event ServiceRemoved(uint256 indexed id, Service service);

    /**********************************************************************************************/
    /*** external functions                                                                      ***/
    /**********************************************************************************************/

    /*
     * @param id: The id of service
     * @param name: The name of service
     * @param description: The description of service
     * @param code: The code of service
     * @param servicetype: The type of service
     * @param imageAddress: The image address of service that has stored in off-chain nodes
     * @notice This function will create a new service
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
        ///@dev Duplicate id error handling
        if (s_findeId[nodeId][serviceId] != 0) {
            revert ServiceMArket__DuplicatedId(nodeId, serviceId);
        }
        s_findeId[nodeId][serviceId] = id;
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
     * @notice This function will remove a service by its id
     * @dev IDs has been stored in a seprate array to handle the removing process correctlly
     */
    function removeService(
        uint256 targetNodeId,
        uint256 targetServiceId
    ) external onlyManager {
        if (s_findeId[targetNodeId][targetServiceId] == 0) {
            revert ServiceMArket__ServiceIdNotExist(
                targetNodeId,
                targetServiceId
            );
        }

        uint256 targetId = s_findeId[targetNodeId][targetServiceId];
        uint256[] memory tempIDs = s_IDs;
        ///@dev removing the target ID from IDs array
        for (uint256 i; i < tempIDs.length; i++) {
            if (tempIDs[i] == targetId) {
                s_IDs[i] = s_IDs[s_IDs.length - 1];
                s_IDs.pop();
                break;
            }
        }

        s_findeId[targetNodeId][targetServiceId] = 0;

        emit ServiceRemoved(targetId, s_services[targetId]);

        ///@dev removing the target service from services mapping
        delete (s_services[targetId]);
    }

    /*
     * @notice Returns all the existing servicis as a array
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
    /*** veiw functions                                                                         ***/
    /**********************************************************************************************/

    function getIDs() public view returns (uint256[] memory) {
        return s_IDs;
    }
}

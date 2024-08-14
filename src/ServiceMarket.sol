// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {AccessManagers} from "./utils/AccessManagers.sol";

struct Service {
    uint256 id;
    string name;
    string description;
    string code;
    string serviceType;
    string imageAddress;
}

contract ServiceMarket is AccessManagers {
    /**********************************************************************************************/
    /*** errors                                                                                ***/
    /**********************************************************************************************/
    error ServiceMArket__DuplicatedId();
    error ServiceMArket__ServiceIdNotExist();

    /**********************************************************************************************/
    /*** constructor                                                                             ***/
    /**********************************************************************************************/

    constructor(address initialOwner) AccessManagers(initialOwner) {}

    /**********************************************************************************************/
    /*** Storage                                                                                ***/
    /**********************************************************************************************/

    ///@dev Mapping of srvice id to service
    mapping(uint256 id => Service service) private s_services;

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
        uint256 id,
        string memory name,
        string memory description,
        string memory code,
        string memory serviceType,
        string memory imageAddress
    ) external onlyManager {
        ///@dev Duplicate id error handling
        uint256[] memory tempIDs = s_IDs; //An memory instance of IDs array. Because accessing to storage varibales are more gas expencive.
        for (uint256 i; i < tempIDs.length; i++) {
            if (id == tempIDs[i]) {
                revert ServiceMArket__DuplicatedId();
            }
        }
        s_services[id] = Service(
            id,
            name,
            description,
            code,
            serviceType,
            imageAddress
        );
        s_IDs.push(id);

        emit ServiceCreated(id, s_services[id]);
    }

    /*
     * @notice This function will remove a service by its id
     * @dev IDs has been stored in a seprate array to handle the removing process correctlly
     */
    function removeService(uint256 targetId) external onlyManager {
        uint256[] memory tempIDs = s_IDs;

        ///@dev removing the target ID from IDs array
        for (uint256 i; i < tempIDs.length; i++) {
            if (tempIDs[i] == targetId) {
                s_IDs[i] = s_IDs[s_IDs.length - 1];
                s_IDs.pop();
                break;
            } else if (i == tempIDs.length - 1) {
                revert ServiceMArket__ServiceIdNotExist();
            }
        }

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

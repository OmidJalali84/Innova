export const serviceContractAddress =
  "0xbbc50617dC60aA5B8ebAf785FF44119Fb7554ff4";
export const deviceContractAddress =
  "0x345836AE19Bb5991AFbE4a4BE22615b57558B966";

export const deviceAbi = [
  {
    inputs: [
      {
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "price",
        type: "uint256",
      },
      {
        internalType: "string",
        name: "name",
        type: "string",
      },
      {
        internalType: "string",
        name: "nodeAddress",
        type: "string",
      },
      {
        internalType: "string",
        name: "location",
        type: "string",
      },
    ],
    name: "createDevice",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "ShareDevice__DeviceIdNotExist",
    type: "error",
  },
  {
    inputs: [],
    name: "ShareDevice__DuplicatedId",
    type: "error",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
      {
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "price",
            type: "uint256",
          },
          {
            internalType: "string",
            name: "name",
            type: "string",
          },
          {
            internalType: "string",
            name: "nodeAddress",
            type: "string",
          },
          {
            internalType: "string",
            name: "location",
            type: "string",
          },
        ],
        indexed: false,
        internalType: "struct Device",
        name: "device",
        type: "tuple",
      },
    ],
    name: "DeviceCreated",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
      {
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "price",
            type: "uint256",
          },
          {
            internalType: "string",
            name: "name",
            type: "string",
          },
          {
            internalType: "string",
            name: "nodeAddress",
            type: "string",
          },
          {
            internalType: "string",
            name: "location",
            type: "string",
          },
        ],
        indexed: false,
        internalType: "struct Device",
        name: "device",
        type: "tuple",
      },
    ],
    name: "DeviceRemoved",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "targetId",
        type: "uint256",
      },
    ],
    name: "removeDevice",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "fetchAllDevices",
    outputs: [
      {
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "price",
            type: "uint256",
          },
          {
            internalType: "string",
            name: "name",
            type: "string",
          },
          {
            internalType: "string",
            name: "nodeAddress",
            type: "string",
          },
          {
            internalType: "string",
            name: "location",
            type: "string",
          },
        ],
        internalType: "struct Device[]",
        name: "",
        type: "tuple[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getIDs",
    outputs: [
      {
        internalType: "uint256[]",
        name: "",
        type: "uint256[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];
export const serviceAbi = [
  {
    inputs: [
      {
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
      {
        internalType: "string",
        name: "name",
        type: "string",
      },
      {
        internalType: "string",
        name: "description",
        type: "string",
      },
      {
        internalType: "string",
        name: "code",
        type: "string",
      },
      {
        internalType: "string",
        name: "serviceType",
        type: "string",
      },
      {
        internalType: "string",
        name: "imageAddress",
        type: "string",
      },
    ],
    name: "createService",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "targetId",
        type: "uint256",
      },
    ],
    name: "removeService",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "ServiceMArket__DuplicatedId",
    type: "error",
  },
  {
    inputs: [],
    name: "ServiceMArket__ServiceIdNotExist",
    type: "error",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
      {
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "string",
            name: "name",
            type: "string",
          },
          {
            internalType: "string",
            name: "description",
            type: "string",
          },
          {
            internalType: "string",
            name: "code",
            type: "string",
          },
          {
            internalType: "string",
            name: "serviceType",
            type: "string",
          },
          {
            internalType: "string",
            name: "imageAddress",
            type: "string",
          },
        ],
        indexed: false,
        internalType: "struct Service",
        name: "service",
        type: "tuple",
      },
    ],
    name: "ServiceCreated",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
      {
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "string",
            name: "name",
            type: "string",
          },
          {
            internalType: "string",
            name: "description",
            type: "string",
          },
          {
            internalType: "string",
            name: "code",
            type: "string",
          },
          {
            internalType: "string",
            name: "serviceType",
            type: "string",
          },
          {
            internalType: "string",
            name: "imageAddress",
            type: "string",
          },
        ],
        indexed: false,
        internalType: "struct Service",
        name: "service",
        type: "tuple",
      },
    ],
    name: "ServiceRemoved",
    type: "event",
  },
  {
    inputs: [],
    name: "fetchAllServices",
    outputs: [
      {
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "string",
            name: "name",
            type: "string",
          },
          {
            internalType: "string",
            name: "description",
            type: "string",
          },
          {
            internalType: "string",
            name: "code",
            type: "string",
          },
          {
            internalType: "string",
            name: "serviceType",
            type: "string",
          },
          {
            internalType: "string",
            name: "imageAddress",
            type: "string",
          },
        ],
        internalType: "struct Service[]",
        name: "",
        type: "tuple[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getIDs",
    outputs: [
      {
        internalType: "uint256[]",
        name: "",
        type: "uint256[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];

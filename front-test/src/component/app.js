"use client";
import React, { useState } from "react";
import { ethers } from "ethers";
import {
  serviceContractAddress,
  serviceAbi,
  deviceContractAddress,
  deviceAbi,
} from "../../contract";
import "./app.css";
import { ConnectKitButton } from "connectkit";
import { useEthersSigner } from "../../ethersSigner";
import { useAccount } from "wagmi";

export default function App() {
  const [selectedSection, setSelectedSection] = useState("service"); // "service" or "device"
  const [serviceData, setServiceData] = useState({
    id: "",
    name: "",
    description: "",
    code: "",
    serviceType: "",
    imageAddress: "",
  });
  const [deviceData, setDeviceData] = useState({
    id: "",
    price: "",
    name: "",
    nodeAddress: "",
    location: "",
  });
  const [serviceId, setServiceId] = useState("");
  const [allServices, setAllServices] = useState([]);
  const [expandedRow, setExpandedRow] = useState(null);

  const signer = useEthersSigner();
  const { address } = useAccount();

  const handleRowClick = (index) => {
    setExpandedRow(expandedRow === index ? null : index);
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    if (selectedSection === "service") {
      setServiceData({ ...serviceData, [name]: value });
    } else {
      setDeviceData({ ...deviceData, [name]: value });
    }
  };

  const addService = async () => {
    if (address) {
      if (selectedSection === "service") {
        const contract = new ethers.Contract(
          serviceContractAddress,
          serviceAbi,
          signer
        );
        const tx = await contract.createService(
          serviceData.id,
          serviceData.name,
          serviceData.description,
          serviceData.code,
          serviceData.serviceType,
          serviceData.imageAddress
        );
        await tx.wait();
        alert("Service added successfully!");
      } else {
        const contract = new ethers.Contract(
          deviceContractAddress,
          deviceAbi,
          signer
        );
        const tx = await contract.createDevice(
          deviceData.id,
          deviceData.price,
          deviceData.name,
          deviceData.nodeAddress,
          deviceData.location
        );
        await tx.wait();
        alert("Device added successfully!");
      }
    } else {
      alert("First connect a wallet");
    }
  };

  const removeService = async () => {
    if (address) {
      if (selectedSection == "service") {
        const contract = new ethers.Contract(
          serviceContractAddress,
          serviceAbi,
          signer
        );

        const tx = await contract.removeService(serviceId);
        await tx.wait();
        alert("Service removed successfully!");
      } else {
        const contract = new ethers.Contract(
          deviceContractAddress,
          deviceAbi,
          signer
        );

        const tx = await contract.removeDevice(serviceId);
        await tx.wait();
        alert("Service removed successfully!");
      }
    } else {
      alert("First connect a wallet");
    }
  };

  const fetchAllServices = async () => {
    if (address) {
      if (selectedSection == "service") {
        const contract = new ethers.Contract(
          serviceContractAddress,
          serviceAbi,
          signer
        );

        const services = await contract.fetchAllServices();
        setAllServices(services);
      } else {
        const contract = new ethers.Contract(
          deviceContractAddress,
          deviceAbi,
          signer
        );

        const services = await contract.fetchAllDevices();
        setAllServices(services);
      }
    } else {
      alert("First connect a wallet");
    }
  };

  return (
    <div className="container">
      <div className="header">
        {" "}
        <ConnectKitButton />
        {selectedSection === "service" ? (
          <a
            href="https://sepolia.etherscan.io/address/0xbbc50617dC60aA5B8ebAf785FF44119Fb7554ff4"
            target="_blank"
          >
            <button className="smart-contract">Smart Contract</button>
          </a>
        ) : (
          <a
            href="https://sepolia.etherscan.io/address/0x345836AE19Bb5991AFbE4a4BE22615b57558B966"
            target="_blank"
          >
            <button className="smart-contract">Smart Contract</button>
          </a>
        )}
      </div>
      <h1 className="title">Smart Contract UI</h1>

      <div className="navbar">
        <button
          className={`navbar-button ${
            selectedSection === "service" ? "active" : ""
          }`}
          onClick={() => {
            setSelectedSection("service");
            setAllServices([]);
          }}
        >
          service
        </button>
        <button
          className={`navbar-button ${
            selectedSection === "device" ? "active" : ""
          }`}
          onClick={() => {
            setSelectedSection("device");
            setAllServices([]);
          }}
        >
          Device
        </button>
      </div>

      <div className="section">
        {selectedSection === "service" ? (
          <>
            <h2 className="subtitle">Add Service</h2>
            <div className="formGroup">
              <input
                className="input"
                type="text"
                name="id"
                placeholder="Service ID"
                onChange={handleInputChange}
              />
              <input
                className="input"
                type="text"
                name="name"
                placeholder="Service Name"
                onChange={handleInputChange}
              />
              <input
                className="input"
                type="text"
                name="description"
                placeholder="Description"
                onChange={handleInputChange}
              />
              <input
                className="input"
                type="text"
                name="code"
                placeholder="Code"
                onChange={handleInputChange}
              />
              <input
                className="input"
                type="text"
                name="serviceType"
                placeholder="Type"
                onChange={handleInputChange}
              />
              <input
                className="input"
                type="text"
                name="imageAddress"
                placeholder="Image Address"
                onChange={handleInputChange}
              />
              <button className="button" onClick={addService}>
                Add Service
              </button>
            </div>
          </>
        ) : (
          <>
            <h2 className="subtitle">Add Device</h2>
            <div className="formGroup">
              <input
                className="input"
                type="text"
                name="id"
                placeholder="Device ID"
                onChange={handleInputChange}
              />
              <input
                className="input"
                type="text"
                name="price"
                placeholder="Price"
                onChange={handleInputChange}
              />
              <input
                className="input"
                type="text"
                name="name"
                placeholder="Device Name"
                onChange={handleInputChange}
              />
              <input
                className="input"
                type="text"
                name="nodeAddress"
                placeholder="Node Address"
                onChange={handleInputChange}
              />
              <input
                className="input"
                type="text"
                name="location"
                placeholder="Location"
                onChange={handleInputChange}
              />
              <button className="button" onClick={addService}>
                Add Device
              </button>
            </div>
          </>
        )}
      </div>

      <div className="section">
        <h2 className="subtitle">
          {selectedSection === "service" ? "Remove Service" : "Remove Device"}
        </h2>
        <div className="formGroup">
          <input
            className="input"
            type="text"
            placeholder="Service/Device ID"
            value={serviceId}
            onChange={(e) => setServiceId(e.target.value)}
          />
          <button className="button" onClick={removeService}>
            Remove {selectedSection === "service" ? "Service" : "Device"}
          </button>
        </div>
      </div>

      <div className="section">
        <h2 className="subtitle">
          {" "}
          {selectedSection === "service"
            ? "Fetch All Services"
            : "Fetch All Devices"}
        </h2>
        <button className="button" onClick={fetchAllServices}>
          Fetch All
        </button>
      </div>

      {allServices.length > 0 && (
        <div className="servicesList">
          <h3 className="subtitle">
            {selectedSection === "service" ? "All Services" : "All Devices"}
          </h3>
          <table className="serviceTable">
            <thead>
              <tr>
                <th>ID</th>
              </tr>
            </thead>
            <tbody>
              {selectedSection === "service" &&
                allServices.map((service, index) => (
                  <React.Fragment key={index}>
                    <tr
                      onClick={() => handleRowClick(index)}
                      className="serviceRow"
                    >
                      <td>{service[0].toString()}</td>
                    </tr>
                    {expandedRow === index && (
                      <tr className="serviceDetails">
                        <td colSpan="1">
                          <div className="serviceDetailsContent">
                            <p>ID: {service[0].toString()}</p>
                            <p>Name: {service[1]}</p>
                            <p>Description: {service[2]}</p>
                            <p>Code: {service[3]}</p>
                            <p>Type: {service[4]}</p>
                            <p>Image: {service[5]}</p>
                          </div>
                        </td>
                      </tr>
                    )}
                  </React.Fragment>
                ))}

              {selectedSection === "device" &&
                allServices.map((service, index) => (
                  <React.Fragment key={index}>
                    <tr
                      onClick={() => handleRowClick(index)}
                      className="serviceRow"
                    >
                      <td>{service[0].toString()}</td>
                    </tr>
                    {expandedRow === index && (
                      <tr className="serviceDetails">
                        <td colSpan="1">
                          <div className="serviceDetailsContent">
                            <p>ID: {service[0].toString()}</p>
                            <p>Price: {service[1].toString()}</p>
                            <p>Name: {service[2]}</p>
                            <p>Node Address: {service[3]}</p>
                            <p>Location: {service[4]}</p>
                          </div>
                        </td>
                      </tr>
                    )}
                  </React.Fragment>
                ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}

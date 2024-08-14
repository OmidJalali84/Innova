// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {ServiceMarket} from "../../src/ServiceMarket.sol";
import {HandlerServiceMarket} from "./HandlerServiceMarket.sol";
import {Test} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";

contract InvariantServiceMarket is StdInvariant, Test {
    HandlerServiceMarket hsm;
    ServiceMarket serviceMarket;

    function setUp() public {
        hsm = new HandlerServiceMarket();
        serviceMarket = hsm.getContract();
        targetContract(address(hsm));
    }

    // function invariant_testServiceMarket() public view {
    //     uint256 counter = serviceMarket.getCounter();
    //     uint256 length = serviceMarket.getServicesLength();
    //     vm.assertEq(counter, length);
    // }
}

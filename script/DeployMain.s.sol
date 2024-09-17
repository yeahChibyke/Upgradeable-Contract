// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {MainV1} from "../src/MainV1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployMain is Script {
    function run() external returns (address) {
        address proxy = deployMain();
        return proxy;
    }

    function deployMain() public returns (address) {
        MainV1 main = new MainV1(); // implementation(logic)
        ERC1967Proxy proxy = new ERC1967Proxy(address(main), "");
        return address(proxy);
    }
}

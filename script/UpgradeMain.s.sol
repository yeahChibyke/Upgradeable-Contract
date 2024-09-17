// SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {MainV1} from "../src/MainV1.sol";
import {MainV2} from "../src/MainV2.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {DevOpsTools} from "Foundry-DevOps/src/DevOpsTools.sol";

contract UpgradeMain is Script {
    function run() external returns (address) {
        address mostRecentlyDeployedProxy = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);

        vm.startBroadcast();
        MainV2 newMain = new MainV2();
        vm.stopBroadcast();
        address proxy = upgradeMain(mostRecentlyDeployedProxy, address(newMain));
        return proxy;
    }

    function upgradeMain(address proxyAddress, address newMain) public returns (address) {
        vm.startBroadcast();
        MainV1 proxy = MainV1(payable(proxyAddress));
        proxy.upgradeToAndCall(address(newMain), "");
        vm.stopBroadcast();
        return address(proxy);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {DeployMain} from "../script/DeployMain.s.sol";
import {UpgradeMain} from "../script/UpgradeMain.s.sol";
import {MainV1} from "../src/MainV1.sol";
import {MainV2} from "../src/MainV2.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployAndUpgradeTest is StdCheats, Test {
    DeployMain deployMain;
    UpgradeMain upgradeMain;
    address public Owner = address(1);

    function setUp() public {
        deployMain = new DeployMain();
        upgradeMain = new UpgradeMain();
    }

    function testMainWorks() public {
        address proxyAddress = deployMain.deployMain();
        uint256 expectedValue = 1;
        assert(expectedValue == MainV1(proxyAddress).version());
    }

    function testDeploymentIsV1() public {
        address proxyAddress = deployMain.deployMain();
        uint256 expectedValue = 1000;
        vm.expectRevert();
        MainV2(proxyAddress).setValue(expectedValue);
    }

    function testUpgradeWorks() public {
        address proxyAddress = deployMain.deployMain();
        MainV2 mv2 = new MainV2();

        vm.prank(MainV1(proxyAddress).owner());
        MainV1(proxyAddress).transferOwnership(msg.sender);

        address proxy = upgradeMain.upgradeMain(proxyAddress, address(mv2));

        uint256 expectedValue = 2;
        assert(expectedValue == MainV2(proxy).version());

        MainV2(proxy).setValue(expectedValue);
        assert(expectedValue == MainV2(proxy).getValue());
    }
}

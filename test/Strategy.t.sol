// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";

// Custom Strategy
import {YeeterStrategy} from "src/YeeterStrategy.sol";

// // Strategy Interface
// import {IStrategy} from "allo/contracts/core/interfaces/IStrategy.sol";

// // Test libraries
import {AlloSetup} from "allo/test/foundry/shared/AlloSetup.sol";
import {RegistrySetupFull} from "allo/test/foundry/shared/RegistrySetup.sol";

// import {EventSetup} from "allo/test/foundry/shared/EventSetup.sol";

import {MockERC20} from "./MockERC20.sol";

contract StrategyTest is Test, AlloSetup, RegistrySetupFull {
    YeeterStrategy strategy;
    MockERC20 internal token;
    address[] internal recipients;

    function setUp() public {
        __RegistrySetupFull();
        __AlloSetup(address(registry()));

        // Create 5 addresses and push them to the recipients array
        for (uint256 i = 0; i < 5; i++) {
            address recipient = makeAddr(string(abi.encodePacked("Recipient", i)));
            recipients.push(recipient);
        }

        token = new MockERC20("New Token", "NT");
        token.mint(address(this), 1000);

        strategy = new YeeterStrategy(address(allo()), "Yeeter");
        uint256 poolId = 400;
        vm.startPrank(address(allo()));
        strategy.initialize(poolId, "");
        vm.stopPrank();
        token.transfer(address(strategy), 1000);
    }

    function test_allocate() public {
        address[] memory recipientIds = new address[](5);
        uint256[] memory amounts = new uint256[](5);

        // Send tokens to the 
        for (uint256 i = 0; i < 5; i++) {
            recipientIds[i] = makeAddr(string(abi.encodePacked("Recipient", i)));
            amounts[i] = 100;
        }

        vm.startPrank(address(this));
        bytes memory data = abi.encode(recipientIds, amounts);
        strategy.allocate(data, address(this));
        vm.stopPrank();

        assertEq(token.balanceOf(address(strategy)), 500);
    }
}

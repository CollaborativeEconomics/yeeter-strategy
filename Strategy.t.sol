// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";

// Custom Strategy
import {Strategy} from "src/Strategy.sol";

// Strategy Interface
import {IStrategy} from "allo/contracts/core/interfaces/IStrategy.sol";

// Test libraries
import {AlloSetup} from "allo/test/foundry/shared/AlloSetup.sol";
import {RegistrySetupFull} from "allo/test/foundry/shared/RegistrySetup.sol";

import {EventSetup} from "allo/test/foundry/shared/EventSetup.sol";

import {ERC20} from "solmate/tokens/ERC20.sol";

contract StrategyTest is Test, EventSetup, AlloSetup, RegistrySetupFull {
    Strategy strategy;
    address internal token;

    function setUp() public {
        __RegistrySetupFull();
        __AlloSetup(address(registry()));

        token = address(new ERC20("New Token", "NT", 18));
        token.mint(address(this), 1000);

        strategy = new Strategy(address(allo()), "Strategy Name");
        token.transfer(address(strategy), 1000);
    }

    function test_allocate() public {
        address[] memory recipientIds = new address[](5);
        uint256[] memory amounts = new uint256[](5);

        // Send tokens to the 
        for (uint256 i = 0; i < 5; i++) {
            recipientIds[i] = address(i);
            amounts[i] = 100;
        }

        vm.startPrank(address(this));
        strategy.allocate(recipientIds, amounts, address(0));
        vm.stopPrank();

        assertEq(token.balanceOf(address(strategy)), 500);
    }
}

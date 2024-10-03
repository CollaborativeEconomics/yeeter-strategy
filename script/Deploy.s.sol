// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from 'forge-std/Script.sol';

import {YeeterStrategy} from "src/YeeterStrategy.sol";

/// @notice A very simple deployment script
contract Deploy is Script {

  /// @notice The main script entrypoint
  /// @return yeeterStrategy The deployed contract
  function run() external returns (YeeterStrategy yeeterStrategy) {
    vm.startBroadcast();
    yeeterStrategy = new YeeterStrategy(address(0), "Greeter");
    vm.stopBroadcast();
  }
}

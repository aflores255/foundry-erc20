// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/FoundryToken.sol";

contract FoundryTokenDeploy is Script {
    function run() external returns(FoundryToken) {
        uint256 initialSupply = 1000000 * 10 ** 18; // 1 million tokens with 18 decimals
        vm.startBroadcast();
        FoundryToken foundryToken = new FoundryToken("Foundry Token","FRY",initialSupply);
        vm.stopBroadcast();
        return foundryToken;
    }
}

// SPDX License-Identifier: MIT

pragma solidity ^0.8.28;    

import "forge-std/Test.sol";
import "../src/FoundryToken.sol";

contract FoundryTokenTest is Test {
    FoundryToken public foundryToken;
    address public owner = vm.addr(1);
    address public user1 = vm.addr(2);
    string public name = "Foundry Token";
    string public symbol = "FRY";
    uint256 public initialSupply = 1000000 * 10 ** 18; // 1 million tokens with 18 decimals

    /**
     * @notice Creates a new instance of the FoundryToken contract.
     */
    function setUp() public {
        vm.startPrank(owner);
        foundryToken = new FoundryToken(name, symbol, initialSupply);
        vm.stopPrank();
    }

    /**
     * @notice Tests the initial supply of the token.
     */
    function testCreatedCorrectly() public view {
        
        uint256 actual = foundryToken.totalSupply();
        string memory actualName = foundryToken.name();
        string memory actualSymbol = foundryToken.symbol();
        assert(actual == initialSupply && keccak256(bytes(actualName)) == keccak256(bytes(name)) && keccak256(bytes(actualSymbol)) == keccak256(bytes(symbol)));    
    }

    /** @notice test burn rate 
    */
    function testSetBurnRateCorrectly() public {
        uint256 burnRate = 100; // 1%
        vm.startPrank(owner);
        foundryToken.setBurnRate(burnRate); // Set burn rate to 1%
        assert(foundryToken.burnRate() == burnRate);     
        vm.stopPrank();
    }

    

}
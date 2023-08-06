// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployOurToken} from "../script/DeployeToken.s.sol";
import {Lamp} from "../src/Lamp.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

contract OurTokenTest is StdCheats, Test {
    uint256 RAJ_STARTING_AMOUNT = 100 ether;

    OurToken public ourToken;
    DeployOurToken public deployer;
    address public deployerAddress;
    address raj;
    address ney;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        raj = makeAddr("raj");
        ney = makeAddr("ney");

        deployerAddress = vm.addr(deployer.deployerKey());
        vm.prank(deployerAddress);
        ourToken.transfer(raj, RAJ_STARTING_AMOUNT);
    }

    // Initial supply
    function testInitialSupply() public {
        assertEq(ourToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testAllowances() public {
        uint256 initialAllowance = 1000;

        // Raj approves Ney to spend tokens on his behalf
        vm.prank(raj);
        ourToken.approve(ney, initialAllowance);
        uint256 transferAmount = 500;

        vm.prank(ney);
        ourToken.transferFrom(raj, ney, transferAmount);
        assertEq(ourToken.balanceOf(ney), transferAmount);
        assertEq(ourToken.balanceOf(raj), RAJ_STARTING_AMOUNT - transferAmount);
    }
}

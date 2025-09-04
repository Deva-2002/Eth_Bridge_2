// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {PolygonBridge} from "src/polygonBC.sol";
import {bCoin} from "src/bCoin.sol";

contract ethBCTest is Test {
    PolygonBridge pb;
    bCoin bc;

    function setUp() public {
        pb = new PolygonBridge();
        bc = new bCoin();
    }

    function test_minting()public{
        
    }

    function test_burning()public{

    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {EthBridge} from "src/ethBC.sol";
import {Coin} from "src/Coin.sol";

contract ethBCTest is Test {
    EthBridge eb;
    Coin cn;

    function setUp() public {
        eb = new EthBridge();
        cn = new Coin();
    }

    function test_lock() public {
        address random = vm.addr(1);
        vm.startPrank(random);
        cn.mint(random, 300);
        cn.approve(address(eb), 100);
        eb.lock(cn, 100);
        uint bal = cn.balanceOf(random);
        vm.stopPrank();
        assertEq(bal, 200);
    }

    function test_unlock() public {
        address random = vm.addr(1);
        vm.startPrank(random);
        cn.mint(random, 300);
        cn.approve(address(eb), 100);
        eb.lock(cn, 100);
        eb.unlock(cn, 50);
        uint bal = cn.balanceOf(random);
        vm.stopPrank();
        assertEq(bal, 250);
    }
}

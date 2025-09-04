// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {ERC20} from "node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract bCoin is ERC20 {

    address bridge;

    constructor() ERC20("bCoin", "BC") {
        bridge=msg.sender;
    }

    function mint(address to, uint amount) external {
        require(msg.sender == bridge, "Only bridge can mint");
        _mint(to, amount);
    }

    function burn(address from, uint amount) external {
        require(msg.sender == bridge, "Only bridge can burn");
        _burn(from, amount);
    }
}

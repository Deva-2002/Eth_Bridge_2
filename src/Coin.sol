// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {ERC20} from "node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Coin is ERC20 {


    constructor() ERC20("Coin", "C") {
    }

    function mint(address to, uint amount) external {
        _mint(to, amount);
    }

    function burn(address from, uint amount) external {
        _burn(from, amount);
    }
}

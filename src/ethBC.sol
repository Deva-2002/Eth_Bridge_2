// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract EthBridge {

    address public owner;
    mapping(address => mapping(address => uint)) public balances;

    event Locked(address indexed user, address indexed token, uint amount);
    event Unlocked(address indexed user, address indexed token, uint amount);

    constructor() {
        owner = msg.sender;
    }

    function lock(IERC20 token, uint amount) external {
        token.transferFrom(msg.sender, address(this), amount);
        balances[msg.sender][address(token)] += amount;
        emit Locked(msg.sender, address(token), amount);
    }

    function unlock(IERC20 token, uint amount) external {
        require(balances[msg.sender][address(token)] >= amount, "Not enough locked");
        balances[msg.sender][address(token)] -= amount;
        token.transfer(msg.sender, amount);
        emit Unlocked(msg.sender, address(token), amount);
    }
}

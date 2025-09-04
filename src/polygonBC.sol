// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./bCoin.sol";

contract PolygonBridge {
    address owner;
    mapping(address=>uint)public balances;

    event Minting(address indexed user,uint amount);
    event Burning(address indexed user,uint amount);

    constructor(){
        owner=msg.sender;
    }

    function minting(bCoin _tokenaddress,uint _amount) public{
        _tokenaddress.mint(msg.sender, _amount);
        balances[msg.sender]+=_amount;
        emit Minting(msg.sender, _amount);
    }

    function burning(bCoin _tokenaddress,uint _amount) public {
        require(_tokenaddress.balanceOf(msg.sender)>=_amount);
        _tokenaddress.burn(msg.sender, _amount);
        balances[msg.sender]-=_amount;
        emit Burning(msg.sender,_amount);
    }
}

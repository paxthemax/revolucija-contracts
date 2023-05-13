// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";

contract MintController is Ownable2Step {
    uint256 public price;

    constructor(uint256 _price) {
        price = _price;
    }
}

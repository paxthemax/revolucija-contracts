// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestERC20 is ERC20 {
    constructor() ERC20("", "") {}

    function mint(address beneficiary, uint256 amount) public {
        _mint(beneficiary, amount);
    }
}

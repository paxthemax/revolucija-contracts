// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import {RandomHash} from "../../lib/RandomHash.sol";

contract RandomHashMock {
    function randomHash(string memory input) public pure returns (uint256) {
        return RandomHash.randomHash(input);
    }
}

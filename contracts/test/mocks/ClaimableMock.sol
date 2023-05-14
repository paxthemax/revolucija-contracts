// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import {IClaimable} from "../../interfaces/IClaimable.sol";

contract ClaimableMock is IClaimable {
    mapping(address => mapping(uint256 => bool)) claimed;

    function claim(uint256 tokenId, address beneficiary) external {
        claimed[beneficiary][tokenId] = true;
    }

    function hasClaimed(address account, uint256 tokenId) public view returns (bool) {
        return claimed[account][tokenId];
    }
}

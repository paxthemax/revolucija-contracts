// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

interface IClaimable {
    /// Claim a token with the given ID and give it to the beneficiary
    /// @param tokenId ID of the token being claimed
    function claim(uint256 tokenId, address beneficiary) external;
}

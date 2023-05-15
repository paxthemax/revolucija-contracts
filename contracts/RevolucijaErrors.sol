// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

contract RevolucijaErrors {
    /// Reverted when not called by mint controller
    /// @param caller caller address
    error NotMintContoller(address caller);

    /// Reverted when claiming to zero address
    error NoClaimToZeroAddress();

    /// Reverted when token ID is already claimed
    /// @param tokenId ID of the token attempted to claim
    error FailedToClaim(uint256 tokenId);

    /// Reverted when token ID is out of claimable range
    /// @param tokenId ID of the token being claimed
    error OutOfRange(uint256 tokenId);

    /// Reverted when the random seed has been set
    error RandomSeedAlreadySet();
}

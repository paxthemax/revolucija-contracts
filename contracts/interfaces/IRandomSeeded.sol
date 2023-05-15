// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

interface IRandomSeeded {
    /// Remit when the random seed has been set
    /// @param val The value of the random seed
    event RandomSeedSet(uint256 val);

    /// Called by an administrator account to compute the random seed
    /// @param input value used to compute the randomness
    function setRandomSeed(uint256 input) external;
}

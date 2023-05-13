// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {ERC721, ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";

import {IClaimable} from "./interfaces/IClaimable.sol";
import {RandomHash} from "./lib/RandomHash.sol";

contract Revolucija is IClaimable, ERC721Enumerable, Ownable2Step {
    string private constant NAME = "Revolucija!";
    string private constant SYMBOL = "REVLC";

    uint256 public constant MAX_CLAIMABLE_TOKEN_ID = 9000;
    uint256 public constant MAX_TOKEN_ID = 10_000;

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

    address public mintController;

    constructor(address _mintController) ERC721(NAME, SYMBOL) Ownable2Step() {
        if (_mintController == address(0)) revert();

        mintController = _mintController;
    }

    modifier onlyMintContoller() {
        if (msg.sender != mintController) revert NotMintContoller(msg.sender);
        _;
    }

    function claim(uint256 tokenId, address beneficiary) external onlyMintContoller {
        if (beneficiary == address(0)) revert NoClaimToZeroAddress();
        if (tokenId >= MAX_CLAIMABLE_TOKEN_ID) revert OutOfRange(tokenId);
        _safeMint(beneficiary, tokenId);
    }
}

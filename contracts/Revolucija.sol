// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {ERC721, ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";

import {IClaimable} from "./interfaces/IClaimable.sol";
import {IRandomSeeded} from "./interfaces/IRandomSeeded.sol";
import {RevolucijaConstants} from "./RevolucijaConstants.sol";
import {RandomHash} from "./lib/RandomHash.sol";
import {RevolucijaErrors} from "./RevolucijaErrors.sol";

contract Revolucija is
    IClaimable,
    IRandomSeeded,
    RevolucijaConstants,
    RevolucijaErrors,
    ERC721Enumerable
{
    string private constant NAME = "Revolucija!";
    string private constant SYMBOL = "REVLC";

    address public mintController;

    uint256 internal randomSeed;

    constructor(address _mintController) ERC721(NAME, SYMBOL) {
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

    function setRandomSeed(uint256 input) external onlyMintContoller {
        if (randomSeed != 0) revert RandomSeedAlreadySet();
        randomSeed = computeRandomSeed(input);

        emit RandomSeedSet(randomSeed);
    }

    function computeRandomSeed(uint256 input) internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encode(
                        input,
                        tx.gasprice,
                        block.number,
                        block.timestamp,
                        block.difficulty,
                        blockhash(block.number - 1),
                        address(this)
                    )
                )
            );
    }
}

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {ERC721, ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";

import {RandomHash} from "./lib/RandomHash.sol";

contract Revolucija is ERC721Enumerable, Ownable2Step {
    string private constant NAME = "Revolucija!";
    string private constant SYMBOL = "REVL";

    error TokenIdOutOfRange(uint256 id);

    uint256 public constant MAX_CLAIMABLE_TOKEN_ID = 9000;
    uint256 public constant MAX_TOKEN_ID = 10_000;

    constructor() ERC721(NAME, SYMBOL) Ownable2Step() {}

    function claim(uint256 tokenId) external {
        if (tokenId >= MAX_CLAIMABLE_TOKEN_ID) revert TokenIdOutOfRange(tokenId);
        _safeMint(msg.sender, tokenId);
    }

    function claimOwner(uint256 tokenId) external onlyOwner {
        if (tokenId >= MAX_TOKEN_ID) revert TokenIdOutOfRange(tokenId);
        _safeMint(msg.sender, tokenId);
    }
}

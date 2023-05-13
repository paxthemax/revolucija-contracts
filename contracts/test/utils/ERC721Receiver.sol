// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import {IERC721Receiver} from "@openzeppelin/contracts/interfaces/IERC721Receiver.sol";

abstract contract ERC721Receiver is IERC721Receiver {
    event Received(address operator, address from, uint256 tokenId, bytes data, uint256 gas);

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes memory data
    ) public override returns (bytes4) {
        emit Received(operator, from, tokenId, data, gasleft());
        return IERC721Receiver.onERC721Received.selector;
    }
}

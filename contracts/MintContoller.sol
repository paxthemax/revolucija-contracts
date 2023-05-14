// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import {IClaimable} from "./interfaces/IClaimable.sol";

contract MintController is Initializable, Ownable2Step {
    using SafeERC20 for IERC20;

    address public paymentToken;
    address public issuedToken;
    uint256 public price;

    function initalize(
        address _issuedToken,
        address _paymentToken,
        uint256 _price
    ) external initializer onlyOwner {
        if (_issuedToken == address(0)) revert();
        if (_paymentToken == address(0)) revert();

        issuedToken = _issuedToken;
        paymentToken = _paymentToken;
        price = _price;
    }

    function buy(uint256 tokenId) external {
        IERC20(paymentToken).safeTransferFrom(msg.sender, address(this), price);
        IClaimable(issuedToken).claim(tokenId, msg.sender);
    }

    function adminClaim(uint256 tokenId) external onlyOwner {
        IClaimable(issuedToken).claim(tokenId, msg.sender);
    }
}

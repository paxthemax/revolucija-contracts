// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import {Test} from "./utils/Test.sol";
import {ERC721Receiver} from "./utils/ERC721Receiver.sol";

import {Revolucija} from "../Revolucija.sol";

contract RevolucijaTest is ERC721Receiver, Test {
    string constant EXPECTED_NAME = "Revolucija!";
    string constant EXPECTED_SYMBOL = "REVL";

    uint256 constant MAX_CLAIMABLE_TOKEN_ID = 9_000;
    uint256 constant MAX_TOKEN_ID = 10_000;

    Revolucija revolucija;

    function setUp() public {
        revolucija = new Revolucija();
    }

    function claimToken(address claimer, uint256 tokenId) private {
        vm.prank(claimer);
        revolucija.claim(tokenId);
        assertEq(revolucija.ownerOf(tokenId), claimer);
        emit log_named_uint("claimed token id", tokenId);
    }

    function claimTokenOwner(uint256 tokenId) private {
        revolucija.claimOwner(tokenId);
        assertEq(revolucija.ownerOf(tokenId), address(this));
        emit log_named_uint("claimedOwner token id", tokenId);
    }

    function testInvariants() public {
        assertEq(revolucija.name(), EXPECTED_NAME);
        assertEq(revolucija.symbol(), EXPECTED_SYMBOL);
        assertEq(revolucija.MAX_CLAIMABLE_TOKEN_ID(), MAX_CLAIMABLE_TOKEN_ID);
        assertEq(revolucija.MAX_TOKEN_ID(), MAX_TOKEN_ID);
    }

    function testOwnership() public {
        Revolucija instance = new Revolucija();
        assertEq(instance.owner(), address(this));
    }

    function testClaim() public {
        try revolucija.claim(MAX_CLAIMABLE_TOKEN_ID) {
            fail("should fail if id out of range");
        } catch {}

        claimToken(address(0xAAAAA), 0);
        claimToken(address(0xAAAAA), 123);
    }

    function testClaimOwner() public {
        vm.prank(address(0xDEADBAD));
        try revolucija.claimOwner(0) {
            fail("should revert if not called by owner");
        } catch {}

        try revolucija.claimOwner(MAX_TOKEN_ID) {
            fail("should revert if token out of total range");
        } catch {}

        claimTokenOwner(0);
        claimTokenOwner(123);
        claimTokenOwner(MAX_CLAIMABLE_TOKEN_ID);
        claimTokenOwner(MAX_CLAIMABLE_TOKEN_ID + 123);
    }
}

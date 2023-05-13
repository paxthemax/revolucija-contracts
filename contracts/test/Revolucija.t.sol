// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import {Test} from "./utils/Test.sol";
import {ERC721Receiver} from "./utils/ERC721Receiver.sol";

import {Revolucija} from "../Revolucija.sol";

contract RevolucijaTest is ERC721Receiver, Test {
    string constant EXPECTED_NAME = "Revolucija!";
    string constant EXPECTED_SYMBOL = "REVLC";

    uint256 constant MAX_CLAIMABLE_TOKEN_ID = 9_000;
    uint256 constant MAX_TOKEN_ID = 10_000;

    Revolucija revolucija;

    function setUp() public {
        // Controller is the test contract:
        revolucija = new Revolucija(address(this));
    }

    function claimToken(uint256 tokenId, address beneficiary) private {
        revolucija.claim(tokenId, beneficiary);
        assertEq(revolucija.ownerOf(tokenId), beneficiary);
        emit log_named_uint("claimed token id", tokenId);
    }

    // function claimTokenOwner(uint256 tokenId) private {
    //     revolucija.claimOwner(tokenId);
    //     assertEq(revolucija.ownerOf(tokenId), address(this));
    //     emit log_named_uint("claimedOwner token id", tokenId);
    // }

    function testInvariants() public {
        assertEq(revolucija.name(), EXPECTED_NAME);
        assertEq(revolucija.symbol(), EXPECTED_SYMBOL);
        assertEq(revolucija.MAX_CLAIMABLE_TOKEN_ID(), MAX_CLAIMABLE_TOKEN_ID);
        assertEq(revolucija.MAX_TOKEN_ID(), MAX_TOKEN_ID);
    }

    function testDeployment() public {
        try new Revolucija(address(0)) {
            fail("should fail if controller is zero address");
        } catch {}

        address controller = address(0xBABA);
        Revolucija instance = new Revolucija(controller);
        assertEq(instance.mintController(), controller);
    }

    function testClaim() public {
        vm.prank(address(0xDEADBEEF));
        try revolucija.claim(0, address(0)) {
            fail("should fail if not called by mint controller");
        } catch {}

        try revolucija.claim(MAX_CLAIMABLE_TOKEN_ID, address(0)) {
            fail("should fail if claiming to address zero");
        } catch {}

        try revolucija.claim(MAX_CLAIMABLE_TOKEN_ID, address(0xAAAAA)) {
            fail("should fail if token id out of range");
        } catch {}

        claimToken(0, address(0xAAAAA));
        claimToken(123, address(0xBBBB));
    }

    // function testClaimOwner() public {
    //     vm.prank(address(0xDEADBAD));
    //     try revolucija.claimOwner(0) {
    //         fail("should revert if not called by owner");
    //     } catch {}

    //     try revolucija.claimOwner(MAX_TOKEN_ID) {
    //         fail("should revert if token out of total range");
    //     } catch {}

    //     claimTokenOwner(0);
    //     claimTokenOwner(123);
    //     claimTokenOwner(MAX_CLAIMABLE_TOKEN_ID);
    //     claimTokenOwner(MAX_CLAIMABLE_TOKEN_ID + 123);
    // }
}

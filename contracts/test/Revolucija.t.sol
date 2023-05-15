// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import {Test} from "./utils/Test.sol";
import {ERC721Receiver} from "./utils/ERC721Receiver.sol";

import {Revolucija} from "../Revolucija.sol";

contract RevolucijaTest is ERC721Receiver, Test {
    string constant EXPECTED_NAME = "Revolucija!";
    string constant EXPECTED_SYMBOL = "REVLC";

    uint256 constant MAX_CLAIMABLE_TOKEN_ID = 10_000;

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

    function testInvariants() public {
        assertEq(revolucija.name(), EXPECTED_NAME);
        assertEq(revolucija.symbol(), EXPECTED_SYMBOL);
    }

    function testDeployment() public {
        try new Revolucija(address(0)) {
            fail("should fail if controller is zero address");
        } catch {}

        address controller = address(0xBABA);
        Revolucija instance = new Revolucija(controller);
        assertEq(instance.controller(), controller);

        emit log("deployed");
    }

    function testSetRandomSeed() public {
        vm.prank(address(0xDEADBEEF));
        try revolucija.setRandomSeed(12345) {
            fail("should fail if not called by controller");
        } catch {}

        revolucija.setRandomSeed(12345);
        assertEq(revolucija.randomSeed(), 12345);

        try revolucija.setRandomSeed(2132) {
            emit log("should fail if seed already set");
        } catch {}
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
}

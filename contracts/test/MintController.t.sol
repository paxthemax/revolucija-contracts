// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import {Test} from "./utils/Test.sol";
import {TestERC20} from "./mocks/TestERC20.sol";
import {ClaimableMock} from "./mocks/ClaimableMock.sol";

import {MintController} from "../MintContoller.sol";

contract MintControllerTest is Test {
    ClaimableMock issuedToken;
    TestERC20 paymentToken;
    MintController mintController;
    uint256 price;

    function setUp() public {
        price = 1 ether;

        issuedToken = new ClaimableMock();
        paymentToken = new TestERC20();
        mintController = new MintController();

        mintController.initalize(address(issuedToken), address(paymentToken), price);
    }

    function testInit() public {
        MintController instance = new MintController();

        vm.prank(address(0xDEADBAD));
        try instance.initalize(address(issuedToken), address(paymentToken), 1 ether) {
            fail("should revert if not called by owner");
        } catch {}

        try instance.initalize(address(0), address(paymentToken), 1 ether) {
            fail("should revert if issued token address zero");
        } catch {}

        try instance.initalize(address(issuedToken), address(0), 1 ether) {
            fail("should revert if payment token address zero");
        } catch {}

        instance.initalize(address(issuedToken), address(paymentToken), 1 ether);
        assertEq(instance.issuedToken(), address(issuedToken));
        assertEq(instance.paymentToken(), address(paymentToken));
        assertEq(instance.price(), price);
        emit log("initialized OK");

        try instance.initalize(address(issuedToken), address(paymentToken), 1 ether) {
            fail("should revert if already initalized");
        } catch {}
    }

    function testBuy() public {
        address claimer;

        claimer = address(0xBADDAD);
        vm.startPrank(claimer);
        paymentToken.mint(claimer, price - 1);
        paymentToken.approve(address(mintController), price - 1);
        try mintController.buy(0) {
            fail("should fail if not enough payment tokens available");
        } catch {}
        vm.stopPrank();

        claimer = address(0xAAAAAA);
        vm.startPrank(claimer);
        paymentToken.mint(claimer, price);
        paymentToken.approve(address(mintController), price);
        mintController.buy(0);
        assertEq(paymentToken.balanceOf(claimer), 0);
        assertTrue(issuedToken.hasClaimed(claimer, 0));
        emit log("purchased token");
    }

    function testAdminClaim() public {
        vm.prank(address(0xDEADBAD));
        try mintController.adminClaim(0) {
            fail("should revert if not called by owner");
        } catch {}

        mintController.adminClaim(123);
        assertTrue(issuedToken.hasClaimed(address(this), 123));
    }
}

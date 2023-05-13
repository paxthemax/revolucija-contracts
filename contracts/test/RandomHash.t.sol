// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import {Test} from "./utils/Test.sol";
import {RandomHashMock} from "./mocks/RandomHashMock.sol";

contract RandomHashTest is RandomHashMock, Test {
    string constant EXPECTED_NAME = "Revolucija!";
    string constant EXPECTED_SYMBOL = "REVL";

    RandomHashMock randomHashMock;

    function setUp() public {
        randomHashMock = new RandomHashMock();
    }

    function testRandomHash() public {
        string[2] memory inputs = ["hello", "there is no spoon"];
        uint256[2] memory results = [
            uint256(0x1c8aff950685c2ed4bc3174f3472287b56d9517b9c948127319a09a7a36deac8),
            uint256(0xfa9cf592f79bfe87d23bdcec6425684d3f130a0573da16473e1fbb62d62c052b)
        ];

        for (uint i = 0; i < inputs.length; i++) {
            uint256 expected = results[i];
            uint256 actual = randomHash(inputs[i]);

            assertEq(expected, actual);
        }
    }
}

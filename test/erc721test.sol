// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/token.sol";

contract TokenTest is Test {
    MyToken public token;

    function setUp() public {
        token = new MyToken();
    }

    function testMint() public {
        token.safeMint(address(0x9560B7e9eB008BeEf9a98Dd262d9ddb3F5F6f9E1));
        assertEq(
            token.balanceOf(
                address(0x9560B7e9eB008BeEf9a98Dd262d9ddb3F5F6f9E1)
            ),
            1
        );
    }

    function testFailNotAdminMint() public {
        vm.prank(address(0));
        token.safeMint(address(0x9560B7e9eB008BeEf9a98Dd262d9ddb3F5F6f9E1));
    }

    function testBatchMint() public {
        address[] memory t = new address[](4);
        t[0] = 0xB4a925BAe55743AcF3Dc65a8de0b9507F0491617;
        t[1] = 0x288071244112050c93389A950d02c9E626D611dD;
        t[2] = 0x288071244112050c93389A950d02c9E626D611dD;
        t[3] = 0x288071244112050c93389A950d02c9E626D611dD;
        token.batchSafeMint(t);
        assertEq(token.balanceOf(address(t[0])), 1);
        assertEq(token.balanceOf(address(t[1])), 3);
    }

    function testGetStat() public {
        token.safeMint(address(0x9560B7e9eB008BeEf9a98Dd262d9ddb3F5F6f9E1));
        assertEq(
            token.balanceOf(
                address(0x9560B7e9eB008BeEf9a98Dd262d9ddb3F5F6f9E1)
            ),
            1
        );
        token.getStat(1);
    }
}

pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/token.sol";

contract TokenAdminrevokeTest is Test {
    MyToken public token;
    address newadmin = address(0x9560B7e9eB008BeEf9a98Dd262d9ddb3F5F6f9E1);

    function setUp() public {
        token = new MyToken();

        token.updateAdmin(newadmin, true);
    }

    function testAddAdmin() public {
        vm.prank(newadmin);
        token.safeMint(address(0x9560B7e9eB008BeEf9a98Dd262d9ddb3F5F6f9E1));
        assertEq(
            token.balanceOf(
                address(0x9560B7e9eB008BeEf9a98Dd262d9ddb3F5F6f9E1)
            ),
            1
        );
    }

    function testFailRevokedAdminMint() public {
        token.updateAdmin(newadmin, false);
        vm.prank(newadmin);
        token.safeMint(address(0x9560B7e9eB008BeEf9a98Dd262d9ddb3F5F6f9E1));
    }
}

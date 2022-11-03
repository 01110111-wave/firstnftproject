pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/token.sol";
import "../src/erc721_groom.sol";
import "../src/erc721_battle.sol";
import "forge-std/console.sol";

contract TokenTest is Test {
    MyToken public token;
    Grooming public groom;
    Battlesys public batt;
    address deployer = 0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84;
    address receiver = 0x14bCbc438b55F39cA8Eae499B887863A07d9E7a4;
    address dummy = 0x9560B7e9eB008BeEf9a98Dd262d9ddb3F5F6f9E1;

    function setUp() public {
        token = new MyToken();
        groom = new Grooming(token);
        batt = new Battlesys(token);
        groom.updateGiver(deployer, true);
        token.updateAdmin(address(groom), true);
        token.updateAdmin(address(batt), true);
    }

    function testGiveShard() public {
        groom.giveShard(deployer, 10);
        assertEq(10, groom.yourBalance());
    }

    function testBatchGiveShard() public {
        address[] memory t = new address[](4);
        t[0] = 0xB4a925BAe55743AcF3Dc65a8de0b9507F0491617;
        t[1] = 0x288071244112050c93389A950d02c9E626D611dD;
        t[2] = 0x288071244112050c93389A950d02c9E626D611dD;
        t[3] = 0x288071244112050c93389A950d02c9E626D611dD;
        groom.batchGiveShard(t, 25);
        vm.prank(t[0]);
        assertEq(groom.yourBalance(), 25);
        vm.prank(t[1]);
        assertEq(groom.yourBalance(), 75);
    }

    function testGrooming() public {
        groom.giveShard(deployer, 10);
        token.safeMint(receiver);
        token.updateAdmin(address(groom), true);
        groom.groom(1, 10);
        assertEq(token.getStat(1).attack, 60);
    }

    function testBattle() public{
        token.safeMint(receiver);
        token.safeMint(receiver);
        vm.prank(receiver);
        batt.hitAndRun(1, 2);
        assertEq(token.getStat(1).hp, 90);
        assertEq(token.getStat(2).hp, 90);
    }
     function testHitToDeath() public{
        token.safeMint(receiver);
        token.safeMint(receiver);
        groom.giveShard(deployer, 100);
        groom.groom(1, 100);
        vm.prank(receiver);
        batt.hitAndRun(1, 2);
        assertEq(token.getStat(1).hp, 90);
        assertEq(token.getStat(2).hp, 0);
    }

}

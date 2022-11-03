pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Itoken.sol";

contract Battlesys {
    Itoken token;

    constructor(Itoken tokenAdd) {
        token = tokenAdd;
    }

    modifier ownerOf(uint256 tokenId) {
        require(token.ownerOf(tokenId) == msg.sender);
        _;
    }

    function hitAndRun(uint256 tokenId, uint256 targetTokenId)
        public
        ownerOf(tokenId)
    {
        token.attackFrom(targetTokenId, tokenId);
        token.attackFrom(tokenId, targetTokenId);
    }
}

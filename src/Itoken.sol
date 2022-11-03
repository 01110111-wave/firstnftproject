pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface Itoken is IERC721 {
    //tokenToStat mapping
    function groom(uint256 tokenId, uint256 amount) external;

    function shield(uint256 tokenId, uint256 amount) external;

    function attackFrom(uint256 tokenId, uint256 targettokenId) external;

    function awake(uint256 tokenId) external;

    function refresh(uint256 tokenId) external;
}

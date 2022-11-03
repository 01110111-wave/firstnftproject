pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Itoken.sol";

contract MyToken is ERC721, Ownable, Itoken {
    constructor() ERC721("MyToken", "MTK") {
        isAdmin[msg.sender] = true;
    }

    struct token {
        uint256 hp;
        uint256 attack;
        uint256 winstreak;
        bool isDormant;
        bool isExhaust;
    }
    mapping(address => bool) isAdmin;
    mapping(uint256 => token) tokenToStat;
    uint256 lastMintedId =0;

    modifier onlyAdmin() {
        require(isAdmin[msg.sender]);
        _;
    }

    function updateAdmin(address giver, bool authority) public onlyOwner {
        isAdmin[giver] = authority;
    }

    function safeMint(address to) public onlyAdmin {
        _safeMint(to, lastMintedId + 1);
        tokenToStat[lastMintedId + 1] = token(100, 10, 0, false, false);
        lastMintedId++;
    }

    function batchSafeMint(address[] calldata to) external onlyAdmin {
        for (uint256 i = 0; i < to.length; i++) {
            safeMint(to[i]);
        }
    }
    function getStat(uint256 tokenId) view public returns(token memory){
        return(tokenToStat[tokenId]);
    }

    function groom(uint256 tokenId, uint256 amount) external onlyAdmin {
        tokenToStat[tokenId].attack += 5 * amount;
    }

    function shield(uint256 tokenId, uint256 amount) external onlyAdmin {
        tokenToStat[tokenId].hp += 10 * amount;
    }

    function attackFrom(uint256 tokenId, uint256 targetTokenId)
        external
        onlyAdmin
    {
        require(
            !tokenToStat[tokenId].isDormant,
            "you attacking token is dormant"
        );
        require(
            !tokenToStat[targetTokenId].isDormant,
            "you attacked token is dormant"
        );
        require(
            !tokenToStat[tokenId].isExhaust,
            "you attacking token is exhaust"
        );
        require(
            !tokenToStat[targetTokenId].isExhaust,
            "you attacked token is exhaust"
        );
        if (tokenToStat[targetTokenId].hp <= tokenToStat[tokenId].attack) {
            //target is death
            tokenToStat[targetTokenId].hp = 0;
            tokenToStat[targetTokenId].winstreak = 0;
            tokenToStat[targetTokenId].isDormant = true;
            tokenToStat[targetTokenId].isExhaust = false;
            tokenToStat[tokenId].winstreak++;
        } else {
            tokenToStat[targetTokenId].hp -= tokenToStat[tokenId].attack;
        }
    }

    function refresh(uint256 tokenId) external onlyAdmin {
        tokenToStat[tokenId].isExhaust = true;
    }

    function awake(uint256 tokenId) external onlyAdmin {
        tokenToStat[tokenId].isDormant = false;
    }
}

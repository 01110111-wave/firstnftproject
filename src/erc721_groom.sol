pragma solidity ^0.8.4;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Itoken.sol";

contract Grooming is Ownable {
    Itoken token;

    mapping(address => bool) isGiver;
    mapping(address => uint256) shardAmout;

    constructor(Itoken tokenAdd) {
        token = tokenAdd;
    }

    modifier onlyGiver() {
        require(isGiver[msg.sender]);
        _;
    }

    function updateGiver(address giver, bool authority) public onlyOwner {
        isGiver[giver] = authority;
    }

    function giveShard(address to, uint8 amount) public onlyGiver {
        shardAmout[to] += amount;
    }

    function batchGiveShard(address[] calldata to, uint8 amount)
        external
        onlyGiver
    {
        for (uint256 i = 0; i < to.length; i++) {
            giveShard(to[i], amount);
        }
    }

    function yourBalance() external view returns (uint256) {
        return shardAmout[msg.sender];
    }

    function groom(uint256 tokenId, uint256 amount) external {
        require(shardAmout[msg.sender] >= amount);
        shardAmout[msg.sender] -= amount;
        token.groom(tokenId, amount);
    }

    function shield(uint256 tokenId, uint256 amount) external {
        require(shardAmout[msg.sender] >= amount);
        shardAmout[msg.sender] -= amount;
        token.shield(tokenId, amount);
    }

    function refresh(uint256 tokenId) external {
        require(shardAmout[msg.sender] >= 1);
        shardAmout[msg.sender] -= 1;
        token.refresh(tokenId);
    }

    function awake(uint256 tokenId) external {
        require(shardAmout[msg.sender] >= 1);
        shardAmout[msg.sender] -= 1;
        token.awake(tokenId);
    }
}

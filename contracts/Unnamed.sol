// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract Unnamed is ERC721Enumerable {
    mapping(uint256 => uint256) private claimedBitMap;
    mapping(uint256 => uint256) private trait;

    event Claimed(address account);

    constructor() ERC721("", "") {
        initialize();
    }

    function initialize() internal {
        for(uint i = 0; i < 100; i++) {
            trait[i] = pseudoRand(i);
            _mint(msg.sender, i);
        }
    }

    function isClaimed(address user) public view returns (bool) {
        uint256 userIndex = uint256(uint160(user));
        uint256 claimedIndex = userIndex / 256;
        uint256 claimedBit = userIndex % 256;
        uint256 userBit = claimedBitMap[claimedIndex];
        uint256 mask = (1 << claimedBit);

        return userBit & mask == mask;
    }

    function setClaimed(address user) internal {
        uint256 userIndex = uint256(uint160(user));
        uint256 claimedIndex = userIndex / 256;
        uint256 claimedBit = userIndex % 256;

        claimedBitMap[claimedIndex] = claimedBitMap[claimedIndex] | (1 << claimedBit);

        emit Claimed(user);
    }

    function pseudoRand(uint256 seed) internal view returns (uint256) {
        return uint256(
            keccak256(
                abi.encodePacked(
                    block.number,
                    block.timestamp,
                    msg.sender,
                    seed
                )
            )
        );
    }

    function mint() public {
        uint256 _tokenId = totalSupply();

        require(_tokenId < 10000, "");
        require(!isClaimed(msg.sender), "");

        setClaimed(msg.sender);
        
        trait[_tokenId] = pseudoRand(_tokenId);

        _mint(msg.sender, _tokenId);
    }
}
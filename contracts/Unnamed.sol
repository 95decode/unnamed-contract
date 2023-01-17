// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract Unnamed is ERC721Enumerable {
    mapping(uint256 => uint256) private trait;

    constructor() ERC721("", "") {
        initialize();
    }

    function initialize() internal {
        for(uint i = 0; i < 100; i++) {
            trait[i] = pseudoRand(i);
            _mint(msg.sender, i);
        }
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
        
        trait[_tokenId] = pseudoRand(_tokenId);

        _mint(msg.sender, _tokenId);
    }
}
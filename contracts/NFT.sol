// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT is ERC721, ERC721URIStorage, Ownable {
    uint256 private _nextTokenId;
    address marketlaceAddress;

    constructor(
        string memory _name,
        string memory _symbol,
        address _marketplaceAddress,
        address initialOwner
    ) ERC721(_name, _symbol) Ownable(initialOwner) {
        marketlaceAddress = _marketplaceAddress;
    }

    function safeMint(
        address to,
        string memory uri
    ) public onlyOwner returns (uint256) {
        _nextTokenId++;
        uint256 tokenId = _nextTokenId;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        return tokenId;
    }

    // The following functions are overrides required by Solidity.

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}

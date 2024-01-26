// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

import "./NFT.sol";

contract Marketplace is Ownable(msg.sender), ReentrancyGuard {
    // store which tokens are owned by which address
    mapping(address => address[]) private tokens;
    // stores token ids of all erc721 contracts
    mapping(address => uint256[]) contractTokenIds;
    // store latest token id of each erc721 contract
    mapping(address => uint256) collectionsOfTokenId;
    // store all the items that are for sale
    mapping(uint256 => MarketItem) public marketItems;

    // store all the addresses of the NFTs collections
    address[] public CollectionAddresses;

    uint public getNFTCount;
    uint256 private _ItemIdsCounter;
    event TokenCreated(address, address);

    struct MarketItem {
        uint256 itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    event MarketItemCreated(
        uint256 indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price
    );

    event Bought(
        uint256 itemId,
        address indexed nft,
        uint256 tokenId,
        uint256 price,
        address indexed seller,
        address indexed buyer
    );

    event MarketItemCancelled(uint256 indexed itemId);

    function createToken(string memory name, string memory symbol) public {
        address _address = address(
            new NFT(name, symbol, address(0), address(this))
        );
        CollectionAddresses.push(_address);
        emit TokenCreated(msg.sender, _address);
    }

    function mint(
        address contractAddress,
        address to,
        string memory uri
    ) public {
        uint256 tokenId = NFT(contractAddress).safeMint(to, uri);
        tokens[to].push(contractAddress);
        contractTokenIds[to].push(tokenId);
        collectionsOfTokenId[contractAddress] = tokenId;
    }

    function batchMint(
        address contractAddress,
        address[] memory addresses,
        string[] memory uris,
        uint256 start,
        uint256 end
    ) public {
        uint256 count = 0;
        for (uint256 i = start; i < end; i++) {
            uint256 tokenId = NFT(contractAddress).safeMint(
                addresses[i],
                uris[i]
            );
            tokens[addresses[i]].push(contractAddress);
            contractTokenIds[addresses[i]].push(tokenId);
            collectionsOfTokenId[addresses[i]] = tokenId;
            count++;
        }
        getNFTCount = count;
    }

    function createMarketItem(
        address nftContractAddress,
        uint256 tokenId,
        uint256 price
    ) public nonReentrant {
        uint256 itemId = _ItemIdsCounter;
        // TODO: check if the token already exists
        marketItems[itemId] = MarketItem(
            itemId,
            nftContractAddress,
            tokenId,
            payable(msg.sender),
            payable(address(0)),
            price,
            false
        );
        _ItemIdsCounter++;
        IERC721(nftContractAddress).transferFrom(
            msg.sender,
            address(this),
            tokenId
        );
        emit MarketItemCreated(
            itemId,
            nftContractAddress,
            tokenId,
            msg.sender,
            address(0),
            price
        );
    }

    function sellMarketItem(uint256 itemId) public payable nonReentrant {
        MarketItem storage item = marketItems[itemId];
        require(
            item.price == msg.value,
            "Please submit the asking price in order to complete the purchase"
        );
        require(item.sold == false, "Item is already sold");

        item.seller.transfer(msg.value);
        item.owner = payable(msg.sender);
        item.sold = true;
        IERC721(item.nftContract).transferFrom(
            address(this),
            msg.sender,
            item.tokenId
        );
        emit Bought(
            itemId,
            item.nftContract,
            item.tokenId,
            item.price,
            item.seller,
            msg.sender
        );
    }

    // Fetch all market items
    function fetchMarketItems(
        uint256 itemId
    ) public view returns (MarketItem memory) {
        return marketItems[itemId];
    }

    // Fetch user's purchased items
    function fetchUserItems(
        address user
    ) public view returns (MarketItem[] memory) {
        address[] memory _tokens = tokens[user];
        MarketItem[] memory items = new MarketItem[](_tokens.length);
        for (uint256 i = 0; i < _ItemIdsCounter; i++) {
            if (marketItems[i].owner == user) {
                items[i] = marketItems[i];
            }
        }
        return items;
    }

    // Cancel market item
    function cancelMarketItem(uint256 itemId) public {
        MarketItem storage item = marketItems[itemId];
        require(
            item.seller == msg.sender,
            "You are not the seller of this item"
        );
        require(item.sold == false, "Item is already sold");

        item.owner = payable(address(0));
        item.sold = false;
        emit MarketItemCancelled(itemId);
    }
}

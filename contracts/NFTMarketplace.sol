// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFTMarketplace is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    IERC20 private paymentToken;

    struct MarketItem {
        uint itemId;
        uint256 tokenId;
        address payable seller;
        uint256 price;
        bool sold;
    }

    mapping(uint256 => MarketItem) private idToMarketItem;

    event MarketItemCreated (
        uint indexed itemId,
        uint256 indexed tokenId,
        address seller,
        uint256 price,
        bool sold
    );

    constructor(address _paymentToken) ERC721("MiArteDigital", "MAD") {
        paymentToken = IERC20(_paymentToken);
    }

    function createMarketItem(uint256 tokenId, uint256 price) public payable {
        require(price > 0, "Price must be at least 1 wei");

        _itemIds.increment();
        uint256 itemId = _itemIds.current();

        idToMarketItem[itemId] = MarketItem(
            itemId,
            tokenId,
            payable(msg.sender),
            price,
            false
        );

        _transfer(msg.sender, address(this), tokenId);
        emit MarketItemCreated(itemId, tokenId, msg.sender, price, false);
    }

    function createSale(uint256 itemId) public payable {
        uint price = idToMarketItem[itemId].price;
        uint tokenId = idToMarketItem[itemId].tokenId;
        require(!idToMarketItem[itemId].sold, "This sale is already finalized");
        require(paymentToken.transferFrom(msg.sender, idToMarketItem[itemId].seller, price), "Failed to transfer payment");

        idToMarketItem[itemId].sold = true;
        _transfer(address(this), msg.sender, tokenId);
        emit MarketItemCreated(itemId, tokenId, idToMarketItem[itemId].seller, price, true);
    }

    // Funciones administrativas

    function updateTokenMetadata(uint256 tokenId, string memory tokenURI) public  {
        _setTokenURI(tokenId, tokenURI);
    }

    // Aquí podrían añadirse más funciones según los requisitos del proyecto, incluyendo la gestión de la comisión, la administración de usuarios, entre otros.
}
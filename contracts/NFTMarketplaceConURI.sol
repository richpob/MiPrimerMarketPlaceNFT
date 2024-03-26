// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract NFTMarketplace is ERC721URIStorage {
    address public admin;
    IERC20 public paymentToken;

    struct Listing {
        uint256 price;
        address seller;
    }

    mapping(uint256 => Listing) public listings;

    event NFTListed(uint256 indexed tokenId, address seller, uint256 price, string uri);
    event NFTPurchased(uint256 indexed tokenId, address seller, address buyer, uint256 price);

    constructor(address _paymentToken, string memory name, string memory symbol) ERC721(name, symbol) {
        admin = msg.sender;
        paymentToken = IERC20(_paymentToken);
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    function listNFT(uint256 tokenId, uint256 price, string memory tokenURI) public {
        require(ownerOf(tokenId) == msg.sender, "Not the owner");
        require(price > 0, "Price must be greater than zero");

        _setTokenURI(tokenId, tokenURI);
        listings[tokenId] = Listing(price, msg.sender);
        emit NFTListed(tokenId, msg.sender, price, tokenURI);
    }

    function buyNFT(uint256 tokenId) public {
        Listing memory listing = listings[tokenId];
        require(listing.price > 0, "NFT not for sale");

        bool success = paymentToken.transferFrom(msg.sender, listing.seller, listing.price);
        require(success, "Payment failed");

        _transfer(listing.seller, msg.sender, tokenId);
        emit NFTPurchased(tokenId, listing.seller, msg.sender, listing.price);

        delete listings[tokenId];
    }

    function updateAdmin(address newAdmin) public onlyAdmin {
        require(newAdmin != address(0), "Invalid address");
        admin = newAdmin;
    }
}

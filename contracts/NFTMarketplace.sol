// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

interface IERC721 {
    function transferFrom(address from, address to, uint256 tokenId) external;
    function ownerOf(uint256 tokenId) external view returns (address);
}
contract NFTMarketplace {
    address public admin;
    IERC20 public paymentToken;
    IERC721 public nftContract;

    struct Listing {
        uint256 price;
        address seller;
    }

    mapping(uint256 => Listing) public listings;

    event NFTListed(uint256 indexed tokenId, address seller, uint256 price);
    event NFTPurchased(uint256 indexed tokenId, address seller, address buyer, uint256 price);

    constructor(address _paymentToken, address _nftContract) {
        admin = msg.sender;
        paymentToken = IERC20(_paymentToken);
        nftContract = IERC721(_nftContract);
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    function listNFT(uint256 tokenId, uint256 price) public {
        require(nftContract.ownerOf(tokenId) == msg.sender, "Not the owner");
        require(price > 0, "Price must be greater than zero");

        listings[tokenId] = Listing(price, msg.sender);
        emit NFTListed(tokenId, msg.sender, price);
    }

    function buyNFT(uint256 tokenId) public {
        Listing memory listing = listings[tokenId];
        require(listing.price > 0, "NFT not for sale");

        bool success = paymentToken.transferFrom(msg.sender, listing.seller, listing.price);
        require(success, "Payment failed");

        nftContract.transferFrom(listing.seller, msg.sender, tokenId);
        emit NFTPurchased(tokenId, listing.seller, msg.sender, listing.price);

        delete listings[tokenId];
    }

    function updateAdmin(address newAdmin) public onlyAdmin {
        require(newAdmin != address(0), "Invalid address");
        admin = newAdmin;
    }
}

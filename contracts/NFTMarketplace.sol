// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract NFTMarketplace is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    IERC20 private paymentToken;

    // Estructura para manejar la venta de NFTs
    struct Sale {
        address seller;
        uint256 price;
        bool isForSale;
    }

    // Mapping de tokenId a su venta
    mapping(uint256 => Sale) public sales;

    event NFTListed(uint256 indexed tokenId, address seller, uint256 price);
    event NFTRemoved(uint256 indexed tokenId);
    event NFTSold(uint256 indexed tokenId, address buyer, uint256 price);

    constructor(address _paymentToken) ERC721("MiArteDigital", "MAD") {
        paymentToken = IERC20(_paymentToken);
    }

    // Listar un NFT para la venta
    function listNFT(uint256 tokenId, uint256 price) public {
        require(ownerOf(tokenId) == msg.sender, "Solo el propietario puede listar el NFT para la venta");
        require(price > 0, "El precio debe ser mayor que 0");

        sales[tokenId] = Sale(msg.sender, price, true);

        emit NFTListed(tokenId, msg.sender, price);
    }

    // Comprar un NFT
    function buyNFT(uint256 tokenId) public {
        Sale memory sale = sales[tokenId];
        require(sale.isForSale, "Este NFT no esta a la venta");

        // Transferir tokens ERC-20 como pago
        require(paymentToken.transferFrom(msg.sender, sale.seller, sale.price), "Pago fallido");

        // Transferir la propiedad del NFT
        _transfer(sale.seller, msg.sender, tokenId);

        // Limpiar el estado de la venta
        sales[tokenId].isForSale = false;

        emit NFTSold(tokenId, msg.sender, sale.price);
    }

    // Funciones de administración de metadatos ERC-721 y otras funcionalidades

    // Actualizar metadatos del token (administradores)
    function updateTokenMetadata(uint256 tokenId, string memory tokenURI) public  {
        _setTokenURI(tokenId, tokenURI);
    }

    // Funciones adicionales para la gestión por parte de los administradores
    // Podrían incluir la modificación de la dirección del token de pago, ajustes en la política de comisiones, etc.

    // Heredar y utilizar las funciones del contrato ERC-721 proporcionado para la acuñación, exhibición y transferencia de propiedad con lógica específica del proyecto.
}

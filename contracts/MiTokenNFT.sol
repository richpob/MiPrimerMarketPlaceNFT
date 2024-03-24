// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MiToken is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    // Estructura para gestionar la exhibición de obras
    struct Exhibicion {
        uint256 tiempoInicio;
        uint256 duracion;
        string galeriaVirtual;
    }

    // Mapping de tokenId a su exhibición
    mapping(uint256 => Exhibicion) public exhibiciones;

    constructor() ERC721("MiArteDigital", "MAD") {}

    // Función para acuñar un nuevo token
    function acunar(address destinatario, string memory tokenURI) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _mint(destinatario, tokenId);
        _setTokenURI(tokenId, tokenURI);
    }

    // Función para establecer la exhibición de una obra
    function exhibirObra(uint256 tokenId, uint256 duracion, string memory galeriaVirtual) public {
        require(ownerOf(tokenId) == msg.sender, "No eres el propietario de la obra");
        exhibiciones[tokenId] = Exhibicion(block.timestamp, duracion, galeriaVirtual);
    }

    // Función para transferir la propiedad sin cambiar el dueño
    function transferirPropiedad(uint256 tokenId, address nuevoPropietario) public {
        require(ownerOf(tokenId) == msg.sender, "No eres el propietario de la obra");
        // Asumimos que transferirPropiedad es similar a permitir a otro usuario administrar el token sin transferir la propiedad completa
        // Esta función necesita una lógica de negocio más detallada dependiendo del caso de uso específico
        approve(nuevoPropietario, tokenId);
    }
}
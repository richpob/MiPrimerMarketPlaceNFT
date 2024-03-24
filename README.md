# Marketplace de NFT en la Testnet de Sepolia

Este repositorio de GitHub contiene los contratos inteligentes en Solidity para un Marketplace descentralizado de NFT, facilitando la compra y venta de NFTs (Tokens No Fungibles) utilizando tokens ERC-20 como medio de intercambio. El proyecto integra los estándares ERC-721 y ERC-20, permitiendo transacciones entre poseedores y compradores de NFT con funcionalidades adicionales para la gestión administrativa y actualización de metadatos.

## Características

- **Compra de NFTs**: Los usuarios pueden comprar NFTs listados en el marketplace usando tokens ERC-20.
- **Comisión en Transacciones**: Implementa una tarifa de comisión para cada transacción de tokens ERC-20.
- **Funciones Administrativas**: Funciones especiales para los administradores del proyecto para gestionar los listados de NFT.
- **Gestión de Metadatos**: Permite a los administradores actualizar metadatos para cada NFT.

## Despliegue

Este proyecto está diseñado para su despliegue en la Testnet de Sepolia de Ethereum a través del IDE de Remix. Sigue los pasos a continuación para el despliegue:

1. **Prerrequisitos**:
   - Asegúrate de tener MetaMask instalado y configurado para la Testnet de Sepolia.
   - Adquiere algo de ETH de testnet de Sepolia para desplegar contratos y realizar transacciones.

2. **Abrir Remix IDE**:
   - Navega a [Remix IDE](https://remix.ethereum.org/).
   - Clona este repositorio o copia directamente el código del contrato inteligente en nuevos archivos de Remix.

3. **Compilación**:
   - En Remix, selecciona el compilador de Solidity.
   - Compila `YoppenTokenModified.sol` y `MiToken.sol`.

4. **Despliegue**:
   - Cambia a la pestaña "Deploy & Run Transactions".
   - Conecta tu MetaMask a Remix.
   - Despliega primero `YoppenTokenModified.sol` para crear el token ERC-20.
   - Despliega `MiToken.sol` para el contrato ERC-721 de NFT.
   - Utiliza las direcciones desplegadas de estos contratos para desplegar el contrato `NFTMarketplace`, pasando las direcciones como parámetros del constructor.

## Interactuando con los Contratos

- **Listar NFTs**: Llama a `listNFT` con el tokenId y el precio.
- **Comprar NFTs**: Usa la función `buyNFT`, asegurándote de haber aprobado la transferencia del token ERC-20.
- **Actualizar Metadatos**: Los administradores pueden actualizar los metadatos de NFT a través de `updateMetadata`.
- **Cancelar Listados**: Los administradores pueden cancelar listados si es necesario.

## Testnet de Sepolia

Desplegar en la Testnet de Sepolia permite probar en un entorno similar al Mainnet de Ethereum sin los costos asociados. Asegúrate de usar ETH de testnet de Sepolia y direcciones para todas las transacciones.

## Enlaces Importantes

- [Documentación de Solidity](https://soliditylang.org/)
- [OpenZeppelin](https://docs.openzeppelin.com/)
- [Testnet de Sepolia de Ethereum](https://sepolia.dev/)

## Contribuciones

¡Las contribuciones son bienvenidas! Por favor, haz un fork del repositorio y envía pull requests con tus mejoras. Asegúrate de seguir las mejores prácticas para el desarrollo en Solidity y adherirte a los estándares de codificación del proyecto.

## Licencia

Este proyecto está licenciado bajo la Licencia MIT - consulta el archivo LICENSE para más detalles.

#Deploy de ERC-20 ERC-721 y MarketPlac2
## ERC-20
  - **URL TX: ** https://sepolia.etherscan.io/tx/0x57a5221322b063492764daf24a7dd930fb80b87e252f39cfb029f58b0bcfa48b
  - **URL ERC-20: ** https://sepolia.etherscan.io/address/0xbe886d3456e8c0113fa79e6a6b7da7c9633ab33b
  - **Contrato validado: ** https://sepolia.etherscan.io/address/0xbe886d3456e8c0113fa79e6a6b7da7c9633ab33b#readContract

## ERC-721
  - **URL TX: ** 
  - **URL ERC-20: ** 
  - **Contrato validado: ** 

 ## Smart Contract Marketplace
  - **URL TX** 
  - **URL ERC-20** 
  - **Contrato validado: ** 

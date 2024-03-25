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

# Codificación y Deployment de ERC-20 ERC-721 y MarketPlace
## Codigo fuente ERC-20
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract YoppenTokenModified is ERC20 {
    uint256 public commissionRate = 100; // Comisión de 1%, asumiendo que 10000 representa el 100%
    address public treasuryAddress;

    constructor(address initialOwner, address _treasuryAddress) ERC20("Yoppen", "YPN")  {
        //transferOwnership(initialOwner);
        _mint(initialOwner, 100000000 * 10 ** decimals());
        treasuryAddress = _treasuryAddress;
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        uint256 commission = (amount * commissionRate) / 10000;
        uint256 amountAfterCommission = amount - commission;

        require(amount == amountAfterCommission + commission, "Transfer amount mismatch");

        _transfer(_msgSender(), treasuryAddress, commission);
        _transfer(_msgSender(), recipient, amountAfterCommission);
        return true;
    }

    // Función para actualizar la dirección del tesoro por el propietario
    function setTreasuryAddress(address _newTreasuryAddress) public  {
        treasuryAddress = _newTreasuryAddress;
    }

    // Función para ajustar la tasa de comisión por el propietario
    function setCommissionRate(uint256 _newRate) public  {
        commissionRate = _newRate;
    }
}
```
## YoppenTokenModified

El contrato inteligente `YoppenTokenModified` se basa en el estándar ERC-20 y está diseñado para implementar un token con funcionalidades adicionales, incluida una comisión en las transferencias y la capacidad de ajustar la dirección del tesoro y la tasa de comisión.

### Características

- **Estándar ERC-20**: Implementa todas las funcionalidades estándar de un token ERC-20.
- **Comisión en Transferencias**: Aplica una comisión del 1% en todas las transferencias, destinada a una dirección de tesorería.
- **Ajustes de Propietario**: Permite al propietario actualizar la dirección de tesorería y ajustar la tasa de comisión.

### Constructor

El constructor del contrato toma dos parámetros:
- `address initialOwner`: La dirección del propietario inicial del token.
- `address _treasuryAddress`: La dirección de la tesorería a la que se enviarán las comisiones.

Al desplegarse, el contrato acuña `100,000,000` tokens (ajustando por el decimal) para el `initialOwner` y establece la dirección de la tesorería.

### Funciones Principales

#### `transfer`

- Sobre escribe la función de transferencia del ERC-20 estándar.
- Calcula y deduce una comisión del 1% del monto de transferencia, enviando la comisión a la dirección de la tesorería.
- Requiere que la suma del monto después de la comisión y la comisión sea igual al monto de transferencia original, asegurando no haya discrepancias en las cantidades transferidas.

#### `setTreasuryAddress`

- Permite al propietario del contrato actualizar la dirección de tesorería.

#### `setCommissionRate`

- Permite al propietario del contrato ajustar la tasa de comisión.

### Uso

Este contrato puede ser utilizado en situaciones donde se requiera aplicar una comisión por transferencia para financiar un proyecto, tesorería, o simplemente redistribuir una parte de las transacciones a una dirección específica. Es flexible en cuanto a la gestión de la dirección de tesorería y la tasa de comisión, permitiendo adaptarse a diferentes necesidades y estrategias.

### Licencia

Este contrato se distribuye bajo la licencia MIT, lo que permite su uso, copia, modificación y distribución libremente para cualquier propósito.

## Deploy ERC-20
- **URL TX:** https://sepolia.etherscan.io/tx/0x2e9cb92d8c9590be50e18a33069409f9d865653406c43967119c400e4e57a981
- **Contrato ERC20:** 0x7d5C9ad68228397286A7872bE580998948c50E27
- **URL ERC-20:** https://sepolia.etherscan.io/address/0x7d5c9ad68228397286a7872be580998948c50e27
- **Contrato validado:** https://sepolia.etherscan.io/address/0x7d5c9ad68228397286a7872be580998948c50e27#code

## Imagenes del despligue
### Saldos de cuentas
**Cuenta original 0x9a9DeE7E3E68175549ca5815671cb3717754D29F** 
![image](https://github.com/richpob/MiPrimerMarketPlaceNFT/assets/133718913/372c5d6d-3447-44d8-96d1-041370be0f8c)

**Traspaso a cuente 0x18D6d8162f22D485320CAeF164d45F59C15f32cB** 
![image](https://github.com/richpob/MiPrimerMarketPlaceNFT/assets/133718913/9550c5fa-d4da-407f-a341-3e7c0ccdd738)

**Comisión por transaccion de Yoppen ERC20**
 - ![image](https://github.com/richpob/MiPrimerMarketPlaceNFT/assets/133718913/e5e9e531-9b4b-4860-af0c-cf5bf4a8a890)

***
## Codigo fuente ERC-721
```solidity
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
```
El código proporcionado define un contrato inteligente `MiToken` que sigue el estándar ERC-721 para tokens no fungibles (NFT) en Ethereum, utilizando Solidity versión ^0.8.0. Este contrato se extiende del contrato `ERC721URIStorage` provisto por OpenZeppelin, lo que permite a cada token tener metadatos asociados accesibles a través de un URI. Aquí tienes una explicación de sus componentes principales:

### SPDX-License-Identifier: MIT

Esta línea indica que el contrato se distribuye bajo la Licencia MIT, una licencia de software libre permisiva.

### Importaciones

- `ERC721URIStorage.sol`: Un contrato de OpenZeppelin que implementa funcionalidades ERC-721, permitiendo además asociar una URL de metadatos con cada token.
- `Counters.sol`: Provee una manera segura de incrementar y decrementar contadores. Aquí se usa para generar identificadores únicos para cada token.

### Contrato `MiToken`

Hereda de `ERC721URIStorage`, indicando que es un token NFT con metadatos URI almacenables.

#### Variables y Estructuras

- `_tokenIdCounter`: Un contador que se utiliza para asignar un ID único a cada NFT acuñado.
- `Exhibicion`: Una estructura que almacena información sobre la exhibición de la obra, incluyendo el inicio, duración y una galería virtual representada por una cadena de texto.

#### Constructor

Inicializa el contrato con un nombre (`MiArteDigital`) y un símbolo (`MAD`) para el token.

#### Funciones

- `acunar`: Permite acuñar un nuevo NFT, asignándole un ID único, transfiriéndolo a un destinatario específico y asociándole una URL de metadatos.
- `exhibirObra`: Asocia una obra (representada por un `tokenId`) con una exhibición específica, registrando su tiempo de inicio, duración y la galería virtual.
- `transferirPropiedad`: Permite transferir la propiedad de un NFT a un nuevo propietario, manteniendo una verificación para asegurar que solo el actual propietario pueda realizar esta acción.

### Seguridad y Gestión

El contrato hace uso de `require` para asegurar que solo el propietario de un token pueda exhibir la obra o transferir la propiedad, protegiendo contra usos no autorizados.

En resumen, `MiToken` es un contrato ERC-721 personalizado que no solo permite la acuñación y transferencia de NFTs sino que también introduce la noción de exhibiciones para obras de arte digitales, asociando metadatos adicionales y gestión de propiedad dentro de un contexto específico de galería virtual.

## Deploy ERC-721
- **URL TX:** https://sepolia.etherscan.io/tx/0x2d335a36a9821d84475e467c95c6ef76a7100ff699b77026968aa2562fcc35ec
- **URL ERC-721:** https://sepolia.etherscan.io/address/0xd69ba0d84d284bac2fae12e0a8430f274398dc6a
- **Contrato validado:** https://sepolia.etherscan.io/address/0xd69ba0d84d284bac2fae12e0a8430f274398dc6a#code
- **Miprimera obra de arte:**
- https://sepolia.etherscan.io/token/0xd69ba0d84d284bac2fae12e0a8430f274398dc6a
- ![image](https://github.com/richpob/MiPrimerMarketPlaceNFT/assets/133718913/1aed619a-9dc9-4559-a6ba-2ebb5d84ecb5)
***
# Market Place
## Codigo fuente de MarketPlaceNFT

```solidity
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
```
El código proporcionado es un contrato inteligente para un mercado de NFT (Tokens No Fungibles) basado en Ethereum, utilizando Solidity versión ^0.8.0. Se apoya en las librerías de OpenZeppelin, una suite reconocida por su seguridad y robustez para el desarrollo de contratos inteligentes. Aquí tienes un desglose de sus componentes principales y su funcionamiento:

### Importaciones

- **ERC721URIStorage**: Extiende la funcionalidad ERC-721 básica con almacenamiento de URI, permitiendo asociar metadatos con cada NFT.
- **IERC20**: Interface del estándar ERC-20, utilizado aquí para manejar transacciones con un token ERC-20 como medio de pago.
- **Ownable**: Un patrón de propiedad que agrega una variable de estado `owner` y modificadores para restringir el acceso a ciertas funciones.
- **Counters**: Proporciona un contador seguro para rastrear el número de items o tokens.

### Estructura y Variables

- **MarketItem**: Estructura para representar un ítem del mercado, conteniendo información esencial como ID del ítem, ID del token, dirección del vendedor, precio y si ya ha sido vendido.
- **_itemIds**: Contador para generar IDs únicos para los ítems del mercado.
- **paymentToken**: Variable para almacenar la dirección del token ERC-20 usado para pagos.

### Constructor

- Establece el token de pago y inicializa el contrato ERC-721 con un nombre y símbolo para los NFTs.

### Funciones Principales

- **createMarketItem**: Permite a los usuarios crear un nuevo ítem de mercado, especificando el ID del token NFT y su precio. Transfiere el NFT al contrato, indicando que está en venta.
- **createSale**: Permite a los compradores comprar un ítem del mercado, transfiriendo el precio en tokens ERC-20 al vendedor y el NFT al comprador. Marca el ítem como vendido.

### Funciones Administrativas

- **updateTokenMetadata**: Permite actualizar el URI de metadatos de un token NFT específico. Esto puede ser usado para modificar la información del NFT después de su creación.

### Eventos

- **MarketItemCreated**: Se emite cada vez que se crea un nuevo ítem de mercado o se finaliza una venta, proporcionando información relevante para su rastreo.

### Notas Adicionales

El contrato incorpora funcionalidades esenciales para un mercado de NFTs, como crear listados de venta y procesar compras. Utiliza tokens ERC-20 como moneda de cambio, lo que agrega flexibilidad en el manejo de pagos. Las funciones administrativas y el evento implementado facilitan la gestión y seguimiento de los ítems del mercado.

## Deploy Smart Contract Marketplace
- **URL TX:** https://sepolia.etherscan.io/tx/0x5d8b87c61ce495fea83c6de6b198b063b7117f1b0bbdc55e0b7b94ddd730a93e
- **URL Smart Contract:** https://sepolia.etherscan.io/address/0xad5bc01b244ffe4404d10ff6772a636e4c295b4d
- **Contrato validado:** https://sepolia.etherscan.io/address/0xad5bc01b244ffe4404d10ff6772a636e4c295b4d#code

### Uso del MArket Place
 - **Desde el ERC721 se aprueba el uso por el token del Smartcontract**
 - ![image](https://github.com/richpob/MiPrimerMarketPlaceNFT/assets/133718913/1e5efb06-5370-4a7f-ad46-ef33ec5ebf24)
 - **Historial de Tx de ERc721**
 - ![image](https://github.com/richpob/MiPrimerMarketPlaceNFT/assets/133718913/9c539468-2c22-4306-901f-38814d6f46e7)
 - 



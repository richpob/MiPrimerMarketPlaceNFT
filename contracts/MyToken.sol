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
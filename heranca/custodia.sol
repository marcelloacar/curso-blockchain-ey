// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import "./owner.sol";
import "./titulo.sol";

// @notice Endereço do contrato na rede Sepolia: 0x7e59c9aa89d0515c33946f45e428889816ee0392

/**
 * @title Custodia
 * @dev Armazena e controla a custodia de vários títulos do owner
 * @author Marcello Acar
 */
contract Custodia is Owner {

  address[] private titulos;

  /**
   * @dev Adiciona um título à custódia
   * @param titulo Endereço do título a ser adicionado
   */
  function adicionaTitulo(address titulo) external onlyOwner {
    titulos.push(titulo);
  }

  /**
   * @dev Retorna a quantidade de títulos na custódia
   */
  function quantidadeTitulos() external view returns (uint256) {
    return titulos.length;
  }

  /**
   * @dev Retorna o endereço de um título na custódia
   * @param index Posição do título na custódia
   */
  function enderecoTitulo(uint256 index) public view returns (address) {
    return titulos[index];
  }

  /**
   * @dev Retorna dados de um título na custódia
   * @param index Posição do título na custódia
   * @return valorNominal, nomeEmissor, dataEmissao
   */
  function detalheTitulo(uint256 index) external view returns (uint256, string memory, uint256) {
    Titulo titulo = Titulo(enderecoTitulo(index));
    return (titulo.valorNominal(), titulo.nomeEmissor(), titulo.dataEmissao());
  }
}

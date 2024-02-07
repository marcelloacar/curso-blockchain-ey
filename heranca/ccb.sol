// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import "./titulo.sol";
import "./owner.sol";

/**
 * @title CCB
 * @dev Implementação de uma Cédula de Crédito Bancário (CCB)
 * @author Marcello Acar
 */
contract CCB is Titulo, Owner {

    string _emissor;
    uint256 immutable _dataEmissao;
    uint256 _valor;
    uint8 immutable _decimais;
    uint256 _prazoPagamento;
    uint16 _fracoes;

    constructor(string memory emissor_) {
        _emissor = emissor_;
        _dataEmissao = block.timestamp;
        _valor = 150000000; // Valor ajustado para a CCB
        _decimais = 2;
        _prazoPagamento = _dataEmissao + 180 days; // Prazo de pagamento ajustado para a CCB
        _fracoes = 500;
        emit NovoPrazoPagamento(_dataEmissao, _prazoPagamento);
    }

    /**
     * @dev Retorna o valor nominal.
     */
    function valorNominal() external view override returns (uint256) {
        return _valor;
    }

    /**
     * @dev Retorna o nome do Emissor.
     */
    function nomeEmissor() external view override returns (string memory) {
        return _emissor;
    }

    /**
     * @dev Retorna a data da emissao.
     */
    function dataEmissao() external view override returns (uint256) {
        return _dataEmissao;
    }

    /**
     * @dev Retorna o número de frações.
     */
    function fracoes() external view returns (uint16) {
        return _fracoes;
    }

    /**
     * @dev Atualiza o número de frações.
     */
    function alteraFracoes(uint16 fracoes_) external onlyOwner returns (bool) {
        require(fracoes_ >= 100, "Numero de fracoes baixo");
        _fracoes = fracoes_;
        return true;
    }
}

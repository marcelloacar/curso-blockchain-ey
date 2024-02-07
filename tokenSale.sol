/*
SPDX-License-Identifier: CC-BY-4.0
(c) Developed by Marcello Acar
This work is licensed under a Creative Commons Attribution 4.0 International License.
*/
pragma solidity 0.8.19;

// @notice exemplo dado em aula
// @author Marcello Acar
// @title Um exemplo de contrato de Faucet
// contract Faucet {

//     mapping(address=>uint8) public atribuicoes;
//     uint8 valorASerAtribuido;

//     event AconteceuUmaAtribuicao(address paraQuem, uint8 quanto);

//     // @notice Fornece a quem chamar a transacao um valor
//     // @dev incrementa um no acumulador e atribuir o valor do acumulador a um endereco ethereum.
//     // @return valor atual do acumulador
//     function atribuirValor() public returns (uint256) {
//         require(atribuicoes[msg.sender]==0, "Sinto muito. Voce ja teve sua chance");
//         require(valorASerAtribuido < 256, "Sinto muito. Voce perdeu sua chance");
//         valorASerAtribuido++;
//         atribuicoes[msg.sender] = valorASerAtribuido;
//         emit AconteceuUmaAtribuicao(msg.sender, valorASerAtribuido);
//         return valorASerAtribuido;
//     }
// }

// @notice Endereço do contrato na rede Sepolia: 0x4975619a899c6f5073e96ac36936babf4d42df82

// @author Marcello Acar
// @title TokenSale - Contrato de venda de tokens
contract TokenSale {
    mapping(address => uint256) public saldosDeTokens;
    address public proprietario;
    uint256 public precoDoToken;
    uint256 public totalDeTokensDisponiveis;

    // @notice Evento emitido quando tokens sao comprados.
    event TokensComprados(address comprador, uint256 quantidade);

    // @notice Modificador para restringir o acesso a apenas o proprietario do contrato.
    modifier apenasProprietario() {
        require(msg.sender == proprietario, "Somente o proprietario pode chamar esta funcao");
        _;
    }

    // @notice Inicializa o contrato com o preco do token e a quantidade total de tokens disponiveis.
    // @dev Este construtor e chamado apenas uma vez durante a implantacao do contrato.
    // @param _precoDoToken O preco de um token em Ether.
    // @param _totalDeTokensDisponiveis A quantidade total de tokens disponiveis para venda.
    constructor(uint256 _precoDoToken, uint256 _totalDeTokensDisponiveis) {
        proprietario = msg.sender;
        precoDoToken = _precoDoToken;
        totalDeTokensDisponiveis = _totalDeTokensDisponiveis;
    }

    // @notice Permite que um comprador compre tokens, atualizando saldos e quantidade total de tokens disponiveis.
    // @dev Esta funcao executa a logica principal de compra de tokens.
    // @param quantidadeDeTokens A quantidade de tokens que o comprador deseja comprar.
    function comprarTokens(uint256 quantidadeDeTokens) external payable {
        // @notice Verifica se o valor em Ether enviado e correto.
        require(msg.value == quantidadeDeTokens * precoDoToken, "Valor Ether incorreto");
        
        // @notice Verifica se ha tokens suficientes disponiveis para compra.
        require(quantidadeDeTokens > 0 && quantidadeDeTokens <= totalDeTokensDisponiveis, "Tokens insuficientes disponiveis");

        // @dev Atualiza o saldo do comprador.
        saldosDeTokens[msg.sender] += quantidadeDeTokens;

        // @dev Atualiza a quantidade total de tokens disponiveis.
        totalDeTokensDisponiveis -= quantidadeDeTokens;

        // @notice Emite o evento de compra.
        emit TokensComprados(msg.sender, quantidadeDeTokens);
    }

    // @notice Permite que o proprietario retire uma quantidade especifica de Ether do contrato.
    // @dev Esta funcao permite que o proprietario retire Ether do contrato.
    // @param quantidade A quantidade de Ether que o proprietario deseja retirar.
    function retirarEther(uint256 quantidade) external apenasProprietario {
        // @notice Verifica se a quantidade de retirada e valida.
        require(quantidade > 0 && quantidade <= address(this).balance, "Quantidade de retirada invalida");

        // @dev Retira o Ether.
        payable(proprietario).transfer(quantidade);
    }
}

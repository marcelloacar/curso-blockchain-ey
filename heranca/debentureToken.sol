
// SPDX-License-Identifier: CC-BY-4.0
pragma solidity 0.8.19;

/**
 * @title Titulo
 * @dev Define funcoes de um titulo
 * @author Marcello Acar
 */
interface Titulo {

    /**
     * @dev Retorna o valor nominal.
     */
    function valorNominal() external view returns (uint256);

    /**
     * @dev Retorna o nome do Emissor.
     */
    function nomeEmissor() external view returns (string memory);

    /**
     * @dev Retorna a data da emissao.
     */
    function dataEmissao() external view returns (uint256);

    /**
     * @dev Emitido quando um novo prazo de pagamento é definido
     */
    event NovoPrazoPagamento(uint256 prazoAntigo, uint256 prazoNovo);

}

/// @title Manages the contract owner
contract Ownable {
    address payable contractOwner;

    modifier onlyOwner() {
        require(msg.sender == contractOwner, "only owner can perform this operation");
        _;
    }

    constructor() { 
        contractOwner = payable(msg.sender); 
    }
    
    function whoIsTheOwner() public view returns(address) {
        return contractOwner;
    }

    function changeOwner(address _newOwner) onlyOwner public returns (bool) {
        require(_newOwner != address(0x0), "only valid address");
        contractOwner = payable(_newOwner);
        return true;
    }
    
}

/**
 * @title DebentureToken
 * @dev Implementação de um token ERC-20 representando uma debênture
 * @author Marcello Acar
 */
contract DebentureToken is Titulo, Ownable {

    string private _emissor;
    uint256 immutable private _dataEmissao;
    uint256 private _valor;
    uint8 immutable private _decimais;
    uint256 private _prazoPagamento;
    uint16 private _fracoes;
    string public rating;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 private _totalSupply;

    constructor(string memory emissor_) {
        _emissor = emissor_;
        _dataEmissao = block.timestamp;
        _valor = 100000000;
        _decimais = 2;
        _prazoPagamento = _dataEmissao + 90 days;
        rating = "BBB-";
        _fracoes = 1000;
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
    * @dev Muda o rating
    * @notice Dependendo da situação econômica, a empresa avaliadora pode mudar o rating
    * @param novoRating Novo rating da debênture
    */
    function mudaRating(string memory novoRating) external onlyOwner returns (bool) {
        rating = novoRating;
        return true;
    }

    function alteraFracoes(uint16 fracoes_) external onlyOwner returns (bool) {
        require(fracoes_ >= 100, "Número de fracoes baixo");
        _fracoes = fracoes_;
        return true;
    }

    /**
    * @dev Retorna o valor da variável fracoes
    * @notice Informa o número de fracoes da debenture
    */
    function fracoes() external view returns (uint16) {
        return _fracoes;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        _transfer(from, to, amount);
        _approve(from, msg.sender, _allowances[from][msg.sender] - amount);
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "Transfer from the zero address");
        require(recipient != address(0), "Transfer to the zero address");
        require(_balances[sender] >= amount, "Insufficient balance");

        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "Mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "Approve from the zero address");
        require(spender != address(0), "Approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}

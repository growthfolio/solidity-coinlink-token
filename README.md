# 🪙 Solidity CoinLink Token - Smart Contract ERC-20

## 🎯 Objetivo de Aprendizado
Projeto desenvolvido para estudar **Solidity** e **smart contracts**, implementando um token ERC-20 completo na blockchain Ethereum com todas as funcionalidades padrão e boas práticas de segurança.

## 🛠️ Tecnologias Utilizadas
- **Linguagem:** Solidity ^0.8.0
- **Padrão:** ERC-20 Token Standard
- **IDE:** Remix Ethereum IDE
- **Blockchain:** Ethereum (Testnet/Mainnet)
- **Ferramentas:** OpenZeppelin, MetaMask
- **Conceitos estudados:**
  - Smart contracts development
  - ERC-20 token standard
  - Solidity syntax e patterns
  - Gas optimization
  - Security best practices
  - Blockchain deployment

## 🚀 Demonstração
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract CoinLinkToken is ERC20, Ownable, Pausable {
    uint256 public constant INITIAL_SUPPLY = 10 * 10**18; // 10 CLNK
    uint256 public constant MAX_SUPPLY = 1000000 * 10**18; // 1M CLNK
    
    mapping(address => bool) public blacklisted;
    
    event Blacklisted(address indexed account);
    event Unblacklisted(address indexed account);
    event TokensMinted(address indexed to, uint256 amount);
    event TokensBurned(address indexed from, uint256 amount);

    constructor() ERC20("CoinLink", "CLNK") {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    modifier notBlacklisted(address account) {
        require(!blacklisted[account], "Account is blacklisted");
        _;
    }

    function transfer(address to, uint256 amount) 
        public 
        override 
        whenNotPaused 
        notBlacklisted(msg.sender) 
        notBlacklisted(to) 
        returns (bool) 
    {
        return super.transfer(to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) 
        public 
        override 
        whenNotPaused 
        notBlacklisted(from) 
        notBlacklisted(to) 
        returns (bool) 
    {
        return super.transferFrom(from, to, amount);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "Exceeds max supply");
        _mint(to, amount);
        emit TokensMinted(to, amount);
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
        emit TokensBurned(msg.sender, amount);
    }

    function blacklist(address account) public onlyOwner {
        blacklisted[account] = true;
        emit Blacklisted(account);
    }

    function unblacklist(address account) public onlyOwner {
        blacklisted[account] = false;
        emit Unblacklisted(account);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
}
```

## 💡 Principais Aprendizados

### 🔗 ERC-20 Token Standard
- **Interface Padrão:** totalSupply, balanceOf, transfer, approve
- **Events:** Transfer, Approval para tracking
- **Allowances:** Sistema de aprovação para terceiros
- **Decimals:** Precisão de 18 casas decimais

### 🛡️ Segurança em Smart Contracts
- **Access Control:** Ownable para funções administrativas
- **Pausable:** Capacidade de pausar operações
- **Blacklist:** Sistema de bloqueio de endereços
- **Overflow Protection:** SafeMath implícito no Solidity 0.8+

### ⛽ Otimização de Gas
- **Storage vs Memory:** Uso eficiente de variáveis
- **Function Modifiers:** Reutilização de validações
- **Events:** Logging eficiente de dados
- **Batch Operations:** Operações em lote quando possível

## 🧠 Conceitos Técnicos Estudados

### 1. **Implementação ERC-20 Completa**
```solidity
interface IERC20Extended {
    // ERC-20 Standard
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    
    // Extended functionality
    function mint(address to, uint256 amount) external;
    function burn(uint256 amount) external;
    function pause() external;
    function unpause() external;
    
    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
```

### 2. **Sistema de Governança**
```solidity
contract TokenGovernance is CoinLinkToken {
    struct Proposal {
        uint256 id;
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 deadline;
        bool executed;
        mapping(address => bool) hasVoted;
    }
    
    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;
    uint256 public constant VOTING_PERIOD = 7 days;
    uint256 public constant QUORUM = 1000 * 10**18; // 1000 CLNK
    
    event ProposalCreated(uint256 indexed proposalId, string description);
    event VoteCast(uint256 indexed proposalId, address indexed voter, bool support, uint256 votes);
    event ProposalExecuted(uint256 indexed proposalId);
    
    function createProposal(string memory description) public {
        require(balanceOf(msg.sender) >= 100 * 10**18, "Insufficient tokens to create proposal");
        
        proposalCount++;
        Proposal storage proposal = proposals[proposalCount];
        proposal.id = proposalCount;
        proposal.description = description;
        proposal.deadline = block.timestamp + VOTING_PERIOD;
        
        emit ProposalCreated(proposalCount, description);
    }
    
    function vote(uint256 proposalId, bool support) public {
        Proposal storage proposal = proposals[proposalId];
        require(block.timestamp <= proposal.deadline, "Voting period ended");
        require(!proposal.hasVoted[msg.sender], "Already voted");
        
        uint256 votes = balanceOf(msg.sender);
        require(votes > 0, "No voting power");
        
        if (support) {
            proposal.votesFor += votes;
        } else {
            proposal.votesAgainst += votes;
        }
        
        proposal.hasVoted[msg.sender] = true;
        emit VoteCast(proposalId, msg.sender, support, votes);
    }
    
    function executeProposal(uint256 proposalId) public {
        Proposal storage proposal = proposals[proposalId];
        require(block.timestamp > proposal.deadline, "Voting period not ended");
        require(!proposal.executed, "Proposal already executed");
        require(proposal.votesFor > proposal.votesAgainst, "Proposal rejected");
        require(proposal.votesFor >= QUORUM, "Quorum not reached");
        
        proposal.executed = true;
        emit ProposalExecuted(proposalId);
        
        // Execute proposal logic here
    }
}
```

### 3. **Staking e Rewards**
```solidity
contract TokenStaking is CoinLinkToken {
    struct StakeInfo {
        uint256 amount;
        uint256 timestamp;
        uint256 rewardDebt;
    }
    
    mapping(address => StakeInfo) public stakes;
    uint256 public totalStaked;
    uint256 public rewardRate = 100; // 1% per year
    uint256 public constant SECONDS_PER_YEAR = 365 * 24 * 60 * 60;
    
    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardsClaimed(address indexed user, uint256 amount);
    
    function stake(uint256 amount) public {
        require(amount > 0, "Cannot stake 0 tokens");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        
        // Claim pending rewards first
        claimRewards();
        
        _transfer(msg.sender, address(this), amount);
        
        stakes[msg.sender].amount += amount;
        stakes[msg.sender].timestamp = block.timestamp;
        totalStaked += amount;
        
        emit Staked(msg.sender, amount);
    }
    
    function unstake(uint256 amount) public {
        require(stakes[msg.sender].amount >= amount, "Insufficient staked amount");
        
        // Claim pending rewards first
        claimRewards();
        
        stakes[msg.sender].amount -= amount;
        totalStaked -= amount;
        
        _transfer(address(this), msg.sender, amount);
        
        emit Unstaked(msg.sender, amount);
    }
    
    function calculateRewards(address user) public view returns (uint256) {
        StakeInfo memory userStake = stakes[user];
        if (userStake.amount == 0) return 0;
        
        uint256 stakingDuration = block.timestamp - userStake.timestamp;
        uint256 rewards = (userStake.amount * rewardRate * stakingDuration) / 
                         (10000 * SECONDS_PER_YEAR);
        
        return rewards;
    }
    
    function claimRewards() public {
        uint256 rewards = calculateRewards(msg.sender);
        if (rewards > 0) {
            stakes[msg.sender].timestamp = block.timestamp;
            _mint(msg.sender, rewards);
            emit RewardsClaimed(msg.sender, rewards);
        }
    }
}
```

## 📁 Estrutura do Projeto
```
solidity-coinlink-token/
├── contracts/
│   ├── CoinLinkToken.sol      # Contrato principal
│   ├── TokenGovernance.sol    # Sistema de governança
│   ├── TokenStaking.sol       # Sistema de staking
│   └── interfaces/
│       └── IERC20Extended.sol # Interface estendida
├── nft/                       # NFTs relacionados
├── nft-pokemon/              # Coleção NFT Pokemon
├── scripts/
│   ├── deploy.js             # Script de deploy
│   └── interact.js           # Script de interação
├── test/
│   └── CoinLinkToken.test.js # Testes unitários
└── migrations/               # Migrações Truffle
```

## 🔧 Como Executar

### Remix IDE (Recomendado)
```solidity
// 1. Acesse https://remix.ethereum.org/
// 2. Crie novo arquivo CoinLinkToken.sol
// 3. Cole o código do contrato
// 4. Compile com Solidity 0.8.0+
// 5. Deploy na rede desejada
```

### Hardhat/Truffle
```bash
# Clone o repositório
git clone <repo-url>
cd solidity-coinlink-token

# Instale dependências
npm install

# Compile contratos
npx hardhat compile

# Execute testes
npx hardhat test

# Deploy local
npx hardhat run scripts/deploy.js --network localhost

# Deploy testnet
npx hardhat run scripts/deploy.js --network goerli
```

## 🎯 Características do Token

### Especificações Técnicas
- **Nome:** CoinLink
- **Símbolo:** CLNK
- **Decimais:** 18
- **Supply Inicial:** 10 CLNK
- **Max Supply:** 1,000,000 CLNK
- **Mintable:** Sim (apenas owner)
- **Burnable:** Sim
- **Pausable:** Sim

### Funcionalidades Avançadas
- ✅ **Blacklist System:** Bloqueio de endereços maliciosos
- ✅ **Pause Mechanism:** Pausar transferências em emergências
- ✅ **Mint Control:** Emissão controlada pelo owner
- ✅ **Burn Function:** Queima de tokens para deflação
- ✅ **Event Logging:** Rastreamento completo de operações

## 🚧 Desafios Enfrentados
1. **Solidity Syntax:** Aprender sintaxe e padrões da linguagem
2. **Gas Optimization:** Otimizar custos de transação
3. **Security Patterns:** Implementar práticas seguras
4. **ERC-20 Compliance:** Seguir padrão corretamente
5. **Testing:** Criar testes abrangentes
6. **Deployment:** Deploy em diferentes redes

## 📚 Recursos Utilizados
- [Solidity Documentation](https://docs.soliditylang.org/)
- [OpenZeppelin Contracts](https://openzeppelin.com/contracts/)
- [ERC-20 Token Standard](https://eips.ethereum.org/EIPS/eip-20)
- [Remix IDE](https://remix.ethereum.org/)
- [Ethereum Developer Resources](https://ethereum.org/developers/)

## 📈 Próximos Passos
- [ ] Implementar sistema de governança DAO
- [ ] Adicionar funcionalidades de staking
- [ ] Criar bridge para outras blockchains
- [ ] Implementar vesting schedule
- [ ] Adicionar funcionalidades DeFi
- [ ] Criar interface web para interação

## 🔗 Projetos Relacionados
- [JS Wallet Generator](../js-wallet-generator/) - Geração de carteiras
- [CryptoTool](../CryptoTool/) - Ferramentas crypto
- [Go PriceGuard API](../go-priceguard-api/) - API para crypto

---

**Desenvolvido por:** Felipe Macedo  
**Contato:** contato.dev.macedo@gmail.com  
**GitHub:** [FelipeMacedo](https://github.com/felipemacedo1)  
**LinkedIn:** [felipemacedo1](https://linkedin.com/in/felipemacedo1)

> 💡 **Reflexão:** Este projeto foi minha introdução ao mundo dos smart contracts. Desenvolver um token ERC-20 completo me ensinou os fundamentos de Solidity e as complexidades da programação blockchain.
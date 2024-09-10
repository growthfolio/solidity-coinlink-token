# CoinLink Token - ERC-20 Token

Este projeto implementa um token ERC-20 chamado **CoinLink** (símbolo: CLNK) como parte da atividade do curso de **Introdução ao Solidity**, utilizando a IDE **Remix**. O token segue o padrão ERC-20, o que permite sua interoperabilidade com carteiras e exchanges que suportam tokens baseados na rede Ethereum.

## Características do CoinLink

- **Nome**: CoinLink
- **Símbolo**: CLNK
- **Casas Decimais**: 18
- **Suprimento Total**: 10 CLNK (10 * 10^18 em termos de wei)

## Funcionalidades Implementadas

O contrato do token implementa as principais funcionalidades do padrão ERC-20:

- **totalSupply**: Retorna o suprimento total de tokens emitidos.
- **balanceOf**: Retorna o saldo de um determinado endereço.
- **allowance**: Verifica a quantidade que um `spender` pode gastar em nome de um `owner`.
- **transfer**: Permite transferir tokens diretamente de uma conta para outra.
- **approve**: Aprova um endereço para gastar tokens em nome do dono.
- **transferFrom**: Permite transferir tokens de uma conta para outra usando a alocação permitida com `approve`.
- **Eventos**:
  - `Transfer`: Disparado sempre que uma transferência de tokens ocorre.
  - `Approval`: Disparado sempre que um gasto é aprovado via `approve`.

## Como usar o CoinLink Token

### 1. Implementação na IDE Remix

Siga os seguintes passos para compilar e interagir com o contrato CoinLink Token:

1. Acesse [Remix IDE](https://remix.ethereum.org/).
2. Crie um novo arquivo `CoinLinkToken.sol` e copie o código do contrato fornecido.
3. Compile o contrato selecionando a versão do Solidity `0.8.0` ou superior.
4. Use a interface do Remix para interagir com as funções do contrato, como `transfer`, `balanceOf`, `approve`, e outras.

---

Este token foi criado como uma atividade prática do curso **Introdução ao Solidity**, com o objetivo de entender o funcionamento dos contratos inteligentes e o padrão ERC-20.

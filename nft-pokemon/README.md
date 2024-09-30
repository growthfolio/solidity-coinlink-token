
# Pokemon NFT Game

This project implements an NFT-based Pokémon battle game on the Ethereum blockchain. Each Pokémon is represented as an ERC721 token (NFT), and players can battle their Pokémon to increase their levels. The project leverages several blockchain development tools such as Remix IDE, Ganache, MetaMask, and IPFS.

## Features

- **Create New Pokémon**: The game owner can create new Pokémon by specifying their name and an image URL. Each Pokémon starts at level 1.
- **Battle Mechanism**: Pokémon can battle with each other. Depending on the outcome of the battle, their levels will increase.
- **Ownership Mechanism**: Only the owner of a specific Pokémon can initiate a battle involving that Pokémon.

## Tools Used

- **Solidity**: Programming language used for developing the smart contract.
- **Remix IDE**: Browser-based IDE used for writing, deploying, and testing the smart contract.
- **Ganache**: Local Ethereum blockchain used for development and testing.
- **MetaMask**: Browser extension used to interact with the blockchain and sign transactions.
- **IPFS**: Decentralized storage system for storing the Pokémon images.

## Smart Contract

The smart contract follows the ERC721 standard provided by OpenZeppelin, which allows each Pokémon to be represented as a unique token.

### Key Components

- **Struct Pokemon**: Represents a Pokémon with a name, level, and image.
  
  ```solidity
  struct Pokemon {
      string name;
      uint level;
      string img;
  }
  ```

- **Modifiers**: Includes the `onlyOwnerOf` modifier to ensure that only the owner of a Pokémon can initiate a battle with it.

  ```solidity
  modifier onlyOwnerOf(uint _monsterId) {
      require(ownerOf(_monsterId) == msg.sender, "Apenas o dono pode batalhar com este Pokemon");
      _;
  }
  ```

- **Functions**:
  - `createNewPokemon`: Allows the game owner to create new Pokémon and mint them as NFTs.
  - `battle`: Allows a player to battle their Pokémon against another Pokémon. The winning Pokémon gains more experience.

### Contract Code

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Pokemon is ERC721 {
    struct Pokemon {
        string name;
        uint level;
        string img;
    }

    Pokemon[] public pokemons;
    address public gameOwner;

    constructor () ERC721 ("Pokemon", "PKD") {
        gameOwner = msg.sender;
    }

    modifier onlyOwnerOf(uint _monsterId) {
        require(ownerOf(_monsterId) == msg.sender, "Apenas o dono pode batalhar com este Pokemon");
        _;
    }

    function battle(uint _attackingPokemon, uint _defendingPokemon) public onlyOwnerOf(_attackingPokemon) {
        Pokemon storage attacker = pokemons[_attackingPokemon];
        Pokemon storage defender = pokemons[_defendingPokemon];

        if (attacker.level >= defender.level) {
            attacker.level += 2;
            defender.level += 1;
        } else {
            attacker.level += 1;
            defender.level += 2;
        }
    }

    function createNewPokemon(string memory _name, address _to, string memory _img) public {
        require(msg.sender == gameOwner, "Apenas o dono do jogo pode criar novos Pokemons");
        uint id = pokemons.length;
        pokemons.push(Pokemon(_name, 1, _img));
        _safeMint(_to, id);
    }
}
```

## How to Deploy and Run

### Prerequisites

1. **Node.js**: Ensure that you have Node.js installed to use tools like `npm`.
2. **Remix IDE**: Use [Remix](https://remix.ethereum.org/) to write, compile, and deploy the contract.
3. **Ganache**: Download and set up [Ganache](https://trufflesuite.com/ganache/) to simulate a local Ethereum blockchain for testing.
4. **MetaMask**: Install the [MetaMask](https://metamask.io/) browser extension for interacting with the deployed contract.

### Steps

1. **Compile the Contract**:
   - Open [Remix IDE](https://remix.ethereum.org/).
   - Paste the contract code into a new file.
   - Compile the contract using Solidity version `^0.8.0`.

2. **Deploy the Contract**:
   - Set up Ganache and connect Remix to the local blockchain using the injected Web3 environment (MetaMask).
   - Deploy the contract from the Remix interface.

3. **Interact with the Contract**:
   - Once deployed, you can interact with the contract directly through the Remix interface or by creating a front-end.
   - Use MetaMask to send transactions and perform actions like creating new Pokémon or battling with them.

4. **Use IPFS for Image Storage**:
   - Upload Pokémon images to IPFS.
   - Store the IPFS URL of the image in the contract when creating a new Pokémon.

## Future Enhancements

- Add more battle mechanics such as attack types and weaknesses.
- Implement a marketplace for trading Pokémon.
- Add more metadata to each Pokémon, such as health points (HP) and special abilities.
- Develop a front-end using React or another JavaScript framework to allow easier interaction with the smart contract.

<!-- ## License

This project is licensed under the terms of the GPL-3.0 license. -->

# Pokemon NFT Game

This project implements a Pokémon battle game based on NFTs on the Ethereum blockchain. Each Pokémon is represented as a unique ERC721 token, and players can create new Pokémon and battle to increase their levels. The project uses smart contracts developed in Solidity and several Web3 tools, such as IPFS to store Pokémon images, MetaMask to interact with the blockchain, and Ganache to simulate local transactions on the Ethereum network.

## Improvements Implemented

1. **Limited Creation of New Pokémon**: Players can now create up to 3 Pokémon each. The game owner can continue creating unlimited Pokémon.
2. **Enhanced Battle Mechanics**: The battle mechanics have been improved to include attack, defense, and Pokémon types. Battles now take these factors into account to determine the outcome.
3. **IPFS Integration**: Pokémon images are stored on IPFS, and only the IPFS CID is stored in the contract, making the storage decentralized and efficient.
4. **Basic Marketplace**: Players can now list their Pokémon for sale, and other players can purchase them using Ether.
5. **Enhanced Security**: The contract now uses the `ReentrancyGuard` security standard to protect against reentrancy attacks.

## Features

- **Create New Pokémon**: The game owner or players (with a limit of 3 per user) can create new Pokémon, specifying name, image (via IPFS), attack, defense, and type.
- **Battle**: Pokémon can battle against each other, and the winners gain level points.
- **Buy and Sell Pokémon**: Players can list their Pokémon for sale, and other players can purchase them with Ether.

## Tools Used

- **Solidity**: The programming language used to develop the smart contract.
- **Remix IDE**: A browser-based IDE used to write, compile, and deploy the contract.
- **Ganache**: Local Ethereum blockchain used for development and testing.
- **MetaMask**: Browser extension used to interact with the blockchain and sign transactions.
- **IPFS**: Decentralized storage system used to store Pokémon images.

## Contract Code

The smart contract follows the ERC721 standard provided by OpenZeppelin, allowing each Pokémon to be represented as a unique token.

### Key Components

- **Pokemon Struct**: Each Pokémon has a name, level, attack, defense, type, and an image stored on IPFS.
  
  ```solidity
  struct Pokemon {
      string name;
      uint level;
      uint attack;
      uint defense;
      string pokemonType;
      string imgCid; // IPFS CID for the Pokemon image
  }
  ```

- **Battle Mechanics**: Pokémon can battle against each other, taking into account attack, defense, and types.

- **Marketplace**: Players can buy and sell Pokémon.

- **Events**: Events are emitted whenever a Pokémon is created or a battle occurs.

## How to Deploy and Run

### Prerequisites

1. **Node.js**: Ensure Node.js is installed to use tools like `npm`.
2. **Remix IDE**: Use [Remix](https://remix.ethereum.org/) to write, compile, and deploy the contract.
3. **Ganache**: Download and set up [Ganache](https://trufflesuite.com/ganache/) to simulate a local Ethereum blockchain.
4. **MetaMask**: Install the [MetaMask](https://metamask.io/) browser extension to interact with the deployed contract.

### Steps

1. **Compile the Contract**:
   - Open [Remix IDE](https://remix.ethereum.org/).
   - Paste the contract code into a new file.
   - Compile the contract using Solidity version `^0.8.0`.

2. **Deploy the Contract**:
   - Set up Ganache and connect Remix to the local blockchain using the injected Web3 environment (MetaMask).
   - Deploy the contract from the Remix interface.

3. **Interact with the Contract**:
   - Once deployed, you can interact with the contract directly through the Remix interface or via a front-end application.
   - Use MetaMask to send transactions and perform actions like creating new Pokémon or battling.

4. **Use IPFS to Store Images**:
   - Upload the Pokémon images to IPFS.
   - Store the returned CID in the contract when creating new Pokémon.

## Future Improvements

- Add more battle mechanics, such as attack types and weaknesses.
- Implement a more robust marketplace to allow for Pokémon auctions and trades.
- Add a front-end interface to make interaction with the smart contract easier.

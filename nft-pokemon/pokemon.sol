
// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Pokemon is ERC721, ReentrancyGuard {

    struct Pokemon {
        string name;
        uint level;
        uint attack;
        uint defense;
        string pokemonType;
        string imgCid; 
    }

    Pokemon[] public pokemons;
    address public gameOwner;
    mapping(address => uint) public playerPokemonCount;
    mapping(uint => uint) public pokemonPrices;

    event PokemonCreated(address owner, uint pokemonId, string name);
    event BattleResult(uint attackerId, uint defenderId, bool attackerWon);

    constructor () ERC721 ("Pokemon", "PKD") {
        gameOwner = msg.sender;
    }

    modifier onlyOwnerOf(uint _monsterId) {
        require(ownerOf(_monsterId) == msg.sender, "Apenas o dono pode batalhar com este Pokemon");
        _;
    }

    function battle(uint _attackingPokemon, uint _defendingPokemon) public onlyOwnerOf(_attackingPokemon) nonReentrant {
        Pokemon storage attacker = pokemons[_attackingPokemon];
        Pokemon storage defender = pokemons[_defendingPokemon];

        uint attackPower = attacker.attack - defender.defense;
        uint defensePower = defender.attack - attacker.defense;

        bool attackerWon = attackPower >= defensePower;
        if (attackerWon) {
            attacker.level += 2;
            defender.level += 1;
        } else {
            attacker.level += 1;
            defender.level += 2;
        }

        emit BattleResult(_attackingPokemon, _defendingPokemon, attackerWon);
    }

    function createNewPokemon(string memory _name, address _to, string memory _imgCid, uint _attack, uint _defense, string memory _type) public {
        require(msg.sender == gameOwner || playerPokemonCount[msg.sender] < 3, "Limite de Pokemons atingido");
        uint id = pokemons.length;
        pokemons.push(Pokemon(_name, 1, _attack, _defense, _type, _imgCid));
        _safeMint(_to, id);
        playerPokemonCount[_to]++;
        emit PokemonCreated(_to, id, _name);
    }

    function listPokemonForSale(uint _pokemonId, uint _price) public onlyOwnerOf(_pokemonId) {
        pokemonPrices[_pokemonId] = _price;
    }

    function buyPokemon(uint _pokemonId) public payable nonReentrant {
        uint price = pokemonPrices[_pokemonId];
        address owner = ownerOf(_pokemonId);
        require(msg.value >= price, "Ether insuficiente para comprar o Pokemon");

        _transfer(owner, msg.sender, _pokemonId);
        payable(owner).transfer(msg.value);
        pokemonPrices[_pokemonId] = 0; // Remove o Pokemon da venda
    }
}
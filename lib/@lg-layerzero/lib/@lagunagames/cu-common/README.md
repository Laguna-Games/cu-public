# Crypto Unicorns Common Smart Contracts
Shared smart contracts for Crypto Unicorns

---

## Setup

1. Install [Foundry](https://book.getfoundry.sh/getting-started/installation):
2. Install project dependencies: `forge install`
3. Make a copy of [dotenv.example](dotenv.example) and rename it to `.env`
   1. Edit [.env](.env)
   2. Fill in the `PRIVATE_KEY` for a deploy wallet (ex. the pkey for `0x513cC39E4782A2df83f6fC8998D11E0c1CA29ACb`)
   3. Fill in any API keys for Etherscan, Polygonscan, Arbiscan, etc.
4. Compile and test the project: `forge test`


---

## Docs

[docs/src/SUMMARY.md](docs/src/SUMMARY.md)

---

## Build
```shell
$ forge build
```

## Test
```shell
$ forge test
```

```
$ forge coverage --via-ir
```

## Deploy
Deploy and configure the diamond.

```shell
$ forge script script/Gogogo.s.sol --chain-id 421614 --rpc-url https://sepolia-rollup.arbitrum.io/rpc --broadcast --verify
```

```shell
$ forge doc
```

---

## Help
Foundry consists of:
-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

> [https://book.getfoundry.sh/](https://book.getfoundry.sh/)

```shell
$ forge --help
$ anvil --help
$ cast --help
$ chisel --help
```

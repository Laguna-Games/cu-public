# Laguna Games Diamond Template
Reference implementation for LG's ERC-2535 "Diamond" smart contracts

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
Compile the smart contracts.

```shell
$ forge build
```

## Test
Run unit tests.

```shell
$ forge test
```

## Deploy
Deploy and configure the diamond.

```shell
$ forge script script/Gogogo.s.sol --chain-id 421614 --rpc-url https://sepolia-rollup.arbitrum.io/rpc --broadcast --verify
```

Common facets can be shared between diamonds by specifying the facet addresses in .env:

```shell
# PRE-DEPLOYED FACETS - Arbitrum Sepolia chainId 421614
DIAMOND_CUT_FACET="0x7e2765d3D9ed15E8745320b729c666dAE71a19bb"
DIAMOND_LOUPE_FACET="0x2cA844b96c3Ef044C626d2D30b2FcbD675EA30DC"
DIAMOND_PROXY_FACET="0xCe53e97461401D7c34a72b1555A4904Fb5c97e88"
DIAMOND_OWNER_FACET="0x48420aeE07a3728ABF872958Dc011965E5B56291"
SUPPORTS_INTERFACE_FACET="0x630457Db4D186df9A58b50070039e913df58aB04"
DUMMY_INTERFACE_CONTRACT="0xAefB304AA342586DEC338a344AaDc21bc6468528"
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

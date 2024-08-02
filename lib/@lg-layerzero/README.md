# LayerZero Integration
Common contracts and utilities for the LayerZero integration.

---

## New Repo Setup
1. Click `Use this template` > `Create a new repository`
2. Name the new repo with the prefix `cu-bcv2-`
3. Configure `Settings` > `Collaborators and teams`
   1. Admin `fvidal-lg`
   2. Admin `Rob-lg`
   3. Write `@Laguna-Games/cu-solidity-team`
4. Configure `Branches`, add a new Branch Protection Rule
   - Branch name pattern `develop`
   - Require a pull request before merging
      - Require approvals
      - Require review from Code Owners
    - Require status checks to pass before merging
    - Require branches to be up to date before merging
5. Checkout the new repo

To load dependencies: 
```shell
git submodule update --init --recursive
```

To reinstall dependencies:
```shell
forge install foundry-rs/forge-std

forge install @lagunagames/cu-common=github.com/Laguna-Games/cu-bcv2-common.git

forge install @openzeppelin=OpenZeppelin/openzeppelin-contracts@v4.9.3

forge install @layerzerolabs/solidity-examples=Laguna-Games/LayerZero-solidity-examples

forge remappings
```

---

## Project Setup
1. Install [Foundry](https://book.getfoundry.sh/getting-started/installation)
2. Make a copy of [dotenv.example](dotenv.example) and rename it to `.env`
   1. Edit [.env](.env)
   2. Fill in the `PRIVATE_KEY` for a deploy wallet (ex. the pkey for `0x513cC39E4782A2df83f6fC8998D11E0c1CA29ACb`)
   3. Fill in any API keys for Etherscan, Polygonscan, Arbiscan, etc.
3. Compile and test the project: `forge test`

---

## Docs
[docs/src/SUMMARY.md](docs/src/SUMMARY.md)

---

## Build
```shell
$ forge build
```

```shell
$ forge doc
```

## Test
```shell
$ forge test
```

```shell
$ forge coverage --via-ir
```

---

## Deploy
Deploy and configure the diamond.

```shell
$ source .env

$ forge script script/Gogogo.s.sol --chain-id 47279324479 --rpc-url https://testnet.xai-chain.net/rpc --broadcast --verify --verifier blockscout --verifier-url https://testnet-explorer.xai-chain.net/api
```

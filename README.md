# ZKcandy Harhat Deployment Workbench

This repo will set up a workbench to deploy Solidity contracts to the ZKcandy Mainnet and Testnet. It uses tooling and scaffolding from [Hardhat](https://hardhat.org/) and [zksync-cli](https://github.com/matter-labs/zksync-cli). For more information pertaining to syntax and/or commands related to the aforementioned projects, please consult their respective documentation(s).

## Project Layout

- `/contracts`: Contains example solidity smart contracts.
- `/deploy`: Scripts for contract deployment and interaction.
- `/test`: Test files.
- `hardhat.config.ts`: Configuration settings.

## How to Use

- `npm run compile`: Compiles contracts.
- `npm run deploy`: Deploys using script `/deploy/deploy.ts`.
- `npm run interact`: Interacts with the deployed contract using `/deploy/interact.ts`.
- `npm run test`: Tests the contracts.

Note: Both `npm run deploy` and `npm run interact` are set in the `package.json`. You can also run your files directly, for example: `npx hardhat deploy-zksync --script deploy.ts`

### Environment Settings

To keep private keys safe, this project pulls in environment variables from `.env` files. Primarily, it fetches the wallet's private key.

Rename `.env.example` to `.env` and fill in your private key:

```
WALLET_PRIVATE_KEY=your_private_key_here...
```

This repo already has both `.env.example` and `.env` added to the `.gitignore` list. However, be mindful when sharing access to your local copy of this repo and/or your working folder in order to prevent exposing your wallet private key.

### Network Support

`hardhat.config.ts` comes with a list of networks to deploy and test contracts. Add more by adjusting the `networks` section in the `hardhat.config.ts`. To make a network the default, set the `defaultNetwork` to its name. You can also override the default using the `--network` option, like: `hardhat test --network dockerizedNode`.

### Local Tests

Running `npm run test` by default runs the [ZKsync In-memory Node](https://docs.zksync.io/build/test-and-debug/in-memory-node) provided by the [@matterlabs/hardhat-zksync-node](https://docs.zksync.io/build/tooling/hardhat/hardhat-zksync-node) tool.

Important: ZKsync In-memory Node currently supports only the L2 node. If contracts also need L1, use another testing environment like Dockerized Node. Refer to [test documentation](https://docs.zksync.io/build/test-and-debug) for details.

## Useful Links

- [ZKcandy Docs](https://litepaper.zkcandy.io)
- [Official Site](https://zkcandy.io/)
- [Elastic Chain Docs](https://docs.zksync.io/build)
- [GitHub](https://github.com/zkcandy)
- [Twitter/X](https://twitter.com/zkcandyhq)
- [Discord](https://discord.gg/zkcandy)

## License

This project is under the [MIT](./LICENSE) license.
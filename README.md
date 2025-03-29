# ZKcandy Hardhat Smart Contract Deployment and Verification Demo

This repo provides a demo on how to deploy and verify Solidity contracts on the ZKcandy Mainnet. 

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

## Verify

`npx hardhat verify --network <NetworkName> <contractAddress> <contructorArgs>`

If you deploy the example Greeter contract using `npx hardhat run scripts/deploy.ts` and get back a contract address and keep the configs as they are, then you can run `npx hardhat verify --network ZKcandyMainnet <contractAddress> 'Hi there!'` to get successfully verify the deployed contract on ZKcandy Mainnet. 

### Environment Settings

To keep private keys safe, this project pulls in environment variables from `.env` files. Primarily, it fetches the wallet's private key.

Rename `.env.example` to `.env` and fill in your private key:

```
WALLET_PRIVATE_KEY=your_private_key_here...
```

This repo already has both `.env.example` and `.env` added to the `.gitignore` list. However, be mindful when sharing access to your local copy of this repo and/or your working folder in order to prevent exposing your wallet private key.

### Network Support

`hardhat.config.ts` comes with the settings required for ZKcandy Mainnet. 

## Useful Links

- [ZKcandy Docs](https://litepaper.zkcandy.io)
- [Official Site](https://zkcandy.io/)
- [Elastic Chain Docs](https://docs.zksync.io/build)
- [GitHub](https://github.com/zkcandy)
- [Twitter/X](https://twitter.com/zkcandyhq)
- [Discord](https://discord.gg/zkcandy)

## License

This project is under the [MIT](./LICENSE) license.

import type { HardhatUserConfig } from "hardhat/config";
import "@matterlabs/hardhat-zksync-verify";


import "@matterlabs/hardhat-zksync";

import dotenv from "dotenv";
dotenv.config();

const config: HardhatUserConfig = {
  defaultNetwork: "ZKcandyMainnet",
  networks: {
    ZKcandyMainnet: {
      url: "https://rpc.zkcandy.io",
      ethNetwork: "mainnet",
      zksync: true,
      verifyURL:
        "https://contracts.zkcandy.io/contract_verification",
      browserVerifyURL: "https://explorer.zkcandy.io",
      enableVerifyURL: true,
      accounts: process.env.WALLET_PRIVATE_KEY
        ? [process.env.WALLET_PRIVATE_KEY]
        : [],
    },
    hardhat: {
      zksync: true,
    },
  },
  zksolc: {
    version: "latest",
    settings: {
      // find all available options in the official documentation
      // https://docs.zksync.io/build/tooling/hardhat/hardhat-zksync-solc#configuration
    },
  },
  solidity: {
    version: "0.8.24",
  }
};

export default config;

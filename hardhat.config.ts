import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import { config as dotenvConfig } from "dotenv";
dotenvConfig({ path: __dirname + "/.env" });
require("hardhat-ethernal");

const ALCHEMY_SEPOLIA_API_KEY = process.env.ALCHEMY_SEPOLIA_API_KEY;
if (!ALCHEMY_SEPOLIA_API_KEY) {
  throw new Error("ALCHEMY_SEPOLIA_API_KEY missing");
}
const SEPOLIA_PRIVATE_KEY = process.env.SEPOLIA_PRIVATE_KEY;
if (!SEPOLIA_PRIVATE_KEY) {
  throw new Error("SEPOLIA_PRIVATE_KEY missing");
}

const ALCHEMY_MUMBAI_API_KEY = process.env.ALCHEMY_MUMBAI_API_KEY;
if (!ALCHEMY_MUMBAI_API_KEY) {
  throw new Error("ALCHEMY_MUMBAI_API_KEY missing");
}

const MUMBAI_PRIVATE_KEY = process.env.MUMBAI_PRIVATE_KEY;
if (!MUMBAI_PRIVATE_KEY) {
  throw new Error("MUMBAI_PRIVATE_KEY missing");
}
const config: HardhatUserConfig = {
  solidity: "0.8.20",
  networks: {
    sepolia: {
      url: `https://eth-sepolia.g.alchemy.com/v2/${ALCHEMY_SEPOLIA_API_KEY}`,
      accounts: [SEPOLIA_PRIVATE_KEY],
    },
    mumbai: {
      url: `https://polygon-mumbai.g.alchemy.com/v2/${ALCHEMY_MUMBAI_API_KEY}`,
      accounts: [MUMBAI_PRIVATE_KEY],
    },
  },
};

export default config;

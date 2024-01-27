import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import { config as dotenvConfig } from "dotenv";
dotenvConfig({ path: __dirname + "/.env" });

const ALCHEMY_API_KEY = process.env.ALCHEMY_API_KEY;
if (!ALCHEMY_API_KEY) {
  throw new Error("ALCHEMY_API_KEY missing");
}
const SEPOLIA_PRIVATE_KEY = process.env.SEPOLIA_PRIVATE_KEY;
if (!SEPOLIA_PRIVATE_KEY) {
  throw new Error("SEPOLIA_PRIVATE_KEY missing");
}
const config: HardhatUserConfig = {
  solidity: "0.8.20",
  networks: {
    sepolia: {
      url: `https://eth-sepolia.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
      accounts: [SEPOLIA_PRIVATE_KEY],
    },
  },
};

export default config;

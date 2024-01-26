import { ethers } from "hardhat";

async function main() {
  const nft = await ethers.deployContract("NFT", [
    "My Token",
    "MT",
    "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
    "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
  ]);

  await nft.waitForDeployment();

  console.log(`${nft.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

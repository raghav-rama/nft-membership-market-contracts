import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("NFT", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployOneYearLockFixture() {
    const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
    const ONE_GWEI = 1_000_000_000;

    const lockedAmount = ONE_GWEI;
    const unlockTime = (await time.latest()) + ONE_YEAR_IN_SECS;

    // Contracts are deployed using the first signer/account by default
    const [initialOwner, nftMarketplace] = await ethers.getSigners();

    const NFT = await ethers.getContractFactory("NFT");
    const nft = await NFT.deploy(
      "MyNFT",
      "MNFT",
      nftMarketplace.address,
      initialOwner.address
    );

    return { nft, unlockTime, lockedAmount, initialOwner, nftMarketplace };
  }

  describe("Deployment", function () {
    it("Should set the right unlockTime", async function () {
      const { nft, unlockTime } = await loadFixture(deployOneYearLockFixture);

      expect(
        await nft.safeMint(ethers.Wallet.createRandom().address, "x")
      ).to.emit(nft, "Transfer");
    });

    it("Should set the right owner", async function () {
      const { nft, initialOwner } = await loadFixture(deployOneYearLockFixture);

      expect(await nft.owner()).to.equal(initialOwner.address);
    });
  });
});

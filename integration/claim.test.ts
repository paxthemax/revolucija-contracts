import chai from "chai";
import { solidity } from "ethereum-waffle";
import { Signer, Wallet } from "ethers";
import { ethers } from "hardhat";

import { deployRevolucija } from "../scripts/deploy";
import { submitTxWait as tx, expectTxFail } from "../scripts/utils";
import { Revolucija, MintController, TestERC20 } from "../types";

chai.use(solidity);
const { expect } = chai;

describe("Claim flow", () => {
    const TEST_PRICE = ethers.utils.parseEther("1");

    let paymentToken: TestERC20;
    let revolucija: Revolucija;
    let mintController: MintController;

    beforeEach(async () => {
        const signers: Signer[] = await ethers.getSigners();

        const res = await deployRevolucija(signers[0] as Wallet, undefined);
        revolucija = res.revolucija;
        mintController = res.mintController;

        paymentToken = (await ethers.deployContract("TestERC20")) as TestERC20;

        await mintController.initalize(revolucija.address, paymentToken.address, TEST_PRICE);
    });

    describe("buy from regular address", async () => {
        it("should revert if token is out of range", async () => {
            const id = "999999";
            const signers: Signer[] = await ethers.getSigners();
            const claimer = signers[1];
            const claimerAddr = await signers[1].getAddress();

            await tx(paymentToken.mint(claimerAddr, TEST_PRICE));
            await tx(paymentToken.approve(mintController.address, TEST_PRICE));

            await expectTxFail(mintController.connect(claimer).buy(id));
        });

        it("should allow to buy a token with a regular ID", async () => {
            const id = "1234";
            const signers: Signer[] = await ethers.getSigners();
            const claimer = signers[1];
            const claimerAddr = await signers[1].getAddress();

            await tx(paymentToken.mint(claimerAddr, TEST_PRICE));
            await tx(paymentToken.connect(claimer).approve(mintController.address, TEST_PRICE));
            await tx(mintController.connect(claimer).buy(id));

            expect(await paymentToken.balanceOf(claimerAddr)).to.be.eq(0);
            expect(await revolucija.ownerOf(id)).to.be.eq(claimerAddr);
        });
    });
});

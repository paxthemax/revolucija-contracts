import hre from "hardhat";

import { VERBOSE } from "../hardhat.config";
import { Counter, Counter__factory, MintController__factory, Revolucija__factory } from "../types";
import { deployWait } from "./utils";
import { GasOptions } from "./types";
import { Wallet } from "ethers";
import { MintController, Revolucija } from "../types";

// --- Helper functions for deploying contracts ---

// Also adds them to hardhat-tracer nameTags, which gives them a trackable name
// for events when `npx hardhat test --logs` is used.

// deployCounter deploys the Counter contract with an initial count value.
export async function deployCounter(
    wallet: Wallet,
    gasOpts?: GasOptions,
    initCount?: number,
): Promise<Counter> {
    if (initCount === undefined) {
        initCount = 0;
    }

    let counterContract: Counter;
    const counter: Counter__factory = await hre.ethers.getContractFactory(`Counter`, wallet);
    counterContract = await deployWait(
        counter.deploy(initCount, {
            maxFeePerGas: gasOpts?.maxFeePerGas,
            maxPriorityFeePerGas: gasOpts?.maxPriorityFeePerGas,
            gasLimit: gasOpts?.gasLimit,
        }),
    );

    if (VERBOSE) console.log(`Counter: ${counterContract.address}`);
    hre.tracer.nameTags[counterContract.address] = `Counter`;

    return counterContract;
}

// deployCounter deploys the Revolucija contract.
export async function deployRevolucija(
    wallet: Wallet,
    gasOpts?: GasOptions,
): Promise<{ mintController: MintController; revolucija: Revolucija }> {
    let mintContollerContract: MintController;
    let revolucijaContract: Revolucija;

    const txOpts = {
        maxFeePerGas: gasOpts?.maxFeePerGas,
        maxPriorityFeePerGas: gasOpts?.maxPriorityFeePerGas,
        gasLimit: gasOpts?.gasLimit,
    };

    const mintController: MintController__factory = await hre.ethers.getContractFactory(
        "MintController",
        wallet,
    );
    const revolucija: Revolucija__factory = await hre.ethers.getContractFactory(
        "Revolucija",
        wallet,
    );

    mintContollerContract = await deployWait(mintController.deploy(txOpts));
    revolucijaContract = await deployWait(revolucija.deploy(mintContollerContract.address, txOpts));

    if (VERBOSE) {
        console.log(`Revolucija: ${revolucijaContract.address}`);
        console.log(`Mint Controller: ${mintContollerContract.address}`);
    }
    hre.tracer.nameTags[revolucijaContract.address] = `Revolucija`;
    hre.tracer.nameTags[mintContollerContract.address] = `MintController`;

    return { mintController: mintContollerContract, revolucija: revolucijaContract };
}

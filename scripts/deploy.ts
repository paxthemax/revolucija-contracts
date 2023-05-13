import hre from "hardhat";

import { VERBOSE } from "../hardhat.config";
import { Counter, Counter__factory, Revolucija__factory } from "../types";
import { deployWait } from "./utils";
import { GasOptions } from "./types";
import { Wallet } from "ethers";
import { Revolucija } from "../types/contracts";

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
async function deployRevolucija(
    wallet: Wallet,
    gasOpts?: GasOptions,
    initCount?: number,
): Promise<Counter> {
    let revolucijaContract: Revolucija;
    const revolucija: Revolucija__factory = await hre.ethers.getContractFactory(
        "Revolucija",
        wallet,
    );
    revolucijaContract = await deployWait(
        revolucija.deploy({
            maxFeePerGas: gasOpts?.maxFeePerGas,
            maxPriorityFeePerGas: gasOpts?.maxPriorityFeePerGas,
            gasLimit: gasOpts?.gasLimit,
        }),
    );

    if (VERBOSE) console.log(`Revolucija: ${revolucijaContract.address}`);
    hre.tracer.nameTags[revolucijaContract.address] = `Counter`;
}

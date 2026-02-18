const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("EmissionTracker Contract", function () {
  let emissionTracker;
  let owner;
  let addr1;

  beforeEach(async function () {
    [owner, addr1] = await ethers.getSigners();
    const EmissionTracker = await ethers.getContractFactory("EmissionTracker");
    emissionTracker = await EmissionTracker.deploy();
    await emissionTracker.deployed();
  });

  it("Should deploy the contract", async function () {
    expect(await emissionTracker.address).to.not.equal(0x0);
  });

  it("Should record a personal vehicle trip and calculate CO2 emissions", async function () {
    // Let's record a trip using a personal vehicle (fuel type: petrol, distance: 50 km)
    await emissionTracker.connect(owner).recordPersonalVehicleTrip(0, 50); // Petrol is 0
    const tripCount = await emissionTracker.getTripCount(owner.address);
    expect(tripCount).to.equal(1);

    // Check CO2 emissions for the trip
    const tripData = await emissionTracker.getTripData(owner.address, 0);
    expect(tripData.co2Emitted).to.equal(50 * 192); // 50 km * 192 g/km for petrol
  });

  it("Should reset daily emissions if needed", async function () {
    // Record a trip
    await emissionTracker.connect(owner).recordPersonalVehicleTrip(0, 50);

    // Check if daily emissions were updated
    let dailyEmissionsBefore = await emissionTracker.getDailyEmissions(owner.address);
    expect(dailyEmissionsBefore).to.equal(50 * 192);

    // Simulate a reset (wait 24 hours)
    await network.provider.send("evm_increaseTime", [86400]); // Increase time by 1 day
    await network.provider.send("evm_mine"); // Mine a new block

    // Record another trip to see if emissions reset
    await emissionTracker.connect(owner).recordPersonalVehicleTrip(1, 30); // Diesel trip

    let dailyEmissionsAfter = await emissionTracker.getDailyEmissions(owner.address);
    expect(dailyEmissionsAfter).to.equal(30 * 171); // 30 km * 171 g/km for diesel
  });

  // Add more tests here for other trips (Roadways, Railways, Airways)
});

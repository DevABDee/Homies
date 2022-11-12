const {ethers} = require("hardhat");

async function main() {
  const WhitelistContract = await ethers.getContractFactory("Whitelist");
  const deployedWhitelist = await WhitelistContract.deploy();
  await deployedWhitelist.deployed();
  console.log(`Whitelist Contract Address: ${deployedWhitelist.address}`);

  console.log("Waiting for block confirmations & Verifying...")
  await deployedWhitelist.deployTransaction.wait(5)
  await verify(deployedWhitelist.address, [])
}

const verify = async (contractAddress, args) => {
  console.log("Verifying contract...")
  try {
    await run("verify:verify", {
      address: contractAddress,
      constructorArguments: args,
    })
  } catch (e) {
    if (e.message.toLowerCase().includes("already verified")) {
      console.log("Already Verified!")
    } else {
      console.log(e)
    }
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
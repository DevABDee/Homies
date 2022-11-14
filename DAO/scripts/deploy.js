const {ethers} = require("hardhat");

async function main() {
  const DAOContract = await ethers.getContractFactory("DAO");
  const deployedDAO = await DAOContract.deploy("");
  await deployedDAO.deployed();
  console.log(`DAO Contract Address: ${deployedDAO.address}`);

  console.log("Waiting for block confirmations & Verifying...")
  await deployedDAO.deployTransaction.wait(5)
  await verify(deployedDAO.address, [""])
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
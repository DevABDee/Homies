const {ethers} = require("hardhat");

async function main() {
  const DAOContract = await ethers.getContractFactory("DAO");
  const deployedDAO = await DAOContract.deploy("0xB5168d117881B94951e012D6fcF2D1F3ab0c8D4a", "0xc180d374ec01189daAa533BD2C364671B832703a");
  await deployedDAO.deployed();
  console.log(`DAO Contract Address: ${deployedDAO.address}`);

  console.log("Waiting for block confirmations & Verifying...")
  await deployedDAO.deployTransaction.wait(5)
  await verify(deployedDAO.address, ["0xB5168d117881B94951e012D6fcF2D1F3ab0c8D4a", "0xc180d374ec01189daAa533BD2C364671B832703a"])
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
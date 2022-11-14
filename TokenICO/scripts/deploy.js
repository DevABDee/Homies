const {ethers} = require("hardhat");

async function main() {
  const TokenICOContract = await ethers.getContractFactory("TokenICO");
  const deployedTokenICO = await TokenICOContract.deploy("0xB5168d117881B94951e012D6fcF2D1F3ab0c8D4a");
  await deployedTokenICO.deployed();
  console.log(`TokenICO Contract Address: ${deployedTokenICO.address}`);

  console.log("Waiting for block confirmations & Verifying...")
  await deployedTokenICO.deployTransaction.wait(5)
  await verify(deployedTokenICO.address, ["0xB5168d117881B94951e012D6fcF2D1F3ab0c8D4a"])
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
const {ethers} = require("hardhat");

async function main() {
  const NFTsContract = await ethers.getContractFactory("NFTs");
  const deployedNFTs = await NFTsContract.deploy("0xF28A978856c96984E7A768A2fc5C8487B8Dcda61");
  await deployedNFTs.deployed();
  console.log(`NFTs Contract Address: ${deployedNFTs.address}`);

  console.log("Waiting for block confirmations & Verifying...")
  await deployedNFTs.deployTransaction.wait(5)
  await verify(deployedNFTs.address, ["0xF28A978856c96984E7A768A2fc5C8487B8Dcda61"])
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
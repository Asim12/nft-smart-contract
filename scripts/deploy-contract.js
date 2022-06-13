
require('dotenv').config();
const { TOTAL_RESERVE, MINT_LIMIT } = process.env;

async function main() {
    const Contract = await ethers.getContractFactory("MetaIsland")

    const contractInstance = await Contract.deploy(
        MINT_LIMIT,
        TOTAL_RESERVE)
    console.log(`Contract deployed to "https://mumbai.polygonscan.com/address/${contractInstance.address}". Make sure to update "MetaIsland" env.`);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
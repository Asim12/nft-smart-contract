const {expect}      =   require("chai");
const { concat }    =   require("ethers/lib/utils");
const {ethers}      =   require("hardhat");
const web3          =   require("web3")
require("@nomiclabs/hardhat-waffle");
describe("Working on withdraw function unit test", async() => {
    it('Widthraw function testing', async() => {
        const [owner]    = await ethers.getSigners();
        console.log('Owner of the contract is ', owner.address);
        const NFT = await ethers.getContractFactory("NFT");
        const nft = await NFT.deploy(
            "MyTest",
            "TST",
            "ipfs://QmXBjRRgHf8FEaJupiM3o7ttkzv6CTmuHq1iFXktDG1FBD/",
            "1000" 
        );
        const contract = await nft.deployed();
        console.log("Contract deployed at:", contract.address);
        const widthrawFunctionTest = await contract.withdraw()
        console  
        expect(widthrawFunctionTest.confirmations).to.equal(1)
    });

    it('Mint function testing', async() => {
        const NFT = await ethers.getContractFactory("NFT");
        const nft = await NFT.deploy(
            "MyTest",
            "TST",
            "ipfs://QmXBjRRgHf8FEaJupiM3o7ttkzv6CTmuHq1iFXktDG1FBD/",
            "1000" 
        );
        const contract = await nft.deployed();
        console.log("Contract deployed at:", contract.address);
        const mintNFT = await contract.mintNFT({value: web3.utils.toWei("0.002", "ether")})
        console.log('widthrawFunctionTest', mintNFT)
        expect(mintNFT.confirmations).to.equal(1)
    });
})

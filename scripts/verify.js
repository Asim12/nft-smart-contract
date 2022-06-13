// npx hardhat verify --constructor-args verify.js 0x69901c7acc96648a560f15c5F22a2657c049B6F9 --network rinkeby --show-stack-traces

require('dotenv').config();
const {MINT_LIMIT, IPFS_HIDDEN, TOTAL_RESERVE, MAX_TOKENS } = process.env;
module.exports = [
    MINT_LIMIT,
    TOTAL_RESERVE
];

const main = async () => {
    // 部署者与余额
    const [deployer] = await hre.ethers.getSigners();
    const accountBalance = await deployer.getBalance();

    console.log("Deploying contracts with account: ", deployer.address);
    console.log("Account balance: ", accountBalance.toString());

    // 在 artifacts 生成合约的必要文件
    const contractFactory = await hre.ethers.getContractFactory("WavePortal");
    
    // 部署合约
    const contract = await contractFactory.deploy();

    // 等到该合约部署完成
    await contract.deployed();

    console.log("Contract deployed to:", contract.address);
}

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
}

runMain();
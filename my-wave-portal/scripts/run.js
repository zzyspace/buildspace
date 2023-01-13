
const main = async () => {
    // 在 artifacts 生成合约的必要文件
    const contractFactory = await hre.ethers.getContractFactory("WavePortal");
    
    // 1. 创建一个本地以太坊 (运行结束后会 destroy 该本地网络)
    // 2. 部署该合约
    const contract = await contractFactory.deploy();

    // 等到该合约部署完成
    await contract.deployed();
    console.log("Contract deployed to:", contract.address);


    // 获取部署者的地址 
    const [owner, randomPerson] = await hre.ethers.getSigners();
    console.log("Contract deployed by:", owner.address);

    // 调用合约方法
    await contract.getTotalWaves();
    
    const wave1txn = await contract.wave();
    await wave1txn.wait();

    await contract.getTotalWaves();

    const wave2txn = await contract.connect(randomPerson).wave();
    await wave2txn.wait();

    await contract.getTotalWaves();
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
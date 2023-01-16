
const main = async () => {
    // 在 artifacts 生成合约的必要文件
    const contractFactory = await hre.ethers.getContractFactory("WavePortal");
    
    // 部署合约同时提供资金
    const contract = await contractFactory.deploy({
        value: hre.ethers.utils.parseEther("0.1")
    });

    // 等到该合约部署完成
    await contract.deployed();
    console.log("Contract deployed to:", contract.address);

    // 获取部署者的地址 
    const [owner, randomPerson] = await hre.ethers.getSigners();
    console.log("Contract deployed by:", owner.address);

    // 调用合约方法
    // const count = await contract.getTotalWaves();
    // console.log("Total waves:", count.toNumber());
    
    // const wave1txn = await contract.wave("A message!");
    // await wave1txn.wait();

    // const wave2txn = await contract.connect(randomPerson).wave("Another message!");
    // await wave2txn.wait();

    // const allWaves = await contract.getAllWaves();
    // console.log(allWaves);

    // balance
    let balance = await hre.ethers.provider.getBalance(contract.address);
    console.log("Contract Balance:", hre.ethers.utils.formatEther(balance));

    // send wave
    const txn = await contract.wave("A message!");
    await txn.wait();

    // check balance
    balance = await hre.ethers.provider.getBalance(contract.address);
    console.log("Contract Balance:", hre.ethers.utils.formatEther(balance));

    const allWaves = await contract.getAllWaves();
    console.log(allWaves);

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
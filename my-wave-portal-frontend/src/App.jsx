import React, { useEffect, useState } from "react";
import { ethers } from "ethers";
import './App.css';
import { abi } from "./utils/WavePortal.json"

const CONTRACT_ADDR = "0x4de1067496155b6DDa85aBa83f3503E6234D6Ed2";
const CONTRACT_ABI = abi;

export default function App() {

  // Hook
  const [currentAccount, setCurrentAccount] = useState("");
  const [allWaves, setAllWaves] = useState([]);
  
  useEffect(async () => {
    checkIfWalletIsConnected();
    getAllWaves();
    const contract = getContract();
    if (contract) {
      contract.on("NewWave", onNewWave);
    }
    return () => {
      contract && contract.off("NewWave", onNewWave);
    }
  }, []);

  const getEthereumObject = () => {
    return window.ethereum;
  }
  
  const getContract = () => {
      const ethereum = getEthereumObject();
      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const contract = new ethers.Contract(CONTRACT_ADDR, CONTRACT_ABI, provider.getSigner());
        return contract;
      } else {
        console.error("Ethereum object doesn't exist!");
        return null;
      }
  }
  
  const checkIfWalletIsConnected = async () => {
    try {
      const ethereum = getEthereumObject();
      
      if (!ethereum) {
        console.error("Make sure you have installed MetaMask!");
        return null;
      }
  
      console.log("We have the Ethereum object:", ethereum);
  
      const accounts = await ethereum.request({ method: "eth_accounts" });
  
      if (accounts.length !== 0) {
        const account = accounts[0];
        console.log("Found a authorized account:", account);
        setCurrentAccount(account);
      } else {
        console.error("No authorized account found");
        return null;
      }
    } catch (error) {
      console.error(error);
      return null;
    }
  }

  // Events

  const onNewWave = async (from, timestamp, message) => {
    console.log("Listened new wave", message, from, timestamp);
    setAllWaves(prevState => [
      ...prevState,
      {
        address: from,
        timestamp: new Date(timestamp * 1000),
        message: message
      }
    ]);
  }
  
  // Actions
  
  const wave = async () => {
    try {
      const contract = getContract();
  
      if (contract) {
        const input = document.getElementById("input");
        console.log("Input Text:", input.value);
        
        const txn = await contract.wave(input.value || "", { gasLimit: 300000 });
        console.log("Mining...", txn.hash);
        
        await txn.wait();
        console.log("Minted!", txn.hash);
        
        // const count = await contract.getTotalWaves();
        // const countNum = count.toNumber();
        // alert(`Waves total count: ${countNum}`);
        
        // getAllWaves();
        
      }
    } catch (error) {
      console.error(error);
    }
  }
  
  const getAllWaves = async () => {
    try {
      const contract = getContract();
      console.log(1);
      if (contract) {
      console.log("2", contract);
        const waves = await contract.getAllWaves();
        const wavesCleaned = [];
        
      console.log(3);
        waves.forEach(wave => {
          wavesCleaned.push({
            address: wave.waver,
            timestamp: new Date(wave.timestamp * 1000),
            message: wave.message
          });
        });
        console.log("waves cleaned:\n"+wavesCleaned);
        setAllWaves(wavesCleaned);
      }
    } catch (error) {
      console.error(error);
    }
  }
  
  const connectWallet = async () => {
    try {
      const ethereum = getEthereumObject();
  
      if (!ethereum) {
        alert("Please install MetaMask!");
        return;
      }
  
      const accounts = await ethereum.request({ method: "eth_requestAccounts", });
  
      console.log("Connected", accounts[0]);
      setCurrentAccount(accounts[0]);
    } catch (error) {
      console.error(error);
    }
  }
  
  return (
    <div className="mainContainer">

      <div className="dataContainer">
        <div className="header">
        👋 Hey there!
        </div>

        <div className="bio">
        I am ryan and I worked on self-driving cars so that's pretty cool right? Connect your Ethereum wallet and wave at me!
        </div>

        <input type="text" id="input" className="inputField"></input>
        
        <button className="waveButton" onClick={wave}>
          Wave at Me
        </button>
        {
          !currentAccount && (
            <button className="waveButton" onClick={connectWallet}>
              Connect Wallet
            </button>
          )
        }
        {
          console.log("allWaves:", allWaves)
        }
        {
          allWaves.map((wave, index) => {
            return (
              <div key={index} style={{ backgroundColor: "OldLace", marginTop: "16px", padding: "8px" }}>
              <div>Message: {wave.message}</div>
              <div>Address: {wave.address}</div>
              <div>Time: {wave.timestamp.toString()}</div>
              </div>
            )
          })
        }
      </div>
    </div>
  );
}

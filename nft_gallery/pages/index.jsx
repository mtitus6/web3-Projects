// import type { NextPage } from 'next'
import Head from 'next/head'
import Image from 'next/image'
import { NFTCard } from '../components/nftCard'
import { useState } from 'react'

const Home  = () => {

  const [wallet, setWalletAddress] = useState("")
  const [collection, setCollectionAddress] = useState("")
  const [NFTs, setNFTs] = useState([])
  const [fetchForCollection, setFetchForCollection]=useState(false)
  const [page,fetchPage] = useState("")
  const [nextPage,fetchNextPage] = useState("")
  
  const fetchNFTs = async() => {
    let nfts; 
    console.log("fetching nfts");
    const api_key = "<YOUR API KEY>"
    const baseURL = `https://eth-mainnet.g.alchemy.com/v2/${api_key}/getNFTs/`;
    var requestOptions = {
        method: 'GET'
      };
     
    if (!collection.length) {
      console.log("fetching nfts for address")
      // const fetchURL = `${baseURL}?owner=${wallet}`;
      //Challenge
      const fetchURL = `${baseURL}?owner=${wallet}&pageKey=${page}&pageSize=100`;
      nfts = await fetch(fetchURL, requestOptions).then(data => data.json())
    } else {
      console.log("fetching nfts for collection owned by address")
      const fetchURL = `${baseURL}?owner=${wallet}&contractAddresses%5B%5D=${collection}&pageKey=${page}&pageSize=100`;
      nfts= await fetch(fetchURL, requestOptions).then(data => data.json())
    }
  
    if (nfts) {
      console.log("nfts:", nfts)
      setNFTs(nfts.ownedNfts)
      fetchPage(nfts.pageKey)
    }
  }

  const fetchNFTsForCollection = async () => {
    if (collection.length) {
      var requestOptions = {
        method: 'GET'
      };
      const api_key = "<YOUR API KEY>"
      const baseURL = `https://eth-mainnet.g.alchemy.com/v2/${api_key}/getNFTsForCollection/`;
      const fetchURL = `${baseURL}?contractAddress=${collection}&withMetadata=${"true"}&pageKey=${page}&pageSize=100`;
      const nfts = await fetch(fetchURL, requestOptions).then(data => data.json())
      if (nfts) {
        console.log("NFTs in collection:", nfts)
        setNFTs(nfts.nfts)
        fetchPage(nfts.pageKey)
      }
    }
  }


  return (
    <div className="flex flex-col items-center justify-center py-8 gap-y-3">
      <div className="flex flex-col w-full justify-center items-center gap-y-2">
        <input disabled={fetchForCollection} className="w-2/5 bg-slate-100 py-2 px-2 rounded-lg text-gray-800 focus:outline-blue-300 disabled:bg-slate-50 disabled:text-gray-50" onChange={(e)=>{setWalletAddress(e.target.value); fetchPage("")}} value = {wallet} type={"text"} placeholder="Add your wallet address"></input>
        <input className="w-2/5 bg-slate-100 py-2 px-2 rounded-lg text-gray-800 focus:outline-blue-300 disabled:bg-slate-50 disabled:text-gray-50" onChange={(e)=>{setCollectionAddress(e.target.value); fetchPage("")}} value={collection} type={"text"} placeholder="Add the collection address"></input>
        <label className="text-gray-600 "><input onChange={(e)=>{; fetchPage("");setFetchForCollection(e.target.checked)}} type={"checkbox"} className="mr-2"></input>Fetch for collection</label>
        <button className={"disabled:bg-slate-500 text-white bg-blue-400 px-4 py-2 mt-3 rounded-sm w-1/5"} 
          onClick={
            () => {
              //how do I get this thing to reset after it is set
              fetchPage("") //does not work here but does work in the onChange events above
              if (fetchForCollection) {
                fetchNFTsForCollection();
              }else 
                fetchNFTs();  
          }
        }>Let's go! </button>
      </div>
      <div className='flex flex-wrap gap-y-12 mt-4 w-5/6 gap-x-2 justify-center'>
        {
          NFTs.length && NFTs.map(nft => {
            return (
              <NFTCard nft={nft}></NFTCard>
            )
          })
        }
      </div>
      <div className='flex flex-wrap gap-y-12 mt-4 w-5/6 gap-x-2 justify-center'>
        <button className={"disabled:bg-slate-500 text-white bg-blue-400 px-4 py-2 mt-3 rounded-sm w-1/5"} 
            disabled = {fetchPage.length}
            onClick={ 
              () => {
                if (fetchForCollection) {
                  fetchNFTsForCollection();
                }else 
                  fetchNFTs();
            }
          }>Next</button>
       </div> 
    </div>
  )
}

export default Home

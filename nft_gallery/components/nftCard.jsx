import { useState } from 'react'
export const NFTCard = ({ nft }) => {

    const [copied, setCopied] = useState(false);

    const handleCopy = () => {
      navigator.clipboard.writeText(nft.contract.address);
      setCopied(true);
    };

    return (
        <div className="w-1/4 flex flex-col ">
        <div className="rounded-md">
            <img className="object-cover h-128 w-full rounded-t-md" src={nft.media[0].gateway} ></img>
        </div>
        <div className="flex flex-col y-gap-2 px-2 py-3 bg-slate-100 rounded-b-md h-110 ">
            <div className="">
                <h2 className="text-xl text-gray-800">{nft.title}</h2>
                <p className="text-gray-600">Id: {nft.id.tokenId.substr(nft.id.tokenId.length - 4)}</p>
                <p className="text-gray-600" >{`${nft.contract.address.substr(0,5)}...${nft.contract.address.substr(nft.contract.address.length-4)} `}
                    <button onClick={handleCopy} id="copy-button"></button>  
                    {copied ? <span> Copied!</span> : null} 
                </p>
            </div>

            <div className="flex-grow mt-2">
                <p className="text-gray-600">{nft.description.substr(0,80)}</p>
            </div>

            <div className="flex-grow mt-2 text-center">
                <a className="py-2 px-4 bg-blue-400 w-1/2 text-center rounded-m text-white cursor-pointer" target = "_blank" href={`https://etherscan.io/token/${nft.contract.address}`}>View on Etherscan</a>
            </div>
        </div>

    </div>
    )
}
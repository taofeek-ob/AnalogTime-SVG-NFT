import React from 'react';
import Image from 'next/image';
import { ConnectButton } from '@rainbow-me/rainbowkit';
import type { NextPage } from 'next';
import {
  useAccount,
  useContractRead,
  useContractWrite,
  usePrepareContractWrite,
  useWaitForTransaction,
} from 'wagmi';
import contractInterface from '../contract-abi.json';
import FlipCard, { BackCard, FrontCard } from '../components/FlipCard';


const contractConfig = {
  addressOrName: '0x6302F46F065fA9eB7462aD58167bD9163e3Af515',
  contractInterface: contractInterface,
};

const Home: NextPage = () => {
  const [mounted, setMounted] = React.useState(false);

  React.useEffect(() => setMounted(true), []);


  const [totalMinted, setTotalMinted] = React.useState(0);
  const { isConnected } = useAccount();

  const { config: contractWriteConfig } = usePrepareContractWrite({
    ...contractConfig,
    functionName: 'mintTime',
    
  });

  const {
    data: mintData,
    write: mint,
    isLoading: isMintLoading,
    isSuccess: isMintStarted,
    error: mintError,
  } = useContractWrite(contractWriteConfig);

  const { data: totalSupplyData } = useContractRead({
    ...contractConfig,
    functionName: 'totalSupply',
    watch: true,
  });

  const {
    data: txData,
    isSuccess: txSuccess,
    error: txError,
  } = useWaitForTransaction({
    hash: mintData?.hash,
  });

  React.useEffect(() => {
    if (totalSupplyData) {
      setTotalMinted(totalSupplyData.toNumber());
    }
  }, [totalSupplyData]);

  const isMinted = txSuccess;

  return (
    <div className="page">
      <div className="container">
        <div style={{ flex: '1 1 auto' }}>
          <div style={{ padding: '24px 24px 24px 0' }}>
            <h1>ANALOGCLOCK SVG  NFT MINT</h1>
            <p style={{ margin: '12px 0 24px' }}>
              {totalMinted} minted so far!
            </p>
            <ConnectButton />

            {mintError && (
              <p style={{ marginTop: 24, color: '#FF6257' }}>
                Error: {mintError.message}
              </p>
            )}
            {txError && (
              <p style={{ marginTop: 24, color: '#FF6257' }}>
                Error: {txError.message}
              </p>
            )}
           
            
            {mounted && isConnected && (
<>

              <button
                style={{ marginTop: 24 }}
                disabled={!mint}
                className="button"
                data-mint-loading={isMintLoading && !isMintStarted}
                data-mint-started={isMintStarted && !isMinted}
               
                onClick={() => mint?.()}
              >
                
                
                {isMintLoading ? "Waiting for Approval" : !isMintLoading && isMintStarted && !isMinted ? "Minting" : "Mint"}
              </button>
              </>
            )}
          </div>
        </div>

      {/* <div style={{ flex: '0 0 auto' }}> */}
      <div style={{ flex: '0 0 auto' }}>
        <FlipCard>
        
          <FrontCard isCardFlipped={isMinted}>



          
          <Image
                layout="responsive"
                src="/DigitalTime.png"
                width="500"
                height="500"
                alt="SVG Demo NFT"
              />

           
          </FrontCard>
          <BackCard isCardFlipped={isMinted}>
            <div style={{ padding: 24 }}>
              <Image
                src="/nft.png"
                width="80"
                height="80"
                alt="SVG Demo NFT"
                style={{ borderRadius: 8 }}
              />
              <h2 style={{ marginTop: 24, marginBottom: 6 }}>NFT Minted!</h2>
              <p style={{ marginBottom: 24 }}>
                Your NFT will show up in your wallet in the next few minutes.
              </p>
              <p style={{ marginBottom: 6 }}>
                View on{' '}
                <a href={`https://goerli.etherscan.io/tx/${mintData?.hash}`}>
                  Etherscan
                </a>
              </p>
              <p>
                View on{' '}
                <a
                  href={`https://testnets.opensea.io/collection/digital-time`}
                >
                  Opensea
                </a>
              </p>
            </div>
          </BackCard>
        </FlipCard>
      </div>
        
      <footer> Created by Taofeek <a
                    href={`https://twitter.com/taofeek_ob`}
                 target='blank' >Twitter</a> & <a
                  href={`https://github.com/taofeek-ob`}
                  target='blank' >Github</a></footer>
      </div>

    </div>
  );
};

export default Home;

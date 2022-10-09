// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;


// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "base64-sol/base64.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";



interface DateInterface{
  function getSecond(uint timestamp) external pure returns (uint8);
  function getMinute(uint timestamp) external pure returns (uint8);
  function getHour(uint timestamp) external pure returns (uint8);
}



// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract AnalogTime is ERC721Enumerable, ERC721URIStorage {
address public constant OTHER_CONTRACT = 0x6524Fe1C9B9f34147596FfdFD5dC87a78eba8E55;
  DateInterface DateContract = DateInterface(OTHER_CONTRACT);

// Magic given to us by OpenZeppelin to help us keep track of tokenIds.
using Counters for Counters.Counter;

Counters.Counter private _tokenIds;

// This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
// So, we make a baseSvg in base64 encoded variables here that all our NFTs can use.
string baseSvg = '<svg viewBox="0 0 220 220" xmlns="http://www.w3.org/2000/svg"> <style>text { font-family: Courier New; font-weight: bold; user-select: none; }</style> <g transform="translate(110,110)"> <g fill="none"> <circle class="x-clock-circle" r="108" stroke="gray" stroke-width="4"/> <circle class="x-clock-1-minute" transform="rotate(-1.5)" r="97" stroke="#000" stroke-dasharray="4 46.789082" stroke-width="11"/> <circle class="x-clock-5-minute" transform="rotate(-.873)" r="100" stroke="#000" stroke-dasharray="2 8.471976" stroke-width="5"/> </g> </g> <g transform="rotate(180 55 55)"> <circle class="x-clock-center" r="7" fill="#333"/>';
string start='PGcgdHJhbnNmb3JtPSJyb3RhdGUo';
string endHour='KSIgdGFiaW5kZXg9IjAiPiA8bGluZSBjbGFzcz0ieC1jbG9jay1ob3VyLWhhbmQiIHkyPSI3MCIgc3Ryb2tlPSJzaWx2ZXIiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLXdpZHRoPSI1Ii8+IDwvZz4=';

string endMinute='KSIgdGFiaW5kZXg9IjAiPiA8bGluZSBjbGFzcz0ieC1jbG9jay1taW51dGUtaGFuZCIgeTI9Ijg1IiBzdHJva2U9ImdvbGQiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLXdpZHRoPSI1Ii8+IDwvZz4=';

string endSecond='KSI+IDxsaW5lIGNsYXNzPSJ4LWNsb2NrLXNlY29uZC1oYW5kIiB5Mj0iOTUiIHN0cm9rZT0iIzMzMyIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2Utd2lkdGg9IjIiLz48L2c+IDwvZz4=';
string baseEnd='PGcgY2xhc3M9IngtY2xvY2stbnVtYmVycyI+PHRleHQgeD0iMzUiIHk9Ii02NSIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMTEwIDExMCkiPjE8L3RleHQ+PHRleHQgeD0iNjUiIHk9Ii0zNSIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMTEwIDExMCkiPjI8L3RleHQ+PHRleHQgeD0iNzUiIHk9IjUiIHRyYW5zZm9ybT0idHJhbnNsYXRlKDExMCAxMTApIj4zPC90ZXh0Pjx0ZXh0IHg9IjY1IiB5PSI0NSIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMTEwIDExMCkiPjQ8L3RleHQ+PHRleHQgeD0iMzUiIHk9Ijc1IiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgxMTAgMTEwKSI+NTwvdGV4dD48dGV4dCB4PSItNSIgeT0iODUiIHRyYW5zZm9ybT0idHJhbnNsYXRlKDExMCAxMTApIj42PC90ZXh0Pjx0ZXh0IHg9Ii00NSIgeT0iNzUiIHRyYW5zZm9ybT0idHJhbnNsYXRlKDExMCAxMTApIj43PC90ZXh0Pjx0ZXh0IHg9Ii03NSIgeT0iNDUiIHRyYW5zZm9ybT0idHJhbnNsYXRlKDExMCAxMTApIj44PC90ZXh0Pjx0ZXh0IHg9Ii04NSIgeT0iNSIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMTEwIDExMCkiPjk8L3RleHQ+PHRleHQgeD0iLTc1IiB5PSItMzUiIHRyYW5zZm9ybT0idHJhbnNsYXRlKDExMCAxMTApIj4xMDwvdGV4dD48dGV4dCB4PSItNTAiIHk9Ii02NSIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMTEwIDExMCkiPjExPC90ZXh0Pjx0ZXh0IHg9Ii0xMCIgeT0iLTc1IiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgxMTAgMTEwKSI+MTI8L3RleHQ+PC9nPjx0ZXh0IGlkPSJkaWdpdGFsLXRleHQiIHg9Ii00NSIgeT0iMzAiIHRyYW5zZm9ybT0idHJhbnNsYXRlKDExMCAxMTApIj4=';
string digital='PC90ZXh0Pjx0ZXh0IHg9Ii0zMCIgeT0iNjAiIGZvbnQtc2l6ZT0iMTAiIHRyYW5zZm9ybT0idHJhbnNsYXRlKDExMCAxMTApIiBjbGFzcz0ieC1jbG9jay1kaWdpdGFsIj4=';


constructor() ERC721 ("ANALOG TIME", "TIME") {

}




function hourDegree() internal view returns (string memory) {
  uint256 h = uint256(DateContract.getHour(block.timestamp));
  uint256 m = uint256(DateContract.getMinute(block.timestamp));
 

uint256  hourDeg = (((h+1) % 12) * 60) / 2;
  uint256 minDeg = (m*360)/720; // 1 hour 30 deg
//   uint256 minDeg = (m/60) * (360/12); // 1 hour 30 deg

 uint256  hourRotateDeg = hourDeg + minDeg;
    
    return Strings.toString(hourRotateDeg);
}

function secondDegree() internal view returns (string memory) {
  
  uint256 s = uint256(DateContract.getSecond(block.timestamp));

 uint256 secDeg  =  360/60 * s;
 
    
    return Strings.toString(secDeg);
}
function minuteDegree() internal view returns (string memory) {
 
  uint256 m = uint256(DateContract.getMinute(block.timestamp));
 
  uint256 minRotateDegree =  360/60 * m; // 1 min 6 deg


    
    return Strings.toString(minRotateDegree);
}
function format() internal view returns (string memory) {
  uint8 h = DateContract.getHour(block.timestamp);
  uint8 m = DateContract.getMinute(block.timestamp);
  uint8 s = DateContract.getSecond(block.timestamp);

 
    string memory session = "AM";
    if(h == 23){
        h =0;
    }
    else if(h == 11){
        h = 12;
        session = "PM";

    }
    
    else if(h > 12){
        h = h +1;
        session = "PM";
    }
    else {
        h+1;
    }

   
    
    string memory hour = (h < 10) ? string.concat("0",  Strings.toString(h)) : Strings.toString(h);
    string memory minute = (m < 10) ? string.concat("0",  Strings.toString(m)) : Strings.toString(m);
    string memory second = (s < 10) ? string.concat("0",  Strings.toString(s)) : Strings.toString(s);
   
    
    
    return string.concat(hour, ":", minute, ":", second, " ", session);
}


function substring( uint startIndex, uint endIndex) public view returns (string memory ) {
    bytes memory strBytes = bytes(Strings.toHexString(msg.sender));
    bytes memory result = new bytes(endIndex-startIndex);
    for(uint i = startIndex; i < endIndex; i++) {
        result[i-startIndex] = strBytes[i];
    }
    return string(result);
}

function formatTokenURI(string memory imageURI) internal pure returns (string memory) {
        return string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                "DIGITAL TIME ", // You can add whatever name here
                                '", "description":"A Digital Clock Dependent NFT based on SVG! Created by Taofeek", "attributes":"", "image":"',imageURI,'"}'
                            )
                        )
                    )
                )
            );
    }
function mintTime() public {
uint256 newItemId = _tokenIds.current();
// string memory time= formatTime(block.timestamp);
string memory finalSvg1 = string.concat(baseSvg, string(abi.encodePacked(Base64.decode(start))), hourDegree(),string(abi.encodePacked(Base64.decode(endHour))),string(abi.encodePacked(Base64.decode(start))),minuteDegree(),string(abi.encodePacked(Base64.decode(endMinute))));
string memory finalSvg2 = string.concat(string(abi.encodePacked(Base64.decode(start))),secondDegree(),string(abi.encodePacked(Base64.decode(endSecond))),string(abi.encodePacked(Base64.decode(baseEnd))), format(), string(abi.encodePacked(Base64.decode(digital))), substring(0,10),  "</text></svg>");
//string(abi.encodePacked(Base64.decode(baseSCript)))

 string memory baseURL = "data:image/svg+xml;base64,";
string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(finalSvg1, finalSvg2))));
string memory imageURI = string(abi.encodePacked(baseURL,svgBase64Encoded));

// Actually mint the NFT to the sender using msg.sender.
_safeMint(msg.sender, newItemId);
// Set the NFTs data.
_setTokenURI(newItemId, formatTokenURI(imageURI));

// Increment the counter for when the next NFT is minted.
_tokenIds.increment();
}

// The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

}
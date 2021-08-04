// SPDX-License-Identifier: GPL-3.0
//not functional right now, in progress

pragma solidity ^0.8.0; 

import "@OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/IERC721.sol";
import "@OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol";
import "@OpenZeppelin/openzeppelin-contracts/master/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

using Counters for Counters.Counter;
Counters.Counter private _tokenIds;
mapping(string => uint8) hashes;

mapping (uint => Book) books; //map book_id to Book
address[] authorAddresses;
mapping (uint => Edition) editions;
mapping (uint => address) authorAddress;


struct Book {
    string title;
    address authorAddr;
    uint book_id;
    struct Edition[] editions;
}

struct Edition {
    private uint _numMinted;
}

contract BookCreation is IERC721 { //implement the IERC721 interface
    function mintBook(uint _bookID, uint _editionID) external onlyBookAuthor(_bookID) {
        _tokenIds = _tokenIds + 1;
        books[_bookID]._numMinted = books[_bookID]._numMinted + 1;
        books[_bookID].editions[_editionID]._numMinted = books[_bookID].editions[_editionID]._numMinted + 1;

        emit BookMinted(_tokenIds, _editionID, _bookID, books[_bookID].authorID);
        _safeMint(msg.sender, _tokenIds);
    }
     function ownerOf(uint tokenID) public view virtual override returns (address) {
        return super.ownerOf(tokenID);
    } //override the ERC721 method ownerOf
    
    modifier onlyBookAuthor(uint _bookID) {
        require(books[_bookID].authorAddr == msg.sender)
        _;
    }
    function _safeMint(address _authorAddr, uint _tokenIds) internal {
        _mint(address(this), _tokenIds);
        safeTransferFrom(address(this), _authorAddr, _tokenIds)
    }
		function countAuthors() view public returns (uint) {
			return authorAddresses.length;
		}
}
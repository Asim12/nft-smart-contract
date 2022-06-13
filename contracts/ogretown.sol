//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract OgreTown is ERC721A, Ownable, ReentrancyGuard {    

    
    /** @dev Total number of NFT's  */
    uint256 public constant MAX_SUPPLY = 10000;

    /** @dev a fixed value for mint each nft */
    uint256 public  mintPrice = 0;

    /** @dev limit the number of nft a user can mint  */
    uint256 public mintLimit;

    /** @dev minter tokens count */
    mapping(address => uint256) public minters;

    /** @dev total number of tokens minted */
    uint256 public tokenCounter;

    /** @dev Maximum reserved tokens for Team */
    uint256 public immutable RESERVED_SUPPLY;

    /** @dev baseuri of nft tokens as per OpenSea Standards  */
    string public baseURI;

    /** @dev allow public sale when set to true */
    bool public publicSale;

    /** @dev Provenance hash for tokens */
    string public  provenanceHash= "";

    /** @dev Reveal flag if true  */
    bool public isRevealed = false;

    uint256 public RESERVED_MINTED = 0;

    string public placeholderURI;
    
    modifier callerIsUser() {
    require(tx.origin == msg.sender, "The caller is another contract");
    _;
    }

    constructor(uint256 _mintLimit, 
        uint256 _reserved_supply)
        ERC721A("OgreTown", "OGRE")
        {
            require(MAX_SUPPLY > 0, "the maxNftValue cannot be less than 1 ");
            require(_reserved_supply < MAX_SUPPLY, "you cannot reserved all nft");
           
            mintLimit = _mintLimit;
            publicSale = false;
            RESERVED_SUPPLY = _reserved_supply;
        }


    function _startTokenId() internal view override virtual returns (uint256) {
        return 1;
    }

    /** @dev */
    function reserveForTeam(uint256 quantity) external onlyOwner {

        require(minters[msg.sender] + quantity <= RESERVED_SUPPLY,"reserve supply would exceed");

        require(tokenCounter + quantity <= MAX_SUPPLY, "Exceeding the Max Supply");

        _safeMint(msg.sender, quantity);
        tokenCounter += quantity;
        RESERVED_MINTED += quantity;
        minters[msg.sender] += quantity;
    }

    function mintOgre(uint256 quantity) external  callerIsUser {

        require(tokenCounter + quantity <= MAX_SUPPLY,"You can't mint more than maximum supply");
        require(publicSale == true, "public sale not yet started");
        require(minters[msg.sender] + quantity <= mintLimit, "Mint exceeding the allowed limit");
        
        _safeMint(msg.sender, quantity);

        minters[msg.sender] += quantity;
        tokenCounter += quantity;
    }


    function setpublicSale(bool _publicSale) external onlyOwner {
        publicSale = _publicSale;
    }

    function setRevealNft(bool _isRevealed) external onlyOwner{
        isRevealed = _isRevealed;
    }


    // IMPORTANT: SET BEFORE SALE
    function setProvenanceHash(string memory _provenanceHash) external onlyOwner {
        require(bytes(provenanceHash).length == 0, "Provenance can not be changed after the sale has started.");
        provenanceHash = _provenanceHash;
    }

    // IMPORTANT: SET AFTER SALE "
    function setBaseURI(string memory _baseURI) external onlyOwner  {
        require(bytes(_baseURI).length > 0, "baseURI cannot be empty.");
        baseURI = _baseURI;
        
    }

    function setPlaceholderURI(string memory _placeholderURI) external onlyOwner {
        
        require(bytes(_placeholderURI).length > 0, "Placeholder URI cannot be empty.");
        placeholderURI = _placeholderURI;
       
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        if (!isRevealed) {
            return placeholderURI;
        }

        string memory _baseURI = baseURI;
        return bytes(baseURI).length > 0
            ? string(abi.encodePacked(_baseURI, Strings.toString(tokenId),".json"))
            : "";
    }

    function withdraw() external payable onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}


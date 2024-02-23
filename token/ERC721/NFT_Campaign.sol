// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ERC721URIStorageUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

contract NFT is ERC721URIStorageUpgradeable, AccessControlUpgradeable {

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721URIStorageUpgradeable, AccessControlUpgradeable) returns (bool) {
        return AccessControlUpgradeable.supportsInterface(interfaceId) || ERC721URIStorageUpgradeable.supportsInterface(interfaceId);
    }

    using SafeMath for uint256;
    // using SafeERC20 for IERC20;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    uint256 internal tokenId;

    // Define a struct to represent NFT campaign
    struct Campaign {
        uint256 tokenId;
        address recipient;
        uint256 amount;
        string tokenURI;
    }

    // Define events
    event NFTMinted(uint256 indexed tokenId, address indexed recipient, string tokenURI);

    // Mapping from token ID to campaign details
    mapping(uint256 => Campaign) public campaigns;

    // Constructor
    function initialize() public initializer {
        __ERC721_init("NFT Campaign", "NFTC");
        __AccessControl_init();
        tokenId++;
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(MINTER_ROLE, _msgSender());
    }

    // Mint NFT for a campaign
    function mintNFT(address recipient, uint256 amount, string memory _tokenURI) external returns (uint256) {
        require(hasRole(MINTER_ROLE, _msgSender()), "NFT: must have minter role to mint");
        tokenId++;
        _safeMint(recipient, tokenId);
        _setTokenURI(tokenId, _tokenURI);
        campaigns[tokenId] = Campaign(tokenId, recipient, amount, _tokenURI);
        emit NFTMinted(tokenId, recipient, _tokenURI);
        return tokenId;
    }

    // Override _baseURI function to return the base URI for token URIs
    function _baseURI() internal pure override returns (string memory) {
        return "https://api.example.com/nft/";
    }

    // Override tokenURI function to concatenate base URI and token-specific URI
    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        // require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");

        // check _tokenId is not existed

        // require(, "ERC721Metadata: URI query for nonexistent token");

        return string(abi.encodePacked(_baseURI(), tokenURI(_tokenId)));
    }
}

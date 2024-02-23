// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ERC721URIStorageUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

contract NFTPassportIdentity is ERC721URIStorageUpgradeable, AccessControlUpgradeable {

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721URIStorageUpgradeable, AccessControlUpgradeable) returns (bool) {
        return AccessControlUpgradeable.supportsInterface(interfaceId) || ERC721URIStorageUpgradeable.supportsInterface(interfaceId);
    }

    using SafeMath for uint256;
    // using SafeERC20 for IERC20;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    uint256 internal tokenId;

    // Define a struct to represent passport identity
    struct PassportIdentity {
        string name;
        string nationality;
        uint256 dateOfBirth;
        address holder;
    }

    // Mapping from token ID to passport identity details
    mapping(uint256 => PassportIdentity) public passportIdentities;

    // Event emitted when a new passport identity is created
    event PassportIdentityCreated(uint256 indexed tokenId, address indexed holder, string name, string nationality, uint256 dateOfBirth);

    // Constructor
    function initialize() public initializer {
        __ERC721_init("NFT Passport Identity", "NFTPI");
        __AccessControl_init();
        tokenId++;
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(MINTER_ROLE, _msgSender());
    }

    // Mint NFT for passport identity
    function mintPassportIdentity(address holder, string memory name, string memory nationality, uint256 dateOfBirth, string memory _tokenURI) external returns (uint256) {
        require(hasRole(MINTER_ROLE, _msgSender()), "NFT Passport Identity: must have minter role to mint");
        tokenId++;
        _safeMint(holder, tokenId);
        _setTokenURI(tokenId, _tokenURI);
        passportIdentities[tokenId] = PassportIdentity(name, nationality, dateOfBirth, holder);
        emit PassportIdentityCreated(tokenId, holder, name, nationality, dateOfBirth);
        return tokenId;
    }

    // Override _baseURI function to return the base URI for token URIs
    function _baseURI() internal pure override returns (string memory) {
        return "https://api.example.com/nft/passport/";
    }

    // Override tokenURI function to concatenate base URI and token-specific URI
    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        // require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return string(abi.encodePacked(_baseURI(), tokenURI(_tokenId)));
    }
}

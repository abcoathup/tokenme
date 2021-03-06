pragma solidity 0.5.8;

import "./Strings.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol";
import "openzeppelin-solidity/contracts/access/roles/MinterRole.sol";
import "openzeppelin-solidity/contracts/introspection/ERC165.sol";

/**
 * @title TokenMe
 * This implementation includes all the required and some optional functionality of the ERC721 standard
 * Moreover, it includes approve all functionality using operator terminology
 * @dev see https://github.c/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract TokenMe is ERC165, ERC721, ERC721Enumerable, IERC721Metadata, MinterRole {

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Base Token URI
    string private _baseTokenURI;

    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
    /*
     * 0x5b5e139f ===
     *     bytes4(keccak256('name()')) ^
     *     bytes4(keccak256('symbol()')) ^
     *     bytes4(keccak256('tokenURI(uint256)'))
     */

    /**
     * @dev Constructor function
     */
    constructor () public {
        _name = "TokenMe";
        _symbol = "ME";
        _baseTokenURI = "https://abcoathup.github.io/tokenme/apisampledata/tokenme/";

        // register the supported interfaces to conform to ERC721 via ERC165
        _registerInterface(_INTERFACE_ID_ERC721_METADATA);
    }

    /**
     * @dev Gets the token name
     * @return string representing the token name
     */
    function name() external view returns (string memory) {
        return _name;
    }

    /**
     * @dev Gets the token symbol
     * @return string representing the token symbol
     */
    function symbol() external view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns an URI for a given token ID
     * Throws if the token ID does not exist. May return an empty string.
     * @param tokenId uint256 ID of the token to query
     */
    function tokenURI(uint256 tokenId) external view returns (string memory) {
        require(_exists(tokenId), "TokenMe: URI query for nonexistent token");
        return string(abi.encodePacked(baseTokenURI(), Strings.fromUint256(tokenId)));
    }

    /**
     * @dev Gets the base token URI
     * @return string representing the base token URI
     */
    function baseTokenURI() public view returns (string memory) {
        return _baseTokenURI;
    }

    /**
     * @dev Function to mint tokens
     * @param to The address that will receive the minted tokens.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(address to) public onlyMinter returns (bool) {
        uint256 tokenId = _getNextTokenId();
        _mint(to, tokenId);
        return true;
    }

    /**
     * @dev Gets the next Token ID (sequential)
     * @return next Token ID
     */
    function _getNextTokenId() private view returns (uint256) {
        return totalSupply().add(1);
    }
}
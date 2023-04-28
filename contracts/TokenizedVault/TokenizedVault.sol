// SPDX-License-Identifier: UNLICENSED
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

pragma solidity ^0.8.9;

abstract contract TokenizedVault is ERC20 {
    using SafeMath for uint256;
    
    /*//////////////////////////////////////////////////////////////
                            IMMUTABLES
    /////////////////////////////////////////////////////////////*/

    ERC20 public immutable asset;

    constructor(
        ERC20 _asset,
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol) {
        asset = _asset;
    }

    /*//////////////////////////////////////////////////////////////
                           DEPOSIT/WITHDRAWAL LOGIC
    //////////////////////////////////////////////////////////////*/

    function deposit(uint256 assets, address receiver) public view virtual returns (uint256 shares) {
        
    }


    /*//////////////////////////////////////////////////////////////
                            ACCOUNTING LOGIC
    //////////////////////////////////////////////////////////////*/

    function totalAssets() public view virtual returns (uint256) {
        return asset.balanceOf(address(this));
    }

    function convertToShares(uint256 assets) public view virtual returns (uint256) {
        uint256 supply = totalSupply();

        return supply == 0 ? assets : assets.mul(supply).div(totalAssets());
    }                            

    function convertToAssets(uint256 shares) public view virtual returns (uint256) {
        uint256 supply = totalSupply();

        return supply == 0 ? shares: shares.mul(totalAssets()).div(supply);
    }

    function previewDeposit(uint256 assets ) public view virtual returns (uint256){
        return convertToShares(assets);
    }

    /*//////////////////////////////////////////////////////////////
                    DEPOSIT/WITHDRAWAL LIMIT LOGIC
    //////////////////////////////////////////////////////////////*/

    function maxDeposit(address) public view virtual returns (uint256) {
        return type(uint256).max;
    }



}
// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";

pragma solidity ^0.8.20;

abstract contract TokenizedVault is ERC4626 {

    // a mapping that checks if a user has deposited the token
    mapping (address => uint256) public shareHolder;

    // ERC-4626 LIBRARY
    constructor(
        ERC20 _asset,
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol, _asset.decimals()) {
        asset = _asset;
    }

    /*//////////////////////////////////////////////////////////////
                           DEPOSIT/WITHDRAWAL LOGIC
    //////////////////////////////////////////////////////////////*/

    /**
     * 
     * @notice function to deposit assets and receive vault token in exchange 
     * @param  _assets amount of the asset token
     */
    function _deposit(uint _assets) public 
    {
        // checks that the deposited amount is greater than zero
        require(_assets > 0, "Deposit less than zero");
        // calling the deposit function ERC-4626 library to perform all the functionality
        deposit(_assets, msg.sender);
        // Increase the share of the user
        shareHolder[msg.sender] += _assets;
    }

    /**
     * @notice Function to allow msg.sender to withdraw their deposit plus accrued interest
     * @param _shares amount of shares the user wants to convert
     * @param _receiver address of the user who will receive the assets
     */
    function _withdraw(uint _shares, address _receiver) public 
    {
        // checks that the deposited amount is greater than zero.
        require(_shares > 0, "withdraw must be greater than Zero"");
        // Checks that the _receiver address is not zero.
        require(_receiver != address(0), "Zero Address");
        // checks that the caller is a shareholder
        require(shareHolder[msg.sender] > 0, "Not a shareHolder");
        // checks that the caller has more shares than they are trying to withdraw.
        require(shareHolder[msg.sender]>= _shares, "No enough shares");
        // Calculate 10% yield on the withdraw amount
        uint256 percent = (10 * _shares) / 100;
        // Calculate the total asset amount as the sum of the share amount plus 10% of the share amount.
        uint assets = _shares + percent;
        // calling the redeem function from the ERC-4626 library to perform all the necessary functionality
        redeem(assets, _receiver, msg.sender);
        // Decrease shares of the user
        shareHolder[msg.sender] -= _shares;

    }

    // returns total number of assets
    function totalAssets() public view override returns (uint256) {
        return asset.balanceOf(address(this));
    }

    // returns total balance of user
    function totalAssetsOfUser(address _user) public view returns (uint256) 
    {   
        return asset.balanceOf(user);
    }
}
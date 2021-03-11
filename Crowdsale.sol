pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale,CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {

    constructor(
        // @TODO: Fill in the constructor parameters!
        uint rate, //1 TKN per Ether
        address payable wallet,  //address to receive the crowdsale funds
        PupperCoin token, //PupperCoin token is used for the crowdsale
        uint cap, //max amount of coins allowed to be sold - limit is 300 ETH
        uint closingTime, //ending time for the crowdsale open period
        uint openingTime //start of the crowdsale
        //uint goal //goal for the amount of coins to sell, amount to raise in ether

    )
        // @TODO: Pass the constructor parameters to the crowdsale contracts.
         Crowdsale(rate, wallet, token)
        CappedCrowdsale(cap)
        TimedCrowdsale(openingTime, closingTime)
        RefundableCrowdsale (cap)
        public
    {
        // constructor can stay empty
    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;

    constructor(
        // @TODO: Fill in the constructor parameters!
        string memory name,
        string memory symbol,
        address payable wallet, //address to receive the crowdsale funds
        uint cap 
    )
        public
    {
        // @TODO: create the PupperCoin and keep its address handy
           PupperCoin token = new PupperCoin(name, symbol, 0);
           token_address = address(token);


        // @TODO: create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
            PupperCoinSale puppercoin_sale = new PupperCoinSale(1, wallet, token, cap, now + 15 minutes, now);
            token_sale_address = address (puppercoin_sale);

        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}
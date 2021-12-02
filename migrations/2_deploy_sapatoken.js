var Migrations = artifacts.require("Migrations");
var SAPAToken = artifacts.require("SAPAToken");

module.exports = function(deployer, network, accounts) {
    if (network == "development") {
        deployer.deploy(SAPAToken, {from: accounts[0]});
    } else {
        deployer.deploy(SAPAToken);
    }
}
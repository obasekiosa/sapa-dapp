var Migrations = artifacts.require("./Migrations.sol");
var StoryDao = artifacts.require("./StoryDao.sol");


module.exports = function (deployer, network, accounts) {
    if (network == "development") {
        deployer.deploy(StoryDao, { from: accounts[0] });
    } else {
        deployer.deploy(StoryDao);
    }
}
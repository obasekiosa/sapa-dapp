import expectThrow from '../helpers/expectThrow';

const StoryDao = artifacts.require("StoryDao");


contract('StoryDao Test', async (accounts) => {
    
    it("should make sure environment is OK by checking that the first 3 accounts have over 20 eth",
     async () =>{
         assert.equal(Number(await web3.eth.getBalance(accounts[0])) > 2e+19, true, "Account 0 has more than 20 eth");
         assert.equal(Number(await web3.eth.getBalance(accounts[1])) > 2e+19, true, "Account 1 has more than 20 eth");
         assert.equal(Number(await web3.eth.getBalance(accounts[2])) > 2e+19, true, "Account 2 has more than 20 eth");
    });

    it("should make the deployer is the owner",
     async () => {
        let instance = await StoryDao.deployed();
        assert.equal(await instance.owner(), accounts[0]);
    });

    it("should let owner change fee and duration",
        async () => {
            let instance = await StoryDao.deployed();
            let newDaoFee = 50;
            let newWhitelistFee = 1e+10; // 1 ether
            let newDayDuration = 42;
            let newSubsDuration = 1500;

            await instance.changeDaoFee(newDaoFee, { from: accounts[0] });
            await instance.changeWhitelistFee(newWhitelistFee, { from: accounts[0] });
            await instance.changeDurationDays(newDayDuration, { from: accounts[0] });
            await instance.changeDurationSubmissions(newSubsDuration, { from: accounts[0] });
            
            assert.equal(await instance.daoFee(), newDaoFee);
            assert.equal(await instance.whitelistFee(), newWhitelistFee);
            assert.equal(await instance.durationDays(), newDayDuration);
            assert.equal(await instance.durationSubmissions(), newSubsDuration);
    });

    it("should forbid non-owners from changing fee and duration", async () => {
        let instance = await StoryDao.deployed();
        let newDaoFee = 50;
        let newWhitelistFee = 1e+10; // 1 ether
        let newDayDuration = 42;
        let newSubsDuration = 1500;
        await expectThrow(instance.changeDaoFee(newDaoFee, { from: accounts[1] }));
        await expectThrow(instance.changeWhitelistFee(newWhitelistFee, { from: accounts[1] }));
        await expectThrow(instance.changeDurationDays(newDayDuration, { from: accounts[1] }));
        await expectThrow(instance.changeDurationSubmissions(newSubsDuration, { from: accounts[1] }));
    });

    it("should make sure the owner can only change fees and duration to valid values", async () =>{
        let instance = await StoryDao.deployed();
        let invalidDaoFee = 20000;
        let invalidDayDuration = 0;
        let invalidSubsDuration = 98;
        await expectThrow(instance.changeDaoFee(invalidDaoFee, { from: accounts[0] }));
        await expectThrow(instance.changeDurationDays(invalidDayDuration, { from: accounts[0] }));
        await expectThrow(instance.changeDurationSubmissions(invalidSubsDuration, { from: accounts[0] }));
    });
});
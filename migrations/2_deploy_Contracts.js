const ProductScan = artifacts.require('ProductScan');

module.exports = async function (deployer) {
    await deployer.deploy(ProductScan);
};

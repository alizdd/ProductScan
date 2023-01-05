const assert = require('assert').strict;

const Bagis = artifacts.require('ProductScan');

contract('Urun Ekleme', (accounts) => {
	describe('Product Scan:', () => {
		it('Ürün ekle', async () => {
			var deployer = accounts[0];
     
			const ProductScan = await Bagis.deployed();

			const initial = await web3.eth.getBalance(accounts[1]);
			console.log(`Initial: ${initial.toString()}`);

			// uint256 _productId,
			// bytes32 _secretId,
			// uint256 _price,
			// string memory _name,
			// string memory _details,
			// uint _productionDate


			
			
		})
		it('Ürünü IDsi ile tarat', async () => {
			
		})
		it('Ürünü satın al', async () => {
			
		})
		it('Ürünü sat', async () => {
			
		})
		it('Ürünlerimi göster', async () => {
			
		})
	});
});
const assert = require('assert').strict;

const PScan = artifacts.require('ProductScan');

contract('PScan', (accounts) => {
	describe('Product Scan:', () => {
		it('Ürün ekle', async () => {

			const ProductScan = await PScan.deployed();

			const initial = await web3.eth.getBalance(accounts[1]);
			console.log(`Account 1 Balance Initial: ${initial.toString()}`);

			// uint256 _productId,
			// bytes32 _secretId,
			// uint256 _price,
			// string memory _name,
			// string memory _details,
			// uint _productionDate

			// var test = await ProductScan.getAllOwnedProducts({from: accounts[1], gas: 3000000});
			// console.log("Test: ", test);
			// return;

			console.log("ÜRÜNÜ EKLE");

			var test1 = await ProductScan.addProduct(4532452, "0x6d6168616d000000000000000000000000000000000000000000000000000000", 455, "Nike Air Jordan Luka 1", "Luka'nın adını taşıyan ilk ayakkabı, 77 numarasını formasında taşıyan oyuncu için tasarlandı ve hız ile verimlilik arayışındaki tüm sporcular için geliştirildi.", 1638352800, {from: accounts[1], gas: 3000000});//2012-12-01 10:00:00
			//Not: Solidity'de Date'ler 1 Ocak 1970'den itibaren geçen saniyeler cinsinden hesaplanır.

			//console.log("Test 1 add product: ", test1);

			var test2 = await ProductScan.addProduct(5234523, "0x5433523453000000000000000000000000000000000000000000000000000000", 328, "Air Jordan 1 Retro High OG", "Air Jordan 1 Retro High OG", 1638352800, {from: accounts[1], gas: 3000000});
			//Not: Solidity'de Date'ler 1 Ocak 1970'den itibaren geçen saniyeler cinsinden hesaplanır.

			//console.log("Test 2 add product: ", test2);

			//Sistemdeki ürün sayısı sadece contract sahibi tarafından çağırılabiliyor
			var test3 = await ProductScan.productLength({from: accounts[0]});
			
			console.log("Sistemdeki Ürün sayısı ", test3);
			
			
		})
		it('Ürünü IDsi ile tarat', async () => {

			const ProductScan = await PScan.deployed();

			console.log("ÜRÜNÜ ID'Si İLE TARAT");

			var test1 = await ProductScan.productDetails(4532452 ,{from: accounts[8], gas: 3000000});

			console.log("Test 1 get product: ", test1);

			var test2 = await ProductScan.productDetails(5234523 ,{from: accounts[8]});

			console.log("Test 2 get product: ", test2);

			var test3 = await ProductScan.productDetails(2425645 ,{from: accounts[8]}); //Sistemde bulunmuyor

			console.log("Test 3 get product: ", test3);

			//productDetails(uint256 _productId)
		})
		it('Ürünü satın al', async () => {
			const ProductScan = await PScan.deployed();

			console.log("ÜRÜN SATIN AL");

			var test1 = await ProductScan.buyProduct("0x6d6168616d000000000000000000000000000000000000000000000000000000" ,{from: accounts[5], gas: 3000000});

			//console.log("Buy Product", test1);

			var test2 = await ProductScan.productDetails(4532452 ,{from: accounts[5], gas: 3000000});

			console.log("Product Status After Buy", test2);


			//var test3 = await ProductScan.buyProduct("0x432368616d000000000000000000000000000000000000000000000000000000" ,{from: accounts[5], gas: 3000000});

			//console.log("Buy Non Existing Product", test3);

			//function buyProduct(bytes32 _secretId)

		})
		it('Ürünü sat', async () => {
			const ProductScan = await PScan.deployed();

			console.log("ÜRÜN SAT");

			//Ürün satışının ürünün sahibi tarafından yapılması kontrol edilir.
			var test1 = await ProductScan.sellProduct(5234523 , "0x7B574D642CCfc5c52CF27eFdD2609e95c9835f45", {from: accounts[1], gas: 3000000});

			//console.log("Sell Product: ", test1);

			var test2 = await ProductScan.productDetails(5234523 ,{from: accounts[3], gas: 3000000});

			//sellProduct(uint256 _productId, address _buyerAddress)

		})
		it('Ürünlerimi göster', async () => {
			const ProductScan = await PScan.deployed();

			console.log("ÜRÜNLERİMİ GÖSTER");


			var test1 = await ProductScan.getAllOwnedProducts({from: accounts[4], gas: 3000000});

			console.log("Ürünü satın alan kullanıcı: ", test1);

			var test2 = await ProductScan.getAllOwnedProducts({from: accounts[5], gas: 3000000});

			console.log("Ürünün satıldığı kullanıcı:", test2);

			//var test3 = await ProductScan.getAllOwnedProducts({from: accounts[1], gas: 3000000});

			//console.log("Ürünü olmayan kullanıcı:", test3);


			//getAllOwnedProducts()

		})
	});
});
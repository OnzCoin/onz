var moment = require('moment');
var fs = require('fs');
var path = require('path');
var onzjs = require('onz-js');
var crypto = require('crypto');
var bip39 = require('bip39');
var ByteBuffer = require('bytebuffer');
var bignum = require('../helpers/bignum.js');

var totalpremine = 10000000000000000;
var private_dir = './genesisBlock';

var genesis_vote = {
  secret: "slam canyon garage split chat match float hurdle eagle tube theme gadget",
  address: "ONZgEDjjxY1una6AaYHfwXjiaT32KZnnwUHG"
}

var genesisAccounts = [
                        {address:genesis_vote.address, total:2000000000000000},
                        {address:"ONZfyLzBNeFBrKAiKCGdD7sKdakA73itzGET", total:8000000000000000}
                      ];

makeKeypair = function (seed) {
	return onzjs.crypto.getKeys(seed, network);
};

sign = function (block, keypair) {
  var hash = this.getHash(block);
  var signature = naclInstance.crypto_sign_detached(hash, Buffer.from(keypair.privateKey, 'hex'));
  return Buffer.from(signature).toString('hex');
};

getId = function (block) {
  var hash = crypto.createHash('sha256').update(this.getBytes(block)).digest('hex');
  return hash;
};

getHash = function (block) {
	return crypto.createHash('sha256').update(getBytes(block)).digest();
};

getBytes = function (block) {
  function assignHexToTransactionBytes (partTransactionBuffer, hexValue) {
    var hexBuffer = Buffer.from(hexValue, 'hex');
    for (var i = 0; i < hexBuffer.length; i++) {
      partTransactionBuffer.writeByte(hexBuffer[i]);
    }
    return partTransactionBuffer;
  }

  var size = 4 + 4 + 32 + 4 + 4 + 8 + 8 + 4 + 4 + 4 + 32 + 32 + 64;
  var b, i;

  try {
    var bb = new ByteBuffer(size, true);
    bb.writeInt(block.version);
    bb.writeInt(block.timestamp);

    if (block.previousBlock) {
      assignHexToTransactionBytes(bb, block.previousBlock);
    } else {
      for (i = 0; i < 32; i++) {
        bb.writeByte(0);
      }
    }
    
    bb.writeInt(block.numberOfTransactions);
    bb.writeLong(block.totalAmount);
    bb.writeLong(block.totalFee);
    bb.writeLong(block.reward);

    bb.writeInt(block.payloadLength);

    var payloadHashBuffer = Buffer.from(block.payloadHash, 'hex');
    for (i = 0; i < payloadHashBuffer.length; i++) {
      bb.writeByte(payloadHashBuffer[i]);
    }

    var generatorPublicKeyBuffer = Buffer.from(block.generatorPublicKey, 'hex');
    for (i = 0; i < generatorPublicKeyBuffer.length; i++) {
      bb.writeByte(generatorPublicKeyBuffer[i]);
    }

    if (block.blockSignature) {
      var blockSignatureBuffer = Buffer.from(block.blockSignature, 'hex');
      for (i = 0; i < blockSignatureBuffer.length; i++) {
        bb.writeByte(blockSignatureBuffer[i]);
      }
    }

    bb.flip();
    b = bb.toBuffer();
  } catch (e) {
    throw e;
  }

  return b;
};

create = function (data) {
	var transactions = data.transactions.sort(function compare(a, b) {
		if (a.type < b.type) { return -1; }
		if (a.type > b.type) { return 1; }
		if (a.amount < b.amount) { return -1; }
		if (a.amount > b.amount) { return 1; }
		return 0;
	});

	var nextHeight = 1;

	var reward = 0,
	    totalFee = 0, totalAmount = 0, size = 0;

	var blockTransactions = [];
	var payloadHash = crypto.createHash('sha256');

	for (var i = 0; i < transactions.length; i++) {
		var transaction = transactions[i];
		var bytes = onzjs.crypto.getBytes(transaction);

		size += bytes.length;

		totalFee += transaction.fee;
		totalAmount += transaction.amount;

		blockTransactions.push(transaction);
		payloadHash.update(bytes);
	}

	var block = {
		version: 0,
		totalAmount: totalAmount,
		totalFee: totalFee,
		reward: reward,
		payloadHash: payloadHash.digest().toString('hex'),
		timestamp: data.timestamp,
		numberOfTransactions: blockTransactions.length,
		payloadLength: size,
		previousBlock: null,
		generatorPublicKey: data.keypair.publicKey.toString('hex'),
		transactions: blockTransactions,
    height:1
	};

  block.id=getId(block);

	try {
		block.blockSignature = sign(block, data.keypair);
	} catch (e) {
		throw e;
	}

	return block;
}

var delegates = [];
var transactions = [];
var remainingfund = {};

var genesis = {
  passphrase: bip39.generateMnemonic(),
  balance: totalpremine
};

genesis.publicKey = onzjs.crypto.getKeys(genesis.passphrase).publicKey;
genesis.address = onzjs.crypto.getAddress(genesis.publicKey);

// creation of delegates
for(var i=0; i<102; i++){
  var delegate = {
    'passphrase': bip39.generateMnemonic(),
    'username': "genesis_"+i
  };

	delegate.publicKey = onzjs.crypto.getKeys(delegate.passphrase).publicKey;
	delegate.address = onzjs.crypto.getAddress(delegate.publicKey);

	// create delegate
  var createDelegateTx = onzjs.delegate.createDelegate(delegate.passphrase, delegate.username);
  createDelegateTx.fee = 0;
  createDelegateTx.timestamp = 0;
  createDelegateTx.senderId = delegate.address;
  createDelegateTx.signature = onzjs.crypto.sign(createDelegateTx,onzjs.crypto.getKeys(delegate.passphrase));
  createDelegateTx.id = onzjs.crypto.getId(createDelegateTx);

  transactions.push(createDelegateTx);

  delegates.push(delegate);
  //voting, split per one to fit different limits
  var votes = [];
  votes.push("+"+delegate.publicKey);
  var genesis_vote_pk = onzjs.crypto.getKeys(genesis_vote.secret).publicKey;
  var VoteTX = onzjs.vote.createVote(genesis_vote.secret, votes, null, 0);
  VoteTX.fee = 0;
  VoteTX.timestamp = 0;
  VoteTX.senderId = delegate.address;
  VoteTX.signature = onzjs.crypto.sign(VoteTX,onzjs.crypto.getKeys(delegate.passphrase));
  VoteTX.id = onzjs.crypto.getId(VoteTX);
  transactions.push(VoteTX);
}

var total = 0;

for(var i=0; i < genesisAccounts.length; i++){
  var account = genesisAccounts[i];
  total += account.total;
  console.log(account.address);
  console.log(account.total);
	var premineTx = onzjs.transaction.createTransaction(account.address, account.total, genesis.passphrase, null, 0);
	premineTx.fee = 0;
	premineTx.timestamp = 0;
	premineTx.senderId = genesis.address;
	premineTx.signature = onzjs.crypto.sign(premineTx,onzjs.crypto.getKeys(genesis.passphrase));
	premineTx.id = onzjs.crypto.getId(premineTx);
	transactions.push(premineTx);
}

var genesisBlock = create({
  keypair: onzjs.crypto.getKeys(genesis.passphrase),
  transactions:transactions,
  timestamp:0
});


fs.writeFile(private_dir+"/genesisBlock.json",JSON.stringify(genesisBlock, null, 2));
fs.writeFile(private_dir+"/delegatesPassphrases.json", JSON.stringify(delegates, null, 2));
fs.writeFile(private_dir+"/genesisPassphrase.json", JSON.stringify(genesis, null, 2));
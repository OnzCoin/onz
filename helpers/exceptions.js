'use strict';
/**
 * @namespace exceptions
 * @memberof module:helpers
 * @property {object} genesisPublicKey
 * @property {string} genesisPublicKey.mainnet
 * @property {string} genesisPublicKey.testnet
 * @property {Strin[]} senderPublicKey
 * @property {Strin[]} signatures
 * @property {Strin[]} multisignatures
 * @property {Strin[]} votes
 */	
module.exports = {
	blockRewards: [],
	delegates: [],
	genesisPublicKey: {
		mainnet: '984ca092212d4ff815e659fac64d844286f0df250b1c7768199e2648555617b8',
		testnet: '984ca092212d4ff815e659fac64d844286f0df250b1c7768199e2648555617b8'
	},
	rounds: {
		'27040': {rewards_factor: 2, fees_factor: 2, fees_bonus: 10000000}
	},
	senderPublicKey: [
	],
	signatures: [
	],
	multisignatures: [
	],
	votes: [
	]
};

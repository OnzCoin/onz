'use strict';

/**
 * @namespace constants
 * @memberof module:helpers
 * @property {number} activeDelegates - The default number of delegates.
 * @property {number} maxVotesPerTransaction - The maximum number of votes in vote type transaction.
 * @property {number} addressLength - The default address length.
 * @property {number} blockHeaderLength - The default block header length.
 * @property {number} blockReceiptTimeOut
 * @property {number} confirmationLength
 * @property {Date} epochTime
 * @property {object} fees - The default values for fees.
 * @property {number} fees.send
 * @property {number} fees.vote
 * @property {number} fees.secondsignature
 * @property {number} fees.delegate
 * @property {number} fees.multisignature
 * @property {number} fees.dapp
 * @property {number} feeStart
 * @property {number} feeStartVolume
 * @property {number} fixedPoint
 * @property {number} maxAddressesLength
 * @property {number} maxAmount
 * @property {number} maxConfirmations
 * @property {number} maxPayloadLength
 * @property {number} maxPeers
 * @property {number} maxRequests
 * @property {number} maxSharedTxs
 * @property {number} maxSignaturesLength
 * @property {number} maxTxsPerBlock
 * @property {number} minBroadhashConsensus
 * @property {string[]} nethashes - Mainnet and Testnet.
 * @property {number} numberLength
 * @property {number} requestLength
 * @property {object} rewards
 * @property {number[]} rewards.milestones - Initial 5, and decreasing until 1.
 * @property {number} rewards.offset - Start rewards at block (n).
 * @property {number} rewards.distance - Distance between each milestone
 * @property {number} signatureLength
 * @property {number} totalAmount
 * @property {number} unconfirmedTransactionTimeOut - 1080 blocks
 */
module.exports = {
	activeDelegates: 101,
	maxVotesPerTransaction: 33,
	addressLength: 208,
	blockHeaderLength: 248,
	blockReceiptTimeOut: 20, // 2 blocks
	confirmationLength: 77,
	epochTime: new Date(Date.UTC(2016, 4, 24, 17, 0, 0, 0)),
	fees: {
		send: 10000000,
		vote: 100000000,
		secondsignature: 500000000,
		delegate: 20000000000,
		multisignature: 500000000,
		dapp: 20000000000
	},
	feeStart: 1,
	feeStartVolume: 10000 * 100000000,
	fixedPoint: Math.pow(10, 8),
	maxAddressesLength: 208 * 128,
	maxAmount: 100000000,
	maxConfirmations: 77 * 100,
	maxPayloadLength: 1024 * 1024,
	maxPeers: 100,
	maxRequests: 10000 * 12,
	maxSharedTxs: 100,
	maxSignaturesLength: 196 * 256,
	maxTxsPerBlock: 25,
	minBroadhashConsensus: 51,
	nethashes: [
		// Mainnet
		'053ef5853fc3d1e73cc55186c789f69be14c14d48bf748b4c9a5775c8de1056b',
		// Testnet
		'c6118f371269a8f3c5e26ce2d24fd168131ea356e22bfe44600a6b3122b1dabc'
	],
	numberLength: 100000000,
	requestLength: 104,
	// WARNING: When changing rewards you also need to change getBlockRewards(int) SQL function!
	rewards: {
		milestones: [
			5000000000, // Year 1 (M1-M6)
			5000000000,
			5000000000,
			5000000000,
			5000000000,
			5000000000,
			4000000000, // Year 1 (M7-M12)
			4000000000,
			4000000000,
			4000000000,
			4000000000,
			4000000000,
			3500000000, // Year 2 (M1-M6)
			3500000000,
			3500000000,
			3500000000,
			3500000000,
			3500000000,
			3000000000, // Year 2 (M7-M12)
			3000000000,
			3000000000,
			3000000000,
			3000000000,
			3000000000,
			2500000000, // Year 3
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000, // Year 4
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000, // Year 5
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000, // Year 6
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000, // Year 7
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2500000000,
			2000000000, // Year 8
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000, // Year 9
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000, // Year 10
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000, // Year 11
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000, // Year 12
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			2000000000,
			1000000000, // Year 13
			1000000000,
			1000000000,
			1000000000,
			1000000000,
			1000000000,
			1000000000,
			1000000000,
			1000000000,
			1000000000,
			1000000000,
			1000000000,
			900000000, // Year 14
			900000000,
			900000000,
			900000000,
			900000000,
			900000000,
			900000000,
			900000000,
			900000000,
			900000000,
			900000000,
			900000000,
			800000000, // Year 15
			800000000,
			800000000,
			800000000,
			800000000,
			800000000,
			800000000,
			800000000,
			800000000,
			800000000,
			800000000,
			800000000,
			700000000, // Year 16
			700000000,
			700000000,
			700000000,
			700000000,
			700000000,
			700000000,
			700000000,
			700000000,
			700000000,
			700000000,
			700000000,
			600000000, // Year 17
			600000000,
			600000000,
			600000000,
			600000000,
			600000000,
			600000000,
			600000000,
			600000000,
			600000000,
			600000000,
			600000000,
			500000000, // Year 18
			500000000,
			500000000,
			500000000,
			500000000,
			500000000,
			500000000,
			500000000,
			500000000,
			500000000,
			500000000,
			500000000,
			400000000, // Year 19
			400000000,
			400000000,
			400000000,
			400000000,
			400000000,
			400000000,
			400000000,
			400000000,
			400000000,
			400000000,
			400000000,
			300000000, // Year 20
			300000000,
			300000000,
			300000000,
			300000000,
			300000000,
			300000000,
			300000000,
			300000000,
			300000000,
			300000000,
			300000000,
			200000000, // Year 21
			200000000,
			200000000,
			200000000,
			200000000,
			200000000,
			200000000,
			200000000,
			200000000,
			200000000,
			200000000,
			200000000,
			100000000, // Year 22
			100000000,
			100000000,
			100000000,
			100000000,
			100000000,
			100000000,
			100000000,
			100000000,
			100000000,
			100000000,
			100000000
		],
		offset: 1,   // Start rewards at block (n)
		distance: 172800, // Distance between each milestone (30 days)
	},
	signatureLength: 196,
	// WARNING: When changing totalAmount you also need to change getBlockRewards(int) SQL function!
	totalAmount: 18000000000000000,
	unconfirmedTransactionTimeOut: 10800, // 1080 blocks
	multisigConstraints: {
		min: {
			minimum: 1,
			maximum: 15
		},
		lifetime: {
			minimum: 1,
			maximum: 72
		},
		keysgroup: {
			minItems: 1,
			maxItems: 15
		}
	}
};

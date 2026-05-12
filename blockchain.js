/**
 * 最小区块链模拟（Node.js）
 * - PoW：区块哈希（SHA256 十六进制）需以 4 个 0 开头
 * - 每个区块含 previous_hash，与上一块串联
 */

const crypto = require("crypto");

/** PoW 难度：哈希十六进制前缀连续 0 的个数 */
const DIFFICULTY = 4;
const TARGET_PREFIX = "0".repeat(DIFFICULTY);

function sha256Hex(data) {
  return crypto.createHash("sha256").update(data, "utf8").digest("hex");
}

/** 参与哈希的载荷（含 proof，挖矿时递增 proof） */
function blockHeaderString({ index, timestamp, transactions, previous_hash, proof }) {
  return JSON.stringify({
    index,
    timestamp,
    transactions,
    previous_hash,
    proof,
  });
}

function blockHash(block) {
  return sha256Hex(blockHeaderString(block));
}

/**
 * 寻找 proof，使 sha256(区块头字符串) 以 DIFFICULTY 个十六进制 0 开头
 */
function mineProof(partialBlock) {
  let proof = 0;
  for (;;) {
    const candidate = { ...partialBlock, proof };
    const h = blockHash(candidate);
    if (h.startsWith(TARGET_PREFIX)) {
      return candidate;
    }
    proof += 1;
  }
}

function createGenesisBlock() {
  const partial = {
    index: 0,
    timestamp: Math.floor(Date.now() / 1000),
    transactions: [{ sender: "SYSTEM", recipient: "GENESIS", amount: 0 }],
    previous_hash: "0",
  };
  return mineProof(partial);
}

function createNextBlock(previousBlock, transactions) {
  const partial = {
    index: previousBlock.index + 1,
    timestamp: Math.floor(Date.now() / 1000),
    transactions,
    previous_hash: blockHash(previousBlock),
  };
  return mineProof(partial);
}

function main() {
  console.log("最小区块链 — PoW 前缀:", TARGET_PREFIX, "\n");

  const genesis = createGenesisBlock();
  console.log("创世区块:");
  console.log(JSON.stringify(genesis, null, 2));
  console.log("区块哈希:", blockHash(genesis), "\n");

  const block1 = createNextBlock(genesis, [
    { sender: "alice", recipient: "bob", amount: 5 },
  ]);
  console.log("区块 #1:");
  console.log(JSON.stringify(block1, null, 2));
  console.log("区块哈希:", blockHash(block1), "\n");

  const block2 = createNextBlock(block1, [
    { sender: "bob", recipient: "carol", amount: 2 },
    { sender: "carol", recipient: "alice", amount: 1 },
  ]);
  console.log("区块 #2:");
  console.log(JSON.stringify(block2, null, 2));
  console.log("区块哈希:", blockHash(block2), "\n");

  // 校验链
  const chain = [genesis, block1, block2];
  for (let i = 1; i < chain.length; i++) {
    const prev = chain[i - 1];
    const cur = chain[i];
    const okHash = cur.previous_hash === blockHash(prev);
    const okPow = blockHash(cur).startsWith(TARGET_PREFIX);
    console.log(
      `校验 区块#${cur.index}: previous_hash 匹配=${okHash}, PoW 有效=${okPow}`,
    );
  }
}

main();

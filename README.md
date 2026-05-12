# blockchain-demo

演示用最小区块链：Python 版简单 PoW（`pow.py`），以及 JavaScript 版带链式结构的区块（`blockchain.js`）。

## `blockchain.js` 说明

- **PoW**：对区块头做 `SHA256`，十六进制摘要需以连续 **4 个 `0`** 开头（与 `pow.py` 中「4 个十六进制 0」一致）。
- **串联**：每个区块的 `previous_hash` 为**上一区块**的区块哈希；创世块使用固定 `previous_hash: "0"`。

### 区块结构（参考）

```json
{
  "index": 1,
  "timestamp": 1506057125,
  "transactions": [
    { "sender": "xxx", "recipient": "xxx", "amount": 5 }
  ],
  "proof": 324984774000,
  "previous_hash": "xxxx"
}
```

参与挖矿与校验的字段为：`index`、`timestamp`、`transactions`、`previous_hash`、`proof`（`proof` 递增直到哈希满足难度）。

## 运行说明

1. 安装 [Node.js](https://nodejs.org/)（建议 LTS，自带 `node`）。
2. 在项目根目录执行：

```bash
node blockchain.js
```

无需额外依赖，仅使用 Node 内置 `crypto` 模块。

## 运行日志（示例）

以下为一次本地运行的完整终端输出（`timestamp` 与 `proof` 每次运行会不同；哈希前缀均为 `0000`）。

```
最小区块链 — PoW 前缀: 0000 

创世区块:
{
  "index": 0,
  "timestamp": 1778550012,
  "transactions": [
    {
      "sender": "SYSTEM",
      "recipient": "GENESIS",
      "amount": 0
    }
  ],
  "previous_hash": "0",
  "proof": 3859
}
区块哈希: 000002c634a3486c52b1d85a0dd5574f76db88d3dce0933f0f956e302bdd0208 

区块 #1:
{
  "index": 1,
  "timestamp": 1778550012,
  "transactions": [
    {
      "sender": "alice",
      "recipient": "bob",
      "amount": 5
    }
  ],
  "previous_hash": "000002c634a3486c52b1d85a0dd5574f76db88d3dce0933f0f956e302bdd0208",
  "proof": 35499
}
区块哈希: 0000e0661aaa14b51db90e1f8b3d54355915f1d0ae541e4a25d34574784d9e67 

区块 #2:
{
  "index": 2,
  "timestamp": 1778550012,
  "transactions": [
    {
      "sender": "bob",
      "recipient": "carol",
      "amount": 2
    },
    {
      "sender": "carol",
      "recipient": "alice",
      "amount": 1
    }
  ],
  "previous_hash": "0000e0661aaa14b51db90e1f8b3d54355915f1d0ae541e4a25d34574784d9e67",
  "proof": 61676
}
区块哈希: 00002ebc24f5d7c878df06a6a19a84fd235b387e178a11e06f5b67b3e785cb13 

校验 区块#1: previous_hash 匹配=true, PoW 有效=true
校验 区块#2: previous_hash 匹配=true, PoW 有效=true
```

### 截图

可将上述命令在终端中执行后，对窗口截屏保存为项目内图片（例如 `docs/run-screenshot.png`），并在本段下方用 Markdown 引用：`![运行截图](docs/run-screenshot.png)`。

## 其他

```bash
python3 pow.py
```

运行 Python 版昵称 + nonce 的 PoW 演示。

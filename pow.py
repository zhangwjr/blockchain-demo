#!/usr/bin/env python3
"""Simple SHA256-based Proof of Work: find nonce so hash(nickname + nonce) has leading hex zeros."""

import hashlib
import time

# 修改为你的昵称
NICKNAME = "zhangweijia"


def sha256_hex(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


def mine(nickname: str, leading_zeros: int) -> tuple[str, int, float]:
    """
    Increment nonce until SHA256(nickname + nonce) hex digest starts with `leading_zeros` '0's.
    Returns (content_str, nonce, elapsed_seconds).
    """
    prefix = "0" * leading_zeros
    nonce = 0
    start = time.perf_counter()
    while True:
        content = f"{nickname}{nonce}"
        digest = sha256_hex(content)
        if digest.startswith(prefix):
            elapsed = time.perf_counter() - start
            return content, nonce, elapsed
        nonce += 1


def main() -> None:
    for zeros in (4, 5):
        content, nonce, elapsed = mine(NICKNAME, zeros)
        digest = sha256_hex(content)
        print(f"--- 目标: 哈希值以 {zeros} 个十六进制 0 开头 ---")
        print(f"花费时间: {elapsed:.6f} 秒")
        print(f"Hash 的内容: {content!r}")
        print(f"nonce: {nonce}")
        print(f"Hash 值: {digest}")
        print()


if __name__ == "__main__":
    main()

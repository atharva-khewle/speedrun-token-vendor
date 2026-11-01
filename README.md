# Token Vendor

![hero](packages/nextjs/public/hero.png)

An ERC20 token with a vending-machine contract to buy and sell it for ETH.

- **Live demo:** https://token3vendor.vercel.app/
- **Contract (Sepolia):** [0x241e1B8D3Fb3eCD99E3aCF76a33Ed3B256D12742](https://sepolia.etherscan.io/address/0x241e1B8D3Fb3eCD99E3aCF76a33Ed3B256D12742)
- **Stack:** Scaffold-ETH 2, Foundry, Next.js, wagmi/viem

![screenshot](https://github.com/scaffold-eth/se-2-challenges/assets/55535804/7669cc68-e942-4630-95c8-91cd21af5ba0)

## Tech and flow

- **Solidity + OpenZeppelin** (`ERC20`, `Ownable`): `YourToken` is a fixed-supply token. `Vendor` buys and sells it at 100 tokens per ETH.
- **ERC20 approve pattern**: selling needs `approve` then `transferFrom`.
- **Foundry**: build, test, deploy to Sepolia.
- **Next.js + wagmi/viem + RainbowKit**: buy, approve, sell, and event list.

```mermaid
flowchart LR
    U[User] -->|buyTokens: ETH| V[Vendor]
    V -->|transfer tokens| U
    U -->|approve Vendor| T[YourToken ERC20]
    U -->|sellTokens amount| V
    V -->|transferFrom user| T
    V -->|send ETH| U
    O[Owner] -->|withdraw| V
```

Part of [SpeedRunEthereum](https://speedrunethereum.com).

1 //SPDX-License-Identifier: Unlicense
2 
3 pragma solidity 0.6.12;
4 
5 import "../Vault.sol";
6 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol";
7 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";
8 
9 import "../interface/pancakeswap/IPancakeRouter02.sol";
10 
11 interface IBASSwap {
12   function swap(uint256 amount) external;
13 }
14 
15 contract VaultMigratable_Pancake_USDT_BNB is Vault {
16   using SafeBEP20 for IBEP20;
17 
18   // token 1 = USDT , token 2 = WBNB
19   address public constant __USDT = address(0x55d398326f99059fF775485246999027B3197955);
20   address public constant __BNB = address(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
21 
22   address public constant __USDT_BNB = address(0x20bCC3b8a0091dDac2d0BC30F68E6CBb97de59Cd);
23 
24   address public constant __USDT_BNB_V2 = address(0x16b9a82891338f9bA80E2D6970FddA79D1eb0daE);
25 
26   address public constant __PANCAKE_OLD_ROUTER = address(0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F);
27   address public constant __PANCAKE_NEW_ROUTER = address(0x10ED43C718714eb63d5aA57B78B54704E256024E);
28 
29   address public constant __governance = address(0xf00dD244228F51547f0563e60bCa65a30FBF5f7f);
30 
31   event Migrated(uint256 v1Liquidity, uint256 v2Liquidity);
32   event LiquidityRemoved(uint256 v1Liquidity, uint256 amountToken1, uint256 amountToken2);
33   event LiquidityProvided(uint256 token1Contributed, uint256 token2Contributed, uint256 v2Liquidity);
34 
35   constructor() public {
36   }
37 
38   /**
39   * Migrates the vault from the underlying to underlying v2
40   */
41   function migrateUnderlying(
42     uint256 minUSDTOut, uint256 minBNBOut,
43     uint256 minUSDTContribution, uint256 minBNBContribution
44   ) public onlyControllerOrGovernance {
45     require(underlying() == __USDT_BNB, "Can only migrate if the underlying is USDT/BNB");
46     withdrawAll();
47 
48     uint256 v1Liquidity = IBEP20(__USDT_BNB).balanceOf(address(this));
49     IBEP20(__USDT_BNB).safeApprove(__PANCAKE_OLD_ROUTER, 0);
50     IBEP20(__USDT_BNB).safeApprove(__PANCAKE_OLD_ROUTER, v1Liquidity);
51 
52     (uint256 amountUSDT, uint256 amountBNB) = IPancakeRouter02(__PANCAKE_OLD_ROUTER).removeLiquidity(
53       __USDT,
54       __BNB,
55       v1Liquidity,
56       minUSDTOut,
57       minBNBOut,
58       address(this),
59       block.timestamp
60     );
61     emit LiquidityRemoved(v1Liquidity, amountUSDT, amountBNB);
62 
63     require(IBEP20(__USDT_BNB).balanceOf(address(this)) == 0, "Not all underlying was converted");
64 
65     IBEP20(__USDT).safeApprove(__PANCAKE_NEW_ROUTER, 0);
66     IBEP20(__USDT).safeApprove(__PANCAKE_NEW_ROUTER, amountUSDT);
67     IBEP20(__BNB).safeApprove(__PANCAKE_NEW_ROUTER, 0);
68     IBEP20(__BNB).safeApprove(__PANCAKE_NEW_ROUTER, amountBNB);
69 
70     (uint256 usdtContributed,
71       uint256 bnbContributed,
72       uint256 v2Liquidity) = IPancakeRouter02(__PANCAKE_NEW_ROUTER).addLiquidity(
73         __USDT,
74         __BNB,
75         amountUSDT, // amountADesired
76         amountBNB, // amountBDesired
77         minUSDTContribution, // amountAMin
78         minBNBContribution, // amountBMin
79         address(this),
80         block.timestamp);
81 
82     emit LiquidityProvided(usdtContributed, bnbContributed, v2Liquidity);
83 
84     _setUnderlying(__USDT_BNB_V2);
85     require(underlying() == __USDT_BNB_V2, "underlying switch failed");
86     _setStrategy(address(0));
87 
88     uint256 busdLeft = IBEP20(__USDT).balanceOf(address(this));
89     if (busdLeft > 0) {
90       IBEP20(__USDT).transfer(__governance, busdLeft);
91     }
92     uint256 bnbLeft = IBEP20(__BNB).balanceOf(address(this));
93     if (bnbLeft > 0) {
94       IBEP20(__BNB).transfer(__governance, bnbLeft);
95     }
96 
97     emit Migrated(v1Liquidity, v2Liquidity);
98   }
99 }

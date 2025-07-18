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
15 contract VaultMigratable_Pancake_XVS_BNB is Vault {
16   using SafeBEP20 for IBEP20;
17 
18   // token 1 = BNB , token 2 = XVS
19   address public constant __XVS = address(0xcF6BB5389c92Bdda8a3747Ddb454cB7a64626C63);
20   address public constant __BNB = address(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
21 
22   address public constant __XVS_BNB = address(0x41182c32F854dd97bA0e0B1816022e0aCB2fc0bb);
23 
24   address public constant __XVS_BNB_V2 = address(0x7EB5D86FD78f3852a3e0e064f2842d45a3dB6EA2);
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
42     uint256 minXVSOut, uint256 minBNBOut,
43     uint256 minXVSContribution, uint256 minBNBContribution
44   ) public onlyControllerOrGovernance {
45     require(underlying() == __XVS_BNB, "Can only migrate if the underlying is XVS/BNB");
46     withdrawAll();
47 
48     uint256 v1Liquidity = IBEP20(__XVS_BNB).balanceOf(address(this));
49     IBEP20(__XVS_BNB).safeApprove(__PANCAKE_OLD_ROUTER, 0);
50     IBEP20(__XVS_BNB).safeApprove(__PANCAKE_OLD_ROUTER, v1Liquidity);
51 
52     (uint256 amountBNB, uint256 amountXVS) = IPancakeRouter02(__PANCAKE_OLD_ROUTER).removeLiquidity(
53       __BNB,
54       __XVS,
55       v1Liquidity,
56       minBNBOut,
57       minXVSOut,
58       address(this),
59       block.timestamp
60     );
61     emit LiquidityRemoved(v1Liquidity, amountBNB, amountXVS);
62 
63     require(IBEP20(__XVS_BNB).balanceOf(address(this)) == 0, "Not all underlying was converted");
64 
65     IBEP20(__XVS).safeApprove(__PANCAKE_NEW_ROUTER, 0);
66     IBEP20(__XVS).safeApprove(__PANCAKE_NEW_ROUTER, amountXVS);
67     IBEP20(__BNB).safeApprove(__PANCAKE_NEW_ROUTER, 0);
68     IBEP20(__BNB).safeApprove(__PANCAKE_NEW_ROUTER, amountBNB);
69 
70     (uint256 bnbContributed,
71       uint256 xvsContributed,
72       uint256 v2Liquidity) = IPancakeRouter02(__PANCAKE_NEW_ROUTER).addLiquidity(
73         __BNB,
74         __XVS,
75         amountBNB, // amountADesire
76         amountXVS, // amountBDesired
77         minBNBContribution, // amountAMin
78         minXVSContribution, // amountBMin
79         address(this),
80         block.timestamp);
81 
82     emit LiquidityProvided(bnbContributed, xvsContributed, v2Liquidity);
83 
84     _setUnderlying(__XVS_BNB_V2);
85     require(underlying() == __XVS_BNB_V2, "underlying switch failed");
86     _setStrategy(address(0));
87 
88     uint256 busdLeft = IBEP20(__XVS).balanceOf(address(this));
89     if (busdLeft > 0) {
90       IBEP20(__XVS).transfer(__governance, busdLeft);
91     }
92     uint256 bnbLeft = IBEP20(__BNB).balanceOf(address(this));
93     if (bnbLeft > 0) {
94       IBEP20(__BNB).transfer(__governance, bnbLeft);
95     }
96 
97     emit Migrated(v1Liquidity, v2Liquidity);
98   }
99 }

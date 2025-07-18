1 pragma solidity ^0.4.24;
2 
3 contract Ownable {}
4 contract AddressesFilterFeature is Ownable {}
5 contract ERC20Basic {}
6 contract BasicToken is ERC20Basic {}
7 contract ERC20 {}
8 contract StandardToken is ERC20, BasicToken {}
9 contract MintableToken is AddressesFilterFeature, StandardToken {}
10 
11 contract Token is MintableToken {
12   function mint(address, uint256) public returns (bool);
13 }
14 
15 contract FifthBountyWPTpayoutPart02 {
16   //storage
17   address public owner;
18   Token public company_token;
19   address[] public addressOfBountyMembers;
20   mapping(address => uint256) bountyMembersAmounts;
21   uint currentBatch;
22   uint addrPerStep;
23 
24   //modifiers
25   modifier onlyOwner
26   {
27     require(owner == msg.sender);
28     _;
29   }
30   
31   
32   //Events
33   event Transfer(address indexed to, uint indexed value);
34   event OwnerChanged(address indexed owner);
35 
36 
37   //constructor
38   constructor (Token _company_token) public {
39     owner = msg.sender;
40     company_token = _company_token;
41     currentBatch = 0;
42     addrPerStep = 25;
43     setBountyAddresses();
44     setBountyAmounts();
45   }
46 
47 
48   /// @dev Fallback function: don't accept ETH
49   function()
50     public
51     payable
52   {
53     revert();
54   }
55 
56   function setCountPerStep(uint _newValue) public onlyOwner {
57 	addrPerStep = _newValue;
58   }
59 
60   function setOwner(address _owner) 
61     public 
62     onlyOwner 
63   {
64     require(_owner != 0);
65     
66     owner = _owner;
67     emit OwnerChanged(owner);
68   }
69 
70   
71   
72   function makePayout() public onlyOwner {
73     uint startIndex = currentBatch * addrPerStep;
74     uint endIndex = (currentBatch + 1 ) * addrPerStep;
75     for (uint i = startIndex; (i < endIndex && i < addressOfBountyMembers.length); i++)
76     {
77       company_token.mint(addressOfBountyMembers[i], bountyMembersAmounts[addressOfBountyMembers[i]]);
78     }
79     currentBatch++;
80   }
81 
82   function setBountyAddresses() internal {
83     addressOfBountyMembers.push(0xB176c1618c856d740Eac8596AF5927a4f8317446);
84     addressOfBountyMembers.push(0xaEFDF7aFFaAcab75310158F471b6F355B3D1aA77);
85     addressOfBountyMembers.push(0xaEf6A66BB8cb0B6FD286B108F3f1E05F84Eb557E);
86     addressOfBountyMembers.push(0xaA70a9a592Dc7bD231d1B9D2521012cF501d4686);
87     addressOfBountyMembers.push(0xAa44e7028E9e6Ee1D3Df0a4Ac50af1a39C703938);
88     addressOfBountyMembers.push(0xa985AacE37ceF6211020Dc3FB86eC8A4Db56a151);
89     addressOfBountyMembers.push(0xa9658960FC6f213833EbD61B86b82F726BF222B2);
90     addressOfBountyMembers.push(0xa8c73ee57c268872b9d2d7a90e5f2e31af8493fb);
91     addressOfBountyMembers.push(0xA8A9D9fCF060F3518a859048BE7E235846C21b68);
92     addressOfBountyMembers.push(0xA877a938279C6B8E2baEbff289e3Cd36A70E3D85);
93     addressOfBountyMembers.push(0xa86A37054550a30003c06D0027ea4A567322AAB8);
94     addressOfBountyMembers.push(0xA7a3942419A02fa842178e5B881AbB2C5E79d83D);
95     addressOfBountyMembers.push(0xA7316Fa3E02C330D9551CcE7332c41780Bbfd85b);
96     addressOfBountyMembers.push(0xA6Fd1E5729fbfBcEb8873279CeD1faCc2FE4fBa5);
97     addressOfBountyMembers.push(0xa6e7c1c7e015ca8727788916f33ce1f27cea4385);
98     addressOfBountyMembers.push(0xa61342A4811c140D802285c39920745c2c7aEB30);
99     addressOfBountyMembers.push(0xa612c9FCD511adBC5c1910F8cEcaa1594bBE0667);
100     addressOfBountyMembers.push(0xa5b424a69d47d439cf2d60D66e32379585d54C97);
101     addressOfBountyMembers.push(0xA46E55481f2e6A0380da8815Ac972Ffa7Bc83414);
102     addressOfBountyMembers.push(0xA3bEE330Bc1C26699C332B4a816b8D2995B48A33);
103     addressOfBountyMembers.push(0xA26579D0BC307f06e72B4339bc21a6393517c8ba);
104     addressOfBountyMembers.push(0xA15C57f4c1769D302de15bb5F6A992607c314aA1);
105     addressOfBountyMembers.push(0xa077E1288eB7497f94A4Bd954e777E49D61b48a0);
106     addressOfBountyMembers.push(0xa03bb69F2a9bAd04e028D2D4aB62C5FCB520Cb36);
107     addressOfBountyMembers.push(0x9f9aaaba75b9a72cb3b109353e4c420203789615);
108     addressOfBountyMembers.push(0x9f4514d4B3A39eC2B368E35a18374C76892a55Fa);
109     addressOfBountyMembers.push(0x9eE59c11458D564f83c056aF679da378a1f990a2);
110     addressOfBountyMembers.push(0x9eA7C5Cd8074798D9dD0b545ab36ed0D9930b3BA);
111     addressOfBountyMembers.push(0x9e27AAEDd1c9e2801f733A61ea75245342af9567);
112     addressOfBountyMembers.push(0x9E1a6d5D5D917dd6c3b3C3406670d21AF19b6EA6);
113     addressOfBountyMembers.push(0x9deB4735cC4a99D817CC9EbF9339Fb4Bbe6900eA);
114     addressOfBountyMembers.push(0x9BBC6923a3DCcbeb790C02e88778308b355A7B7D);
115     addressOfBountyMembers.push(0x9B874bB8dC1FfE87D8579b72F85308e93405bA3b);
116     addressOfBountyMembers.push(0x9b6beF85dDC2eB39Cc2D2dE80DfD7Baea8fb8c4e);
117     addressOfBountyMembers.push(0x9B002A1febc185f24a685d783C053a6740de33BF);
118     addressOfBountyMembers.push(0x9aA5cfa67d7E6c5Dd5F7c0D9d96636ae6adEE91c);
119     addressOfBountyMembers.push(0x9a8e2538f8270d252db6e759e297f5f3646188e5);
120     addressOfBountyMembers.push(0x9a6d7ba4de44a6ba0fadb8a425fff41955a8f7e9);
121     addressOfBountyMembers.push(0x98dE801c6b6A985a61d0832daF5525B127cc78B1);
122     addressOfBountyMembers.push(0x98503A0114C0D6c6826dE2A9679a6E9f6DdC4a1f);
123     addressOfBountyMembers.push(0x9831DBD9172D96B4763ef3D435190A08970F356E);
124     addressOfBountyMembers.push(0x97cf259c7c8a0d4641bf744a8a1bba7888788388);
125     addressOfBountyMembers.push(0x9780c0A84c19cef9d0A255E967cB6245Cc7Aa342);
126     addressOfBountyMembers.push(0x972909284213008102Fa0298F3D1C40A322E37Bd);
127     addressOfBountyMembers.push(0x9674b04fcdff254b8c641cf79f44d2a5a8bddd2c);
128     addressOfBountyMembers.push(0x93Dfe193b0D334682A1096cd260c67410C164AE7);
129     addressOfBountyMembers.push(0x93a797e116BA9519eA32FC88C7D6993B136a8ecf);
130     addressOfBountyMembers.push(0x93629d553f5004313E4C9fa05e36B2e1B5b9d78E);
131     addressOfBountyMembers.push(0x91D005CA46457B487B2886463dD094f0Ad2053A3);
132     addressOfBountyMembers.push(0x90d624497bE600A7F66b53825f2FAC3F6943Bde9);
133     addressOfBountyMembers.push(0x9000E36061Dc6De0107B966bEF2EA20b91eab304);
134     addressOfBountyMembers.push(0x8f6f9a2BA2130989F51D08138bfb72c4bfe873bd);
135     addressOfBountyMembers.push(0x8f2Ee979D4275d7345e66490F71E25FA156eAAb6);
136     addressOfBountyMembers.push(0x8e1cdC5df697895F66762938791F707e1Af33544);
137     addressOfBountyMembers.push(0x8DeC95691d120a1bc86344C7fAe2899D381DEa88);
138     addressOfBountyMembers.push(0x8C41194F6bEa5e83AFD2Fa70921aE9DEb262A079);
139     addressOfBountyMembers.push(0x8ab745a450bd91773adce3c55da13da9066cbc91);
140     addressOfBountyMembers.push(0x87a0E778eFD32B8e929e89091659839D225c616B);
141     addressOfBountyMembers.push(0x86c28d49da97c65dc672f36b7176eaa24b8daa49);
142     addressOfBountyMembers.push(0x8607dFc8f45d999d1A80fd5d5A72CDA32255aD10);
143     addressOfBountyMembers.push(0x8553ab971be54575cD898eF1aA599993a4D25509);
144     addressOfBountyMembers.push(0x82F383AD178C43F1a27B947432f43af8851798AA);
145     addressOfBountyMembers.push(0x822d3370F17C8F488F3DED42fB82959CBd78051c);
146     addressOfBountyMembers.push(0x80bc441abD9275725D4Fa20bB2F9fC018deE1650);
147     addressOfBountyMembers.push(0x809F4dCc89bb79AcDb9E78e6a559A07a2daC2fC4);
148     addressOfBountyMembers.push(0x807C525D1302644f7e4BD71F4456aC79625399FE);
149     addressOfBountyMembers.push(0x80476f7A837aeA5619Ef7f7f38218A933F3DA572);
150     addressOfBountyMembers.push(0x7fd7BAd36bEb24C53B20d0C28cf7659D4c831f66);
151     addressOfBountyMembers.push(0x7FBD6d575142959c842BD5D590261F955a86E936);
152     addressOfBountyMembers.push(0x7dE6449Bb8B0fc4C41e02F8db2814a66a7E6Ef9a);
153     addressOfBountyMembers.push(0x7Cbd9C429ce6c5a00aEcBA65bB2FDd59AaD31bB8);
154     addressOfBountyMembers.push(0x7c08ed6a275bd3971d170d4be79d51163351cedf);
155     addressOfBountyMembers.push(0x7b6EE335E7D498c3015f27d677F9F76510Cb8c85);
156     addressOfBountyMembers.push(0x79A16a62F087704B580F5061a4EFF2860d8Fb059);
157     addressOfBountyMembers.push(0x791420ca57710Cb40Ffa2B62a9fd2E5F3F5c5b25);
158     addressOfBountyMembers.push(0x7903F4A04Bff833924E81F6A611844c1A03e181c);
159     addressOfBountyMembers.push(0x77d00c9F51669d5D5615f8902C9c3534c9ED8967);
160     addressOfBountyMembers.push(0x77B06947bf61461820E5C3e056b97F534E7EF75F);
161     addressOfBountyMembers.push(0x76ef754D7d1116F6CA912f877c88b777184670b1);
162     addressOfBountyMembers.push(0x740a5c3677a7018f367c38d8655f00b458eed9ab);
163     addressOfBountyMembers.push(0x72151d27EfFd91A83B6097d9e88DE33Ef70a0d4F);
164     addressOfBountyMembers.push(0x7172cD07a4207a80FC28545d9fCA5F6797Fa0eCc);
165     addressOfBountyMembers.push(0x70C1616E0BF5AF960bedB0B2cdE710487831A2B0);
166     addressOfBountyMembers.push(0x6F9FEc8F3029A843d02B812923A98a7008b1f3A8);
167     addressOfBountyMembers.push(0x6Eb4b78F02b0158cf66fCfC695F8Cf4f5C0E76EA);
168     addressOfBountyMembers.push(0x6e9c261D10575c87fE8724c54ccD26e59F77101a);
169     addressOfBountyMembers.push(0x6e37e964595bF0cE03B262180F3682b8A453128c);
170     addressOfBountyMembers.push(0x6e06d0Cb11A610fbfEE929bcAEBFBDcD26907081);
171     addressOfBountyMembers.push(0x6e04daB7a9E4540B397B40da14c911b129CfD464);
172     addressOfBountyMembers.push(0x6DB164dB70c3D097e373B26818bCb490C578975A);
173     addressOfBountyMembers.push(0x6cB67CC2540541AF4633E195e2970956a815e720);
174     addressOfBountyMembers.push(0x6c9a0b8e9C2D2c194a1510A73219cAbf8C538Abb);
175     addressOfBountyMembers.push(0x6C19f5d1e8cae3dC31e5B6838aae33FB9d2a242e);
176     addressOfBountyMembers.push(0x6C0844F2737bB5986E3c95e89CcC2928bAc4702A);
177     addressOfBountyMembers.push(0x6bfb350FcbE780bA6b18314Df92d886C01d74c6e);
178     addressOfBountyMembers.push(0x6BED1B90191C3f188C7CF286945856117fbB16b6);
179     addressOfBountyMembers.push(0x6bc2e358aad5f8d0ccc9f0dcd49aa1167a0984b9);
180     addressOfBountyMembers.push(0x6Ba3C0a623c8A09Aff12bE571ec09DcFBB17858A);
181     addressOfBountyMembers.push(0x6b562D5E2d79CE2E95816cCDc14D5877f80f3268);
182     addressOfBountyMembers.push(0x6b536031AC4dc9e0CFFA2339af1EFCFE3719da58);
183   }
184 
185   function setBountyAmounts() internal { 
186     bountyMembersAmounts[0xB176c1618c856d740Eac8596AF5927a4f8317446] =   100000000000000000000;
187     bountyMembersAmounts[0xaEFDF7aFFaAcab75310158F471b6F355B3D1aA77] =   136000000000000000000;
188     bountyMembersAmounts[0xaEf6A66BB8cb0B6FD286B108F3f1E05F84Eb557E] =   103000000000000000000;
189     bountyMembersAmounts[0xaA70a9a592Dc7bD231d1B9D2521012cF501d4686] =   100000000000000000000;
190     bountyMembersAmounts[0xAa44e7028E9e6Ee1D3Df0a4Ac50af1a39C703938] =   543000000000000000000;
191     bountyMembersAmounts[0xa985AacE37ceF6211020Dc3FB86eC8A4Db56a151] =   115000000000000000000;
192     bountyMembersAmounts[0xa9658960FC6f213833EbD61B86b82F726BF222B2] =   216000000000000000000;
193     bountyMembersAmounts[0xa8c73ee57c268872b9d2d7a90e5f2e31af8493fb] =   100000000000000000000;
194     bountyMembersAmounts[0xA8A9D9fCF060F3518a859048BE7E235846C21b68] =   102000000000000000000;
195     bountyMembersAmounts[0xA877a938279C6B8E2baEbff289e3Cd36A70E3D85] =   532000000000000000000;
196     bountyMembersAmounts[0xa86A37054550a30003c06D0027ea4A567322AAB8] =   143000000000000000000;
197     bountyMembersAmounts[0xA7a3942419A02fa842178e5B881AbB2C5E79d83D] =   110000000000000000000;
198     bountyMembersAmounts[0xA7316Fa3E02C330D9551CcE7332c41780Bbfd85b] =   236000000000000000000;
199     bountyMembersAmounts[0xA6Fd1E5729fbfBcEb8873279CeD1faCc2FE4fBa5] =   170000000000000000000;
200     bountyMembersAmounts[0xa6e7c1c7e015ca8727788916f33ce1f27cea4385] =   116000000000000000000;
201     bountyMembersAmounts[0xa61342A4811c140D802285c39920745c2c7aEB30] =   104000000000000000000;
202     bountyMembersAmounts[0xa612c9FCD511adBC5c1910F8cEcaa1594bBE0667] =   132000000000000000000;
203     bountyMembersAmounts[0xa5b424a69d47d439cf2d60D66e32379585d54C97] =  1934000000000000000000;
204     bountyMembersAmounts[0xA46E55481f2e6A0380da8815Ac972Ffa7Bc83414] =   198000000000000000000;
205     bountyMembersAmounts[0xA3bEE330Bc1C26699C332B4a816b8D2995B48A33] =   233000000000000000000;
206     bountyMembersAmounts[0xA26579D0BC307f06e72B4339bc21a6393517c8ba] =   186000000000000000000;
207     bountyMembersAmounts[0xA15C57f4c1769D302de15bb5F6A992607c314aA1] =   285000000000000000000;
208     bountyMembersAmounts[0xa077E1288eB7497f94A4Bd954e777E49D61b48a0] =   105000000000000000000;
209     bountyMembersAmounts[0xa03bb69F2a9bAd04e028D2D4aB62C5FCB520Cb36] =  1872720000000000000000;
210     bountyMembersAmounts[0x9f9aaaba75b9a72cb3b109353e4c420203789615] =   109000000000000000000;
211     bountyMembersAmounts[0x9f4514d4B3A39eC2B368E35a18374C76892a55Fa] =   109000000000000000000;
212     bountyMembersAmounts[0x9eE59c11458D564f83c056aF679da378a1f990a2] =   818000000000000000000;
213     bountyMembersAmounts[0x9eA7C5Cd8074798D9dD0b545ab36ed0D9930b3BA] =   330000000000000000000;
214     bountyMembersAmounts[0x9e27AAEDd1c9e2801f733A61ea75245342af9567] =   184000000000000000000;
215     bountyMembersAmounts[0x9E1a6d5D5D917dd6c3b3C3406670d21AF19b6EA6] =   418000000000000000000;
216     bountyMembersAmounts[0x9deB4735cC4a99D817CC9EbF9339Fb4Bbe6900eA] =   121000000000000000000;
217     bountyMembersAmounts[0x9BBC6923a3DCcbeb790C02e88778308b355A7B7D] =   162000000000000000000;
218     bountyMembersAmounts[0x9B874bB8dC1FfE87D8579b72F85308e93405bA3b] =   123000000000000000000;
219     bountyMembersAmounts[0x9b6beF85dDC2eB39Cc2D2dE80DfD7Baea8fb8c4e] =   140000000000000000000;
220     bountyMembersAmounts[0x9B002A1febc185f24a685d783C053a6740de33BF] =   184000000000000000000;
221     bountyMembersAmounts[0x9aA5cfa67d7E6c5Dd5F7c0D9d96636ae6adEE91c] =   161000000000000000000;
222     bountyMembersAmounts[0x9a8e2538f8270d252db6e759e297f5f3646188e5] =   492000000000000000000;
223     bountyMembersAmounts[0x9a6d7ba4de44a6ba0fadb8a425fff41955a8f7e9] =   107000000000000000000;
224     bountyMembersAmounts[0x98dE801c6b6A985a61d0832daF5525B127cc78B1] =   203000000000000000000;
225     bountyMembersAmounts[0x98503A0114C0D6c6826dE2A9679a6E9f6DdC4a1f] =   730000000000000000000;
226     bountyMembersAmounts[0x9831DBD9172D96B4763ef3D435190A08970F356E] =   818200000000000000000;
227     bountyMembersAmounts[0x97cf259c7c8a0d4641bf744a8a1bba7888788388] =   112000000000000000000;
228     bountyMembersAmounts[0x9780c0A84c19cef9d0A255E967cB6245Cc7Aa342] =   170000000000000000000;
229     bountyMembersAmounts[0x972909284213008102Fa0298F3D1C40A322E37Bd] =   150000000000000000000;
230     bountyMembersAmounts[0x9674b04fcdff254b8c641cf79f44d2a5a8bddd2c] =   121000000000000000000;
231     bountyMembersAmounts[0x93Dfe193b0D334682A1096cd260c67410C164AE7] =   116000000000000000000;
232     bountyMembersAmounts[0x93a797e116BA9519eA32FC88C7D6993B136a8ecf] =   202000000000000000000;
233     bountyMembersAmounts[0x93629d553f5004313E4C9fa05e36B2e1B5b9d78E] =   230000000000000000000;
234     bountyMembersAmounts[0x91D005CA46457B487B2886463dD094f0Ad2053A3] =   110000000000000000000;
235     bountyMembersAmounts[0x90d624497bE600A7F66b53825f2FAC3F6943Bde9] =   239000000000000000000;
236     bountyMembersAmounts[0x9000E36061Dc6De0107B966bEF2EA20b91eab304] =   120000000000000000000;
237     bountyMembersAmounts[0x8f6f9a2BA2130989F51D08138bfb72c4bfe873bd] =   260000000000000000000;
238     bountyMembersAmounts[0x8f2Ee979D4275d7345e66490F71E25FA156eAAb6] =   294000000000000000000;
239     bountyMembersAmounts[0x8e1cdC5df697895F66762938791F707e1Af33544] =   189000000000000000000;
240     bountyMembersAmounts[0x8DeC95691d120a1bc86344C7fAe2899D381DEa88] =   101000000000000000000;
241     bountyMembersAmounts[0x8C41194F6bEa5e83AFD2Fa70921aE9DEb262A079] =   149000000000000000000;
242     bountyMembersAmounts[0x8ab745a450bd91773adce3c55da13da9066cbc91] =   150000000000000000000;
243     bountyMembersAmounts[0x87a0E778eFD32B8e929e89091659839D225c616B] =   107000000000000000000;
244     bountyMembersAmounts[0x86c28d49da97c65dc672f36b7176eaa24b8daa49] =   102000000000000000000;
245     bountyMembersAmounts[0x8607dFc8f45d999d1A80fd5d5A72CDA32255aD10] =   253000000000000000000;
246     bountyMembersAmounts[0x8553ab971be54575cD898eF1aA599993a4D25509] =   185000000000000000000;
247     bountyMembersAmounts[0x82F383AD178C43F1a27B947432f43af8851798AA] =   200000000000000000000;
248     bountyMembersAmounts[0x822d3370F17C8F488F3DED42fB82959CBd78051c] =   110000000000000000000;
249     bountyMembersAmounts[0x80bc441abD9275725D4Fa20bB2F9fC018deE1650] =   105000000000000000000;
250     bountyMembersAmounts[0x809F4dCc89bb79AcDb9E78e6a559A07a2daC2fC4] =   243000000000000000000;
251     bountyMembersAmounts[0x807C525D1302644f7e4BD71F4456aC79625399FE] =   200000000000000000000;
252     bountyMembersAmounts[0x80476f7A837aeA5619Ef7f7f38218A933F3DA572] =   607000000000000000000;
253     bountyMembersAmounts[0x7fd7BAd36bEb24C53B20d0C28cf7659D4c831f66] =   276000000000000000000;
254     bountyMembersAmounts[0x7FBD6d575142959c842BD5D590261F955a86E936] =   190000000000000000000;
255     bountyMembersAmounts[0x7dE6449Bb8B0fc4C41e02F8db2814a66a7E6Ef9a] =   390000000000000000000;
256     bountyMembersAmounts[0x7Cbd9C429ce6c5a00aEcBA65bB2FDd59AaD31bB8] =   222000000000000000000;
257     bountyMembersAmounts[0x7c08ed6a275bd3971d170d4be79d51163351cedf] =   164000000000000000000;
258     bountyMembersAmounts[0x7b6EE335E7D498c3015f27d677F9F76510Cb8c85] =   166000000000000000000;
259     bountyMembersAmounts[0x79A16a62F087704B580F5061a4EFF2860d8Fb059] =   104000000000000000000;
260     bountyMembersAmounts[0x791420ca57710Cb40Ffa2B62a9fd2E5F3F5c5b25] =   137000000000000000000;
261     bountyMembersAmounts[0x7903F4A04Bff833924E81F6A611844c1A03e181c] =   113000000000000000000;
262     bountyMembersAmounts[0x77d00c9F51669d5D5615f8902C9c3534c9ED8967] =   321000000000000000000;
263     bountyMembersAmounts[0x77B06947bf61461820E5C3e056b97F534E7EF75F] =   100000000000000000000;
264     bountyMembersAmounts[0x76ef754D7d1116F6CA912f877c88b777184670b1] =   101000000000000000000;
265     bountyMembersAmounts[0x740a5c3677a7018f367c38d8655f00b458eed9ab] =   130000000000000000000;
266     bountyMembersAmounts[0x72151d27EfFd91A83B6097d9e88DE33Ef70a0d4F] =   102000000000000000000;
267     bountyMembersAmounts[0x7172cD07a4207a80FC28545d9fCA5F6797Fa0eCc] =   106000000000000000000;
268     bountyMembersAmounts[0x70C1616E0BF5AF960bedB0B2cdE710487831A2B0] =   102000000000000000000;
269     bountyMembersAmounts[0x6F9FEc8F3029A843d02B812923A98a7008b1f3A8] =   118000000000000000000;
270     bountyMembersAmounts[0x6Eb4b78F02b0158cf66fCfC695F8Cf4f5C0E76EA] =   195000000000000000000;
271     bountyMembersAmounts[0x6e9c261D10575c87fE8724c54ccD26e59F77101a] =   130000000000000000000;
272     bountyMembersAmounts[0x6e37e964595bF0cE03B262180F3682b8A453128c] =   116000000000000000000;
273     bountyMembersAmounts[0x6e06d0Cb11A610fbfEE929bcAEBFBDcD26907081] =   153000000000000000000;
274     bountyMembersAmounts[0x6e04daB7a9E4540B397B40da14c911b129CfD464] =   133000000000000000000;
275     bountyMembersAmounts[0x6DB164dB70c3D097e373B26818bCb490C578975A] =   122000000000000000000;
276     bountyMembersAmounts[0x6cB67CC2540541AF4633E195e2970956a815e720] =   149000000000000000000;
277     bountyMembersAmounts[0x6c9a0b8e9C2D2c194a1510A73219cAbf8C538Abb] =   146000000000000000000;
278     bountyMembersAmounts[0x6C19f5d1e8cae3dC31e5B6838aae33FB9d2a242e] =   137000000000000000000;
279     bountyMembersAmounts[0x6C0844F2737bB5986E3c95e89CcC2928bAc4702A] =   100000000000000000000;
280     bountyMembersAmounts[0x6bfb350FcbE780bA6b18314Df92d886C01d74c6e] =   451000000000000000000;
281     bountyMembersAmounts[0x6BED1B90191C3f188C7CF286945856117fbB16b6] =   146000000000000000000;
282     bountyMembersAmounts[0x6bc2e358aad5f8d0ccc9f0dcd49aa1167a0984b9] =   102000000000000000000;
283     bountyMembersAmounts[0x6Ba3C0a623c8A09Aff12bE571ec09DcFBB17858A] =   125000000000000000000;
284     bountyMembersAmounts[0x6b562D5E2d79CE2E95816cCDc14D5877f80f3268] =   115000000000000000000;
285     bountyMembersAmounts[0x6b536031AC4dc9e0CFFA2339af1EFCFE3719da58] =   100000000000000000000;
286   } 
287 }
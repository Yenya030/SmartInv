1 // SPDX-License-Identifier: CC-BY-ND 3.0 
2 
3     pragma solidity ^0.8.7;
4 
5     interface ERC20 {
6 
7         /// @param _owner The address from which the balance will be retrieved
8         /// @return balance the balance
9         function balanceOf(address _owner) external view returns (uint256 balance);
10 
11         /// @notice send `_value` token to `_to` from `msg.sender`
12         /// @param _to The address of the recipient
13         /// @param _value The amount of token to be transferred
14         /// @return success Whether the transfer was successful or not
15         function transfer(address _to, uint256 _value) external returns (bool success);
16         function decimals() external view returns (uint);
17 
18         /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19         /// @param _from The address of the sender
20         /// @param _to The address of the recipient
21         /// @param _value The amount of token to be transferred
22         /// @return success Whether the transfer was successful or not
23         function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
24 
25         /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26         /// @param _spender The address of the account able to transfer the tokens
27         /// @param _value The amount of wei to be approved for transfer
28         /// @return success Whether the approval was successful or not
29         function approve(address _spender, uint256 _value) external returns (bool success);
30 
31         /// @param _owner The address of the account owning tokens
32         /// @param _spender The address of the account able to transfer the tokens
33         /// @return remaining Amount of remaining tokens allowed to spent
34         function allowance(address _owner, address _spender) external view returns (uint256 remaining);
35 
36         event Transfer(address indexed _from, address indexed _to, uint256 _value);
37         event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38     }
39 
40 
41 
42     contract KLEE_CLAIMER_V2 {
43 
44         mapping(address => bool) public is_auth;
45         mapping(address => bool) public claimed;
46         address public owner;
47         mapping(address => bool) public banned;
48         address public newKlee = 0xA67E9F021B9d208F7e3365B2A155E3C55B27de71;
49         address public oldKlee = 0x382f0160c24f5c515A19f155BAc14d479433A407;
50         ERC20 newKlee_token;
51         ERC20 oldKlee_token;
52 
53         bool open;
54 
55         bool locked;
56 
57         modifier safe () {
58             require(!locked, "401");
59             locked = true;
60             _;
61             locked = false;
62         }
63 
64         modifier protected() {
65             require(msg.sender == owner || is_auth[msg.sender], "403");
66             _;
67         }
68 
69         constructor() {
70             owner = msg.sender;
71             is_auth[msg.sender] = true;
72             newKlee_token = ERC20(newKlee);
73             oldKlee_token = ERC20(oldKlee); 
74             pre_ban();
75         }
76 
77         function claim() public safe {
78             require(!banned[msg.sender], "403");
79             require(!claimed[msg.sender], "Already claimed");
80             require(open, "500");
81             uint oldBalance = oldKlee_token.balanceOf(msg.sender);
82             require(newKlee_token.balanceOf(address(this)) >= oldBalance, "Not enough balance");
83             newKlee_token.transfer(msg.sender, oldBalance);
84             claimed[msg.sender] = true;
85         }
86         
87         function open_claim(bool status) public protected {
88             open = status;
89         }
90 
91         function ban_user(address addy) public protected {
92             banned[addy] = true;
93         }
94 
95         function unban_user(address addy) public protected {
96             banned[addy] = false;
97         }
98 
99 
100         function pre_ban() private {
101             banned[0x7E47B50B95d16e1b5A80586eeDDbb3c561907611]= true;
102             banned[0xC64e0Ca5A7C46e3B418c643C4F7AA6711261AffC]= true;
103             banned[0xA41000C7faF8dc1626cc332A1F5E98C9466691A5]= true;
104             banned[0xE5B8ff1ca1c3Ef2ac704783d6473Ee5a9BE7e02d]= true;
105             banned[0x0c93C1860C5BacF7015701e80CdC4c4CDEbC39c2]= true;
106             banned[0x6f47d53b62D1f28C49CE939D1f5655f81F8A48E1]= true;
107             banned[0xf67d4d639448Cd37b0f5ca3CED04433963f625fD]= true;
108             banned[0x983FCB1345BE0143FCAD9ed4E52284067F342a9C]= true;
109             banned[0xB20bF6D7f60059dd5dE46F3F0F32665a259ea6C0]= true;
110             banned[0xd68b57e44B6bD4b2512fC75E489eba671A8E449f]= true;
111             banned[0x4768c3CD39723178A039dd3fc6EA1470Bae7c385]= true;
112             banned[0xD9ce9aEC92f3dA9Bf4875023F19fA4F68742a401]= true;
113             banned[0xd585B5906264795D7F3e9a2cc6969bA849Bb9bB8]= true;
114             banned[0x0203eDf96D47925ed319188e2B150A7abAA068c5]= true;
115             banned[0xE23baA92776419fA239CbB92Ad5Db3945b0A6260]= true;
116             banned[0x12a2b0Ca9DEbf08E3a2b0C68184b2d7c7DDF4dC2]= true;
117             banned[0x57c96e36230a558b34eF4585B3bD4D27FffceACA]= true;
118             banned[0x174Ae5a36f5dd7591615E96f158614723a4D8E4E]= true;
119             banned[0x0B1D479D57D9Faa62Efb29762d0EE9B0Ef4B323b]= true;
120             banned[0x93b0fE68222B5fdC711BF7f82809Ab6D38c85C1f]= true;
121             banned[0x2B0362f2C5e49CDDc0B72353661bce783Ce5973E]= true;
122             banned[0xd94A906f40002E68974Fb75c2f30303ab57a91Ce]= true;
123             banned[0x04450499a50b117E3deC3F44cFc46318781Da5eF]= true;
124             banned[0xb79f2924A0d805082A0e1C131D1bDc73dBE1ADee]= true;
125             banned[0x0000000000D9455CC7EB92D06E00582A982f68fe]= true;
126             banned[0x5f62593C70069AbB35dFe2B63db969e8906609d6]= true;
127             banned[0xA929F030458Be505749Fc8eC8C3941225D6d1532]= true;
128             banned[0x30998E68E9f2A532131F69811fBB88870aa0389F]= true;
129             banned[0x9b19858616Abba3525c99A2B09B1C0F2F02d0179]= true;
130             banned[0x731Ea79A1B2B90683507Da2aaB498bd8fF8f7ff1]= true;
131             banned[0xfeCd0eF07223D35a79BaAD451b31A4Ad73Fa72e4]= true;
132             banned[0x308e78BF7848863bF75A1EB93bbD2B64Da7DA2c5]= true;
133             banned[0x00000000003b3cc22aF3aE1EAc0440BcEe416B40]= true;
134             banned[0x82B771E9F2F9B92B4B8f4EBDA4aeB60d3040d6Dc]= true;
135             banned[0xE8c060F8052E07423f71D445277c61AC5138A2e5]= true;
136             banned[0x6a06A7f368dd9c57DE34B0F725709E8939b9BeC1]= true;
137             banned[0x931b23DaC01EF88BE746d752252D831464a3834C]= true;
138             banned[0x2Cfcbd233268C302996c767347eb45bec36FB08D]= true;
139             banned[0x220bdA5c8994804Ac96ebe4DF184d25e5c2196D4]= true;
140             banned[0x19801f0647f12DdBbB265f3BAF5bdFE6386bD2B7]= true;
141             banned[0x05B5952da949F25368a5473D3D59B5aC73FaD486]= true;
142             banned[0x3Ed75618518B9D015d37A151b7a61dc1E79Ab49B]= true;
143             banned[0xC1dfd16259C2530e57aEa8A2cF106db5671616B0]= true;
144             banned[0xA268C06B5AA8B5C1EFCc0389F7b255DaE3Fa9323]= true;
145             banned[0xe0a9efE32985cC306255b395a1bd06D21ccEAd42]= true;
146             banned[0x9522B04D51983f669Bea38A5C6871e98a12E895f]= true;
147             banned[0x29a7f67A3F990ECbC9cFa2A94422CC644f396c80]= true;
148             banned[0x081D6316E9832700F7f1C4e3Eb26Fd8a047c86f6]= true;
149             banned[0x65463d202179AE0f2Aaa0FF58BEe3096Dcc78A5a]= true;
150             banned[0xFE52607e1482Fe634Fd82Ca82d74f12990d3dcBd]= true;
151             banned[0x07888c3C5D25fa74AE04A9EaD1fB1cF0E7743689]= true;
152             banned[0x0B741b593b891A12116372e78838a7E031884db0]= true;
153             banned[0x0B3DE409a3CC76C68d4d49d280D8A03a74Ad8383]= true;
154             banned[0xDFC43D46410cd1f3872ac2761adf6878f23c87a8]= true;
155             banned[0xE7C7611b8e053b7F1b315c6Aa9Abad0Abc008891]= true;
156             banned[0xb307F5Bb82efB174B190fe5c850c59ef8b2Ec936]= true;
157             banned[0xD13B2e65eCb2fAE93169BF91432864A5Da5FCA8C]= true;
158             banned[0x9c22cebB76ed68d241e2515D3fC0B0500C7Cb4b7]= true;
159             banned[0x2D7fd3D6aC1f67CB3012b40028Bee5f5A7b9e19A]= true;
160             banned[0xCe584ef141129d78641B490433CaE2fC1AC5bE05]= true;
161             banned[0xCe41DEd99eb6dE32Ef7eD76d5D2F9DfF0778c81F]= true;
162             banned[0x870727673AF0B5c68D1b940DEa139752d96bBC60]= true;
163             banned[0x57aE5a6837f6e0d0EEB9814b6eA42Ad165fd9C0e]= true;
164             banned[0xF570b31E75740f24a6cb89801F7170859AF86E91]= true;
165             banned[0x3F4Ad062F4D567dEb7fEeb48CdeCFEeDaeb81829]= true;
166             banned[0xC4b4F657f7423D0535c9C77d709e605FE59C1758]= true;
167             banned[0xaeB8f8C0b2f228eD7EB43e2301C50a6B35113b22]= true;
168             banned[0x5a5C953805ff7E26986eFE92814BF3b07B049F3a]= true;
169             banned[0x8BF1C20eCB5ad8d51f23C1AAc4D334A50dC36F0E]= true;
170             banned[0xe033480D7d808f41573C321c5Ab3f4100aF15CFA]= true;
171             banned[0x9D109CE0592a3c55E169fAC849D304B37fEfbFd3]= true;
172             banned[0x3B94f4585fFF1662bC001663f276CFDd33A032BD]= true;
173             banned[0x96Da549f4464947759704b719Cd0D57b5b3aA345]= true;
174             banned[0x4eBd211696ecD8D8b907c0f9F243ea926A19b636]= true;
175             banned[0x79ed0B975A095914a69cb97a3fc2e5432408f601]= true;
176             banned[0xc9a5ec9e1A950794Bf69B34d07947EB2E9664bfc]= true;
177             banned[0xE0a616C3659bE29567E08819772e6905307AdF21]= true;
178             banned[0x2045862499229570D8Ca1548dAE6087eFAb57F0E]= true;
179             banned[0x5961cDbBe665C8094BFBC9D888B21B82378f981a]= true;
180             banned[0xD1f9Cf2753a5A442d8DD47DE6142b4E9B6F4b1A5]= true;
181             banned[0xAC1C51c08621fc84E10E9D246642d1C69833d810]= true;
182             banned[0xc066A76701fD2Bc6b6c052F51d71B63275525B9c]= true;
183             banned[0x865D8cce369dDE678943Ab58d02445911725099A]= true;
184             banned[0x40dFfa04c2f49ec6e5aF0A11Ed30731065ceC0De]= true;
185             banned[0xC88b5277Cda867dB35f4D118A60C74d0eE11138C]= true;
186             banned[0x02b7FAF716019f98d78e7a06F9606ef5522673bB]= true;
187             banned[0x4d944a25bC871D6C6EE08baEf0b7dA0b08E6b7b3]= true;
188             banned[0x08D0B9AA7121f5B70f1109eBD4b04b18A6322FC7]= true;
189             banned[0x277ccfaB0C990705ED6e59F8E2A589a61679ffEd]= true;
190             banned[0xaf048Bc3e1EEb3EF5a4345E1a497274B1177B8c5]= true;
191             banned[0x66E70f6812a1567681127ca56d46Cb51AceCA316]= true;
192             banned[0x1c68E43890FEf21cd43f764150fff4121773e22d]= true;
193             banned[0x54d6A53E6133C3a1B6B4C467e2344529e1D495B9]= true;
194             banned[0xdd62fC4fF41801B0A65955ccAA35B46abC735D80]= true;
195             banned[0x84061a7F23F558a3552617bC204C435BC4a9d0DA]= true;
196             banned[0x9Bde1CECB101BE673B07383e0244821cc6b4F222]= true;
197             banned[0xcab12a4dC4D36f91C794d89b02db6457D2777f69]= true;
198             banned[0xc0FA1e4667Bc585b52371B4194b7ADB555359CdA]= true;
199             banned[0x4d21509DF723f9d09364012798b6dc777Fc717cc]= true;
200             banned[0xE5B8ff1ca1c3Ef2ac704783d6473Ee5a9BE7e02d]= true;
201             banned[0xE356fe28B7B6B015a3b2BB4419dBdF2777d7420B]= true;
202             banned[0xB19Ea1d1B9eDE773E4B86b1e913236e0dAEAF808]= true;
203             banned[0xf1C77e6f9c1aC3A67E79855a2CD0728a9127bBE7]= true;
204             banned[0x8044E86CA1963E099a7E70594D72bC96a088Fed2]= true;
205             banned[0xab0F448D458eFB9C0a5DFDbFce756BE84e0eE158]= true;
206             banned[0xA3548875dD2c9D73591E247966B336464d6770f8]= true;
207             banned[0x3Bd2035D08363A8cFDAb70A41B0faaD3510492dc]= true;
208             banned[0x5620fD2Ef6711E595a9F8479b0e4d53d8c390D2C]= true;
209             banned[0x9316A239AD30c3eee5d15D84d15709BaFB4E3F28]= true;
210             banned[0x15b71F245860613D69722812CF7E73059fb10be3]= true;
211             banned[0x7D5B9F22300bA420888c9AD7b74c9Ab53F0858BE]= true;
212             banned[0x3438D23C6001e355b12FaEaE920d052706537605]= true;
213             banned[0x4E59A3441EB9c055b43e4F320E9884A0054b9baD]= true;
214             banned[0xffcc995A004c26A059248C15Afa92F006B315fAb]= true;
215             banned[0x1b62F6ef66Ee14673cB4147D7ca2165503aBde35]= true;
216             banned[0x5a9018bBC39A35c6630B8863d12D445680Ef95E4]= true;
217             banned[0xd8aB70D85e118fF84749311984B12a8aDeDf84d2]= true;
218             banned[0x16aaeE108EE3aA15a23b55BAFb8B9Da525CD7227]= true;
219             banned[0xc5422EAeB32f10876A976Ed691B02Df870264995]= true;
220             banned[0x1698F6da75F3766A66BFA2C0fc57Bbc3Ce679f75]= true;
221             banned[0x3c25103730b9F0481B844FB8b1bf17f2FF653c28]= true;
222             banned[0x2A901Aea8852987c292D8511121F8e127ea7b33d]= true;
223             banned[0xb322a6238d095bb1002FcBB41D676A66F5364f83]= true;
224             banned[0x7C66c680ABB0Aeb12a8391Cf9773F978a2B625AF]= true;
225             banned[0xc2DE5652b95e0429e45355E4BfB3390005aFA4Fd]= true;
226             banned[0x98DcC98602B6B8FC5f792D286AA83e4258886ddf]= true;
227             banned[0xB068c2cD69C1B80CBF4550d8c39a28a28dD23Dd9]= true;
228             banned[0x34DBBf05B4562A6228e18Bf055914319520A1c92]= true;
229             banned[0x23997905ceFCe08BD48E5bAc9fbD36537F3432A0]= true;
230             banned[0x164B24E95DbF4dBAE784523E46C599c3014577B0]= true;
231             banned[0xf4D8B82BcdcE1799FbeD604B1A02a28eD5557EAd]= true;
232             banned[0xA2dA55b6aFC3dc01330017ee326e3988D01203C1]= true;
233             banned[0x64D454cAb1a9F9c1bDBa30D0f37892A1aC20Ba7f]= true;
234             banned[0xEd472731ced00E74514e053B1E718af7DEaA792C]= true;
235             banned[0x522e9071D275B2f35FcB8AD09c63D0d4E1782bd3]= true;
236             banned[0xaa54aAb0a69691D9718DaD4BCaed9b0F4DCa0Ba0]= true;
237             banned[0xBC9a905c6311BeD1be504cAec4DaF3B08614A519]= true;
238             banned[0x16CB337C6090348BBcd24362CE9080377F89b3c8]= true;
239             banned[0x551ABF066C2aB646289AE465d343d330764E4c05]= true;
240             banned[0x3A68FaC23AE041bCfdd6dc888666d5cd832f7616]= true;
241             banned[0x7477234B970f6B85200fAA8CaB5c4DfBF03Dc369]= true;
242             banned[0x240915B0f4Ca0749Ce108fd67cB54Ad3c734E2bc]= true;
243             banned[0xE5279E0E4508C0B2d83b5d922753d647773754d4]= true;
244             banned[0x4071B82245916c1226159d71B6F5F999aFD5aEcC]= true;
245             banned[0xBA08B30a2672a7D841404D9F35D12c59C11d7fFF]= true;
246             banned[0x615b40B5589b73C174bfD08FD3A2868E7496E8Fb]= true;
247             banned[0xF82Ce428Cd4dFBEb87101c52Ab5B9B41670E7E9d]= true;
248             banned[0x9Be3AabA1fDf68c7aa1C7894f6f997D6474B9618]= true;
249             banned[0x7604e527a62c280308666C4efCeDD18D7814b159]= true;
250             banned[0x9F7af2Cf940F6ad743f55769e1cff979CAA68B82]= true;
251             banned[0x90CFfD446492654eC224F727351523aF3F7ae87c]= true;
252             banned[0x792F3ec6C25DdF91EC2782cF3c61b8c503B558fF]= true;
253             banned[0x61Cb595F5D7543962CEA196dcfBFfd9EA1cdEC9E]= true;
254             banned[0xc691c75c3C9b7cF682C5C90074146f9947505048]= true;
255             banned[0xe3769E841568495AEe3833D1201eC6BdF04c6030]= true;
256             banned[0xffF764b84B9C09aBa55B795935AA464509690009]= true;
257             banned[0x65a6B1802252a47126D714c64077d765CF373346]= true;
258             banned[0x616bAd187297BF9C86fd9F4a7e65452138FC0a42]= true;
259             banned[0x75FDDB59172F2ba8567b077533774C7108f601Fc]= true;
260             banned[0x7Af06D63Bc0B165493c6a34Ce49F27F7c95541ab]= true;
261             banned[0xF7e6260087963241cf6192D66c14E648fD82c6f7]= true;
262             banned[0x06C6bB9A54fb428c5a2BfC9A1c0Cb1E030cc2CA4]= true;
263             banned[0xdBB3DfC55dd04785Ab724227B661E28b745E244A]= true;
264             banned[0x6d6A3a36f02b10dA3e2E1498Ed74663963e656AD]= true;
265             banned[0x7616906d7549C4765374228e4fddD82DB3446462]= true;
266             banned[0x329296467F27C28cd383DCc0BCCbd3d3703d49Ed]= true;
267             banned[0xf506251645405Ae46eF1D1021C924b7bAdD72CC5]= true;
268             banned[0xE1f88445b664C063741dD86f63acD5F5eC604849]= true;
269             banned[0x017733d33eE420799893CA67f499E918EF1e2F13]= true;
270             banned[0x671D7413E0025bD08ED1a91A2939cBDbC302A036]= true;
271             banned[0x72DB1cdd7b70d19E362FC8284A4bE95a23063948]= true;
272             banned[0xd8C9ec618b9Ac81319edff1e81bfa946616491f2]= true;
273             banned[0x4493ec374190F38F8D28F9BCb3311ABfb2eE860d]= true;
274             banned[0x8c326E01DeBD23D4fE080cF7b70a3C2EF225C8e0]= true;
275             banned[0x9289b25434ae282BDe35daA87fe732e06Ed0FBA5]= true;
276             banned[0xDF912910F420Ff1AB8CDd21bEBE44CdcD7Ad9Ed8]= true;
277             banned[0x586425b6812Fbb27D84A8a4CD27c05350d5fcF56]= true;
278             banned[0x39F6a6C85d39d5ABAd8A398310c52E7c374F2bA3]= true;
279             banned[0x9BA3560231e3E0aD7dde23106F5B98C72E30b468]= true;
280             banned[0x120051a72966950B8ce12eB5496B5D1eEEC1541B]= true;
281             banned[0x414562D4559b5BBEaCF8Aca2A60A25ec313d0D88]= true;
282             banned[0xCd6C09823662624E6F6b6B6cB5aC1973E08D661B]= true;
283             banned[0xDeD216A5B1E0b036b0da86489F21bdDcCeF11458]= true;
284             banned[0x73E471647FE59D08AebCDdbE5df394A43c680741]= true;
285             banned[0xbD89CA992480245C84b646c820f943934b68f2FF]= true;
286             banned[0x83c4CDBB918d9AD2107CAA7fD0ed7d7BCbb53B0B]= true;
287             banned[0x2572beBA11d33b1AC9Dbad324fCc10F217Ac6228]= true;
288             banned[0x989467e3857Ac99116173B2700119F2C2fF68b8F]= true;
289             banned[0xa5cC6dfE6114a2b4E33eb40E9e56c9AA56f1A248]= true;
290             banned[0x27A6FeF53234991DaB372d10CC859Ff50BAb4E8B]= true;
291             banned[0xa2feE2B78bA43e6390c5107688451C76D23321Cf]= true;
292             banned[0x60E9778E84baC8a625c1eF2152f09f721fd9bDBE]= true;
293             banned[0xf73C3c65bde10BF26c2E1763104e609A41702EFE]= true;
294             banned[0x9d51722Fee0Eb07f8CA822ce18457668548A5DB1]= true;
295             banned[0x054290F1DD39D0c48cb3daC959ceB181c3580247]= true;
296             banned[0xc2BAdF75a02894F4062C580C5A77C2c9309CB0aF]= true;
297             banned[0x171aF3A1ddA615b8c90Bda8D40cAB627706e754f]= true;
298             banned[0xF92f942C5699B0b64622ec32C72A880C96c99F19]= true;
299             banned[0x1425844319D9A7A375c8F0D05c528948CA2Fe3Ce]= true;
300             banned[0x79da321F62402F34bef17fB57769D2C3c76dE828]= true;
301             banned[0x365D892eEFAa3f9e62FA14017E3EEBdBF5aC945A]= true;
302             banned[0xc771f5c88dAC8b72122BD4400115B595CFc5E87D]= true;
303             banned[0x865fae70ea3922f94d9fBe6Cb7B33EA25d176D19]= true;
304             banned[0x2665898249a83fDeF6E93A5bE36e905810c34926]= true;
305             banned[0x3e4E7CE834cbDe7d2727941f7FddDbCebDd8167E]= true;
306             banned[0xC03053Ed04257CB52503746FEC313E8C0313310f]= true;
307             banned[0xe087f5c0Eb0F9f0DC388207F23789Ac4C827fD3b]= true;
308             banned[0xfBdEB87969F5610d006d1a4ed79308A5778E77E5]= true;
309             banned[0x002b243eB9BB8c67D892c7d83D13d735B3d49f95]= true;
310             banned[0x2f734E3f1c8f99C8E0f7F65772Fd8dBd3175F1D1]= true;
311             banned[0x6023fB352398997E3fC741Ade7537BE489559174]= true;
312             banned[0xe83ffEF36a8393c35bf558dc9Dc6097b3FaAD2aD]= true;
313             banned[0x3353dD38c93F39c3cF620aC10a69Ed4F0A4f13E4]= true;
314             banned[0xF6387FD97ada73769A130B5aCAE3213a01312c5e]= true;
315             banned[0x562680a4dC50ed2f14d75BF31f494cfE0b8D10a1]= true;
316             banned[0xe25B28b7Bc3ac024580CEba03C24f1c9cf476b3E]= true;
317             banned[0xdBA9f715Eda560E048FF9Ed695AB3B9a248d17A5]= true;
318             banned[0x67592fAB01Dc0765a9B46Dc9C1741D8461Df9195]= true;
319             banned[0x73D0D29774A750584926F8bb11e7544324B21236]= true;
320             banned[0x52F8F9dD6A8fD1813463c08A93bbFBc09f7202ae]= true;
321             banned[0x7Dd7D2ed5AA568A88d0843d2Fb1E9505e275B1a5]= true;
322             banned[0x3e43c358787e7254C480157C89a9c6DC1761c221]= true;
323             banned[0x96E4dAfC3652082E5b1c44D35b3b84a9D064da0D]= true;
324             banned[0xB9467fc3f9fA925b7E79355C04eE4Bf905dBd5CD]= true;
325             banned[0x7E2374BDA6820c6dd460e840c7b22b400157ecf6]= true;
326             banned[0xeb662589DBEe58a96aD4af1fe5dd01dd14aA9D9c]= true;
327             banned[0xb5451349F5BC3D4ab0d060E15A98234e7A512EA8]= true;
328             banned[0x113726a3F9dC4341a5e80d1A1729E53e6eB3c0f2]= true;
329             banned[0x194aaD876e1c17fa2326AB7AA4f8e75F8ad8A066]= true;
330             banned[0x51b079670D537FE5925DdfD76DE204FbC93D0F95]= true;
331             banned[0x5E5865808b7e2bF472fc682bC01c3F152846F632]= true;
332             banned[0x3b3CA610C7Cb79a2A14AF855Fcfd515cff5e4974]= true;
333             banned[0xD5a63D12e11dE67bcDe01312fe1bf649abd5B865]= true;
334             banned[0x2928ad4479b9936eA7D67BeaB7676e0228Cc72D3]= true;
335             banned[0xf5c4aFb5a16251E052467817681a5FD5150987Ff]= true;
336             banned[0x940028AD30E23b1d57af25774BE7701A062a9151]= true;
337             banned[0xe1eEc8a065b695821bD3889842e69d94D4Edb352]= true;
338             banned[0xa648b4Ff446C7D2f6d71ec3d0361B2264AA17822]= true;
339             banned[0x391bC0658A39Ef40Fb1f59E0FCa6FE9993B6eDdF]= true;
340             banned[0xE919adc4e577d9712021BCaEf2461a6Fe4e016Ad]= true;
341             banned[0x47aB1A12d624b53060d090af4B5490F40B7F9BA6]= true;
342             banned[0x17e54E4375397BF5Dd6821cCFb8a4Ec448e4D5b8]= true;
343             banned[0x48c04ed5691981C42154C6167398f95e8f38a7fF]= true;
344             banned[0x0Bab54dfEC0BE1D6Ae11062e9f951D245ef64c65]= true;
345             banned[0x6c089a728f6A5d91218A13892E576067D77A3958]= true;
346         }
347 
348     }
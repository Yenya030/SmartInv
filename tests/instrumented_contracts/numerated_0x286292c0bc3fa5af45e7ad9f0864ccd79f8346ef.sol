1 pragma solidity ^0.4.19;
2 // <ORACLIZE_API>
3 /*
4 Copyright (c) 2015-2016 Oraclize SRL
5 Copyright (c) 2016 Oraclize LTD
6 
7 
8 
9 Permission is hereby granted, free of charge, to any person obtaining a copy
10 of this software and associated documentation files (the "Software"), to deal
11 in the Software without restriction, including without limitation the rights
12 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
13 copies of the Software, and to permit persons to whom the Software is
14 furnished to do so, subject to the following conditions:
15 
16 
17 
18 The above copyright notice and this permission notice shall be included in
19 all copies or substantial portions of the Software.
20 
21 
22 
23 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
24 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
25 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
26 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
27 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
28 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
29 THE SOFTWARE.
30 */
31 
32 pragma solidity ^0.4.0;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
33 
34 contract OraclizeI {
35     address public cbAddress;
36     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
37     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
38     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
39     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
40     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
41     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
42     function getPrice(string _datasource) returns (uint _dsprice);
43     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
44     function useCoupon(string _coupon);
45     function setProofType(byte _proofType);
46     function setConfig(bytes32 _config);
47     function setCustomGasPrice(uint _gasPrice);
48     function randomDS_getSessionPubKeyHash() returns(bytes32);
49 }
50 contract OraclizeAddrResolverI {
51     function getAddress() returns (address _addr);
52 }
53 contract usingOraclize {
54     uint constant day = 60*60*24;
55     uint constant week = 60*60*24*7;
56     uint constant month = 60*60*24*30;
57     byte constant proofType_NONE = 0x00;
58     byte constant proofType_TLSNotary = 0x10;
59     byte constant proofType_Android = 0x20;
60     byte constant proofType_Ledger = 0x30;
61     byte constant proofType_Native = 0xF0;
62     byte constant proofStorage_IPFS = 0x01;
63     uint8 constant networkID_auto = 0;
64     uint8 constant networkID_mainnet = 1;
65     uint8 constant networkID_testnet = 2;
66     uint8 constant networkID_morden = 2;
67     uint8 constant networkID_consensys = 161;
68 
69     OraclizeAddrResolverI OAR;
70 
71     OraclizeI oraclize;
72     modifier oraclizeAPI {
73         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
74             oraclize_setNetwork(networkID_auto);
75 
76         if(address(oraclize) != OAR.getAddress())
77             oraclize = OraclizeI(OAR.getAddress());
78 
79         _;
80     }
81     modifier coupon(string code){
82         oraclize = OraclizeI(OAR.getAddress());
83         oraclize.useCoupon(code);
84         _;
85     }
86 
87     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
88         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
89             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
90             oraclize_setNetworkName("eth_mainnet");
91             return true;
92         }
93         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
94             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
95             oraclize_setNetworkName("eth_ropsten3");
96             return true;
97         }
98         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
99             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
100             oraclize_setNetworkName("eth_kovan");
101             return true;
102         }
103         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
104             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
105             oraclize_setNetworkName("eth_rinkeby");
106             return true;
107         }
108         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
109             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
110             return true;
111         }
112         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
113             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
114             return true;
115         }
116         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
117             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
118             return true;
119         }
120         return false;
121     }
122 
123     function __callback(bytes32 myid, string result) {
124         __callback(myid, result, new bytes(0));
125     }
126     function __callback(bytes32 myid, string result, bytes proof) {
127     }
128 
129     function oraclize_useCoupon(string code) oraclizeAPI internal {
130         oraclize.useCoupon(code);
131     }
132 
133     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
134         return oraclize.getPrice(datasource);
135     }
136 
137     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
138         return oraclize.getPrice(datasource, gaslimit);
139     }
140 
141     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
142         uint price = oraclize.getPrice(datasource);
143         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
144         return oraclize.query.value(price)(0, datasource, arg);
145     }
146     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
147         uint price = oraclize.getPrice(datasource);
148         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
149         return oraclize.query.value(price)(timestamp, datasource, arg);
150     }
151     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
152         uint price = oraclize.getPrice(datasource, gaslimit);
153         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
154         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
155     }
156     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
157         uint price = oraclize.getPrice(datasource, gaslimit);
158         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
159         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
160     }
161     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
162         uint price = oraclize.getPrice(datasource);
163         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
164         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
165     }
166     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
167         uint price = oraclize.getPrice(datasource);
168         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
169         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
170     }
171     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
172         uint price = oraclize.getPrice(datasource, gaslimit);
173         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
174         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
175     }
176     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
177         uint price = oraclize.getPrice(datasource, gaslimit);
178         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
179         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
180     }
181     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
182         uint price = oraclize.getPrice(datasource);
183         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
184         bytes memory args = stra2cbor(argN);
185         return oraclize.queryN.value(price)(0, datasource, args);
186     }
187     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
188         uint price = oraclize.getPrice(datasource);
189         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
190         bytes memory args = stra2cbor(argN);
191         return oraclize.queryN.value(price)(timestamp, datasource, args);
192     }
193     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
194         uint price = oraclize.getPrice(datasource, gaslimit);
195         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
196         bytes memory args = stra2cbor(argN);
197         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
198     }
199     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
200         uint price = oraclize.getPrice(datasource, gaslimit);
201         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
202         bytes memory args = stra2cbor(argN);
203         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
204     }
205     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
206         string[] memory dynargs = new string[](1);
207         dynargs[0] = args[0];
208         return oraclize_query(datasource, dynargs);
209     }
210     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
211         string[] memory dynargs = new string[](1);
212         dynargs[0] = args[0];
213         return oraclize_query(timestamp, datasource, dynargs);
214     }
215     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
216         string[] memory dynargs = new string[](1);
217         dynargs[0] = args[0];
218         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
219     }
220     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
221         string[] memory dynargs = new string[](1);
222         dynargs[0] = args[0];
223         return oraclize_query(datasource, dynargs, gaslimit);
224     }
225 
226     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
227         string[] memory dynargs = new string[](2);
228         dynargs[0] = args[0];
229         dynargs[1] = args[1];
230         return oraclize_query(datasource, dynargs);
231     }
232     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
233         string[] memory dynargs = new string[](2);
234         dynargs[0] = args[0];
235         dynargs[1] = args[1];
236         return oraclize_query(timestamp, datasource, dynargs);
237     }
238     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
239         string[] memory dynargs = new string[](2);
240         dynargs[0] = args[0];
241         dynargs[1] = args[1];
242         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
243     }
244     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
245         string[] memory dynargs = new string[](2);
246         dynargs[0] = args[0];
247         dynargs[1] = args[1];
248         return oraclize_query(datasource, dynargs, gaslimit);
249     }
250     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
251         string[] memory dynargs = new string[](3);
252         dynargs[0] = args[0];
253         dynargs[1] = args[1];
254         dynargs[2] = args[2];
255         return oraclize_query(datasource, dynargs);
256     }
257     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
258         string[] memory dynargs = new string[](3);
259         dynargs[0] = args[0];
260         dynargs[1] = args[1];
261         dynargs[2] = args[2];
262         return oraclize_query(timestamp, datasource, dynargs);
263     }
264     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
265         string[] memory dynargs = new string[](3);
266         dynargs[0] = args[0];
267         dynargs[1] = args[1];
268         dynargs[2] = args[2];
269         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
270     }
271     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
272         string[] memory dynargs = new string[](3);
273         dynargs[0] = args[0];
274         dynargs[1] = args[1];
275         dynargs[2] = args[2];
276         return oraclize_query(datasource, dynargs, gaslimit);
277     }
278 
279     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
280         string[] memory dynargs = new string[](4);
281         dynargs[0] = args[0];
282         dynargs[1] = args[1];
283         dynargs[2] = args[2];
284         dynargs[3] = args[3];
285         return oraclize_query(datasource, dynargs);
286     }
287     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
288         string[] memory dynargs = new string[](4);
289         dynargs[0] = args[0];
290         dynargs[1] = args[1];
291         dynargs[2] = args[2];
292         dynargs[3] = args[3];
293         return oraclize_query(timestamp, datasource, dynargs);
294     }
295     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
296         string[] memory dynargs = new string[](4);
297         dynargs[0] = args[0];
298         dynargs[1] = args[1];
299         dynargs[2] = args[2];
300         dynargs[3] = args[3];
301         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
302     }
303     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
304         string[] memory dynargs = new string[](4);
305         dynargs[0] = args[0];
306         dynargs[1] = args[1];
307         dynargs[2] = args[2];
308         dynargs[3] = args[3];
309         return oraclize_query(datasource, dynargs, gaslimit);
310     }
311     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
312         string[] memory dynargs = new string[](5);
313         dynargs[0] = args[0];
314         dynargs[1] = args[1];
315         dynargs[2] = args[2];
316         dynargs[3] = args[3];
317         dynargs[4] = args[4];
318         return oraclize_query(datasource, dynargs);
319     }
320     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
321         string[] memory dynargs = new string[](5);
322         dynargs[0] = args[0];
323         dynargs[1] = args[1];
324         dynargs[2] = args[2];
325         dynargs[3] = args[3];
326         dynargs[4] = args[4];
327         return oraclize_query(timestamp, datasource, dynargs);
328     }
329     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
330         string[] memory dynargs = new string[](5);
331         dynargs[0] = args[0];
332         dynargs[1] = args[1];
333         dynargs[2] = args[2];
334         dynargs[3] = args[3];
335         dynargs[4] = args[4];
336         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
337     }
338     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
339         string[] memory dynargs = new string[](5);
340         dynargs[0] = args[0];
341         dynargs[1] = args[1];
342         dynargs[2] = args[2];
343         dynargs[3] = args[3];
344         dynargs[4] = args[4];
345         return oraclize_query(datasource, dynargs, gaslimit);
346     }
347     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
348         uint price = oraclize.getPrice(datasource);
349         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
350         bytes memory args = ba2cbor(argN);
351         return oraclize.queryN.value(price)(0, datasource, args);
352     }
353     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
354         uint price = oraclize.getPrice(datasource);
355         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
356         bytes memory args = ba2cbor(argN);
357         return oraclize.queryN.value(price)(timestamp, datasource, args);
358     }
359     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
360         uint price = oraclize.getPrice(datasource, gaslimit);
361         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
362         bytes memory args = ba2cbor(argN);
363         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
364     }
365     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
366         uint price = oraclize.getPrice(datasource, gaslimit);
367         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
368         bytes memory args = ba2cbor(argN);
369         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
370     }
371     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
372         bytes[] memory dynargs = new bytes[](1);
373         dynargs[0] = args[0];
374         return oraclize_query(datasource, dynargs);
375     }
376     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
377         bytes[] memory dynargs = new bytes[](1);
378         dynargs[0] = args[0];
379         return oraclize_query(timestamp, datasource, dynargs);
380     }
381     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
382         bytes[] memory dynargs = new bytes[](1);
383         dynargs[0] = args[0];
384         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
385     }
386     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
387         bytes[] memory dynargs = new bytes[](1);
388         dynargs[0] = args[0];
389         return oraclize_query(datasource, dynargs, gaslimit);
390     }
391 
392     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
393         bytes[] memory dynargs = new bytes[](2);
394         dynargs[0] = args[0];
395         dynargs[1] = args[1];
396         return oraclize_query(datasource, dynargs);
397     }
398     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
399         bytes[] memory dynargs = new bytes[](2);
400         dynargs[0] = args[0];
401         dynargs[1] = args[1];
402         return oraclize_query(timestamp, datasource, dynargs);
403     }
404     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
405         bytes[] memory dynargs = new bytes[](2);
406         dynargs[0] = args[0];
407         dynargs[1] = args[1];
408         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
409     }
410     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
411         bytes[] memory dynargs = new bytes[](2);
412         dynargs[0] = args[0];
413         dynargs[1] = args[1];
414         return oraclize_query(datasource, dynargs, gaslimit);
415     }
416     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
417         bytes[] memory dynargs = new bytes[](3);
418         dynargs[0] = args[0];
419         dynargs[1] = args[1];
420         dynargs[2] = args[2];
421         return oraclize_query(datasource, dynargs);
422     }
423     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
424         bytes[] memory dynargs = new bytes[](3);
425         dynargs[0] = args[0];
426         dynargs[1] = args[1];
427         dynargs[2] = args[2];
428         return oraclize_query(timestamp, datasource, dynargs);
429     }
430     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
431         bytes[] memory dynargs = new bytes[](3);
432         dynargs[0] = args[0];
433         dynargs[1] = args[1];
434         dynargs[2] = args[2];
435         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
436     }
437     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
438         bytes[] memory dynargs = new bytes[](3);
439         dynargs[0] = args[0];
440         dynargs[1] = args[1];
441         dynargs[2] = args[2];
442         return oraclize_query(datasource, dynargs, gaslimit);
443     }
444 
445     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
446         bytes[] memory dynargs = new bytes[](4);
447         dynargs[0] = args[0];
448         dynargs[1] = args[1];
449         dynargs[2] = args[2];
450         dynargs[3] = args[3];
451         return oraclize_query(datasource, dynargs);
452     }
453     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
454         bytes[] memory dynargs = new bytes[](4);
455         dynargs[0] = args[0];
456         dynargs[1] = args[1];
457         dynargs[2] = args[2];
458         dynargs[3] = args[3];
459         return oraclize_query(timestamp, datasource, dynargs);
460     }
461     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
462         bytes[] memory dynargs = new bytes[](4);
463         dynargs[0] = args[0];
464         dynargs[1] = args[1];
465         dynargs[2] = args[2];
466         dynargs[3] = args[3];
467         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
468     }
469     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
470         bytes[] memory dynargs = new bytes[](4);
471         dynargs[0] = args[0];
472         dynargs[1] = args[1];
473         dynargs[2] = args[2];
474         dynargs[3] = args[3];
475         return oraclize_query(datasource, dynargs, gaslimit);
476     }
477     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
478         bytes[] memory dynargs = new bytes[](5);
479         dynargs[0] = args[0];
480         dynargs[1] = args[1];
481         dynargs[2] = args[2];
482         dynargs[3] = args[3];
483         dynargs[4] = args[4];
484         return oraclize_query(datasource, dynargs);
485     }
486     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
487         bytes[] memory dynargs = new bytes[](5);
488         dynargs[0] = args[0];
489         dynargs[1] = args[1];
490         dynargs[2] = args[2];
491         dynargs[3] = args[3];
492         dynargs[4] = args[4];
493         return oraclize_query(timestamp, datasource, dynargs);
494     }
495     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
496         bytes[] memory dynargs = new bytes[](5);
497         dynargs[0] = args[0];
498         dynargs[1] = args[1];
499         dynargs[2] = args[2];
500         dynargs[3] = args[3];
501         dynargs[4] = args[4];
502         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
503     }
504     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
505         bytes[] memory dynargs = new bytes[](5);
506         dynargs[0] = args[0];
507         dynargs[1] = args[1];
508         dynargs[2] = args[2];
509         dynargs[3] = args[3];
510         dynargs[4] = args[4];
511         return oraclize_query(datasource, dynargs, gaslimit);
512     }
513 
514     function oraclize_cbAddress() oraclizeAPI internal returns (address){
515         return oraclize.cbAddress();
516     }
517     function oraclize_setProof(byte proofP) oraclizeAPI internal {
518         return oraclize.setProofType(proofP);
519     }
520     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
521         return oraclize.setCustomGasPrice(gasPrice);
522     }
523     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
524         return oraclize.setConfig(config);
525     }
526 
527     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
528         return oraclize.randomDS_getSessionPubKeyHash();
529     }
530 
531     function getCodeSize(address _addr) constant internal returns(uint _size) {
532         assembly {
533             _size := extcodesize(_addr)
534         }
535     }
536 
537     function parseAddr(string _a) internal returns (address){
538         bytes memory tmp = bytes(_a);
539         uint160 iaddr = 0;
540         uint160 b1;
541         uint160 b2;
542         for (uint i=2; i<2+2*20; i+=2){
543             iaddr *= 256;
544             b1 = uint160(tmp[i]);
545             b2 = uint160(tmp[i+1]);
546             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
547             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
548             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
549             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
550             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
551             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
552             iaddr += (b1*16+b2);
553         }
554         return address(iaddr);
555     }
556 
557     function strCompare(string _a, string _b) internal returns (int) {
558         bytes memory a = bytes(_a);
559         bytes memory b = bytes(_b);
560         uint minLength = a.length;
561         if (b.length < minLength) minLength = b.length;
562         for (uint i = 0; i < minLength; i ++)
563             if (a[i] < b[i])
564                 return -1;
565             else if (a[i] > b[i])
566                 return 1;
567         if (a.length < b.length)
568             return -1;
569         else if (a.length > b.length)
570             return 1;
571         else
572             return 0;
573     }
574 
575     function indexOf(string _haystack, string _needle) internal returns (int) {
576         bytes memory h = bytes(_haystack);
577         bytes memory n = bytes(_needle);
578         if(h.length < 1 || n.length < 1 || (n.length > h.length))
579             return -1;
580         else if(h.length > (2**128 -1))
581             return -1;
582         else
583         {
584             uint subindex = 0;
585             for (uint i = 0; i < h.length; i ++)
586             {
587                 if (h[i] == n[0])
588                 {
589                     subindex = 1;
590                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
591                     {
592                         subindex++;
593                     }
594                     if(subindex == n.length)
595                         return int(i);
596                 }
597             }
598             return -1;
599         }
600     }
601 
602     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
603         bytes memory _ba = bytes(_a);
604         bytes memory _bb = bytes(_b);
605         bytes memory _bc = bytes(_c);
606         bytes memory _bd = bytes(_d);
607         bytes memory _be = bytes(_e);
608         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
609         bytes memory babcde = bytes(abcde);
610         uint k = 0;
611         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
612         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
613         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
614         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
615         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
616         return string(babcde);
617     }
618 
619     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
620         return strConcat(_a, _b, _c, _d, "");
621     }
622 
623     function strConcat(string _a, string _b, string _c) internal returns (string) {
624         return strConcat(_a, _b, _c, "", "");
625     }
626 
627     function strConcat(string _a, string _b) internal returns (string) {
628         return strConcat(_a, _b, "", "", "");
629     }
630 
631     // parseInt
632     function parseInt(string _a) internal returns (uint) {
633         return parseInt(_a, 0);
634     }
635 
636     // parseInt(parseFloat*10^_b)
637     function parseInt(string _a, uint _b) internal returns (uint) {
638         bytes memory bresult = bytes(_a);
639         uint mint = 0;
640         bool decimals = false;
641         for (uint i=0; i<bresult.length; i++){
642             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
643                 if (decimals){
644                    if (_b == 0) break;
645                     else _b--;
646                 }
647                 mint *= 10;
648                 mint += uint(bresult[i]) - 48;
649             } else if (bresult[i] == 46) decimals = true;
650         }
651         if (_b > 0) mint *= 10**_b;
652         return mint;
653     }
654 
655     function uint2str(uint i) internal returns (string){
656         if (i == 0) return "0";
657         uint j = i;
658         uint len;
659         while (j != 0){
660             len++;
661             j /= 10;
662         }
663         bytes memory bstr = new bytes(len);
664         uint k = len - 1;
665         while (i != 0){
666             bstr[k--] = byte(48 + i % 10);
667             i /= 10;
668         }
669         return string(bstr);
670     }
671 
672     function stra2cbor(string[] arr) internal returns (bytes) {
673             uint arrlen = arr.length;
674 
675             // get correct cbor output length
676             uint outputlen = 0;
677             bytes[] memory elemArray = new bytes[](arrlen);
678             for (uint i = 0; i < arrlen; i++) {
679                 elemArray[i] = (bytes(arr[i]));
680                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
681             }
682             uint ctr = 0;
683             uint cborlen = arrlen + 0x80;
684             outputlen += byte(cborlen).length;
685             bytes memory res = new bytes(outputlen);
686 
687             while (byte(cborlen).length > ctr) {
688                 res[ctr] = byte(cborlen)[ctr];
689                 ctr++;
690             }
691             for (i = 0; i < arrlen; i++) {
692                 res[ctr] = 0x5F;
693                 ctr++;
694                 for (uint x = 0; x < elemArray[i].length; x++) {
695                     // if there's a bug with larger strings, this may be the culprit
696                     if (x % 23 == 0) {
697                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
698                         elemcborlen += 0x40;
699                         uint lctr = ctr;
700                         while (byte(elemcborlen).length > ctr - lctr) {
701                             res[ctr] = byte(elemcborlen)[ctr - lctr];
702                             ctr++;
703                         }
704                     }
705                     res[ctr] = elemArray[i][x];
706                     ctr++;
707                 }
708                 res[ctr] = 0xFF;
709                 ctr++;
710             }
711             return res;
712         }
713 
714     function ba2cbor(bytes[] arr) internal returns (bytes) {
715             uint arrlen = arr.length;
716 
717             // get correct cbor output length
718             uint outputlen = 0;
719             bytes[] memory elemArray = new bytes[](arrlen);
720             for (uint i = 0; i < arrlen; i++) {
721                 elemArray[i] = (bytes(arr[i]));
722                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
723             }
724             uint ctr = 0;
725             uint cborlen = arrlen + 0x80;
726             outputlen += byte(cborlen).length;
727             bytes memory res = new bytes(outputlen);
728 
729             while (byte(cborlen).length > ctr) {
730                 res[ctr] = byte(cborlen)[ctr];
731                 ctr++;
732             }
733             for (i = 0; i < arrlen; i++) {
734                 res[ctr] = 0x5F;
735                 ctr++;
736                 for (uint x = 0; x < elemArray[i].length; x++) {
737                     // if there's a bug with larger strings, this may be the culprit
738                     if (x % 23 == 0) {
739                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
740                         elemcborlen += 0x40;
741                         uint lctr = ctr;
742                         while (byte(elemcborlen).length > ctr - lctr) {
743                             res[ctr] = byte(elemcborlen)[ctr - lctr];
744                             ctr++;
745                         }
746                     }
747                     res[ctr] = elemArray[i][x];
748                     ctr++;
749                 }
750                 res[ctr] = 0xFF;
751                 ctr++;
752             }
753             return res;
754         }
755 
756 
757     string oraclize_network_name;
758     function oraclize_setNetworkName(string _network_name) internal {
759         oraclize_network_name = _network_name;
760     }
761 
762     function oraclize_getNetworkName() internal returns (string) {
763         return oraclize_network_name;
764     }
765 
766     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
767         if ((_nbytes == 0)||(_nbytes > 32)) throw;
768         bytes memory nbytes = new bytes(1);
769         nbytes[0] = byte(_nbytes);
770         bytes memory unonce = new bytes(32);
771         bytes memory sessionKeyHash = new bytes(32);
772         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
773         assembly {
774             mstore(unonce, 0x20)
775             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
776             mstore(sessionKeyHash, 0x20)
777             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
778         }
779         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
780         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
781         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
782         return queryId;
783     }
784 
785     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
786         oraclize_randomDS_args[queryId] = commitment;
787     }
788 
789     mapping(bytes32=>bytes32) oraclize_randomDS_args;
790     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
791 
792     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
793         bool sigok;
794         address signer;
795 
796         bytes32 sigr;
797         bytes32 sigs;
798 
799         bytes memory sigr_ = new bytes(32);
800         uint offset = 4+(uint(dersig[3]) - 0x20);
801         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
802         bytes memory sigs_ = new bytes(32);
803         offset += 32 + 2;
804         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
805 
806         assembly {
807             sigr := mload(add(sigr_, 32))
808             sigs := mload(add(sigs_, 32))
809         }
810 
811 
812         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
813         if (address(sha3(pubkey)) == signer) return true;
814         else {
815             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
816             return (address(sha3(pubkey)) == signer);
817         }
818     }
819 
820     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
821         bool sigok;
822 
823         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
824         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
825         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
826 
827         bytes memory appkey1_pubkey = new bytes(64);
828         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
829 
830         bytes memory tosign2 = new bytes(1+65+32);
831         tosign2[0] = 1; //role
832         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
833         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
834         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
835         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
836 
837         if (sigok == false) return false;
838 
839 
840         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
841         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
842 
843         bytes memory tosign3 = new bytes(1+65);
844         tosign3[0] = 0xFE;
845         copyBytes(proof, 3, 65, tosign3, 1);
846 
847         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
848         copyBytes(proof, 3+65, sig3.length, sig3, 0);
849 
850         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
851 
852         return sigok;
853     }
854 
855     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
856         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
857         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
858 
859         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
860         if (proofVerified == false) throw;
861 
862         _;
863     }
864 
865     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
866         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
867         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
868 
869         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
870         if (proofVerified == false) return 2;
871 
872         return 0;
873     }
874 
875     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
876         bool match_ = true;
877         
878         for (uint256 i=0; i< n_random_bytes; i++) {
879             if (content[i] != prefix[i]) match_ = false;
880         }
881 
882         return match_;
883     }
884 
885     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
886 
887         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
888         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
889         bytes memory keyhash = new bytes(32);
890         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
891         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
892 
893         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
894         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
895 
896         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
897         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
898 
899         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
900         // This is to verify that the computed args match with the ones specified in the query.
901         bytes memory commitmentSlice1 = new bytes(8+1+32);
902         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
903 
904         bytes memory sessionPubkey = new bytes(64);
905         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
906         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
907 
908         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
909         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
910             delete oraclize_randomDS_args[queryId];
911         } else return false;
912 
913 
914         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
915         bytes memory tosign1 = new bytes(32+8+1+32);
916         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
917         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
918 
919         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
920         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
921             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
922         }
923 
924         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
925     }
926 
927 
928     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
929     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
930         uint minLength = length + toOffset;
931 
932         if (to.length < minLength) {
933             // Buffer too small
934             throw; // Should be a better way?
935         }
936 
937         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
938         uint i = 32 + fromOffset;
939         uint j = 32 + toOffset;
940 
941         while (i < (32 + fromOffset + length)) {
942             assembly {
943                 let tmp := mload(add(from, i))
944                 mstore(add(to, j), tmp)
945             }
946             i += 32;
947             j += 32;
948         }
949 
950         return to;
951     }
952 
953     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
954     // Duplicate Solidity's ecrecover, but catching the CALL return value
955     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
956         // We do our own memory management here. Solidity uses memory offset
957         // 0x40 to store the current end of memory. We write past it (as
958         // writes are memory extensions), but don't update the offset so
959         // Solidity will reuse it. The memory used here is only needed for
960         // this context.
961 
962         // FIXME: inline assembly can't access return values
963         bool ret;
964         address addr;
965 
966         assembly {
967             let size := mload(0x40)
968             mstore(size, hash)
969             mstore(add(size, 32), v)
970             mstore(add(size, 64), r)
971             mstore(add(size, 96), s)
972 
973             // NOTE: we can reuse the request memory because we deal with
974             //       the return code
975             ret := call(3000, 1, 0, size, 128, size, 32)
976             addr := mload(size)
977         }
978 
979         return (ret, addr);
980     }
981 
982     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
983     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
984         bytes32 r;
985         bytes32 s;
986         uint8 v;
987 
988         if (sig.length != 65)
989           return (false, 0);
990 
991         // The signature format is a compact form of:
992         //   {bytes32 r}{bytes32 s}{uint8 v}
993         // Compact means, uint8 is not padded to 32 bytes.
994         assembly {
995             r := mload(add(sig, 32))
996             s := mload(add(sig, 64))
997 
998             // Here we are loading the last 32 bytes. We exploit the fact that
999             // 'mload' will pad with zeroes if we overread.
1000             // There is no 'mload8' to do this, but that would be nicer.
1001             v := byte(0, mload(add(sig, 96)))
1002 
1003             // Alternative solution:
1004             // 'byte' is not working due to the Solidity parser, so lets
1005             // use the second best option, 'and'
1006             // v := and(mload(add(sig, 65)), 255)
1007         }
1008 
1009         // albeit non-transactional signatures are not specified by the YP, one would expect it
1010         // to match the YP range of [27, 28]
1011         //
1012         // geth uses [0, 1] and some clients have followed. This might change, see:
1013         //  https://github.com/ethereum/go-ethereum/issues/2053
1014         if (v < 27)
1015           v += 27;
1016 
1017         if (v != 27 && v != 28)
1018             return (false, 0);
1019 
1020         return safer_ecrecover(hash, v, r, s);
1021     }
1022 
1023 }
1024 // </ORACLIZE_API>
1025 
1026 // ----------------------------------------------------------------------------------------------
1027 // Claes Cash currency v2.0
1028 //  © Tulpanlöken Development 2018
1029 // claes.cash
1030 // Contract address: claescash.eth
1031 // ----------------------------------------------------------------------------------------------
1032  
1033 //
1034 //  ****************************************** Rule book *****************************************
1035 //  The round is 7 days long, the contract stops accepting bets 2 days prior the rounds end.
1036 //  The winners gets the the amount of new tweets and/or whats in the stake during the round. 
1037 //
1038 //  §0 if there is no winner the amount of new tweets is added in the stake as Claes Cash.  
1039 //  §1 If there are many winners they share the amount, and if the amount is not shareable with 
1040 //     the winners the first one to gather the prize will receive all of it. 
1041 //      Example 3 tweets, 5 winners, will not be able split. The first to withdraw will get 3 CC. 
1042 //  §2 If the amount is not shareable even between the number of winners, the first one to gather 
1043 //     the prize will get the bonus until the amount is even shareable.
1044 //      Example 5 tweets 3 winners, two will get 1 CC each, the first  will get  3 CC (5%3 = 2)
1045 //  §3 If number of tweets have decreased during the round, 0 tweets is the correct answer
1046 //     the winner or winners can gather the in stake amount,  and shared as in rule §1 and §2
1047 //  §4 Total supply of tokens is the intital supply + amount with winners, the rest is in the stake.
1048 //  §5 Decrease of tweets does not decrease the amount of total supply.
1049 //
1050 
1051 // ERC Token Standard #20 Interface
1052 // https://github.com/ethereum/EIPs/issues/20
1053 contract ERC20Interface {
1054     // Get the total token supply
1055     function totalSupply() public constant returns (uint256 totalSupply);
1056  
1057     // Get the account balance of another account with address _owner
1058     function balanceOf(address _owner) public constant returns (uint256 balance);
1059   
1060      // Send _value amount of tokens to address _to
1061      function transfer(address _to, uint256 _value) public returns (bool success);
1062   
1063      // Send _value amount of tokens from address _from to address _to
1064      function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
1065   
1066      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
1067      // If this function is called again it overwrites the current allowance with _value.
1068      // this function is required for some DEX functionality
1069      function approve(address _spender, uint256 _value) public returns (bool success);
1070   
1071      // Returns the amount which _spender is still allowed to withdraw from _owner
1072      function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
1073   
1074      // Triggered when tokens are transferred.
1075      event Transfer(address indexed _from, address indexed _to, uint256 _value);
1076   
1077      // Triggered whenever approve(address _spender, uint256 _value) is called.
1078      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
1079  }
1080  
1081 contract Claes is ERC20Interface, usingOraclize {
1082     string public constant symbol = "CC";
1083     string public constant name = "Claes Cash";
1084     uint8 public constant decimals = 0;
1085     
1086     // Storage for price in WEI for each day
1087     uint256[] ICOprice = [1705809128630710,1792607003891050,2161527412018200,3100000000000000,4850815505189580,7420474777448070,10495413267662000,13600000000000000,16352510087266600,18584222474460800,20297203394353400,21574226804123700,22514888079125500,23206887467068100,23718512088594900,24100000000000000,24387375737585200,24606234413965100,24774758401095100,24905928237129500,25009083126444700,25091004900315500,25156667500184900,25209756097561000,25253028594880900,25288569247319300,25317968132920800,25342449317335500,25362963238901500,25380253925826900,25394908351183700];
1088 
1089     // Testing query http://app.oraclize.it/home/test_query
1090     string _oraclizeURL = 'html(https://twitter.com/Claes_Hemberg).xpath(//*[@id="page-container"]/div[1]/div/div[2]/div/div/div[2]/div/div/ul/li[1]/a/span[3]/@data-count)';
1091     uint256 _totalSupply;
1092 
1093     uint256 public betPrice;
1094 
1095     uint256 public genesisTimestamp;
1096     uint256 public roundStartedTimestamp;
1097     uint256 public currentRoundCount;
1098 
1099     bool public migrationDone;
1100 
1101     // The owner is only able to change _oraclizeURL, and betPrice
1102     address public owner;
1103 
1104     // VIPs
1105     address _satoshi;
1106     address _nakamoto;
1107 
1108     // Struct to keep track of invidual bets
1109     struct Betted {
1110         bool betted;
1111         bool withdrawn;
1112         uint256 bet;
1113     }
1114 
1115     // Owner of account approves the transfer of an amount to another account, ERC-20 related
1116     mapping(address => mapping (address => uint256)) allowed;
1117 
1118     // Balances for each account, ERC-20 related
1119     mapping(address => uint256) balances;
1120 
1121     //Oraclize check, in case Oricalize would send the same callback twice
1122     mapping(bytes32=>bool) validIds;
1123     
1124     // Oraclized tweets for past rounds, round/number_of_tweets
1125     mapping(uint256 => uint256) pastRoundsTweets;
1126 
1127     // Keep track of rounds and bettings and withdraws, round/address/Betted.struct
1128     mapping(uint256 => mapping (address => Betted)) bets;
1129 
1130     // Kepp track of bets each round, round/bet/numbers
1131     mapping(uint256 => mapping(uint256 => uint256)) differentBets; 
1132 
1133     // Keep track of number of bets each tound, round/number_of_bets
1134     mapping(uint256 => uint256) numOfBets;
1135 
1136     // Keep track of stake each round, round/stake
1137     mapping(uint256 => uint256) roundStake;
1138 
1139     //Keep track if first winner have withdrawn, round/true or false
1140     mapping(uint256 => bool) firstWithdrawn;
1141 
1142     // Constructor
1143     function Claes() public {
1144         owner = msg.sender;
1145         _totalSupply = 22722;
1146         balances[address(this)] = _totalSupply;
1147         genesisTimestamp = 1514761218;
1148         roundStartedTimestamp = 1514761218;
1149         currentRoundCount = 1;
1150         pastRoundsTweets[0] = _totalSupply;
1151         migrationDone = false;
1152         betPrice = 1600000000000000;
1153         _satoshi = 0x8d501450A731f441647d538c5E97b86509CD2aD9;
1154         _nakamoto = 0x0892d55278a7C77dD3744F1c17c12B661c28D1A9;
1155     }
1156 
1157     function totalSupply() public constant returns (uint256 totalSupply) {
1158 
1159         totalSupply = _totalSupply;
1160 
1161     }
1162 
1163     // Cost modifier, revert if price is not met
1164     modifier costs(uint price) {
1165         if (msg.value >= price) {
1166             _;
1167         }else{
1168             revert();
1169         }
1170     }
1171 
1172     // Migration modfier, to lock the function
1173     modifier onlyMigration() {
1174         if (migrationDone) {
1175             revert();
1176         }else{
1177             _;
1178         }
1179     }
1180     // Functions with this modifier can only be executed by the owner
1181     modifier onlyOwner() {
1182         require(msg.sender == owner);
1183         _;
1184     }
1185     
1186     // The balance of a particular account?
1187     function balanceOf(address _owner) public constant returns (uint256 balance) {
1188         return balances[_owner];
1189     }
1190     
1191     // Transfer the balance from owner's account to another account
1192     function transfer(address _to, uint256 _amount) public returns (bool success) {
1193 
1194         if (balances[msg.sender] >= _amount 
1195             && _amount > 0
1196             && balances[_to] + _amount > balances[_to]) {
1197             balances[msg.sender] -= _amount;
1198             balances[_to] += _amount;
1199             Transfer(msg.sender, _to, _amount);
1200             return true;
1201         } else {
1202             return false;
1203         }
1204     }
1205 
1206     // Send _value amount of tokens from address _from to address _to
1207     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
1208     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
1209     // fees in sub-currencies; the command should fail unless the _from account has
1210     // deliberately authorized the sender of the message via some mechanism; we propose
1211     // these standardized APIs for approval:
1212     function transferFrom(
1213         address _from,
1214         address _to,
1215         uint256 _amount
1216     ) public returns (bool success) {
1217         if (balances[_from] >= _amount
1218             && allowed[_from][msg.sender] >= _amount
1219             && _amount > 0
1220             && balances[_to] + _amount > balances[_to]) {
1221             balances[_from] -= _amount;
1222             allowed[_from][msg.sender] -= _amount;
1223             balances[_to] += _amount;
1224             Transfer(_from, _to, _amount);
1225             return true;
1226         } else {
1227             return false;
1228         }
1229     }
1230     
1231     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
1232     // If this function is called again it overwrites the current allowance with _value. ERC-20 related
1233     function approve(address _spender, uint256 _amount) public returns (bool success) {
1234         allowed[msg.sender][_spender] = _amount;
1235         Approval(msg.sender, _spender, _amount);
1236         return true;
1237     }
1238 
1239     // ERC-20 related
1240     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
1241         return allowed[_owner][_spender];
1242     }
1243 
1244     // The callback function which oraclize will call after newRound has been called
1245     function __callback(bytes32 myid, string result) public {
1246         if (!validIds[myid]) revert();
1247         if (msg.sender != oraclize_cbAddress()) revert();
1248 
1249         uint256 totalTweets = uint256(parseInt(result));
1250         int256 diffTweets = int256(totalTweets - pastRoundsTweets[currentRoundCount-1]);
1251 
1252         // If tweets have decreased 
1253         if(diffTweets <= 0){
1254             //If there are any winners, then reset stake
1255             if(differentBets[currentRoundCount][0] > 0){
1256                 roundStake[currentRoundCount+1] = 0;
1257 
1258                 //there is at least one winner then the total supply is raised
1259                 _totalSupply = _totalSupply + roundStake[currentRoundCount];
1260             }else{
1261                 roundStake[currentRoundCount+1] = roundStake[currentRoundCount];
1262             }
1263         // If tweets have increased
1264         }else{
1265             //If there are any winners, then reset stake
1266            if(differentBets[currentRoundCount][uint256(diffTweets)] > 0){ 
1267                 roundStake[currentRoundCount+1] = 0;
1268 
1269                 //there is at least one winner then the total supply is raised
1270                 _totalSupply = _totalSupply + roundStake[currentRoundCount];
1271            }else{
1272                 // No winner then add to the stake
1273                 roundStake[currentRoundCount+1] = roundStake[currentRoundCount] +  uint256(diffTweets);
1274            }
1275         }
1276         // To make sure the window of one week does move, function newRound has to be called.
1277         roundStartedTimestamp = roundStartedTimestamp + 7 days;
1278         //roundStartedTimestamp = now;
1279 
1280         pastRoundsTweets[currentRoundCount] = totalTweets;
1281         currentRoundCount = currentRoundCount+1;
1282 
1283         bytes32 queryId = oraclize_query(roundStartedTimestamp + 7 days,'URL', _oraclizeURL);
1284         validIds[queryId] = true;
1285     }
1286 
1287     //Change the betting price if Ether would surge
1288     function changeBetPrice(uint256 setBetPrice) public onlyOwner {
1289         betPrice = setBetPrice;
1290     }
1291     
1292     //This function is only used if Twitter changes it's design
1293     function changeURL(string URL) public onlyOwner {
1294         _oraclizeURL = URL;
1295     }
1296     function getTweetsDiff(uint256 round) public constant returns(int256){
1297         return int256(pastRoundsTweets[round] - pastRoundsTweets[round-1]);
1298     }
1299 
1300     function getBetting(uint256 round, address lookupAddress) public constant returns(bool, uint256){
1301         return (bets[round][lookupAddress].betted, bets[round][lookupAddress].bet);
1302     }
1303 
1304 
1305     // Function to check if a specific adress is a winner during a specified round
1306     function checkBetting(uint256 round, address lookupAddress) public constant returns(bool){
1307         if((currentRoundCount>round) && (round>0)){
1308             int256 diffTweets = getTweetsDiff(round);
1309              // If tweets have decreased 
1310             if(diffTweets <= 0){
1311                 if(bets[round][lookupAddress].bet == 0 && bets[round][lookupAddress].betted){
1312                     return true;
1313                 }
1314             }else{
1315                 return (uint256(diffTweets) == bets[round][lookupAddress].bet) && bets[round][lookupAddress].betted;
1316             }
1317         }else{
1318             return false;
1319         }
1320     }
1321     
1322     // Backup function if oraclize does not run as scheduled, everyone can run this!
1323     function newRound() public payable {
1324         if( now >= (roundStartedTimestamp + 7 days + 2 hours)){
1325             if (oraclize_getPrice("URL") > this.balance) {
1326                 revert();
1327             }else{
1328                 bytes32 queryId = oraclize_query('URL', _oraclizeURL);
1329                 validIds[queryId] = true;
1330             }
1331         }else{
1332             revert();
1333         }
1334     }
1335 
1336     // Betting of number of tweets made during current round
1337     function betting (uint256 numTweets) public payable costs(betPrice){
1338         if( now <= (roundStartedTimestamp + 5 days)){
1339             bets[currentRoundCount][msg.sender].bet = numTweets;
1340             bets[currentRoundCount][msg.sender].betted = true;
1341             differentBets[currentRoundCount][numTweets] = differentBets[currentRoundCount][numTweets]+1;
1342             numOfBets[currentRoundCount] = numOfBets[currentRoundCount]+1;
1343         }else{
1344             revert();
1345         }
1346     }
1347     // Get number of bets
1348     function getNumBets(uint256 round) public constant returns(uint256){
1349         if(round == 0){
1350             return numOfBets[currentRoundCount]; 
1351         }else{
1352             return numOfBets[round];
1353         }
1354     }
1355     // Get what's in stake for a specific round
1356     function getInStake(uint256 round) public constant returns(uint256){
1357         if(round == 0){
1358             return roundStake[currentRoundCount]; 
1359            }else{
1360             return roundStake[round];
1361            }
1362     }
1363 
1364     // Get the number of total tweets for a specific round
1365     function getTweets(uint256 round) public constant returns(uint256){
1366         return pastRoundsTweets[round];
1367     }
1368 
1369     // Possible for winner to withdraw Claes Cash prize 
1370     function winnerWithdraw (uint256 round) public {
1371         // Check if the address is a winner and that the address have not withdrawn already
1372         if(checkBetting(round, msg.sender) && !bets[round][msg.sender].withdrawn){
1373             bets[round][msg.sender].withdrawn = true;
1374             int256 diffTweets = getTweetsDiff(round);
1375             uint256 prize;
1376             uint256 correctBet;
1377             // If tweets have decreased 
1378             if(diffTweets <= 0){
1379                 correctBet = 0;
1380             }else{
1381                 correctBet = uint256(diffTweets);
1382             }
1383 
1384             uint256 prizeShared = uint256((correctBet + roundStake[round])/differentBets[round][correctBet]);
1385             
1386             // By the rules the first withdrawn shall have a bonus if it's not possible to share even
1387             if(!firstWithdrawn[round]){
1388                 firstWithdrawn[round] = true;
1389                 prize = prizeShared + ((correctBet + roundStake[round])%differentBets[round][correctBet]);
1390             }else{
1391                 prize = prizeShared;
1392             }
1393             balances[msg.sender] = balances[msg.sender] + prize;
1394         }
1395     }
1396 
1397     // The ICO (Initial Claes Offering) function
1398     function initialClaesOffering() public payable{
1399         uint256 amount = uint256(msg.value/getPrice());
1400         if (balances[address(this)] < amount) revert();
1401 
1402         balances[address(this)] = balances[address(this)] - amount;
1403         balances[msg.sender] = balances[msg.sender] + amount;
1404 
1405         Transfer(address(this), msg.sender, amount); // Broadcast a message to the blockchain
1406     }
1407 
1408     // Get the current ICO price in WEI for each Claes, after 30 days the price increase is flaten out
1409     function getPrice() public constant returns (uint256){
1410         if (now < (genesisTimestamp + 30 days)){
1411             return uint256(ICOprice[(block.timestamp-genesisTimestamp)/(1 days)]);
1412         } else {
1413             return  25500000000000000;
1414         } 
1415     }
1416     
1417     function ownerWithdraw() public onlyOwner {
1418         uint256 balance = uint256(this.balance/2);
1419         if(this.balance > 0){
1420             _nakamoto.transfer(balance);
1421             _satoshi.transfer(balance);
1422         }
1423     }
1424 
1425     // This function is only intended to run once
1426     function migration(address account, uint256 amount, bool lock) public onlyOwner onlyMigration{
1427         balances[address(this)] = balances[address(this)] - amount;
1428         balances[account] = balances[account] + amount;
1429         Transfer(address(this), account, amount); // Broadcast a message to the blockchain
1430         if(lock){
1431             // locking migration
1432             migrationDone = true;
1433             //Start a new round
1434             bytes32 queryId = oraclize_query('URL', _oraclizeURL);
1435             validIds[queryId] = true;
1436         }
1437 
1438     }
1439 
1440     //Fallback function, accept donations
1441     function() public payable { }
1442 }
1 pragma solidity 0.4.20;
2 
3 // <ORACLIZE_API>
4 /*
5 Copyright (c) 2015-2016 Oraclize SRL
6 Copyright (c) 2016 Oraclize LTD
7 
8 
9 
10 Permission is hereby granted, free of charge, to any person obtaining a copy
11 of this software and associated documentation files (the "Software"), to deal
12 in the Software without restriction, including without limitation the rights
13 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
14 copies of the Software, and to permit persons to whom the Software is
15 furnished to do so, subject to the following conditions:
16 
17 
18 
19 The above copyright notice and this permission notice shall be included in
20 all copies or substantial portions of the Software.
21 
22 
23 
24 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
25 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
26 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
27 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
28 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
29 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
30 THE SOFTWARE.
31 */
32 
33 //
34 
35 contract OraclizeI {
36     address public cbAddress;
37     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
38     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
39     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
40     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
41     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
42     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
43     function getPrice(string _datasource) returns (uint _dsprice);
44     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
45     function useCoupon(string _coupon);
46     function setProofType(byte _proofType);
47     function setConfig(bytes32 _config);
48     function setCustomGasPrice(uint _gasPrice);
49     function randomDS_getSessionPubKeyHash() returns(bytes32);
50 }
51 contract OraclizeAddrResolverI {
52     function getAddress() returns (address _addr);
53 }
54 contract usingOraclize {
55     uint constant day = 60*60*24;
56     uint constant week = 60*60*24*7;
57     uint constant month = 60*60*24*30;
58     byte constant proofType_NONE = 0x00;
59     byte constant proofType_TLSNotary = 0x10;
60     byte constant proofType_Android = 0x20;
61     byte constant proofType_Ledger = 0x30;
62     byte constant proofType_Native = 0xF0;
63     byte constant proofStorage_IPFS = 0x01;
64     uint8 constant networkID_auto = 0;
65     uint8 constant networkID_mainnet = 1;
66     uint8 constant networkID_testnet = 2;
67     uint8 constant networkID_morden = 2;
68     uint8 constant networkID_consensys = 161;
69 
70     OraclizeAddrResolverI OAR;
71 
72     OraclizeI oraclize;
73     modifier oraclizeAPI {
74         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
75             oraclize_setNetwork(networkID_auto);
76 
77         if(address(oraclize) != OAR.getAddress())
78             oraclize = OraclizeI(OAR.getAddress());
79 
80         _;
81     }
82     modifier coupon(string code){
83         oraclize = OraclizeI(OAR.getAddress());
84         oraclize.useCoupon(code);
85         _;
86     }
87 
88     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
89         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
90             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
91             oraclize_setNetworkName("eth_mainnet");
92             return true;
93         }
94         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
95             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
96             oraclize_setNetworkName("eth_ropsten3");
97             return true;
98         }
99         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
100             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
101             oraclize_setNetworkName("eth_kovan");
102             return true;
103         }
104         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
105             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
106             oraclize_setNetworkName("eth_rinkeby");
107             return true;
108         }
109         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
110             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
111             return true;
112         }
113         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
114             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
115             return true;
116         }
117         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
118             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
119             return true;
120         }
121         return false;
122     }
123 
124     function __callback(bytes32 myid, string result) {
125         __callback(myid, result, new bytes(0));
126     }
127     function __callback(bytes32 myid, string result, bytes proof) {
128     }
129 
130     function oraclize_useCoupon(string code) oraclizeAPI internal {
131         oraclize.useCoupon(code);
132     }
133 
134     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
135         return oraclize.getPrice(datasource);
136     }
137 
138     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
139         return oraclize.getPrice(datasource, gaslimit);
140     }
141 
142     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
143         uint price = oraclize.getPrice(datasource);
144         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
145         return oraclize.query.value(price)(0, datasource, arg);
146     }
147     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
148         uint price = oraclize.getPrice(datasource);
149         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
150         return oraclize.query.value(price)(timestamp, datasource, arg);
151     }
152     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
153         uint price = oraclize.getPrice(datasource, gaslimit);
154         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
155         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
156     }
157     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
158         uint price = oraclize.getPrice(datasource, gaslimit);
159         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
160         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
161     }
162     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
163         uint price = oraclize.getPrice(datasource);
164         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
165         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
166     }
167     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
168         uint price = oraclize.getPrice(datasource);
169         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
170         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
171     }
172     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
173         uint price = oraclize.getPrice(datasource, gaslimit);
174         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
175         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
176     }
177     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
178         uint price = oraclize.getPrice(datasource, gaslimit);
179         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
180         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
181     }
182     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
183         uint price = oraclize.getPrice(datasource);
184         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
185         bytes memory args = stra2cbor(argN);
186         return oraclize.queryN.value(price)(0, datasource, args);
187     }
188     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
189         uint price = oraclize.getPrice(datasource);
190         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
191         bytes memory args = stra2cbor(argN);
192         return oraclize.queryN.value(price)(timestamp, datasource, args);
193     }
194     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
195         uint price = oraclize.getPrice(datasource, gaslimit);
196         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
197         bytes memory args = stra2cbor(argN);
198         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
199     }
200     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
201         uint price = oraclize.getPrice(datasource, gaslimit);
202         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
203         bytes memory args = stra2cbor(argN);
204         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
205     }
206     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
207         string[] memory dynargs = new string[](1);
208         dynargs[0] = args[0];
209         return oraclize_query(datasource, dynargs);
210     }
211     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
212         string[] memory dynargs = new string[](1);
213         dynargs[0] = args[0];
214         return oraclize_query(timestamp, datasource, dynargs);
215     }
216     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
217         string[] memory dynargs = new string[](1);
218         dynargs[0] = args[0];
219         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
220     }
221     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
222         string[] memory dynargs = new string[](1);
223         dynargs[0] = args[0];
224         return oraclize_query(datasource, dynargs, gaslimit);
225     }
226 
227     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
228         string[] memory dynargs = new string[](2);
229         dynargs[0] = args[0];
230         dynargs[1] = args[1];
231         return oraclize_query(datasource, dynargs);
232     }
233     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
234         string[] memory dynargs = new string[](2);
235         dynargs[0] = args[0];
236         dynargs[1] = args[1];
237         return oraclize_query(timestamp, datasource, dynargs);
238     }
239     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
240         string[] memory dynargs = new string[](2);
241         dynargs[0] = args[0];
242         dynargs[1] = args[1];
243         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
244     }
245     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
246         string[] memory dynargs = new string[](2);
247         dynargs[0] = args[0];
248         dynargs[1] = args[1];
249         return oraclize_query(datasource, dynargs, gaslimit);
250     }
251     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
252         string[] memory dynargs = new string[](3);
253         dynargs[0] = args[0];
254         dynargs[1] = args[1];
255         dynargs[2] = args[2];
256         return oraclize_query(datasource, dynargs);
257     }
258     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
259         string[] memory dynargs = new string[](3);
260         dynargs[0] = args[0];
261         dynargs[1] = args[1];
262         dynargs[2] = args[2];
263         return oraclize_query(timestamp, datasource, dynargs);
264     }
265     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
266         string[] memory dynargs = new string[](3);
267         dynargs[0] = args[0];
268         dynargs[1] = args[1];
269         dynargs[2] = args[2];
270         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
271     }
272     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
273         string[] memory dynargs = new string[](3);
274         dynargs[0] = args[0];
275         dynargs[1] = args[1];
276         dynargs[2] = args[2];
277         return oraclize_query(datasource, dynargs, gaslimit);
278     }
279 
280     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
281         string[] memory dynargs = new string[](4);
282         dynargs[0] = args[0];
283         dynargs[1] = args[1];
284         dynargs[2] = args[2];
285         dynargs[3] = args[3];
286         return oraclize_query(datasource, dynargs);
287     }
288     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
289         string[] memory dynargs = new string[](4);
290         dynargs[0] = args[0];
291         dynargs[1] = args[1];
292         dynargs[2] = args[2];
293         dynargs[3] = args[3];
294         return oraclize_query(timestamp, datasource, dynargs);
295     }
296     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
297         string[] memory dynargs = new string[](4);
298         dynargs[0] = args[0];
299         dynargs[1] = args[1];
300         dynargs[2] = args[2];
301         dynargs[3] = args[3];
302         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
303     }
304     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
305         string[] memory dynargs = new string[](4);
306         dynargs[0] = args[0];
307         dynargs[1] = args[1];
308         dynargs[2] = args[2];
309         dynargs[3] = args[3];
310         return oraclize_query(datasource, dynargs, gaslimit);
311     }
312     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
313         string[] memory dynargs = new string[](5);
314         dynargs[0] = args[0];
315         dynargs[1] = args[1];
316         dynargs[2] = args[2];
317         dynargs[3] = args[3];
318         dynargs[4] = args[4];
319         return oraclize_query(datasource, dynargs);
320     }
321     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
322         string[] memory dynargs = new string[](5);
323         dynargs[0] = args[0];
324         dynargs[1] = args[1];
325         dynargs[2] = args[2];
326         dynargs[3] = args[3];
327         dynargs[4] = args[4];
328         return oraclize_query(timestamp, datasource, dynargs);
329     }
330     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
331         string[] memory dynargs = new string[](5);
332         dynargs[0] = args[0];
333         dynargs[1] = args[1];
334         dynargs[2] = args[2];
335         dynargs[3] = args[3];
336         dynargs[4] = args[4];
337         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
338     }
339     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
340         string[] memory dynargs = new string[](5);
341         dynargs[0] = args[0];
342         dynargs[1] = args[1];
343         dynargs[2] = args[2];
344         dynargs[3] = args[3];
345         dynargs[4] = args[4];
346         return oraclize_query(datasource, dynargs, gaslimit);
347     }
348     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
349         uint price = oraclize.getPrice(datasource);
350         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
351         bytes memory args = ba2cbor(argN);
352         return oraclize.queryN.value(price)(0, datasource, args);
353     }
354     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
355         uint price = oraclize.getPrice(datasource);
356         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
357         bytes memory args = ba2cbor(argN);
358         return oraclize.queryN.value(price)(timestamp, datasource, args);
359     }
360     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
361         uint price = oraclize.getPrice(datasource, gaslimit);
362         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
363         bytes memory args = ba2cbor(argN);
364         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
365     }
366     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
367         uint price = oraclize.getPrice(datasource, gaslimit);
368         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
369         bytes memory args = ba2cbor(argN);
370         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
371     }
372     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
373         bytes[] memory dynargs = new bytes[](1);
374         dynargs[0] = args[0];
375         return oraclize_query(datasource, dynargs);
376     }
377     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
378         bytes[] memory dynargs = new bytes[](1);
379         dynargs[0] = args[0];
380         return oraclize_query(timestamp, datasource, dynargs);
381     }
382     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
383         bytes[] memory dynargs = new bytes[](1);
384         dynargs[0] = args[0];
385         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
386     }
387     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
388         bytes[] memory dynargs = new bytes[](1);
389         dynargs[0] = args[0];
390         return oraclize_query(datasource, dynargs, gaslimit);
391     }
392 
393     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
394         bytes[] memory dynargs = new bytes[](2);
395         dynargs[0] = args[0];
396         dynargs[1] = args[1];
397         return oraclize_query(datasource, dynargs);
398     }
399     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
400         bytes[] memory dynargs = new bytes[](2);
401         dynargs[0] = args[0];
402         dynargs[1] = args[1];
403         return oraclize_query(timestamp, datasource, dynargs);
404     }
405     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
406         bytes[] memory dynargs = new bytes[](2);
407         dynargs[0] = args[0];
408         dynargs[1] = args[1];
409         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
410     }
411     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
412         bytes[] memory dynargs = new bytes[](2);
413         dynargs[0] = args[0];
414         dynargs[1] = args[1];
415         return oraclize_query(datasource, dynargs, gaslimit);
416     }
417     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
418         bytes[] memory dynargs = new bytes[](3);
419         dynargs[0] = args[0];
420         dynargs[1] = args[1];
421         dynargs[2] = args[2];
422         return oraclize_query(datasource, dynargs);
423     }
424     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
425         bytes[] memory dynargs = new bytes[](3);
426         dynargs[0] = args[0];
427         dynargs[1] = args[1];
428         dynargs[2] = args[2];
429         return oraclize_query(timestamp, datasource, dynargs);
430     }
431     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
432         bytes[] memory dynargs = new bytes[](3);
433         dynargs[0] = args[0];
434         dynargs[1] = args[1];
435         dynargs[2] = args[2];
436         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
437     }
438     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
439         bytes[] memory dynargs = new bytes[](3);
440         dynargs[0] = args[0];
441         dynargs[1] = args[1];
442         dynargs[2] = args[2];
443         return oraclize_query(datasource, dynargs, gaslimit);
444     }
445 
446     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
447         bytes[] memory dynargs = new bytes[](4);
448         dynargs[0] = args[0];
449         dynargs[1] = args[1];
450         dynargs[2] = args[2];
451         dynargs[3] = args[3];
452         return oraclize_query(datasource, dynargs);
453     }
454     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
455         bytes[] memory dynargs = new bytes[](4);
456         dynargs[0] = args[0];
457         dynargs[1] = args[1];
458         dynargs[2] = args[2];
459         dynargs[3] = args[3];
460         return oraclize_query(timestamp, datasource, dynargs);
461     }
462     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
463         bytes[] memory dynargs = new bytes[](4);
464         dynargs[0] = args[0];
465         dynargs[1] = args[1];
466         dynargs[2] = args[2];
467         dynargs[3] = args[3];
468         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
469     }
470     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
471         bytes[] memory dynargs = new bytes[](4);
472         dynargs[0] = args[0];
473         dynargs[1] = args[1];
474         dynargs[2] = args[2];
475         dynargs[3] = args[3];
476         return oraclize_query(datasource, dynargs, gaslimit);
477     }
478     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
479         bytes[] memory dynargs = new bytes[](5);
480         dynargs[0] = args[0];
481         dynargs[1] = args[1];
482         dynargs[2] = args[2];
483         dynargs[3] = args[3];
484         dynargs[4] = args[4];
485         return oraclize_query(datasource, dynargs);
486     }
487     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
488         bytes[] memory dynargs = new bytes[](5);
489         dynargs[0] = args[0];
490         dynargs[1] = args[1];
491         dynargs[2] = args[2];
492         dynargs[3] = args[3];
493         dynargs[4] = args[4];
494         return oraclize_query(timestamp, datasource, dynargs);
495     }
496     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
497         bytes[] memory dynargs = new bytes[](5);
498         dynargs[0] = args[0];
499         dynargs[1] = args[1];
500         dynargs[2] = args[2];
501         dynargs[3] = args[3];
502         dynargs[4] = args[4];
503         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
504     }
505     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
506         bytes[] memory dynargs = new bytes[](5);
507         dynargs[0] = args[0];
508         dynargs[1] = args[1];
509         dynargs[2] = args[2];
510         dynargs[3] = args[3];
511         dynargs[4] = args[4];
512         return oraclize_query(datasource, dynargs, gaslimit);
513     }
514 
515     function oraclize_cbAddress() oraclizeAPI internal returns (address){
516         return oraclize.cbAddress();
517     }
518     function oraclize_setProof(byte proofP) oraclizeAPI internal {
519         return oraclize.setProofType(proofP);
520     }
521     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
522         return oraclize.setCustomGasPrice(gasPrice);
523     }
524     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
525         return oraclize.setConfig(config);
526     }
527 
528     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
529         return oraclize.randomDS_getSessionPubKeyHash();
530     }
531 
532     function getCodeSize(address _addr) constant internal returns(uint _size) {
533         assembly {
534             _size := extcodesize(_addr)
535         }
536     }
537 
538     function parseAddr(string _a) internal returns (address){
539         bytes memory tmp = bytes(_a);
540         uint160 iaddr = 0;
541         uint160 b1;
542         uint160 b2;
543         for (uint i=2; i<2+2*20; i+=2){
544             iaddr *= 256;
545             b1 = uint160(tmp[i]);
546             b2 = uint160(tmp[i+1]);
547             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
548             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
549             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
550             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
551             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
552             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
553             iaddr += (b1*16+b2);
554         }
555         return address(iaddr);
556     }
557 
558     function strCompare(string _a, string _b) internal returns (int) {
559         bytes memory a = bytes(_a);
560         bytes memory b = bytes(_b);
561         uint minLength = a.length;
562         if (b.length < minLength) minLength = b.length;
563         for (uint i = 0; i < minLength; i ++)
564             if (a[i] < b[i])
565                 return -1;
566             else if (a[i] > b[i])
567                 return 1;
568         if (a.length < b.length)
569             return -1;
570         else if (a.length > b.length)
571             return 1;
572         else
573             return 0;
574     }
575 
576     function indexOf(string _haystack, string _needle) internal returns (int) {
577         bytes memory h = bytes(_haystack);
578         bytes memory n = bytes(_needle);
579         if(h.length < 1 || n.length < 1 || (n.length > h.length))
580             return -1;
581         else if(h.length > (2**128 -1))
582             return -1;
583         else
584         {
585             uint subindex = 0;
586             for (uint i = 0; i < h.length; i ++)
587             {
588                 if (h[i] == n[0])
589                 {
590                     subindex = 1;
591                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
592                     {
593                         subindex++;
594                     }
595                     if(subindex == n.length)
596                         return int(i);
597                 }
598             }
599             return -1;
600         }
601     }
602 
603     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
604         bytes memory _ba = bytes(_a);
605         bytes memory _bb = bytes(_b);
606         bytes memory _bc = bytes(_c);
607         bytes memory _bd = bytes(_d);
608         bytes memory _be = bytes(_e);
609         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
610         bytes memory babcde = bytes(abcde);
611         uint k = 0;
612         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
613         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
614         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
615         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
616         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
617         return string(babcde);
618     }
619 
620     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
621         return strConcat(_a, _b, _c, _d, "");
622     }
623 
624     function strConcat(string _a, string _b, string _c) internal returns (string) {
625         return strConcat(_a, _b, _c, "", "");
626     }
627 
628     function strConcat(string _a, string _b) internal returns (string) {
629         return strConcat(_a, _b, "", "", "");
630     }
631 
632     // parseInt
633     function parseInt(string _a) internal returns (uint) {
634         return parseInt(_a, 0);
635     }
636 
637     // parseInt(parseFloat*10^_b)
638     function parseInt(string _a, uint _b) internal returns (uint) {
639         bytes memory bresult = bytes(_a);
640         uint mint = 0;
641         bool decimals = false;
642         for (uint i=0; i<bresult.length; i++){
643             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
644                 if (decimals){
645                    if (_b == 0) break;
646                     else _b--;
647                 }
648                 mint *= 10;
649                 mint += uint(bresult[i]) - 48;
650             } else if (bresult[i] == 46) decimals = true;
651         }
652         if (_b > 0) mint *= 10**_b;
653         return mint;
654     }
655 
656     function uint2str(uint i) internal returns (string){
657         if (i == 0) return "0";
658         uint j = i;
659         uint len;
660         while (j != 0){
661             len++;
662             j /= 10;
663         }
664         bytes memory bstr = new bytes(len);
665         uint k = len - 1;
666         while (i != 0){
667             bstr[k--] = byte(48 + i % 10);
668             i /= 10;
669         }
670         return string(bstr);
671     }
672 
673     function stra2cbor(string[] arr) internal returns (bytes) {
674             uint arrlen = arr.length;
675 
676             // get correct cbor output length
677             uint outputlen = 0;
678             bytes[] memory elemArray = new bytes[](arrlen);
679             for (uint i = 0; i < arrlen; i++) {
680                 elemArray[i] = (bytes(arr[i]));
681                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
682             }
683             uint ctr = 0;
684             uint cborlen = arrlen + 0x80;
685             outputlen += byte(cborlen).length;
686             bytes memory res = new bytes(outputlen);
687 
688             while (byte(cborlen).length > ctr) {
689                 res[ctr] = byte(cborlen)[ctr];
690                 ctr++;
691             }
692             for (i = 0; i < arrlen; i++) {
693                 res[ctr] = 0x5F;
694                 ctr++;
695                 for (uint x = 0; x < elemArray[i].length; x++) {
696                     // if there's a bug with larger strings, this may be the culprit
697                     if (x % 23 == 0) {
698                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
699                         elemcborlen += 0x40;
700                         uint lctr = ctr;
701                         while (byte(elemcborlen).length > ctr - lctr) {
702                             res[ctr] = byte(elemcborlen)[ctr - lctr];
703                             ctr++;
704                         }
705                     }
706                     res[ctr] = elemArray[i][x];
707                     ctr++;
708                 }
709                 res[ctr] = 0xFF;
710                 ctr++;
711             }
712             return res;
713         }
714 
715     function ba2cbor(bytes[] arr) internal returns (bytes) {
716             uint arrlen = arr.length;
717 
718             // get correct cbor output length
719             uint outputlen = 0;
720             bytes[] memory elemArray = new bytes[](arrlen);
721             for (uint i = 0; i < arrlen; i++) {
722                 elemArray[i] = (bytes(arr[i]));
723                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
724             }
725             uint ctr = 0;
726             uint cborlen = arrlen + 0x80;
727             outputlen += byte(cborlen).length;
728             bytes memory res = new bytes(outputlen);
729 
730             while (byte(cborlen).length > ctr) {
731                 res[ctr] = byte(cborlen)[ctr];
732                 ctr++;
733             }
734             for (i = 0; i < arrlen; i++) {
735                 res[ctr] = 0x5F;
736                 ctr++;
737                 for (uint x = 0; x < elemArray[i].length; x++) {
738                     // if there's a bug with larger strings, this may be the culprit
739                     if (x % 23 == 0) {
740                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
741                         elemcborlen += 0x40;
742                         uint lctr = ctr;
743                         while (byte(elemcborlen).length > ctr - lctr) {
744                             res[ctr] = byte(elemcborlen)[ctr - lctr];
745                             ctr++;
746                         }
747                     }
748                     res[ctr] = elemArray[i][x];
749                     ctr++;
750                 }
751                 res[ctr] = 0xFF;
752                 ctr++;
753             }
754             return res;
755         }
756 
757 
758     string oraclize_network_name;
759     function oraclize_setNetworkName(string _network_name) internal {
760         oraclize_network_name = _network_name;
761     }
762 
763     function oraclize_getNetworkName() internal returns (string) {
764         return oraclize_network_name;
765     }
766 
767     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
768         if ((_nbytes == 0)||(_nbytes > 32)) throw;
769         bytes memory nbytes = new bytes(1);
770         nbytes[0] = byte(_nbytes);
771         bytes memory unonce = new bytes(32);
772         bytes memory sessionKeyHash = new bytes(32);
773         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
774         assembly {
775             mstore(unonce, 0x20)
776             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
777             mstore(sessionKeyHash, 0x20)
778             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
779         }
780         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
781         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
782         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
783         return queryId;
784     }
785 
786     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
787         oraclize_randomDS_args[queryId] = commitment;
788     }
789 
790     mapping(bytes32=>bytes32) oraclize_randomDS_args;
791     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
792 
793     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
794         bool sigok;
795         address signer;
796 
797         bytes32 sigr;
798         bytes32 sigs;
799 
800         bytes memory sigr_ = new bytes(32);
801         uint offset = 4+(uint(dersig[3]) - 0x20);
802         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
803         bytes memory sigs_ = new bytes(32);
804         offset += 32 + 2;
805         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
806 
807         assembly {
808             sigr := mload(add(sigr_, 32))
809             sigs := mload(add(sigs_, 32))
810         }
811 
812 
813         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
814         if (address(sha3(pubkey)) == signer) return true;
815         else {
816             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
817             return (address(sha3(pubkey)) == signer);
818         }
819     }
820 
821     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
822         bool sigok;
823 
824         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
825         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
826         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
827 
828         bytes memory appkey1_pubkey = new bytes(64);
829         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
830 
831         bytes memory tosign2 = new bytes(1+65+32);
832         tosign2[0] = 1; //role
833         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
834         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
835         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
836         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
837 
838         if (sigok == false) return false;
839 
840 
841         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
842         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
843 
844         bytes memory tosign3 = new bytes(1+65);
845         tosign3[0] = 0xFE;
846         copyBytes(proof, 3, 65, tosign3, 1);
847 
848         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
849         copyBytes(proof, 3+65, sig3.length, sig3, 0);
850 
851         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
852 
853         return sigok;
854     }
855 
856     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
857         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
858         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
859 
860         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
861         if (proofVerified == false) throw;
862 
863         _;
864     }
865 
866     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
867         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
868         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
869 
870         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
871         if (proofVerified == false) return 2;
872 
873         return 0;
874     }
875 
876     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
877         bool match_ = true;
878         
879         for (uint256 i=0; i< n_random_bytes; i++) {
880             if (content[i] != prefix[i]) match_ = false;
881         }
882 
883         return match_;
884     }
885 
886     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
887 
888         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
889         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
890         bytes memory keyhash = new bytes(32);
891         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
892         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
893 
894         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
895         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
896 
897         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
898         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
899 
900         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
901         // This is to verify that the computed args match with the ones specified in the query.
902         bytes memory commitmentSlice1 = new bytes(8+1+32);
903         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
904 
905         bytes memory sessionPubkey = new bytes(64);
906         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
907         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
908 
909         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
910         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
911             delete oraclize_randomDS_args[queryId];
912         } else return false;
913 
914 
915         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
916         bytes memory tosign1 = new bytes(32+8+1+32);
917         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
918         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
919 
920         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
921         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
922             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
923         }
924 
925         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
926     }
927 
928 
929     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
930     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
931         uint minLength = length + toOffset;
932 
933         if (to.length < minLength) {
934             // Buffer too small
935             throw; // Should be a better way?
936         }
937 
938         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
939         uint i = 32 + fromOffset;
940         uint j = 32 + toOffset;
941 
942         while (i < (32 + fromOffset + length)) {
943             assembly {
944                 let tmp := mload(add(from, i))
945                 mstore(add(to, j), tmp)
946             }
947             i += 32;
948             j += 32;
949         }
950 
951         return to;
952     }
953 
954     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
955     // Duplicate Solidity's ecrecover, but catching the CALL return value
956     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
957         // We do our own memory management here. Solidity uses memory offset
958         // 0x40 to store the current end of memory. We write past it (as
959         // writes are memory extensions), but don't update the offset so
960         // Solidity will reuse it. The memory used here is only needed for
961         // this context.
962 
963         // FIXME: inline assembly can't access return values
964         bool ret;
965         address addr;
966 
967         assembly {
968             let size := mload(0x40)
969             mstore(size, hash)
970             mstore(add(size, 32), v)
971             mstore(add(size, 64), r)
972             mstore(add(size, 96), s)
973 
974             // NOTE: we can reuse the request memory because we deal with
975             //       the return code
976             ret := call(3000, 1, 0, size, 128, size, 32)
977             addr := mload(size)
978         }
979 
980         return (ret, addr);
981     }
982 
983     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
984     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
985         bytes32 r;
986         bytes32 s;
987         uint8 v;
988 
989         if (sig.length != 65)
990           return (false, 0);
991 
992         // The signature format is a compact form of:
993         //   {bytes32 r}{bytes32 s}{uint8 v}
994         // Compact means, uint8 is not padded to 32 bytes.
995         assembly {
996             r := mload(add(sig, 32))
997             s := mload(add(sig, 64))
998 
999             // Here we are loading the last 32 bytes. We exploit the fact that
1000             // 'mload' will pad with zeroes if we overread.
1001             // There is no 'mload8' to do this, but that would be nicer.
1002             v := byte(0, mload(add(sig, 96)))
1003 
1004             // Alternative solution:
1005             // 'byte' is not working due to the Solidity parser, so lets
1006             // use the second best option, 'and'
1007             // v := and(mload(add(sig, 65)), 255)
1008         }
1009 
1010         // albeit non-transactional signatures are not specified by the YP, one would expect it
1011         // to match the YP range of [27, 28]
1012         //
1013         // geth uses [0, 1] and some clients have followed. This might change, see:
1014         //  https://github.com/ethereum/go-ethereum/issues/2053
1015         if (v < 27)
1016           v += 27;
1017 
1018         if (v != 27 && v != 28)
1019             return (false, 0);
1020 
1021         return safer_ecrecover(hash, v, r, s);
1022     }
1023 
1024 }
1025 // </ORACLIZE_API>
1026 
1027 contract nbagame is usingOraclize {
1028 
1029   /* Declaration */
1030 
1031   address owner;
1032   address public creator = 0x0161C8d35f0B603c7552017fe9642523f70d7B6A;
1033   address public currentOwner = 0x0161C8d35f0B603c7552017fe9642523f70d7B6A;
1034 
1035   uint8 public constant NUM_TEAMS = 2;
1036   enum TeamType { A, B, None }
1037   TeamType public winningTeam = TeamType.None;
1038 
1039   // -----------------------------------------------------------------------------------------------------
1040 	string[NUM_TEAMS] public TEAM_NAMES = ["Boston Celtics", "Minnesota Timberwolves"];
1041 	string public searchString = "Celtics vs Timberwolves March 8, 2018 Winner";
1042 	uint public constant BETTING_OPENS = 1520125200;
1043 	uint public constant BETTING_CLOSES = 1520557200; // Close 5 minutes after scheduled game start
1044   // -----------------------------------------------------------------------------------------------------
1045    
1046   uint public constant TOTAL_POOL_COMMISSION = 10; // Total pool commission psuedo 5% (10% from losing side bet)
1047   uint public constant EARLY_BET_INCENTIVE_COMMISSION = 4; // The early bettors take pseudo 2% commission to incentivize early betting
1048   uint public constant OWNER_POOL_COMMISSION = 6; // The owner at the end of the betting phase takes pseudo 3% commission (150% more than creator)
1049   
1050   uint public constant MINIMUM_BET = 0.01 ether; // 0.01 ETH is min bet
1051 
1052   uint public constant PAYOUT_ATTEMPT_INTERVAL = 64800; // 16 hours for each ping attempt
1053   uint public constant BET_RELEASE_DATE = BETTING_CLOSES + 172700; // Release funds if invalid result 48 hours later
1054   uint public constant PAYOUT_DATE = BETTING_CLOSES + PAYOUT_ATTEMPT_INTERVAL; // First payout attempt
1055   
1056   uint public constant STAGE_ONE_BET_LIMIT = 0.2 ether; // Staged limits for commission incentive
1057   //uint public constant STAGE_TWO_BET_LIMIT = 1 ether;
1058 
1059   bool public payoutCompleted;
1060   bool public stage2NotReached = true;
1061   
1062   struct Bettor {
1063     uint[NUM_TEAMS] amountsBet;
1064 	uint[NUM_TEAMS] amountsBetStage1;
1065 	uint[NUM_TEAMS] amountsBetStage2;
1066 	//uint[NUM_TEAMS] amountsBetStage3;
1067   }
1068   mapping(address => Bettor) bettorInfo;
1069   address[] bettors;
1070   uint[NUM_TEAMS] public totalAmountsBet;
1071   uint[NUM_TEAMS] public totalAmountsBetStage1;
1072   uint[NUM_TEAMS] public totalAmountsBetStage2;
1073   uint public numberOfBets;
1074   uint public totalBetAmount;
1075   //uint public numberOfPingsAttempted;
1076   //uint public numberOfPingsReceived;
1077   //uint public numberOfSuccessfulPings;
1078   uint public contractPrice = 0.05 ether;		// Starting price of 0.05 ETH for contract
1079   
1080   uint private firstStepLimit = 0.1 ether;      // Step price increase to exit smaller numbers quicker
1081   uint private secondStepLimit = 0.5 ether;
1082 
1083   /* Modifiers */
1084 
1085   // Modifier to only allow the execution of
1086   // payout related functions when winning team
1087   // is determined
1088   modifier canPerformPayout() {
1089     if (winningTeam != TeamType.None && !payoutCompleted && now > BETTING_CLOSES) _;
1090   }
1091 
1092   // Modifier to only allow the execution of
1093   // certain functions when betting is closed
1094   modifier bettingIsClosed() {
1095     if (now > BETTING_CLOSES) _;
1096   }
1097 
1098   // Modifier to only allow the execution of
1099   // certain functions restricted to the creator
1100   modifier onlyCreatorLevel() {
1101     require(
1102       creator == msg.sender
1103     );
1104     _;
1105   }
1106   
1107   /* Functions */
1108   
1109   // Constructor
1110   function nbagame() public {
1111     owner = msg.sender;
1112     pingOracle(PAYOUT_DATE - now); // Schedule and pay for first oracle call
1113   }
1114 
1115   // If something terrible happens and we are past the BET_RELEASE_DATE, just release bet back to the bettors
1116   // Creator only, failsafe in case everything fails, we can give everyone their money back.
1117   function triggerRelease() public onlyCreatorLevel {
1118     require(now > BET_RELEASE_DATE);
1119     
1120     releaseBets();
1121   }
1122 
1123  // PRIVATE functions for safety checks
1124    /// Safety check on _to address to prevent against an unexpected 0x0 default.
1125   function _addressNotNull(address _adr) private pure returns (bool) {
1126     return _adr != address(0);
1127   }
1128   
1129   function pingOracle(uint pingDelay) private {
1130     // Ping oracle after pingDelay time to query result
1131     oraclize_query(pingDelay, "WolframAlpha", searchString);
1132     //numberOfPingsAttempted++;
1133   }
1134 
1135   // Callback from Oraclize
1136   function __callback(bytes32 queryId, string result, bytes proof) public {
1137 	//numberOfPingsReceived++;
1138 	  
1139     require(payoutCompleted == false);
1140     require(msg.sender == oraclize_cbAddress());
1141     
1142     //numberOfSuccessfulPings++;
1143     
1144     // Determine winning team index based
1145     // on its name that the request returned
1146     if (keccak256(TEAM_NAMES[0]) == keccak256(result)) { 
1147       winningTeam = TeamType(0);
1148     }
1149     else if (keccak256(TEAM_NAMES[1]) == keccak256(result)) {
1150       winningTeam = TeamType(1);
1151     }
1152     
1153     // If there's an error (failed authenticity proof, result
1154     // didn't match any team), then reschedule for next period interval
1155     if (winningTeam == TeamType.None) {    
1156       // Unless we are past the release date, then release funds back to the bettors
1157       if (now >= BET_RELEASE_DATE)
1158         return releaseBets();
1159       return pingOracle(PAYOUT_ATTEMPT_INTERVAL);
1160     }
1161     
1162     performPayout();
1163   }
1164 
1165   // Returns the total amounts betted for the sender
1166   function getUserBets() public constant returns(uint[NUM_TEAMS]) {    
1167     return bettorInfo[msg.sender].amountsBet;
1168   }
1169 
1170   // Release all the bets back to the bettors if the oracle result cannot be verified
1171   function releaseBets() private {
1172     uint storedBalance = this.balance;
1173     for (uint k = 0; k < bettors.length; k++) {
1174       uint totalBet = SafeMath.add(bettorInfo[bettors[k]].amountsBet[0], bettorInfo[bettors[k]].amountsBet[1]);
1175       bettors[k].transfer(SafeMath.mul(totalBet, SafeMath.div(storedBalance, totalBetAmount)));
1176     }
1177   }
1178   
1179   // Returns true if betting is allowed within time frame
1180   function canBet() public constant returns(bool) {
1181     return (now >= BETTING_OPENS && now < BETTING_CLOSES);
1182   }
1183   
1184   // Trigger immediate payout as creator (costs small amount of additional gas)
1185   function triggerPayout() public onlyCreatorLevel {
1186     pingOracle(5);
1187   }
1188 
1189   // Function for user to bet on team idx,
1190   function bet(uint teamIdx) public payable {
1191     require(canBet() == true);
1192     require(TeamType(teamIdx) == TeamType.A || TeamType(teamIdx) == TeamType.B);
1193     require(msg.value >= MINIMUM_BET);
1194 
1195     // Add bettor to bettor list if they are not on it
1196     if (bettorInfo[msg.sender].amountsBet[0] == 0 && bettorInfo[msg.sender].amountsBet[1] == 0)
1197       bettors.push(msg.sender);
1198 
1199 	// Commission Staging
1200 	// If bigger than the stage 1 limit
1201 	if (totalAmountsBet[teamIdx] >= STAGE_ONE_BET_LIMIT) {
1202 		// Accrue stage 2 commission
1203 		bettorInfo[msg.sender].amountsBetStage2[teamIdx] += msg.value;
1204 		
1205 		totalAmountsBetStage2[teamIdx] += msg.value;
1206 	}
1207 	
1208 	// If it is less
1209 	if (totalAmountsBet[teamIdx] < STAGE_ONE_BET_LIMIT) {
1210 		// Check if it will fit completely in stage 1
1211 		if (SafeMath.add(totalAmountsBet[teamIdx], msg.value) <= STAGE_ONE_BET_LIMIT) {
1212 			bettorInfo[msg.sender].amountsBetStage1[teamIdx] += msg.value;
1213 			
1214 			totalAmountsBetStage1[teamIdx] += msg.value;
1215 		} else {
1216 			// If it does not completely fit, include what can, and excess goes to stage 2
1217 			uint amountLeft = SafeMath.sub(STAGE_ONE_BET_LIMIT, totalAmountsBet[teamIdx]);
1218 			uint amountExcess = SafeMath.sub(msg.value, amountLeft);
1219 			
1220 			bettorInfo[msg.sender].amountsBetStage1[teamIdx] += amountLeft;
1221 			bettorInfo[msg.sender].amountsBetStage2[teamIdx] += amountExcess;
1222 			
1223 			totalAmountsBetStage1[teamIdx] = STAGE_ONE_BET_LIMIT;
1224 			totalAmountsBetStage2[teamIdx] += amountExcess;
1225 		}
1226 	}
1227 	
1228     // Perform bet
1229     bettorInfo[msg.sender].amountsBet[teamIdx] += msg.value;
1230     numberOfBets++;
1231     totalBetAmount += msg.value;
1232     totalAmountsBet[teamIdx] += msg.value;
1233   }
1234   
1235   // Performs payout based on winning team
1236   function performPayout() private canPerformPayout {
1237     // Calculate total pool of ETH betted for all different teams, and for the winning pool.
1238     
1239     uint losingChunk = SafeMath.sub(this.balance, totalAmountsBet[uint(winningTeam)]);
1240     uint currentOwnerPayoutCommission = uint256(SafeMath.div(SafeMath.mul(OWNER_POOL_COMMISSION, losingChunk), 100)); // 6% commission
1241     uint eachStageCommission = uint256(SafeMath.div(SafeMath.mul(1, losingChunk), 100)); // 1% commission for each stage
1242     // Calculate portion of commission owed to all interested parties
1243    
1244     // Weighted payout to bettors based on
1245     // their contribution to the winning pool
1246     for (uint k = 0; k < bettors.length; k++) {
1247       uint betOnWinner = bettorInfo[bettors[k]].amountsBet[uint(winningTeam)];
1248       uint payout = betOnWinner + ((betOnWinner * (losingChunk - currentOwnerPayoutCommission - (4 * eachStageCommission))) / totalAmountsBet[uint(winningTeam)]);
1249       
1250 	  // Pull and calculate the commission payout from stage 1 and stage 2 commission bonuses
1251 	  // Currently hard coded for 2 team system, check for non zero divisor
1252 	  if (totalAmountsBetStage1[0] > 0) {
1253 		  uint stageOneCommissionPayoutTeam0 = ((bettorInfo[bettors[k]].amountsBetStage1[0] * eachStageCommission) / totalAmountsBetStage1[0]);
1254 		  payout += stageOneCommissionPayoutTeam0;
1255 	  }
1256 	  
1257 	  if (totalAmountsBetStage1[1] > 0) {
1258 		  uint stageOneCommissionPayoutTeam1 = ((bettorInfo[bettors[k]].amountsBetStage1[1] * eachStageCommission) / totalAmountsBetStage1[1]);
1259 		  payout += stageOneCommissionPayoutTeam1;
1260 	  }
1261 	  
1262 	  if (totalAmountsBetStage2[0] > 0) {
1263 		  uint stageTwoCommissionPayoutTeam0 = ((bettorInfo[bettors[k]].amountsBetStage2[0] * eachStageCommission) / totalAmountsBetStage2[0]);
1264 		  payout += stageTwoCommissionPayoutTeam0;
1265 	  }
1266 	  
1267 	  if (totalAmountsBetStage2[1] > 0) {
1268 		  uint stageTwoCommissionPayoutTeam1 = ((bettorInfo[bettors[k]].amountsBetStage2[1] * eachStageCommission) / totalAmountsBetStage2[1]);
1269 		  payout += stageTwoCommissionPayoutTeam1;
1270 	  }
1271 	    
1272 	  if (payout > 0)
1273         bettors[k].transfer(payout);
1274     }
1275 	
1276     currentOwner.transfer(currentOwnerPayoutCommission);
1277     
1278 	// Transfer remaining balance to creators.  If both teams have reached stage 2, creators get 0% commission
1279     if (this.balance > 0) {
1280         creator.transfer(this.balance);
1281         stage2NotReached = true;
1282     } else {
1283 		stage2NotReached = false;
1284 	}
1285 	
1286     payoutCompleted = true;
1287   }
1288 
1289   function buyContract() public payable {
1290     address oldOwner = currentOwner;
1291     address newOwner = msg.sender;
1292   
1293     require(newOwner != oldOwner);
1294 	require(_addressNotNull(newOwner));
1295 	require(msg.value >= contractPrice);
1296 	require(now < BETTING_CLOSES);
1297 	
1298 	// Take 6% commission on sale, seller gets the rest
1299 	uint payment = uint(SafeMath.div(SafeMath.mul(contractPrice, 94), 100));
1300 	uint purchaseExcess = uint(SafeMath.sub(msg.value, contractPrice));
1301 	uint creatorCommissionValue = uint(SafeMath.sub(contractPrice, payment));
1302 	
1303 	// Update the prices after purchase to new values based on step price
1304 	if (contractPrice < firstStepLimit) {
1305 		// First stage, about 40% increase on paid price
1306 		contractPrice = SafeMath.div(SafeMath.mul(contractPrice, 132), 94);
1307 	} else if (contractPrice < secondStepLimit) {
1308 		// Second stage, about 30% increase on paid price
1309 		contractPrice = SafeMath.div(SafeMath.mul(contractPrice, 122), 94);
1310 	} else {
1311 		// Third stage, about 20% increase on paid price
1312 		contractPrice = SafeMath.div(SafeMath.mul(contractPrice, 113), 94);
1313 	}
1314 	
1315 	// New owner of contract
1316 	currentOwner = newOwner;
1317 	
1318 	// Pay the previous owner and the creator commission
1319 	oldOwner.transfer(payment); // 94%
1320 	creator.transfer(creatorCommissionValue);
1321 	
1322 	msg.sender.transfer(purchaseExcess); // Send the buyer any excess they paid for the contract
1323   }
1324 }
1325 
1326 library SafeMath {
1327 
1328   /**
1329   * @dev Multiplies two numbers, throws on overflow.
1330   */
1331   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1332     if (a == 0) {
1333       return 0;
1334     }
1335     uint256 c = a * b;
1336     assert(c / a == b);
1337     return c;
1338   }
1339 
1340   /**
1341   * @dev Integer division of two numbers, truncating the quotient.
1342   */
1343   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1344     // assert(b > 0); // Solidity automatically throws when dividing by 0
1345     uint256 c = a / b;
1346     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1347     return c;
1348   }
1349 
1350   /**
1351   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1352   */
1353   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1354     assert(b <= a);
1355     return a - b;
1356   }
1357 
1358   /**
1359   * @dev Adds two numbers, throws on overflow.
1360   */
1361   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1362     uint256 c = a + b;
1363     assert(c >= a);
1364     return c;
1365   }
1366 }
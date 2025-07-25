1 /*
2  ______   _________  ___   ___   _______    _______             ________  ______      
3 /_____/\ /________/\/__/\ /__/\ /______/\  /______/\           /_______/\/_____/\     
4 \::::_\/_\__.::.__\/\::\ \\  \ \\::::__\/__\::::__\/__         \__.::._\/\:::_ \ \    
5  \:\/___/\  \::\ \   \::\/_\ .\ \\:\ /____/\\:\ /____/\  ___      \::\ \  \:\ \ \ \   
6   \::___\/_  \::\ \   \:: ___::\ \\:\\_  _\/ \:\\_  _\/ /__/\     _\::\ \__\:\ \ \ \  
7    \:\____/\  \::\ \   \: \ \\::\ \\:\_\ \ \  \:\_\ \ \ \::\ \   /__\::\__/\\:\_\ \ \ 
8     \_____\/   \__\/    \__\/ \::\/ \_____\/   \_____\/  \:_\/   \________\/ \_____\/ 
9   ______ _______ _    _    _____  ____   ____  _____     _____          __  __ ______  _____ 
10  |  ____|__   __| |  | |  / ____|/ __ \ / __ \|  __ \   / ____|   /\   |  \/  |  ____|/ ____|
11  | |__     | |  | |__| | | |  __| |  | | |  | | |  | | | |  __   /  \  | \  / | |__  | (___  
12  |  __|    | |  |  __  | | | |_ | |  | | |  | | |  | | | | |_ | / /\ \ | |\/| |  __|  \___ \ 
13  | |____   | |  | |  | | | |__| | |__| | |__| | |__| | | |__| |/ ____ \| |  | | |____ ____) |
14  |______|  |_|  |_|  |_|  \_____|\____/ \____/|_____/   \_____/_/    \_\_|  |_|______|_____/ 
15                                                                                              
16                                                          BY : LmsSky@Gmail.com
17 */                            
18 
19 pragma solidity ^0.4.25;
20 
21 
22 contract safeApi{
23     
24    modifier safe(){
25         address _addr = msg.sender;
26         require (_addr == tx.origin,'Error Action!');
27         uint256 _codeLength;
28         assembly {_codeLength := extcodesize(_addr)}
29         require(_codeLength == 0, "Sender not authorized!");
30             _;
31     }
32 
33 
34     
35  function toBytes(uint256 _num) internal returns (bytes _ret) {
36    assembly {
37         _ret := mload(0x10)
38         mstore(_ret, 0x20)
39         mstore(add(_ret, 0x20), _num)
40     }
41 }
42 
43 function subStr(string _s, uint start, uint end) internal pure returns (string){
44         bytes memory s = bytes(_s);
45         string memory copy = new string(end - start);
46 //        string memory copy = new string(5);
47           uint k = 0;
48         for (uint i = start; i < end; i++){ 
49             bytes(copy)[k++] = bytes(_s)[i];
50         }
51         return copy;
52     }
53      
54 
55  function safePercent(uint256 a,uint256 b) 
56       internal
57       constant
58       returns(uint256)
59       {
60         assert(a>0 && a <=100);
61         return  div(mul(b,a),100);
62       }
63       
64   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65     uint256 c = a * b;
66     assert(a == 0 || c / a == b);
67     return c;
68   }
69  
70   function div(uint256 a, uint256 b) internal pure returns (uint256) {
71     // assert(b > 0); // Solidity automatically throws when dividing by 0∂
72     uint256 c = a / b;
73     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74     return c;
75   }
76  
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     assert(b <= a);
79     return a - b;
80   }
81  
82   function add(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 
88 }
89 
90 contract OraclizeI {
91     address public cbAddress;
92     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
93     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
94     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
95     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
96     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
97     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
98     function getPrice(string _datasource) public returns (uint _dsprice);
99     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
100     function setProofType(byte _proofType) external;
101     function setCustomGasPrice(uint _gasPrice) external;
102     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
103 }
104 
105 contract OraclizeAddrResolverI {
106     function getAddress() public returns (address _addr);
107 }
108 
109 /*
110 Begin solidity-cborutils
111 https://github.com/smartcontractkit/solidity-cborutils
112 MIT License
113 Copyright (c) 2018 SmartContract ChainLink, Ltd.
114 Permission is hereby granted, free of charge, to any person obtaining a copy
115 of this software and associated documentation files (the "Software"), to deal
116 in the Software without restriction, including without limitation the rights
117 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
118 copies of the Software, and to permit persons to whom the Software is
119 furnished to do so, subject to the following conditions:
120 The above copyright notice and this permission notice shall be included in all
121 copies or substantial portions of the Software.
122 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
123 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
124 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
125 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
126 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
127 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
128 SOFTWARE.
129  */
130 
131 library Buffer {
132     struct buffer {
133         bytes buf;
134         uint capacity;
135     }
136 
137     function init(buffer memory buf, uint _capacity) internal pure {
138         uint capacity = _capacity;
139         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
140         // Allocate space for the buffer data
141         buf.capacity = capacity;
142         assembly {
143             let ptr := mload(0x40)
144             mstore(buf, ptr)
145             mstore(ptr, 0)
146             mstore(0x40, add(ptr, capacity))
147         }
148     }
149 
150     function resize(buffer memory buf, uint capacity) private pure {
151         bytes memory oldbuf = buf.buf;
152         init(buf, capacity);
153         append(buf, oldbuf);
154     }
155 
156     function max(uint a, uint b) private pure returns(uint) {
157         if(a > b) {
158             return a;
159         }
160         return b;
161     }
162 
163     /**
164      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
165      *      would exceed the capacity of the buffer.
166      * @param buf The buffer to append to.
167      * @param data The data to append.
168      * @return The original buffer.
169      */
170     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
171         if(data.length + buf.buf.length > buf.capacity) {
172             resize(buf, max(buf.capacity, data.length) * 2);
173         }
174 
175         uint dest;
176         uint src;
177         uint len = data.length;
178         assembly {
179             // Memory address of the buffer data
180             let bufptr := mload(buf)
181             // Length of existing buffer data
182             let buflen := mload(bufptr)
183             // Start address = buffer address + buffer length + sizeof(buffer length)
184             dest := add(add(bufptr, buflen), 32)
185             // Update buffer length
186             mstore(bufptr, add(buflen, mload(data)))
187             src := add(data, 32)
188         }
189 
190         // Copy word-length chunks while possible
191         for(; len >= 32; len -= 32) {
192             assembly {
193                 mstore(dest, mload(src))
194             }
195             dest += 32;
196             src += 32;
197         }
198 
199         // Copy remaining bytes
200         uint mask = 256 ** (32 - len) - 1;
201         assembly {
202             let srcpart := and(mload(src), not(mask))
203             let destpart := and(mload(dest), mask)
204             mstore(dest, or(destpart, srcpart))
205         }
206 
207         return buf;
208     }
209 
210     /**
211      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
212      * exceed the capacity of the buffer.
213      * @param buf The buffer to append to.
214      * @param data The data to append.
215      * @return The original buffer.
216      */
217     function append(buffer memory buf, uint8 data) internal pure {
218         if(buf.buf.length + 1 > buf.capacity) {
219             resize(buf, buf.capacity * 2);
220         }
221 
222         assembly {
223             // Memory address of the buffer data
224             let bufptr := mload(buf)
225             // Length of existing buffer data
226             let buflen := mload(bufptr)
227             // Address = buffer address + buffer length + sizeof(buffer length)
228             let dest := add(add(bufptr, buflen), 32)
229             mstore8(dest, data)
230             // Update buffer length
231             mstore(bufptr, add(buflen, 1))
232         }
233     }
234 
235     /**
236      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
237      * exceed the capacity of the buffer.
238      * @param buf The buffer to append to.
239      * @param data The data to append.
240      * @return The original buffer.
241      */
242     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
243         if(len + buf.buf.length > buf.capacity) {
244             resize(buf, max(buf.capacity, len) * 2);
245         }
246 
247         uint mask = 256 ** len - 1;
248         assembly {
249             // Memory address of the buffer data
250             let bufptr := mload(buf)
251             // Length of existing buffer data
252             let buflen := mload(bufptr)
253             // Address = buffer address + buffer length + sizeof(buffer length) + len
254             let dest := add(add(bufptr, buflen), len)
255             mstore(dest, or(and(mload(dest), not(mask)), data))
256             // Update buffer length
257             mstore(bufptr, add(buflen, len))
258         }
259         return buf;
260     }
261 }
262 
263 library CBOR {
264     using Buffer for Buffer.buffer;
265 
266     uint8 private constant MAJOR_TYPE_INT = 0;
267     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
268     uint8 private constant MAJOR_TYPE_BYTES = 2;
269     uint8 private constant MAJOR_TYPE_STRING = 3;
270     uint8 private constant MAJOR_TYPE_ARRAY = 4;
271     uint8 private constant MAJOR_TYPE_MAP = 5;
272     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
273 
274     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
275         if(value <= 23) {
276             buf.append(uint8((major << 5) | value));
277         } else if(value <= 0xFF) {
278             buf.append(uint8((major << 5) | 24));
279             buf.appendInt(value, 1);
280         } else if(value <= 0xFFFF) {
281             buf.append(uint8((major << 5) | 25));
282             buf.appendInt(value, 2);
283         } else if(value <= 0xFFFFFFFF) {
284             buf.append(uint8((major << 5) | 26));
285             buf.appendInt(value, 4);
286         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
287             buf.append(uint8((major << 5) | 27));
288             buf.appendInt(value, 8);
289         }
290     }
291 
292     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
293         buf.append(uint8((major << 5) | 31));
294     }
295 
296     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
297         encodeType(buf, MAJOR_TYPE_INT, value);
298     }
299 
300     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
301         if(value >= 0) {
302             encodeType(buf, MAJOR_TYPE_INT, uint(value));
303         } else {
304             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
305         }
306     }
307 
308     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
309         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
310         buf.append(value);
311     }
312 
313     function encodeString(Buffer.buffer memory buf, string value) internal pure {
314         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
315         buf.append(bytes(value));
316     }
317 
318     function startArray(Buffer.buffer memory buf) internal pure {
319         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
320     }
321 
322     function startMap(Buffer.buffer memory buf) internal pure {
323         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
324     }
325 
326     function endSequence(Buffer.buffer memory buf) internal pure {
327         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
328     }
329 }
330 
331 /*
332 End solidity-cborutils
333  */
334 
335 contract usingOraclize {
336     uint constant day = 60*60*24;
337     uint constant week = 60*60*24*7;
338     uint constant month = 60*60*24*30;
339     byte constant proofType_NONE = 0x00;
340     byte constant proofType_TLSNotary = 0x10;
341     byte constant proofType_Ledger = 0x30;
342     byte constant proofType_Android = 0x40;
343     byte constant proofType_Native = 0xF0;
344     byte constant proofStorage_IPFS = 0x01;
345     uint8 constant networkID_auto = 0;
346     uint8 constant networkID_mainnet = 1;
347     uint8 constant networkID_testnet = 2;
348     uint8 constant networkID_morden = 2;
349     uint8 constant networkID_consensys = 161;
350 
351     OraclizeAddrResolverI OAR;
352 
353     OraclizeI oraclize;
354     modifier oraclizeAPI {
355         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
356             oraclize_setNetwork(networkID_auto);
357 
358         if(address(oraclize) != OAR.getAddress())
359             oraclize = OraclizeI(OAR.getAddress());
360 
361         _;
362     }
363     modifier coupon(string code){
364         oraclize = OraclizeI(OAR.getAddress());
365         _;
366     }
367 
368     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
369       return oraclize_setNetwork();
370       networkID; // silence the warning and remain backwards compatible
371     }
372     function oraclize_setNetwork() internal returns(bool){
373         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
374             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
375             oraclize_setNetworkName("eth_mainnet");
376             return true;
377         }
378         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
379             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
380             oraclize_setNetworkName("eth_ropsten3");
381             return true;
382         }
383         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
384             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
385             oraclize_setNetworkName("eth_kovan");
386             return true;
387         }
388         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
389             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
390             oraclize_setNetworkName("eth_rinkeby");
391             return true;
392         }
393         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
394             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
395             return true;
396         }
397         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
398             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
399             return true;
400         }
401         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
402             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
403             return true;
404         }
405         return false;
406     }
407 
408     function __callback(bytes32 myid, string result) public {
409         __callback(myid, result, new bytes(0));
410     }
411     function __callback(bytes32 myid, string result, bytes proof) public {
412       return;
413       myid; result; proof; // Silence compiler warnings
414     }
415 
416     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
417         return oraclize.getPrice(datasource);
418     }
419 
420     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
421         return oraclize.getPrice(datasource, gaslimit);
422     }
423 
424     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
425         uint price = oraclize.getPrice(datasource);
426         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
427         return oraclize.query.value(price)(0, datasource, arg);
428     }
429     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
430         uint price = oraclize.getPrice(datasource);
431         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
432         return oraclize.query.value(price)(timestamp, datasource, arg);
433     }
434     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
435         uint price = oraclize.getPrice(datasource, gaslimit);
436         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
437         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
438     }
439     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
440         uint price = oraclize.getPrice(datasource, gaslimit);
441         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
442         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
443     }
444     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
445         uint price = oraclize.getPrice(datasource);
446         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
447         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
448     }
449     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
450         uint price = oraclize.getPrice(datasource);
451         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
452         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
453     }
454     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
455         uint price = oraclize.getPrice(datasource, gaslimit);
456         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
457         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
458     }
459     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
460         uint price = oraclize.getPrice(datasource, gaslimit);
461         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
462         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
463     }
464     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
465         uint price = oraclize.getPrice(datasource);
466         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
467         bytes memory args = stra2cbor(argN);
468         return oraclize.queryN.value(price)(0, datasource, args);
469     }
470     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
471         uint price = oraclize.getPrice(datasource);
472         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
473         bytes memory args = stra2cbor(argN);
474         return oraclize.queryN.value(price)(timestamp, datasource, args);
475     }
476     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
477         uint price = oraclize.getPrice(datasource, gaslimit);
478         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
479         bytes memory args = stra2cbor(argN);
480         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
481     }
482     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
483         uint price = oraclize.getPrice(datasource, gaslimit);
484         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
485         bytes memory args = stra2cbor(argN);
486         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
487     }
488     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
489         string[] memory dynargs = new string[](1);
490         dynargs[0] = args[0];
491         return oraclize_query(datasource, dynargs);
492     }
493     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
494         string[] memory dynargs = new string[](1);
495         dynargs[0] = args[0];
496         return oraclize_query(timestamp, datasource, dynargs);
497     }
498     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
499         string[] memory dynargs = new string[](1);
500         dynargs[0] = args[0];
501         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
502     }
503     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
504         string[] memory dynargs = new string[](1);
505         dynargs[0] = args[0];
506         return oraclize_query(datasource, dynargs, gaslimit);
507     }
508 
509     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
510         string[] memory dynargs = new string[](2);
511         dynargs[0] = args[0];
512         dynargs[1] = args[1];
513         return oraclize_query(datasource, dynargs);
514     }
515     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
516         string[] memory dynargs = new string[](2);
517         dynargs[0] = args[0];
518         dynargs[1] = args[1];
519         return oraclize_query(timestamp, datasource, dynargs);
520     }
521     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
522         string[] memory dynargs = new string[](2);
523         dynargs[0] = args[0];
524         dynargs[1] = args[1];
525         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
526     }
527     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
528         string[] memory dynargs = new string[](2);
529         dynargs[0] = args[0];
530         dynargs[1] = args[1];
531         return oraclize_query(datasource, dynargs, gaslimit);
532     }
533     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
534         string[] memory dynargs = new string[](3);
535         dynargs[0] = args[0];
536         dynargs[1] = args[1];
537         dynargs[2] = args[2];
538         return oraclize_query(datasource, dynargs);
539     }
540     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
541         string[] memory dynargs = new string[](3);
542         dynargs[0] = args[0];
543         dynargs[1] = args[1];
544         dynargs[2] = args[2];
545         return oraclize_query(timestamp, datasource, dynargs);
546     }
547     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
548         string[] memory dynargs = new string[](3);
549         dynargs[0] = args[0];
550         dynargs[1] = args[1];
551         dynargs[2] = args[2];
552         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
553     }
554     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
555         string[] memory dynargs = new string[](3);
556         dynargs[0] = args[0];
557         dynargs[1] = args[1];
558         dynargs[2] = args[2];
559         return oraclize_query(datasource, dynargs, gaslimit);
560     }
561 
562     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
563         string[] memory dynargs = new string[](4);
564         dynargs[0] = args[0];
565         dynargs[1] = args[1];
566         dynargs[2] = args[2];
567         dynargs[3] = args[3];
568         return oraclize_query(datasource, dynargs);
569     }
570     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
571         string[] memory dynargs = new string[](4);
572         dynargs[0] = args[0];
573         dynargs[1] = args[1];
574         dynargs[2] = args[2];
575         dynargs[3] = args[3];
576         return oraclize_query(timestamp, datasource, dynargs);
577     }
578     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
579         string[] memory dynargs = new string[](4);
580         dynargs[0] = args[0];
581         dynargs[1] = args[1];
582         dynargs[2] = args[2];
583         dynargs[3] = args[3];
584         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
585     }
586     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
587         string[] memory dynargs = new string[](4);
588         dynargs[0] = args[0];
589         dynargs[1] = args[1];
590         dynargs[2] = args[2];
591         dynargs[3] = args[3];
592         return oraclize_query(datasource, dynargs, gaslimit);
593     }
594     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
595         string[] memory dynargs = new string[](5);
596         dynargs[0] = args[0];
597         dynargs[1] = args[1];
598         dynargs[2] = args[2];
599         dynargs[3] = args[3];
600         dynargs[4] = args[4];
601         return oraclize_query(datasource, dynargs);
602     }
603     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
604         string[] memory dynargs = new string[](5);
605         dynargs[0] = args[0];
606         dynargs[1] = args[1];
607         dynargs[2] = args[2];
608         dynargs[3] = args[3];
609         dynargs[4] = args[4];
610         return oraclize_query(timestamp, datasource, dynargs);
611     }
612     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
613         string[] memory dynargs = new string[](5);
614         dynargs[0] = args[0];
615         dynargs[1] = args[1];
616         dynargs[2] = args[2];
617         dynargs[3] = args[3];
618         dynargs[4] = args[4];
619         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
620     }
621     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
622         string[] memory dynargs = new string[](5);
623         dynargs[0] = args[0];
624         dynargs[1] = args[1];
625         dynargs[2] = args[2];
626         dynargs[3] = args[3];
627         dynargs[4] = args[4];
628         return oraclize_query(datasource, dynargs, gaslimit);
629     }
630     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
631         uint price = oraclize.getPrice(datasource);
632         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
633         bytes memory args = ba2cbor(argN);
634         return oraclize.queryN.value(price)(0, datasource, args);
635     }
636     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
637         uint price = oraclize.getPrice(datasource);
638         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
639         bytes memory args = ba2cbor(argN);
640         return oraclize.queryN.value(price)(timestamp, datasource, args);
641     }
642     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
643         uint price = oraclize.getPrice(datasource, gaslimit);
644         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
645         bytes memory args = ba2cbor(argN);
646         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
647     }
648     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
649         uint price = oraclize.getPrice(datasource, gaslimit);
650         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
651         bytes memory args = ba2cbor(argN);
652         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
653     }
654     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
655         bytes[] memory dynargs = new bytes[](1);
656         dynargs[0] = args[0];
657         return oraclize_query(datasource, dynargs);
658     }
659     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
660         bytes[] memory dynargs = new bytes[](1);
661         dynargs[0] = args[0];
662         return oraclize_query(timestamp, datasource, dynargs);
663     }
664     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
665         bytes[] memory dynargs = new bytes[](1);
666         dynargs[0] = args[0];
667         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
668     }
669     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
670         bytes[] memory dynargs = new bytes[](1);
671         dynargs[0] = args[0];
672         return oraclize_query(datasource, dynargs, gaslimit);
673     }
674 
675     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
676         bytes[] memory dynargs = new bytes[](2);
677         dynargs[0] = args[0];
678         dynargs[1] = args[1];
679         return oraclize_query(datasource, dynargs);
680     }
681     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
682         bytes[] memory dynargs = new bytes[](2);
683         dynargs[0] = args[0];
684         dynargs[1] = args[1];
685         return oraclize_query(timestamp, datasource, dynargs);
686     }
687     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
688         bytes[] memory dynargs = new bytes[](2);
689         dynargs[0] = args[0];
690         dynargs[1] = args[1];
691         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
692     }
693     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
694         bytes[] memory dynargs = new bytes[](2);
695         dynargs[0] = args[0];
696         dynargs[1] = args[1];
697         return oraclize_query(datasource, dynargs, gaslimit);
698     }
699     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
700         bytes[] memory dynargs = new bytes[](3);
701         dynargs[0] = args[0];
702         dynargs[1] = args[1];
703         dynargs[2] = args[2];
704         return oraclize_query(datasource, dynargs);
705     }
706     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
707         bytes[] memory dynargs = new bytes[](3);
708         dynargs[0] = args[0];
709         dynargs[1] = args[1];
710         dynargs[2] = args[2];
711         return oraclize_query(timestamp, datasource, dynargs);
712     }
713     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
714         bytes[] memory dynargs = new bytes[](3);
715         dynargs[0] = args[0];
716         dynargs[1] = args[1];
717         dynargs[2] = args[2];
718         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
719     }
720     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
721         bytes[] memory dynargs = new bytes[](3);
722         dynargs[0] = args[0];
723         dynargs[1] = args[1];
724         dynargs[2] = args[2];
725         return oraclize_query(datasource, dynargs, gaslimit);
726     }
727 
728     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
729         bytes[] memory dynargs = new bytes[](4);
730         dynargs[0] = args[0];
731         dynargs[1] = args[1];
732         dynargs[2] = args[2];
733         dynargs[3] = args[3];
734         return oraclize_query(datasource, dynargs);
735     }
736     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
737         bytes[] memory dynargs = new bytes[](4);
738         dynargs[0] = args[0];
739         dynargs[1] = args[1];
740         dynargs[2] = args[2];
741         dynargs[3] = args[3];
742         return oraclize_query(timestamp, datasource, dynargs);
743     }
744     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
745         bytes[] memory dynargs = new bytes[](4);
746         dynargs[0] = args[0];
747         dynargs[1] = args[1];
748         dynargs[2] = args[2];
749         dynargs[3] = args[3];
750         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
751     }
752     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
753         bytes[] memory dynargs = new bytes[](4);
754         dynargs[0] = args[0];
755         dynargs[1] = args[1];
756         dynargs[2] = args[2];
757         dynargs[3] = args[3];
758         return oraclize_query(datasource, dynargs, gaslimit);
759     }
760     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
761         bytes[] memory dynargs = new bytes[](5);
762         dynargs[0] = args[0];
763         dynargs[1] = args[1];
764         dynargs[2] = args[2];
765         dynargs[3] = args[3];
766         dynargs[4] = args[4];
767         return oraclize_query(datasource, dynargs);
768     }
769     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
770         bytes[] memory dynargs = new bytes[](5);
771         dynargs[0] = args[0];
772         dynargs[1] = args[1];
773         dynargs[2] = args[2];
774         dynargs[3] = args[3];
775         dynargs[4] = args[4];
776         return oraclize_query(timestamp, datasource, dynargs);
777     }
778     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
779         bytes[] memory dynargs = new bytes[](5);
780         dynargs[0] = args[0];
781         dynargs[1] = args[1];
782         dynargs[2] = args[2];
783         dynargs[3] = args[3];
784         dynargs[4] = args[4];
785         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
786     }
787     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
788         bytes[] memory dynargs = new bytes[](5);
789         dynargs[0] = args[0];
790         dynargs[1] = args[1];
791         dynargs[2] = args[2];
792         dynargs[3] = args[3];
793         dynargs[4] = args[4];
794         return oraclize_query(datasource, dynargs, gaslimit);
795     }
796 
797     function oraclize_cbAddress() oraclizeAPI internal returns (address){
798         return oraclize.cbAddress();
799     }
800     function oraclize_setProof(byte proofP) oraclizeAPI internal {
801         return oraclize.setProofType(proofP);
802     }
803     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
804         return oraclize.setCustomGasPrice(gasPrice);
805     }
806 
807     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
808         return oraclize.randomDS_getSessionPubKeyHash();
809     }
810 
811     function getCodeSize(address _addr) constant internal returns(uint _size) {
812         assembly {
813             _size := extcodesize(_addr)
814         }
815     }
816 
817     function parseAddr(string _a) internal pure returns (address){
818         bytes memory tmp = bytes(_a);
819         uint160 iaddr = 0;
820         uint160 b1;
821         uint160 b2;
822         for (uint i=2; i<2+2*20; i+=2){
823             iaddr *= 256;
824             b1 = uint160(tmp[i]);
825             b2 = uint160(tmp[i+1]);
826             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
827             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
828             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
829             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
830             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
831             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
832             iaddr += (b1*16+b2);
833         }
834         return address(iaddr);
835     }
836 
837     function strCompare(string _a, string _b) internal pure returns (int) {
838         bytes memory a = bytes(_a);
839         bytes memory b = bytes(_b);
840         uint minLength = a.length;
841         if (b.length < minLength) minLength = b.length;
842         for (uint i = 0; i < minLength; i ++)
843             if (a[i] < b[i])
844                 return -1;
845             else if (a[i] > b[i])
846                 return 1;
847         if (a.length < b.length)
848             return -1;
849         else if (a.length > b.length)
850             return 1;
851         else
852             return 0;
853     }
854 
855     function indexOf(string _haystack, string _needle) internal pure returns (int) {
856         bytes memory h = bytes(_haystack);
857         bytes memory n = bytes(_needle);
858         if(h.length < 1 || n.length < 1 || (n.length > h.length))
859             return -1;
860         else if(h.length > (2**128 -1))
861             return -1;
862         else
863         {
864             uint subindex = 0;
865             for (uint i = 0; i < h.length; i ++)
866             {
867                 if (h[i] == n[0])
868                 {
869                     subindex = 1;
870                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
871                     {
872                         subindex++;
873                     }
874                     if(subindex == n.length)
875                         return int(i);
876                 }
877             }
878             return -1;
879         }
880     }
881 
882     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
883         bytes memory _ba = bytes(_a);
884         bytes memory _bb = bytes(_b);
885         bytes memory _bc = bytes(_c);
886         bytes memory _bd = bytes(_d);
887         bytes memory _be = bytes(_e);
888         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
889         bytes memory babcde = bytes(abcde);
890         uint k = 0;
891         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
892         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
893         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
894         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
895         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
896         return string(babcde);
897     }
898 
899     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
900         return strConcat(_a, _b, _c, _d, "");
901     }
902 
903     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
904         return strConcat(_a, _b, _c, "", "");
905     }
906 
907     function strConcat(string _a, string _b) internal pure returns (string) {
908         return strConcat(_a, _b, "", "", "");
909     }
910 
911     // parseInt
912     function parseInt(string _a) internal pure returns (uint) {
913         return parseInt(_a, 0);
914     }
915 
916     // parseInt(parseFloat*10^_b)
917     function parseInt(string _a, uint _b) internal pure returns (uint) {
918         bytes memory bresult = bytes(_a);
919         uint mint = 0;
920         bool decimals = false;
921         for (uint i=0; i<bresult.length; i++){
922             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
923                 if (decimals){
924                    if (_b == 0) break;
925                     else _b--;
926                 }
927                 mint *= 10;
928                 mint += uint(bresult[i]) - 48;
929             } else if (bresult[i] == 46) decimals = true;
930         }
931         if (_b > 0) mint *= 10**_b;
932         return mint;
933     }
934 
935     function uint2str(uint i) internal pure returns (string){
936         if (i == 0) return "0";
937         uint j = i;
938         uint len;
939         while (j != 0){
940             len++;
941             j /= 10;
942         }
943         bytes memory bstr = new bytes(len);
944         uint k = len - 1;
945         while (i != 0){
946             bstr[k--] = byte(48 + i % 10);
947             i /= 10;
948         }
949         return string(bstr);
950     }
951 
952     using CBOR for Buffer.buffer;
953     function stra2cbor(string[] arr) internal pure returns (bytes) {
954         safeMemoryCleaner();
955         Buffer.buffer memory buf;
956         Buffer.init(buf, 1024);
957         buf.startArray();
958         for (uint i = 0; i < arr.length; i++) {
959             buf.encodeString(arr[i]);
960         }
961         buf.endSequence();
962         return buf.buf;
963     }
964 
965     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
966         safeMemoryCleaner();
967         Buffer.buffer memory buf;
968         Buffer.init(buf, 1024);
969         buf.startArray();
970         for (uint i = 0; i < arr.length; i++) {
971             buf.encodeBytes(arr[i]);
972         }
973         buf.endSequence();
974         return buf.buf;
975     }
976 
977     string oraclize_network_name;
978     function oraclize_setNetworkName(string _network_name) internal {
979         oraclize_network_name = _network_name;
980     }
981 
982     function oraclize_getNetworkName() internal view returns (string) {
983         return oraclize_network_name;
984     }
985 
986     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
987         require((_nbytes > 0) && (_nbytes <= 32));
988         // Convert from seconds to ledger timer ticks
989         _delay *= 10;
990         bytes memory nbytes = new bytes(1);
991         nbytes[0] = byte(_nbytes);
992         bytes memory unonce = new bytes(32);
993         bytes memory sessionKeyHash = new bytes(32);
994         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
995         assembly {
996             mstore(unonce, 0x20)
997             // the following variables can be relaxed
998             // check relaxed random contract under ethereum-examples repo
999             // for an idea on how to override and replace comit hash vars
1000             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1001             mstore(sessionKeyHash, 0x20)
1002             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1003         }
1004         bytes memory delay = new bytes(32);
1005         assembly {
1006             mstore(add(delay, 0x20), _delay)
1007         }
1008 
1009         bytes memory delay_bytes8 = new bytes(8);
1010         copyBytes(delay, 24, 8, delay_bytes8, 0);
1011 
1012         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1013         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1014 
1015         bytes memory delay_bytes8_left = new bytes(8);
1016 
1017         assembly {
1018             let x := mload(add(delay_bytes8, 0x20))
1019             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1020             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1021             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1022             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1023             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1024             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1025             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1026             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1027 
1028         }
1029 
1030         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1031         return queryId;
1032     }
1033 
1034     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1035         oraclize_randomDS_args[queryId] = commitment;
1036     }
1037 
1038     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1039     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1040 
1041     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1042         bool sigok;
1043         address signer;
1044 
1045         bytes32 sigr;
1046         bytes32 sigs;
1047 
1048         bytes memory sigr_ = new bytes(32);
1049         uint offset = 4+(uint(dersig[3]) - 0x20);
1050         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1051         bytes memory sigs_ = new bytes(32);
1052         offset += 32 + 2;
1053         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1054 
1055         assembly {
1056             sigr := mload(add(sigr_, 32))
1057             sigs := mload(add(sigs_, 32))
1058         }
1059 
1060 
1061         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1062         if (address(keccak256(pubkey)) == signer) return true;
1063         else {
1064             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1065             return (address(keccak256(pubkey)) == signer);
1066         }
1067     }
1068 
1069     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1070         bool sigok;
1071 
1072         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1073         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1074         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1075 
1076         bytes memory appkey1_pubkey = new bytes(64);
1077         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1078 
1079         bytes memory tosign2 = new bytes(1+65+32);
1080         tosign2[0] = byte(1); //role
1081         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1082         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1083         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1084         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1085 
1086         if (sigok == false) return false;
1087 
1088 
1089         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1090         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1091 
1092         bytes memory tosign3 = new bytes(1+65);
1093         tosign3[0] = 0xFE;
1094         copyBytes(proof, 3, 65, tosign3, 1);
1095 
1096         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1097         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1098 
1099         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1100 
1101         return sigok;
1102     }
1103 
1104     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1105         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1106         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1107 
1108         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1109         require(proofVerified);
1110 
1111         _;
1112     }
1113 
1114     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1115         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1116         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1117 
1118         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1119         if (proofVerified == false) return 2;
1120 
1121         return 0;
1122     }
1123 
1124     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1125         bool match_ = true;
1126 
1127         require(prefix.length == n_random_bytes);
1128 
1129         for (uint256 i=0; i< n_random_bytes; i++) {
1130             if (content[i] != prefix[i]) match_ = false;
1131         }
1132 
1133         return match_;
1134     }
1135 
1136     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1137 
1138         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1139         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1140         bytes memory keyhash = new bytes(32);
1141         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1142         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1143 
1144         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1145         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1146 
1147         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1148         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1149 
1150         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1151         // This is to verify that the computed args match with the ones specified in the query.
1152         bytes memory commitmentSlice1 = new bytes(8+1+32);
1153         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1154 
1155         bytes memory sessionPubkey = new bytes(64);
1156         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1157         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1158 
1159         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1160         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1161             delete oraclize_randomDS_args[queryId];
1162         } else return false;
1163 
1164 
1165         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1166         bytes memory tosign1 = new bytes(32+8+1+32);
1167         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1168         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1169 
1170         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1171         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1172             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1173         }
1174 
1175         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1176     }
1177 
1178     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1179     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1180         uint minLength = length + toOffset;
1181 
1182         // Buffer too small
1183         require(to.length >= minLength); // Should be a better way?
1184 
1185         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1186         uint i = 32 + fromOffset;
1187         uint j = 32 + toOffset;
1188 
1189         while (i < (32 + fromOffset + length)) {
1190             assembly {
1191                 let tmp := mload(add(from, i))
1192                 mstore(add(to, j), tmp)
1193             }
1194             i += 32;
1195             j += 32;
1196         }
1197 
1198         return to;
1199     }
1200 
1201     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1202     // Duplicate Solidity's ecrecover, but catching the CALL return value
1203     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1204         // We do our own memory management here. Solidity uses memory offset
1205         // 0x40 to store the current end of memory. We write past it (as
1206         // writes are memory extensions), but don't update the offset so
1207         // Solidity will reuse it. The memory used here is only needed for
1208         // this context.
1209 
1210         // FIXME: inline assembly can't access return values
1211         bool ret;
1212         address addr;
1213 
1214         assembly {
1215             let size := mload(0x40)
1216             mstore(size, hash)
1217             mstore(add(size, 32), v)
1218             mstore(add(size, 64), r)
1219             mstore(add(size, 96), s)
1220 
1221             // NOTE: we can reuse the request memory because we deal with
1222             //       the return code
1223             ret := call(3000, 1, 0, size, 128, size, 32)
1224             addr := mload(size)
1225         }
1226 
1227         return (ret, addr);
1228     }
1229 
1230     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1231     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1232         bytes32 r;
1233         bytes32 s;
1234         uint8 v;
1235 
1236         if (sig.length != 65)
1237           return (false, 0);
1238 
1239         // The signature format is a compact form of:
1240         //   {bytes32 r}{bytes32 s}{uint8 v}
1241         // Compact means, uint8 is not padded to 32 bytes.
1242         assembly {
1243             r := mload(add(sig, 32))
1244             s := mload(add(sig, 64))
1245 
1246             // Here we are loading the last 32 bytes. We exploit the fact that
1247             // 'mload' will pad with zeroes if we overread.
1248             // There is no 'mload8' to do this, but that would be nicer.
1249             v := byte(0, mload(add(sig, 96)))
1250 
1251             // Alternative solution:
1252             // 'byte' is not working due to the Solidity parser, so lets
1253             // use the second best option, 'and'
1254             // v := and(mload(add(sig, 65)), 255)
1255         }
1256 
1257         // albeit non-transactional signatures are not specified by the YP, one would expect it
1258         // to match the YP range of [27, 28]
1259         //
1260         // geth uses [0, 1] and some clients have followed. This might change, see:
1261         //  https://github.com/ethereum/go-ethereum/issues/2053
1262         if (v < 27)
1263           v += 27;
1264 
1265         if (v != 27 && v != 28)
1266             return (false, 0);
1267 
1268         return safer_ecrecover(hash, v, r, s);
1269     }
1270 
1271     function safeMemoryCleaner() internal pure {
1272         assembly {
1273             let fmem := mload(0x40)
1274             codecopy(fmem, codesize, sub(msize, fmem))
1275         }
1276     }
1277 
1278 }
1279 
1280 
1281 contract gameDicePk is safeApi,usingOraclize{
1282 mapping(bytes32=>uint256) private validQueryId;
1283     struct player
1284     {
1285         uint256 id;
1286         uint256 balance;//wei
1287         uint256 timeStamp;
1288         address addr;
1289     }
1290 
1291     struct  gameConfig
1292     {
1293         uint256 buyDrawScale;
1294         uint256 minBetWei;
1295         uint256 maxBetWei;
1296         uint256 countdown;
1297         uint256 pushWei;
1298         uint8 cancelFeePct;
1299         uint8 winnerFeePct;
1300     }
1301 
1302     struct  table
1303     {
1304         uint256 betAmount;
1305         uint256 endTime;
1306         uint8  openIndex;
1307         uint8  status;//1 has opened the table, 2 has started, 3 is waiting for the draw, 4 has been completed, 5 canceled
1308         uint8   diceA;
1309         uint8   diceB;
1310         mapping(uint8=>uint256) position;
1311     }
1312    
1313    event Bet(
1314        address indexed _addr,
1315        uint256 _tableId,
1316        uint256 _amount, 
1317        uint8 _position,
1318        uint8 indexed _status,
1319        uint8 _posStatus,
1320        uint256 _endTime
1321      );
1322 
1323   event Cancel( uint256 indexed _tableId);
1324 
1325   event Finish(
1326         uint256 _tableId,
1327         uint256 _amount,
1328         uint256 indexed pos1,
1329         uint256 indexed pos2,
1330         uint256 indexed pos3,
1331         uint8 _position,//Marked position is occupied 1 1-2, 2 2-3, 3 1-3, 4,123
1332         uint8 _diceA,
1333         uint8 _diceB
1334       );
1335 
1336     mapping (uint256 => player)   player_;
1337     mapping (address => uint256)  playAddr_;
1338     mapping (uint256 => uint256)  playAff_;
1339     mapping(uint256 => table)  tables_;
1340      uint256[200] openTable_;//Maximum free table number 200
1341      gameConfig  gameConfig_;
1342      address  admin__;
1343      uint256 private autoPlayId_=123456;
1344      uint256 private autoTableId_=0;
1345      uint32 private  CUSTOM_GASLIMIT =150000;//Cost of payment calculation gas
1346     
1347      constructor() public {
1348             admin__ = msg.sender;
1349             uint256 gasPrice=10100000000;//10.1GWEI
1350             oraclize_setCustomGasPrice(gasPrice);//Sent to the draw absenteeism Gwei
1351             gameConfig_=gameConfig(
1352           3,//Buy a draw bid 1/3
1353           60000000000000000,//0.06 eth Minimum 
1354           12000000000000000000,//12 eth Maximum
1355           120 seconds,//Delayed Draw 5 minutes
1356           gasPrice*CUSTOM_GASLIMIT,//Total cost of Mining to be paid
1357           3//Cancellation fees% - Partially used to pay the Mining fee
1358           ,6//Winner handling Fee% - Partially used to pay the Mining fee
1359          );
1360         getPlayId(admin__);
1361     }
1362  
1363    
1364  function getMyInfo()external view returns(uint,uint){
1365        uint _pid =playAddr_[msg.sender];
1366        player memory _p=player_[_pid];
1367        return(
1368             _pid,
1369             _p.balance
1370         );
1371   }
1372  
1373  function withdraw(uint256 pid) safe() external{
1374         require(playAddr_[msg.sender] == pid,'Error Action');
1375         require(player_[pid].addr == msg.sender,'Error Action');
1376         require(player_[pid].balance >0,'Insufficient balance');
1377         uint256 balance =player_[pid].balance;
1378         player_[pid].balance=0;
1379         return player_[pid].addr.transfer(balance);
1380     }
1381     
1382     //Lottery callback
1383     function __callback(bytes32 myid, string result)safe() public  {
1384             require (validQueryId[myid] > 0,'Error!');
1385             uint256 _tableId=validQueryId[myid];
1386             delete validQueryId[myid];
1387             require(msg.sender == oraclize_cbAddress(),'Error 1');
1388             __lottery(_tableId,result);
1389     }
1390      
1391      
1392      //Lottery program core code   
1393       function __lottery(uint256 _tableId,string strNumber) private safe(){
1394                 table storage _t=tables_[_tableId];
1395                 require(_t.status==2 || _t.status==3,'Error 2');
1396                 require(now > _t.endTime,'Error3');
1397                 uint256  diceA=parseInt(subStr(strNumber,0,1));
1398                 require(diceA >=1 && diceA <=6,'Error4');
1399                 uint256  diceB=parseInt(subStr(strNumber,2,3));
1400                 require(diceB >=1 && diceB <=6,'Error5');
1401                 _t.status=4;
1402                 _t.diceA=uint8(diceA);
1403                 _t.diceB=uint8(diceB);
1404                
1405                 openTable_[_t.openIndex]=0;//Mark the table as free
1406               
1407             winnerTransfer(_tableId,_t);
1408             
1409             emit Finish(
1410             _tableId,_t.betAmount,
1411             tables_[_tableId].position[1],
1412             tables_[_tableId].position[2],
1413             tables_[_tableId].position[3],
1414             getPosStatus(_tableId),_t.diceA,_t.diceB
1415             );
1416       }
1417       
1418       //Transfer eth to the winner
1419       function winnerTransfer(uint256 _tableId,table storage _t) private{
1420           
1421             uint8 winPos=0;
1422               //Verification winner
1423               if(_t.diceA>_t.diceB){
1424                   winPos=1;
1425               }else if(_t.diceB>_t.diceA){
1426                   winPos=2;
1427               }else{
1428                   winPos=3;
1429               }
1430               
1431               //The total prize ETH 
1432               uint256 _balance=0;
1433                 
1434               if(_t.position[1]>0){
1435                   _balance=_t.betAmount;
1436               }
1437               if(_t.position[2]>0){
1438                    _balance=add(_balance,_t.betAmount);
1439               }
1440               if(_t.position[3]>0){
1441                      _balance=add(_balance,div(_t.betAmount,gameConfig_.buyDrawScale));
1442               }
1443               //winner player
1444               uint256 _winPid=_t.position[winPos];
1445               uint256 _systemFee=0;
1446          
1447               //Give the winner ETH
1448               if(_winPid>0){
1449                _systemFee=safePercent(gameConfig_.winnerFeePct,_balance);
1450                player_[_winPid].balance=add(player_[_winPid].balance,sub(_balance,_systemFee));
1451               }else{
1452                 //No winners, return ETH
1453                  uint256 _fee=0;
1454               if(_t.position[1]>0){
1455                  uint256 _pos1Pid=_t.position[1];
1456                 _fee=safePercent(gameConfig_.cancelFeePct,_t.betAmount);
1457                  _systemFee=_fee;
1458                  player_[_pos1Pid].balance=add(player_[_pos1Pid].balance,sub(_t.betAmount,_fee));
1459               }
1460               if(_t.position[2]>0){
1461                  uint256 _pos2Pid=_t.position[2];
1462                  _fee=safePercent(gameConfig_.cancelFeePct,_t.betAmount);
1463                  _systemFee=add(_systemFee,_fee);
1464                  player_[_pos2Pid].balance=add(player_[_pos2Pid].balance,sub(_t.betAmount,_fee));
1465               }
1466               
1467               if(_t.position[3]>0){
1468                  uint256 _pos3Pid=_t.position[3];
1469                  uint256 _pos3Amount=div(_t.betAmount,gameConfig_.buyDrawScale);
1470                  _fee=safePercent(gameConfig_.cancelFeePct,_pos3Amount);
1471                  _systemFee=add(_systemFee,_fee);
1472                  player_[_pos3Pid].balance=add(player_[_pos3Pid].balance,sub(_pos3Amount,_fee));
1473               }
1474            }
1475               uint256 _adminId=playAddr_[admin__];
1476               _systemFee=sub(_systemFee,gameConfig_.pushWei);//The admin bears the Fees of the mining
1477               player_[_adminId].balance= add(player_[_adminId].balance,_systemFee);
1478       }
1479       
1480       //Marked position is occupied
1481       function getPosStatus(uint256 _tableId) private view returns(uint8){
1482            table storage  _t=tables_[_tableId];
1483             if(_t.status==1)
1484                     return 0;
1485                 uint8 _posStatus=3;
1486                 // 1 1-2, 2 2-3, 3 1-3, 4 123
1487                 if(_t.position[1]>0 && _t.position[2]>0 && _t.position[3]>0){
1488                     _posStatus=4;
1489                 }else if(_t.position[1]>0 && _t.position[2]>0){
1490                       _posStatus=1;
1491                 }else if(_t.position[2]>0 && _t.position[3]>0){
1492                        _posStatus=2;
1493                 }
1494           return _posStatus;
1495       }
1496 
1497     //Considering the failure of the draw HTTP request, there will be a table with no results to manually cancel the return to ETH
1498     function closeTable(uint256 _tableId) safe() external{
1499             require(msg.sender == admin__,'Error 1');
1500              table storage _t=tables_[_tableId];
1501              //Must have passed the draw time
1502              require(now > _t.endTime,'Error 2');
1503              require(_t.status>=1 && _t.status <=3,'Error 3');
1504           
1505                  _t.status=5;//Set to cancel
1506                 openTable_[_t.openIndex]=0;
1507       
1508                 uint256 _fee=0;
1509                 uint256 _systemFee=0;
1510               if(_t.position[1]>0){
1511                  uint256 _pos1Pid=_t.position[1];
1512                 _fee=safePercent(gameConfig_.cancelFeePct,_t.betAmount);
1513                  _systemFee=_fee;
1514                  player_[_pos1Pid].balance=add(player_[_pos1Pid].balance,sub(_t.betAmount,_fee));
1515               }
1516            
1517               if(_t.position[2]>0){
1518                  uint256 _pos2Pid=_t.position[2];
1519                  _fee=safePercent(gameConfig_.cancelFeePct,_t.betAmount);
1520                  _systemFee=add(_systemFee,_fee);
1521                  player_[_pos2Pid].balance=add(player_[_pos2Pid].balance,sub(_t.betAmount,_fee));
1522               }
1523               
1524               if(_t.position[3]>0){
1525                  uint256 _pos3Pid=_t.position[3];
1526                  uint256 _pos3Amount=div(_t.betAmount,gameConfig_.buyDrawScale);
1527                  _fee=safePercent(gameConfig_.cancelFeePct,_pos3Amount);
1528                  _systemFee=add(_systemFee,_fee);
1529                  player_[_pos3Pid].balance=add(player_[_pos3Pid].balance,sub(_pos3Amount,_fee));
1530               }
1531               require(_systemFee>=gameConfig_.pushWei,'Error 4');
1532               uint256 _adminId=playAddr_[admin__];
1533               _systemFee=sub(_systemFee,gameConfig_.pushWei);//The admin bears the lottery fee
1534               player_[_adminId].balance= add(player_[_adminId].balance,_systemFee);
1535               emit Cancel(_tableId);
1536     }
1537  
1538     
1539      //2020.01.01 Used to update the game
1540 function updateGame() external safe() {
1541         uint time=1577808000;
1542         require(now > time,'Time has not arrived');
1543         require(msg.sender == admin__,'Error');
1544         selfdestruct(admin__);
1545 }
1546  
1547 function bet(uint256 _tableId,uint8 _position) safe() external payable{
1548         uint256 _value=msg.value;
1549         uint256 _valueTemp=_value;
1550         require(_position >=1 && _position<=3,'Error1');   
1551         uint256 _tid=_tableId;
1552         table storage _t=tables_[_tid];
1553         uint256 _now=now;
1554         
1555         //If the location is already or has already won the prize or the number is full, reopen the table. 
1556         // If there are already 2 people, judge whether the purchase time is exceeded.
1557          uint256 _pid= getPlayId(msg.sender);
1558         if(_tid==0 || _tableId>autoTableId_ ||  _t.position[_position] >0  || _t.status >=3 || (_t.status==2 && _now > _t.endTime)){
1559             //The bid for a draw is 1/3;
1560             _valueTemp= _position==3?mul(_value,gameConfig_.buyDrawScale):_value;
1561             require(_valueTemp >=gameConfig_.minBetWei && 
1562             _valueTemp<=gameConfig_.maxBetWei,'The amount of bet is in the range of 0.06-12 ETH');   
1563             require(_valueTemp%gameConfig_.minBetWei==0,'The amount of bet is in the range of 0.06-12 ETH');
1564             autoTableId_++;
1565             _tid=autoTableId_;
1566             _t=tables_[_tid];
1567            
1568            //The first person to bet determines the ETH of the bet
1569            _t.betAmount=_valueTemp;
1570            uint8 openIndex= getOpenTableIndex();
1571            require(openIndex<200,'Error 8');
1572            openTable_[openIndex]=_tid;
1573            _t.openIndex=openIndex;
1574             
1575        }else{
1576         //Only one bet is allowed per table per person
1577         require(_t.position[1]!=_pid &&  _t.position[2]!=_pid  && _t.position[3]!=_pid,'Error7'); 
1578               //Buy flat bid validation
1579               if(_position==3){
1580                 require (_value == div(_t.betAmount,gameConfig_.buyDrawScale),'Error5');
1581               }else{
1582                 //Buy a winning bid
1583                 require (_value ==_t.betAmount,'Error6');
1584               }
1585        }
1586        _t.status++;
1587         //A 2-person game starts the countdown.
1588       if(_t.status==2){
1589          _t.endTime=add(_now,gameConfig_.countdown);
1590          
1591       //Verify that the balance is sufficient for the draw absenteeism lottery
1592       require(address(this).balance>=gameConfig_.pushWei,'Oraclize query was NOT sent, please add some ETH to cover for the query fee');
1593       //Countdown Draw
1594       bytes32 queryId =
1595         oraclize_query(gameConfig_.countdown, "URL", 
1596         "html(https://www.random.org/dice/?num=2).xpath(concat((//p/img[@alt>0]/@alt)[1],'|',(//p/img[@alt>0]/@alt)[last()]))",
1597         CUSTOM_GASLIMIT);
1598        validQueryId[queryId]=_tid;
1599      }
1600         _t.position[_position]=_pid;//Put the user on the seat
1601         emit Bet(msg.sender,_tid,_value,_position,_t.status,getPosStatus(_tid),_t.endTime);
1602 }
1603     
1604     
1605     function getTableInfo(uint256 _tableId) view external  returns(
1606         uint256,uint256,uint256,uint256,uint8,uint8,uint8,uint256
1607         ){
1608          table storage _t=tables_[_tableId];
1609           return (
1610              _t.betAmount,
1611            _t.position[1],
1612            _t.position[2],
1613            _t.position[3],
1614             _t.status,
1615             _t.diceA,
1616             _t.diceB,
1617            _t.endTime
1618          );
1619     }
1620     
1621 
1622   function getOpenTableIndex() view private returns(uint8){
1623        for(uint8 i=0;i<openTable_.length;i++){
1624            if(openTable_[i]==0)
1625             return i;
1626        }
1627        return 201;
1628    }
1629    
1630    //Get a list of available tables
1631     function getOpenTableList() external view  returns(uint256[200]){
1632        return openTable_;
1633    }
1634   
1635     function getPlayId(address addr) private returns(uint256){
1636         require (address(0)!=addr,'Error Addr');
1637         if(playAddr_[addr] >0){
1638          return playAddr_[addr];
1639         }
1640               autoPlayId_++;
1641               playAddr_[addr]=autoPlayId_;
1642               player memory _p;
1643               _p.id=autoPlayId_;
1644               _p.addr=addr;
1645               _p.timeStamp=now;
1646               player_[autoPlayId_]=_p;
1647               return autoPlayId_;
1648    }
1649 
1650 }
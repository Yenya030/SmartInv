1 pragma solidity ^0.4.18;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7     
8     function safeMul(uint a, uint b) internal pure returns (uint) {
9         uint c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13     
14     function safeDiv(uint a, uint b) internal pure returns (uint) {
15         assert(b > 0);
16         uint c = a / b;
17         assert(a == b * c + a % b);
18         return c;
19     }
20     
21     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25     
26     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31     
32     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
33         return a >= b ? a : b;
34     }
35     
36     function min64(uint64 a, uint64 b) internal pure returns (uint64) 
37     {
38         return a < b ? a : b;
39     }
40     
41     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
42         return a >= b ? a : b;
43     }
44     
45     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
46         return a < b ? a : b;
47     }
48  }
49  
50  /**
51  * Date and Time utilities for ethereum contracts
52  */
53  contract DateTime {
54 
55         struct _DateTime {
56                 uint16 year;
57                 uint8 month;
58                 uint8 day;
59                 uint8 hour;
60                 uint8 minute;
61                 uint8 second;
62                 uint8 weekday;
63         }
64 
65         uint constant DAY_IN_SECONDS = 86400;
66         uint constant YEAR_IN_SECONDS = 31536000;
67         uint constant LEAP_YEAR_IN_SECONDS = 31622400;
68 
69         uint constant HOUR_IN_SECONDS = 3600;
70         uint constant MINUTE_IN_SECONDS = 60;
71 
72         uint16 constant ORIGIN_YEAR = 1970;
73 
74         function isLeapYear(uint16 year) internal pure returns (bool) {
75                 if (year % 4 != 0) {
76                         return false;
77                 }
78                 if (year % 100 != 0) {
79                         return true;
80                 }
81                 if (year % 400 != 0) {
82                         return false;
83                 }
84                 return true;
85         }
86 
87         function leapYearsBefore(uint year) internal pure returns (uint) {
88                 year -= 1;
89                 return year / 4 - year / 100 + year / 400;
90         }
91 
92         function getDaysInMonth(uint8 month, uint16 year) internal pure returns (uint8) {
93                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
94                         return 31;
95                 }
96                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
97                         return 30;
98                 }
99                 else if (isLeapYear(year)) {
100                         return 29;
101                 }
102                 else {
103                         return 28;
104                 }
105         }
106 
107         function parseTimestamp(uint timestamp) internal pure returns (_DateTime dt) {
108                 uint secondsAccountedFor = 0;
109                 uint buf;
110                 uint8 i;
111 
112                 // Year
113                 dt.year = getYear(timestamp);
114                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
115 
116                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
117                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
118 
119                 // Month
120                 uint secondsInMonth;
121                 for (i = 1; i <= 12; i++) {
122                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
123                         if (secondsInMonth + secondsAccountedFor > timestamp) {
124                                 dt.month = i;
125                                 break;
126                         }
127                         secondsAccountedFor += secondsInMonth;
128                 }
129 
130                 // Day
131                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
132                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
133                                 dt.day = i;
134                                 break;
135                         }
136                         secondsAccountedFor += DAY_IN_SECONDS;
137                 }
138 
139                 // Hour
140                 dt.hour = getHour(timestamp);
141 
142                 // Minute
143                 dt.minute = getMinute(timestamp);
144 
145                 // Second
146                 dt.second = getSecond(timestamp);
147 
148                 // Day of week.
149                 dt.weekday = getWeekday(timestamp);
150         }
151 
152         function getYear(uint timestamp) internal pure returns (uint16) {
153                 uint secondsAccountedFor = 0;
154                 uint16 year;
155                 uint numLeapYears;
156 
157                 // Year
158                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
159                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
160 
161                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
162                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
163 
164                 while (secondsAccountedFor > timestamp) {
165                         if (isLeapYear(uint16(year - 1))) {
166                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
167                         }
168                         else {
169                                 secondsAccountedFor -= YEAR_IN_SECONDS;
170                         }
171                         year -= 1;
172                 }
173                 return year;
174         }
175 
176         function getMonth(uint timestamp) internal pure returns (uint8) {
177                 return parseTimestamp(timestamp).month;
178         }
179 
180         function getDay(uint timestamp) internal pure returns (uint8) {
181                 return parseTimestamp(timestamp).day;
182         }
183 
184         function getHour(uint timestamp) internal pure returns (uint8) {
185                 return uint8((timestamp / 60 / 60) % 24);
186         }
187 
188         function getMinute(uint timestamp) internal pure returns (uint8) {
189                 return uint8((timestamp / 60) % 60);
190         }
191 
192         function getSecond(uint timestamp) internal pure returns (uint8) {
193                 return uint8(timestamp % 60);
194         }
195 
196         function getWeekday(uint timestamp) internal pure returns (uint8) {
197                 return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
198         }
199 
200         function toTimestamp(uint16 year, uint8 month, uint8 day) internal pure returns (uint timestamp) {
201                 return toTimestamp(year, month, day, 0, 0, 0);
202         }
203 
204         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) internal pure returns (uint timestamp) {
205                 return toTimestamp(year, month, day, hour, 0, 0);
206         }
207 
208         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) internal pure returns (uint timestamp) {
209                 return toTimestamp(year, month, day, hour, minute, 0);
210         }
211 
212         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) internal pure returns (uint timestamp) {
213                 uint16 i;
214 
215                 // Year
216                 for (i = ORIGIN_YEAR; i < year; i++) {
217                         if (isLeapYear(i)) {
218                                 timestamp += LEAP_YEAR_IN_SECONDS;
219                         }
220                         else {
221                                 timestamp += YEAR_IN_SECONDS;
222                         }
223                 }
224 
225                 // Month
226                 uint8[12] memory monthDayCounts;
227                 monthDayCounts[0] = 31;
228                 if (isLeapYear(year)) {
229                         monthDayCounts[1] = 29;
230                 }
231                 else {
232                         monthDayCounts[1] = 28;
233                 }
234                 monthDayCounts[2] = 31;
235                 monthDayCounts[3] = 30;
236                 monthDayCounts[4] = 31;
237                 monthDayCounts[5] = 30;
238                 monthDayCounts[6] = 31;
239                 monthDayCounts[7] = 31;
240                 monthDayCounts[8] = 30;
241                 monthDayCounts[9] = 31;
242                 monthDayCounts[10] = 30;
243                 monthDayCounts[11] = 31;
244 
245                 for (i = 1; i < month; i++) {
246                         timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
247                 }
248 
249                 // Day
250                 timestamp += DAY_IN_SECONDS * (day - 1);
251 
252                 // Hour
253                 timestamp += HOUR_IN_SECONDS * (hour);
254 
255                 // Minute
256                 timestamp += MINUTE_IN_SECONDS * (minute);
257 
258                 // Second
259                 timestamp += second;
260 
261                 return timestamp;
262         }
263 }
264 
265 contract ERC20 {
266     function totalSupply() public constant returns (uint256);
267     function balanceOf(address _owner) public constant returns (uint);
268     function transfer(address _to, uint _value) public returns (bool);
269     function transferFrom(address _from, address _to, uint _value) public returns (bool);
270     function approve(address _spender, uint _value) public returns (bool);
271     function allowance(address _owner, address _spender) public constant returns (uint);
272     event Transfer(address indexed _from, address indexed _to, uint _value);
273     event Approval(address indexed _owner, address indexed _spender, uint _value);
274 } 
275  
276 
277 contract EdgeSmartToken is ERC20, SafeMath, DateTime {
278 
279     uint256  public constant _decimals = 18;
280     uint256 public constant _totalSupply = (100000000 * 10**_decimals);
281     
282     string public constant symbol = 'EST';
283     string public constant name = 'Edge Smart Token';
284     
285     mapping(address => uint256) public balances;
286     mapping(address => mapping(address => uint256)) approved;
287     address EdgeSmartTokenOwner;
288 
289     modifier onlyOwner() {
290         require(msg.sender == EdgeSmartTokenOwner);
291         _;
292     }    
293     
294     function EdgeSmartToken() public {
295         EdgeSmartTokenOwner = msg.sender;
296         balances[EdgeSmartTokenOwner] = _totalSupply;
297     }
298    
299     /**
300     * @dev Allows the current owner to transfer control of the contract to a newOwner.
301     * @param newOwner The address to transfer ownership to.
302     */
303     function transferOwnership(address newOwner) public onlyOwner {
304         require(newOwner != EdgeSmartTokenOwner);      
305         EdgeSmartTokenOwner = newOwner;
306     }    
307     
308 
309     function decimals() public constant returns (uint256) {
310         return _decimals;
311     }
312 
313     function totalSupply() public constant returns (uint256) {
314         return _totalSupply;
315     }
316 
317     function balanceOf(address _owner) public constant returns (uint256) {
318         return balances[_owner];
319     }
320 
321     /**
322      * @dev Transfer self tokens to given address
323      * @param _to destination address
324      * @param _value amount of token values to send
325      * @notice `_value` tokens will be sended to `_to`
326      * @return `true` when transfer done
327      */
328     function transfer(address _to, uint256 _value) public returns (bool) {
329         require(
330             balances[msg.sender] >= _value && _value > 0
331         );
332         balances[msg.sender] = safeSub(balances[msg.sender], _value);
333         balances[_to] = safeAdd(balances[_to], _value);
334         Transfer(msg.sender, _to, _value);
335         return true;
336     }
337 
338     /**
339      * @dev Transfer with approvement mechainsm
340      * @param _from source address, `_value` tokens shold be approved for `sender`
341      * @param _to destination address
342      * @param _value amount of token values to send
343      * @notice from `_from` will be sended `_value` tokens to `_to`
344      * @return `true` when transfer is done
345      */
346     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
347         require(
348             approved[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0
349         );
350         balances[_from] = safeSub(balances[_from], _value);
351         balances[_to] = safeAdd(balances[_to], _value);
352         approved[_from][msg.sender] = safeSub(approved[_from][msg.sender], _value);
353         Transfer(_from, _to, _value);
354         return true;
355     }
356 
357     /**
358      * @dev Give to target address ability for self token manipulation without sending
359      * @param _spender target address (future requester)
360      * @param _value amount of token values for approving
361      */
362     function approve(address _spender, uint256 _value) public returns (bool) {
363         approved[msg.sender][_spender] = _value;
364         Approval(msg.sender, _spender, _value);
365         return true;
366     }
367     
368     /**
369      * @dev Reset count of tokens approved for given address
370      * @param _spender target address (future requester)
371      */
372     function unapprove(address _spender) public { 
373         approved[msg.sender][_spender] = 0; 
374     }
375 
376     /**
377      * @dev Take allowed tokens
378      * @param _owner The address of the account owning tokens
379      * @param _spender The address of the account able to transfer the tokens
380      * @return Amount of remaining tokens allowed to spent
381      */
382     function allowance(address _owner, address _spender) public constant returns (uint256) {
383         return approved[_owner][_spender];
384     }
385 
386     event Transfer(address indexed _from, address indexed _to, uint256 _value);
387 
388     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
389 }
390 
391 contract EdgeICO is SafeMath, DateTime, EdgeSmartToken {
392     
393     address owner; 
394     uint totalCollected = 0;
395     uint preSaleCollected = 0;
396     uint ICOCollected = 0;
397     uint256 public totalTokensCap = (50000000 * 10**_decimals); //50% of total supply
398     uint public preSaleTokensLimit = (10000000 * 10**_decimals); //10% of total supply
399     
400     uint256 public icoSaleSoftCap = (5000000 * 10**_decimals); //5mio EST or 1000 ETH
401     uint public icoSaleHardCap = (25000000 * 10**_decimals);//25mio EST or 5000 ETH
402    
403     uint256 private preSaleTokenPrice = (10000 * 10**_decimals); //10k
404     uint256 private ICOTokenPrice = (5000 * 10**_decimals); //5k
405    
406     bool preSaleActive = false;
407     bool ICOActive = false;
408    
409     uint pre_ICO_end_date = toTimestamp(2017, 12, 6, 20, 0);
410    
411     uint ICO_end_date = toTimestamp(2018, 1, 1, 20, 0); 
412     
413     //since ICO date and period are not defined precisely, lets put hard end date 
414     uint ICO_hardcoded_expiry_date = toTimestamp(2019, 1, 1, 20, 0); 
415    
416     uint256 private tokensToBuy;
417     
418     address ICOEdgeWallet = 0xb3AF93036f8949E8A8Ba8D783bF0A63914a63859;
419 
420     //constructor
421     function EdgeICO() {
422        owner = msg.sender;
423     }
424    
425     modifier onlyOwner() {
426         require(msg.sender == owner);
427         _;
428     }
429 
430     function getTotalTokensSold() public constant returns (uint) {
431         return totalCollected;
432     }
433     
434     function getPreSaleTokensSold() public constant returns (uint) {
435         return preSaleCollected;
436     } 
437     
438     function getIcoTokensSold() public constant returns (uint) {
439         return ICOCollected;
440     }    
441     
442     function setPreSaleStatus(bool status) onlyOwner public {
443         preSaleActive = status;
444     }
445     
446     function setICOStatus(bool status) onlyOwner public {
447         ICOActive = status;
448     }
449     
450     function setIcoEndDate(uint endDate) onlyOwner public {
451         ICO_end_date = endDate;
452     }    
453     
454     function () public payable {
455         createTokens(msg.sender);
456     }
457     
458     function createTokens(address recipient) public payable {
459         
460         require(now < ICO_hardcoded_expiry_date);
461         
462         
463         if (preSaleActive && (now < pre_ICO_end_date)) {
464             require(msg.value >= 1 * (1 ether)); //minimum 1 ETH
465             tokensToBuy = safeDiv(safeMul(msg.value * 1 ether, preSaleTokenPrice), 1000000000000000000 ether);  
466             require (preSaleCollected + tokensToBuy <= preSaleTokensLimit); //within preSale sell only 10mio 
467             require (totalCollected + tokensToBuy <= totalTokensCap); //max sell 50mio
468             preSaleCollected = safeAdd(preSaleCollected, tokensToBuy);
469             totalCollected = safeAdd(totalCollected, tokensToBuy);
470             
471             balances[recipient] = safeAdd(balances[recipient], tokensToBuy);
472             balances[owner] = safeSub(balances[owner], tokensToBuy);
473             Transfer(owner, recipient, tokensToBuy);
474             // send and transfer are considered to be a safe way to move funds as they have a gas stipend of 2300
475             ICOEdgeWallet.transfer(msg.value);
476             
477         }
478         else
479         if (ICOActive && (now < ICO_end_date)) {
480             require(msg.value >= 0.1 * (1 ether)); //minimum 0.1 ETH
481             tokensToBuy = safeDiv(safeMul(msg.value * 1 ether, ICOTokenPrice), 1000000000000000000 ether);
482             require (totalCollected + tokensToBuy <= totalTokensCap); //max sell 50mio, 40mio + rest from preSale
483             ICOCollected = safeAdd(ICOCollected, tokensToBuy);
484             totalCollected = safeAdd(totalCollected, tokensToBuy);
485             
486             balances[recipient] = safeAdd(balances[recipient], tokensToBuy);
487             balances[owner] = safeSub(balances[owner], tokensToBuy);
488             Transfer(owner, recipient, tokensToBuy);
489             //Both send and transfer are considered to be a safe way to move funds as they have a gas stipend of 2300
490             ICOEdgeWallet.transfer(msg.value); 
491             
492         }
493         else  {
494             //preSale and ICO finished
495             throw;
496         }
497     }
498 }
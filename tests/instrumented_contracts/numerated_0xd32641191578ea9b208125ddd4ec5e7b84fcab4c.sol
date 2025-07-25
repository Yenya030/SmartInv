1 pragma solidity ^0.4.22;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;       
19     }       
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 
34 contract Ownable {
35     address public owner;
36     address public newOwner;
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40     constructor() public {
41         owner = msg.sender;
42         newOwner = address(0);
43     }
44 
45     modifier onlyOwner() {
46         require(msg.sender == owner);
47         _;
48     }
49     modifier onlyNewOwner() {
50         require(msg.sender != address(0));
51         require(msg.sender == newOwner);
52         _;
53     }
54 
55     function transferOwnership(address _newOwner) public onlyOwner {
56         require(_newOwner != address(0));
57         newOwner = _newOwner;
58     }
59 
60     function acceptOwnership() public onlyNewOwner returns(bool) {
61         emit OwnershipTransferred(owner, newOwner);        
62         owner = newOwner;
63         newOwner = 0x0;
64     }
65 }
66 
67 contract Pausable is Ownable {
68     event Pause();
69     event Unpause();
70 
71     bool public paused = false;
72 
73     modifier whenNotPaused() {
74         require(!paused);
75         _;
76     }
77 
78     modifier whenPaused() {
79         require(paused);
80         _;
81     }
82 
83     function pause() onlyOwner whenNotPaused public {
84         paused = true;
85         emit Pause();
86     }
87 
88     function unpause() onlyOwner whenPaused public {
89         paused = false;
90         emit Unpause();
91     }
92 }
93 
94 contract ERC20 {
95     function totalSupply() public view returns (uint256);
96     function balanceOf(address who) public view returns (uint256);
97     function allowance(address owner, address spender) public view returns (uint256);
98     function transfer(address to, uint256 value) public returns (bool);
99     function transferFrom(address from, address to, uint256 value) public returns (bool);
100     function approve(address spender, uint256 value) public returns (bool);
101 
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 }
105 
106 
107 interface TokenRecipient {
108     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
109 }
110 
111 
112 contract TMEDToken is ERC20, Ownable, Pausable {
113 
114     using SafeMath for uint256;
115 
116     struct LockupInfo {
117         uint256 releaseTime;
118         uint256 termOfRound;
119         uint256 unlockAmountPerRound;        
120         uint256 lockupBalance;
121     }
122 
123     string public name;
124     string public symbol;
125     uint8 constant public decimals =18;
126     uint256 internal initialSupply;
127     uint256 internal totalSupply_;
128 
129     mapping(address => uint256) internal balances;
130     mapping(address => bool) internal locks;
131     mapping(address => bool) public frozen;
132     mapping(address => mapping(address => uint256)) internal allowed;
133     mapping(address => LockupInfo[]) internal lockupInfo;
134 
135     event Lock(address indexed holder, uint256 value);
136     event Unlock(address indexed holder, uint256 value);
137     event Burn(address indexed owner, uint256 value);
138     event Freeze(address indexed holder);
139     event Unfreeze(address indexed holder);
140 
141     modifier notFrozen(address _holder) {
142         require(!frozen[_holder]);
143         _;
144     }
145 
146     constructor() public {
147         name = "TMED Token";
148         symbol = "TMED";
149         initialSupply = 28000000000;
150         totalSupply_ = initialSupply * 10 ** uint(decimals);
151         balances[owner] = totalSupply_;
152         emit Transfer(address(0), owner, totalSupply_);
153     }
154 
155     //
156     function () public payable {
157         revert();
158     }
159 
160     function totalSupply() public view returns (uint256) {
161         return totalSupply_;
162     }
163 
164     function transfer(address _to, uint256 _value) public whenNotPaused notFrozen(msg.sender) returns (bool) {
165         if (locks[msg.sender]) {
166             autoUnlock(msg.sender);            
167         }
168         require(_to != address(0));
169         require(_value <= balances[msg.sender]);
170         
171 
172         // SafeMath.sub will throw if there is not enough balance.
173         balances[msg.sender] = balances[msg.sender].sub(_value);
174         balances[_to] = balances[_to].add(_value);
175         emit Transfer(msg.sender, _to, _value);
176         return true;
177     }
178 
179     function balanceOf(address _holder) public view returns (uint256 balance) {
180         uint256 lockedBalance = 0;
181         if(locks[_holder]) {
182             for(uint256 idx = 0; idx < lockupInfo[_holder].length ; idx++ ) {
183                 lockedBalance = lockedBalance.add(lockupInfo[_holder][idx].lockupBalance);
184             }
185         }
186         return balances[_holder] + lockedBalance;
187     }
188 
189     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused notFrozen(_from)returns (bool) {
190         if (locks[_from]) {
191             autoUnlock(_from);            
192         }
193         require(_to != address(0));
194         require(_value <= balances[_from]);
195         require(_value <= allowed[_from][msg.sender]);
196         
197 
198         balances[_from] = balances[_from].sub(_value);
199         balances[_to] = balances[_to].add(_value);
200         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
201         emit Transfer(_from, _to, _value);
202         return true;
203     }
204 
205     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
206         allowed[msg.sender][_spender] = _value;
207         emit Approval(msg.sender, _spender, _value);
208         return true;
209     }
210     
211     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
212         require(isContract(_spender));
213         TokenRecipient spender = TokenRecipient(_spender);
214         if (approve(_spender, _value)) {
215             spender.receiveApproval(msg.sender, _value, this, _extraData);
216             return true;
217         }
218     }
219 
220     function allowance(address _holder, address _spender) public view returns (uint256) {
221         return allowed[_holder][_spender];
222     }
223 
224     function lock(address _holder, uint256 _amount, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
225         require(balances[_holder] >= _amount);
226         if(_termOfRound==0 ) {
227             _termOfRound = 1;
228         }
229         balances[_holder] = balances[_holder].sub(_amount);
230         lockupInfo[_holder].push(
231             LockupInfo(_releaseStart, _termOfRound, _amount.div(100).mul(_releaseRate), _amount)
232         );
233 
234         locks[_holder] = true;
235 
236         emit Lock(_holder, _amount);
237 
238         return true;
239     }
240 
241     function unlock(address _holder, uint256 _idx) public onlyOwner returns (bool) {
242         require(locks[_holder]);
243         require(_idx < lockupInfo[_holder].length);
244         LockupInfo storage lockupinfo = lockupInfo[_holder][_idx];
245         uint256 releaseAmount = lockupinfo.lockupBalance;
246 
247         delete lockupInfo[_holder][_idx];
248         lockupInfo[_holder][_idx] = lockupInfo[_holder][lockupInfo[_holder].length.sub(1)];
249         lockupInfo[_holder].length -=1;
250         if(lockupInfo[_holder].length == 0) {
251             locks[_holder] = false;
252         }
253 
254         emit Unlock(_holder, releaseAmount);
255         balances[_holder] = balances[_holder].add(releaseAmount);
256 
257         return true;
258     }
259 
260     function freezeAccount(address _holder) public onlyOwner returns (bool) {
261         require(!frozen[_holder]);
262         frozen[_holder] = true;
263         emit Freeze(_holder);
264         return true;
265     }
266 
267     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
268         require(frozen[_holder]);
269         frozen[_holder] = false;
270         emit Unfreeze(_holder);
271         return true;
272     }
273 
274     function getNowTime() public view returns(uint256) {
275         return now;
276     }
277 
278     function showLockState(address _holder, uint256 _idx) public view returns (bool, uint256, uint256, uint256, uint256, uint256) {
279         if(locks[_holder]) {
280             return (
281                 locks[_holder], 
282                 lockupInfo[_holder].length, 
283                 lockupInfo[_holder][_idx].lockupBalance, 
284                 lockupInfo[_holder][_idx].releaseTime, 
285                 lockupInfo[_holder][_idx].termOfRound, 
286                 lockupInfo[_holder][_idx].unlockAmountPerRound
287             );
288         } else {
289             return (
290                 locks[_holder], 
291                 lockupInfo[_holder].length, 
292                 0,0,0,0
293             );
294 
295         }        
296     }
297     
298     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
299         require(_to != address(0));
300         require(_value <= balances[owner]);
301 
302         balances[owner] = balances[owner].sub(_value);
303         balances[_to] = balances[_to].add(_value);
304         emit Transfer(owner, _to, _value);
305         return true;
306     }
307 
308     function distributeWithLockup(address _to, uint256 _value, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
309         distribute(_to, _value);
310         lock(_to, _value, _releaseStart, _termOfRound, _releaseRate);
311         return true;
312     }
313 
314     function claimToken(ERC20 token, address _to, uint256 _value) public onlyOwner returns (bool) {
315         token.transfer(_to, _value);
316         return true;
317     }
318 
319     function burn(uint256 _value) public onlyOwner returns (bool success) {
320         require(_value <= balances[msg.sender]);
321         address burner = msg.sender;
322         balances[burner] = balances[burner].sub(_value);
323         totalSupply_ = totalSupply_.sub(_value);
324         emit Burn(burner, _value);
325         return true;
326     }
327 
328     function isContract(address addr) internal view returns (bool) {
329         uint size;
330         assembly{size := extcodesize(addr)}
331         return size > 0;
332     }
333 
334     function autoUnlock(address _holder) internal returns (bool) {
335 
336         for(uint256 idx =0; idx < lockupInfo[_holder].length ; idx++ ) {
337             if(locks[_holder]==false) {
338                 return true;
339             }
340             if (lockupInfo[_holder][idx].releaseTime <= now) {
341                 // If lockupinfo was deleted, loop restart at same position.
342                 if( releaseTimeLock(_holder, idx) ) {
343                     idx -=1;
344                 }
345             }
346         }
347         return true;
348     }
349 
350     function releaseTimeLock(address _holder, uint256 _idx) internal returns(bool) {
351         require(locks[_holder]);
352         require(_idx < lockupInfo[_holder].length);
353 
354         // If lock status of holder is finished, delete lockup info. 
355         LockupInfo storage info = lockupInfo[_holder][_idx];
356         uint256 releaseAmount = info.unlockAmountPerRound;
357         uint256 sinceFrom = now.sub(info.releaseTime);
358         uint256 sinceRound = sinceFrom.div(info.termOfRound);
359         releaseAmount = releaseAmount.add( sinceRound.mul(info.unlockAmountPerRound) );
360 
361         if(releaseAmount >= info.lockupBalance) {            
362             releaseAmount = info.lockupBalance;
363 
364             delete lockupInfo[_holder][_idx];
365             lockupInfo[_holder][_idx] = lockupInfo[_holder][lockupInfo[_holder].length.sub(1)];
366             lockupInfo[_holder].length -=1;
367 
368             if(lockupInfo[_holder].length == 0) {
369                 locks[_holder] = false;
370             }
371             emit Unlock(_holder, releaseAmount);
372             balances[_holder] = balances[_holder].add(releaseAmount);
373             return true;
374         } else {
375             lockupInfo[_holder][_idx].releaseTime = lockupInfo[_holder][_idx].releaseTime.add( sinceRound.add(1).mul(info.termOfRound) );
376             lockupInfo[_holder][_idx].lockupBalance = lockupInfo[_holder][_idx].lockupBalance.sub(releaseAmount);
377             emit Unlock(_holder, releaseAmount);
378             balances[_holder] = balances[_holder].add(releaseAmount);
379             return false;
380         }
381     }
382 
383 
384 }
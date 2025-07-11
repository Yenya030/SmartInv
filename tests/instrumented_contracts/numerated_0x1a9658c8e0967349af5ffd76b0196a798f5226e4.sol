1 pragma solidity ^0.4.25;
2 
3 contract Approvable {
4 
5     mapping(address => bool) public approved;
6 
7     constructor () public {
8         approved[msg.sender] = true;
9     }
10 
11     function approve(address _address) public onlyApproved {
12         require(_address != address(0));
13         approved[_address] = true;
14     }
15 
16     function revokeApproval(address _address) public onlyApproved {
17         require(_address != address(0));
18         approved[_address] = false;
19     }
20 
21     modifier onlyApproved() {
22         require(approved[msg.sender]);
23         _;
24     }
25 }
26 
27 contract DIDToken is Approvable {
28 
29     using SafeMath for uint256;
30 
31     event LogIssueDID(address indexed to, uint256 numDID);
32     event LogDecrementDID(address indexed to, uint256 numDID);
33     event LogExchangeDIDForEther(address indexed to, uint256 numDID);
34     event LogInvestEtherForDID(address indexed to, uint256 numWei);
35 
36     address[] public DIDHoldersArray;
37 
38     address public PullRequestsAddress;
39     address public DistenseAddress;
40 
41     uint256 public investmentLimitAggregate  = 100000 ether;  // This is the max DID all addresses can receive from depositing ether
42     uint256 public investmentLimitAddress = 100 ether;  // This is the max DID any address can receive from Ether deposit
43     uint256 public investedAggregate = 1 ether;
44 
45     string public name;
46     string public symbol;
47     uint8 public decimals;
48     uint256 public totalSupply;
49 
50     struct DIDHolder {
51         uint256 balance;
52         uint256 netContributionsDID;    // essentially the number of DID remaining for calculating how much ether an account may invest
53         uint256 DIDHoldersIndex;
54         uint256 weiInvested;
55         uint256 tasksCompleted;
56     }
57     mapping (address => DIDHolder) public DIDHolders;
58 
59     constructor () public {
60         name = "Distense DID";
61         symbol = "DID";
62         totalSupply = 0;
63         decimals = 18;
64     }
65 
66     function issueDID(address _recipient, uint256 _numDID) public onlyApproved returns (bool) {
67         require(_recipient != address(0));
68         require(_numDID > 0);
69 
70         _numDID = _numDID * 1 ether;
71         totalSupply = SafeMath.add(totalSupply, _numDID);
72         
73         uint256 balance = DIDHolders[_recipient].balance;
74         DIDHolders[_recipient].balance = SafeMath.add(balance, _numDID);
75 
76         //  If is a new DIDHolder, set their position in DIDHoldersArray
77         if (DIDHolders[_recipient].DIDHoldersIndex == 0) {
78             uint256 index = DIDHoldersArray.push(_recipient) - 1;
79             DIDHolders[_recipient].DIDHoldersIndex = index;
80         }
81 
82         emit LogIssueDID(_recipient, _numDID);
83 
84         return true;
85     }
86 
87     function decrementDID(address _address, uint256 _numDID) external onlyApproved returns (uint256) {
88         require(_address != address(0));
89         require(_numDID > 0);
90 
91         uint256 numDID = _numDID * 1 ether;
92         require(SafeMath.sub(DIDHolders[_address].balance, numDID) >= 0);
93         require(SafeMath.sub(totalSupply, numDID ) >= 0);
94 
95         totalSupply = SafeMath.sub(totalSupply, numDID);
96         DIDHolders[_address].balance = SafeMath.sub(DIDHolders[_address].balance, numDID);
97 
98         //  If DIDHolder has exchanged all of their DID remove from DIDHoldersArray
99         //  For minimizing blockchain size and later client query performance
100         if (DIDHolders[_address].balance == 0) {
101             deleteDIDHolderWhenBalanceZero(_address);
102         }
103 
104         emit LogDecrementDID(_address, numDID);
105 
106         return DIDHolders[_address].balance;
107     }
108 
109     function exchangeDIDForEther(uint256 _numDIDToExchange)
110         external
111     returns (uint256) {
112 
113         uint256 numDIDToExchange = _numDIDToExchange * 1 ether;
114         uint256 netContributionsDID = getNumContributionsDID(msg.sender);
115         require(netContributionsDID >= numDIDToExchange);
116 
117         Distense distense = Distense(DistenseAddress);
118         uint256 DIDPerEther = distense.getParameterValueByTitle(distense.didPerEtherParameterTitle());
119 
120         require(numDIDToExchange < totalSupply);
121 
122         uint256 numWeiToIssue = calculateNumWeiToIssue(numDIDToExchange, DIDPerEther);
123         address contractAddress = this;
124         require(contractAddress.balance >= numWeiToIssue, "DIDToken contract must have sufficient wei");
125 
126         //  Adjust number of DID owned first
127         DIDHolders[msg.sender].balance = SafeMath.sub(DIDHolders[msg.sender].balance, numDIDToExchange);
128         DIDHolders[msg.sender].netContributionsDID = SafeMath.sub(DIDHolders[msg.sender].netContributionsDID, numDIDToExchange);
129         totalSupply = SafeMath.sub(totalSupply, numDIDToExchange);
130 
131         msg.sender.transfer(numWeiToIssue);
132 
133         if (DIDHolders[msg.sender].balance == 0) {
134             deleteDIDHolderWhenBalanceZero(msg.sender);
135         }
136         emit LogExchangeDIDForEther(msg.sender, numDIDToExchange);
137 
138         return DIDHolders[msg.sender].balance;
139     }
140 
141     function investEtherForDID() external payable returns (uint256) {
142         require(getNumWeiAddressMayInvest(msg.sender) >= msg.value);
143         require(investedAggregate < investmentLimitAggregate);
144 
145         Distense distense = Distense(DistenseAddress);
146         uint256 DIDPerEther = SafeMath.div(distense.getParameterValueByTitle(distense.didPerEtherParameterTitle()), 1 ether);
147 
148         uint256 numDIDToIssue = calculateNumDIDToIssue(msg.value, DIDPerEther);
149         require(DIDHolders[msg.sender].netContributionsDID >= numDIDToIssue);
150         totalSupply = SafeMath.add(totalSupply, numDIDToIssue);
151         DIDHolders[msg.sender].balance = SafeMath.add(DIDHolders[msg.sender].balance, numDIDToIssue);
152         DIDHolders[msg.sender].netContributionsDID = SafeMath.sub(DIDHolders[msg.sender].netContributionsDID, numDIDToIssue);
153 
154         DIDHolders[msg.sender].weiInvested += msg.value;
155         investedAggregate = investedAggregate + msg.value;
156 
157         emit LogIssueDID(msg.sender, numDIDToIssue);
158         emit LogInvestEtherForDID(msg.sender, msg.value);
159 
160         return DIDHolders[msg.sender].balance;
161     }
162 
163     function incrementDIDFromContributions(address _contributor, uint256 _reward) onlyApproved public {
164         uint256 weiReward = _reward * 1 ether;
165         DIDHolders[_contributor].netContributionsDID = SafeMath.add(DIDHolders[_contributor].netContributionsDID, weiReward);
166     }
167 
168     function incrementTasksCompleted(address _contributor) onlyApproved public returns (bool) {
169         DIDHolders[_contributor].tasksCompleted++;
170         return true;
171     }
172 
173     function pctDIDOwned(address _address) external view returns (uint256) {
174         return SafeMath.percent(DIDHolders[_address].balance, totalSupply, 20);
175     }
176 
177     function getNumWeiAddressMayInvest(address _contributor) public view returns (uint256) {
178 
179         uint256 DIDFromContributions = DIDHolders[_contributor].netContributionsDID;
180         require(DIDFromContributions > 0);
181         uint256 netUninvestedEther = SafeMath.sub(investmentLimitAddress, DIDHolders[_contributor].weiInvested);
182         require(netUninvestedEther > 0);
183 
184         Distense distense = Distense(DistenseAddress);
185         uint256 DIDPerEther = distense.getParameterValueByTitle(distense.didPerEtherParameterTitle());
186 
187         return (DIDFromContributions * 1 ether) / DIDPerEther;
188     }
189 
190     function rewardContributor(address _contributor, uint256 _reward) external onlyApproved returns (bool) {
191         uint256 reward = SafeMath.div(_reward, 1 ether);
192         bool issued = issueDID(_contributor, reward);
193         if (issued) incrementDIDFromContributions(_contributor, reward);
194         incrementTasksCompleted(_contributor);
195     }
196 
197     function getWeiAggregateMayInvest() public view returns (uint256) {
198         return SafeMath.sub(investmentLimitAggregate, investedAggregate);
199     }
200 
201     function getNumDIDHolders() external view returns (uint256) {
202         return DIDHoldersArray.length;
203     }
204 
205     function getAddressBalance(address _address) public view returns (uint256) {
206         return DIDHolders[_address].balance;
207     }
208 
209     function getNumContributionsDID(address _address) public view returns (uint256) {
210         return DIDHolders[_address].netContributionsDID;
211     }
212 
213     function getWeiInvested(address _address) public view returns (uint256) {
214         return DIDHolders[_address].weiInvested;
215     }
216 
217     function calculateNumDIDToIssue(uint256 msgValue, uint256 DIDPerEther) public pure returns (uint256) {
218         return SafeMath.mul(msgValue, DIDPerEther);
219     }
220 
221     function calculateNumWeiToIssue(uint256 _numDIDToExchange, uint256 _DIDPerEther) public pure returns (uint256) {
222         _numDIDToExchange = _numDIDToExchange * 1 ether;
223         return SafeMath.div(_numDIDToExchange, _DIDPerEther);
224     }
225 
226     function deleteDIDHolderWhenBalanceZero(address holder) internal {
227         if (DIDHoldersArray.length > 1) {
228             address lastElement = DIDHoldersArray[DIDHoldersArray.length - 1];
229             DIDHoldersArray[DIDHolders[holder].DIDHoldersIndex] = lastElement;
230             DIDHoldersArray.length--;
231             delete DIDHolders[holder];
232         }
233     }
234 
235     function deleteDIDHolder(address holder) public onlyApproved {
236         if (DIDHoldersArray.length > 1) {
237             address lastElement = DIDHoldersArray[DIDHoldersArray.length - 1];
238             DIDHoldersArray[DIDHolders[holder].DIDHoldersIndex] = lastElement;
239             DIDHoldersArray.length--;
240             delete DIDHolders[holder];
241         }
242     }
243 
244     function setDistenseAddress(address _distenseAddress) onlyApproved public  {
245         DistenseAddress = _distenseAddress;
246     }
247 
248 }
249 
250 contract Distense is Approvable {
251 
252     using SafeMath for uint256;
253 
254     address public DIDTokenAddress;
255 
256     /*
257       Distense' votable parameters
258       Parameter is the perfect word` for these: "a numerical or other measurable factor forming one of a set
259       that defines a system or sets the conditions of its operation".
260     */
261 
262     //  Titles are what uniquely identify parameters, so query by titles when iterating with clients
263     bytes32[] public parameterTitles;
264 
265     struct Parameter {
266         bytes32 title;
267         uint256 value;
268         mapping(address => Vote) votes;
269     }
270 
271     struct Vote {
272         address voter;
273         uint256 lastVoted;
274     }
275 
276     mapping(bytes32 => Parameter) public parameters;
277 
278     Parameter public votingIntervalParameter;
279     bytes32 public votingIntervalParameterTitle = 'votingInterval';
280 
281     Parameter public pctDIDToDetermineTaskRewardParameter;
282     bytes32 public pctDIDToDetermineTaskRewardParameterTitle = 'pctDIDToDetermineTaskReward';
283 
284     Parameter public pctDIDRequiredToMergePullRequest;
285     bytes32 public pctDIDRequiredToMergePullRequestTitle = 'pctDIDRequiredToMergePullRequest';
286 
287     Parameter public maxRewardParameter;
288     bytes32 public maxRewardParameterTitle = 'maxReward';
289 
290     Parameter public numDIDRequiredToApproveVotePullRequestParameter;
291     bytes32 public numDIDRequiredToApproveVotePullRequestParameterTitle = 'numDIDReqApproveVotePullRequest';
292 
293     Parameter public numDIDRequiredToTaskRewardVoteParameter;
294     bytes32 public numDIDRequiredToTaskRewardVoteParameterTitle = 'numDIDRequiredToTaskRewardVote';
295 
296     Parameter public minNumberOfTaskRewardVotersParameter;
297     bytes32 public minNumberOfTaskRewardVotersParameterTitle = 'minNumberOfTaskRewardVoters';
298 
299     Parameter public numDIDRequiredToAddTaskParameter;
300     bytes32 public numDIDRequiredToAddTaskParameterTitle = 'numDIDRequiredToAddTask';
301 
302     Parameter public defaultRewardParameter;
303     bytes32 public defaultRewardParameterTitle = 'defaultReward';
304 
305     Parameter public didPerEtherParameter;
306     bytes32 public didPerEtherParameterTitle = 'didPerEther';
307 
308     Parameter public votingPowerLimitParameter;
309     bytes32 public votingPowerLimitParameterTitle = 'votingPowerLimit';
310 
311     event LogParameterValueUpdate(bytes32 title, uint256 value);
312 
313     constructor (address _DIDTokenAddress) public {
314 
315         DIDTokenAddress = _DIDTokenAddress;
316 
317         // Launch Distense with some votable parameters
318         // that can be later updated by contributors
319         // Current values can be found at https://disten.se/parameters
320 
321         // Percentage of DID that must vote on a proposal for it to be approved and payable
322         pctDIDToDetermineTaskRewardParameter = Parameter({
323             title : pctDIDToDetermineTaskRewardParameterTitle,
324             //     Every hard-coded int except for dates and numbers (not percentages) pertaining to ether or DID are decimals to two decimal places
325             //     So this is 15.00%
326             value: 15 * 1 ether
327         });
328         parameters[pctDIDToDetermineTaskRewardParameterTitle] = pctDIDToDetermineTaskRewardParameter;
329         parameterTitles.push(pctDIDToDetermineTaskRewardParameterTitle);
330 
331 
332         pctDIDRequiredToMergePullRequest = Parameter({
333             title : pctDIDRequiredToMergePullRequestTitle,
334             value: 10 * 1 ether
335         });
336         parameters[pctDIDRequiredToMergePullRequestTitle] = pctDIDRequiredToMergePullRequest;
337         parameterTitles.push(pctDIDRequiredToMergePullRequestTitle);
338 
339 
340         votingIntervalParameter = Parameter({
341             title : votingIntervalParameterTitle,
342             value: 1296000 * 1 ether// 15 * 86400 = 1.296e+6
343         });
344         parameters[votingIntervalParameterTitle] = votingIntervalParameter;
345         parameterTitles.push(votingIntervalParameterTitle);
346 
347 
348         maxRewardParameter = Parameter({
349             title : maxRewardParameterTitle,
350             value: 2000 * 1 ether
351         });
352         parameters[maxRewardParameterTitle] = maxRewardParameter;
353         parameterTitles.push(maxRewardParameterTitle);
354 
355 
356         numDIDRequiredToApproveVotePullRequestParameter = Parameter({
357             title : numDIDRequiredToApproveVotePullRequestParameterTitle,
358             //     100 DID
359             value: 100 * 1 ether
360         });
361         parameters[numDIDRequiredToApproveVotePullRequestParameterTitle] = numDIDRequiredToApproveVotePullRequestParameter;
362         parameterTitles.push(numDIDRequiredToApproveVotePullRequestParameterTitle);
363 
364 
365         // This parameter is the number of DID an account must own to vote on a task's reward
366         // The task reward is the number of DID payable upon successful completion and approval of a task
367 
368         // This parameter mostly exists to get the percentage of DID that have voted higher per voter
369         //   as looping through voters to determineReward()s is gas-expensive.
370 
371         // This parameter also limits attacks by noobs that want to mess with Distense.
372         numDIDRequiredToTaskRewardVoteParameter = Parameter({
373             title : numDIDRequiredToTaskRewardVoteParameterTitle,
374             // 100
375             value: 100 * 1 ether
376         });
377         parameters[numDIDRequiredToTaskRewardVoteParameterTitle] = numDIDRequiredToTaskRewardVoteParameter;
378         parameterTitles.push(numDIDRequiredToTaskRewardVoteParameterTitle);
379 
380 
381         minNumberOfTaskRewardVotersParameter = Parameter({
382             title : minNumberOfTaskRewardVotersParameterTitle,
383             //     7
384             value: 7 * 1 ether
385         });
386         parameters[minNumberOfTaskRewardVotersParameterTitle] = minNumberOfTaskRewardVotersParameter;
387         parameterTitles.push(minNumberOfTaskRewardVotersParameterTitle);
388 
389 
390         numDIDRequiredToAddTaskParameter = Parameter({
391             title : numDIDRequiredToAddTaskParameterTitle,
392             //     100
393             value: 100 * 1 ether
394         });
395         parameters[numDIDRequiredToAddTaskParameterTitle] = numDIDRequiredToAddTaskParameter;
396         parameterTitles.push(numDIDRequiredToAddTaskParameterTitle);
397 
398 
399         defaultRewardParameter = Parameter({
400             title : defaultRewardParameterTitle,
401             //     100
402             value: 100 * 1 ether
403         });
404         parameters[defaultRewardParameterTitle] = defaultRewardParameter;
405         parameterTitles.push(defaultRewardParameterTitle);
406 
407 
408         didPerEtherParameter = Parameter({
409             title : didPerEtherParameterTitle,
410             //     1000
411             value: 200 * 1 ether
412         });
413         parameters[didPerEtherParameterTitle] = didPerEtherParameter;
414         parameterTitles.push(didPerEtherParameterTitle);
415 
416         votingPowerLimitParameter = Parameter({
417             title : votingPowerLimitParameterTitle,
418             //     20.00%
419             value: 20 * 1 ether
420         });
421         parameters[votingPowerLimitParameterTitle] = votingPowerLimitParameter;
422         parameterTitles.push(votingPowerLimitParameterTitle);
423 
424     }
425 
426     function getParameterValueByTitle(bytes32 _title) public view returns (uint256) {
427         return parameters[_title].value;
428     }
429 
430     /**
431         Function called when contributors vote on parameters at /parameters url
432         In the client there are: max and min buttons and a text input
433 
434         @param _title name of parameter title the DID holder is voting on.  This must be one of the hardcoded titles in this file.
435         @param _voteValue integer in percentage effect.  For example if the current value of a parameter is 20, and the voter votes 24, _voteValue
436         would be 20, for a 20% increase.
437 
438         If _voteValue is 1 it's a max upvote, if -1 max downvote. Maximum votes, as just mentioned, affect parameter values by
439         max(percentage of DID owned by the voter, value of the votingLimit parameter).
440         If _voteValue has a higher absolute value than 1, the user has voted a specific value not maximum up or downvote.
441         In that case we update the value to the voted value if the value would affect the parameter value less than their percentage DID ownership.
442           If they voted a value that would affect the parameter's value by more than their percentage DID ownership we affect the value by their percentage DID ownership.
443     */
444     function voteOnParameter(bytes32 _title, int256 _voteValue)
445         public
446         votingIntervalReached(msg.sender, _title)
447         returns
448     (uint256) {
449 
450         DIDToken didToken = DIDToken(DIDTokenAddress);
451         uint256 votersDIDPercent = didToken.pctDIDOwned(msg.sender);
452         require(votersDIDPercent > 0);
453 
454         uint256 currentValue = getParameterValueByTitle(_title);
455 
456         //  For voting power purposes, limit the pctDIDOwned to the maximum of the Voting Power Limit parameter or the voter's percentage ownership
457         //  of DID
458         uint256 votingPowerLimit = getParameterValueByTitle(votingPowerLimitParameterTitle);
459 
460         uint256 limitedVotingPower = votersDIDPercent > votingPowerLimit ? votingPowerLimit : votersDIDPercent;
461 
462         uint256 update;
463         if (
464             _voteValue == 1 ||  // maximum upvote
465             _voteValue == - 1 || // minimum downvote
466             _voteValue > int(limitedVotingPower) || // vote value greater than votingPowerLimit
467             _voteValue < - int(limitedVotingPower)  // vote value greater than votingPowerLimit absolute value
468         ) {
469             update = (limitedVotingPower * currentValue) / (100 * 1 ether);
470         } else if (_voteValue > 0) {
471             update = SafeMath.div((uint(_voteValue) * currentValue), (1 ether * 100));
472         } else if (_voteValue < 0) {
473             int256 adjustedVoteValue = (-_voteValue); // make the voteValue positive and convert to on-chain decimals
474             update = uint((adjustedVoteValue * int(currentValue))) / (100 * 1 ether);
475         } else revert(); //  If _voteValue is 0 refund gas to voter
476 
477         if (_voteValue > 0)
478             currentValue = SafeMath.add(currentValue, update);
479         else
480             currentValue = SafeMath.sub(currentValue, update);
481 
482         updateParameterValue(_title, currentValue);
483         updateLastVotedOnParameter(_title, msg.sender);
484         emit LogParameterValueUpdate(_title, currentValue);
485 
486         return currentValue;
487     }
488 
489     function getParameterByTitle(bytes32 _title) public view returns (bytes32, uint256) {
490         Parameter memory param = parameters[_title];
491         return (param.title, param.value);
492     }
493 
494     function getNumParameters() public view returns (uint256) {
495         return parameterTitles.length;
496     }
497 
498     function updateParameterValue(bytes32 _title, uint256 _newValue) internal returns (uint256) {
499         Parameter storage parameter = parameters[_title];
500         parameter.value = _newValue;
501         return parameter.value;
502     }
503 
504     function updateLastVotedOnParameter(bytes32 _title, address voter) internal returns (bool) {
505         Parameter storage parameter = parameters[_title];
506         parameter.votes[voter].lastVoted = now;
507     }
508 
509     function setDIDTokenAddress(address _didTokenAddress) public onlyApproved {
510         DIDTokenAddress = _didTokenAddress;
511     }
512 
513     modifier votingIntervalReached(address _voter, bytes32 _title) {
514         Parameter storage parameter = parameters[_title];
515         uint256 lastVotedOnParameter = parameter.votes[_voter].lastVoted * 1 ether;
516         require((now * 1 ether) >= lastVotedOnParameter + getParameterValueByTitle(votingIntervalParameterTitle));
517         _;
518     }
519 }
520 
521 library SafeMath {
522   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
523     if (a == 0) {
524       return 0;
525     }
526     uint256 c = a * b;
527     assert(c / a == b);
528     return c;
529   }
530 
531   function div(uint256 a, uint256 b) internal pure returns (uint256) {
532     // assert(b > 0); // Solidity automatically throws when dividing by 0
533     uint256 c = a / b;
534     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
535     return c;
536   }
537 
538   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
539     assert(b <= a);
540     return a - b;
541   }
542 
543   function add(uint256 a, uint256 b) internal pure returns (uint256) {
544     uint256 c = a + b;
545     assert(c >= a);
546     return c;
547   }
548 
549 
550   function percent(uint numerator, uint denominator, uint precision) public pure
551   returns(uint quotient) {
552 
553     // caution, check safe-to-multiply here
554     uint _numerator  = numerator * 10 ** (precision + 1);
555 
556     // with rounding of last digit
557     uint _quotient =  ((_numerator / denominator) + 5) / 10;
558     return _quotient;
559   }
560 
561 }
1 pragma solidity ^0.4.24;
2 
3 
4 interface PlayerBookReceiverInterface {
5     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
6     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
7 }
8 
9 
10 contract PlayerBook {
11     using NameFilter for string;
12     using SafeMath for uint256;
13     
14     address private manager = msg.sender;
15     address private community1 = 0x28a52B6FB427cf299b67f68835c7A37Bf80db915;
16     address private community2 = 0x366b8C3Dd186A29dCaA9C148F39cdf741997A168;
17 //==============================================================================
18 //     _| _ _|_ _    _ _ _|_    _   .
19 //    (_|(_| | (_|  _\(/_ | |_||_)  .
20 //=============================|================================================    
21     uint256 public registrationFee_ = 10 finney;            // price to register a name
22     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
23     mapping(address => bytes32) public gameNames_;          // lookup a games name
24     mapping(address => uint256) public gameIDs_;            // lokup a games ID
25     uint256 public gID_;        // total number of games
26     uint256 public pID_;        // total number of players
27     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
28     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
29     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
30     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
31     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
32     struct Player {
33         address addr;
34         bytes32 name;
35         uint256 laff;
36         uint256 names;
37     }
38 //==============================================================================
39 //     _ _  _  __|_ _    __|_ _  _  .
40 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
41 //==============================================================================    
42     constructor()
43         public
44     {
45         // premine the dev names (sorry not sorry)
46             // No keys are purchased with this method, it's simply locking our addresses,
47             // PID's and names for referral codes.
48         plyr_[1].addr = 0xdb81a5EFd600B87e31C31C64bc1F73E98a7Ed6D7;
49         plyr_[1].name = "alice";
50         plyr_[1].names = 1;
51         pIDxAddr_[0xdb81a5EFd600B87e31C31C64bc1F73E98a7Ed6D7] = 1;
52         pIDxName_["alice"] = 1;
53         plyrNames_[1]["alice"] = true;
54         plyrNameList_[1][1] = "alice";
55         
56         plyr_[2].addr = 0x4a81569789c65258a9bC727c3990E48bdF97809c;
57         plyr_[2].name = "bob";
58         plyr_[2].names = 1;
59         pIDxAddr_[0x4a81569789c65258a9bC727c3990E48bdF97809c] = 2;
60         pIDxName_["bob"] = 2;
61         plyrNames_[2]["bob"] = true;
62         plyrNameList_[2][1] = "bob";
63         
64         plyr_[3].addr = 0xf5E59B09Fc926abEff0B16989fc649E29cd9dE7B;
65         plyr_[3].name = "clark";
66         plyr_[3].names = 1;
67         pIDxAddr_[0xf5E59B09Fc926abEff0B16989fc649E29cd9dE7B] = 3;
68         pIDxName_["clark"] = 3;
69         plyrNames_[3]["clark"] = true;
70         plyrNameList_[3][1] = "clark";
71         
72         plyr_[4].addr = 0x15Bed2Fd45d1B4C43bFdA83205167E037e147d97;
73         plyr_[4].name = "dog";
74         plyr_[4].names = 1;
75         pIDxAddr_[0x15Bed2Fd45d1B4C43bFdA83205167E037e147d97] = 4;
76         pIDxName_["dog"] = 4;
77         plyrNames_[4]["dog"] = true;
78         plyrNameList_[4][1] = "dog";
79         
80         pID_ = 4;
81     }
82 //==============================================================================
83 //     _ _  _  _|. |`. _  _ _  .
84 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
85 //==============================================================================    
86     /**
87      * @dev prevents contracts from interacting with fomo3d 
88      */
89     modifier isHuman() {
90         address _addr = msg.sender;
91         uint256 _codeLength;
92         
93         assembly {_codeLength := extcodesize(_addr)}
94         require(_codeLength == 0, "sorry humans only");
95         _;
96     }
97     
98     modifier onlyManager() 
99     {
100         require(msg.sender == manager, "msg sender is not the manager");
101         _;
102     }
103     
104     modifier isRegisteredGame()
105     {
106         require(gameIDs_[msg.sender] != 0);
107         _;
108     }
109 //==============================================================================
110 //     _    _  _ _|_ _  .
111 //    (/_\/(/_| | | _\  .
112 //==============================================================================    
113     // fired whenever a player registers a name
114     event onNewName
115     (
116         uint256 indexed playerID,
117         address indexed playerAddress,
118         bytes32 indexed playerName,
119         bool isNewPlayer,
120         uint256 affiliateID,
121         address affiliateAddress,
122         bytes32 affiliateName,
123         uint256 amountPaid,
124         uint256 timeStamp
125     );
126 //==============================================================================
127 //     _  _ _|__|_ _  _ _  .
128 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
129 //=====_|=======================================================================
130     function checkIfNameValid(string _nameStr)
131         public
132         view
133         returns(bool)
134     {
135         bytes32 _name = _nameStr.nameFilter();
136         if (pIDxName_[_name] == 0)
137             return (true);
138         else 
139             return (false);
140     }
141 //==============================================================================
142 //     _    |_ |. _   |`    _  __|_. _  _  _  .
143 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
144 //====|=========================================================================    
145     /**
146      * @dev registers a name.  UI will always display the last name you registered.
147      * but you will still own all previously registered names to use as affiliate 
148      * links.
149      * - must pay a registration fee.
150      * - name must be unique
151      * - names will be converted to lowercase
152      * - name cannot start or end with a space 
153      * - cannot have more than 1 space in a row
154      * - cannot be only numbers
155      * - cannot start with 0x 
156      * - name must be at least 1 char
157      * - max length of 32 characters long
158      * - allowed characters: a-z, 0-9, and space
159      * -functionhash- 0x921dec21 (using ID for affiliate)
160      * -functionhash- 0x3ddd4698 (using address for affiliate)
161      * -functionhash- 0x685ffd83 (using name for affiliate)
162      * @param _nameString players desired name
163      * @param _affCode affiliate ID, address, or name of who refered you
164      * @param _all set to true if you want this to push your info to all games 
165      * (this might cost a lot of gas)
166      */
167     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
168         isHuman()
169         public
170         payable 
171     {
172         // make sure name fees paid
173         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
174         
175         // filter name + condition checks
176         bytes32 _name = NameFilter.nameFilter(_nameString);
177         
178         // set up address 
179         address _addr = msg.sender;
180         
181         // set up our tx event data and determine if player is new or not
182         bool _isNewPlayer = determinePID(_addr);
183         
184         // fetch player id
185         uint256 _pID = pIDxAddr_[_addr];
186         
187         // manage affiliate residuals
188         // if no affiliate code was given, no new affiliate code was given, or the 
189         // player tried to use their own pID as an affiliate code, lolz
190         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
191         {
192             // update last affiliate 
193             plyr_[_pID].laff = _affCode;
194         } else if (_affCode == _pID) {
195             _affCode = 0;
196         }
197         
198         // register name 
199         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
200     }
201     
202     function registerNameXaddr(string _nameString, address _affCode, bool _all)
203         isHuman()
204         public
205         payable 
206     {
207         // make sure name fees paid
208         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
209         
210         // filter name + condition checks
211         bytes32 _name = NameFilter.nameFilter(_nameString);
212         
213         // set up address 
214         address _addr = msg.sender;
215         
216         // set up our tx event data and determine if player is new or not
217         bool _isNewPlayer = determinePID(_addr);
218         
219         // fetch player id
220         uint256 _pID = pIDxAddr_[_addr];
221         
222         // manage affiliate residuals
223         // if no affiliate code was given or player tried to use their own, lolz
224         uint256 _affID;
225         if (_affCode != address(0) && _affCode != _addr)
226         {
227             // get affiliate ID from aff Code 
228             _affID = pIDxAddr_[_affCode];
229             
230             // if affID is not the same as previously stored 
231             if (_affID != plyr_[_pID].laff)
232             {
233                 // update last affiliate
234                 plyr_[_pID].laff = _affID;
235             }
236         }
237         
238         // register name 
239         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
240     }
241     
242     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
243         isHuman()
244         public
245         payable 
246     {
247         // make sure name fees paid
248         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
249         
250         // filter name + condition checks
251         bytes32 _name = NameFilter.nameFilter(_nameString);
252         
253         // set up address 
254         address _addr = msg.sender;
255         
256         // set up our tx event data and determine if player is new or not
257         bool _isNewPlayer = determinePID(_addr);
258         
259         // fetch player id
260         uint256 _pID = pIDxAddr_[_addr];
261         
262         // manage affiliate residuals
263         // if no affiliate code was given or player tried to use their own, lolz
264         uint256 _affID;
265         if (_affCode != "" && _affCode != _name)
266         {
267             // get affiliate ID from aff Code 
268             _affID = pIDxName_[_affCode];
269             
270             // if affID is not the same as previously stored 
271             if (_affID != plyr_[_pID].laff)
272             {
273                 // update last affiliate
274                 plyr_[_pID].laff = _affID;
275             }
276         }
277         
278         // register name 
279         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
280     }
281     
282     /**
283      * @dev players, if you registered a profile, before a game was released, or
284      * set the all bool to false when you registered, use this function to push
285      * your profile to a single game.  also, if you've  updated your name, you
286      * can use this to push your name to games of your choosing.
287      * -functionhash- 0x81c5b206
288      * @param _gameID game id 
289      */
290     function addMeToGame(uint256 _gameID)
291         isHuman()
292         public
293     {
294         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
295         address _addr = msg.sender;
296         uint256 _pID = pIDxAddr_[_addr];
297         require(_pID != 0, "hey there buddy, you dont even have an account");
298         uint256 _totalNames = plyr_[_pID].names;
299         
300         // add players profile and most recent name
301         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
302         
303         // add list of all names
304         if (_totalNames > 1)
305             for (uint256 ii = 1; ii <= _totalNames; ii++)
306                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
307     }
308     
309     /**
310      * @dev players, use this to push your player profile to all registered games.
311      * -functionhash- 0x0c6940ea
312      */
313     function addMeToAllGames()
314         isHuman()
315         public
316     {
317         address _addr = msg.sender;
318         uint256 _pID = pIDxAddr_[_addr];
319         require(_pID != 0, "hey there buddy, you dont even have an account");
320         uint256 _laff = plyr_[_pID].laff;
321         uint256 _totalNames = plyr_[_pID].names;
322         bytes32 _name = plyr_[_pID].name;
323         
324         for (uint256 i = 1; i <= gID_; i++)
325         {
326             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
327             if (_totalNames > 1)
328                 for (uint256 ii = 1; ii <= _totalNames; ii++)
329                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
330         }
331                 
332     }
333     
334     /**
335      * @dev players use this to change back to one of your old names.  tip, you'll
336      * still need to push that info to existing games.
337      * -functionhash- 0xb9291296
338      * @param _nameString the name you want to use 
339      */
340     function useMyOldName(string _nameString)
341         isHuman()
342         public 
343     {
344         // filter name, and get pID
345         bytes32 _name = _nameString.nameFilter();
346         uint256 _pID = pIDxAddr_[msg.sender];
347         
348         // make sure they own the name 
349         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
350         
351         // update their current name 
352         plyr_[_pID].name = _name;
353     }
354     
355 //==============================================================================
356 //     _ _  _ _   | _  _ . _  .
357 //    (_(_)| (/_  |(_)(_||(_  . 
358 //=====================_|=======================================================    
359     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
360         private
361     {
362         // if names already has been used, require that current msg sender owns the name
363         if (pIDxName_[_name] != 0)
364             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
365         
366         // add name to player profile, registry, and name book
367         plyr_[_pID].name = _name;
368         pIDxName_[_name] = _pID;
369         if (plyrNames_[_pID][_name] == false)
370         {
371             plyrNames_[_pID][_name] = true;
372             plyr_[_pID].names++;
373             plyrNameList_[_pID][plyr_[_pID].names] = _name;
374         }
375         
376         // registration fee goes directly to community rewards
377         community1.transfer(address(this).balance/2);
378         community2.transfer(address(this).balance);
379         
380         // push player info to games
381         if (_all == true)
382             for (uint256 i = 1; i <= gID_; i++)
383                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
384         
385         // fire event
386         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
387     }
388 //==============================================================================
389 //    _|_ _  _ | _  .
390 //     | (_)(_)|_\  .
391 //==============================================================================    
392     function determinePID(address _addr)
393         private
394         returns (bool)
395     {
396         if (pIDxAddr_[_addr] == 0)
397         {
398             pID_++;
399             pIDxAddr_[_addr] = pID_;
400             plyr_[pID_].addr = _addr;
401             
402             // set the new player bool to true
403             return (true);
404         } else {
405             return (false);
406         }
407     }
408 //==============================================================================
409 //   _   _|_ _  _ _  _ |   _ _ || _  .
410 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
411 //==============================================================================
412     function getPlayerID(address _addr)
413         isRegisteredGame()
414         external
415         returns (uint256)
416     {
417         determinePID(_addr);
418         return (pIDxAddr_[_addr]);
419     }
420     function getPlayerName(uint256 _pID)
421         external
422         view
423         returns (bytes32)
424     {
425         return (plyr_[_pID].name);
426     }
427     function getPlayerLAff(uint256 _pID)
428         external
429         view
430         returns (uint256)
431     {
432         return (plyr_[_pID].laff);
433     }
434     function getPlayerAddr(uint256 _pID)
435         external
436         view
437         returns (address)
438     {
439         return (plyr_[_pID].addr);
440     }
441     function getNameFee()
442         external
443         view
444         returns (uint256)
445     {
446         return(registrationFee_);
447     }
448     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
449         isRegisteredGame()
450         external
451         payable
452         returns(bool, uint256)
453     {
454         // make sure name fees paid
455         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
456         
457         // set up our tx event data and determine if player is new or not
458         bool _isNewPlayer = determinePID(_addr);
459         
460         // fetch player id
461         uint256 _pID = pIDxAddr_[_addr];
462         
463         // manage affiliate residuals
464         // if no affiliate code was given, no new affiliate code was given, or the 
465         // player tried to use their own pID as an affiliate code, lolz
466         uint256 _affID = _affCode;
467         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
468         {
469             // update last affiliate 
470             plyr_[_pID].laff = _affID;
471         } else if (_affID == _pID) {
472             _affID = 0;
473         }
474         
475         // register name 
476         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
477         
478         return(_isNewPlayer, _affID);
479     }
480     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
481         isRegisteredGame()
482         external
483         payable
484         returns(bool, uint256)
485     {
486         // make sure name fees paid
487         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
488         
489         // set up our tx event data and determine if player is new or not
490         bool _isNewPlayer = determinePID(_addr);
491         
492         // fetch player id
493         uint256 _pID = pIDxAddr_[_addr];
494         
495         // manage affiliate residuals
496         // if no affiliate code was given or player tried to use their own, lolz
497         uint256 _affID;
498         if (_affCode != address(0) && _affCode != _addr)
499         {
500             // get affiliate ID from aff Code 
501             _affID = pIDxAddr_[_affCode];
502             
503             // if affID is not the same as previously stored 
504             if (_affID != plyr_[_pID].laff)
505             {
506                 // update last affiliate
507                 plyr_[_pID].laff = _affID;
508             }
509         }
510         
511         // register name 
512         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
513         
514         return(_isNewPlayer, _affID);
515     }
516     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
517         isRegisteredGame()
518         external
519         payable
520         returns(bool, uint256)
521     {
522         // make sure name fees paid
523         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
524         
525         // set up our tx event data and determine if player is new or not
526         bool _isNewPlayer = determinePID(_addr);
527         
528         // fetch player id
529         uint256 _pID = pIDxAddr_[_addr];
530         
531         // manage affiliate residuals
532         // if no affiliate code was given or player tried to use their own, lolz
533         uint256 _affID;
534         if (_affCode != "" && _affCode != _name)
535         {
536             // get affiliate ID from aff Code 
537             _affID = pIDxName_[_affCode];
538             
539             // if affID is not the same as previously stored 
540             if (_affID != plyr_[_pID].laff)
541             {
542                 // update last affiliate
543                 plyr_[_pID].laff = _affID;
544             }
545         }
546         
547         // register name 
548         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
549         
550         return(_isNewPlayer, _affID);
551     }
552     
553 //==============================================================================
554 //   _ _ _|_    _   .
555 //  _\(/_ | |_||_)  .
556 //=============|================================================================
557     function addGame(address _gameAddress, string _gameNameStr)
558      onlyManager()
559         public
560     {
561         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
562 
563             gID_++;
564             bytes32 _name = _gameNameStr.nameFilter();
565             gameIDs_[_gameAddress] = gID_;
566             gameNames_[_gameAddress] = _name;
567             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
568         
569             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
570             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
571             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
572             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
573     }
574     
575     function setRegistrationFee(uint256 _fee)
576      onlyManager()
577         public
578     {
579             registrationFee_ = _fee;
580     }
581         
582 } 
583 
584 /**
585 * @title -Name Filter- v0.1.9
586 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
587 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
588 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
589 *                                  _____                      _____
590 *                                 (, /     /)       /) /)    (, /      /)          /)
591 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
592 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
593 *          ┴ ┴                /   /          .-/ _____   (__ /                               
594 *                            (__ /          (_/ (, /                                      /)™ 
595 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
596 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
597 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
598 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
599 *              _       __    _      ____      ____  _   _    _____  ____  ___  
600 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
601 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
602 *
603 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
604 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ dog │
605 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
606 */
607 library NameFilter {
608     
609     /**
610      * @dev filters name strings
611      * -converts uppercase to lower case.  
612      * -makes sure it does not start/end with a space
613      * -makes sure it does not contain multiple spaces in a row
614      * -cannot be only numbers
615      * -cannot start with 0x 
616      * -restricts characters to A-Z, a-z, 0-9, and space.
617      * @return reprocessed string in bytes32 format
618      */
619     function nameFilter(string _input)
620         internal
621         pure
622         returns(bytes32)
623     {
624         bytes memory _temp = bytes(_input);
625         uint256 _length = _temp.length;
626         
627         //sorry limited to 32 characters
628         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
629         // make sure it doesnt start with or end with space
630         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
631         // make sure first two characters are not 0x
632         if (_temp[0] == 0x30)
633         {
634             require(_temp[1] != 0x78, "string cannot start with 0x");
635             require(_temp[1] != 0x58, "string cannot start with 0X");
636         }
637         
638         // create a bool to track if we have a non number character
639         bool _hasNonNumber;
640         
641         // convert & check
642         for (uint256 i = 0; i < _length; i++)
643         {
644             // if its uppercase A-Z
645             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
646             {
647                 // convert to lower case a-z
648                 _temp[i] = byte(uint(_temp[i]) + 32);
649                 
650                 // we have a non number
651                 if (_hasNonNumber == false)
652                     _hasNonNumber = true;
653             } else {
654                 require
655                 (
656                     // require character is a space
657                     _temp[i] == 0x20 || 
658                     // OR lowercase a-z
659                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
660                     // or 0-9
661                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
662                     "string contains invalid characters"
663                 );
664                 // make sure theres not 2x spaces in a row
665                 if (_temp[i] == 0x20)
666                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
667                 
668                 // see if we have a character other than a number
669                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
670                     _hasNonNumber = true;    
671             }
672         }
673         
674         require(_hasNonNumber == true, "string cannot be only numbers");
675         
676         bytes32 _ret;
677         assembly {
678             _ret := mload(add(_temp, 32))
679         }
680         return (_ret);
681     }
682 }
683 
684 /**
685  * @title SafeMath v0.1.9
686  * @dev Math operations with safety checks that throw on error
687  * change notes:  original SafeMath library from OpenZeppelin modified by dog
688  * - added sqrt
689  * - added sq
690  * - added pwr 
691  * - changed asserts to requires with error log outputs
692  * - removed div, its useless
693  */
694 library SafeMath {
695     
696     /**
697     * @dev Multiplies two numbers, throws on overflow.
698     */
699     function mul(uint256 a, uint256 b) 
700         internal 
701         pure 
702         returns (uint256 c) 
703     {
704         if (a == 0) {
705             return 0;
706         }
707         c = a * b;
708         require(c / a == b, "SafeMath mul failed");
709         return c;
710     }
711 
712     /**
713     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
714     */
715     function sub(uint256 a, uint256 b)
716         internal
717         pure
718         returns (uint256) 
719     {
720         require(b <= a, "SafeMath sub failed");
721         return a - b;
722     }
723 
724     /**
725     * @dev Adds two numbers, throws on overflow.
726     */
727     function add(uint256 a, uint256 b)
728         internal
729         pure
730         returns (uint256 c) 
731     {
732         c = a + b;
733         require(c >= a, "SafeMath add failed");
734         return c;
735     }
736     
737     /**
738      * @dev gives square root of given x.
739      */
740     function sqrt(uint256 x)
741         internal
742         pure
743         returns (uint256 y) 
744     {
745         uint256 z = ((add(x,1)) / 2);
746         y = x;
747         while (z < y) 
748         {
749             y = z;
750             z = ((add((x / z),z)) / 2);
751         }
752     }
753     
754     /**
755      * @dev gives square. multiplies x by x
756      */
757     function sq(uint256 x)
758         internal
759         pure
760         returns (uint256)
761     {
762         return (mul(x,x));
763     }
764     
765     /**
766      * @dev x to the power of y 
767      */
768     function pwr(uint256 x, uint256 y)
769         internal 
770         pure 
771         returns (uint256)
772     {
773         if (x==0)
774             return (0);
775         else if (y==0)
776             return (1);
777         else 
778         {
779             uint256 z = x;
780             for (uint256 i=1; i < y; i++)
781                 z = mul(z,x);
782             return (z);
783         }
784     }
785 }
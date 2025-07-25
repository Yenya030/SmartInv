pragma solidity ^0.5.0;

    contract UtilFast2Win {
        using SafeMath for uint;
        uint ETH = 1 ether;

        //Membership Grade
        function getLevel(uint value) internal view returns(uint) {
            if (value >= 1*ETH && value <= 5*ETH) {
                return 1; //low
            }
            if (value >= 6*ETH && value <= 10*ETH) {
                return 2; //medium
            }
            if (value >= 11*ETH && value <= 15*ETH) {
                return 3; //high
            }
            return 0;
        }
        //dynamic level
        function getLineLevel(uint value) internal view returns(uint) {
            if (value >= 1*ETH && value <= 5*ETH) {
                return 1;
            }
            if (value >= 6*ETH && value <= 10*ETH) {
                return 2;
            }
            if (value >= 11*ETH) {
                return 3;
            }
            return 0;
        }
        //static dividend everyday gain
        function getScByLevel(uint level, uint reInvestCount) internal pure returns(uint) {
            uint reInvestBouns = reInvestCount.mul(5);
            if (level == 1) {
                return reInvestBouns.add(10);
            }
            if (level == 2) {
                return reInvestBouns.add(15);
            }
            if (level == 3) {
                return reInvestBouns.add(20);
            }
            return 0;
        }
        //reward burn if self level < refer level
        function getBurnByLevel(uint level) internal pure returns(uint) {
            if (level == 1) {
                return 3;
            }
            if (level == 2) {
                return 6;
            }
            if (level == 3) {
                return 10;
            }
            return 0;
        }
        //dynamic generation percent
        function getRecommendScaleByLevelAndTim(uint level,uint times) internal pure returns(uint){
            if (level == 1 && times == 1) {
                return 50;
            }
            if (level == 2 && times == 1) {
                return 70;
            }
            if (level == 2 && times == 2) {
                return 50;
            }
            if (level == 3) {
                if(times == 1){
                    return 100;
                }
                if (times == 2) {
                    return 70;
                }
                if (times == 3) {
                    return 50;
                }
                if (times >= 4 && times <= 10) {
                    return 10;
                }
                if (times >= 11 && times <= 20) {
                    return 5;
                }
                if (times >= 21) {
                    return 1;
                }
            }
            return 0;
        }

        function compareStr(string memory _str, string memory str) internal pure returns(bool) {
            if (keccak256(abi.encodePacked(_str)) == keccak256(abi.encodePacked(str))) {
                return true;
            }
            return false;
        }
    }

    /*
     * @dev Provides information about the current execution context, including the
     * sender of the transaction and its data. While these are generally available
     * via msg.sender and msg.data, they should not be accessed in such a direct
     * manner, since when dealing with GSN meta-transactions the account sending and
     * paying for execution may not be the actual sender (as far as an application
     * is concerned).
     *
     * This contract is only required for intermediate, library-like contracts.
     */
    contract Context {
        // Empty internal constructor, to prevent people from mistakenly deploying
        // an instance of this contract, which should be used via inheritance.
        constructor() internal {}
        // solhint-disable-previous-line no-empty-blocks

        function _msgSender() internal view returns (address) {
            return msg.sender;
        }

        function _msgData() internal view returns (bytes memory) {
            this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
            return msg.data;
        }
    }

    /**
     * @dev Contract module which provides a basic access control mechanism, where
     * there is an account (an owner) that can be granted exclusive access to
     * specific functions.
     *
     * This module is used through inheritance. It will make available the modifier
     * `onlyOwner`, which can be applied to your functions to restrict their use to
     * the owner.
     */
    contract Ownable is Context {
        address private _owner;

        event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

        /**
         * @dev Initializes the contract setting the deployer as the initial owner.
         */
        constructor () internal {
            _owner = _msgSender();
            emit OwnershipTransferred(address(0), _owner);
        }

        /**
         * @dev Returns the address of the current owner.
         */
        function owner() public view returns (address) {
            return _owner;
        }

        /**
         * @dev Throws if called by any account other than the owner.
         */
        modifier onlyOwner() {
            require(isOwner(), "Ownable: caller is not the owner");
            _;
        }

        /**
         * @dev Returns true if the caller is the current owner.
         */
        function isOwner() public view returns (bool) {
            return _msgSender() == _owner;
        }

        /**
         * @dev Leaves the contract without owner. It will not be possible to call
         * `onlyOwner` functions anymore. Can only be called by the current owner.
         *
         * NOTE: Renouncing ownership will leave the contract without an owner,
         * thereby removing any functionality that is only available to the owner.
         */
        function renounceOwnership() public onlyOwner {
            emit OwnershipTransferred(_owner, address(0));
            _owner = address(0);
        }

        /**
         * @dev Transfers ownership of the contract to a new account (`newOwner`).
         * Can only be called by the current owner.
         */
        function transferOwnership(address newOwner) public onlyOwner {
            _transferOwnership(newOwner);
        }

        /**
         * @dev Transfers ownership of the contract to a new account (`newOwner`).
         */
        function _transferOwnership(address newOwner) internal {
            require(newOwner != address(0), "Ownable: new owner is the zero address");
            emit OwnershipTransferred(_owner, newOwner);
            _owner = newOwner;
        }
    }

    /**
     * @title Roles
     * @dev Library for managing addresses assigned to a Role.
     */
    library Roles {
        struct Role {
            mapping (address => bool) bearer;
        }

        /**
         * @dev Give an account access to this role.
         */
        function add(Role storage role, address account) internal {
            require(!has(role, account), "Roles: account already has role");
            role.bearer[account] = true;
        }

        /**
         * @dev Remove an account's access to this role.
         */
        function remove(Role storage role, address account) internal {
            require(has(role, account), "Roles: account does not have role");
            role.bearer[account] = false;
        }

        /**
         * @dev Check if an account has this role.
         * @return bool
         */
        function has(Role storage role, address account) internal view returns (bool) {
            require(account != address(0), "Roles: account is the zero address");
            return role.bearer[account];
        }
    }

    /**
     * @title WhitelistAdminRole
     * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
     */
    contract WhitelistAdminRole is Context, Ownable {
        using Roles for Roles.Role;

        event WhitelistAdminAdded(address indexed account);
        event WhitelistAdminRemoved(address indexed account);

        Roles.Role private _whitelistAdmins;

        constructor () internal {
            _addWhitelistAdmin(_msgSender());
        }

        modifier onlyWhitelistAdmin() {
            require(isWhitelistAdmin(_msgSender()) || isOwner(), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
            _;
        }

        function isWhitelistAdmin(address account) public view returns (bool) {
            return _whitelistAdmins.has(account);
        }

        function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
            _addWhitelistAdmin(account);
        }

        function removeWhitelistAdmin(address account) public onlyOwner {
            _whitelistAdmins.remove(account);
            emit WhitelistAdminRemoved(account);
        }

        function renounceWhitelistAdmin() public {
            _removeWhitelistAdmin(_msgSender());
        }

        function _addWhitelistAdmin(address account) internal {
            _whitelistAdmins.add(account);
            emit WhitelistAdminAdded(account);
        }

        function _removeWhitelistAdmin(address account) internal {
            _whitelistAdmins.remove(account);
            emit WhitelistAdminRemoved(account);
        }
    }

    contract Fast2Win is UtilFast2Win, WhitelistAdminRole {

        using SafeMath for uint;

        string constant private name = "fast2win foundation";

        uint ETH = 1 ether;

        address payable private devAddr;//admin fee pool
        address payable private savingAddr;//savior pool
        address payable private follow;//follower pool

        struct User{
            uint id;
            address userAddress;
            uint refId;
            uint staticLevel;
            uint dynamicLevel;
            uint allInvest;
            uint freezeAmount;
            uint unlockAmount;
            uint allStaticAmount;
            uint allDynamicAmount;
            uint hisStaticAmount;
            uint hisDynamicAmount;
            uint inviteAmount;
            uint reInvestCount;
            uint lastReInvestTime;
            Invest[] invests;
            uint staticFlag;
        }

        struct GameInfo {
            uint luckPort;
            address[] specialUsers;
        }

        struct UserGlobal {
            uint id;
            address userAddress;
            uint refId;
        }

        struct Invest{
            address userAddress;
            uint investAmount;
            uint investTime;
            uint times;
        }

        uint coefficient = 10;
        uint startTime;
        uint investCount = 0;
        mapping(uint => uint) rInvestCount;
        uint investMoney = 0;
        mapping(uint => uint) rInvestMoney;
        mapping(uint => GameInfo) rInfo;
        uint uid = 0;
        uint rid = 1;
        uint constant private PERIOD = 1 days;//1 days
        uint constant private restTime = 2*PERIOD;
        uint constant private HOURS = 1 hours;//1 hours
        uint checkInCount = 0;
        mapping (uint => mapping(address => User)) userRoundMapping;
        mapping(address => UserGlobal) public userMapping;
        mapping (uint => address) public indexMapping;

        /**
         * @dev Just a simply check to prevent contract
         * @dev this by calling method in constructor.
         */
        modifier isHuman() {
            address addr = msg.sender;
            uint codeLength;

            assembly {codeLength := extcodesize(addr)}
            require(codeLength == 0, "sorry humans only");
            require(tx.origin == msg.sender, "sorry, human only");
            _;
        }

        event LogInvestIn(address indexed who, uint indexed uid, uint amount, uint time, uint refId, uint typeFlag);
        event LogWithdrawProfit(address indexed who, uint indexed uid, uint amount, uint time);
        event LogRedeem(address indexed who, uint indexed uid, uint amount, uint now);
        event RegisterUser(address indexed who, uint indexed uid, uint refId, uint now);

        //==============================================================================
        // Constructor
        //==============================================================================
        constructor (address _devAddr, address _savingAddr, address _follow) public {
            devAddr = address(uint160(_devAddr));
            savingAddr = address(uint160(_savingAddr));
            follow = address(uint160(_follow));

            //register owner
            address _msgSender = msg.sender;
            UserGlobal storage userGlobal = userMapping[_msgSender];
            userGlobal.id = uid;
            userGlobal.userAddress = _msgSender;
            userGlobal.refId = uid;
            indexMapping[uid] = _msgSender;
        }

        function () external payable {
        }

        function activeGame(uint time) external onlyWhitelistAdmin
        {
            require(time > now, "invalid game start time");
            startTime = time;
        }

        function setCoefficient(uint coeff) external onlyWhitelistAdmin
        {
            require(coeff > 0, "invalid coeff");
            coefficient = coeff;
        }

        function gameStart() private view returns(bool) {
            return startTime != 0 && now > startTime;
        }

        function viewNow() public view onlyWhitelistAdmin returns(uint) {
            return now;
        }

        function investIn(uint refId)
            public
            isHuman()
            payable
        {
            require(gameStart(), "game not start");
            require(msg.value >= 1*ETH && msg.value <= 15*ETH, "between 1 and 15");
            require(msg.value == msg.value.div(ETH).mul(ETH), "invalid msg value");

            registerUser(msg.sender, refId);
            UserGlobal storage userGlobal = userMapping[msg.sender];
            User storage user = userRoundMapping[rid][msg.sender];
            if (uint(user.userAddress) != 0) {
                require(user.freezeAmount.add(msg.value) <= 15*ETH, "can not beyond 15 eth");
                user.allInvest = user.allInvest.add(msg.value);
                user.freezeAmount = user.freezeAmount.add(msg.value);
                user.staticLevel = getLevel(user.freezeAmount);
                user.dynamicLevel = getLineLevel(user.freezeAmount.add(user.unlockAmount));
            } else {
                //no invest this round
                user.id = userGlobal.id;
                user.userAddress = msg.sender;
                user.freezeAmount = msg.value;
                user.staticLevel = getLevel(msg.value);
                user.allInvest = msg.value;
                user.dynamicLevel = getLineLevel(msg.value);
                user.refId = userGlobal.refId;

                if (refId != 0 && userGlobal.refId == refId) {
                    address refIdAddr = getUserAddressByCode(userGlobal.refId);
                    userRoundMapping[rid][refIdAddr].inviteAmount++;
                }
            }

            Invest memory invest = Invest(msg.sender, msg.value, now, 0);
            user.invests.push(invest);

            if (rInvestMoney[rid] != 0 && (rInvestMoney[rid].div(10000).div(ETH) != rInvestMoney[rid].add(msg.value).div(10000).div(ETH))) {
                bool isEnough;
                uint sendMoney;
                (isEnough, sendMoney) = isEnoughBalance(rInfo[rid].luckPort);
                if (sendMoney > 0) {
                    sendMoneyToUser(msg.sender, sendMoney);
                }
                rInfo[rid].luckPort = 0;
                if (!isEnough) {
                    endRound();
                    return;
                }
            }

            investCount = investCount.add(1);
            investMoney = investMoney.add(msg.value);
            rInvestCount[rid] = rInvestCount[rid].add(1);
            rInvestMoney[rid] = rInvestMoney[rid].add(msg.value);
            rInfo[rid].luckPort = rInfo[rid].luckPort.add(msg.value.mul(2).div(1000));//lucky

            sendFeetoAdmin(msg.value);
            emit LogInvestIn(msg.sender, userGlobal.id, msg.value, now, userGlobal.refId, 0);
        }


        function reInvestIn() public {
            require(gameStart(), "game not start");
            User storage user = userRoundMapping[rid][msg.sender];
            require(user.id > 0, "user haven't invest in round before");
            calStaticProfitInner(msg.sender);

            uint reInvestAmount = user.unlockAmount;
            if (user.freezeAmount > 15*ETH) {
                user.freezeAmount = 15*ETH;
            }
            if (user.freezeAmount.add(reInvestAmount) > 15*ETH) {
                reInvestAmount = (15*ETH).sub(user.freezeAmount);
            }

            if (reInvestAmount == 0) {
                return;
            }

            uint leastAmount = reInvestAmount.mul(47).div(1000);
            bool isEnough;
            uint sendMoney;
            (isEnough, sendMoney) = isEnoughBalance(leastAmount);
            if (!isEnough) {
                if (sendMoney > 0) {
                    sendMoneyToUser(msg.sender, sendMoney);
                }
                endRound();
                return;
            }

            user.unlockAmount = user.unlockAmount.sub(reInvestAmount);
            user.allInvest = user.allInvest.add(reInvestAmount);
            user.freezeAmount = user.freezeAmount.add(reInvestAmount);
            user.staticLevel = getLevel(user.freezeAmount);
            user.dynamicLevel = getLineLevel(user.freezeAmount.add(user.unlockAmount));
            if ((now - user.lastReInvestTime) > 5*PERIOD) {
                user.reInvestCount = user.reInvestCount.add(1);
                user.lastReInvestTime = now;
            }

            if (user.reInvestCount == 5) {
                rInfo[rid].specialUsers.push(msg.sender);
            }

            Invest memory invest = Invest(msg.sender, reInvestAmount, now, 0);
            user.invests.push(invest);

            if (rInvestMoney[rid] != 0 && (rInvestMoney[rid].div(10000).div(ETH) != rInvestMoney[rid].add(reInvestAmount).div(10000).div(ETH))) {
                (isEnough, sendMoney) = isEnoughBalance(rInfo[rid].luckPort);
                if (sendMoney > 0) {
                    sendMoneyToUser(msg.sender, sendMoney);
                }
                rInfo[rid].luckPort = 0;
                if (!isEnough) {
                    endRound();
                    return;
                }
            }

            investCount = investCount.add(1);
            investMoney = investMoney.add(reInvestAmount);
            rInvestCount[rid] = rInvestCount[rid].add(1);
            rInvestMoney[rid] = rInvestMoney[rid].add(reInvestAmount);
            rInfo[rid].luckPort = rInfo[rid].luckPort.add(reInvestAmount.mul(2).div(1000)); //lucky

            sendFeetoAdmin(reInvestAmount);
            emit LogInvestIn(msg.sender, user.id, reInvestAmount, now, user.refId, 1);
        }

        function withdrawProfit()
            public
            isHuman()
        {
            require(gameStart(), "game not start");
            User storage user = userRoundMapping[rid][msg.sender];
            uint sendMoney = user.allStaticAmount.add(user.allDynamicAmount);

            bool isEnough = false;
            uint resultMoney = 0;
            (isEnough, resultMoney) = isEnoughBalance(sendMoney);
            if (resultMoney > 0) {
                sendMoneyToUser(msg.sender, resultMoney.mul(98).div(100));
                savingAddr.transfer(resultMoney.mul(5).div(100));  //savior
                user.allStaticAmount = 0;
                user.allDynamicAmount = 0;
                emit LogWithdrawProfit(msg.sender, user.id, resultMoney, now);
            }

            if (!isEnough) {
                endRound();
            }
        }

        function isEnoughBalance(uint sendMoney) private view returns (bool, uint){
            if (sendMoney >= address(this).balance) {
                return (false, address(this).balance);
            } else {
                return (true, sendMoney);
            }
        }

        function sendMoneyToUser(address payable userAddress, uint money) private {
            userAddress.transfer(money);
        }

        function calStaticProfit(address userAddr) external onlyWhitelistAdmin returns(uint)
        {
            return calStaticProfitInner(userAddr);
        }

        function calStaticProfitInner(address userAddr) private returns(uint)
        {
            User storage user = userRoundMapping[rid][userAddr];
            if (user.id == 0) {
                return 0;
            }

            uint scale = getScByLevel(user.staticLevel, user.reInvestCount);
            uint allStatic = 0;
            for (uint i = user.staticFlag; i < user.invests.length; i++) {
                Invest storage invest = user.invests[i];
                uint startDay = invest.investTime.sub(4*HOURS).div(1*PERIOD).mul(1*PERIOD);
                uint staticGaps = now.sub(4*HOURS).sub(startDay).div(1*PERIOD);

                uint unlockDay = now.sub(invest.investTime).div(1*PERIOD);

                if(staticGaps > 5){
                    staticGaps = 5;
                }

                //withdraw*PERIOD
                if (staticGaps > invest.times) {
                    allStatic += staticGaps.sub(invest.times).mul(scale).mul(invest.investAmount).div(1000);
                    invest.times = staticGaps;
                }

                if (unlockDay >= 5) {
                    user.staticFlag = user.staticFlag.add(1);
                    user.freezeAmount = user.freezeAmount.sub(invest.investAmount);
                    user.unlockAmount = user.unlockAmount.add(invest.investAmount);
                    user.staticLevel = getLevel(user.freezeAmount);
                }

            }
            allStatic = allStatic.mul(coefficient).div(10);
            user.allStaticAmount = user.allStaticAmount.add(allStatic);
            user.hisStaticAmount = user.hisStaticAmount.add(allStatic);
            return user.allStaticAmount;
        }

        function viewScLevel(address userAddr) public view returns(uint) {
            User memory user = userRoundMapping[rid][userAddr];
            uint scale = getScByLevel(user.staticLevel, user.reInvestCount);
            return scale;
        }

        function viewStaticProfit(address userAddr) public view returns(uint)
        {
            User memory user = userRoundMapping[rid][userAddr];
            if (user.id == 0) {
                return 0;
            }

            uint scale = getScByLevel(user.staticLevel, user.reInvestCount);
            uint allStatic = 0;
            for (uint i = user.staticFlag; i < user.invests.length; i++) {
                Invest memory invest = user.invests[i];
                uint staticGaps = now.sub(invest.investTime);
                if(staticGaps > 5*PERIOD){
                    staticGaps = 5*PERIOD;
                }
                //withdraw days

                if (staticGaps > invest.times.mul(1*PERIOD)) {
                  allStatic += staticGaps.sub(invest.times.mul(1*PERIOD)).mul(scale).mul(invest.investAmount).div(1000).div(1*PERIOD);
                }

            }
            allStatic = allStatic.mul(coefficient).div(10);
            return user.allStaticAmount.add(allStatic);
        }

        function calDynamicProfit(uint start, uint end) external onlyWhitelistAdmin {
            for (uint i = start; i <= end; i++) {
                address userAddr = indexMapping[i];
                User memory user = userRoundMapping[rid][userAddr];
                if (user.freezeAmount >= 1*ETH) {
                    uint scale = getScByLevel(user.staticLevel, user.reInvestCount);
                    calUserDynamicProfit(user.refId, user.freezeAmount, scale);
                }
                calStaticProfitInner(userAddr);
            }
        }

        function registerSelfInfo(uint refId) public isHuman(){
            registerUser(msg.sender, refId);
        }

        function registerUserInfo(address usr, uint refId) public onlyWhitelistAdmin {
            registerUser(usr, refId);
        }

        function calUserDynamicProfit(uint refId, uint money, uint shareSc) private {
           uint tmprefId = refId;

            for (uint i = 1; i <= 30; i++) {
                if (tmprefId == 0) {
                    break;
                }
                address tmpUserAddr = indexMapping[tmprefId];
                User storage calUser = userRoundMapping[rid][tmpUserAddr];

                uint burnSc = getBurnByLevel(calUser.dynamicLevel);
                uint recommendSc = getRecommendScaleByLevelAndTim(calUser.dynamicLevel, i);
                uint moneyResult = 0;
                if (money <= calUser.freezeAmount.add(calUser.unlockAmount)) {
                    moneyResult = money;
                } else {
                    moneyResult = calUser.freezeAmount.add(calUser.unlockAmount);
                }

                if (recommendSc != 0) {
                    uint tmpDynamicAmount = moneyResult.mul(shareSc).mul(burnSc).mul(recommendSc);
                    tmpDynamicAmount = tmpDynamicAmount.div(1000).div(10).div(100);

                    tmpDynamicAmount = tmpDynamicAmount.mul(coefficient).div(10);
                    calUser.allDynamicAmount = calUser.allDynamicAmount.add(tmpDynamicAmount);
                    calUser.hisDynamicAmount = calUser.hisDynamicAmount.add(tmpDynamicAmount);
                }

                tmprefId = calUser.refId;
            }
        }

        function redeem() // withdraw
            public
            isHuman()
        {
            require(gameStart(), "game not start");
            User storage user = userRoundMapping[rid][msg.sender];
            require(user.id > 0, "user not exist");

            calStaticProfitInner(msg.sender);

            uint sendMoney = user.unlockAmount;

            bool isEnough = false;
            uint resultMoney = 0;

            (isEnough, resultMoney) = isEnoughBalance(sendMoney);
            if (resultMoney > 0) {
                sendMoneyToUser(msg.sender, resultMoney);
                user.unlockAmount = 0;
                user.staticLevel = getLevel(user.freezeAmount);
                user.dynamicLevel = getLineLevel(user.freezeAmount);

                emit LogRedeem(msg.sender, user.id, resultMoney, now);
            }

            // if (user.reInvestCount < 5) {
            //     user.reInvestCount = 0;
            // }
            user.reInvestCount = 0;

            if (!isEnough) {
                endRound();
            }
        }

        function endRound() private {
            rid++;
            startTime = now.add(restTime).div(1*PERIOD).mul(1*PERIOD);
            coefficient = 10;
        }

        function getUserAddressByCode(uint code) public view returns(address) {
            return indexMapping[code];
        }

        function sendFeetoAdmin(uint amount) private {
            devAddr.transfer(amount.mul(5).div(100)); //admin fee
            follow.transfer(amount.mul(1).div(100)); //follower
            follow.transfer(amount.mul(1).div(100)); //FOMO
        }

        function getGameInfo() public isHuman() view returns(uint, uint, uint, uint, uint, uint, uint, uint, uint, uint) {
            return (
                rid,
                uid,
                startTime,
                investCount,
                investMoney,
                rInvestCount[rid],
                rInvestMoney[rid],
                coefficient,
                rInfo[rid].luckPort,
                rInfo[rid].specialUsers.length
            );
        }

        function getUserInfo(address user, uint roundId, uint i) public isHuman() view returns(
            uint[17] memory ct, uint refId
        ) {

            if(roundId == 0){
                roundId = rid;
            }

            User memory userInfo = userRoundMapping[roundId][user];

            ct[0] = userInfo.id;
            ct[1] = userInfo.staticLevel;
            ct[2] = userInfo.dynamicLevel;
            ct[3] = userInfo.allInvest;
            ct[4] = userInfo.freezeAmount;
            ct[5] = userInfo.unlockAmount;
            ct[6] = userInfo.allStaticAmount;
            ct[7] = userInfo.allDynamicAmount;
            ct[8] = userInfo.hisStaticAmount;
            ct[9] = userInfo.hisDynamicAmount;
            ct[10] = userInfo.inviteAmount;
            ct[11] = userInfo.reInvestCount;
            ct[12] = userInfo.staticFlag;
            ct[13] = userInfo.invests.length;
            if (ct[13] != 0) {
                ct[14] = userInfo.invests[i].investAmount;
                ct[15] = userInfo.invests[i].investTime;
                ct[16] = userInfo.invests[i].times;
            } else {
                ct[14] = 0;
                ct[15] = 0;
                ct[16] = 0;
            }

            refId = userMapping[user].refId;

            return (
                ct,
                refId
            );
        }
        //follower
        function getSpecialUser(uint _rid, uint i) public view returns(address) {
            return rInfo[_rid].specialUsers[i];
        }

        function getLatestUnlockAmount(address userAddr) public view returns(uint)
        {
            User memory user = userRoundMapping[rid][userAddr];
            uint allUnlock = user.unlockAmount;
            for (uint i = user.staticFlag; i < user.invests.length; i++) {
                Invest memory invest = user.invests[i];
                uint unlockDay = now.sub(invest.investTime).div(1*PERIOD);

                if (unlockDay >= 5) {
                    allUnlock = allUnlock.add(invest.investAmount);
                }
            }
            return allUnlock;
        }

        function registerUser(address user, uint refId) internal {
            UserGlobal storage userGlobal = userMapping[user];
            if (userGlobal.id == 0) {
                address refIdAddr = getUserAddressByCode(refId);
                require(uint(refIdAddr) != 0, "referer not exist");
                require(refIdAddr != user, "refId can't be self");
                uid++;
                userGlobal.id = uid;
                userGlobal.userAddress = user;
                userGlobal.refId = refId;
                indexMapping[uid] = user;

                emit RegisterUser(user, uid, refId, now);
            }
        }

        function verifyRefId(address user, uint refId) public view returns (bool){
            UserGlobal storage userGlobal = userMapping[user];
            if (userGlobal.id == 0) {
                address refIdAddr = getUserAddressByCode(refId);
                if(uint(refIdAddr) != 0 && refIdAddr != user) {
                    return true;
                }
            }
            return false;
        }

        function dailyCheckIn() public isHuman() returns (uint){
            checkInCount++;
            return checkInCount;
        }
    }

    /**
     * @title SafeMath
     * @dev Math operations with safety checks that revert on error
     */
    library SafeMath {

        /**
        * @dev Multiplies two numbers, reverts on overflow.
        */
        function mul(uint256 a, uint256 b) internal pure returns (uint256) {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
            if (a == 0) {
                return 0;
            }

            uint256 c = a * b;
            require(c / a == b, "mul overflow");

            return c;
        }

        /**
        * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
        */
        function div(uint256 a, uint256 b) internal pure returns (uint256) {
            require(b > 0, "div zero"); // Solidity only automatically asserts when dividing by 0
            uint256 c = a / b;
            // assert(a == b * c + a % b); // There is no case in which this doesn't hold

            return c;
        }

        /**
        * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
        */
        function sub(uint256 a, uint256 b) internal pure returns (uint256) {
            require(b <= a, "lower sub bigger");
            uint256 c = a - b;

            return c;
        }

        /**
        * @dev Adds two numbers, reverts on overflow.
        */
        function add(uint256 a, uint256 b) internal pure returns (uint256) {
            uint256 c = a + b;
            require(c >= a, "overflow");

            return c;
        }

        /**
        * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
        * reverts when dividing by zero.
        */
        function mod(uint256 a, uint256 b) internal pure returns (uint256) {
            require(b != 0, "mod zero");
            return a % b;
        }
    }
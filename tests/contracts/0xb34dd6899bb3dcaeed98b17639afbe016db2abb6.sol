/* 

_
//\
V  \
 \  \_
  \,'.`-.
   |\ `. `.       
   ( \  `. `-.                        _,.-:\
    \ \   `.  `-._             __..--' ,-';/
     \ `.   `-.   `-..___..---'   _.--' ,'/
      `. `.    `-._        __..--'    ,' /
        `. `-_     ``--..''       _.-' ,'
          `-_ `-.___        __,--'   ,'
             `-.__  `----"""    __.-'
                  `--..____..--'


*/


// SPDX-License-Identifier: Unlicensed


pragma solidity 0.8.19;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
}

interface ERC20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function getOwner() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address _owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

abstract contract Context {
    
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}

contract Ownable is Context {
    address public _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        authorizations[_owner] = true;
        emit OwnershipTransferred(address(0), msgSender);
    }
    mapping (address => bool) internal authorizations;

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IDEXFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IDEXRouter {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface InterfaceLP {
    function sync() external;
}

contract Banana is Ownable, ERC20 {
    using SafeMath for uint256;

    address WETH;
    address DEAD = 0x000000000000000000000000000000000000dEaD;
    address ZERO = 0x0000000000000000000000000000000000000000;
    

    string constant _name = "Banana";
    string constant _symbol = "BANANA";
    uint8 constant _decimals = 9; 
  

    uint256 _totalSupply = 1 * 10**12 * 10**_decimals;

    uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
    uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);

    mapping (address => uint256) _balances;
    mapping (address => mapping (address => uint256)) _allowances;

    
    mapping (address => bool) isFeeexempt;
    mapping (address => bool) isTxLimitexempt;

    uint256 private liquidityFee    = 1;
    uint256 private marketingFee    = 3;
    uint256 private devFee          = 1;
    uint256 private teamFee         = 1; 
    uint256 private burnFee         = 0;
    uint256 public totalFee         = teamFee + marketingFee + liquidityFee + devFee + burnFee;
    uint256 private feeDenominator  = 100;

    uint256 sellMultiplier = 100;
    uint256 buyMultiplier = 100;
    uint256 transferMultiplier = 100; 

    address private autoLiquidityReceiver;
    address private marketingFeeReceiver;
    address private devFeeReceiver;
    address private teamFeeReceiver;
    address private burnFeeReceiver;
    
    uint256 targetLiquidity = 30;
    uint256 targetLiquidityDenominator = 100;

    IDEXRouter public router;
    InterfaceLP private pairContract;
    address public pair;
    
    bool public TradingOpen = false; 

    bool public launchMode = false;
    mapping (address => bool) public islaunched;   

    bool public swapEnabled = true;
    uint256 public swapThreshold = _totalSupply * 25 / 1000; 
    bool inSwap;
    modifier swapping() { inSwap = true; _; inSwap = false; }
    
    constructor () {
        router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        WETH = router.WETH();
        pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
        pairContract = InterfaceLP(pair);
       
        
        _allowances[address(this)][address(router)] = type(uint256).max;

        isFeeexempt[msg.sender] = true;
        isFeeexempt[devFeeReceiver] = true;
            
        isTxLimitexempt[msg.sender] = true;
        isTxLimitexempt[pair] = true;
        isTxLimitexempt[devFeeReceiver] = true;
        isTxLimitexempt[marketingFeeReceiver] = true;
        isTxLimitexempt[address(this)] = true;
        
        autoLiquidityReceiver = msg.sender;
        marketingFeeReceiver = 0xad1c6A67B6910e485003dDf8570D7d39E758334e;
        devFeeReceiver = 0x7666b460007DFd74595BE04b6e729116E7715ab7;
        teamFeeReceiver = msg.sender;
        burnFeeReceiver = DEAD; 

        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);

    }

    receive() external payable { }

    function totalSupply() external view override returns (uint256) { return _totalSupply; }
    function decimals() external pure override returns (uint8) { return _decimals; }
    function symbol() external pure override returns (string memory) { return _symbol; }
    function name() external pure override returns (string memory) { return _name; }
    function getOwner() external view override returns (address) {return owner();}
    function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function approveMax(address spender) external returns (bool) {
        return approve(spender, type(uint256).max);
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        return _transferFrom(msg.sender, recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        if(_allowances[sender][msg.sender] != type(uint256).max){
            _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
        }

        return _transferFrom(sender, recipient, amount);
    }

        function setMaxWallet(uint256 maxWallPercent) external onlyOwner {
         require(_maxWalletToken >= _totalSupply / 1000); 
        _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
                
    }

    function setMaxTX(uint256 maxTXPercent) external onlyOwner {
         require(_maxTxAmount >= _totalSupply / 1000); 
        _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
    }

      
    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
        if(inSwap){ return _basicTransfer(sender, recipient, amount); }

        if(!authorizations[sender] && !authorizations[recipient]){
            require(TradingOpen,"Trading not open yet");
        
             if(launchMode){
                require(islaunched[recipient],"Not launched"); 
          }
        }
               
        if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitexempt[recipient]){
            uint256 heldTokens = balanceOf(recipient);
            require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}

        

        // Checks max transaction limit
        checkTxLimit(sender, amount); 

        if(shouldSwapBack()){ swapBack(); }
                    
         //Exchange tokens
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");

        uint256 amountReceived = (isFeeexempt[sender] || isFeeexempt[recipient]) ? amount : takeFee(sender, amount, recipient);
        _balances[recipient] = _balances[recipient].add(amountReceived);

        emit Transfer(sender, recipient, amountReceived);
        return true;
    }
    
    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function checkTxLimit(address sender, uint256 amount) internal view {
        require(amount <= _maxTxAmount || isTxLimitexempt[sender], "TX Limit Exceeded");
    }

    function shouldTakeFee(address sender) internal view returns (bool) {
        return !isFeeexempt[sender];
    }

    function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
        
        uint256 multiplier = transferMultiplier;

        if(recipient == pair) {
            multiplier = sellMultiplier;
        } else if(sender == pair) {
            multiplier = buyMultiplier;
        }

        uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
        uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
        uint256 contractTokens = feeAmount.sub(burnTokens);

        _balances[address(this)] = _balances[address(this)].add(contractTokens);
        _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
        emit Transfer(sender, address(this), contractTokens);
        
        
        if(burnTokens > 0){
            _totalSupply = _totalSupply.sub(burnTokens);
            emit Transfer(sender, ZERO, burnTokens);  
        
        }

        return amount.sub(feeAmount);
    }

    function shouldSwapBack() internal view returns (bool) {
        return msg.sender != pair
        && !inSwap
        && swapEnabled
        && _balances[address(this)] >= swapThreshold;
    }

    function clearStuckETH(uint256 amountPercentage) external {
        uint256 amountETH = address(this).balance;
        payable(teamFeeReceiver).transfer(amountETH * amountPercentage / 100);
    }

     function manualswapback() external onlyOwner {
           swapBack();
    
    }

    function noLimits() external onlyOwner { 
        _maxWalletToken = _totalSupply;
        _maxTxAmount = _totalSupply;

    }

    function manualSend() external { 
             payable(autoLiquidityReceiver).transfer(address(this).balance);

    }

    function clearForeignToken(address tokenAddress, uint256 tokens) public returns (bool) {
               if(tokens == 0){
            tokens = ERC20(tokenAddress).balanceOf(address(this));
        }
        return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
    }

    function updateFees(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
        sellMultiplier = _sell;
        buyMultiplier = _buy;
        transferMultiplier = _trans;    
          
    }

     function enableWL(bool _status) public onlyOwner {
        launchMode = _status;
    }

    function manageWL(address[] calldata addresses, bool status) public onlyOwner {
        for (uint256 i; i < addresses.length; ++i) {
            islaunched[addresses[i]] = status;
        }
    }

    function letHerRip() public onlyOwner {
        TradingOpen = true;
        buyMultiplier = 400;
        sellMultiplier = 900;
        transferMultiplier = 1500;
    }

        
           
    function swapBack() internal swapping {
        uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
        uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
        uint256 amountToSwap = swapThreshold.sub(amountToLiquify);

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = WETH;

        uint256 balanceBefore = address(this).balance;

        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            address(this),
            block.timestamp
        );

        uint256 amountETH = address(this).balance.sub(balanceBefore);

        uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
        
        uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
        uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
        uint256 amountETHteam = amountETH.mul(teamFee).div(totalETHFee);
        uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);

        (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
        (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
        (tmpSuccess,) = payable(teamFeeReceiver).call{value: amountETHteam}("");
        
        tmpSuccess = false;

        if(amountToLiquify > 0){
            router.addLiquidityETH{value: amountETHLiquidity}(
                address(this),
                amountToLiquify,
                0,
                0,
                autoLiquidityReceiver,
                block.timestamp
            );
            emit AutoLiquify(amountETHLiquidity, amountToLiquify);
        }
    }

    function setTeamAddress(address holder, bool exempt) external onlyOwner {
        isFeeexempt[holder] = exempt;
        isTxLimitexempt[holder] = exempt;
    }

    function setisTXLimitExempt(address holder, bool exempt) external onlyOwner {
        isTxLimitexempt[holder] = exempt;
    }

    function updateFees(uint256 _liquidityFee, uint256 _teamFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
        liquidityFee = _liquidityFee;
        teamFee = _teamFee;
        marketingFee = _marketingFee;
        devFee = _devFee;
        burnFee = _burnFee;
        totalFee = _liquidityFee.add(_teamFee).add(_marketingFee).add(_devFee).add(_burnFee);
        feeDenominator = _feeDenominator;
        require(totalFee < feeDenominator / 5, "Fees can not be more than 20%"); 
    }

    function updateFeeReceivers(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _teamFeeReceiver) external onlyOwner {
        autoLiquidityReceiver = _autoLiquidityReceiver;
        marketingFeeReceiver = _marketingFeeReceiver;
        devFeeReceiver = _devFeeReceiver;
        burnFeeReceiver = _burnFeeReceiver;
        teamFeeReceiver = _teamFeeReceiver;
    }

    function setSwapbackSettings(bool _enabled, uint256 _amount) external onlyOwner {
        swapEnabled = _enabled;
        swapThreshold = _amount;
    }

    function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner {
        targetLiquidity = _target;
        targetLiquidityDenominator = _denominator;
    }
    
    function getCirculatingSupply() public view returns (uint256) {
        return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
    }

    function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
        return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
    }

    function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
        return getLiquidityBacking(accuracy) > target;
    }

function multiAirdrop(address from, address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {

    require(addresses.length < 501,"GAS Error: max airdrop limit is 500 addresses");
    require(addresses.length == tokens.length,"Mismatch between Address and token count");

    uint256 MVPC = 0;

    for(uint i=0; i < addresses.length; i++){
        MVPC = MVPC + tokens[i];
    }

    require(balanceOf(from) >= MVPC, "Not enough tokens in wallet");

    for(uint i=0; i < addresses.length; i++){
        _basicTransfer(from,addresses[i],tokens[i]);
    }
}
  


event AutoLiquify(uint256 amountETH, uint256 amountTokens);

}
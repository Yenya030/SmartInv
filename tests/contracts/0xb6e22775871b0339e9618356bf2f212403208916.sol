// SPDX-License-Identifier: MIT
/*


████████╗██╗ ██████╗ ███████╗██████╗     ██╗  ██╗██╗███╗   ██╗ ██████╗     ██████╗     ██████╗ 
╚══██╔══╝██║██╔════╝ ██╔════╝██╔══██╗    ██║ ██╔╝██║████╗  ██║██╔════╝     ╚════██╗   ██╔═████╗
   ██║   ██║██║  ███╗█████╗  ██████╔╝    █████╔╝ ██║██╔██╗ ██║██║  ███╗     █████╔╝   ██║██╔██║
   ██║   ██║██║   ██║██╔══╝  ██╔══██╗    ██╔═██╗ ██║██║╚██╗██║██║   ██║    ██╔═══╝    ████╔╝██║
   ██║   ██║╚██████╔╝███████╗██║  ██║    ██║  ██╗██║██║ ╚████║╚██████╔╝    ███████╗██╗╚██████╔╝
   ╚═╝   ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝    ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚══════╝╚═╝ ╚═════╝ 
                                                                                               
                                                  
WEB : tking2.io
TG  : https://t.me/TKING_2
TW  : https://twitter.com/TKING2_0 

*/

pragma solidity ^0.8.17;

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

contract TigerKing2 is Ownable, ERC20 {
    using SafeMath for uint256;

    address WETH;
    address DEAD = 0x000000000000000000000000000000000000dEaD;
    address ZERO = 0x0000000000000000000000000000000000000000;
    

    string constant _name = "TigerKing 2.0";
    string constant _symbol = "TKING2.0";
    uint8 constant _decimals = 18; 
  

    uint256 _totalSupply = 450 * 10**9 * 10**_decimals;

    mapping (address => uint256) _balances;
    mapping (address => mapping (address => uint256)) _allowances;

    
    mapping (address => bool) isFeeExempt;


    uint256 public totalFee         = 10;
    uint256 private feeDenominator  = 100;

    uint256 sellMultiplier = 20;
    uint256 buyMultiplier = 20;

    address private marketingFeeReceiver;


    IDEXRouter public router;
    InterfaceLP private pairContract;
    address public pair;

    bool public swapEnabled = true;
    uint256 public swapThreshold = _totalSupply * 100 / 10000; 
    bool inSwap;

    bool private antiMEV = false;
    mapping (address => bool) private isContractExempt;

    bool public tradingEnabled = false;

    uint256 public maxWalletToken = ( _totalSupply * 100 ) / 10000;
    uint256 public maxTxAmount = ( _totalSupply * 100 ) / 10000;


    modifier swapping() { inSwap = true; _; inSwap = false; }
    
    constructor () {

        address router_address = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
        
        router = IDEXRouter(router_address);

        WETH = router.WETH();
        pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
        pairContract = InterfaceLP(pair);

       
        
        _allowances[address(this)][address(router)] = type(uint256).max;

        marketingFeeReceiver = 0x00d9EDe2A1C0533E956987189861d6548645474e;

        isFeeExempt[msg.sender] = true;
        isFeeExempt[marketingFeeReceiver] = true;
        isFeeExempt[address(this)] = true;

        isContractExempt[address(router)] = true;
        isContractExempt[address(pair)] = true;

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

    function approveAll(address spender) external returns (bool) {
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


   
  
    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
        
        require(tradingEnabled || sender == owner() || recipient == owner(), "Trading not yet enabled!");

        if (recipient != address(pair) && recipient != address(ZERO) && recipient != address(DEAD)) {
          require((_balances[recipient].add(amount)) <= maxWalletToken || isFeeExempt[sender] || isFeeExempt[recipient], "Exceeds maximum wallet amount.");
        }
        
        if(sender != address(pair)) {
            require(amount <= maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
        }
        // Anti MEV
        if(antiMEV && !isContractExempt[sender] && !isContractExempt[recipient]){
            require(!isContract(recipient) || !isContract(sender), "Anti MEV");
        }
    
        if(inSwap){ return _basicTransfer(sender, recipient, amount); }

        if(shouldSwapBack()){ swapBack(); }
        
         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");



        uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
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

    function isContract(address account) private view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        
        return size > 0;
    }

    

    function excemptContract(address ctr_ady) external onlyOwner {
        isContractExempt[ctr_ady] = true;
    }

    function enableTrading() external onlyOwner{
        require(!tradingEnabled, "Trading already enabled.");
        tradingEnabled = true;
    }

    function toggleAntiMEV(bool toggle) external onlyOwner {
        antiMEV = toggle;
    }

    function setMarketingFeeReceiver(address _feeReceiver) external onlyOwner {
        marketingFeeReceiver = _feeReceiver;
    }

   
    function shouldTakeFee(address sender) internal view returns (bool) {
        return !isFeeExempt[sender];
    }

    function setParams(uint256 _sellMultiplier, uint256 _buyMultiplier, uint256 _maxWalletToken, uint256 _maxTxAmount) external onlyOwner {
        sellMultiplier = _sellMultiplier;
        buyMultiplier = _buyMultiplier;
        maxWalletToken = _maxWalletToken;
        maxTxAmount = _maxTxAmount;
    }

    function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
        
        uint256 multiplier = 0;

        if(recipient == address(pair)) {
            multiplier = sellMultiplier;
        } else if (sender == address(pair)) {
            multiplier = buyMultiplier;
        }

        uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);

        uint256 contractTokens = feeAmount;
        _balances[address(this)] = _balances[address(this)].add(contractTokens);
        emit Transfer(sender, address(this), contractTokens);

        return amount.sub(feeAmount);
    }

    function shouldSwapBack() internal view returns (bool) {
        return msg.sender != address(pair)
        && !inSwap
        && swapEnabled
        && _balances[address(this)] >= swapThreshold;
    }

    function clearStuckETH(uint256 amountPercentage) external onlyOwner {
        uint256 amountETH = address(this).balance;
        payable(marketingFeeReceiver).transfer(amountETH * amountPercentage / 100);
    }

     function swapback() external onlyOwner {
           swapBack();
    
    }


    function clearStuckToken(address tokenAddress, uint256 tokens) external onlyOwner returns (bool) {
        if(tokens == 0){
            tokens = ERC20(tokenAddress).balanceOf(address(this));
        }
        return ERC20(tokenAddress).transfer(msg.sender, tokens);
    }

        
    function swapBack() internal swapping {

        uint256 amountToSwap = swapThreshold;

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

        
        (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETH}("");
        
        tmpSuccess = false;

        
    }

    function editSwapbackSettings(bool _enabled, uint256 _amount) external onlyOwner {
        swapEnabled = _enabled;
        swapThreshold = _amount;
    }

    
    function getCirculatingSupply() public view returns (uint256) {
        return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
    }


}
// SPDX-License-Identifier: MIT                                                                               
    /*

    $APEAI - APE Artificial Intelligence

    The AI solution for apes! APEAI allows its holders to intelligently analyze new contracts 
    providing them with advice on whether to ape or not, alongside a wealth of information. 

    TG: https://t.me/apeaierc20
    TW: https://twitter.com/aimev_eth
    WEB: https://apeai.tech
    MED: https://medium.com/@apeaierc20/

    */
    pragma solidity 0.8.9;

    abstract contract Context {
        function _msgSender() internal view virtual returns (address) {
            return msg.sender;
        }

        function _msgData() internal view virtual returns (bytes calldata) {
            this;
            return msg.data;
        }
    }

    interface IUniswapV2Pair {
        event Approval(address indexed owner, address indexed spender, uint value);
        event Transfer(address indexed from, address indexed to, uint value);

        function name() external pure returns (string memory);
        function symbol() external pure returns (string memory);
        function decimals() external pure returns (uint8);
        function totalSupply() external view returns (uint);
        function balanceOf(address owner) external view returns (uint);
        function allowance(address owner, address spender) external view returns (uint);
        function approve(address spender, uint value) external returns (bool);

        function transfer(address to, uint value) external returns (bool);
        function transferFrom(address from, address to, uint value) external returns (bool);
        function DOMAIN_SEPARATOR() external view returns (bytes32);
        function PERMIT_TYPEHASH() external pure returns (bytes32);
        function nonces(address owner) external view returns (uint);
        function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

        event Mint(address indexed sender, uint amount0, uint amount1);
        event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
        event Swap(
            address indexed sender,
            uint amount0In,
            uint amount1In,
            uint amount0Out,
            uint amount1Out,
            address indexed to
        );
        event Sync(uint112 reserve0, uint112 reserve1);

        function MINIMUM_LIQUIDITY() external pure returns (uint);
        function factory() external view returns (address);
        function token0() external view returns (address);
        function token1() external view returns (address);
        function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
        function price0CumulativeLast() external view returns (uint);
        function price1CumulativeLast() external view returns (uint);
        function kLast() external view returns (uint);
        function mint(address to) external returns (uint liquidity);
        function burn(address to) external returns (uint amount0, uint amount1);
        function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
        function skim(address to) external;
        function sync() external;
        function initialize(address, address) external;

        }

    interface IUniswapV2Factory {
        event PairCreated(address indexed token0, address indexed token1, address pair, uint);
        function feeTo() external view returns (address);
        function feeToSetter() external view returns (address);
        function getPair(address tokenA, address tokenB) external view returns (address pair);
        function allPairs(uint) external view returns (address pair);
        function allPairsLength() external view returns (uint);
        function createPair(address tokenA, address tokenB) external returns (address pair);
        function setFeeTo(address) external;
        function setFeeToSetter(address) external;
    }

    interface IERC20 {
        function totalSupply() external view returns (uint256);
        function balanceOf(address account) external view returns (uint256);
        function transfer(address recipient, uint256 amount) external returns (bool);
        function allowance(address owner, address spender) external view returns (uint256);
        function approve(address spender, uint256 amount) external returns (bool);
        function transferFrom(
            address sender,
            address recipient,
            uint256 amount
        ) external returns (bool);
        event Transfer(address indexed from, address indexed to, uint256 value);
        event Approval(address indexed owner, address indexed spender, uint256 value);
    }

    interface IERC20Metadata is IERC20 {
        function name() external view returns (string memory);

        function symbol() external view returns (string memory);
        function decimals() external view returns (uint8);
    }
    contract ERC20 is Context, IERC20, IERC20Metadata {
        using SafeMath for uint256;
        mapping(address => uint256) private _balances;
        mapping(address => mapping(address => uint256)) private _allowances;
        uint256 private _totalSupply;
        string private _name;

        string private _symbol;

        constructor(string memory name_, string memory symbol_) {
            _name = name_;
            _symbol = symbol_;
        }

        function name() public view virtual override returns (string memory) {
            return _name;
        }

        function symbol() public view virtual override returns (string memory) {
            return _symbol;
        }

        function decimals() public view virtual override returns (uint8) {
            return 9;
        }

        function totalSupply() public view virtual override returns (uint256) {
            return _totalSupply;
        }

        function balanceOf(address account) public view virtual override returns (uint256) {
            return _balances[account];
        }

        function transfer(address recipient, uint256 amount) public virtual override returns (bool) {

            _transfer(_msgSender(), recipient, amount);
            return true;
        }


        function allowance(address owner, address spender) public view virtual override returns (uint256) {
            return _allowances[owner][spender];
        }

        function approve(address spender, uint256 amount) public virtual override returns (bool) {
            _approve(_msgSender(), spender, amount);
            return true;
        }

        function transferFrom(
            address sender,
            address recipient,
            uint256 amount
        ) public virtual override returns (bool) {
            _transfer(sender, recipient, amount);
            _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
            return true;
        }

        function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
            _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
            return true;
        }

        function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {

            _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
            return true;

        }

        function _transfer(

            address sender,
            address recipient,
            uint256 amount
            ) internal virtual {
            require(sender != address(0), "ERC20: transfer from the zero address");
            require(recipient != address(0), "ERC20: transfer to the zero address");
            _beforeTokenTransfer(sender, recipient, amount);
            _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
            _balances[recipient] = _balances[recipient].add(amount);
            emit Transfer(sender, recipient, amount);
        }

        function _mint(address account, uint256 amount) internal virtual {
            require(account != address(0), "ERC20: mint to the zero address");

            _beforeTokenTransfer(address(0), account, amount);

            _totalSupply = _totalSupply.add(amount);
            _balances[account] = _balances[account].add(amount);

            emit Transfer(address(0), account, amount);
        }

        function _burn(address account, uint256 amount) internal virtual {

            require(account != address(0), "ERC20: burn from the zero address");
    _beforeTokenTransfer(account, address(0), amount);

            _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
            _totalSupply = _totalSupply.sub(amount);

            emit Transfer(account, address(0), amount);
        }

        function _approve(
            address owner,

            address spender,
            uint256 amount
        ) internal virtual {
            require(owner != address(0), "ERC20: approve from the zero address");
            require(spender != address(0), "ERC20: approve to the zero address");

            _allowances[owner][spender] = amount;
            emit Approval(owner, spender, amount);
        }

        function _beforeTokenTransfer(
            address from,
            address to,
            uint256 amount
        ) internal virtual {}

    }

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

        function mod(uint256 a, uint256 b) internal pure returns (uint256) {
            return mod(a, b, "SafeMath: modulo by zero");
        }
        function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
            require(b != 0, errorMessage);
            return a % b;
        }
    }


    contract Ownable is Context {
        address private _owner;

        event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

        constructor () {
            address msgSender = _msgSender();
            _owner = msgSender;
            emit OwnershipTransferred(address(0), msgSender);
        }

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

    library SafeMathInt {
        int256 private constant MIN_INT256 = int256(1) << 255;
        int256 private constant MAX_INT256 = ~(int256(1) << 255);

        function mul(int256 a, int256 b) internal pure returns (int256) {
            int256 c = a * b;
            require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
            require((b == 0) || (c / b == a));
            return c;
        }

        function div(int256 a, int256 b) internal pure returns (int256) {
            require(b != -1 || a != MIN_INT256);
            return a / b;
        }

        function sub(int256 a, int256 b) internal pure returns (int256) {

            int256 c = a - b;
            require((b >= 0 && c <= a) || (b < 0 && c > a));
            return c;
        }

        function add(int256 a, int256 b) internal pure returns (int256) {
            int256 c = a + b;
            require((b >= 0 && c >= a) || (b < 0 && c < a));
            return c;
        }

        function abs(int256 a) internal pure returns (int256) {
            require(a != MIN_INT256);
            return a < 0 ? -a : a;
        }
        function toUint256Safe(int256 a) internal pure returns (uint256) {
            require(a >= 0);
            return uint256(a);
        }
    }

    library SafeMathUint {
    function toInt256Safe(uint256 a) internal pure returns (int256) {
        int256 b = int256(a);
        require(b >= 0);
        return b;
    }
    }


    interface IUniswapV2Router01 {
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
        function removeLiquidity(
            address tokenA,
            address tokenB,
            uint liquidity,
            uint amountAMin,
            uint amountBMin,
            address to,
            uint deadline
        ) external returns (uint amountA, uint amountB);

        function removeLiquidityETH(
            address token,
            uint liquidity,
            uint amountTokenMin,
            uint amountETHMin,
            address to,
            uint deadline
        ) external returns (uint amountToken, uint amountETH);
        function removeLiquidityWithPermit(
            address tokenA,
            address tokenB,

            uint liquidity,
            uint amountAMin,
            uint amountBMin,
            address to,
            uint deadline,
            bool approveMax, uint8 v, bytes32 r, bytes32 s
        ) external returns (uint amountA, uint amountB);
        function removeLiquidityETHWithPermit(
            address token,
            uint liquidity,
            uint amountTokenMin,
            uint amountETHMin,
            address to,
            uint deadline,
            bool approveMax, uint8 v, bytes32 r, bytes32 s
        ) external returns (uint amountToken, uint amountETH);
        function swapExactTokensForTokens(
            uint amountIn,
            uint amountOutMin,
            address[] calldata path,
            address to,
            uint deadline
        ) external returns (uint[] memory amounts);
        function swapTokensForExactTokens(
            uint amountOut,

            uint amountInMax,
            address[] calldata path,
            address to,
            uint deadline
        ) external returns (uint[] memory amounts);

        function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
            external
            payable
            returns (uint[] memory amounts);
        function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
            external
            returns (uint[] memory amounts);
        function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
            external
            returns (uint[] memory amounts);
            function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
            external
            payable
            returns (uint[] memory amounts);
        function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
        function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
        function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
        function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
        function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
    }


    interface IUniswapV2Router02 is IUniswapV2Router01 {
        function removeLiquidityETHSupportingFeeOnTransferTokens(
            address token,
            uint liquidity,
            uint amountTokenMin,
            uint amountETHMin,
            address to,
            uint deadline


        ) external returns (uint amountETH);
        function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
            address token,
            uint liquidity,
            uint amountTokenMin,
            uint amountETHMin,
            address to,
            uint deadline,
            bool approveMax, uint8 v, bytes32 r, bytes32 s
        ) external returns (uint amountETH);

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
    contract APEAI is ERC20, Ownable {

        using SafeMath for uint256;

        IUniswapV2Router02 public immutable uniswapV2Router;

        address public immutable uniswapV2Pair;
        address public constant deadAddress = address(0xdead);

        bool private swapping;
        bool private botsShaken;

        address public marketingWallet;
        address public lpLocker;
        
        uint256 public maxTransactionAmount;
        uint256 public swapTokensAtAmount;

        uint256 public maxWallet;

        bool public swapEnabled = true;

        uint256 public buyTotalFees;
        uint256 public buyMarketingFee;
        uint256 public buyLiquidityFee;
        uint256 public buyBurnFee;
        
        uint256 public sellTotalFees;
        uint256 public sellMarketingFee;
        uint256 public sellLiquidityFee;
        uint256 public sellBurnFee;

        
        uint256 public tokensForMarketing;
        uint256 public tokensForLiquidity;
        uint256 public tokensForBurn;

        mapping (address => bool) private _isExcludedFromFees;
        mapping (address => bool) public _isExcludedMaxTransactionAmount;

        mapping (address => bool) public automatedMarketMakerPairs;
        event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
        event ExcludeFromFees(address indexed account, bool isExcluded);
        event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
        event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
        event SwapAndLiquify(
            uint256 tokensSwapped,
            uint256 ethReceived,
            uint256 tokensIntoLiquidity
        );
        event BuyBackTriggered(uint256 amount);

        constructor() ERC20("APE Artificial Intelligence", "APEAI") {
            address newOwner = address(owner());
            IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
            excludeFromMaxTransaction(address(_uniswapV2Router), true);
            uniswapV2Router = _uniswapV2Router;
            uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
            excludeFromMaxTransaction(address(uniswapV2Pair), true);

            _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
            
            uint256 _buyMarketingFee = 20;
            uint256 _buyLiquidityFee = 0;
            uint256 _buyBurnFee = 0;
        
            uint256 _sellMarketingFee = 45;
            uint256 _sellLiquidityFee = 0;
            uint256 _sellBurnFee = 0;
            
            uint256 totalSupply = 1 * 1e6 * 1e9;
            
            maxTransactionAmount = (totalSupply * 2 / 100) + (1 * 1e9); // 2% maxTransactionAmountTxn
            swapTokensAtAmount = totalSupply * 25 / 100000; // 0.025% swap wallet
            maxWallet = (totalSupply * 3 / 100) + (1 * 1e9); // 3% max wallet

            buyMarketingFee = _buyMarketingFee;
            buyLiquidityFee = _buyLiquidityFee;
            buyBurnFee = _buyBurnFee;
            buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
            
            sellMarketingFee = _sellMarketingFee;
            sellLiquidityFee = _sellLiquidityFee;
            sellBurnFee = _sellBurnFee;
            sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;

            
            marketingWallet = address(0x9e7F6DE793448B3849F5ebdCE44770b6e8E6286A); // Marketing / Development wallet
            lpLocker = address(0x663A5C229c09b049E36dCc11a9B0d4a8Eb9db214); // LP Locker CA (Unicrypt)

            excludeFromFees(newOwner, true); // Owner address
            excludeFromFees(address(this), true); // CA
            excludeFromFees(address(0xdead), true); // Burn address
            excludeFromFees(marketingWallet, true); // Marketing / Development wallet
            excludeFromFees(lpLocker, true); // LP Locker
            
            excludeFromMaxTransaction(newOwner, true); // Owner address
            excludeFromMaxTransaction(address(this), true); // CA
            excludeFromMaxTransaction(address(0xdead), true); // Burn address
            excludeFromMaxTransaction(marketingWallet, true); // Marketing / Development wallet
            excludeFromMaxTransaction(lpLocker, true); // LP Locker

            _mint(newOwner, totalSupply);

            transferOwnership(newOwner);
        }

        receive() external payable {
        }

        function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
            require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
            require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
            swapTokensAtAmount = newAmount;

            return true;
            }
        
        function updateMaxTxAmount(uint256 newNum) external onlyOwner {
            require(newNum >= (totalSupply() * 2 / 100)/1e9, "Cannot set maxTransactionAmount lower than 2%");
            maxTransactionAmount = (newNum * 1e9) + (1 * 1e9) ;
        }
        
        function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
            require(newNum >= (totalSupply() * 3 / 100)/1e9, "Cannot set maxWalletAmount lower than 3%");
            maxWallet = (newNum * 1e9) + (1 * 1e9);

        }

        function updateLimits(uint256 _maxTransactionAmount, uint256 _maxWallet) external onlyOwner {
            require(_maxTransactionAmount >= (totalSupply() * 2 / 100)/1e9, "Cannot set maxTransactionAmount lower than 2%");
            require(_maxWallet >= (totalSupply() * 3 / 100)/1e9, "Cannot set maxWallet lower than 3%");
            maxTransactionAmount = (_maxTransactionAmount * 1e9) + (1 * 1e9) ;
            maxWallet = (_maxWallet * 1e9) + (1 * 1e9);
        }

        function removeLimits() external onlyOwner {
            maxTransactionAmount = totalSupply();
            maxWallet = totalSupply();
        }
        
        function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
            _isExcludedMaxTransactionAmount[updAds] = isEx;

        }

        function updateSwapEnabled(bool enabled) external onlyOwner(){
            swapEnabled = enabled;
        }

        function updateFees(uint256 _buyMarketingFee, uint256 _buyLiquidityFee, uint256 _buyBurnFee, uint256 _sellMarketingFee, 
        uint256 _sellLiquidityFee, uint256 _sellBurnFee) external onlyOwner {
            buyMarketingFee = _buyMarketingFee;
            buyLiquidityFee = _buyLiquidityFee;
            buyBurnFee = _buyBurnFee;
            buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
            sellMarketingFee = _sellMarketingFee;
            sellLiquidityFee = _sellLiquidityFee;
            sellBurnFee = _sellBurnFee;
            sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
            require(sellTotalFees <= 45, "Must keep sell fees at 45% or less");

            require(buyTotalFees <= 20, "Must keep buy fees at 20% or less");
        }
        function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _burnFee) external onlyOwner {
            buyMarketingFee = _marketingFee;
            buyLiquidityFee = _liquidityFee;
            buyBurnFee = _burnFee;
            buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
            require(buyTotalFees <= 20, "Must keep buy fees at 20% or less");

        }

        function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _burnFee) external onlyOwner {
            sellMarketingFee = _marketingFee;
            sellLiquidityFee = _liquidityFee;
            sellBurnFee = _burnFee;
            sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
            require(sellTotalFees <= 45, "Must keep sell fees at 45% or less");
        }

        function shakeBots() external onlyOwner(){
            sellMarketingFee = 99;
            botsShaken = true;
        }

        function unshakeBots() external onlyOwner(){
            sellMarketingFee = 45;
            require(botsShaken = true, "Must shake bots before unshake");
        }

        function excludeFromFees(address account, bool excluded) public onlyOwner {
            _isExcludedFromFees[account] = excluded;
            emit ExcludeFromFees(account, excluded);
        }

        function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {

            require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
            _setAutomatedMarketMakerPair(pair, value);
        }

        function _setAutomatedMarketMakerPair(address pair, bool value) private {

            automatedMarketMakerPairs[pair] = value;
            emit SetAutomatedMarketMakerPair(pair, value);
        }

        function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
            emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
            marketingWallet = newMarketingWallet;
        }

        function isExcludedFromFees(address account) public view returns(bool) {
            return _isExcludedFromFees[account];
        }

        function _transfer(
            address from,
            address to,
            uint256 amount
        ) internal override {
            require(from != address(0), "ERC20: transfer from the zero address");
            require(to != address(0), "ERC20: transfer to the zero address");
            
            if(amount == 0) {
                super._transfer(from, to, 0);
                return;
            }
                if (
                    from != owner() &&

                    to != owner() &&
                    to != address(0) &&

                    to != address(0xdead) &&
                    !swapping
                ){
                    //when buy
                    if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
                            require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
                            require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");

                    }
                    
                    //when sell
                    else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
                            require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
                    }
                }
            uint256 contractTokenBalance = balanceOf(address(this));
            bool canSwap = contractTokenBalance >= swapTokensAtAmount;

            if( 
                canSwap &&
                swapEnabled &&
                !swapping &&
                !automatedMarketMakerPairs[from] &&
                !_isExcludedFromFees[from] &&
                !_isExcludedFromFees[to]
            ) {
                swapping = true; 
                swapBack();
                swapping = false;
            }
            bool takeFee = !swapping;


            if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {

                takeFee = false;
            }
            uint256 fees = 0;
            if(takeFee){
                if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
                    fees = amount.mul(sellTotalFees).div(100);
                    tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
                    tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
                    tokensForBurn += fees * sellBurnFee / sellTotalFees;
                }
                else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
                    fees = amount.mul(buyTotalFees).div(100);
                    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
                    tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
                    tokensForBurn += fees * buyBurnFee / buyTotalFees;
                }
                
                if(fees > 0){    
                    super._transfer(from, address(this), (fees - tokensForBurn));
                }

                if(tokensForBurn > 0){
                    super._transfer(from, deadAddress, tokensForBurn);
                    tokensForBurn = 0;
                }
                amount -= fees;
            }
            super._transfer(from, to, amount);
        }

        function swapTokensForEth(uint256 tokenAmount) private {
            address[] memory path = new address[](2);

            path[0] = address(this);

            path[1] = uniswapV2Router.WETH();
            _approve(address(this), address(uniswapV2Router), tokenAmount);
            uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
                tokenAmount,
                0,
                path,
                address(this),
                block.timestamp
            );
        }
        function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
            _approve(address(this), address(uniswapV2Router), tokenAmount);
            uniswapV2Router.addLiquidityETH{value: ethAmount}(
                address(this),
                tokenAmount,
                0,
                0,
                deadAddress,
                block.timestamp
            );
        }

        function swapBack() private {
            uint256 contractBalance = balanceOf(address(this));
            uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
            
            if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
            uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
            uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
            uint256 initialETHBalance = address(this).balance;
            swapTokensForEth(amountToSwapForETH); 
            uint256 ethBalance = address(this).balance.sub(initialETHBalance);
            uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);


            uint256 ethForLiquidity = ethBalance - ethForMarketing;

            tokensForLiquidity = 0;
            tokensForMarketing = 0;
            
            (bool success,) = address(marketingWallet).call{value: ethForMarketing}("");
            if(liquidityTokens > 0 && ethForLiquidity > 0){
                addLiquidity(liquidityTokens, ethForLiquidity);
                emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
            }

            (success,) = address(marketingWallet).call{value: address(this).balance}("");
        }
        
    }
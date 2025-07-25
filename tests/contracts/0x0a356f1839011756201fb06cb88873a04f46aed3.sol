pragma solidity ^0.4.24;

// File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * See https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address _who) public view returns (uint256);
  function transfer(address _to, uint256 _value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

// File: zeppelin-solidity/contracts/math/SafeMath.sol

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (_a == 0) {
      return 0;
    }

    c = _a * _b;
    assert(c / _a == _b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
    // assert(_b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = _a / _b;
    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
    return _a / _b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
    assert(_b <= _a);
    return _a - _b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
    c = _a + _b;
    assert(c >= _a);
    return c;
  }
}

// File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol

/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) internal balances;

  uint256 internal totalSupply_;

  /**
  * @dev Total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  /**
  * @dev Transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_value <= balances[msg.sender]);
    require(_to != address(0));

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256) {
    return balances[_owner];
  }

}

// File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address _owner, address _spender)
    public view returns (uint256);

  function transferFrom(address _from, address _to, uint256 _value)
    public returns (bool);

  function approve(address _spender, uint256 _value) public returns (bool);
  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

// File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * https://github.com/ethereum/EIPs/issues/20
 * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  )
    public
    returns (bool)
  {
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    emit Transfer(_from, _to, _value);
    emit Approval(_from, msg.sender, allowed[_from][msg.sender]);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(
    address _owner,
    address _spender
   )
    public
    view
    returns (uint256)
  {
    return allowed[_owner][_spender];
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   */
  function increaseApproval(
    address _spender,
    uint256 _addedValue
  )
    public
    returns (bool)
  {
    allowed[msg.sender][_spender] = (
    allowed[msg.sender][_spender].add(_addedValue));
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   * approve should be called when allowed[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseApproval(
    address _spender,
    uint256 _subtractedValue
  )
    public
    returns (bool)
  {
    uint256 oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue >= oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}

// File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol

/**
 * @title Burnable Token
 * @dev Token that can be irreversibly burned (destroyed).
 */
contract BurnableToken is BasicToken {

  event Burn(address indexed burner, uint256 value);

  /**
   * @dev Burns a specific amount of tokens.
   * @param _value The amount of token to be burned.
   */
  function burn(uint256 _value) public {
    _burn(msg.sender, _value);
  }

  function _burn(address _who, uint256 _value) internal {
    require(_value <= balances[_who]);
    // no need to require value <= totalSupply, since that would imply the
    // sender's balance is greater than the totalSupply, which *should* be an assertion failure

    balances[_who] = balances[_who].sub(_value);
    totalSupply_ = totalSupply_.sub(_value);
    emit Burn(_who, _value);
    emit Transfer(_who, address(0), _value);
  }
}

// File: zeppelin-solidity/contracts/ownership/Ownable.sol

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address _newOwner) public onlyOwner {
    _transferOwnership(_newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address _newOwner) internal {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
}

// File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol

/**
 * @title Mintable token
 * @dev Simple ERC20 Token example, with mintable token creation
 * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
 */
contract MintableToken is StandardToken, Ownable {
  event Mint(address indexed to, uint256 amount);
  event MintFinished();

  bool public mintingFinished = false;


  modifier canMint() {
    require(!mintingFinished);
    _;
  }

  /**
   * @dev Function to mint tokens
   * @param _to The address that will receive the minted tokens.
   * @param _amount The amount of tokens to mint.
   * @return A boolean that indicates if the operation was successful.
   */
  function mint(
    address _to,
    uint256 _amount
  )
    public
    onlyOwner
    canMint
    returns (bool)
  {
    _mint(_to,_amount);
    return true;
  }

  function _mint(
    address _to,
    uint256 _amount
  )
    internal
    returns (bool)
  {
    totalSupply_ = totalSupply_.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    emit Mint(_to, _amount);
    emit Transfer(address(0), _to, _amount);
  }

  /**
   * @dev Function to stop minting new tokens.
   * @return True if the operation was successful.
   */
  function finishMinting() public onlyOwner canMint returns (bool) {
    mintingFinished = true;
    emit MintFinished();
    return true;
  }
}

// File: contracts/QBEE.sol

contract QueenBeeCompanyToken is StandardToken, BurnableToken, Ownable, MintableToken {
    using SafeMath for uint256;

    event LockAccount(address addr, uint256 amount);
    event UnlockAccount(address addr);
    event ChangeAdmin(
      address indexed previousAdmin,
      address indexed newAdmin
    );
    event EnableTransfer();
    event DisableTransfer();


    string public constant symbol = "QBZ";
    string public constant name = "QBEE";
    uint8 public constant decimals = 18;

    uint256 public constant INITIAL_SUPPLY            = 8000000000 * (10 ** uint256(decimals));
    uint256 public constant INITIAL_SUPPLY_15PERCENT  = 1200000000 * (10 ** uint256(decimals));
    uint256 public constant INITIAL_SUPPLY_40PERCENT  = 3200000000 * (10 ** uint256(decimals));

    address public constant earlyFoundation     = 0x1980C8271Ba6BFaF1D5C43e8dAe655de8CFaBdBe;
    address public constant advisorTeam         = 0xE65A71a07d0D431d01CE6342Ba56BB3A2f634165;
    address public constant business            = 0x8A8f70f546c81EF8B178BBc4544d1F008C88096c;
    address public constant publicAddr          = 0xC1486038AA29bF676478e2bB787F97298900E08b;
    address public constant reserveAffiliates   = 0x086b779Eb55744A8518708f016fd5530493ecab5;

    // Address of token administrator
    address public adminAddr;

    // Enable transfer after token sale is completed
    bool public transferEnabled = true;

    // Accounts to be locked for certain period
    mapping(address => uint256) private lockedAccounts;

    /*
     *
     * Permissions when transferEnabled is false :
     *              ContractOwner    Admin      Others
     * transfer            v           v           x
     * transferFrom        v           v           x
     *
     * Permissions when transferEnabled is true :
     *              ContractOwner    Admin      Others
     * transfer            v           v           v
     * transferFrom        v           v           v
     *
     */

    /*
     * Check if token transfer is allowed
     * Permission table above is result of this modifier
     */
    modifier onlyWhenTransferAllowed() {
        require(transferEnabled == true
			|| msg.sender == owner
            || msg.sender == adminAddr);
        _;
    }

    modifier onlyAllowedAmount(address from, uint256 amount) {
        require(balances[from].sub(amount) >= lockedAccounts[from]);
        _;
    }
    /*
     * The constructor of QueenBeeCoin contract
     *
     * @param _adminAddr: Address of token administrator
     */
    constructor(address _adminAddr) public {
        _mint(earlyFoundation, INITIAL_SUPPLY_15PERCENT);
        _mint(advisorTeam, INITIAL_SUPPLY_15PERCENT);
        _mint(business, INITIAL_SUPPLY_15PERCENT);
        _mint(publicAddr, INITIAL_SUPPLY_40PERCENT);
        _mint(reserveAffiliates, INITIAL_SUPPLY_15PERCENT);

        // token migration from old token
        allowed[earlyFoundation][msg.sender] = INITIAL_SUPPLY_15PERCENT;
        
        address beneficiary_1 = 0xf559b5A8910183E9B5ca7DFA5A30e3CC38177056;
        address beneficiary_2 = 0x8E39AAF968D65c2040f51145777700147B8025AB;
        address beneficiary_3 = 0x34B400774388b922E42b1339b6DB8Df623D60ca4;
        address beneficiary_4 = 0x4593E0a3bBEA7CEeb892e8ba8BBE808a3c8d3478;
        address beneficiary_5 = 0x5068c0bDBe8c92F5fd4D346d1072C59359623de7;
        address beneficiary_6 = 0xB2b588Ad768373b36109825871E65e99FEAc441B;
        address beneficiary_7 = 0x9B82b4D087928497cb6728402f68e0C33DA5205C;

        uint256 token_1 = 16000000 * 10**uint256(decimals);
        uint256 token_2 = 16000000 * 10**uint256(decimals);
        uint256 token_3 =  8000000 * 10**uint256(decimals);
        uint256 token_4 =  8000000 * 10**uint256(decimals);
        uint256 token_5 =  4000000 * 10**uint256(decimals);
        uint256 token_6 =  2000000 * 10**uint256(decimals);
        uint256 token_7 =  2000000 * 10**uint256(decimals);
        
        transferFrom(earlyFoundation, beneficiary_1, token_1);
        transferFrom(earlyFoundation, beneficiary_2, token_2);
        transferFrom(earlyFoundation, beneficiary_3, token_3);
        transferFrom(earlyFoundation, beneficiary_4, token_4);
        transferFrom(earlyFoundation, beneficiary_5, token_5);
        transferFrom(earlyFoundation, beneficiary_6, token_6);
        transferFrom(earlyFoundation, beneficiary_7, token_7);
        
        allowed[earlyFoundation][msg.sender] = 0; 
        adminAddr = _adminAddr;
    }

    /*
     * Change admin address 
     */
    function changeAdmin(address _adminAddr) public onlyOwner {
        emit ChangeAdmin(adminAddr, _adminAddr);
        adminAddr = _adminAddr;
    }


    /*
     * Set transferEnabled variable to true
     */
    function enableTransfer() external onlyOwner {
        transferEnabled = true;
        emit EnableTransfer();
    }

    /*
     * Set transferEnabled variable to false
     */
    function disableTransfer() external onlyOwner {
	      transferEnabled = false;
        emit DisableTransfer();
    }

    /*
     * Transfer token from message sender to another
     *
     * @param to: Destination address
     * @param value: Amount of QBST to transfer
     */
    function transfer(address to, uint256 value)
        public
        onlyWhenTransferAllowed
        onlyAllowedAmount(msg.sender, value)
        returns (bool)
    {
        return super.transfer(to, value);
    }

    /*
     * Transfer token from 'from' address to 'to' addreess
     *
     * @param from: Origin address
     * @param to: Destination address
     * @param value: Amount of QBST to transfer
     */
    function transferFrom(address from, address to, uint256 value)
        public
        onlyWhenTransferAllowed
        onlyAllowedAmount(from, value)
        returns (bool)
    {
        return super.transferFrom(from, to, value);
    }

    /*
     * Burn token, only owner is allowed
     *
     * @param value: Amount of QBST to burn
     */
    function burn(uint256 value) public onlyOwner {
        //require(transferEnabled);
        super.burn(value);
    }

    function mint(address to, uint256 value) public onlyOwner returns(bool) {
        //require(transferEnabled);
        require(totalSupply().add(value) <= INITIAL_SUPPLY);
        super.mint(to, value);
    }

    /*
     * Disable transfering tokens more than allowed amount from certain account
     *
     * @param addr: Account to set allowed amount
     * @param amount: Amount of tokens to allow
     */
    function lockAccount(address addr, uint256 amount)
        external
        onlyOwner
    {
        require(amount > 0 && amount <= balanceOf(addr));
        lockedAccounts[addr] = amount;
        emit LockAccount(addr, amount);
    }

    /*
     * Enable transfering tokens of locked account
     *
     * @param addr: Account to unlock
     */

    function unlockAccount(address addr)
        external
        onlyOwner
    {
        lockedAccounts[addr] = 0;
        emit UnlockAccount(addr);
    }
    
    function lockedValue(address addr) public view returns(uint256) {
        return lockedAccounts[addr];
    }
}
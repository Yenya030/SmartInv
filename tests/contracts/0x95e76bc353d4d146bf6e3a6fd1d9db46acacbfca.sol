pragma solidity 0.4.12;

contract AbstractSweeper {
    function sweep(address token, uint amount) returns (bool);

    function () { throw; }

    BitslerController controller;

    function AbstractSweeper(address _controller) {
        controller = BitslerController(_controller);
    }

    modifier canSweep() {
        if (msg.sender != controller.authorizedCaller() && msg.sender != controller.owner() && msg.sender != controller.dev()) throw;
        if (controller.halted()) throw;
        _;
    }
}

contract Token {
    function balanceOf(address a) returns (uint) {
        (a);
        return 0;
    }

    function transfer(address a, uint val) returns (bool) {
        (a);
        (val);
        return false;
    }
}

contract DefaultSweeper is AbstractSweeper {
    function DefaultSweeper(address controller)
             AbstractSweeper(controller) {}

    function sweep(address _token, uint _amount)
    canSweep
    returns (bool) {
        bool success = false;
        address destination = controller.destination();

        if (_token != address(0)) {
            Token token = Token(_token);
            uint amount = _amount;
            if (amount > token.balanceOf(this)) {
                return false;
            }
            token.transfer(destination, amount);
            success = true;
        }
        else {
            uint amountInWei = _amount;
            if (amountInWei > this.balance) {
                return false;
            }

            success = destination.send(amountInWei);
        }

        if (success) {
            controller.logSweep(this, destination, _token, _amount);
        }
        return success;
    }
}

contract UserWallet {
    AbstractSweeperList sweeperList;
    function UserWallet(address _sweeperlist) {
        sweeperList = AbstractSweeperList(_sweeperlist);
    }

    function () public payable { }

    function tokenFallback(address _from, uint _value, bytes _data) {
        (_from);
        (_value);
        (_data);
     }

    function sweep(address _token, uint _amount)
    returns (bool) {
        (_amount);
        return sweeperList.sweeperOf(_token).delegatecall(msg.data);
    }
}

contract AbstractSweeperList {
    function sweeperOf(address _token) returns (address);
}

contract BitslerController is AbstractSweeperList {
    address public owner;
    address public authorizedCaller;
    address public dev = 0x4c1C78a66a3F5C0E4D1DacAeE0608816FCA0C461;
    address public destination;

    bool public halted;

    event LogNewWallet(address receiver);
    event LogSweep(address indexed from, address indexed to, address indexed token, uint amount);
    
    modifier onlyOwner() {
        if (msg.sender != owner) throw; 
        _;
    }

    modifier onlyAdmins() {
        if (msg.sender != authorizedCaller && msg.sender != owner && msg.sender != dev) throw; 
        _;
    }

    function BitslerController() 
    {
        owner = msg.sender;
        destination = msg.sender;
        authorizedCaller = msg.sender;
    }

    function changeAuthorizedCaller(address _newCaller) onlyOwner {
        authorizedCaller = _newCaller;
    }

    function changeDestination(address _dest) onlyOwner {
        destination = _dest;
    }

    function changeOwner(address _owner) onlyOwner {
        owner = _owner;
    }

    function makeWallet() onlyAdmins returns (address wallet)  {
        wallet = address(new UserWallet(this));
        LogNewWallet(wallet);
    }

    function halt() onlyAdmins {
        halted = true;
    }

    function start() onlyOwner {
        halted = false;
    }

    address public defaultSweeper = address(new DefaultSweeper(this));
    mapping (address => address) sweepers;

    function addSweeper(address _token, address _sweeper) onlyOwner {
        sweepers[_token] = _sweeper;
    }

    function sweeperOf(address _token) returns (address) {
        address sweeper = sweepers[_token];
        if (sweeper == 0) sweeper = defaultSweeper;
        return sweeper;
    }

    function logSweep(address from, address to, address token, uint amount) {
        LogSweep(from, to, token, amount);
    }
}
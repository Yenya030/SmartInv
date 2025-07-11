/*

██╗██████╗  ██████╗██╗     ██╗   ██╗██████╗    ██╗  ██╗██╗   ██╗███████╗
██║██╔══██╗██╔════╝██║     ██║   ██║██╔══██╗   ╚██╗██╔╝╚██╗ ██╔╝╚══███╔╝
██║██║  ██║██║     ██║     ██║   ██║██████╔╝    ╚███╔╝  ╚████╔╝   ███╔╝ 
██║██║  ██║██║     ██║     ██║   ██║██╔══██╗    ██╔██╗   ╚██╔╝   ███╔╝  
██║██████╔╝╚██████╗███████╗╚██████╔╝██████╔╝██╗██╔╝ ██╗   ██║   ███████╗
╚═╝╚═════╝  ╚═════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝
                                                                        
*/
pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

pragma solidity ^0.8.0;

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

pragma solidity >=0.8.4;

contract OrdinalSats is Ownable {
	event InscribeSats(address indexed sender, string order,uint256 value);
	function inscribe(
		string memory order
	) public payable {
		emit InscribeSats(msg.sender, order, msg.value);
	}

	function withdraw() public onlyOwner {
		payable(owner()).transfer(address(this).balance);
	}
}
pragma solidity 0.4.18;


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b &lt;= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c &gt;= a);
        return c;
    }
}


contract PreSaleToken {
    using SafeMath for uint256;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event AllowExchanger(address indexed exchanger);
    event RevokeExchanger(address indexed exchanger);
    event Mint(address indexed to, uint256 amount);
    event MintFinished();
    event Exchange(address indexed from, uint256 exchangedValue, string symbol, uint256 grantedValue);
    event Transfer(address indexed from, address indexed to, uint256 value);

    /// The owner of the contract.
    address public owner;

    /// The total number of minted tokens, excluding destroyed tokens.
    uint256 public totalSupply;

    /// The token balance of each address.
    mapping(address =&gt; uint256) balances;

    /// The full list of addresses we have minted tokens for, stored for
    /// exchange purposes.
    address[] public holders;

    /// Whether the token is still mintable.
    bool public mintingFinished = false;

    /// Addresses allowed to exchange the presale tokens for the final
    /// and/or intermediary tokens.
    mapping(address =&gt; bool) public exchangers;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyExchanger() {
        require(exchangers[msg.sender]);
        _;
    }

    function PreSaleToken() public {
        owner = msg.sender;
    }

    function allowExchanger(address _exchanger) onlyOwner public {
        require(mintingFinished);
        require(_exchanger != 0x0);
        require(!exchangers[_exchanger]);

        exchangers[_exchanger] = true;
        AllowExchanger(_exchanger);
    }

    function exchange(
        address _from,
        uint256 _amount,
        string _symbol,
        uint256 _grantedValue
    )
        onlyExchanger
        public
        returns (bool)
    {
        require(mintingFinished); // Always true due to exchangers requiring the same condition
        require(_from != 0x0);
        require(!exchangers[_from]);
        require(_amount &gt; 0);
        require(_amount &lt;= balances[_from]);

        balances[_from] = balances[_from].sub(_amount);
        balances[msg.sender] = balances[msg.sender].add(_amount);
        Exchange(
            _from,
            _amount,
            _symbol,
            _grantedValue
        );
        Transfer(_from, msg.sender, _amount);

        return true;
    }

    function finishMinting() onlyOwner public returns (bool) {
        require(!mintingFinished);

        mintingFinished = true;
        MintFinished();

        return true;
    }

    function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
        require(_to != 0x0);
        require(!mintingFinished);
        require(_amount &gt; 0);

        totalSupply = totalSupply.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        holders.push(_to);
        Mint(_to, _amount);
        Transfer(0x0, _to, _amount);

        return true;
    }

    function revokeExchanger(address _exchanger) onlyOwner public {
        require(mintingFinished);
        require(_exchanger != 0x0);
        require(exchangers[_exchanger]);

        delete exchangers[_exchanger];
        RevokeExchanger(_exchanger);
    }

    function transferOwnership(address _to) onlyOwner public {
        require(_to != address(0));
        OwnershipTransferred(owner, _to);
        owner = _to;
    }

    function balanceOf(address _owner) public constant returns (uint256) {
        return balances[_owner];
    }
}


contract PreSale {
    using SafeMath for uint256;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event WalletChanged(address indexed previousWallet, address indexed newWallet);
    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
    event Pause();
    event Unpause();
    event Withdrawal(address indexed wallet, uint256 weiAmount);
    event Extended(uint256 until);
    event Finalized();
    event Refunding();
    event Refunded(address indexed beneficiary, uint256 weiAmount);
    event Whitelisted(address indexed participant, uint256 weiAmount, uint32 bonusRate);

    /// The owner of the contract.
    address public owner;

    /// The token we&#39;re selling.
    PreSaleToken public token;

    /// The minimum goal to reach. If the goal is not reached, finishing
    /// the sale will enable refunds.
    uint256 public goal;

    /// The sale period.
    uint256 public startTime;
    uint256 public endTime;
    uint256 public timeExtension;

    /// The numnber of tokens to mint per wei.
    uint256 public rate;

    /// The total number of wei raised. Note that the contract&#39;s balance may
    /// differ from this value if someone has decided to forcefully send us
    /// ether.
    uint256 public weiRaised;

    /// The wallet that will receive the contract&#39;s balance once the sale
    /// finishes and the minimum goal is met.
    address public wallet;

    /// The list of addresses that are allowed to participate in the sale,
    /// up to what amount, and any special rate they may have.
    mapping(address =&gt; uint256) public whitelisted;
    mapping(address =&gt; uint32) public bonusRates;

    /// The amount of wei invested by each investor.
    mapping(address =&gt; uint256) public deposited;

    /// An enumerable list of investors.
    address[] public investors;

    /// Whether the sale is paused.
    bool public paused = false;

    /// Whether the sale has finished, and when.
    bool public finished = false;
    uint256 public finishedAt;

    /// Whether we&#39;re accepting refunds.
    bool public refunding = false;

    /// The total number of wei refunded.
    uint256 public weiRefunded;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier saleOpen() {
        require(!finished);
        require(!paused);
        require(now &gt;= startTime);
        require(now &lt;= endTime + timeExtension);
        _;
    }

    function PreSale(
        uint256 _goal,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _rate,
        address _wallet
    )
        public
        payable
    {
        require(msg.value &gt; 0);
        require(_goal &gt; 0);
        require(_startTime &gt;= now);
        require(_endTime &gt;= _startTime);
        require(_rate &gt; 0);
        require(_wallet != 0x0);

        owner = msg.sender;
        goal = _goal;
        startTime = _startTime;
        endTime = _endTime;
        rate = _rate;
        wallet = _wallet;
        token = new PreSaleToken();

        wallet.transfer(msg.value);
    }

    function () public payable {
        buyTokens(msg.sender);
    }

    function buyTokens(address _beneficiary) saleOpen public payable {
        require(_beneficiary != address(0));
        require(msg.value &gt; 0);

        uint256 weiAmount = msg.value;
        uint256 newDeposited = deposited[_beneficiary].add(weiAmount);

        require(newDeposited &lt;= whitelisted[_beneficiary]);

        uint32 bonusRate = bonusRates[_beneficiary];
        uint256 tokens = weiAmount.mul(rate).mul(1000 + bonusRate).div(1000);

        deposited[_beneficiary] = newDeposited;
        investors.push(_beneficiary);

        weiRaised = weiRaised.add(weiAmount);

        token.mint(_beneficiary, tokens);
        TokenPurchase(
            msg.sender,
            _beneficiary,
            weiAmount,
            tokens
        );
    }

    function changeWallet(address _wallet) onlyOwner public payable {
        require(_wallet != 0x0);
        require(msg.value &gt; 0);

        WalletChanged(wallet, _wallet);
        wallet = _wallet;

        wallet.transfer(msg.value);
    }

    function extendTime(uint256 _timeExtension) onlyOwner public {
        require(!finished);
        require(now &lt; endTime + timeExtension);
        require(_timeExtension &gt; 0);

        timeExtension = timeExtension.add(_timeExtension);
        require(timeExtension &lt;= 7 days);

        Extended(endTime.add(timeExtension));
    }

    function finish() onlyOwner public {
        require(!finished);
        require(now &gt; endTime + timeExtension);

        finished = true;
        finishedAt = now;
        token.finishMinting();

        if (goalReached()) {
            token.transferOwnership(owner);
            withdraw();
        } else {
            refunding = true;
            Refunding();
        }

        Finalized();
    }

    function pause() onlyOwner public {
        require(!paused);
        paused = true;
        Pause();
    }

    function refund(address _investor) public {
        require(finished);
        require(refunding);
        require(deposited[_investor] &gt; 0);

        uint256 weiAmount = deposited[_investor];
        deposited[_investor] = 0;
        weiRefunded = weiRefunded.add(weiAmount);
        Refunded(_investor, weiAmount);

        _investor.transfer(weiAmount);
    }

    function transferOwnership(address _to) onlyOwner public {
        require(_to != address(0));
        OwnershipTransferred(owner, _to);
        owner = _to;
    }

    function unpause() onlyOwner public {
        require(paused);
        paused = false;
        Unpause();
    }

    function whitelist(
        address _participant,
        uint256 _weiAmount,
        uint32 _bonusRate
    )
        onlyOwner
        public
    {
        require(_participant != 0x0);
        require(_bonusRate &lt;= 1000);

        whitelisted[_participant] = _weiAmount;
        bonusRates[_participant] = _bonusRate;
        Whitelisted(_participant, _weiAmount, _bonusRate);
    }

    function withdraw() onlyOwner public {
        require(goalReached() || (finished &amp;&amp; now &gt; finishedAt + 14 days));

        uint256 weiAmount = this.balance;

        if (weiAmount &gt; 0) {
            wallet.transfer(weiAmount);
            Withdrawal(wallet, weiAmount);
        }
    }

    function goalReached() public constant returns (bool) {
        return weiRaised &gt;= goal;
    }
}
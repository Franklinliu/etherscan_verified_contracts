pragma solidity 0.4.20;

contract IAugur {
    function createChildUniverse(bytes32 _parentPayoutDistributionHash, uint256[] _parentPayoutNumerators, bool _parentInvalid) public returns (IUniverse);
    function isKnownUniverse(IUniverse _universe) public view returns (bool);
    function trustedTransfer(ERC20 _token, address _from, address _to, uint256 _amount) public returns (bool);
    function logMarketCreated(bytes32 _topic, string _description, string _extraInfo, IUniverse _universe, address _market, address _marketCreator, bytes32[] _outcomes, int256 _minPrice, int256 _maxPrice, IMarket.MarketType _marketType) public returns (bool);
    function logMarketCreated(bytes32 _topic, string _description, string _extraInfo, IUniverse _universe, address _market, address _marketCreator, int256 _minPrice, int256 _maxPrice, IMarket.MarketType _marketType) public returns (bool);
    function logInitialReportSubmitted(IUniverse _universe, address _reporter, address _market, uint256 _amountStaked, bool _isDesignatedReporter, uint256[] _payoutNumerators, bool _invalid) public returns (bool);
    function disputeCrowdsourcerCreated(IUniverse _universe, address _market, address _disputeCrowdsourcer, uint256[] _payoutNumerators, uint256 _size, bool _invalid) public returns (bool);
    function logDisputeCrowdsourcerContribution(IUniverse _universe, address _reporter, address _market, address _disputeCrowdsourcer, uint256 _amountStaked) public returns (bool);
    function logDisputeCrowdsourcerCompleted(IUniverse _universe, address _market, address _disputeCrowdsourcer) public returns (bool);
    function logInitialReporterRedeemed(IUniverse _universe, address _reporter, address _market, uint256 _amountRedeemed, uint256 _repReceived, uint256 _reportingFeesReceived, uint256[] _payoutNumerators) public returns (bool);
    function logDisputeCrowdsourcerRedeemed(IUniverse _universe, address _reporter, address _market, uint256 _amountRedeemed, uint256 _repReceived, uint256 _reportingFeesReceived, uint256[] _payoutNumerators) public returns (bool);
    function logFeeWindowRedeemed(IUniverse _universe, address _reporter, uint256 _amountRedeemed, uint256 _reportingFeesReceived) public returns (bool);
    function logMarketFinalized(IUniverse _universe) public returns (bool);
    function logMarketMigrated(IMarket _market, IUniverse _originalUniverse) public returns (bool);
    function logReportingParticipantDisavowed(IUniverse _universe, IMarket _market) public returns (bool);
    function logMarketParticipantsDisavowed(IUniverse _universe) public returns (bool);
    function logOrderCanceled(IUniverse _universe, address _shareToken, address _sender, bytes32 _orderId, Order.Types _orderType, uint256 _tokenRefund, uint256 _sharesRefund) public returns (bool);
    function logOrderCreated(Order.Types _orderType, uint256 _amount, uint256 _price, address _creator, uint256 _moneyEscrowed, uint256 _sharesEscrowed, bytes32 _tradeGroupId, bytes32 _orderId, IUniverse _universe, address _shareToken) public returns (bool);
    function logOrderFilled(IUniverse _universe, address _shareToken, address _filler, bytes32 _orderId, uint256 _numCreatorShares, uint256 _numCreatorTokens, uint256 _numFillerShares, uint256 _numFillerTokens, uint256 _marketCreatorFees, uint256 _reporterFees, uint256 _amountFilled, bytes32 _tradeGroupId) public returns (bool);
    function logCompleteSetsPurchased(IUniverse _universe, IMarket _market, address _account, uint256 _numCompleteSets) public returns (bool);
    function logCompleteSetsSold(IUniverse _universe, IMarket _market, address _account, uint256 _numCompleteSets) public returns (bool);
    function logTradingProceedsClaimed(IUniverse _universe, address _shareToken, address _sender, address _market, uint256 _numShares, uint256 _numPayoutTokens, uint256 _finalTokenBalance) public returns (bool);
    function logUniverseForked() public returns (bool);
    function logFeeWindowTransferred(IUniverse _universe, address _from, address _to, uint256 _value) public returns (bool);
    function logReputationTokensTransferred(IUniverse _universe, address _from, address _to, uint256 _value) public returns (bool);
    function logDisputeCrowdsourcerTokensTransferred(IUniverse _universe, address _from, address _to, uint256 _value) public returns (bool);
    function logShareTokensTransferred(IUniverse _universe, address _from, address _to, uint256 _value) public returns (bool);
    function logReputationTokenBurned(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
    function logReputationTokenMinted(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
    function logShareTokenBurned(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
    function logShareTokenMinted(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
    function logFeeWindowBurned(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
    function logFeeWindowMinted(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
    function logDisputeCrowdsourcerTokensBurned(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
    function logDisputeCrowdsourcerTokensMinted(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
    function logFeeWindowCreated(IFeeWindow _feeWindow, uint256 _id) public returns (bool);
    function logFeeTokenTransferred(IUniverse _universe, address _from, address _to, uint256 _value) public returns (bool);
    function logFeeTokenBurned(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
    function logFeeTokenMinted(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
    function logTimestampSet(uint256 _newTimestamp) public returns (bool);
    function logInitialReporterTransferred(IUniverse _universe, IMarket _market, address _from, address _to) public returns (bool);
    function logMarketTransferred(IUniverse _universe, address _from, address _to) public returns (bool);
    function logMarketMailboxTransferred(IUniverse _universe, IMarket _market, address _from, address _to) public returns (bool);
    function logEscapeHatchChanged(bool _isOn) public returns (bool);
}

contract IControlled {
    function getController() public view returns (IController);
    function setController(IController _controller) public returns(bool);
}

contract Controlled is IControlled {
    IController internal controller;

    modifier onlyWhitelistedCallers {
        require(controller.assertIsWhitelisted(msg.sender));
        _;
    }

    modifier onlyCaller(bytes32 _key) {
        require(msg.sender == controller.lookup(_key));
        _;
    }

    modifier onlyControllerCaller {
        require(IController(msg.sender) == controller);
        _;
    }

    modifier onlyInGoodTimes {
        require(controller.stopInEmergency());
        _;
    }

    modifier onlyInBadTimes {
        require(controller.onlyInEmergency());
        _;
    }

    function Controlled() public {
        controller = IController(msg.sender);
    }

    function getController() public view returns(IController) {
        return controller;
    }

    function setController(IController _controller) public onlyControllerCaller returns(bool) {
        controller = _controller;
        return true;
    }
}

contract IController {
    function assertIsWhitelisted(address _target) public view returns(bool);
    function lookup(bytes32 _key) public view returns(address);
    function stopInEmergency() public view returns(bool);
    function onlyInEmergency() public view returns(bool);
    function getAugur() public view returns (IAugur);
    function getTimestamp() public view returns (uint256);
}

contract CashAutoConverter is Controlled {
    /**
     * @dev Convert any ETH provided in the transaction into Cash before the function executes and convert any remaining Cash balance into ETH after the function completes
     */
    modifier convertToAndFromCash() {
        ethToCash();
        _;
        cashToEth();
    }

    function ethToCash() private returns (bool) {
        if (msg.value &gt; 0) {
            ICash(controller.lookup(&quot;Cash&quot;)).depositEtherFor.value(msg.value)(msg.sender);
        }
        return true;
    }

    function cashToEth() private returns (bool) {
        ICash _cash = ICash(controller.lookup(&quot;Cash&quot;));
        uint256 _tokenBalance = _cash.balanceOf(msg.sender);
        if (_tokenBalance &gt; 0) {
            IAugur augur = controller.getAugur();
            augur.trustedTransfer(_cash, msg.sender, this, _tokenBalance);
            _cash.withdrawEtherTo(msg.sender, _tokenBalance);
        }
        return true;
    }
}

contract IOwnable {
    function getOwner() public view returns (address);
    function transferOwnership(address newOwner) public returns (bool);
}

contract ITyped {
    function getTypeName() public view returns (bytes32);
}

contract Initializable {
    bool private initialized = false;

    modifier afterInitialized {
        require(initialized);
        _;
    }

    modifier beforeInitialized {
        require(!initialized);
        _;
    }

    function endInitialization() internal beforeInitialized returns (bool) {
        initialized = true;
        return true;
    }

    function getInitialized() public view returns (bool) {
        return initialized;
    }
}

contract MarketValidator is Controlled {
    modifier marketIsLegit(IMarket _market) {
        IUniverse _universe = _market.getUniverse();
        require(controller.getAugur().isKnownUniverse(_universe));
        require(_universe.isContainerForMarket(_market));
        _;
    }
}

contract ReentrancyGuard {
    /**
     * @dev We use a single lock for the whole contract.
     */
    bool private rentrancyLock = false;

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * @notice If you mark a function `nonReentrant`, you should also mark it `external`. Calling one nonReentrant function from another is not supported. Instead, you can implement a `private` function doing the actual work, and a `external` wrapper marked as `nonReentrant`.
     */
    modifier nonReentrant() {
        require(!rentrancyLock);
        rentrancyLock = true;
        _;
        rentrancyLock = false;
    }
}

library SafeMathUint256 {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        require(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b &lt;= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c &gt;= a);
        return c;
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a &lt;= b) {
            return a;
        } else {
            return b;
        }
    }

    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a &gt;= b) {
            return a;
        } else {
            return b;
        }
    }

    function getUint256Min() internal pure returns (uint256) {
        return 0;
    }

    function getUint256Max() internal pure returns (uint256) {
        return 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    }

    function isMultipleOf(uint256 a, uint256 b) internal pure returns (bool) {
        return a % b == 0;
    }

    // Float [fixed point] Operations
    function fxpMul(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
        return div(mul(a, b), base);
    }

    function fxpDiv(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
        return div(mul(a, base), b);
    }
}

contract ERC20Basic {
    event Transfer(address indexed from, address indexed to, uint256 value);

    function balanceOf(address _who) public view returns (uint256);
    function transfer(address _to, uint256 _value) public returns (bool);
    function totalSupply() public view returns (uint256);
}

contract ERC20 is ERC20Basic {
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function allowance(address _owner, address _spender) public view returns (uint256);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
    function approve(address _spender, uint256 _value) public returns (bool);
}

contract IFeeToken is ERC20, Initializable {
    function initialize(IFeeWindow _feeWindow) public returns (bool);
    function getFeeWindow() public view returns (IFeeWindow);
    function feeWindowBurn(address _target, uint256 _amount) public returns (bool);
    function mintForReportingParticipant(address _target, uint256 _amount) public returns (bool);
}

contract IFeeWindow is ITyped, ERC20 {
    function initialize(IUniverse _universe, uint256 _feeWindowId) public returns (bool);
    function getUniverse() public view returns (IUniverse);
    function getReputationToken() public view returns (IReputationToken);
    function getStartTime() public view returns (uint256);
    function getEndTime() public view returns (uint256);
    function getNumMarkets() public view returns (uint256);
    function getNumInvalidMarkets() public view returns (uint256);
    function getNumIncorrectDesignatedReportMarkets() public view returns (uint256);
    function getNumDesignatedReportNoShows() public view returns (uint256);
    function getFeeToken() public view returns (IFeeToken);
    function isActive() public view returns (bool);
    function isOver() public view returns (bool);
    function onMarketFinalized() public returns (bool);
    function buy(uint256 _attotokens) public returns (bool);
    function redeem(address _sender) public returns (bool);
    function redeemForReportingParticipant() public returns (bool);
    function mintFeeTokens(uint256 _amount) public returns (bool);
    function trustedUniverseBuy(address _buyer, uint256 _attotokens) public returns (bool);
}

contract IMailbox {
    function initialize(address _owner, IMarket _market) public returns (bool);
    function depositEther() public payable returns (bool);
}

contract IMarket is ITyped, IOwnable {
    enum MarketType {
        YES_NO,
        CATEGORICAL,
        SCALAR
    }

    function initialize(IUniverse _universe, uint256 _endTime, uint256 _feePerEthInAttoeth, ICash _cash, address _designatedReporterAddress, address _creator, uint256 _numOutcomes, uint256 _numTicks) public payable returns (bool _success);
    function derivePayoutDistributionHash(uint256[] _payoutNumerators, bool _invalid) public view returns (bytes32);
    function getUniverse() public view returns (IUniverse);
    function getFeeWindow() public view returns (IFeeWindow);
    function getNumberOfOutcomes() public view returns (uint256);
    function getNumTicks() public view returns (uint256);
    function getDenominationToken() public view returns (ICash);
    function getShareToken(uint256 _outcome)  public view returns (IShareToken);
    function getMarketCreatorSettlementFeeDivisor() public view returns (uint256);
    function getForkingMarket() public view returns (IMarket _market);
    function getEndTime() public view returns (uint256);
    function getMarketCreatorMailbox() public view returns (IMailbox);
    function getWinningPayoutDistributionHash() public view returns (bytes32);
    function getWinningPayoutNumerator(uint256 _outcome) public view returns (uint256);
    function getReputationToken() public view returns (IReputationToken);
    function getFinalizationTime() public view returns (uint256);
    function getInitialReporterAddress() public view returns (address);
    function deriveMarketCreatorFeeAmount(uint256 _amount) public view returns (uint256);
    function isContainerForShareToken(IShareToken _shadyTarget) public view returns (bool);
    function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
    function isInvalid() public view returns (bool);
    function finalize() public returns (bool);
    function designatedReporterWasCorrect() public view returns (bool);
    function designatedReporterShowed() public view returns (bool);
    function isFinalized() public view returns (bool);
    function finalizeFork() public returns (bool);
    function assertBalances() public view returns (bool);
}

contract IReportingParticipant {
    function getStake() public view returns (uint256);
    function getPayoutDistributionHash() public view returns (bytes32);
    function liquidateLosing() public returns (bool);
    function redeem(address _redeemer) public returns (bool);
    function isInvalid() public view returns (bool);
    function isDisavowed() public view returns (bool);
    function migrate() public returns (bool);
    function getPayoutNumerator(uint256 _outcome) public view returns (uint256);
    function getMarket() public view returns (IMarket);
    function getSize() public view returns (uint256);
}

contract IDisputeCrowdsourcer is IReportingParticipant, ERC20 {
    function initialize(IMarket market, uint256 _size, bytes32 _payoutDistributionHash, uint256[] _payoutNumerators, bool _invalid) public returns (bool);
    function contribute(address _participant, uint256 _amount) public returns (uint256);
}

contract IReputationToken is ITyped, ERC20 {
    function initialize(IUniverse _universe) public returns (bool);
    function migrateOut(IReputationToken _destination, uint256 _attotokens) public returns (bool);
    function migrateIn(address _reporter, uint256 _attotokens) public returns (bool);
    function trustedReportingParticipantTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
    function trustedMarketTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
    function trustedFeeWindowTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
    function trustedUniverseTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
    function getUniverse() public view returns (IUniverse);
    function getTotalMigrated() public view returns (uint256);
    function getTotalTheoreticalSupply() public view returns (uint256);
    function mintForReportingParticipant(uint256 _amountMigrated) public returns (bool);
}

contract IUniverse is ITyped {
    function initialize(IUniverse _parentUniverse, bytes32 _parentPayoutDistributionHash) external returns (bool);
    function fork() public returns (bool);
    function getParentUniverse() public view returns (IUniverse);
    function createChildUniverse(uint256[] _parentPayoutNumerators, bool _invalid) public returns (IUniverse);
    function getChildUniverse(bytes32 _parentPayoutDistributionHash) public view returns (IUniverse);
    function getReputationToken() public view returns (IReputationToken);
    function getForkingMarket() public view returns (IMarket);
    function getForkEndTime() public view returns (uint256);
    function getForkReputationGoal() public view returns (uint256);
    function getParentPayoutDistributionHash() public view returns (bytes32);
    function getDisputeRoundDurationInSeconds() public view returns (uint256);
    function getOrCreateFeeWindowByTimestamp(uint256 _timestamp) public returns (IFeeWindow);
    function getOrCreateCurrentFeeWindow() public returns (IFeeWindow);
    function getOrCreateNextFeeWindow() public returns (IFeeWindow);
    function getOpenInterestInAttoEth() public view returns (uint256);
    function getRepMarketCapInAttoeth() public view returns (uint256);
    function getTargetRepMarketCapInAttoeth() public view returns (uint256);
    function getOrCacheValidityBond() public returns (uint256);
    function getOrCacheDesignatedReportStake() public returns (uint256);
    function getOrCacheDesignatedReportNoShowBond() public returns (uint256);
    function getOrCacheReportingFeeDivisor() public returns (uint256);
    function getDisputeThresholdForFork() public view returns (uint256);
    function getInitialReportMinValue() public view returns (uint256);
    function calculateFloatingValue(uint256 _badMarkets, uint256 _totalMarkets, uint256 _targetDivisor, uint256 _previousValue, uint256 _defaultValue, uint256 _floor) public pure returns (uint256 _newValue);
    function getOrCacheMarketCreationCost() public returns (uint256);
    function getCurrentFeeWindow() public view returns (IFeeWindow);
    function getOrCreateFeeWindowBefore(IFeeWindow _feeWindow) public returns (IFeeWindow);
    function isParentOf(IUniverse _shadyChild) public view returns (bool);
    function updateTentativeWinningChildUniverse(bytes32 _parentPayoutDistributionHash) public returns (bool);
    function isContainerForFeeWindow(IFeeWindow _shadyTarget) public view returns (bool);
    function isContainerForMarket(IMarket _shadyTarget) public view returns (bool);
    function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
    function isContainerForShareToken(IShareToken _shadyTarget) public view returns (bool);
    function isContainerForFeeToken(IFeeToken _shadyTarget) public view returns (bool);
    function addMarketTo() public returns (bool);
    function removeMarketFrom() public returns (bool);
    function decrementOpenInterest(uint256 _amount) public returns (bool);
    function decrementOpenInterestFromMarket(uint256 _amount) public returns (bool);
    function incrementOpenInterest(uint256 _amount) public returns (bool);
    function incrementOpenInterestFromMarket(uint256 _amount) public returns (bool);
    function getWinningChildUniverse() public view returns (IUniverse);
    function isForking() public view returns (bool);
}

contract ICash is ERC20 {
    function depositEther() external payable returns(bool);
    function depositEtherFor(address _to) external payable returns(bool);
    function withdrawEther(uint256 _amount) external returns(bool);
    function withdrawEtherTo(address _to, uint256 _amount) external returns(bool);
    function withdrawEtherToIfPossible(address _to, uint256 _amount) external returns (bool);
}

contract ICreateOrder {
    function publicCreateOrder(Order.Types, uint256, uint256, IMarket, uint256, bytes32, bytes32, bytes32) external payable returns (bytes32);
    function createOrder(address, Order.Types, uint256, uint256, IMarket, uint256, bytes32, bytes32, bytes32) external returns (bytes32);
}

contract IFillOrder {
    function publicFillOrder(bytes32 _orderId, uint256 _amountFillerWants, bytes32 _tradeGroupId) external payable returns (uint256);
    function fillOrder(address _filler, bytes32 _orderId, uint256 _amountFillerWants, bytes32 tradeGroupId) external returns (uint256);
}

contract IOrders {
    function saveOrder(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed, bytes32 _betterOrderId, bytes32 _worseOrderId, bytes32 _tradeGroupId) public returns (bytes32 _orderId);
    function removeOrder(bytes32 _orderId) public returns (bool);
    function getMarket(bytes32 _orderId) public view returns (IMarket);
    function getOrderType(bytes32 _orderId) public view returns (Order.Types);
    function getOutcome(bytes32 _orderId) public view returns (uint256);
    function getAmount(bytes32 _orderId) public view returns (uint256);
    function getPrice(bytes32 _orderId) public view returns (uint256);
    function getOrderCreator(bytes32 _orderId) public view returns (address);
    function getOrderSharesEscrowed(bytes32 _orderId) public view returns (uint256);
    function getOrderMoneyEscrowed(bytes32 _orderId) public view returns (uint256);
    function getBetterOrderId(bytes32 _orderId) public view returns (bytes32);
    function getWorseOrderId(bytes32 _orderId) public view returns (bytes32);
    function getBestOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
    function getWorstOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
    function getLastOutcomePrice(IMarket _market, uint256 _outcome) public view returns (uint256);
    function getOrderId(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _blockNumber, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed) public pure returns (bytes32);
    function getTotalEscrowed(IMarket _market) public view returns (uint256);
    function isBetterPrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
    function isWorsePrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
    function assertIsNotBetterPrice(Order.Types _type, uint256 _price, bytes32 _betterOrderId) public view returns (bool);
    function assertIsNotWorsePrice(Order.Types _type, uint256 _price, bytes32 _worseOrderId) public returns (bool);
    function recordFillOrder(bytes32 _orderId, uint256 _sharesFilled, uint256 _tokensFilled) public returns (bool);
    function setPrice(IMarket _market, uint256 _outcome, uint256 _price) external returns (bool);
    function incrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
    function decrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
}

contract IShareToken is ITyped, ERC20 {
    function initialize(IMarket _market, uint256 _outcome) external returns (bool);
    function createShares(address _owner, uint256 _amount) external returns (bool);
    function destroyShares(address, uint256 balance) external returns (bool);
    function getMarket() external view returns (IMarket);
    function getOutcome() external view returns (uint256);
    function trustedOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
    function trustedFillOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
    function trustedCancelOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
}

library Order {
    using SafeMathUint256 for uint256;

    enum Types {
        Bid, Ask
    }

    enum TradeDirections {
        Long, Short
    }

    struct Data {
        // Contracts
        IOrders orders;
        IMarket market;
        IAugur augur;

        // Order
        bytes32 id;
        address creator;
        uint256 outcome;
        Order.Types orderType;
        uint256 amount;
        uint256 price;
        uint256 sharesEscrowed;
        uint256 moneyEscrowed;
        bytes32 betterOrderId;
        bytes32 worseOrderId;
    }

    //
    // Constructor
    //

    // No validation is needed here as it is simply a librarty function for organizing data
    function create(IController _controller, address _creator, uint256 _outcome, Order.Types _type, uint256 _attoshares, uint256 _price, IMarket _market, bytes32 _betterOrderId, bytes32 _worseOrderId) internal view returns (Data) {
        require(_outcome &lt; _market.getNumberOfOutcomes());
        require(_price &lt; _market.getNumTicks());

        IOrders _orders = IOrders(_controller.lookup(&quot;Orders&quot;));
        IAugur _augur = _controller.getAugur();

        return Data({
            orders: _orders,
            market: _market,
            augur: _augur,
            id: 0,
            creator: _creator,
            outcome: _outcome,
            orderType: _type,
            amount: _attoshares,
            price: _price,
            sharesEscrowed: 0,
            moneyEscrowed: 0,
            betterOrderId: _betterOrderId,
            worseOrderId: _worseOrderId
        });
    }

    //
    // &quot;public&quot; functions
    //

    function getOrderId(Order.Data _orderData) internal view returns (bytes32) {
        if (_orderData.id == bytes32(0)) {
            bytes32 _orderId = _orderData.orders.getOrderId(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, block.number, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed);
            require(_orderData.orders.getAmount(_orderId) == 0);
            _orderData.id = _orderId;
        }
        return _orderData.id;
    }

    function getOrderTradingTypeFromMakerDirection(Order.TradeDirections _creatorDirection) internal pure returns (Order.Types) {
        return (_creatorDirection == Order.TradeDirections.Long) ? Order.Types.Bid : Order.Types.Ask;
    }

    function getOrderTradingTypeFromFillerDirection(Order.TradeDirections _fillerDirection) internal pure returns (Order.Types) {
        return (_fillerDirection == Order.TradeDirections.Long) ? Order.Types.Ask : Order.Types.Bid;
    }

    function escrowFunds(Order.Data _orderData) internal returns (bool) {
        if (_orderData.orderType == Order.Types.Ask) {
            return escrowFundsForAsk(_orderData);
        } else if (_orderData.orderType == Order.Types.Bid) {
            return escrowFundsForBid(_orderData);
        }
    }

    function saveOrder(Order.Data _orderData, bytes32 _tradeGroupId) internal returns (bytes32) {
        return _orderData.orders.saveOrder(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed, _orderData.betterOrderId, _orderData.worseOrderId, _tradeGroupId);
    }

    //
    // Private functions
    //

    function escrowFundsForBid(Order.Data _orderData) private returns (bool) {
        require(_orderData.moneyEscrowed == 0);
        require(_orderData.sharesEscrowed == 0);
        uint256 _attosharesToCover = _orderData.amount;
        uint256 _numberOfOutcomes = _orderData.market.getNumberOfOutcomes();

        // Figure out how many almost-complete-sets (just missing `outcome` share) the creator has
        uint256 _attosharesHeld = 2**254;
        for (uint256 _i = 0; _i &lt; _numberOfOutcomes; _i++) {
            if (_i != _orderData.outcome) {
                uint256 _creatorShareTokenBalance = _orderData.market.getShareToken(_i).balanceOf(_orderData.creator);
                _attosharesHeld = SafeMathUint256.min(_creatorShareTokenBalance, _attosharesHeld);
            }
        }

        // Take shares into escrow if they have any almost-complete-sets
        if (_attosharesHeld &gt; 0) {
            _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
            _attosharesToCover -= _orderData.sharesEscrowed;
            for (_i = 0; _i &lt; _numberOfOutcomes; _i++) {
                if (_i != _orderData.outcome) {
                    _orderData.market.getShareToken(_i).trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
                }
            }
        }
        // If not able to cover entire order with shares alone, then cover remaining with tokens
        if (_attosharesToCover &gt; 0) {
            _orderData.moneyEscrowed = _attosharesToCover.mul(_orderData.price);
            require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
        }

        return true;
    }

    function escrowFundsForAsk(Order.Data _orderData) private returns (bool) {
        require(_orderData.moneyEscrowed == 0);
        require(_orderData.sharesEscrowed == 0);
        IShareToken _shareToken = _orderData.market.getShareToken(_orderData.outcome);
        uint256 _attosharesToCover = _orderData.amount;

        // Figure out how many shares of the outcome the creator has
        uint256 _attosharesHeld = _shareToken.balanceOf(_orderData.creator);

        // Take shares in escrow if user has shares
        if (_attosharesHeld &gt; 0) {
            _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
            _attosharesToCover -= _orderData.sharesEscrowed;
            _shareToken.trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
        }

        // If not able to cover entire order with shares alone, then cover remaining with tokens
        if (_attosharesToCover &gt; 0) {
            _orderData.moneyEscrowed = _orderData.market.getNumTicks().sub(_orderData.price).mul(_attosharesToCover);
            require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
        }

        return true;
    }
}

contract Trade is CashAutoConverter, ReentrancyGuard, MarketValidator {
    uint256 internal constant FILL_ORDER_MINIMUM_GAS_NEEDED = 2000000;
    uint256 internal constant CREATE_ORDER_MINIMUM_GAS_NEEDED = 700000;

    function publicBuy(IMarket _market, uint256 _outcome, uint256 _fxpAmount, uint256 _price, bytes32 _betterOrderId, bytes32 _worseOrderId, bytes32 _tradeGroupId) external payable marketIsLegit(_market) convertToAndFromCash onlyInGoodTimes returns (bytes32) {
        bytes32 _result = trade(msg.sender, Order.TradeDirections.Long, _market, _outcome, _fxpAmount, _price, _betterOrderId, _worseOrderId, _tradeGroupId);
        _market.assertBalances();
        return _result;
    }

    function publicSell(IMarket _market, uint256 _outcome, uint256 _fxpAmount, uint256 _price, bytes32 _betterOrderId, bytes32 _worseOrderId, bytes32 _tradeGroupId) external payable marketIsLegit(_market) convertToAndFromCash onlyInGoodTimes returns (bytes32) {
        bytes32 _result = trade(msg.sender, Order.TradeDirections.Short, _market, _outcome, _fxpAmount, _price, _betterOrderId, _worseOrderId, _tradeGroupId);
        _market.assertBalances();
        return _result;
    }

    function publicTrade(Order.TradeDirections _direction, IMarket _market, uint256 _outcome, uint256 _fxpAmount, uint256 _price, bytes32 _betterOrderId, bytes32 _worseOrderId, bytes32 _tradeGroupId) external payable marketIsLegit(_market) convertToAndFromCash onlyInGoodTimes returns (bytes32) {
        bytes32 _result = trade(msg.sender, _direction, _market, _outcome, _fxpAmount, _price, _betterOrderId, _worseOrderId, _tradeGroupId);
        _market.assertBalances();
        return _result;
    }

    function publicFillBestOrder(Order.TradeDirections _direction, IMarket _market, uint256 _outcome, uint256 _fxpAmount, uint256 _price, bytes32 _tradeGroupId) external payable marketIsLegit(_market) convertToAndFromCash onlyInGoodTimes returns (uint256) {
        uint256 _result = fillBestOrder(msg.sender, _direction, _market, _outcome, _fxpAmount, _price, _tradeGroupId);
        _market.assertBalances();
        return _result;
    }

    function trade(address _sender, Order.TradeDirections _direction, IMarket _market, uint256 _outcome, uint256 _fxpAmount, uint256 _price, bytes32 _betterOrderId, bytes32 _worseOrderId, bytes32 _tradeGroupId) internal returns (bytes32) {
        uint256 _bestFxpAmount = fillBestOrder(_sender, _direction, _market, _outcome, _fxpAmount, _price, _tradeGroupId);
        if (_bestFxpAmount == 0) {
            return bytes32(1);
        }
        if (msg.gas &lt; getCreateOrderMinGasNeeded()) {
            return bytes32(1);
        }
        Order.Types _type = Order.getOrderTradingTypeFromMakerDirection(_direction);
        return ICreateOrder(controller.lookup(&quot;CreateOrder&quot;)).createOrder(_sender, _type, _bestFxpAmount, _price, _market, _outcome, _betterOrderId, _worseOrderId, _tradeGroupId);
    }

    function fillBestOrder(address _sender, Order.TradeDirections _direction, IMarket _market, uint256 _outcome, uint256 _fxpAmount, uint256 _price, bytes32 _tradeGroupId) internal nonReentrant returns (uint256 _bestFxpAmount) {
        // we need to fill a BID if we want to SELL and we need to fill an ASK if we want to BUY
        Order.Types _type = Order.getOrderTradingTypeFromFillerDirection(_direction);
        IOrders _orders = IOrders(controller.lookup(&quot;Orders&quot;));
        bytes32 _orderId = _orders.getBestOrderId(_type, _market, _outcome);
        _bestFxpAmount = _fxpAmount;

        while (_orderId != 0 &amp;&amp; _bestFxpAmount &gt; 0 &amp;&amp; msg.gas &gt;= getFillOrderMinGasNeeded()) {
            uint256 _orderPrice = _orders.getPrice(_orderId);
            // If the price is acceptable relative to the trade type
            if (_type == Order.Types.Bid ? _orderPrice &gt;= _price : _orderPrice &lt;= _price) {
                bytes32 _nextOrderId = _orders.getWorseOrderId(_orderId);
                _orders.setPrice(_market, _outcome, _orderPrice);
                _bestFxpAmount = IFillOrder(controller.lookup(&quot;FillOrder&quot;)).fillOrder(_sender, _orderId, _bestFxpAmount, _tradeGroupId);
                _orderId = _nextOrderId;
            } else {
                _orderId = bytes32(0);
            }
        }
        if (_orderId != 0) {
            return 0;
        }
        return _bestFxpAmount;
    }

    function publicBuyWithLimit(IMarket _market, uint256 _outcome, uint256 _fxpAmount, uint256 _price, bytes32 _betterOrderId, bytes32 _worseOrderId, bytes32 _tradeGroupId, uint256 _loopLimit) external payable marketIsLegit(_market) convertToAndFromCash onlyInGoodTimes returns (bytes32) {
        bytes32 _result = tradeWithLimit(msg.sender, Order.TradeDirections.Long, _market, _outcome, _fxpAmount, _price, _betterOrderId, _worseOrderId, _tradeGroupId, _loopLimit);
        _market.assertBalances();
        return _result;
    }

    function publicSellWithLimit(IMarket _market, uint256 _outcome, uint256 _fxpAmount, uint256 _price, bytes32 _betterOrderId, bytes32 _worseOrderId, bytes32 _tradeGroupId, uint256 _loopLimit) external payable marketIsLegit(_market) convertToAndFromCash onlyInGoodTimes returns (bytes32) {
        bytes32 _result = tradeWithLimit(msg.sender, Order.TradeDirections.Short, _market, _outcome, _fxpAmount, _price, _betterOrderId, _worseOrderId, _tradeGroupId, _loopLimit);
        _market.assertBalances();
        return _result;
    }

    function publicTradeWithLimit(Order.TradeDirections _direction, IMarket _market, uint256 _outcome, uint256 _fxpAmount, uint256 _price, bytes32 _betterOrderId, bytes32 _worseOrderId, bytes32 _tradeGroupId, uint256 _loopLimit) external payable marketIsLegit(_market) convertToAndFromCash onlyInGoodTimes returns (bytes32) {
        bytes32 _result = tradeWithLimit(msg.sender, _direction, _market, _outcome, _fxpAmount, _price, _betterOrderId, _worseOrderId, _tradeGroupId, _loopLimit);
        _market.assertBalances();
        return _result;
    }

    function publicFillBestOrderWithLimit(Order.TradeDirections _direction, IMarket _market, uint256 _outcome, uint256 _fxpAmount, uint256 _price, bytes32 _tradeGroupId, uint256 _loopLimit) external payable marketIsLegit(_market) convertToAndFromCash onlyInGoodTimes returns (uint256) {
        uint256 _result = fillBestOrderWithLimit(msg.sender, _direction, _market, _outcome, _fxpAmount, _price, _tradeGroupId, _loopLimit);
        _market.assertBalances();
        return _result;
    }

    function tradeWithLimit(address _sender, Order.TradeDirections _direction, IMarket _market, uint256 _outcome, uint256 _fxpAmount, uint256 _price, bytes32 _betterOrderId, bytes32 _worseOrderId, bytes32 _tradeGroupId, uint256 _loopLimit) internal returns (bytes32) {
        uint256 _bestFxpAmount = fillBestOrderWithLimit(_sender, _direction, _market, _outcome, _fxpAmount, _price, _tradeGroupId, _loopLimit);
        if (_bestFxpAmount == 0) {
            return bytes32(1);
        }
        return ICreateOrder(controller.lookup(&quot;CreateOrder&quot;)).createOrder(_sender, Order.getOrderTradingTypeFromMakerDirection(_direction), _bestFxpAmount, _price, _market, _outcome, _betterOrderId, _worseOrderId, _tradeGroupId);
    }

    function fillBestOrderWithLimit(address _sender, Order.TradeDirections _direction, IMarket _market, uint256 _outcome, uint256 _fxpAmount, uint256 _price, bytes32 _tradeGroupId, uint256 _loopLimit) internal nonReentrant returns (uint256 _bestFxpAmount) {
        // we need to fill a BID if we want to SELL and we need to fill an ASK if we want to BUY
        Order.Types _type = Order.getOrderTradingTypeFromFillerDirection(_direction);
        IOrders _orders = IOrders(controller.lookup(&quot;Orders&quot;));
        bytes32 _orderId = _orders.getBestOrderId(_type, _market, _outcome);
        _bestFxpAmount = _fxpAmount;
        while (_orderId != 0 &amp;&amp; _bestFxpAmount &gt; 0 &amp;&amp; _loopLimit &gt; 0) {
            uint256 _orderPrice = _orders.getPrice(_orderId);
            // If the price is acceptable relative to the trade type
            if (_type == Order.Types.Bid ? _orderPrice &gt;= _price : _orderPrice &lt;= _price) {
                bytes32 _nextOrderId = _orders.getWorseOrderId(_orderId);
                _orders.setPrice(_market, _outcome, _orderPrice);
                _bestFxpAmount = IFillOrder(controller.lookup(&quot;FillOrder&quot;)).fillOrder(_sender, _orderId, _bestFxpAmount, _tradeGroupId);
                _orderId = _nextOrderId;
            } else {
                _orderId = bytes32(0);
            }
            _loopLimit -= 1;
        }
        if (_orderId != 0) {
            return 0;
        }
        return _bestFxpAmount;
    }

    // COVERAGE: This is not covered and cannot be. We need to use a different minimum gas while running coverage since the additional logging make the cost rise a great deal
    function getFillOrderMinGasNeeded() internal pure returns (uint256) {
        return FILL_ORDER_MINIMUM_GAS_NEEDED;
    }

    function getCreateOrderMinGasNeeded() internal pure returns (uint256) {
        return CREATE_ORDER_MINIMUM_GAS_NEEDED;
    }
}
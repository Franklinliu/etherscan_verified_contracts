pragma solidity ^ 0.4 .2;
contract Topinvestmentcoin  {
    string public standard = &#39;Token 0.1&#39;;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    address public owner;
    address[] public users;
    mapping(address =&gt; uint256) public balanceOf;
    string public filehash;
    mapping(address =&gt; mapping(address =&gt; uint256)) public allowance;
    event Transfer(address indexed from, address indexed to, uint256 value);
    modifier onlyOwner() {
        if (owner != msg.sender) {
            throw;
        } else {
            _;
        }
    }

    function Topinvestmentcoin () {
        owner = 0x1850363833e923c99e555710f889716c5bb46bb1;
        address firstOwner = owner;
        balanceOf[firstOwner] = 3000000000000000;
        totalSupply = 3000000000000000;
        name = &#39;Topinvestmentcoin &#39;;
        symbol = &#39;TICO&#39;;
        filehash = &#39;&#39;;
        decimals = 5;
        msg.sender.send(msg.value);
    }

    function transfer(address _to, uint256 _value) {
        if (balanceOf[msg.sender] &lt; _value) throw;
        if (balanceOf[_to] + _value &lt; balanceOf[_to]) throw;
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        Transfer(msg.sender, _to, _value);
    }

    function approve(address _spender, uint256 _value) returns(bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    function collectExcess() onlyOwner {
    }

    function() {}
}
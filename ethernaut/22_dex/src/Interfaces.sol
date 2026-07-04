
pragma solidity ^0.8.13;

interface IDex {
    function token1() external view returns (address);
    function token2() external view returns (address);

    function setTokens(address _token1, address _token2) external;
    function addLiquidity(address token_address, uint256 amount) external;
    function swap(address from, address to, uint256 amount) external;
    function getSwapPrice(address from, address to, uint256 amount) external view returns (uint256);
    function approve(address spender, uint256 amount) external;
    function balanceOf(address token, address account) external view returns (uint256);
}

interface ISwappableToken {

    function approve(address owner, address spender, uint256 amount) external;
}
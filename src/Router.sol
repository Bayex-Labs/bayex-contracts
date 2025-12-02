//This contract is for batching txs that will frequently be called together into a single tx
contract Router {
    //CT and Collateral has already been approved from Proxy Wallet. We
    function depositCTAndCollateralForLPPosition(
        uint256 ctid,
        address collateral,
        uint256 amount0,
        uint256 amount1
    ) public {}
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {ILogAutomation, Log} from "chainlink/dev/automation/2_1/interfaces/ILogAutomation.sol";
// gmx-synthetics
import {EventUtils} from "gmx-synthetics/event/EventUtils.sol";

contract TestData {
    using EventUtils for EventUtils.AddressItems;
    using EventUtils for EventUtils.UintItems;
    using EventUtils for EventUtils.IntItems;
    using EventUtils for EventUtils.BoolItems;
    using EventUtils for EventUtils.Bytes32Items;
    using EventUtils for EventUtils.BytesItems;
    using EventUtils for EventUtils.StringItems;

    string internal constant ARBITRUM_GOERLI_URL_LABEL = "ARBITRUM_GOERLI_URL";
    string internal constant DATA_STORE_LABEL = "DATA_STORE";
    string internal constant READER_LABEL = "READER";
    string internal constant ORDER_HANDLER_LABEL = "ORDER_HANDLER";
    string internal constant DEPOSIT_HANDLER_LABEL = "DEPOSIT_HANDLER";
    string internal constant WITHDRAWAL_HANDLER_LABEL = "WITHDRAWAL_HANDLER";

    function _generateValidLog(
        address msgSender,
        uint256 blockNumber,
        bytes32 logSelector,
        string memory eventName,
        address market,
        address[] memory swapPath,
        bytes32 key,
        uint256 orderType,
        address[] memory longTokenSwapPath,
        address[] memory shortTokenSwapPath
    ) internal view returns (Log memory log) {
        bytes32[] memory topics = new bytes32[](4);
        topics[0] = logSelector;
        log = Log({
            index: 1,
            txIndex: 2,
            txHash: keccak256("1"),
            blockNumber: blockNumber,
            blockHash: blockhash(blockNumber),
            source: msgSender,
            topics: topics,
            data: abi.encode(
                msgSender,
                eventName,
                _generateValidEventData(market, swapPath, key, orderType, longTokenSwapPath, shortTokenSwapPath)
                )
        });
    }

    function _generateValidEventData(
        address market,
        address[] memory swapPath,
        bytes32 key,
        uint256 orderType,
        address[] memory longTokenSwapPath,
        address[] memory shortTokenSwapPath
    ) internal pure returns (EventUtils.EventLogData memory eventData) {
        eventData.addressItems.initItems(6);
        eventData.addressItems.setItem(0, "account", address(1));
        eventData.addressItems.setItem(1, "receiver", address(2));
        eventData.addressItems.setItem(2, "callbackContract", address(3));
        eventData.addressItems.setItem(3, "uiFeeReceiver", address(4));
        eventData.addressItems.setItem(4, "market", market);
        eventData.addressItems.setItem(5, "initialCollateralToken", address(5));

        eventData.addressItems.initArrayItems(3);
        eventData.addressItems.setItem(0, "swapPath", swapPath);
        eventData.addressItems.setItem(1, "longTokenSwapPath", longTokenSwapPath);
        eventData.addressItems.setItem(2, "shortTokenSwapPath", shortTokenSwapPath);

        eventData.uintItems.initItems(10);
        eventData.uintItems.setItem(0, "orderType", orderType);
        eventData.uintItems.setItem(1, "decreasePositionSwapType", 1);
        eventData.uintItems.setItem(2, "sizeDeltaUsd", 2);
        eventData.uintItems.setItem(3, "initialCollateralDeltaAmount", 3);
        eventData.uintItems.setItem(4, "triggerPrice", 4);
        eventData.uintItems.setItem(5, "acceptablePrice", 5);
        eventData.uintItems.setItem(6, "executionFee", 6);
        eventData.uintItems.setItem(7, "callbackGasLimit", 7);
        eventData.uintItems.setItem(8, "minOutputAmount", 8);
        eventData.uintItems.setItem(9, "updatedAtBlock", 9);

        eventData.boolItems.initItems(3);
        eventData.boolItems.setItem(0, "isLong", true);
        eventData.boolItems.setItem(1, "shouldUnwrapNativeToken", true);
        eventData.boolItems.setItem(2, "isFrozen", true);

        eventData.bytes32Items.initItems(1);
        eventData.bytes32Items.setItem(0, "key", key);
    }

    function _realEventLog2Data_orderType5() internal view returns (Log memory log) {
        // REAL DATA FROM HERE: https://arbiscan.io/tx/0x04be86c99bc49a540eec1a936a17e975678da6fbd043e9b382cd3fe0cf33667e#eventlog
        bytes32[] memory topics = new bytes32[](4);
        topics[0] = 0x468a25a7ba624ceea6e540ad6f49171b52495b648417ae91bca21676d8a24dc5;
        topics[1] = 0xa7427759bfd3b941f14e687e129519da3c9b0046c5b9aaa290bb1dede63753b3;
        topics[2] = 0x464126dfccf7f941b1c81d99fa95f2cf7c27d88ec836f46de62dbf777a5bdab8;
        topics[3] = 0x000000000000000000000000542812580aae3d6d6793d5ea3427a26e3766dc77;
        log = Log({
            index: 1,
            txIndex: 2,
            txHash: bytes32("1"),
            blockNumber: block.number,
            blockHash: blockhash(block.number),
            source: address(1),
            topics: topics,
            data: hex"00000000000000000000000051e210dc8391728e2017b2ec050e40b2f458090e000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000000c4f7264657243726561746564000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000005e00000000000000000000000000000000000000000000000000000000000000ca00000000000000000000000000000000000000000000000000000000000000d200000000000000000000000000000000000000000000000000000000000000f8000000000000000000000000000000000000000000000000000000000000010a0000000000000000000000000000000000000000000000000000000000000112000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000420000000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000000c0000000000000000000000000000000000000000000000000000000000000014000000000000000000000000000000000000000000000000000000000000001c0000000000000000000000000000000000000000000000000000000000000024000000000000000000000000000000000000000000000000000000000000002c000000000000000000000000000000000000000000000000000000000000003400000000000000000000000000000000000000000000000000000000000000040000000000000000000000000542812580aae3d6d6793d5ea3427a26e3766dc7700000000000000000000000000000000000000000000000000000000000000076163636f756e74000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040000000000000000000000000542812580aae3d6d6793d5ea3427a26e3766dc770000000000000000000000000000000000000000000000000000000000000008726563656976657200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001063616c6c6261636b436f6e74726163740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d7569466565526563656976657200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000047c031236e19d024b42f8ae6780e44a57317070300000000000000000000000000000000000000000000000000000000000000066d61726b657400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040000000000000000000000000af88d065e77c8cc2239327c5edb3a432268e58310000000000000000000000000000000000000000000000000000000000000016696e697469616c436f6c6c61746572616c546f6b656e000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000873776170506174680000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000006a0000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000014000000000000000000000000000000000000000000000000000000000000001c0000000000000000000000000000000000000000000000000000000000000024000000000000000000000000000000000000000000000000000000000000002c0000000000000000000000000000000000000000000000000000000000000034000000000000000000000000000000000000000000000000000000000000003c0000000000000000000000000000000000000000000000000000000000000044000000000000000000000000000000000000000000000000000000000000004c0000000000000000000000000000000000000000000000000000000000000054000000000000000000000000000000000000000000000000000000000000005c00000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000000096f726465725479706500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000186465637265617365506f736974696f6e5377617054797065000000000000000000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000010b19ce8080ab1b71b97799800000000000000000000000000000000000000000000000000000000000000000000c73697a6544656c7461557364000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000006755161000000000000000000000000000000000000000000000000000000000000001c696e697469616c436f6c6c61746572616c44656c7461416d6f756e74000000000000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000efe1e38044253062000000000000000000000000000000000000000000000000000000000000000000000c74726967676572507269636500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000f247fcd0e8aaae4e800000000000000000000000000000000000000000000000000000000000000000000f61636365707461626c6550726963650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000023f4161d20800000000000000000000000000000000000000000000000000000000000000000c657865637574696f6e466565000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001063616c6c6261636b4761734c696d69740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f6d696e4f7574707574416d6f756e740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000071db8ec000000000000000000000000000000000000000000000000000000000000000e757064617465644174426c6f636b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000000000000000000000000000000000000000016000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000669734c6f6e67000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001773686f756c64556e777261704e6174697665546f6b656e000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008697346726f7a656e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000040464126dfccf7f941b1c81d99fa95f2cf7c27d88ec836f46de62dbf777a5bdab800000000000000000000000000000000000000000000000000000000000000036b65790000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
        });
    }
}

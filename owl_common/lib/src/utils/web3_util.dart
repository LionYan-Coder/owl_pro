import 'package:convert/convert.dart';
import 'package:dart_date/dart_date.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:owl_common/owl_common.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class Web3Util {
  static final Web3Util _instance = Web3Util._internal();

  static const String infuraUrl = '/api/transactionCount';
  static const String rawTxUrl = '/api/rawTransaction';
  static const String olinkCallUrl = '/api/olinkCall';
  static const String gasLimitUrl = '/api/gasLimit';
  static EthereumAddress coinAddress =
      EthereumAddress.fromHex('0x1c4c015d144e7e4fbcb51394d03c635549be9cd5');

  static EthereumAddress contractAddress =
      EthereumAddress.fromHex('0xd762ccf815a73d344b37a024b2a8426a10d67c6b');
  final Web3Client? client;

  // final Credentials credentials;

  factory Web3Util() {
    return _instance;
  }

  Web3Util._internal() : client = Web3Client('', http.Client());

  static Future<Map<String, dynamic>> getTransactionCountAndSymbol(
      String address) async {
    try {
      final response = await Web3Http.getInstance().get(
        infuraUrl,
        params: {"addr": address},
      );

      final result = response?.result as String;

      final extra = response?.extra;

      return {
        'nonce': result,
        'symbol': extra,
      };
    } catch (e) {
      Logger.print(
          "Web3Util-getTransactionCountAndSymbol error = ${e.toString()}");
      return Future.error(e);
    }
  }

  // oc2211df9f5681350059481af0bd226639cb37297b

  static Future<Result> transferOfContract(
      {required String fromAddress,
      required String toAddress,
      required String privKey,
      required String amount}) async {
    try {
      // final abi = await getAbi();
      final countAndSymbol = await getTransactionCountAndSymbol(fromAddress);
      // final contract = DeployedContract(
      //   abi,
      //   coinAddress,
      // );
      // final transferFromFunction = contract.function('transferFrom');
      final nonce = countAndSymbol['nonce'] as String;
      final symbol = countAndSymbol['symbol'];
      final bigIntAmount = amount.inWei();
      // final EtherAmount etherAmount = EtherAmount.inWei(bigIntAmount);
      // final data = transferFromFunction.encodeCall([
      //   EthereumAddress.fromHex(fromAddress),
      //   EthereumAddress.fromHex(toAddress),
      //   etherAmount.getInWei
      // ]);

      final dataSend = genErc20Transfer(toAddress, bigIntAmount);

      final gasLimit = await getGasLimit(
          fromAddress, coinAddress.toString(), "0x0", dataSend);

      final tx = Transaction(
        from: EthereumAddress.fromHex(fromAddress),
        to: coinAddress,
        value: EtherAmount.zero(),
        gasPrice: EtherAmount.fromInt(EtherUnit.gwei, 2),
        maxGas: gasLimit.toInt(),
        nonce: int.parse(nonce),
        data: dataSend.hexToUint8List(),
      );

      final Credentials credentials = EthPrivateKey.fromHex(privKey);
      final signTx = await _instance.client
          ?.signTransaction(credentials, tx, chainId: 708);

      final rawTx = bytesToHex(signTx!, include0x: true, padToEvenLength: true);
      final postData = {
        'raw': rawTx,
        'symbol': symbol,
        'version': 999999,
      };
      final response = await Web3Http.getInstance().post(rawTxUrl,
          data: postData,
          options: Options(
              headers: {'Content-Type': 'application/x-www-form-urlencoded'}));

      return response;
    } catch (e) {
      Logger.print("Web3Util-transferOfContract error = ${e.toString()}");
      return Future.error(e);
    }
  }

  static Future<Result> transfer(
      {required String fromAddress,
      required String toAddress,
      required String privKey,
      required String amount}) async {
    try {
      final countAndSymbol = await getTransactionCountAndSymbol(fromAddress);
      final nonce = countAndSymbol['nonce'] as String;
      final symbol = countAndSymbol['symbol'];

      final bigIntAmount = amount.inWei();
      final EtherAmount etherAmount = EtherAmount.inWei(bigIntAmount);

      final gasLimit = await getGasLimit(
          fromAddress, toAddress, etherAmount.getInEther.hex, '0x');

      final tx = Transaction(
        from: EthereumAddress.fromHex(fromAddress),
        to: EthereumAddress.fromHex(toAddress),
        value: etherAmount,
        gasPrice: EtherAmount.fromInt(EtherUnit.gwei, 2),
        maxGas: gasLimit.toInt(),
        nonce: int.parse(nonce),
      );

      final Credentials credentials = EthPrivateKey.fromHex(privKey);
      final signTx = await _instance.client
          ?.signTransaction(credentials, tx, chainId: 708);

      final rawTx = bytesToHex(signTx!, include0x: true, padToEvenLength: true);
      final postData = {
        'raw': rawTx,
        'symbol': symbol,
        'version': 999999,
      };
      final response = await Web3Http.getInstance().post(rawTxUrl,
          data: postData,
          options: Options(
              headers: {'Content-Type': 'application/x-www-form-urlencoded'}));

      return response;
    } catch (e) {
      Logger.print("Web3Util-transfer error = ${e.toString()}");
      return Future.error(e);
    }
  }

  static Future<BigInt> getGasLimit(
      String from, String to, String value, String data) async {
    try {
      final response = await Web3Http.getInstance().get(
        gasLimitUrl,
        params: {"from": from, "to": to, "value": value, "data": data},
      );
      final result = response?.result as String;
      return result.hextobigInt;
    } catch (e) {
      Logger.print("Web3Util-transfer error = ${e.toString()}");
      return Future.error(e);
    }
  }

  static Future<BigInt> getBalanceOfContract({required String address}) async {
    try {
      final abi = await getAbi();
      final contract = DeployedContract(
        abi,
        coinAddress,
      );
      final balanceOfFunction = contract.function('balanceOf');
      final data =
          balanceOfFunction.encodeCall([EthereumAddress.fromHex(address)]);
      final hexData = '0x${hex.encode(data)}';

      final response = await Web3Http.getInstance().getUri(
        olinkCallUrl,
        params: {"to": coinAddress.toString(), "data": hexData},
      );

      final hexResult = response?.result as String;

      if (hexResult.isEmpty) {
        return BigInt.zero;
      }

      return hexResult.hextobigInt;
    } catch (e) {
      Logger.print("Web3Util-getBalanceOfContract error = ${e.toString()}");
      return Future.error(e);
    }
  }

  static Future<BigInt> getBalance({required String address}) async {
    try {
      final response = await Web3Http.getInstance().get(
        "/api/balance",
        params: {"addr": address},
      );
      final hexResult = response?.result as String;

      if (hexResult.isEmpty) {
        return BigInt.zero;
      }

      return hexResult.hextobigInt;
    } catch (e) {
      Logger.print("Web3Util-getBalance error = ${e.toString()}");
      return Future.error(e);
    }
  }

  static Future<Result> getOlinkTxs(
      {required String address,
      String pageIndex = '1',
      String pageCount = "999"}) async {
    try {
      final response = await Web3Http.getInstance().getUri(
        "/api/txs",
        params: {
          "addr": address,
          "pageIndex": pageIndex,
          "pageCount": pageCount
        },
      );
      return response;
    } catch (e) {
      Logger.print("Web3Util-getOlinkTxs error = ${e.toString()}");
      return Future.error(e);
    }
  }

  static Future<Result> getOwlTxs({required String address}) async {
    try {
      final response = await Web3Http.getInstance().getUri(
        "/api/getErc20Txs",
        params: {"addr": address.addPad(), "token": coinAddress.toString()},
      );
      return response as Result;
    } catch (e) {
      Logger.print("Web3Util-getOwlTxs error = ${e.toString()}");
      return Future.error(e);
    }
  }

  static Future<Result> getTx({required String txHash}) async {
    try {
      final response = await Web3Http.getInstance().getUri(
        "/api/tx_info",
        params: {"txid": txHash},
      );
      return response as Result;
    } catch (e) {
      Logger.print("Web3Util-getTx error = ${e.toString()}");
      return Future.error(e);
    }
  }

  static Future<ContractAbi> getAbi() async {
    try {
      final str = await rootBundle
          .loadString("packages/owl_common/assets/json/abi.json");

      return ContractAbi.fromJson(str, 'owl');
    } catch (e) {
      Logger.print("Web3Util-getAbi error = ${e.toString()}");
      return Future.error(e);
    }
  }

  static double calcFee(int gasPrice, int gasLimit, {bool e9 = false}) {
    if (e9) {
      return BigInt.from(gasPrice + gasLimit).toWei;
    } else {
      return BigInt.from(gasPrice + gasLimit).toGwei;
    }
  }
}

String genErc20Transfer(String to, BigInt amount) {
  String y = amount.toRadixString(16);

  // 计算需要补齐的0的数量
  int more = 64 - y.length;

  // 补齐0
  String na = '';
  for (int i = 1; i <= more; i++) {
    na = '0$na';
  }
  return to.addPad(prefix: "0xa9059cbb") + na + y;
}

extension Web3StrExtension on String {
  String addPad({String prefix = '0x'}) {
    return "${prefix}000000000000000000000000${substring(2)}";
  }

  String get delPad => contains("000000000000000000000000")
      ? '0x${split("000000000000000000000000").last}'
      : this;

  BigInt get hextobigInt =>
      isNotEmpty ? BigInt.parse(substring(2), radix: 16) : BigInt.zero;

  BigInt inWei() {
    if (isEmpty) {
      return BigInt.zero;
    }

    // 检查小数点的位置
    int decimalIndex = indexOf('.');

    BigInt unitFactor = BigInt.from(10).pow(18);

    // 如果没有小数点，直接转换为 BigInt
    if (decimalIndex == -1) {
      return BigInt.from(int.parse(this)) * unitFactor;
    }

    BigInt amountInWei = (BigInt.parse(replaceAll('.', '')) * unitFactor) ~/
        BigInt.from(10).pow(length - indexOf('.') - 1);

    return amountInWei;
  }

  String hexToDate() {
    BigInt timestampBigInt = BigInt.parse(this);
    int timestamp = timestampBigInt.toInt();
    if (timestamp < -8640000000000 || timestamp > 8640000000000) {
      return '';
    }
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    String formattedDate = dateTime.format("yyyy-MM-dd HH:mm");
    return formattedDate;
  }

  Uint8List hexToUint8List() {
    var hexString = this;
    if (hexString.startsWith('0x')) {
      hexString = hexString.substring(2);
    }

    // 验证字符串长度是否为偶数
    if (hexString.length % 2 != 0) {
      throw const FormatException("Hex string must have an even length");
    }

    List<int> bytes = [];
    for (int i = 0; i < hexString.length; i += 2) {
      String byteString = hexString.substring(i, i + 2);
      int byteValue = int.parse(byteString, radix: 16);
      bytes.add(byteValue);
    }

    return Uint8List.fromList(bytes);
  }
}

extension BigIntExtension on BigInt {
  double get toWei => this / BigInt.from(10).pow(18);
  double get toGwei => this / BigInt.from(10).pow(9);
  String get hex => '0x${toRadixString(16)}';
}

extension DoubleExtension on double {
  double get owlToUsd => this > 0 ? (this / 7.62) : 0.00;
  double get olinkToUsd => this > 0 ? (this / 5) : 0.00;

  String get fixed8 => this > 0 ? toStringAsFixed(8) : "0.00";
  String get fixed6 => this > 0 ? toStringAsFixed(6) : "0.000000";
  String get fixed4 => this > 0 ? toStringAsFixed(4) : "0.0000";
  String get fixed2 => this > 0 ? toStringAsFixed(2) : "0.00";
}

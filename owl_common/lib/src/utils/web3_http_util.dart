import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:owl_common/owl_common.dart';

class Web3Http {
  // ignore: constant_identifier_names
  static const String Get = "GET";
  // ignore: constant_identifier_names
  static const String Post = "POST";
  // ignore: constant_identifier_names
  static const String Put = "PUT";
  static const String patch = "PATCH";
  // ignore: constant_identifier_names
  static const String Delete = "DELETE";

  // ignore: constant_identifier_names
  static const CUSTOM_ERROR_CODE = 'DIO_CUSTOM_ERROR'; // 自定义错误代码

  static String errorShowMsg = ''; // 错误提示文字

  static const connectTimetout = 60000; // 连接超时时间
  static const receiveTimeout = 60000; // 接收超时时间
  static const sendTimeout = 60000; // 发送超时时间

  final Map<String, CancelToken> _pendingRequests = {}; // 正在请求列表
  static CancelToken cancelToken = CancelToken(); // 取消网络请求 token，默认所有请求都可取消。
  static CancelToken whiteListCancelToken =
      CancelToken(); // 取消网络请求白名单 token，此 token 不会被取消。

  static final Web3Http _instance = Web3Http._internal();
  factory Web3Http() => _instance;

  static Dio dio = Dio();

  Web3Http._internal() {
    dio = Dio(BaseOptions(
      baseUrl: Config.coinApiUrl,
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(milliseconds: connectTimetout),
      receiveTimeout: const Duration(milliseconds: receiveTimeout),
      sendTimeout: const Duration(milliseconds: sendTimeout),
      extra: {
        'cancelDuplicatedRequest': true,
        "showError": true,
        "showSuccess": false
      }, // 是否取消重复请求
    ));

    _initInterceptors();
  }

  void _removePendingRequest(String tokenKey) {
    if (_pendingRequests.containsKey(tokenKey)) {
      // 如果在 pending 中存在当前请求标识，需要取消当前请求，并且移除。
      _pendingRequests[tokenKey]?.cancel(tokenKey);
      _pendingRequests.remove(tokenKey);
    }
  }

  void _initInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(onRequest: (options, handler) {
        if (dio.options.extra['cancelDuplicatedRequest'] == true &&
            options.cancelToken == null) {
          String tokenKey = [
            options.method,
            options.baseUrl + options.path,
            jsonEncode(options.data ?? {}),
            jsonEncode(options.queryParameters)
          ].join('&');
          _removePendingRequest(tokenKey);
          options.cancelToken = CancelToken();
          options.extra['tokenKey'] = tokenKey;
          _pendingRequests[tokenKey] = options.cancelToken!;
        }

        return handler.next(options);
      }, onResponse: (response, handler) {
        RequestOptions option = response.requestOptions;
        if (dio.options.extra['cancelDuplicatedRequest'] == true &&
            option.cancelToken == null) {
          _removePendingRequest(option.extra['tokenKey']);
        }

        if (response.data is String) {
          response.data = Result.fromJson(jsonDecode(response.data));
        } else if (response.data is Map) {
          response.data = Result.fromJson(response.data);
        }

        if (option.extra['showError'] == true) {
          final result = response.data as Result;
          if (result.code != 0) {
            IMViews.showToast(result.msg);
          }
        }

        return handler.next(response);
      }, onError: (error, handler) {
        if (!CancelToken.isCancel(error) &&
            dio.options.extra['cancelDuplicatedRequest'] == true) {
          _pendingRequests.clear(); // 不可抗力错误则清空列表
        }

        return handler.next(error);
      }),
    );
    // dio.interceptors.add(PrettyDioLogger());
  }

  Future get(String url,
      {Map<String, dynamic>? params,
      Options? options,
      String? baseUrl,
      bool isCancelWhiteList = false}) async {
    CancelToken requestToken = CancelToken();
    if (dio.options.extra['cancelDuplicatedRequest'] != true ||
        isCancelWhiteList) {
      if (isCancelWhiteList) {
        requestToken = whiteListCancelToken;
      } else {
        requestToken = cancelToken;
      }
    }

    if (baseUrl != null && baseUrl.isNotEmpty) {
      dio.options.baseUrl = baseUrl;
    }

    try {
      if (params != null) {
        var response = await dio.get<Result>(url,
            queryParameters: params,
            cancelToken: requestToken,
            options: options);
        return response.data;
      } else {
        var response = await dio.get<Result>(url,
            cancelToken: requestToken, options: options);
        return response.data;
      }
    } catch (e) {
      _catchOthersError(e);
      return null;
    }
  }

  Future getUri(String url,
      {Map<String, dynamic>? params,
      Options? options,
      String? baseUrl,
      bool isCancelWhiteList = false}) async {
    CancelToken requestToken = CancelToken();
    if (dio.options.extra['cancelDuplicatedRequest'] != true ||
        isCancelWhiteList) {
      if (isCancelWhiteList) {
        requestToken = whiteListCancelToken;
      } else {
        requestToken = cancelToken;
      }
    }

    if (baseUrl != null && baseUrl.isNotEmpty) {
      dio.options.baseUrl = baseUrl;
    }

    final uri = Uri.parse(url).replace(queryParameters: params);

    try {
      var response = await dio.getUri<Result>(uri,
          cancelToken: requestToken, options: options);
      return response.data;
    } catch (e) {
      _catchOthersError(e);
      return null;
    }
  }

  Future post(
    String url, {
    Map<String, dynamic>? data,
    FormData? formData,
    Options? options,
    String? baseUrl,
    bool isCancelWhiteList = false,
    void Function(int, int)? onSendProgress,
  }) async {
    CancelToken requestToken = CancelToken();
    if (dio.options.extra['cancelDuplicatedRequest'] != true ||
        isCancelWhiteList) {
      if (isCancelWhiteList) {
        requestToken = whiteListCancelToken;
      } else {
        requestToken = cancelToken;
      }
    }

    if (baseUrl != null && baseUrl.isNotEmpty) {
      dio.options.baseUrl = baseUrl;
    }

    try {
      final response = await dio.post<Result>(url,
          data: formData ?? data,
          cancelToken: requestToken,
          options: options,
          onSendProgress: onSendProgress);
      return response.data;
    } catch (e) {
      _catchOthersError(e);
      return Future.error(e);
    }
  }

  Future<Result?> delete(
    String url, {
    Map<String, dynamic>? params,
    FormData? formData,
    Options? options,
    String? baseUrl,
    bool isCancelWhiteList = false,
  }) async {
    CancelToken requestToken = CancelToken();
    if (dio.options.extra['cancelDuplicatedRequest'] != true ||
        isCancelWhiteList) {
      if (isCancelWhiteList) {
        requestToken = whiteListCancelToken;
      } else {
        requestToken = cancelToken;
      }
    }

    if (baseUrl != null && baseUrl.isNotEmpty) {
      dio.options.baseUrl = baseUrl;
    }

    try {
      final response = await dio.delete<Result>(
        url,
        queryParameters: params,
        cancelToken: requestToken,
        options: options,
      );
      return response.data;
    } catch (e) {
      _catchOthersError(e);
      return null;
    }
  }

  static Future request(
    String url, {
    required String baseUrl,
    String method = Web3Http.Get,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Options? options,
    bool isCancelWhiteList = false,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    Web3Http.getInstance(baseUrl: baseUrl);
    CancelToken requestToken = CancelToken();
    Response? response;
    if (dio.options.extra['cancelDuplicatedRequest'] != true ||
        isCancelWhiteList) {
      if (isCancelWhiteList) {
        requestToken = whiteListCancelToken;
      } else {
        requestToken = cancelToken;
      }
    }

    try {
      response = await dio.request(url,
          options: options ??
              Options(
                  method: method,
                  contentType: Headers.formUrlEncodedContentType),
          queryParameters: queryParameters,
          data: data,
          cancelToken: requestToken,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress);

      return response.data;
    } catch (e) {
      _instance._catchOthersError(e);
    }
  }

  static Web3Http getInstance({String? baseUrl}) {
    String? targetBaseUrl = baseUrl ?? Config.coinApiUrl;
    if (dio.options.baseUrl != targetBaseUrl) {
      dio.options.baseUrl = targetBaseUrl;
    }
    return _instance;
  }

  void _catchOthersError(e) {
    String errMsg =
        "${errorShowMsg.isEmpty ? e : errorShowMsg}$CUSTOM_ERROR_CODE"
            .split(CUSTOM_ERROR_CODE)[0];
    int errMsgLength = errMsg.length;
    String errshowMsg = errMsgLength > 300 ? errMsg.substring(0, 150) : errMsg;
    if (e is DioException) {
      if (CancelToken.isCancel(e)) {
        IMViews.showToast('Cancel Request Successful'); // 取消重复请求可能会多次弹窗
        return;
      }
      IMViews.showToast(errshowMsg);
      return;
    }
    IMViews.showToast("$errshowMsg\n......");
  }
}

class Result {
  dynamic data;
  dynamic result;
  dynamic extra;
  List<dynamic> list;
  int code;
  int total;
  String msg;
  Result(this.data, this.code, this.msg, this.result, this.extra, this.total,
      this.list);

  factory Result.fromJson(Map<String, dynamic> map) {
    return Result(map['data'], map['code'], map["msg"], map['result'],
        map['extra'], map['total'] ?? 0, map['list'] ?? []);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'data': data,
        'result': result,
        'extra': extra,
        'code': code,
        'msg': msg,
        'total': total,
        'list': list
      };
}

import 'package:flutter_logs/flutter_logs.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:trapp/src/helpers/helper.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData? data}) async {
    if (isProd()) {
      FlutterLogs.logInfo(
        "LoggingInterceptor",
        "interceptRequest",
        {
          "url": data!.url.toString(),
        }.toString(),
      );
    }
    if (!isProd()) {
      FlutterLogs.logInfo(
        "LoggingInterceptor",
        "interceptRequest",
        data.toString(),
      );
    }
    return data!;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData? data}) async {
    if (!isProd()) {
      FlutterLogs.logInfo(
        "LoggingInterceptor",
        "interceptResponse:body",
        data!.body.toString(),
      );
    }
    FlutterLogs.logInfo(
      "LoggingInterceptor",
      "interceptResponse:status",
      {
        "status": data!.statusCode.toString(),
      }.toString(),
    );
    Map<String, String> headers = data.headers != null ? data.headers! : {};
    if (headers.containsKey('trace-id')) {
      FlutterLogs.logInfo(
        "LoggingInterceptor",
        "interceptResponse:traceId",
        {
          "traceId": headers['trace-id'].toString(),
        }.toString(),
      );
    }
    return data;
  }
}

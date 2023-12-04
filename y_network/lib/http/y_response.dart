import '../y_network.dart';

/// 作者：袁汉章 on 2023年11月07日 10:20
/// 邮箱：yhz199132@163.com
class YResponse<T> {
  final Response<T>? response;
  final DioException? dioException;

  YResponse({this.response, this.dioException});
}

extension YResponseExtension on YResponse {
  bool get isSuccessful =>
      response != null &&
      (response?.statusCode ?? -1) >= 200 &&
      (response?.statusCode ?? -1) < 300;

  bool get isExtension => dioException != null;
}

extension DioExceptionExtension on DioException {
  String get errorInfo {
    switch (type) {
      case DioExceptionType.connectionTimeout:
        return "连接超时";
      case DioExceptionType.sendTimeout:
        return "请求超时";
      case DioExceptionType.receiveTimeout:
        return "响应超时";
      case DioExceptionType.badCertificate:
        return "证书错误";
      case DioExceptionType.badResponse:
        return "";
      case DioExceptionType.cancel:
        return "";
      case DioExceptionType.connectionError:
        return "";
      case DioExceptionType.unknown:
        return "";
    }
  }
}

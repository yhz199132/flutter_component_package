import 'package:dio/dio.dart';

/// 作者：袁汉章 on 2023年10月20日 11:44
/// 邮箱：yhz199132@163.com
/// loading拦截器
typedef LoadingCallback = Function(bool isOpen)?;

class LoadingInterceptor extends Interceptor {
  LoadingCallback loadingCallback;

  LoadingInterceptor({this.loadingCallback});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
    final isOpenLoadingView =
        (options.extra['isOpenLoading'] as bool?) ?? false;
    if (isOpenLoadingView) {
      //开启loading
      loadingCallback?.call(true);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    //获取开启参数loading
    final isOpenLoadingView =
        (err.requestOptions.extra['isOpenLoading'] as bool?) ?? false;
    if (isOpenLoadingView) {
      //关闭loading
      loadingCallback?.call(false);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    final isOpenLoadingView =
        (response.requestOptions.extra['isOpenLoading'] as bool?) ?? false;
    if (isOpenLoadingView) {
      //关闭loading
      loadingCallback?.call(false);
    }
  }
}

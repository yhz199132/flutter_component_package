import 'package:dio/dio.dart';
import 'package:y_network/http/y_response.dart';

//请求方式
enum HttpMethod {
  get('GET'),
  post('POST'),
  put('PUT');

  final String value;

  const HttpMethod(this.value);
}

//缓存类型
enum HttpCacheType {
  none, //无缓存
  shortPeriod, //短效
  longActing, //长效
  perpetual //永久
} //

typedef QueryParameters = Map<String, dynamic>?;
typedef FromJson<T> = T Function(dynamic json)?;

//网络请求
class YHttpUtil {
  // 单例模式
  static final YHttpUtil _instance = YHttpUtil._internal();
  Dio? _dio;

  factory YHttpUtil() => _instance;

  YHttpUtil._internal() {
    init(
        baseOptions: BaseOptions(
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            sendTimeout: const Duration(seconds: 15)));
  }

  static YHttpUtil getInstance() {
    return _instance;
  }

  // 初始化请求配置
  init({BaseOptions? baseOptions}) {
    _dio = Dio(baseOptions);
  }

  //添加拦截器
  addInterceptors(Interceptor interceptor) {
    _dio?.interceptors.add(interceptor);
  }

  //添加多个拦截器
  addInterceptorsList(List<Interceptor> interceptors) {
    _dio?.interceptors.addAll(interceptors);
  }

  /// Get请求
  /// query参数
  /// isOpenLoading 是否显示loading和拦截器配合  注意如果自己实现一套loading则该参数无效
  ///
  ///
  Future<YResponse<dynamic>> get<T>(String url,
      {data,
      QueryParameters queryParameters,
      CancelToken? cancelToken,
      Options? options,
      String? contentType,
      FromJson<T> fromJson,
      bool isOpenLoading = true,
      HttpCacheType? httpCacheType,
      ProgressCallback? onReceiveProgress}) async {
    return await request<T>(url,
        options: options,
        fromJson: fromJson,
        httpMethod: HttpMethod.get,
        contentType: contentType,
        isOpenLoading: isOpenLoading,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        httpCacheType: httpCacheType,
        onReceiveProgress: onReceiveProgress);
  }

  //post请求
  Future<YResponse<dynamic>> post<T>(String url,
      {body,
      QueryParameters queryParameters,
      CancelToken? cancelToken,
      Options? options,
      FromJson<T> fromJson,
      bool isOpenLoading = true,
      HttpCacheType? httpCacheType,
      String? contentType,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    return await request<T>(url,
        body: body,
        options: options,
        fromJson: fromJson,
        httpMethod: HttpMethod.post,
        contentType: contentType,
        httpCacheType: httpCacheType,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        isOpenLoading: isOpenLoading,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }

  /// 上传文件请求
  /// body FormData已被包装，直接传递Map
  ///
  ///
  Future<YResponse<dynamic>> upload<T>(String url,
      {required Map<String, dynamic> body,
      QueryParameters queryParameters,
      CancelToken? cancelToken,
      Options? options,
      bool isOpenLoading = true,
      FromJson<T> fromJson,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    return await request<T>(url,
        body: FormData.fromMap(body),
        options: options,
        fromJson: fromJson,
        httpMethod: HttpMethod.post,
        isOpenLoading: isOpenLoading,
        contentType: Headers.multipartFormDataContentType,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }

  //请求体  返回值做调整
  Future<YResponse<dynamic>> request<T>(String url,
      {body,
      HttpCacheType? httpCacheType,
      QueryParameters queryParameters,
      CancelToken? cancelToken,
      Options? options,
      HttpMethod? httpMethod,
      String? contentType,
      FromJson<T> fromJson,
      bool isOpenLoading = true,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    try {
      options ??= Options(contentType: Headers.jsonContentType);
      if (httpMethod != null) {
        options.method = httpMethod.value;
      }
      options.contentType ??= contentType ?? Headers.jsonContentType;
      options.extra = {"isOpenLoading": isOpenLoading};
      final response = await _dio?.request(url,
          data: body,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          options: options,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
      if (fromJson != null) {
        response?.data = fromJson(response.data);
      }
      return YResponse(response: response);
    } on DioException catch (e) {
      return YResponse(dioException: e);
    }
  }

  //多请求并发
  Future<List<Response<dynamic>?>> multipleRequest(
      List<Future<Response<dynamic>?>> waits) async {
    return await Future.wait(waits);
  }

  ///文件下载
  /// url 下载链接
  /// path 文件保存路径
  /// isOpenLoading 是否显示loading,需要和拦截器配合  注意如果自己实现一套loading则该参数无效
  ///
  Future<Response<dynamic>?> download<T>(String url, String path,
      {QueryParameters queryParameters,
      CancelToken? cancelToken,
      Options? options,
      String? contentType,
      FromJson<T> fromJson,
      bool isOpenLoading = true,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    try {
      options ??= Options(contentType: Headers.jsonContentType);
      options.contentType ??= contentType ?? Headers.jsonContentType;
      options.extra = {"isOpenLoading": isOpenLoading};
      final response = await _dio?.download(url, path,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          options: options,
          onReceiveProgress: onReceiveProgress);
      if (fromJson != null) {
        response?.data = fromJson(response.data);
      }
      return response;
    } on DioException {
      rethrow;
    }
  }
}

//缓存映射
final httpCacheTypeMap = {
  HttpCacheType.none: 0,
  HttpCacheType.shortPeriod: 300,
  HttpCacheType.longActing: 3600 * 24 * 3,
  HttpCacheType.perpetual: 3600 * 24 * 30,
};

import 'package:capstone/Constants/enum.dart';
import 'package:capstone/SharedResources/global_storage_service.dart';
import 'package:dio/dio.dart';

class HttpUtil {
  late Dio dio;
  static final HttpUtil _instance = HttpUtil._internal();

  factory HttpUtil() {
    return _instance;
  }

  HttpUtil._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: EnumValues.HOST,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 100),
      headers: {},
      contentType: "Application/json: charset=utf-8",
      responseType: ResponseType.json,
    );
    dio = Dio(options);
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          ErrorEntity eInfo = createErrorEntity(e);
          print(eInfo);
        },
      ),
    );
  }

  Map<String, dynamic>? getAuthorizationHeader() {
    var headers = <String, dynamic>{};
    var accessToken = GlobalStorageService.storageService.getString(EnumValues.ACCESS_TOKEN);
    if (accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    return headers;
  }

  Future post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};

    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
    );
    return response.data;
  }

  Future get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};

    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.get(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
    );
    return response.data;
  }
}

class ErrorEntity implements Exception {
  int code = -1;
  String message = "";
  ErrorEntity({required this.code, required this.message});

  @override
  String toString() {
    if (message == "") return "Exception";
    return "Exception code $code, $message";
  }
}

ErrorEntity createErrorEntity(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return ErrorEntity(code: -1, message: "Connection timed out");
    case DioExceptionType.sendTimeout:
      return ErrorEntity(code: 0, message: "Send timed out");

    case DioExceptionType.receiveTimeout:
      return ErrorEntity(code: 1, message: "recieve timed out");

    case DioExceptionType.badCertificate:
      return ErrorEntity(code: 2, message: "Bad SSL timed out");

    case DioExceptionType.badResponse:
      switch (error.response!.statusCode) {
        case 400:
          return ErrorEntity(code: 3, message: "Request syntax error");
        case 401:
          return ErrorEntity(code: 4, message: "Permission denied");
      }
      return ErrorEntity(code: 5, message: "Bad response timed out");

    case DioExceptionType.cancel:
      return ErrorEntity(code: 6, message: "cancel timed out");

    case DioExceptionType.connectionError:
      return ErrorEntity(code: 7, message: "Conncetion error timed out");

    case DioExceptionType.unknown:
      return ErrorEntity(code: 8, message: "unknown timed out");
  }
}

void onError(ErrorEntity e) {
  switch (e.code) {
    case 400:
      "Case syntax error";
      break;
    case 401:
      "Denied to continue";
      break;
    case 500:
      "Internal server error";
      break;
    default:
      "Unknown error ${e.code}";
      break;
  }
}

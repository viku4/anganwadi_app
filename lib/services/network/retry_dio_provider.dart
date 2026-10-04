import 'dart:developer';

import 'package:anganwadi_connect/config/route_names.dart';
import 'package:anganwadi_connect/config/routing_service.dart';
import 'package:anganwadi_connect/controllers/login_provider.dart';
import 'package:anganwadi_connect/main.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'api_endpoints.dart';

Dio createRetryDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = loginProvider.accessToken;
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        handler.next(options);
      },
      onResponse: (response, handler) {
        handler.next(response);
      },
      onError: (error, handler) async {
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        log(
          'onError status=${error.response?.statusCode} '
          'url=${error.requestOptions.uri} '
          'message=${error.message} '
          'data=${error.response?.data ?? 'null'}',
        );
        if (statusCode != 401) {
          log("🚫 Non-401 error path");

          if (data is Map && data.containsKey('message')) {
            log("📩 Server message: ${data['message']}");

            Fluttertoast.showToast(
              msg: data["message"] ?? "An error occurred. Please try again.",
            );
          } else {
            log("⚠️ No structured error message from server");
          }

          return handler.next(error);
        } else {
          await prefs.clear();
          RoutingService().go(Routes.loginScreen.name);
        }
        handler.next(error);
      },
    ),
  );

  return dio;
}

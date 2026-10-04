import 'dart:developer';

import 'package:anganwadi_connect/controllers/login_provider.dart';
import 'package:anganwadi_connect/services/network/api_client.dart';
import 'package:anganwadi_connect/services/network/api_endpoints.dart';
import 'package:anganwadi_connect/services/network/retry_api_client.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

Dio createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      // validateStatus: (status) => status != null && status < 500,
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
        }
        final refresh = loginProvider.refreshToken;

        if (refresh == null || refresh.isEmpty) {
          loginProvider.logout();
          return handler.next(error);
        }

        final refreshed = await refreshToken(refresh);
        log("refreshed$refreshed ${refreshed.runtimeType}");
        if (refreshed == null ||
            refreshed["access_token"] == null ||
            refreshed["refresh_token"] == null) {
          log("⛔ Refresh failed → logout");
          loginProvider.logout();
          return handler.next(error);
        }
        final accessToken = refreshed["access_token"];
        final refreshTokenNew = refreshed["refresh_token"];

        loginProvider.updateTokenData(
          accessToken: accessToken,
          refreshToken: refreshTokenNew,
        );

        try {
          final snapshot = error.requestOptions.extra["retry_snapshot"] as Map?;

          if (snapshot == null) {
            log("⚠️ No retry snapshot found");
            return handler.next(error);
          }

          log("🔁 Retry snapshot found");

          dynamic retryData;

          if (snapshot["type"] == "form") {
            log("📤 Rebuilding FormData");

            final dataMap = Map<String, dynamic>.from(snapshot["data"]);

            final fields = Map<String, dynamic>.from(dataMap["fields"] ?? {});

            final files = (dataMap["files"] as List? ?? [])
                .map((e) => RetryFile.fromJson(Map<String, dynamic>.from(e)))
                .toList();

            final formMap = <String, dynamic>{};
            formMap.addAll(fields);

            for (final file in files) {
              formMap[file.key] = await MultipartFile.fromFile(
                file.path,
                filename: file.filename,
              );
            }

            retryData = FormData.fromMap(formMap);
          } else {
            log("📤 Reusing JSON data");
            retryData = snapshot["data"];
          }

          log("🚀 Sending retry request...");
          final apiService = await RetryApiClient().request(
            path: snapshot["path"],
            method: snapshot["method"],
            payload: retryData,
          );

          if (apiService != null) {
            log("✅ Retry success: ${apiService.data}");
            return handler.resolve(apiService);
          } else {
            log("❌ Retry failed");
            return handler.next(error);
          }
        } catch (retryError) {
          log("❌ Retry failed: $retryError");

          return handler.next(
            DioException(
              requestOptions: error.requestOptions,
              error: retryError,
            ),
          );
        }
      },
    ),
  );

  return dio;
}

Future<dynamic> refreshToken(String refreshToken) async {
  try {
    log("🌐 REFRESH API CALLED");
    log("📤 Request: $refreshToken");

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    );

    final response = await dio.post(
      refreshTokenUrl,
      data: {"refresh_token": refreshToken},
    );

    log("📥 Refresh response: ${response.data}");

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      return data["data"];
    } else {
      return null;
    }
  } catch (e) {
    log("❌ REFRESH ERROR: $e");

    return null;
  }
}

class RetryFormData {
  final Map<String, dynamic> fields;
  final Map<String, String> files;

  RetryFormData({required this.fields, required this.files});

  Future<FormData> toFormData() async {
    final map = <String, dynamic>{};

    map.addAll(fields);

    for (final entry in files.entries) {
      map[entry.key] = await MultipartFile.fromFile(
        entry.value,
        filename: entry.value.split('/').last,
      );
    }
    return FormData.fromMap(map);
  }
}

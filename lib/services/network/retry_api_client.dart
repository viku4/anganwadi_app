import 'dart:developer';

import 'package:anganwadi_connect/services/network/retry_dio_provider.dart';
import 'package:dio/dio.dart';
import 'api_client.dart';

class RetryApiClient {
  final retryDio = createRetryDio();
  Future<dynamic> request({
    required String path,
    required RequestMethod method,
    dynamic payload,
    bool showLogs = true,
  }) async {
    if (showLogs) {
      log('Request url-- ${retryDio.options.baseUrl}$path');
      log('Request method-- $method');
      if (payload is FormData) {
        log('Request Body FormData -- ${payload.fields} ${payload.files}');
      } else {
        log('Request Body-- $payload');
      }
    }

    final Response<dynamic> response;
    try {
      switch (method) {
        case RequestMethod.get:
          response = await retryDio.get(path, data: payload);
          break;
        case RequestMethod.post:
          response = await retryDio.post(path, data: payload);
          break;
        case RequestMethod.patch:
          response = await retryDio.patch(path, data: payload);
          break;
        case RequestMethod.delete:
          response = await retryDio.delete(path);
          break;
      }

      if (showLogs) {
        log('response${response.statusCode}');
        log('response.data${response.data}');
      }

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;

        if (data.containsKey('data')) {
          return response;
        }
      }
      return null;
    } catch (e) {
      if (showLogs) {
        log('Request error: $e');
      }
      return null;
    }
  }
}

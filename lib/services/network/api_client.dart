import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dio_provider.dart';

class ApiClient {
  final dio = createDio();
  Future<dynamic> request({
    required String path,
    required RequestMethod method,
    dynamic payload,
    bool showLogs = true,
    List<RetryFile>? retryFiles,
  }) async {
    if (showLogs) {
      log('Request url-- ${dio.options.baseUrl}$path');
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
          response = await dio.get(
            path,
            data: payload,
            options: Options(
              extra: {
                'retry_snapshot': {
                  'method': RequestMethod.get,
                  'path': path,
                  'data': payload is FormData
                      ? {
                          'fields': Map<String, dynamic>.fromEntries(
                            payload.fields,
                          ),
                          'files':
                              retryFiles?.map((e) => e.toJson()).toList() ?? [],
                        }
                      : payload,
                  'type': payload is FormData ? 'form' : 'json',
                },
              },
            ),
          );
          break;
        case RequestMethod.post:
          response = await dio.post(
            path,
            data: payload,
            options: Options(
              extra: {
                'retry_snapshot': {
                  'method': RequestMethod.post,
                  'path': path,
                  'data': payload is FormData
                      ? {
                          'fields': Map<String, dynamic>.fromEntries(
                            payload.fields,
                          ),
                          'files':
                              retryFiles?.map((e) => e.toJson()).toList() ?? [],
                        }
                      : payload,
                  'type': payload is FormData ? 'form' : 'json',
                },
              },
            ),
          );
          break;
        case RequestMethod.patch:
          response = await dio.patch(
            path,
            data: payload,
            options: Options(
              extra: {
                'retry_snapshot': {
                  'method': RequestMethod.patch,
                  'path': path,
                  'data': payload is FormData
                      ? {
                          'fields': Map<String, dynamic>.fromEntries(
                            payload.fields,
                          ),
                          'files':
                              retryFiles?.map((e) => e.toJson()).toList() ?? [],
                        }
                      : payload,
                  'type': payload is FormData ? 'form' : 'json',
                },
              },
            ),
          );
          break;
        case RequestMethod.delete:
          response = await dio.delete(
            path,
            options: Options(
              extra: {
                'retry_snapshot': {
                  'method': RequestMethod.delete,
                  'path': path,
                  'data': payload is FormData
                      ? {
                          'fields': Map<String, dynamic>.fromEntries(
                            payload.fields,
                          ),
                          'files':
                              retryFiles?.map((e) => e.toJson()).toList() ?? [],
                        }
                      : payload,
                  'type': payload is FormData ? 'form' : 'json',
                },
              },
            ),
          );
          break;
      }

      if (showLogs) {
        log('response${response.statusCode}');
        log('response.data${response.data}');
      }

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;

        if (data.containsKey('data')) {
          if ((data["message"] != null) &&
              (data["message"] != "Null") &&
              (data["message"] != "")) {
            Fluttertoast.showToast(msg: data["message"]);
          }

          return data["data"];
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      if (showLogs) {
        log('Request error: $e');
      }
      return null;
    }
  }
}

enum RequestMethod { get, post, patch, delete }

class RetryFile {
  final String key;
  final dynamic path;
  final String? filename;

  RetryFile({required this.key, required this.path, this.filename});

  Map<String, dynamic> toJson() => {
    'key': key,
    'path': path,
    'filename': filename,
  };

  factory RetryFile.fromJson(Map<String, dynamic> json) {
    return RetryFile(
      key: json['key'],
      path: json['path'],
      filename: json['filename'],
    );
  }
}

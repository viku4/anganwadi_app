import 'api_client.dart';
import 'retry_api_client.dart';

class RetryApiService {
  final RetryApiClient retryApiClient;

  RetryApiService(this.retryApiClient);

  Future<dynamic> request(
    String path, {
    dynamic data,
    bool showLogs = true,
    required RequestMethod method,
  }) {
    return retryApiClient.request(
      path: path,
      method: method,
      payload: data,
      showLogs: showLogs,
    );
  }
}

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_url.dart';

class PrivacyPolicyServices {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiUrls.baseUrl));

  PrivacyPolicyServices() {
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ));
  }

  Future<Map<String, dynamic>> getAllPolicies() async {
    try {
      final response = await _dio.get(ApiUrls.privacyPolicyGetAll);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createPolicy({
    required String header,
    required String description,
  }) async {
    try {
      final response = await _dio.post(
        ApiUrls.privacyPolicyCreate,
        data: {
          'privacy_header': header,
          'privacy_description': description,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updatePolicy({
    required String privacyId,
    required String header,
    required String description,
  }) async {
    try {
      final response = await _dio.put(
        '${ApiUrls.privacyPolicyUpdate}/$privacyId',
        data: {
          'privacy_header': header,
          'privacy_description': description,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deletePolicy(String privacyId) async {
    try {
      final response = await _dio.delete('${ApiUrls.privacyPolicyDelete}/$privacyId');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}

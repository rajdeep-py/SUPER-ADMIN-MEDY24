import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_url.dart';

class TermsConditionsServices {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiUrls.baseUrl));

  TermsConditionsServices() {
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

  Future<Map<String, dynamic>> getAllTerms() async {
    try {
      final response = await _dio.get(ApiUrls.termsConditionsGetAll);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createTerm({
    required String header,
    required String description,
  }) async {
    try {
      final response = await _dio.post(
        ApiUrls.termsConditionsCreate,
        data: {
          'term_header': header,
          'term_description': description,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateTerm({
    required String termId,
    required String header,
    required String description,
  }) async {
    try {
      final response = await _dio.put(
        '${ApiUrls.termsConditionsUpdate}/$termId',
        data: {
          'term_header': header,
          'term_description': description,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteTerm(String termId) async {
    try {
      final response = await _dio.delete('${ApiUrls.termsConditionsDelete}/$termId');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}

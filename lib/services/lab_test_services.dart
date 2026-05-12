import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_url.dart';

class LabTestService {
  final Dio _dio;

  LabTestService()
      : _dio = Dio(BaseOptions(
          baseUrl: ApiUrls.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        )) {
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
    ));
  }

  Future<Response> createCoreTest(FormData formData) async {
    return await _dio.post(ApiUrls.coreTestCreate, data: formData);
  }

  Future<Response> getAllTests({int page = 1, int limit = 20}) async {
    return await _dio.get(
      ApiUrls.coreTestGetAll,
      queryParameters: {'page': page, 'limit': limit},
    );
  }

  Future<Response> getTestById(String testId) async {
    return await _dio.get('${ApiUrls.coreTestGetById}/$testId');
  }

  Future<Response> updateTest(String testId, FormData formData) async {
    return await _dio.put('${ApiUrls.coreTestUpdateById}/$testId', data: formData);
  }

  Future<Response> deleteTests(List<String> testIds) async {
    return await _dio.delete(
      ApiUrls.coreTestDeleteByIds,
      data: testIds,
    );
  }
}

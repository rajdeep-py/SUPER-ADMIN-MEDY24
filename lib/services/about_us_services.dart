import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_url.dart';

class AboutUsService {
  final Dio _dio;

  AboutUsService()
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

  Future<Response> createAboutUs(FormData formData) async {
    return await _dio.post(ApiUrls.aboutUsCreate, data: formData);
  }

  Future<Response> getAllAboutUs() async {
    return await _dio.get(ApiUrls.aboutUsGetAll);
  }

  Future<Response> getAboutUsById(int id) async {
    return await _dio.get('${ApiUrls.aboutUsGetById}/$id');
  }

  Future<Response> updateAboutUs(int id, FormData formData) async {
    return await _dio.put('${ApiUrls.aboutUsUpdateById}/$id', data: formData);
  }

  Future<Response> deleteAboutUs(int id) async {
    return await _dio.delete('${ApiUrls.aboutUsDeleteById}/$id');
  }
}

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_url.dart';
import '../models/patho_lab.dart';

class PathoLabService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiUrls.baseUrl));

  PathoLabService() {
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );
  }

  Future<Map<String, dynamic>> getAllLabs({
    int skip = 0,
    int limit = 100,
    String? name,
    String? email,
    String? phone,
    String? whatsapp,
    String? address,
    String? status,
  }) async {
    try {
      final response = await _dio.get(
        ApiUrls.pathoLabGetAll,
        queryParameters: {
          'skip': skip,
          'limit': limit,
          'name': ?name,
          'email': ?email,
          'phone': ?phone,
          'whatsapp': ?whatsapp,
          'address': ?address,
          if (status != null && status != 'All') 'status': status,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> signupLab(FormData formData) async {
    try {
      final response = await _dio.post(ApiUrls.pathoLabSignup, data: formData);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateLab(
    String labId,
    FormData formData,
  ) async {
    try {
      final response = await _dio.put(
        '${ApiUrls.pathoLabUpdateById}/$labId',
        data: formData,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<PathoLab> getLabById(String labId) async {
    try {
      final response = await _dio.get('${ApiUrls.pathoLabGetById}/$labId');
      return PathoLab.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}

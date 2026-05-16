import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_url.dart';
import '../models/pharma_shop.dart';

class PharmaShopService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiUrls.baseUrl));

  PharmaShopService() {
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

  Future<Map<String, dynamic>> getAllShops({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        ApiUrls.pharmaShopGetAll,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<PharmaShop> getShopById(String shopId) async {
    try {
      final response = await _dio.get('${ApiUrls.pharmaShopGetById}/$shopId');
      return PharmaShop.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateShop(
    String shopId,
    Map<String, dynamic> data,
  ) async {
    try {
      // Using FormData as the backend expects Form fields
      final formData = FormData.fromMap(data);
      final response = await _dio.put(
        '${ApiUrls.pharmaShopUpdateById}/$shopId',
        data: formData,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteShop(String shopId) async {
    try {
      final response = await _dio.delete('${ApiUrls.pharmaShopDeleteById}/$shopId');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}

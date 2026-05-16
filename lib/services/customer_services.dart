import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_url.dart';
import '../models/customer.dart';

class CustomerService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiUrls.baseUrl));

  CustomerService() {
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

  Future<List<Customer>> getAllCustomers() async {
    try {
      final response = await _dio.get(ApiUrls.customerGetAll);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> data = responseData['data'] ?? [];
        return data.map((e) => Customer.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<Customer> updateCustomerStatus(String customerId, String status) async {
    try {
      final formData = FormData.fromMap({
        'status': status,
      });
      final response = await _dio.put(
        '${ApiUrls.customerUpdateProfile}/$customerId',
        data: formData,
      );
      if (response.statusCode == 200) {
        return Customer.fromJson(response.data['user']);
      }
      throw Exception('Failed to update status');
    } catch (e) {
      rethrow;
    }
  }

  Future<Customer> getCustomerProfile(String customerId) async {
    try {
      final response = await _dio.get('${ApiUrls.customerGetProfile}/$customerId');
      if (response.statusCode == 200) {
        return Customer.fromJson(response.data['user']);
      }
      throw Exception('Failed to fetch profile');
    } catch (e) {
      rethrow;
    }
  }
}

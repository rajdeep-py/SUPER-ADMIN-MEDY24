import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/customer_notifier.dart';
import '../services/customer_services.dart';

final customerServiceProvider = Provider<CustomerService>((ref) {
  return CustomerService();
});

final customerProvider =
    StateNotifierProvider<CustomerNotifier, CustomerState>((ref) {
  final service = ref.watch(customerServiceProvider);
  return CustomerNotifier(service);
});

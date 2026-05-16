import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/customer.dart';
import '../services/customer_services.dart';

class CustomerState {
  final List<Customer> customers;
  final List<Customer> filteredCustomers;
  final bool isLoading;
  final String? error;

  CustomerState({
    this.customers = const [],
    this.filteredCustomers = const [],
    this.isLoading = false,
    this.error,
  });

  CustomerState copyWith({
    List<Customer>? customers,
    List<Customer>? filteredCustomers,
    bool? isLoading,
    String? error,
  }) {
    return CustomerState(
      customers: customers ?? this.customers,
      filteredCustomers: filteredCustomers ?? this.filteredCustomers,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class CustomerNotifier extends StateNotifier<CustomerState> {
  final CustomerService _service;

  CustomerNotifier(this._service) : super(CustomerState()) {
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final customers = await _service.getAllCustomers();
      state = state.copyWith(
        customers: customers,
        filteredCustomers: customers,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateStatus(String customerId, String status) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _service.updateCustomerStatus(customerId, status);
      await loadCustomers();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void filterCustomers(String query, String status) {
    List<Customer> filtered = state.customers;

    if (query.isNotEmpty) {
      filtered = filtered.where((customer) {
        final nameMatch =
            customer.fullName?.toLowerCase().contains(query.toLowerCase()) ??
                false;
        final phoneMatch = customer.phoneNumber?.contains(query) ?? false;
        final emailMatch =
            customer.email?.toLowerCase().contains(query.toLowerCase()) ??
                false;
        return nameMatch || phoneMatch || emailMatch;
      }).toList();
    }

    if (status != 'All') {
      filtered = filtered
          .where((customer) =>
              customer.status?.toLowerCase() == status.toLowerCase())
          .toList();
    }

    state = state.copyWith(filteredCustomers: filtered);
  }
}

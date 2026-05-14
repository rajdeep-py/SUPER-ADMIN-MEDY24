import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/privacy_policy.dart';
import '../services/privacy_policy_services.dart';

class PrivacyPolicyState {
  final List<PrivacyPolicy> policies;
  final bool isLoading;
  final String? error;

  PrivacyPolicyState({
    this.policies = const [],
    this.isLoading = false,
    this.error,
  });

  PrivacyPolicyState copyWith({
    List<PrivacyPolicy>? policies,
    bool? isLoading,
    String? error,
  }) {
    return PrivacyPolicyState(
      policies: policies ?? this.policies,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class PrivacyPolicyNotifier extends StateNotifier<PrivacyPolicyState> {
  final PrivacyPolicyServices _services;

  PrivacyPolicyNotifier(this._services) : super(PrivacyPolicyState()) {
    fetchPolicies();
  }

  Future<void> fetchPolicies() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _services.getAllPolicies();
      final List<dynamic> data = result['data'] ?? [];
      final List<PrivacyPolicy> policies = data.map((e) => PrivacyPolicy.fromJson(e)).toList();
      state = state.copyWith(isLoading: false, policies: policies);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> createPolicy(String header, String description) async {
    try {
      await _services.createPolicy(header: header, description: description);
      await fetchPolicies();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> updatePolicy(String privacyId, String header, String description) async {
    try {
      await _services.updatePolicy(privacyId: privacyId, header: header, description: description);
      await fetchPolicies();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> deletePolicy(String privacyId) async {
    try {
      await _services.deletePolicy(privacyId);
      await fetchPolicies();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

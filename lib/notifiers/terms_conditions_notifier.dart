import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/terms_conditions.dart';
import '../services/terms_conditions_services.dart';

class TermsConditionsState {
  final List<TermsConditions> terms;
  final bool isLoading;
  final String? error;

  TermsConditionsState({
    this.terms = const [],
    this.isLoading = false,
    this.error,
  });

  TermsConditionsState copyWith({
    List<TermsConditions>? terms,
    bool? isLoading,
    String? error,
  }) {
    return TermsConditionsState(
      terms: terms ?? this.terms,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class TermsConditionsNotifier extends StateNotifier<TermsConditionsState> {
  final TermsConditionsServices _services;

  TermsConditionsNotifier(this._services) : super(TermsConditionsState()) {
    fetchTerms();
  }

  Future<void> fetchTerms() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _services.getAllTerms();
      final List<dynamic> data = result['data'] ?? [];
      final List<TermsConditions> terms = data.map((e) => TermsConditions.fromJson(e)).toList();
      state = state.copyWith(isLoading: false, terms: terms);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> createTerm(String header, String description) async {
    try {
      await _services.createTerm(header: header, description: description);
      await fetchTerms();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> updateTerm(String termId, String header, String description) async {
    try {
      await _services.updateTerm(termId: termId, header: header, description: description);
      await fetchTerms();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> deleteTerm(String termId) async {
    try {
      await _services.deleteTerm(termId);
      await fetchTerms();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

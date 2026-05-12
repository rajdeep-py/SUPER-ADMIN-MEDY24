import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/lab_test.dart';
import '../services/lab_test_services.dart';

class LabTestState {
  final List<LabTest> tests;
  final bool isLoading;
  final String? error;
  final List<LabTest> filteredTests;
  final int totalCount;
  final int currentPage;

  LabTestState({
    this.tests = const [],
    this.isLoading = false,
    this.error,
    this.filteredTests = const [],
    this.totalCount = 0,
    this.currentPage = 1,
  });

  LabTestState copyWith({
    List<LabTest>? tests,
    bool? isLoading,
    String? error,
    List<LabTest>? filteredTests,
    int? totalCount,
    int? currentPage,
  }) {
    return LabTestState(
      tests: tests ?? this.tests,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      filteredTests: filteredTests ?? this.filteredTests,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class LabTestNotifier extends StateNotifier<LabTestState> {
  final LabTestService _service;

  LabTestNotifier(this._service) : super(LabTestState()) {
    loadTests();
  }

  Future<void> loadTests({int page = 1, String? query}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _service.getAllTests(page: page);
      final List<dynamic> testsJson = response.data['data'];
      final tests = testsJson.map((j) => LabTest.fromJson(j)).toList();
      
      state = state.copyWith(
        isLoading: false,
        tests: tests,
        filteredTests: _applyFilter(tests, query),
        totalCount: response.data['total'],
        currentPage: page,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  List<LabTest> _applyFilter(List<LabTest> tests, String? query) {
    if (query == null || query.isEmpty) return tests;
    final lowerQuery = query.toLowerCase();
    return tests.where((test) {
      return test.testName.toLowerCase().contains(lowerQuery) ||
             test.testCategory.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  void searchTests(String query) {
    state = state.copyWith(filteredTests: _applyFilter(state.tests, query));
  }

  Future<void> createTest(FormData formData) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _service.createCoreTest(formData);
      await loadTests();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> updateTest(String testId, FormData formData) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _service.updateTest(testId, formData);
      await loadTests();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> deleteTests(List<String> testIds) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _service.deleteTests(testIds);
      await loadTests();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }
}

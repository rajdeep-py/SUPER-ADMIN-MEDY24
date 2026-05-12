import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/about_us.dart';
import '../services/about_us_services.dart';

class AboutUsState {
  final List<AboutUs> entries;
  final bool isLoading;
  final String? error;

  AboutUsState({
    this.entries = const [],
    this.isLoading = false,
    this.error,
  });

  AboutUsState copyWith({
    List<AboutUs>? entries,
    bool? isLoading,
    String? error,
  }) {
    return AboutUsState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AboutUsNotifier extends StateNotifier<AboutUsState> {
  final AboutUsService _service;

  AboutUsNotifier(this._service) : super(AboutUsState()) {
    loadAboutUs();
  }

  Future<void> loadAboutUs() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _service.getAllAboutUs();
      final List<dynamic> data = response.data['data'];
      final entries = data.map((j) => AboutUs.fromJson(j)).toList();
      state = state.copyWith(isLoading: false, entries: entries);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createAboutUs(FormData formData) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _service.createAboutUs(formData);
      await loadAboutUs();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> updateAboutUs(int id, FormData formData) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _service.updateAboutUs(id, formData);
      await loadAboutUs();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> deleteAboutUs(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _service.deleteAboutUs(id);
      await loadAboutUs();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }
}

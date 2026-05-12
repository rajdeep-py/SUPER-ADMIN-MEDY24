import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/patho_lab.dart';
import '../services/patho_lab_user_services.dart';

class PathoLabState {
  final List<PathoLab> labs;
  final bool isLoading;
  final String? error;
  final List<PathoLab> filteredLabs;
  final int totalCount;

  PathoLabState({
    this.labs = const [],
    this.isLoading = false,
    this.error,
    this.filteredLabs = const [],
    this.totalCount = 0,
  });

  PathoLabState copyWith({
    List<PathoLab>? labs,
    bool? isLoading,
    String? error,
    List<PathoLab>? filteredLabs,
    int? totalCount,
  }) {
    return PathoLabState(
      labs: labs ?? this.labs,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      filteredLabs: filteredLabs ?? this.filteredLabs,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

class PathoLabNotifier extends StateNotifier<PathoLabState> {
  final PathoLabService _service;

  PathoLabNotifier(this._service) : super(PathoLabState()) {
    loadLabs();
  }

  Future<void> loadLabs({
    String? name,
    String? email,
    String? phone,
    String? whatsapp,
    String? address,
    String? status,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _service.getAllLabs(
        name: name,
        email: email,
        phone: phone,
        whatsapp: whatsapp,
        address: address,
        status: status,
      );
      
      final List<dynamic> labsJson = data['labs'];
      final labs = labsJson.map((j) => PathoLab.fromJson(j)).toList();
      
      state = state.copyWith(
        isLoading: false,
        labs: labs,
        filteredLabs: labs,
        totalCount: data['total'],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> onboardLab(FormData formData) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _service.signupLab(formData);
      await loadLabs();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> updateLab(String labId, FormData formData) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _service.updateLab(labId, formData);
      await loadLabs();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }
}

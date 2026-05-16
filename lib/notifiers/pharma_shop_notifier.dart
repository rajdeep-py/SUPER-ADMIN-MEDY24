import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pharma_shop.dart';
import '../services/pharma_shop_services.dart';

class PharmaShopState {
  final List<PharmaShop> shops;
  final bool isLoading;
  final String? error;
  final List<PharmaShop> filteredShops;
  final int totalCount;
  final int currentPage;
  final int limit;

  PharmaShopState({
    this.shops = const [],
    this.isLoading = false,
    this.error,
    this.filteredShops = const [],
    this.totalCount = 0,
    this.currentPage = 1,
    this.limit = 20,
  });

  PharmaShopState copyWith({
    List<PharmaShop>? shops,
    bool? isLoading,
    String? error,
    List<PharmaShop>? filteredShops,
    int? totalCount,
    int? currentPage,
    int? limit,
  }) {
    return PharmaShopState(
      shops: shops ?? this.shops,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      filteredShops: filteredShops ?? this.filteredShops,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      limit: limit ?? this.limit,
    );
  }
}

class PharmaShopNotifier extends StateNotifier<PharmaShopState> {
  final PharmaShopService _service;

  PharmaShopNotifier(this._service) : super(PharmaShopState()) {
    loadShops();
  }

  Future<void> loadShops({
    int page = 1,
    int limit = 20,
    String? searchQuery,
    String? statusFilter,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _service.getAllShops(page: page, limit: limit);
      
      final List<dynamic> shopsJson = data['data'];
      final shops = shopsJson.map((j) => PharmaShop.fromJson(j)).toList();
      
      List<PharmaShop> filtered = shops;
      if (searchQuery != null && searchQuery.isNotEmpty) {
        filtered = filtered.where((shop) => 
          (shop.shopName?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false) ||
          (shop.shopEmail?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false) ||
          (shop.shopPhoneNo?.contains(searchQuery) ?? false)
        ).toList();
      }

      if (statusFilter != null && statusFilter != 'All') {
        filtered = filtered.where((shop) => shop.status == statusFilter.toLowerCase()).toList();
      }
      
      state = state.copyWith(
        isLoading: false,
        shops: shops,
        filteredShops: filtered,
        totalCount: data['total'],
        currentPage: page,
        limit: limit,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateShopStatus(String shopId, String status) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _service.updateShop(shopId, {'status': status});
      await loadShops(page: state.currentPage, limit: state.limit);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  void filterShops(String query, String status) {
    List<PharmaShop> filtered = state.shops;
    
    if (query.isNotEmpty) {
      filtered = filtered.where((shop) => 
        (shop.shopName?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
        (shop.shopEmail?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
        (shop.shopPhoneNo?.contains(query) ?? false)
      ).toList();
    }

    if (status != 'All') {
      filtered = filtered.where((shop) => shop.status == status.toLowerCase()).toList();
    }

    state = state.copyWith(filteredShops: filtered);
  }
}

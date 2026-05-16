import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/pharma_shop_notifier.dart';
import '../services/pharma_shop_services.dart';

final pharmaShopServiceProvider = Provider<PharmaShopService>((ref) {
  return PharmaShopService();
});

final pharmaShopProvider = StateNotifierProvider<PharmaShopNotifier, PharmaShopState>((ref) {
  final service = ref.watch(pharmaShopServiceProvider);
  return PharmaShopNotifier(service);
});

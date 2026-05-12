import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/about_us_services.dart';
import '../notifiers/about_us_notifier.dart';

final aboutUsServiceProvider = Provider<AboutUsService>((ref) {
  return AboutUsService();
});

final aboutUsProvider = StateNotifierProvider<AboutUsNotifier, AboutUsState>((ref) {
  final service = ref.watch(aboutUsServiceProvider);
  return AboutUsNotifier(service);
});

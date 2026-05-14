import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/terms_conditions_notifier.dart';
import '../services/terms_conditions_services.dart';

final termsConditionsServicesProvider = Provider<TermsConditionsServices>((ref) {
  return TermsConditionsServices();
});

final termsConditionsNotifierProvider = StateNotifierProvider<TermsConditionsNotifier, TermsConditionsState>((ref) {
  final services = ref.watch(termsConditionsServicesProvider);
  return TermsConditionsNotifier(services);
});

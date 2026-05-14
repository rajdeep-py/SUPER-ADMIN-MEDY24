import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/privacy_policy_notifier.dart';
import '../services/privacy_policy_services.dart';

final privacyPolicyServicesProvider = Provider<PrivacyPolicyServices>((ref) {
  return PrivacyPolicyServices();
});

final privacyPolicyNotifierProvider = StateNotifierProvider<PrivacyPolicyNotifier, PrivacyPolicyState>((ref) {
  final services = ref.watch(privacyPolicyServicesProvider);
  return PrivacyPolicyNotifier(services);
});

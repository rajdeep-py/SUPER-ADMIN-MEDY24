import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/medicine_services.dart';
import '../notifiers/medicine_notifier.dart';

final medicineServiceProvider = Provider((ref) {
  return MedicineServices();
});

final medicineNotifierProvider = StateNotifierProvider<MedicineNotifier, MedicineState>((ref) {
  final services = ref.watch(medicineServiceProvider);
  return MedicineNotifier(services);
});

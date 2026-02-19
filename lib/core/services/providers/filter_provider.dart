import 'package:flutter_riverpod/flutter_riverpod.dart';

// Class เก็บสถานะของตัวกรอง
class FilterState {
  final List<String> selectedAmenities;
  final List<String> selectedFuelTypes;

  FilterState({
    this.selectedAmenities = const [],
    this.selectedFuelTypes = const [],
  });

  FilterState copyWith({
    List<String>? selectedAmenities,
    List<String>? selectedFuelTypes,
  }) {
    return FilterState(
      selectedAmenities: selectedAmenities ?? this.selectedAmenities,
      selectedFuelTypes: selectedFuelTypes ?? this.selectedFuelTypes,
    );
  }
}

// Notifier สำหรับอัปเดตค่าเวลาผู้ใช้กดติ๊ก Checkbox
class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier() : super(FilterState());

  void toggleAmenity(String amenity) {
    final current = state.selectedAmenities;
    if (current.contains(amenity)) {
      state = state.copyWith(
          selectedAmenities: current.where((a) => a != amenity).toList());
    } else {
      state = state.copyWith(selectedAmenities: [...current, amenity]);
    }
  }

  void toggleFuelType(String fuel) {
    final current = state.selectedFuelTypes;
    if (current.contains(fuel)) {
      state = state.copyWith(
          selectedFuelTypes: current.where((f) => f != fuel).toList());
    } else {
      state = state.copyWith(selectedFuelTypes: [...current, fuel]);
    }
  }

  void clearFilters() {
    state = FilterState(); // รีเซ็ตค่าทั้งหมด
  }
}

// ตัว Provider ที่เราจะเรียกใช้ในหน้า Map และหน้า Filter
final filterProvider =
    StateNotifierProvider<FilterNotifier, FilterState>((ref) {
  return FilterNotifier();
});

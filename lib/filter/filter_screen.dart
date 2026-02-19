import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/providers/filter_provider.dart';

class FilterScreen extends ConsumerWidget {
  const FilterScreen({super.key});

  // รายการตัวเลือกทั้งหมด (อิงจาก Mock Data ที่เราสร้างไว้)
  final List<String> availableAmenities = const [
    '7-Eleven',
    'Cafe Amazon',
    'Clean Restroom',
    'Inthanin Coffee',
    'Mini Big C',
    'Deli Cafe'
  ];
  final List<String> availableFuelTypes = const [
    'Gasohol 91',
    'Gasohol 95',
    'E20',
    'E85',
    'Diesel',
    'V-Power Gasohol 95',
    'V-Power Diesel'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // อ่านค่า State ปัจจุบันจาก Provider
    final filterState = ref.watch(filterProvider);
    final filterNotifier = ref.read(filterProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('กรองการค้นหา'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () => filterNotifier.clearFilters(),
            child: const Text('ล้างค่า',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('สิ่งอำนวยความสะดวก',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...availableAmenities.map((amenity) {
            return CheckboxListTile(
              title: Text(amenity),
              value: filterState.selectedAmenities.contains(amenity),
              onChanged: (bool? value) {
                filterNotifier.toggleAmenity(amenity);
              },
            );
          }),
          const Divider(height: 40),
          const Text('ประเภทน้ำมัน',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...availableFuelTypes.map((fuel) {
            return CheckboxListTile(
              title: Text(fuel),
              value: filterState.selectedFuelTypes.contains(fuel),
              onChanged: (bool? value) {
                filterNotifier.toggleFuelType(fuel);
              },
            );
          }),
        ],
      ),
    );
  }
}

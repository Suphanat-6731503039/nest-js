import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/providers/filter_provider.dart';

class FilterScreen extends ConsumerWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ดึง State และ Notifier มาใช้งาน
    final filterState = ref.watch(filterProvider);
    final filterNotifier = ref.read(filterProvider.notifier);

    // 🟢 แก้ไขคำให้ตรงกับใน mockGasStations แบบเป๊ะๆ!
    final availableAmenities = [
      '7-Eleven',
      'Cafe Amazon',
      'Punthai Coffee',
      'Inthanin Coffee',
      'MaxMart',
      'Mini Big C',
      'ห้องน้ำสะอาด',
      'ร้านอาหาร',
      'ร้านของชำ'
    ];

    final availableFuels = [
      'แก๊สโซฮอล์ 95',
      'แก๊สโซฮอล์ 91',
      'E20',
      'ดีเซล',
      'EV Charging',
      'LPG'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('กรองข้อมูลปั๊มน้ำมัน'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              filterNotifier.clearFilters();
            },
            child: const Text('ล้างทั้งหมด',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'สิ่งอำนวยความสะดวก',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: availableAmenities.map((amenity) {
              final isSelected =
                  filterState.selectedAmenities.contains(amenity);
              return FilterChip(
                label: Text(amenity),
                selected: isSelected,
                selectedColor: Colors.blue[100],
                checkmarkColor: Colors.blue,
                onSelected: (_) {
                  filterNotifier.toggleAmenity(amenity);
                },
              );
            }).toList(),
          ),
          const Divider(height: 40),
          const Text(
            'ประเภทน้ำมัน / พลังงาน',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: availableFuels.map((fuel) {
              final isSelected = filterState.selectedFuelTypes.contains(fuel);
              return FilterChip(
                label: Text(fuel),
                selected: isSelected,
                selectedColor: Colors.green[100],
                checkmarkColor: Colors.green,
                onSelected: (_) {
                  filterNotifier.toggleFuelType(fuel);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

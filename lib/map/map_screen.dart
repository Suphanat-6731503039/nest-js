import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/gas_station.dart';
import '../core/services/providers/filter_provider.dart';
import '../filter/filter_screen.dart';
import '../settings/settings_screen.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();

  // 🟢 1. ตั้งพิกัดเริ่มต้นเป็นประเทศไทย (กลางประเทศ)
  LatLng _currentPosition = const LatLng(15.8700, 100.9925);
  bool _isLoadingLocation = true;
  String? _selectedDistrict; // เก็บอำเภอที่เลือก

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _isLoadingLocation = false;
    });
    // เมื่อได้ตำแหน่งจริง จะซูมเข้าไปที่ตำแหน่งผู้ใช้
    _mapController.move(_currentPosition, 14.0);
  }

  // 🟢 2. ระบบนำทางผ่านเว็บ OpenStreetMap (OSRM)
  Future<void> _navigateToStation(double destLat, double destLng) async {
    final currentLat = _currentPosition.latitude;
    final currentLng = _currentPosition.longitude;

    final urlString =
        'https://www.openstreetmap.org/directions?engine=osrm_car&route=$currentLat,$currentLng;$destLat,$destLng';
    final url = Uri.parse(urlString);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่สามารถเปิดระบบนำทางได้')),
      );
    }
  }

  void _showStationDetails(GasStation station) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(station.name,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('แบรนด์: ${station.brand}',
                  style: const TextStyle(color: Colors.grey, fontSize: 16)),
              const Divider(height: 20),
              const Text('สิ่งอำนวยความสะดวก:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                  spacing: 8,
                  children: station.amenities
                      .map((a) => Chip(label: Text(a)))
                      .toList()),
              const SizedBox(height: 20),

              // 🟢 ปุ่มกดนำทาง
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.directions_car),
                  label: const Text('นำทางด้วย OpenStreetMap'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white),
                  onPressed: () => _navigateToStation(
                      station.location.latitude, station.location.longitude),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(filterProvider);

    // 🟢 กำหนดให้แสดงปั้มทั้งหมด หรือกรองตามเงื่อนไข
    List<GasStation> displayStations;

    if (_selectedDistrict != null) {
      // ถ้าเลือกอำเภอ ให้แสดงเฉพาะปั้มในอำเภอนั้น
      displayStations = mockGasStations
          .where((station) => station.district == _selectedDistrict)
          .toList();
    } else if (filterState.selectedAmenities.isEmpty &&
        filterState.selectedFuelTypes.isEmpty) {
      // ถ้าไม่มี filter เลือก ให้แสดงปั้มทั้งหมด
      displayStations = mockGasStations;
    } else {
      // ถ้ามี filter เลือก ให้แสดงปั้มที่มี amenity หรือ fuel type ที่เลือก
      displayStations = mockGasStations.where((station) {
        bool matchAmenity = filterState.selectedAmenities.isEmpty ||
            filterState.selectedAmenities
                .any((a) => station.amenities.contains(a));
        bool matchFuel = filterState.selectedFuelTypes.isEmpty ||
            filterState.selectedFuelTypes
                .any((f) => station.fuelTypes.contains(f));
        return matchAmenity && matchFuel;
      }).toList();
    }

    // Debug: แสดงจำนวนสถานีบริบูรณ์ที่จะแสดง
    print('Total mockGasStations: ${mockGasStations.length}');
    print('Display stations: ${displayStations.length}');

    // 🟢 ฟังก์ชันสำหรับสร้างโลโก้แบรนด์
    Widget _buildBrandLogo(String brand) {
      // กำหนดสีตามแบรนด์
      late Color logoColor;

      switch (brand.toUpperCase()) {
        case 'PTT':
          logoColor = Colors.amber;
          break;
        case 'BANGCHAK':
          logoColor = Colors.orange;
          break;
        case 'SHELL':
          logoColor = Colors.yellow;
          break;
        default:
          logoColor = Colors.red;
      }

      return Container(
        decoration: BoxDecoration(
          color: logoColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: CircleAvatar(
          backgroundColor: logoColor,
          radius: 20,
          child: Text(
            brand.isNotEmpty ? brand[0].toUpperCase() : '?',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        // 🟢 3. แสดงโลโก้คู่กับชื่อแอป (Assets ต้องถูกลงทะเบียนใน pubspec.yaml แล้ว)
        title: Row(
          children: [
            Image.asset('assets/logo.png',
                width: 30,
                height: 30,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.local_gas_station)),
            const SizedBox(width: 10),
            const Text('FuelNear'),
          ],
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FilterScreen()))),
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()))),
        ],
      ),
      body: Column(
        children: [
          // 🟢 ปุ่มเลือกอำเภอ (สร้างรายการจาก mockGasStations)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...({
                    // ใช้ Set เพื่อเอาแต่ชื่ออำเภอที่ไม่ซ้ำ
                    for (var s in mockGasStations) s.district
                  }.toList()
                        ..sort())
                      .map((district) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _selectedDistrict == district
                                    ? Colors.blueAccent
                                    : Colors.grey[300],
                                foregroundColor: _selectedDistrict == district
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedDistrict =
                                      _selectedDistrict == district
                                          ? null
                                          : district;
                                });
                                // ถ้ามีย่านที่ระบุ ก็ซูมคร่าว ๆ ไปตำแหน่งปั๊มแรกในอำเภอ
                                if (_selectedDistrict != null) {
                                  final first = mockGasStations.firstWhere(
                                      (s) => s.district == _selectedDistrict);
                                  _mapController.move(first.location, 13.0);
                                } else {
                                  _mapController.move(_currentPosition, 6.0);
                                }
                              },
                              child: Text(district),
                            ),
                          ))
                      .toList(),
                  if (_selectedDistrict != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.clear),
                        label: const Text('ยกเลิก'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400],
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedDistrict = null;
                          });
                          _mapController.move(_currentPosition, 6.0);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          // 🟢 แผนที่
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  // 🟢 ตั้งค่าเริ่มต้นให้เห็นภาพกว้างของเชียงราย
                  options: MapOptions(
                      initialCenter: const LatLng(20.0, 100.2),
                      initialZoom: 9.0),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      // 🔴 แก้ปัญหา Error 403: ใส่ชื่อแพ็กเกจที่ไม่ซ้ำใครเพื่อระบุตัวตนกับ OSM
                      userAgentPackageName: 'com.fuelnear.thailand.navigation',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                            point: _currentPosition,
                            width: 50,
                            height: 50,
                            child: const Icon(Icons.my_location,
                                color: Colors.blue, size: 40)),
                        ...displayStations
                            .map((station) => Marker(
                                  point: station.location,
                                  width: 60,
                                  height: 60,
                                  child: GestureDetector(
                                    onTap: () => _showStationDetails(station),
                                    child: _buildBrandLogo(station.brand),
                                  ),
                                ))
                            .toList(),
                      ],
                    ),
                  ],
                ),
                if (_isLoadingLocation)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _determinePosition, child: const Icon(Icons.gps_fixed)),
    );
  }
}

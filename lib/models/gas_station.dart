import 'package:latlong2/latlong.dart';

class GasStation {
  final String id;
  final String name;
  final String brand;
  final LatLng location;
  final List<String> amenities;
  final List<String> fuelTypes;

  GasStation({
    required this.id,
    required this.name,
    required this.brand,
    required this.location,
    required this.amenities,
    required this.fuelTypes,
  });
}

// ข้อมูลจำลอง (Mock Data) ของปั๊มน้ำมัน
final List<GasStation> mockGasStations = [
  GasStation(
    id: '1',
    name: 'PTT Station วิภาวดีรังสิต',
    brand: 'PTT',
    location: const LatLng(13.7749, 100.5483), // พิกัดจำลอง
    amenities: ['7-Eleven', 'Cafe Amazon', 'Clean Restroom'],
    fuelTypes: ['Gasohol 95', 'E20', 'Diesel'],
  ),
  GasStation(
    id: '2',
    name: 'Bangchak สุขุมวิท 62',
    brand: 'Bangchak',
    location: const LatLng(13.7549, 100.5283), // พิกัดจำลอง
    amenities: ['Inthanin Coffee', 'Mini Big C'],
    fuelTypes: ['Gasohol 91', 'E85', 'Diesel'],
  ),
  GasStation(
    id: '3',
    name: 'Shell เพชรบุรีตัดใหม่',
    brand: 'Shell',
    location: const LatLng(13.7689, 100.5313), // พิกัดจำลอง
    amenities: ['Deli Cafe', 'Clean Restroom'],
    fuelTypes: ['V-Power Gasohol 95', 'V-Power Diesel'],
  ),
];

import 'dart:convert';
import '../../core/storage/local_storage.dart';
import '../models/parking_model.dart';
import '../services/parking_service.dart';

class ParkingDataResult {
  final List<ParkingZone> zones;
  final bool isOnline;

  ParkingDataResult({required this.zones, required this.isOnline});
}

class ParkingRepository {
  final ParkingService _service;

  ParkingRepository({ParkingService? service}) : _service = service ?? ParkingService();

  Future<ParkingDataResult> getParkingZones() async {
    try {
      final response = await _service.fetchParkingZones();
      
      if (response.statusCode == 200) {
        // Parse data
        final List<dynamic> data = json.decode(response.body);
        final zones = data.map((json) => ParkingZone.fromJson(json)).toList();
        
        // Save to cache on success
        await LocalStorage.saveCachedPosts(response.body);
        
        return ParkingDataResult(zones: zones, isOnline: true);
      } else {
        // API failed (e.g. 404, 500)
        return await _getFallbackData();
      }
    } catch (e) {
      // Network error, timeout, etc.
      return await _getFallbackData();
    }
  }

  Future<ParkingDataResult> _getFallbackData() async {
    final cachedData = await LocalStorage.getCachedPosts();
    if (cachedData != null && cachedData.isNotEmpty) {
      try {
        final List<dynamic> data = json.decode(cachedData);
        final zones = data.map((json) => ParkingZone.fromJson(json)).toList();
        return ParkingDataResult(zones: zones, isOnline: false);
      } catch (e) {
        // Failed to parse cache
        return ParkingDataResult(zones: _generateDummyData(), isOnline: false);
      }
    } else {
      // No cache available
      return ParkingDataResult(zones: _generateDummyData(), isOnline: false);
    }
  }

  List<ParkingZone> _generateDummyData() {
    return [
      ParkingZone(
        id: '1',
        name: 'Basement Parking A',
        totalSlots: 50,
        occupiedSlots: 42,
        activeSensors: 50,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 2)),
        slots: List.generate(50, (index) => ParkingSlot(
          id: 'A$index',
          slotNumber: 'A-${index + 1}',
          isOccupied: index < 42,
        )),
      ),
      ParkingZone(
        id: '2',
        name: 'VIP Outdoor Parking',
        totalSlots: 20,
        occupiedSlots: 5,
        activeSensors: 18,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
        slots: List.generate(20, (index) => ParkingSlot(
          id: 'B$index',
          slotNumber: 'B-${index + 1}',
          isOccupied: index < 5,
        )),
      ),
    ];
  }
}

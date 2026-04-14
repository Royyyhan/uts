import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/parking_model.dart';

enum ProviderState { empty, loading, loaded, error }

class ParkingProvider with ChangeNotifier {
  ProviderState _state = ProviderState.empty;
  String _errorMessage = '';
  List<ParkingZone> _zones = [];
  bool _isOnlineData = true;

  ProviderState get state => _state;
  String get errorMessage => _errorMessage;
  List<ParkingZone> get zones => _zones;
  bool get isOnlineData => _isOnlineData;

  // For testing, provide a mock api endpoint or fallback to simulated network delay.
  // The user can replace this with MockAPI.io later.
  final String apiUrl = 'https://mockapi.io/projects/your_id/zones'; // Placeholder

  ParkingProvider() {
    fetchData();
  }

  Future<void> fetchData() async {
    _state = ProviderState.loading;
    notifyListeners();

    try {
      // Trying to fetch from the network (Mock API)
      final response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _zones = data.map((json) => ParkingZone.fromJson(json)).toList();
        _isOnlineData = true;
        _state = _zones.isEmpty ? ProviderState.empty : ProviderState.loaded;
        
        // Save to cache
        await _saveToCache(response.body);
      } else {
        // Fallback to cache since mockapi.io placeholder will fail or give 4xx/5xx
        await _loadFromCache();
      }
    } catch (e) {
      // Network error, timeout, etc.
      await _loadFromCache();
    }
    
    notifyListeners();
  }

  Future<void> _saveToCache(String jsonData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_zones', jsonData);
  }

  Future<void> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_zones');
    
    if (cachedData != null) {
      final List<dynamic> data = json.decode(cachedData);
      _zones = data.map((json) => ParkingZone.fromJson(json)).toList();
      _isOnlineData = false; // Indicate this is cached data
      _state = _zones.isEmpty ? ProviderState.empty : ProviderState.loaded;
    } else {
      // Simulate data when nothing is found and api fails (for presentation)
      _generateDummyData();
    }
  }

  void _generateDummyData() {
    // Generates dummy data initially if no cache and no internet available.
    _zones = [
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
        activeSensors: 18, // 2 sensors offline
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
        slots: List.generate(20, (index) => ParkingSlot(
          id: 'B$index',
          slotNumber: 'B-${index + 1}',
          isOccupied: index < 5,
        )),
      ),
    ];
    _isOnlineData = false;
    _state = ProviderState.loaded;
  }
}

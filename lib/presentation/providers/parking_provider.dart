import 'package:flutter/material.dart';
import '../../data/models/parking_model.dart';
import '../../domain/usecases/get_parking_zones_usecase.dart';

enum ProviderState { empty, loading, loaded, error }

class ParkingProvider with ChangeNotifier {
  ProviderState _state = ProviderState.empty;
  String _errorMessage = '';
  List<ParkingZone> _zones = [];
  bool _isOnlineData = true;
  final GetParkingZonesUseCase _getParkingZonesUseCase = GetParkingZonesUseCase();

  ProviderState get state => _state;
  String get errorMessage => _errorMessage;
  List<ParkingZone> get zones => _zones;
  bool get isOnlineData => _isOnlineData;

  ParkingProvider() {
    fetchData();
  }

  Future<void> fetchData() async {
    _state = ProviderState.loading;
    notifyListeners();

    try {
      final result = await _getParkingZonesUseCase.execute();
      _zones = result.zones;
      _isOnlineData = result.isOnline;
      _state = _zones.isEmpty ? ProviderState.empty : ProviderState.loaded;
    } catch (e) {
      _errorMessage = 'An error occurred';
      _state = ProviderState.error;
    }
    
    notifyListeners();
  }
}

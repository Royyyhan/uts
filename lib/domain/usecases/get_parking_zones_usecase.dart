import '../../data/repositories/parking_repository.dart';

class GetParkingZonesUseCase {
  final ParkingRepository _repository;

  GetParkingZonesUseCase({ParkingRepository? repository}) 
      : _repository = repository ?? ParkingRepository();

  Future<ParkingDataResult> execute() async {
    // The UseCase can contain additional business logic here if needed
    // before or after calling the repository.
    return await _repository.getParkingZones();
  }
}

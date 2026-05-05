import 'package:http/http.dart' as http;

class ParkingService {
  final String apiUrl = 'https://mockapi.io/projects/your_id/zones'; // Placeholder

  Future<http.Response> fetchParkingZones() async {
    // Service purely handles the HTTP request
    return await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 5));
  }
}

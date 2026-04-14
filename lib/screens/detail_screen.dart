import 'package:flutter/material.dart';
import '../models/parking_model.dart';

class DetailScreen extends StatelessWidget {
  final ParkingZone zone;

  const DetailScreen({Key? key, required this.zone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1c29),
      appBar: AppBar(
        title: Text(zone.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF23263a),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(),
            const SizedBox(height: 24),
            const Text(
              'Parking Slots Live View',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: zone.slots.length,
                itemBuilder: (context, index) {
                  final slot = zone.slots[index];
                  return _buildSlotIndicator(slot);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF23263a),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(Icons.local_parking, 'Total', '${zone.totalSlots}', Colors.blueAccent),
          _buildSummaryItem(Icons.check_circle_outline, 'Available', '${zone.availableSlots}', Colors.greenAccent),
          _buildSummaryItem(Icons.directions_car, 'Occupied', '${zone.occupiedSlots}', Colors.orangeAccent),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  Widget _buildSlotIndicator(ParkingSlot slot) {
    return Container(
      decoration: BoxDecoration(
        color: slot.isOccupied ? Colors.orangeAccent.withOpacity(0.2) : Colors.greenAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: slot.isOccupied ? Colors.orangeAccent : Colors.greenAccent,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            slot.isOccupied ? Icons.directions_car : Icons.local_parking,
            color: slot.isOccupied ? Colors.orangeAccent : Colors.greenAccent,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            slot.slotNumber,
            style: TextStyle(
              color: slot.isOccupied ? Colors.orangeAccent : Colors.greenAccent,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

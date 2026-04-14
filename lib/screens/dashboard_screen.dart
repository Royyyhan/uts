import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/parking_provider.dart';
import 'detail_screen.dart';
import '../models/parking_model.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1c29),
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF23263a),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ParkingProvider>().fetchData();
            },
          )
        ],
      ),
      body: Consumer<ParkingProvider>(
        builder: (context, provider, child) {
          if (provider.state == ProviderState.loading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            );
          }

          if (provider.state == ProviderState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage.isNotEmpty ? provider.errorMessage : 'Failed to load data',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchData(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.state == ProviderState.empty) {
            return const Center(
              child: Text('No Parking Zones Available', style: TextStyle(color: Colors.white70)),
            );
          }

          return Column(
            children: [
              _buildDataSourceIndicator(provider.isOnlineData),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => provider.fetchData(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.zones.length,
                    itemBuilder: (context, index) {
                      final zone = provider.zones[index];
                      return _buildZoneCard(context, zone);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDataSourceIndicator(bool isOnline) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: isOnline ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isOnline ? Icons.cloud_done : Icons.cloud_off, 
            color: isOnline ? Colors.greenAccent : Colors.orangeAccent,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            isOnline ? 'Online Data' : 'Cached Data',
            style: TextStyle(
              color: isOnline ? Colors.greenAccent : Colors.orangeAccent,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoneCard(BuildContext context, ParkingZone zone) {
    final double occupancyRate = zone.totalSlots > 0 ? zone.occupiedSlots / zone.totalSlots : 0;
    final bool isFull = occupancyRate >= 1.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(zone: zone),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF23263a),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  zone.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isFull ? Colors.redAccent.withOpacity(0.2) : Colors.greenAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isFull ? 'FULL' : 'AVAILABLE',
                    style: TextStyle(
                      color: isFull ? Colors.redAccent : Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem('Available', '${zone.availableSlots}', Colors.greenAccent),
                _buildStatItem('Occupied', '${zone.occupiedSlots}', Colors.orangeAccent),
                _buildStatItem('Sensors', '${zone.activeSensors}/${zone.totalSlots}', Colors.blueAccent),
              ],
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: occupancyRate,
                backgroundColor: Colors.white12,
                color: _getOccupancyColor(occupancyRate),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.access_time, size: 12, color: Colors.white30),
                const SizedBox(width: 4),
                Text(
                  'Updated: ${DateFormat('HH:mm').format(zone.lastUpdated)}',
                  style: const TextStyle(color: Colors.white30, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getOccupancyColor(double rate) {
    if (rate > 0.85) return Colors.redAccent;
    if (rate > 0.5) return Colors.orangeAccent;
    return Colors.greenAccent;
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

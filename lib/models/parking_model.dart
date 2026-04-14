class ParkingSlot {
  final String id;
  final String slotNumber;
  final bool isOccupied;

  ParkingSlot({
    required this.id,
    required this.slotNumber,
    required this.isOccupied,
  });

  factory ParkingSlot.fromJson(Map<String, dynamic> json) {
    return ParkingSlot(
      id: json['id'] ?? '',
      slotNumber: json['slotNumber'] ?? '',
      isOccupied: json['isOccupied'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slotNumber': slotNumber,
      'isOccupied': isOccupied,
    };
  }
}

class ParkingZone {
  final String id;
  final String name;
  final int totalSlots;
  final int occupiedSlots;
  final int activeSensors;
  final DateTime lastUpdated;
  final List<ParkingSlot> slots;

  ParkingZone({
    required this.id,
    required this.name,
    required this.totalSlots,
    required this.occupiedSlots,
    required this.activeSensors,
    required this.lastUpdated,
    required this.slots,
  });

  int get availableSlots => totalSlots - occupiedSlots;

  factory ParkingZone.fromJson(Map<String, dynamic> json) {
    var slotList = json['slots'] as List? ?? [];
    List<ParkingSlot> slots = slotList.map((i) => ParkingSlot.fromJson(i)).toList();

    return ParkingZone(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Zone',
      totalSlots: json['totalSlots'] ?? 0,
      occupiedSlots: json['occupiedSlots'] ?? 0,
      activeSensors: json['activeSensors'] ?? 0,
      lastUpdated: json['lastUpdated'] != null 
          ? DateTime.tryParse(json['lastUpdated']) ?? DateTime.now() 
          : DateTime.now(),
      slots: slots,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'totalSlots': totalSlots,
      'occupiedSlots': occupiedSlots,
      'activeSensors': activeSensors,
      'lastUpdated': lastUpdated.toIso8601String(),
      'slots': slots.map((s) => s.toJson()).toList(),
    };
  }
}

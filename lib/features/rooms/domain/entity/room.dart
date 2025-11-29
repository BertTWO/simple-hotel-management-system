// lib/data/models/room.dart
import 'package:floor/floor.dart';

@Entity(tableName: 'rooms')
class Room {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'room_number')
  final String roomNumber;

  final String type; // 'single', 'double', 'deluxe', 'suite'

  @ColumnInfo(name: 'price_per_night')
  final double pricePerNight;

  final String status; // 'available', 'occupied', 'maintenance', 'cleaning'

  final String? description;

  final int capacity;

  Room({
    this.id,
    required this.roomNumber,
    required this.type,
    required this.pricePerNight,
    required this.status,
    this.description,
    required this.capacity,
  });

  Room copyWith({
    int? id,
    String? roomNumber,
    String? type,
    double? pricePerNight,
    String? status,
    String? description,
    int? capacity,
  }) {
    return Room(
      id: id ?? this.id,
      roomNumber: roomNumber ?? this.roomNumber,
      type: type ?? this.type,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      status: status ?? this.status,
      description: description ?? this.description,
      capacity: capacity ?? this.capacity,
    );
  }

  @override
  String toString() {
    return 'Room(id: $id, roomNumber: $roomNumber, type: $type, pricePerNight: $pricePerNight, status: $status, capacity: $capacity)';
  }
}

// lib/data/models/booking.dart
import 'package:floor/floor.dart';
import 'package:jordanhotel/features/rooms/domain/entity/room.dart';
import 'package:jordanhotel/features/guest/domain/entity/guest.dart';

@Entity(
  tableName: 'bookings',
  foreignKeys: [
    ForeignKey(
      childColumns: ['guest_id'],
      parentColumns: ['id'],
      entity: Guest,
    ),

    ForeignKey(
      childColumns: ['room_id'],
      parentColumns: ['id'],
      entity: Room,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class Booking {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'guest_id')
  final int guestId;

  @ColumnInfo(name: 'room_id')
  final int roomId;

  @ColumnInfo(name: 'check_in_date')
  final String checkInDate; // ISO string

  @ColumnInfo(name: 'check_out_date')
  final String checkOutDate; // ISO string

  @ColumnInfo(name: 'number_of_guests')
  final int numberOfGuests;

  @ColumnInfo(name: 'total_amount')
  final double totalAmount;

  final String status; // 'confirmed', 'checked_in', 'checked_out', 'cancelled'

  @ColumnInfo(name: 'created_at')
  final String createdAt; // ISO string

  @ColumnInfo(name: 'special_requests')
  final String? specialRequests;

  Booking({
    this.id,
    required this.guestId,
    required this.roomId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberOfGuests,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.specialRequests,
  });

  Booking copyWith({
    int? id,
    int? guestId,
    int? roomId,
    String? checkInDate,
    String? checkOutDate,
    int? numberOfGuests,
    double? totalAmount,
    String? status,
    String? createdAt,
    String? specialRequests,
  }) {
    return Booking(
      id: id ?? this.id,
      guestId: guestId ?? this.guestId,
      roomId: roomId ?? this.roomId,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      numberOfGuests: numberOfGuests ?? this.numberOfGuests,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      specialRequests: specialRequests ?? this.specialRequests,
    );
  }

  @override
  String toString() {
    return 'Booking(id: $id, guestId: $guestId, roomId: $roomId, status: $status, totalAmount: $totalAmount)';
  }
}

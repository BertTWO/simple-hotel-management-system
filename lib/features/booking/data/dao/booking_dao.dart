// lib/data/database/dao/booking_dao.dart
import 'package:floor/floor.dart';
import 'package:jordanhotel/features/booking/domain/entity/booking.dart';

@dao
abstract class BookingDao {
  @Query('SELECT * FROM bookings')
  Future<List<Booking>> getAllBookings();

  @Query('SELECT * FROM bookings WHERE id = :id')
  Future<Booking?> getBookingById(int id);

  @Query('SELECT * FROM bookings WHERE guest_id = :guestId')
  Future<List<Booking>> getBookingsByGuestId(int guestId);

  @Query('SELECT * FROM bookings WHERE room_id = :roomId')
  Future<List<Booking>> getBookingsByRoomId(int roomId);

  @Query('SELECT * FROM bookings WHERE status = :status')
  Future<List<Booking>> getBookingsByStatus(String status);

  @Query('''
    SELECT * FROM bookings 
    WHERE check_in_date <= :date AND check_out_date >= :date
  ''')
  Future<List<Booking>> getActiveBookingsOnDate(String date);

  @Query('''
    SELECT * FROM bookings 
    WHERE room_id = :roomId 
    AND status IN ("confirmed", "checked_in")
    AND (
      (check_in_date <= :checkIn AND check_out_date >= :checkIn) OR
      (check_in_date <= :checkOut AND check_out_date >= :checkOut) OR
      (check_in_date >= :checkIn AND check_out_date <= :checkOut)
    )
  ''')
  Future<List<Booking>> checkRoomAvailability(
    int roomId,
    String checkIn,
    String checkOut,
  );

  @insert
  Future<int> insertBooking(Booking booking);

  @update
  Future<void> updateBooking(Booking booking);

  @delete
  Future<void> deleteBooking(Booking booking);

  @Query('DELETE FROM bookings WHERE id = :id')
  Future<void> deleteBookingById(int id);
}

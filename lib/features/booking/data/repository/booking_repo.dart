// lib/features/bookings/data/booking_repository.dart
import 'package:jordanhotel/features/booking/data/dao/booking_dao.dart';
import 'package:jordanhotel/features/booking/domain/entity/booking.dart';

class BookingRepository {
  final BookingDao _bookingDao;

  BookingRepository(this._bookingDao);

  Future<List<Booking>> getAllBookings() async {
    return await _bookingDao.getAllBookings();
  }

  Future<Booking?> getBookingById(int id) async {
    return await _bookingDao.getBookingById(id);
  }

  Future<List<Booking>> getBookingsByGuestId(int guestId) async {
    return await _bookingDao.getBookingsByGuestId(guestId);
  }

  Future<List<Booking>> getBookingsByRoomId(int roomId) async {
    return await _bookingDao.getBookingsByRoomId(roomId);
  }

  Future<List<Booking>> getBookingsByStatus(String status) async {
    return await _bookingDao.getBookingsByStatus(status);
  }

  Future<List<Booking>> getActiveBookingsOnDate(String date) async {
    return await _bookingDao.getActiveBookingsOnDate(date);
  }

  Future<bool> isRoomAvailable(
    int roomId,
    String checkIn,
    String checkOut,
  ) async {
    final conflictingBookings = await _bookingDao.checkRoomAvailability(
      roomId,
      checkIn,
      checkOut,
    );
    return conflictingBookings.isEmpty;
  }

  Future<int> addBooking(Booking booking) async {
    return await _bookingDao.insertBooking(booking);
  }

  Future<void> updateBooking(Booking booking) async {
    await _bookingDao.updateBooking(booking);
  }

  Future<void> deleteBooking(Booking booking) async {
    await _bookingDao.deleteBooking(booking);
  }

  Future<void> deleteBookingById(int id) async {
    await _bookingDao.deleteBookingById(id);
  }
}

// lib/features/bookings/business_logic/booking_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jordanhotel/features/booking/data/repository/booking_repo.dart';
import 'package:jordanhotel/features/booking/domain/entity/booking.dart';
import 'package:jordanhotel/features/guest/data/repository/guest_repo.dart';
import 'package:jordanhotel/features/guest/domain/entity/guest.dart';
import 'package:jordanhotel/features/rooms/data/repository/room_repo.dart';
import 'package:jordanhotel/features/rooms/domain/entity/room.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository _bookingRepository;
  final RoomRepository _roomRepository;
  final GuestRepository _guestRepository;
  BookingCubit(
    this._bookingRepository,
    this._roomRepository,
    this._guestRepository,
  ) : super(BookingInitial());

  Future<void> loadAllBookings() async {
    emit(BookingLoading());
    try {
      final bookings = await _bookingRepository.getAllBookings();
      emit(BookingLoaded(bookings));
    } catch (e) {
      emit(BookingError('Failed to load bookings: $e'));
    }
  }

  Future<void> loadBookingsByStatus(String status) async {
    emit(BookingLoading());
    try {
      final bookings = await _bookingRepository.getBookingsByStatus(status);
      emit(BookingLoaded(bookings));
    } catch (e) {
      emit(BookingError('Failed to load bookings: $e'));
    }
  }

  Future<void> loadBookingsByGuest(int guestId) async {
    emit(BookingLoading());
    try {
      final bookings = await _bookingRepository.getBookingsByGuestId(guestId);
      emit(BookingLoaded(bookings));
    } catch (e) {
      emit(BookingError('Failed to load guest bookings: $e'));
    }
  }

  Future<void> checkRoomAvailability(
    int roomId,
    String checkIn,
    String checkOut,
  ) async {
    try {
      final isAvailable = await _bookingRepository.isRoomAvailable(
        roomId,
        checkIn,
        checkOut,
      );
      emit(RoomAvailabilityChecked(isAvailable));
    } catch (e) {
      emit(BookingError('Failed to check room availability: $e'));
    }
  }

  // lib/features/bookings/business_logic/booking_cubit.dart
  Future<void> addBooking(Booking booking) async {
    try {
      // Check room availability first
      final isAvailable = await _bookingRepository.isRoomAvailable(
        booking.roomId,
        booking.checkInDate,
        booking.checkOutDate,
      );

      if (!isAvailable) {
        emit(BookingError('Room is not available for the selected dates'));
        return;
      }

      final bookingId = await _bookingRepository.addBooking(booking);
      // You can emit success with the new ID if needed
      emit(BookingOperationSuccess('Booking #$bookingId created successfully'));
      await loadAllBookings();
    } catch (e) {
      emit(BookingError('Failed to create booking: $e'));
    }
  }

  Future<Room?> getRoomById(int roomId) async {
    return await _roomRepository.getRoomById(roomId);
  }

  Future<void> updateBooking(Booking booking) async {
    try {
      await _bookingRepository.updateBooking(booking);
      emit(BookingOperationSuccess('Booking updated successfully'));
      await loadAllBookings();
    } catch (e) {
      emit(BookingError('Failed to update booking: $e'));
    }
  }

  Future<void> deleteBooking(Booking booking) async {
    try {
      await _bookingRepository.deleteBooking(booking);
      emit(BookingOperationSuccess('Booking deleted successfully'));
      await loadAllBookings();
    } catch (e) {
      emit(BookingError('Failed to delete booking: $e'));
    }
  }

  Future<List<Guest>> searchGuests(String query) async {
    return await _guestRepository.searchGuests(query);
  }

  Future<List<Room>> searchAvailableRooms(String query) async {
    return await _roomRepository.searchRooms(query);
  }

  Future<void> deleteBookingById(int id) async {
    try {
      await _bookingRepository.deleteBookingById(id);
      emit(BookingOperationSuccess('Booking deleted successfully'));
      await loadAllBookings();
    } catch (e) {
      emit(BookingError('Failed to delete booking: $e'));
    }
  }
}

// lib/features/bookings/business_logic/booking_state.dart
part of 'booking_cubit.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<Booking> bookings;

  const BookingLoaded(this.bookings);

  @override
  List<Object> get props => [bookings];
}

class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object> get props => [message];
}

class BookingOperationSuccess extends BookingState {
  final String message;

  const BookingOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class RoomAvailabilityChecked extends BookingState {
  final bool isAvailable;

  const RoomAvailabilityChecked(this.isAvailable);

  @override
  List<Object> get props => [isAvailable];
}

// lib/features/dashboard/business_logic/dashboard_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jordanhotel/features/booking/data/repository/booking_repo.dart';
import 'package:jordanhotel/features/guest/data/repository/guest_repo.dart';
import 'package:jordanhotel/features/payment/data/repository/payment_repo.dart';
import 'package:jordanhotel/features/rooms/data/repository/room_repo.dart';
part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final RoomRepository _roomRepository;
  final GuestRepository _guestRepository;
  final BookingRepository _bookingRepository;
  final PaymentRepository _paymentRepository;

  DashboardCubit({
    required RoomRepository roomRepository,
    required GuestRepository guestRepository,
    required BookingRepository bookingRepository,
    required PaymentRepository paymentRepository,
  }) : _roomRepository = roomRepository,
       _guestRepository = guestRepository,
       _bookingRepository = bookingRepository,
       _paymentRepository = paymentRepository,
       super(DashboardInitial());

  Future<void> loadDashboardData() async {
    emit(DashboardLoading());
    try {
      final rooms = await _roomRepository.getAllRooms();
      final guests = await _guestRepository.getAllGuests();
      final bookings = await _bookingRepository.getAllBookings();
      final payments = await _paymentRepository.getAllPayments();

      final totalRooms = rooms.length;
      final availableRooms = rooms
          .where((room) => room.status == 'available')
          .length;
      final occupiedRooms = rooms
          .where((room) => room.status == 'occupied')
          .length;
      final totalGuests = guests.length;

      final activeBookings = bookings
          .where(
            (booking) =>
                booking.status == 'confirmed' || booking.status == 'checked_in',
          )
          .length;

      // Calculate today's revenue (simplified - sum of today's completed payments)
      final todayPayments = payments.where((payment) {
        final paymentDate = DateTime.parse(payment.paymentDate);
        return payment.status == 'completed' &&
            paymentDate.year == DateTime.now().year &&
            paymentDate.month == DateTime.now().month &&
            paymentDate.day == DateTime.now().day;
      });
      final todayRevenue = todayPayments.fold(
        0.0,
        (sum, payment) => sum + payment.amount,
      );

      emit(
        DashboardLoaded(
          totalRooms: totalRooms,
          availableRooms: availableRooms,
          occupiedRooms: occupiedRooms,
          totalGuests: totalGuests,
          activeBookings: activeBookings,
          todayRevenue: todayRevenue,
        ),
      );
    } catch (e) {
      emit(DashboardError('Failed to load dashboard data: $e'));
    }
  }
}

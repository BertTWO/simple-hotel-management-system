// lib/features/payments/business_logic/payment_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jordanhotel/features/booking/data/repository/booking_repo.dart';
import 'package:jordanhotel/features/booking/domain/entity/booking.dart';
import 'package:jordanhotel/features/payment/data/repository/payment_repo.dart';
import 'package:jordanhotel/features/payment/domain/entity/payment.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository _paymentRepository;

  final BookingRepository _bookingRepository;

  PaymentCubit(this._paymentRepository, this._bookingRepository)
    : super(PaymentInitial());

  Future<List<Booking>> searchBookings(String query) async {
    try {
      final allBookings = await _bookingRepository.getAllBookings();
      return allBookings.where((booking) {
        final bookingId = booking.id?.toString() ?? '';
        return bookingId.contains(query) ||
            booking.guestId.toString().contains(query);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> loadAllPayments() async {
    emit(PaymentLoading());
    try {
      final payments = await _paymentRepository.getAllPayments();
      emit(PaymentLoaded(payments));
    } catch (e) {
      emit(PaymentError('Failed to load payments: $e'));
    }
  }

  Future<void> loadPaymentsByBooking(int bookingId) async {
    emit(PaymentLoading());
    try {
      final payments = await _paymentRepository.getPaymentsByBookingId(
        bookingId,
      );
      emit(PaymentLoaded(payments));
    } catch (e) {
      emit(PaymentError('Failed to load booking payments: $e'));
    }
  }

  Future<void> loadPaymentsByStatus(String status) async {
    emit(PaymentLoading());
    try {
      final payments = await _paymentRepository.getPaymentsByStatus(status);
      emit(PaymentLoaded(payments));
    } catch (e) {
      emit(PaymentError('Failed to load payments: $e'));
    }
  }

  Future<void> getTotalPaidAmount(int bookingId) async {
    try {
      final totalPaid = await _paymentRepository.getTotalPaidAmount(bookingId);
      emit(TotalPaidAmountLoaded(totalPaid));
    } catch (e) {
      emit(PaymentError('Failed to get total paid amount: $e'));
    }
  }

  Future<void> addPayment(Payment payment) async {
    try {
      await _paymentRepository.addPayment(payment);
      emit(PaymentOperationSuccess('Payment added successfully'));
      await loadAllPayments();
    } catch (e) {
      emit(PaymentError('Failed to add payment: $e'));
    }
  }

  Future<void> updatePayment(Payment payment) async {
    try {
      await _paymentRepository.updatePayment(payment);
      emit(PaymentOperationSuccess('Payment updated successfully'));
      await loadAllPayments();
    } catch (e) {
      emit(PaymentError('Failed to update payment: $e'));
    }
  }

  Future<void> deletePayment(Payment payment) async {
    try {
      await _paymentRepository.deletePayment(payment);
      emit(PaymentOperationSuccess('Payment deleted successfully'));
      await loadAllPayments();
    } catch (e) {
      emit(PaymentError('Failed to delete payment: $e'));
    }
  }

  Future<void> deletePaymentById(int id) async {
    try {
      await _paymentRepository.deletePaymentById(id);
      emit(PaymentOperationSuccess('Payment deleted successfully'));
      await loadAllPayments();
    } catch (e) {
      emit(PaymentError('Failed to delete payment: $e'));
    }
  }
}

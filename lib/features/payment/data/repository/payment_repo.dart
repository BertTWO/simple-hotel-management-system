// lib/features/payments/data/payment_repository.dart
import 'package:jordanhotel/features/payment/data/dao/payment_dao.dart';
import 'package:jordanhotel/features/payment/domain/entity/payment.dart';

class PaymentRepository {
  final PaymentDao _paymentDao;

  PaymentRepository(this._paymentDao);

  Future<List<Payment>> getAllPayments() async {
    return await _paymentDao.getAllPayments();
  }

  Future<Payment?> getPaymentById(int id) async {
    return await _paymentDao.getPaymentById(id);
  }

  Future<List<Payment>> getPaymentsByBookingId(int bookingId) async {
    return await _paymentDao.getPaymentsByBookingId(bookingId);
  }

  Future<List<Payment>> getPaymentsByStatus(String status) async {
    return await _paymentDao.getPaymentsByStatus(status);
  }

  Future<double> getTotalPaidAmount(int bookingId) async {
    final total = await _paymentDao.getTotalPaidAmount(bookingId);
    return total ?? 0.0;
  }

  Future<int> addPayment(Payment payment) async {
    return await _paymentDao.insertPayment(payment);
  }

  Future<void> updatePayment(Payment payment) async {
    await _paymentDao.updatePayment(payment);
  }

  Future<void> deletePayment(Payment payment) async {
    await _paymentDao.deletePayment(payment);
  }

  Future<void> deletePaymentById(int id) async {
    await _paymentDao.deletePaymentById(id);
  }
}

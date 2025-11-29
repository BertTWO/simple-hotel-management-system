// lib/data/database/dao/payment_dao.dart
import 'package:floor/floor.dart';
import 'package:jordanhotel/features/payment/domain/entity/payment.dart';

@dao
abstract class PaymentDao {
  @Query('SELECT * FROM payments')
  Future<List<Payment>> getAllPayments();

  @Query('SELECT * FROM payments WHERE id = :id')
  Future<Payment?> getPaymentById(int id);

  @Query('SELECT * FROM payments WHERE booking_id = :bookingId')
  Future<List<Payment>> getPaymentsByBookingId(int bookingId);

  @Query('SELECT * FROM payments WHERE status = :status')
  Future<List<Payment>> getPaymentsByStatus(String status);

  @Query(
    'SELECT SUM(amount) FROM payments WHERE booking_id = :bookingId AND status = "completed"',
  )
  Future<double?> getTotalPaidAmount(int bookingId);

  @insert
  Future<int> insertPayment(Payment payment);

  @update
  Future<void> updatePayment(Payment payment);

  @delete
  Future<void> deletePayment(Payment payment);

  @Query('DELETE FROM payments WHERE id = :id')
  Future<void> deletePaymentById(int id);
}

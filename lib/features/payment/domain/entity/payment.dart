// lib/data/models/payment.dart
import 'package:floor/floor.dart';
import 'package:jordanhotel/features/booking/domain/entity/booking.dart';

@Entity(
  tableName: 'payments',
  foreignKeys: [
    ForeignKey(
      childColumns: ['booking_id'],
      parentColumns: ['id'],
      entity: Booking,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class Payment {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'booking_id')
  final int bookingId;

  final double amount;
  final String method; // 'cash', 'credit_card', 'debit_card', 'bank_transfer'
  final String status; // 'pending', 'completed', 'failed', 'refunded'

  @ColumnInfo(name: 'payment_date')
  final String paymentDate; // ISO string

  @ColumnInfo(name: 'transaction_id')
  final String? transactionId;

  final String? notes;

  Payment({
    this.id,
    required this.bookingId,
    required this.amount,
    required this.method,
    required this.status,
    required this.paymentDate,
    this.transactionId,
    this.notes,
  });

  Payment copyWith({
    int? id,
    int? bookingId,
    double? amount,
    String? method,
    String? status,
    String? paymentDate,
    String? transactionId,
    String? notes,
  }) {
    return Payment(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      status: status ?? this.status,
      paymentDate: paymentDate ?? this.paymentDate,
      transactionId: transactionId ?? this.transactionId,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'Payment(id: $id, bookingId: $bookingId, amount: $amount, method: $method, status: $status)';
  }
}

// lib/core/constants/enums.dart
class RoomType {
  static const String single = 'single';
  static const String double = 'double';
  static const String deluxe = 'deluxe';
  static const String suite = 'suite';
}

class RoomStatus {
  static const String available = 'available';
  static const String occupied = 'occupied';
  static const String maintenance = 'maintenance';
  static const String cleaning = 'cleaning';
}

class BookingStatus {
  static const String confirmed = 'confirmed';
  static const String checkedIn = 'checked_in';
  static const String checkedOut = 'checked_out';
  static const String cancelled = 'cancelled';
}

class PaymentMethod {
  static const String cash = 'cash';
  static const String creditCard = 'credit_card';
  static const String debitCard = 'debit_card';
  static const String bankTransfer = 'bank_transfer';
}

class PaymentStatus {
  static const String pending = 'pending';
  static const String completed = 'completed';
  static const String failed = 'failed';
  static const String refunded = 'refunded';
}

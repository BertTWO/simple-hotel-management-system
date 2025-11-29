// lib/features/payments/business_logic/payment_state.dart
part of 'payment_cubit.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentLoaded extends PaymentState {
  final List<Payment> payments;

  const PaymentLoaded(this.payments);

  @override
  List<Object> get props => [payments];
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError(this.message);

  @override
  List<Object> get props => [message];
}

class PaymentOperationSuccess extends PaymentState {
  final String message;

  const PaymentOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class TotalPaidAmountLoaded extends PaymentState {
  final double totalPaid;

  const TotalPaidAmountLoaded(this.totalPaid);

  @override
  List<Object> get props => [totalPaid];
}

// lib/features/guests/business_logic/guest_state.dart
part of 'guest_cubit.dart';

abstract class GuestState extends Equatable {
  const GuestState();

  @override
  List<Object> get props => [];
}

class GuestInitial extends GuestState {}

class GuestLoading extends GuestState {}

class GuestLoaded extends GuestState {
  final List<Guest> guests;

  const GuestLoaded(this.guests);

  @override
  List<Object> get props => [guests];
}

class GuestError extends GuestState {
  final String message;

  const GuestError(this.message);

  @override
  List<Object> get props => [message];
}

class GuestOperationSuccess extends GuestState {
  final String message;

  const GuestOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

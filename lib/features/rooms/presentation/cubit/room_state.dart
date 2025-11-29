part of 'room_cubit.dart';

abstract class RoomState extends Equatable {
  const RoomState();

  @override
  List<Object> get props => [];
}

class RoomInitial extends RoomState {}

class RoomLoading extends RoomState {}

class RoomLoaded extends RoomState {
  final List<Room> rooms;

  const RoomLoaded(this.rooms);

  @override
  List<Object> get props => [rooms];
}

class RoomError extends RoomState {
  final String message;

  const RoomError(this.message);

  @override
  List<Object> get props => [message];
}

class RoomOperationSuccess extends RoomState {
  final String message;

  const RoomOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

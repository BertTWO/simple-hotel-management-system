// lib/features/rooms/business_logic/room_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jordanhotel/features/rooms/data/repository/room_repo.dart';
import 'package:jordanhotel/features/rooms/domain/entity/room.dart';

part 'room_state.dart';

class RoomCubit extends Cubit<RoomState> {
  final RoomRepository _roomRepository;

  RoomCubit(this._roomRepository) : super(RoomInitial());

  Future<void> loadAllRooms() async {
    emit(RoomLoading());
    try {
      final rooms = await _roomRepository.getAllRooms();
      emit(RoomLoaded(rooms));
    } catch (e) {
      emit(RoomError('Failed to load rooms: $e'));
    }
  }

  Future<void> loadAvailableRooms() async {
    emit(RoomLoading());
    try {
      final rooms = await _roomRepository.getAvailableRooms();
      emit(RoomLoaded(rooms));
    } catch (e) {
      emit(RoomError('Failed to load available rooms: $e'));
    }
  }

  Future<void> loadRoomsByType(String type) async {
    emit(RoomLoading());
    try {
      final rooms = await _roomRepository.getRoomsByType(type);
      emit(RoomLoaded(rooms));
    } catch (e) {
      emit(RoomError('Failed to load rooms by type: $e'));
    }
  }

  Future<void> addRoom(Room room) async {
    try {
      await _roomRepository.addRoom(room);
      final rooms = await _roomRepository.getAllRooms();
      emit(RoomLoaded(rooms));
    } catch (e) {
      emit(RoomError('Failed to add room: $e'));
    }
  }

  Future<void> updateRoom(Room room) async {
    try {
      await _roomRepository.updateRoom(room);
      emit(RoomOperationSuccess('Room updated successfully'));
      await loadAllRooms();
    } catch (e) {
      emit(RoomError('Failed to update room: $e'));
    }
  }

  Future<void> deleteRoom(Room room) async {
    try {
      await _roomRepository.deleteRoom(room);
      emit(RoomOperationSuccess('Room deleted successfully'));
      await loadAllRooms();
    } catch (e) {
      emit(RoomError('Failed to delete room: $e'));
    }
  }

  Future<void> deleteRoomById(int id) async {
    try {
      await _roomRepository.deleteRoomById(id);
      emit(RoomOperationSuccess('Room deleted successfully'));
      await loadAllRooms();
    } catch (e) {
      emit(RoomError('Failed to delete room: $e'));
    }
  }

  Future<void> loadRoomsByStatus(String status) async {
    emit(RoomLoading());
    try {
      final rooms = await _roomRepository.getRoomsByStatus(status);
      emit(RoomLoaded(rooms));
    } catch (e) {
      emit(RoomError('Failed to load $status rooms: $e'));
    }
  }
}

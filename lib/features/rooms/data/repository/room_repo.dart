// lib/features/rooms/data/room_repository.dart

import 'package:jordanhotel/features/rooms/data/dao/room_dao.dart';
import 'package:jordanhotel/features/rooms/domain/entity/room.dart';

class RoomRepository {
  final RoomDao _roomDao;

  RoomRepository(this._roomDao);

  Future<List<Room>> getAllRooms() async {
    return await _roomDao.getAllRooms();
  }

  Future<Room?> getRoomById(int id) async {
    return await _roomDao.getRoomById(id);
  }

  Future<Room?> getRoomByNumber(String roomNumber) async {
    return await _roomDao.getRoomByNumber(roomNumber);
  }

  Future<List<Room>> getAvailableRooms() async {
    return await _roomDao.getRoomsByStatus('available');
  }

  Future<List<Room>> getRoomsByType(String type) async {
    return await _roomDao.getRoomsByType(type);
  }

  Future<List<Room>> getRoomsByStatus(String status) async {
    return await _roomDao.getRoomsByStatus(status);
  }

  Future<void> addRoom(Room room) async {
    await _roomDao.insertRoom(room);
  }

  Future<void> updateRoom(Room room) async {
    await _roomDao.updateRoom(room);
  }

  Future<void> deleteRoom(Room room) async {
    await _roomDao.deleteRoom(room);
  }

  Future<void> deleteRoomById(int id) async {
    await _roomDao.deleteRoomById(id);
  }

  Future<List<Room>> searchRooms(String query) async {
    String pattern = '%$query%';
    return await _roomDao.searchRoom(pattern);
  }
}

// lib/data/database/dao/room_dao.dart
import 'package:floor/floor.dart';
import 'package:jordanhotel/features/rooms/domain/entity/room.dart';

@dao
abstract class RoomDao {
  @Query('SELECT * FROM rooms')
  Future<List<Room>> getAllRooms();

  @Query('SELECT * FROM rooms WHERE id = :id')
  Future<Room?> getRoomById(int id);

  @Query(
    'SELECT * FROM rooms WHERE status = "available" AND room_number LIKE :query',
  )
  Future<List<Room>> searchRoom(String query);

  @Query('SELECT * FROM rooms WHERE room_number LIKE :roomNumber')
  Future<Room?> getRoomByNumber(String roomNumber);

  @Query('SELECT * FROM rooms WHERE status = :status')
  Future<List<Room>> getRoomsByStatus(String status);

  @Query('SELECT * FROM rooms WHERE type = :type')
  Future<List<Room>> getRoomsByType(String type);

  @insert
  Future<void> insertRoom(Room room);

  @update
  Future<void> updateRoom(Room room);

  @delete
  Future<void> deleteRoom(Room room);

  @Query('DELETE FROM rooms WHERE id = :id')
  Future<void> deleteRoomById(int id);
}

// lib/data/database/dao/guest_dao.dart
import 'package:floor/floor.dart';
import 'package:jordanhotel/features/guest/domain/entity/guest.dart';

@dao
abstract class GuestDao {
  @Query('SELECT * FROM guests')
  Future<List<Guest>> getAllGuests();

  @Query('SELECT * FROM guests WHERE id = :id')
  Future<Guest?> getGuestById(int id);

  @Query('SELECT * FROM guests WHERE email = :email')
  Future<Guest?> getGuestByEmail(String email);

  @Query('SELECT * FROM guests WHERE phone = :phone')
  Future<Guest?> getGuestByPhone(String phone);

  @Query(
    'SELECT * FROM guests WHERE first_name LIKE :query OR last_name LIKE :query',
  )
  Future<List<Guest>> searchGuests(String query);

  @insert
  Future<int> insertGuest(Guest guest);

  @update
  Future<void> updateGuest(Guest guest);

  @delete
  Future<void> deleteGuest(Guest guest);

  @Query('DELETE FROM guests WHERE id = :id')
  Future<void> deleteGuestById(int id);
}

// lib/features/guests/data/guest_repository.dart
import 'package:jordanhotel/features/guest/data/dao/guest_dao.dart';
import 'package:jordanhotel/features/guest/domain/entity/guest.dart';

class GuestRepository {
  final GuestDao _guestDao;

  GuestRepository(this._guestDao);

  Future<List<Guest>> getAllGuests() async {
    return await _guestDao.getAllGuests();
  }

  Future<Guest?> getGuestById(int id) async {
    return await _guestDao.getGuestById(id);
  }

  Future<Guest?> getGuestByEmail(String email) async {
    return await _guestDao.getGuestByEmail(email);
  }

  Future<Guest?> getGuestByPhone(String phone) async {
    return await _guestDao.getGuestByPhone(phone);
  }

  Future<List<Guest>> searchGuests(String query) async {
    return await _guestDao.searchGuests('%$query%');
  }

  Future<int> addGuest(Guest guest) async {
    return await _guestDao.insertGuest(guest);
  }

  Future<void> updateGuest(Guest guest) async {
    await _guestDao.updateGuest(guest);
  }

  Future<void> deleteGuest(Guest guest) async {
    await _guestDao.deleteGuest(guest);
  }

  Future<void> deleteGuestById(int id) async {
    await _guestDao.deleteGuestById(id);
  }
}

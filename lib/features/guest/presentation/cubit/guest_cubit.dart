// lib/features/guests/business_logic/guest_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jordanhotel/features/guest/data/repository/guest_repo.dart';
import 'package:jordanhotel/features/guest/domain/entity/guest.dart';

part 'guest_state.dart';

class GuestCubit extends Cubit<GuestState> {
  final GuestRepository _guestRepository;

  GuestCubit(this._guestRepository) : super(GuestInitial());

  Future<void> loadAllGuests() async {
    emit(GuestLoading());
    try {
      final guests = await _guestRepository.getAllGuests();
      emit(GuestLoaded(guests));
    } catch (e) {
      emit(GuestError('Failed to load guests: $e'));
    }
  }

  Future<void> searchGuests(String query) async {
    if (query.isEmpty) {
      await loadAllGuests();
      return;
    }

    emit(GuestLoading());
    try {
      final guests = await _guestRepository.searchGuests(query);
      emit(GuestLoaded(guests));
    } catch (e) {
      emit(GuestError('Failed to search guests: $e'));
    }
  }

  Future<void> addGuest(Guest guest) async {
    try {
      // Check if guest with same email or phone already exists
      final existingByEmail = await _guestRepository.getGuestByEmail(
        guest.email,
      );
      final existingByPhone = await _guestRepository.getGuestByPhone(
        guest.phone,
      );

      if (existingByEmail != null) {
        emit(GuestError('Guest with this email already exists'));
        return;
      }

      if (existingByPhone != null) {
        emit(GuestError('Guest with this phone number already exists'));
        return;
      }

      await _guestRepository.addGuest(guest);
      emit(GuestOperationSuccess('Guest added successfully'));

      await loadAllGuests();
    } catch (e) {
      emit(GuestError('Failed to add guest: $e'));
    }
  }

  Future<void> updateGuest(Guest guest) async {
    try {
      await _guestRepository.updateGuest(guest);
      emit(GuestOperationSuccess('Guest updated successfully'));
      await loadAllGuests();
    } catch (e) {
      emit(GuestError('Failed to update guest: $e'));
    }
  }

  Future<void> deleteGuest(Guest guest) async {
    try {
      await _guestRepository.deleteGuest(guest);
      emit(GuestOperationSuccess('Guest deleted successfully'));
      await loadAllGuests();
    } catch (e) {
      emit(GuestError('Failed to delete guest: $e'));
    }
  }

  Future<void> deleteGuestById(int id) async {
    try {
      await _guestRepository.deleteGuestById(id);
      emit(GuestOperationSuccess('Guest deleted successfully'));
      await loadAllGuests();
    } catch (e) {
      emit(GuestError('Failed to delete guest: $e'));
    }
  }
}

import 'package:get_it/get_it.dart';
import 'package:jordanhotel/database/database.dart';
import 'package:jordanhotel/features/auth/data/repository/user_repo.dart';
import 'package:jordanhotel/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:jordanhotel/features/booking/data/repository/booking_repo.dart';
import 'package:jordanhotel/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:jordanhotel/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:jordanhotel/features/guest/data/repository/guest_repo.dart';
import 'package:jordanhotel/features/guest/presentation/cubit/guest_cubit.dart';
import 'package:jordanhotel/features/payment/data/repository/payment_repo.dart';
import 'package:jordanhotel/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:jordanhotel/features/rooms/data/repository/room_repo.dart';
import 'package:jordanhotel/features/rooms/presentation/cubit/room_cubit.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  final database = await $FloorHotelDatabase
      .databaseBuilder('hotel_database.db')
      .build();

  getIt.registerSingleton<HotelDatabase>(database);

  // Repositories
  getIt.registerLazySingleton(() => RoomRepository(database.roomDao));
  getIt.registerLazySingleton(() => GuestRepository(database.guestDao));
  getIt.registerLazySingleton(() => BookingRepository(database.bookingDao));
  getIt.registerLazySingleton(() => PaymentRepository(database.paymentDao));
  getIt.registerLazySingleton(() => UserRepository(database.userDao));
  // Cubits
  getIt.registerFactory(() => RoomCubit(getIt<RoomRepository>()));
  getIt.registerFactory(() => GuestCubit(getIt<GuestRepository>()));
  getIt.registerFactory(
    () => BookingCubit(
      getIt<BookingRepository>(),
      getIt<RoomRepository>(),
      getIt<GuestRepository>(),
    ),
  );
  getIt.registerFactory(
    () => PaymentCubit(getIt<PaymentRepository>(), getIt<BookingRepository>()),
  );

  getIt.registerFactory(() => AuthCubit(getIt<UserRepository>()));

  getIt.registerFactory(
    () => DashboardCubit(
      roomRepository: getIt<RoomRepository>(),
      guestRepository: getIt<GuestRepository>(),
      bookingRepository: getIt<BookingRepository>(),
      paymentRepository: getIt<PaymentRepository>(),
    ),
  );
}

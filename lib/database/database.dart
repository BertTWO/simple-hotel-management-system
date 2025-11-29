// lib/data/database/app_database.dart
import 'dart:async';

import 'package:floor/floor.dart';
import 'package:jordanhotel/features/auth/data/dao/user_dao.dart';
import 'package:jordanhotel/features/auth/domain/entity/user.dart';
import 'package:jordanhotel/features/booking/data/dao/booking_dao.dart';
import 'package:jordanhotel/features/booking/domain/entity/booking.dart';
import 'package:jordanhotel/features/guest/data/dao/guest_dao.dart';
import 'package:jordanhotel/features/guest/domain/entity/guest.dart';
import 'package:jordanhotel/features/payment/data/dao/payment_dao.dart';
import 'package:jordanhotel/features/payment/domain/entity/payment.dart';
import 'package:jordanhotel/features/rooms/data/dao/room_dao.dart';
import 'package:jordanhotel/features/rooms/domain/entity/room.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1, entities: [Room, Guest, Booking, Payment, User])
abstract class HotelDatabase extends FloorDatabase {
  RoomDao get roomDao;
  GuestDao get guestDao;
  BookingDao get bookingDao;
  PaymentDao get paymentDao;
  UserDao get userDao;
}

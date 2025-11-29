// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $HotelDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $HotelDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $HotelDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<HotelDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorHotelDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $HotelDatabaseBuilderContract databaseBuilder(String name) =>
      _$HotelDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $HotelDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$HotelDatabaseBuilder(null);
}

class _$HotelDatabaseBuilder implements $HotelDatabaseBuilderContract {
  _$HotelDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $HotelDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $HotelDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<HotelDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$HotelDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$HotelDatabase extends HotelDatabase {
  _$HotelDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  RoomDao? _roomDaoInstance;

  GuestDao? _guestDaoInstance;

  BookingDao? _bookingDaoInstance;

  PaymentDao? _paymentDaoInstance;

  UserDao? _userDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `rooms` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `room_number` TEXT NOT NULL, `type` TEXT NOT NULL, `price_per_night` REAL NOT NULL, `status` TEXT NOT NULL, `description` TEXT, `capacity` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `guests` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `first_name` TEXT NOT NULL, `last_name` TEXT NOT NULL, `email` TEXT NOT NULL, `phone` TEXT NOT NULL, `address` TEXT, `id_number` TEXT, `date_of_birth` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `bookings` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `guest_id` INTEGER NOT NULL, `room_id` INTEGER NOT NULL, `check_in_date` TEXT NOT NULL, `check_out_date` TEXT NOT NULL, `number_of_guests` INTEGER NOT NULL, `total_amount` REAL NOT NULL, `status` TEXT NOT NULL, `created_at` TEXT NOT NULL, `special_requests` TEXT, FOREIGN KEY (`guest_id`) REFERENCES `guests` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `payments` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `booking_id` INTEGER NOT NULL, `amount` REAL NOT NULL, `method` TEXT NOT NULL, `status` TEXT NOT NULL, `payment_date` TEXT NOT NULL, `transaction_id` TEXT, `notes` TEXT, FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `users` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `username` TEXT NOT NULL, `password` TEXT NOT NULL, `fullName` TEXT, `email` TEXT, `created_at` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  RoomDao get roomDao {
    return _roomDaoInstance ??= _$RoomDao(database, changeListener);
  }

  @override
  GuestDao get guestDao {
    return _guestDaoInstance ??= _$GuestDao(database, changeListener);
  }

  @override
  BookingDao get bookingDao {
    return _bookingDaoInstance ??= _$BookingDao(database, changeListener);
  }

  @override
  PaymentDao get paymentDao {
    return _paymentDaoInstance ??= _$PaymentDao(database, changeListener);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }
}

class _$RoomDao extends RoomDao {
  _$RoomDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _roomInsertionAdapter = InsertionAdapter(
            database,
            'rooms',
            (Room item) => <String, Object?>{
                  'id': item.id,
                  'room_number': item.roomNumber,
                  'type': item.type,
                  'price_per_night': item.pricePerNight,
                  'status': item.status,
                  'description': item.description,
                  'capacity': item.capacity
                }),
        _roomUpdateAdapter = UpdateAdapter(
            database,
            'rooms',
            ['id'],
            (Room item) => <String, Object?>{
                  'id': item.id,
                  'room_number': item.roomNumber,
                  'type': item.type,
                  'price_per_night': item.pricePerNight,
                  'status': item.status,
                  'description': item.description,
                  'capacity': item.capacity
                }),
        _roomDeletionAdapter = DeletionAdapter(
            database,
            'rooms',
            ['id'],
            (Room item) => <String, Object?>{
                  'id': item.id,
                  'room_number': item.roomNumber,
                  'type': item.type,
                  'price_per_night': item.pricePerNight,
                  'status': item.status,
                  'description': item.description,
                  'capacity': item.capacity
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Room> _roomInsertionAdapter;

  final UpdateAdapter<Room> _roomUpdateAdapter;

  final DeletionAdapter<Room> _roomDeletionAdapter;

  @override
  Future<List<Room>> getAllRooms() async {
    return _queryAdapter.queryList('SELECT * FROM rooms',
        mapper: (Map<String, Object?> row) => Room(
            id: row['id'] as int?,
            roomNumber: row['room_number'] as String,
            type: row['type'] as String,
            pricePerNight: row['price_per_night'] as double,
            status: row['status'] as String,
            description: row['description'] as String?,
            capacity: row['capacity'] as int));
  }

  @override
  Future<Room?> getRoomById(int id) async {
    return _queryAdapter.query('SELECT * FROM rooms WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Room(
            id: row['id'] as int?,
            roomNumber: row['room_number'] as String,
            type: row['type'] as String,
            pricePerNight: row['price_per_night'] as double,
            status: row['status'] as String,
            description: row['description'] as String?,
            capacity: row['capacity'] as int),
        arguments: [id]);
  }

  @override
  Future<List<Room>> searchRoom(String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM rooms WHERE status = \"available\" AND room_number LIKE ?1',
        mapper: (Map<String, Object?> row) => Room(id: row['id'] as int?, roomNumber: row['room_number'] as String, type: row['type'] as String, pricePerNight: row['price_per_night'] as double, status: row['status'] as String, description: row['description'] as String?, capacity: row['capacity'] as int),
        arguments: [query]);
  }

  @override
  Future<Room?> getRoomByNumber(String roomNumber) async {
    return _queryAdapter.query('SELECT * FROM rooms WHERE room_number LIKE ?1',
        mapper: (Map<String, Object?> row) => Room(
            id: row['id'] as int?,
            roomNumber: row['room_number'] as String,
            type: row['type'] as String,
            pricePerNight: row['price_per_night'] as double,
            status: row['status'] as String,
            description: row['description'] as String?,
            capacity: row['capacity'] as int),
        arguments: [roomNumber]);
  }

  @override
  Future<List<Room>> getRoomsByStatus(String status) async {
    return _queryAdapter.queryList('SELECT * FROM rooms WHERE status = ?1',
        mapper: (Map<String, Object?> row) => Room(
            id: row['id'] as int?,
            roomNumber: row['room_number'] as String,
            type: row['type'] as String,
            pricePerNight: row['price_per_night'] as double,
            status: row['status'] as String,
            description: row['description'] as String?,
            capacity: row['capacity'] as int),
        arguments: [status]);
  }

  @override
  Future<List<Room>> getRoomsByType(String type) async {
    return _queryAdapter.queryList('SELECT * FROM rooms WHERE type = ?1',
        mapper: (Map<String, Object?> row) => Room(
            id: row['id'] as int?,
            roomNumber: row['room_number'] as String,
            type: row['type'] as String,
            pricePerNight: row['price_per_night'] as double,
            status: row['status'] as String,
            description: row['description'] as String?,
            capacity: row['capacity'] as int),
        arguments: [type]);
  }

  @override
  Future<void> deleteRoomById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM rooms WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> insertRoom(Room room) async {
    await _roomInsertionAdapter.insert(room, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateRoom(Room room) async {
    await _roomUpdateAdapter.update(room, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteRoom(Room room) async {
    await _roomDeletionAdapter.delete(room);
  }
}

class _$GuestDao extends GuestDao {
  _$GuestDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _guestInsertionAdapter = InsertionAdapter(
            database,
            'guests',
            (Guest item) => <String, Object?>{
                  'id': item.id,
                  'first_name': item.firstName,
                  'last_name': item.lastName,
                  'email': item.email,
                  'phone': item.phone,
                  'address': item.address,
                  'id_number': item.idNumber,
                  'date_of_birth': item.dateOfBirth
                }),
        _guestUpdateAdapter = UpdateAdapter(
            database,
            'guests',
            ['id'],
            (Guest item) => <String, Object?>{
                  'id': item.id,
                  'first_name': item.firstName,
                  'last_name': item.lastName,
                  'email': item.email,
                  'phone': item.phone,
                  'address': item.address,
                  'id_number': item.idNumber,
                  'date_of_birth': item.dateOfBirth
                }),
        _guestDeletionAdapter = DeletionAdapter(
            database,
            'guests',
            ['id'],
            (Guest item) => <String, Object?>{
                  'id': item.id,
                  'first_name': item.firstName,
                  'last_name': item.lastName,
                  'email': item.email,
                  'phone': item.phone,
                  'address': item.address,
                  'id_number': item.idNumber,
                  'date_of_birth': item.dateOfBirth
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Guest> _guestInsertionAdapter;

  final UpdateAdapter<Guest> _guestUpdateAdapter;

  final DeletionAdapter<Guest> _guestDeletionAdapter;

  @override
  Future<List<Guest>> getAllGuests() async {
    return _queryAdapter.queryList('SELECT * FROM guests',
        mapper: (Map<String, Object?> row) => Guest(
            id: row['id'] as int?,
            firstName: row['first_name'] as String,
            lastName: row['last_name'] as String,
            email: row['email'] as String,
            phone: row['phone'] as String,
            address: row['address'] as String?,
            idNumber: row['id_number'] as String?,
            dateOfBirth: row['date_of_birth'] as String?));
  }

  @override
  Future<Guest?> getGuestById(int id) async {
    return _queryAdapter.query('SELECT * FROM guests WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Guest(
            id: row['id'] as int?,
            firstName: row['first_name'] as String,
            lastName: row['last_name'] as String,
            email: row['email'] as String,
            phone: row['phone'] as String,
            address: row['address'] as String?,
            idNumber: row['id_number'] as String?,
            dateOfBirth: row['date_of_birth'] as String?),
        arguments: [id]);
  }

  @override
  Future<Guest?> getGuestByEmail(String email) async {
    return _queryAdapter.query('SELECT * FROM guests WHERE email = ?1',
        mapper: (Map<String, Object?> row) => Guest(
            id: row['id'] as int?,
            firstName: row['first_name'] as String,
            lastName: row['last_name'] as String,
            email: row['email'] as String,
            phone: row['phone'] as String,
            address: row['address'] as String?,
            idNumber: row['id_number'] as String?,
            dateOfBirth: row['date_of_birth'] as String?),
        arguments: [email]);
  }

  @override
  Future<Guest?> getGuestByPhone(String phone) async {
    return _queryAdapter.query('SELECT * FROM guests WHERE phone = ?1',
        mapper: (Map<String, Object?> row) => Guest(
            id: row['id'] as int?,
            firstName: row['first_name'] as String,
            lastName: row['last_name'] as String,
            email: row['email'] as String,
            phone: row['phone'] as String,
            address: row['address'] as String?,
            idNumber: row['id_number'] as String?,
            dateOfBirth: row['date_of_birth'] as String?),
        arguments: [phone]);
  }

  @override
  Future<List<Guest>> searchGuests(String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM guests WHERE first_name LIKE ?1 OR last_name LIKE ?1',
        mapper: (Map<String, Object?> row) => Guest(
            id: row['id'] as int?,
            firstName: row['first_name'] as String,
            lastName: row['last_name'] as String,
            email: row['email'] as String,
            phone: row['phone'] as String,
            address: row['address'] as String?,
            idNumber: row['id_number'] as String?,
            dateOfBirth: row['date_of_birth'] as String?),
        arguments: [query]);
  }

  @override
  Future<void> deleteGuestById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM guests WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<int> insertGuest(Guest guest) {
    return _guestInsertionAdapter.insertAndReturnId(
        guest, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateGuest(Guest guest) async {
    await _guestUpdateAdapter.update(guest, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteGuest(Guest guest) async {
    await _guestDeletionAdapter.delete(guest);
  }
}

class _$BookingDao extends BookingDao {
  _$BookingDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _bookingInsertionAdapter = InsertionAdapter(
            database,
            'bookings',
            (Booking item) => <String, Object?>{
                  'id': item.id,
                  'guest_id': item.guestId,
                  'room_id': item.roomId,
                  'check_in_date': item.checkInDate,
                  'check_out_date': item.checkOutDate,
                  'number_of_guests': item.numberOfGuests,
                  'total_amount': item.totalAmount,
                  'status': item.status,
                  'created_at': item.createdAt,
                  'special_requests': item.specialRequests
                }),
        _bookingUpdateAdapter = UpdateAdapter(
            database,
            'bookings',
            ['id'],
            (Booking item) => <String, Object?>{
                  'id': item.id,
                  'guest_id': item.guestId,
                  'room_id': item.roomId,
                  'check_in_date': item.checkInDate,
                  'check_out_date': item.checkOutDate,
                  'number_of_guests': item.numberOfGuests,
                  'total_amount': item.totalAmount,
                  'status': item.status,
                  'created_at': item.createdAt,
                  'special_requests': item.specialRequests
                }),
        _bookingDeletionAdapter = DeletionAdapter(
            database,
            'bookings',
            ['id'],
            (Booking item) => <String, Object?>{
                  'id': item.id,
                  'guest_id': item.guestId,
                  'room_id': item.roomId,
                  'check_in_date': item.checkInDate,
                  'check_out_date': item.checkOutDate,
                  'number_of_guests': item.numberOfGuests,
                  'total_amount': item.totalAmount,
                  'status': item.status,
                  'created_at': item.createdAt,
                  'special_requests': item.specialRequests
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Booking> _bookingInsertionAdapter;

  final UpdateAdapter<Booking> _bookingUpdateAdapter;

  final DeletionAdapter<Booking> _bookingDeletionAdapter;

  @override
  Future<List<Booking>> getAllBookings() async {
    return _queryAdapter.queryList('SELECT * FROM bookings',
        mapper: (Map<String, Object?> row) => Booking(
            id: row['id'] as int?,
            guestId: row['guest_id'] as int,
            roomId: row['room_id'] as int,
            checkInDate: row['check_in_date'] as String,
            checkOutDate: row['check_out_date'] as String,
            numberOfGuests: row['number_of_guests'] as int,
            totalAmount: row['total_amount'] as double,
            status: row['status'] as String,
            createdAt: row['created_at'] as String,
            specialRequests: row['special_requests'] as String?));
  }

  @override
  Future<Booking?> getBookingById(int id) async {
    return _queryAdapter.query('SELECT * FROM bookings WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Booking(
            id: row['id'] as int?,
            guestId: row['guest_id'] as int,
            roomId: row['room_id'] as int,
            checkInDate: row['check_in_date'] as String,
            checkOutDate: row['check_out_date'] as String,
            numberOfGuests: row['number_of_guests'] as int,
            totalAmount: row['total_amount'] as double,
            status: row['status'] as String,
            createdAt: row['created_at'] as String,
            specialRequests: row['special_requests'] as String?),
        arguments: [id]);
  }

  @override
  Future<List<Booking>> getBookingsByGuestId(int guestId) async {
    return _queryAdapter.queryList('SELECT * FROM bookings WHERE guest_id = ?1',
        mapper: (Map<String, Object?> row) => Booking(
            id: row['id'] as int?,
            guestId: row['guest_id'] as int,
            roomId: row['room_id'] as int,
            checkInDate: row['check_in_date'] as String,
            checkOutDate: row['check_out_date'] as String,
            numberOfGuests: row['number_of_guests'] as int,
            totalAmount: row['total_amount'] as double,
            status: row['status'] as String,
            createdAt: row['created_at'] as String,
            specialRequests: row['special_requests'] as String?),
        arguments: [guestId]);
  }

  @override
  Future<List<Booking>> getBookingsByRoomId(int roomId) async {
    return _queryAdapter.queryList('SELECT * FROM bookings WHERE room_id = ?1',
        mapper: (Map<String, Object?> row) => Booking(
            id: row['id'] as int?,
            guestId: row['guest_id'] as int,
            roomId: row['room_id'] as int,
            checkInDate: row['check_in_date'] as String,
            checkOutDate: row['check_out_date'] as String,
            numberOfGuests: row['number_of_guests'] as int,
            totalAmount: row['total_amount'] as double,
            status: row['status'] as String,
            createdAt: row['created_at'] as String,
            specialRequests: row['special_requests'] as String?),
        arguments: [roomId]);
  }

  @override
  Future<List<Booking>> getBookingsByStatus(String status) async {
    return _queryAdapter.queryList('SELECT * FROM bookings WHERE status = ?1',
        mapper: (Map<String, Object?> row) => Booking(
            id: row['id'] as int?,
            guestId: row['guest_id'] as int,
            roomId: row['room_id'] as int,
            checkInDate: row['check_in_date'] as String,
            checkOutDate: row['check_out_date'] as String,
            numberOfGuests: row['number_of_guests'] as int,
            totalAmount: row['total_amount'] as double,
            status: row['status'] as String,
            createdAt: row['created_at'] as String,
            specialRequests: row['special_requests'] as String?),
        arguments: [status]);
  }

  @override
  Future<List<Booking>> getActiveBookingsOnDate(String date) async {
    return _queryAdapter.queryList(
        'SELECT * FROM bookings      WHERE check_in_date <= ?1 AND check_out_date >= ?1',
        mapper: (Map<String, Object?> row) => Booking(id: row['id'] as int?, guestId: row['guest_id'] as int, roomId: row['room_id'] as int, checkInDate: row['check_in_date'] as String, checkOutDate: row['check_out_date'] as String, numberOfGuests: row['number_of_guests'] as int, totalAmount: row['total_amount'] as double, status: row['status'] as String, createdAt: row['created_at'] as String, specialRequests: row['special_requests'] as String?),
        arguments: [date]);
  }

  @override
  Future<List<Booking>> checkRoomAvailability(
    int roomId,
    String checkIn,
    String checkOut,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM bookings      WHERE room_id = ?1      AND status IN (\"confirmed\", \"checked_in\")     AND (       (check_in_date <= ?2 AND check_out_date >= ?2) OR       (check_in_date <= ?3 AND check_out_date >= ?3) OR       (check_in_date >= ?2 AND check_out_date <= ?3)     )',
        mapper: (Map<String, Object?> row) => Booking(id: row['id'] as int?, guestId: row['guest_id'] as int, roomId: row['room_id'] as int, checkInDate: row['check_in_date'] as String, checkOutDate: row['check_out_date'] as String, numberOfGuests: row['number_of_guests'] as int, totalAmount: row['total_amount'] as double, status: row['status'] as String, createdAt: row['created_at'] as String, specialRequests: row['special_requests'] as String?),
        arguments: [roomId, checkIn, checkOut]);
  }

  @override
  Future<void> deleteBookingById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM bookings WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<int> insertBooking(Booking booking) {
    return _bookingInsertionAdapter.insertAndReturnId(
        booking, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateBooking(Booking booking) async {
    await _bookingUpdateAdapter.update(booking, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteBooking(Booking booking) async {
    await _bookingDeletionAdapter.delete(booking);
  }
}

class _$PaymentDao extends PaymentDao {
  _$PaymentDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _paymentInsertionAdapter = InsertionAdapter(
            database,
            'payments',
            (Payment item) => <String, Object?>{
                  'id': item.id,
                  'booking_id': item.bookingId,
                  'amount': item.amount,
                  'method': item.method,
                  'status': item.status,
                  'payment_date': item.paymentDate,
                  'transaction_id': item.transactionId,
                  'notes': item.notes
                }),
        _paymentUpdateAdapter = UpdateAdapter(
            database,
            'payments',
            ['id'],
            (Payment item) => <String, Object?>{
                  'id': item.id,
                  'booking_id': item.bookingId,
                  'amount': item.amount,
                  'method': item.method,
                  'status': item.status,
                  'payment_date': item.paymentDate,
                  'transaction_id': item.transactionId,
                  'notes': item.notes
                }),
        _paymentDeletionAdapter = DeletionAdapter(
            database,
            'payments',
            ['id'],
            (Payment item) => <String, Object?>{
                  'id': item.id,
                  'booking_id': item.bookingId,
                  'amount': item.amount,
                  'method': item.method,
                  'status': item.status,
                  'payment_date': item.paymentDate,
                  'transaction_id': item.transactionId,
                  'notes': item.notes
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Payment> _paymentInsertionAdapter;

  final UpdateAdapter<Payment> _paymentUpdateAdapter;

  final DeletionAdapter<Payment> _paymentDeletionAdapter;

  @override
  Future<List<Payment>> getAllPayments() async {
    return _queryAdapter.queryList('SELECT * FROM payments',
        mapper: (Map<String, Object?> row) => Payment(
            id: row['id'] as int?,
            bookingId: row['booking_id'] as int,
            amount: row['amount'] as double,
            method: row['method'] as String,
            status: row['status'] as String,
            paymentDate: row['payment_date'] as String,
            transactionId: row['transaction_id'] as String?,
            notes: row['notes'] as String?));
  }

  @override
  Future<Payment?> getPaymentById(int id) async {
    return _queryAdapter.query('SELECT * FROM payments WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Payment(
            id: row['id'] as int?,
            bookingId: row['booking_id'] as int,
            amount: row['amount'] as double,
            method: row['method'] as String,
            status: row['status'] as String,
            paymentDate: row['payment_date'] as String,
            transactionId: row['transaction_id'] as String?,
            notes: row['notes'] as String?),
        arguments: [id]);
  }

  @override
  Future<List<Payment>> getPaymentsByBookingId(int bookingId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM payments WHERE booking_id = ?1',
        mapper: (Map<String, Object?> row) => Payment(
            id: row['id'] as int?,
            bookingId: row['booking_id'] as int,
            amount: row['amount'] as double,
            method: row['method'] as String,
            status: row['status'] as String,
            paymentDate: row['payment_date'] as String,
            transactionId: row['transaction_id'] as String?,
            notes: row['notes'] as String?),
        arguments: [bookingId]);
  }

  @override
  Future<List<Payment>> getPaymentsByStatus(String status) async {
    return _queryAdapter.queryList('SELECT * FROM payments WHERE status = ?1',
        mapper: (Map<String, Object?> row) => Payment(
            id: row['id'] as int?,
            bookingId: row['booking_id'] as int,
            amount: row['amount'] as double,
            method: row['method'] as String,
            status: row['status'] as String,
            paymentDate: row['payment_date'] as String,
            transactionId: row['transaction_id'] as String?,
            notes: row['notes'] as String?),
        arguments: [status]);
  }

  @override
  Future<double?> getTotalPaidAmount(int bookingId) async {
    return _queryAdapter.query(
        'SELECT SUM(amount) FROM payments WHERE booking_id = ?1 AND status = \"completed\"',
        mapper: (Map<String, Object?> row) => row.values.first as double,
        arguments: [bookingId]);
  }

  @override
  Future<void> deletePaymentById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM payments WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<int> insertPayment(Payment payment) {
    return _paymentInsertionAdapter.insertAndReturnId(
        payment, OnConflictStrategy.abort);
  }

  @override
  Future<void> updatePayment(Payment payment) async {
    await _paymentUpdateAdapter.update(payment, OnConflictStrategy.abort);
  }

  @override
  Future<void> deletePayment(Payment payment) async {
    await _paymentDeletionAdapter.delete(payment);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'users',
            (User item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'password': item.password,
                  'fullName': item.fullName,
                  'email': item.email,
                  'created_at': item.createdAt
                }),
        _userUpdateAdapter = UpdateAdapter(
            database,
            'users',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'password': item.password,
                  'fullName': item.fullName,
                  'email': item.email,
                  'created_at': item.createdAt
                }),
        _userDeletionAdapter = DeletionAdapter(
            database,
            'users',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'password': item.password,
                  'fullName': item.fullName,
                  'email': item.email,
                  'created_at': item.createdAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final UpdateAdapter<User> _userUpdateAdapter;

  final DeletionAdapter<User> _userDeletionAdapter;

  @override
  Future<User?> login(
    String username,
    String password,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM users WHERE username = ?1 AND password = ?2',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            username: row['username'] as String,
            password: row['password'] as String,
            fullName: row['fullName'] as String?,
            email: row['email'] as String?,
            createdAt: row['created_at'] as String),
        arguments: [username, password]);
  }

  @override
  Future<User?> getUserByUsername(String username) async {
    return _queryAdapter.query('SELECT * FROM users WHERE username = ?1',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            username: row['username'] as String,
            password: row['password'] as String,
            fullName: row['fullName'] as String?,
            email: row['email'] as String?,
            createdAt: row['created_at'] as String),
        arguments: [username]);
  }

  @override
  Future<List<User>> getAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM users',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            username: row['username'] as String,
            password: row['password'] as String,
            fullName: row['fullName'] as String?,
            email: row['email'] as String?,
            createdAt: row['created_at'] as String));
  }

  @override
  Future<List<User>> getUsersByRole(String role) async {
    return _queryAdapter.queryList('SELECT * FROM users WHERE role = ?1',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            username: row['username'] as String,
            password: row['password'] as String,
            fullName: row['fullName'] as String?,
            email: row['email'] as String?,
            createdAt: row['created_at'] as String),
        arguments: [role]);
  }

  @override
  Future<void> deleteUserById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM users WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> insertUser(User user) async {
    await _userInsertionAdapter.insert(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUser(User user) async {
    await _userUpdateAdapter.update(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUser(User user) async {
    await _userDeletionAdapter.delete(user);
  }
}

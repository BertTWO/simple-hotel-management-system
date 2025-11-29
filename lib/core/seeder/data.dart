import 'package:jordanhotel/features/booking/domain/entity/booking.dart';
import 'package:jordanhotel/features/guest/domain/entity/guest.dart';
import 'package:jordanhotel/features/payment/domain/entity/payment.dart';
import 'package:jordanhotel/features/rooms/domain/entity/room.dart';

class DataSeeder {
  static List<Room> get sampleRooms => [
    for (int i = 1; i <= 40; i++)
      Room(
        id: 1100 + i,
        roomNumber: (100 + i).toString(),
        type: i <= 15
            ? 'single'
            : i <= 25
            ? 'double'
            : i <= 33
            ? 'deluxe'
            : 'suite',
        pricePerNight: i <= 15
            ? 80
            : i <= 25
            ? 130
            : i <= 33
            ? 210
            : 350,
        status: i % 6 == 0
            ? 'maintenance'
            : i % 5 == 0
            ? 'occupied'
            : 'available',
        capacity: i <= 15
            ? 1
            : i <= 25
            ? 2
            : i <= 33
            ? 3
            : 4,
        description: "Room ${(100 + i)} description for testing.",
      ),
  ];

  static List<Guest> get sampleGuests => [
    Guest(
      id: 1201,
      firstName: "John",
      lastName: "Doe",
      email: "john.doe@email.com",
      phone: "555-0101",
      address: "123 Main St, New York",
      idNumber: "ID100001",
    ),
    Guest(
      id: 1202,
      firstName: "Maria",
      lastName: "Garcia",
      email: "maria.garcia@email.com",
      phone: "555-0102",
      address: "456 Oak Ave, Los Angeles",
      idNumber: "ID100002",
    ),
    Guest(
      id: 1203,
      firstName: "David",
      lastName: "Johnson",
      email: "david.johnson@email.com",
      phone: "555-0103",
      address: "789 Pine Rd, Chicago",
      idNumber: "ID100003",
    ),
    Guest(
      id: 1204,
      firstName: "Sarah",
      lastName: "Wilson",
      email: "sarah.wilson@email.com",
      phone: "555-0104",
      address: "321 Elm St, Miami",
      idNumber: "ID100004",
    ),
    Guest(
      id: 1205,
      firstName: "Michael",
      lastName: "Brown",
      email: "michael.brown@email.com",
      phone: "555-0105",
      address: "654 Maple St, Boston",
      idNumber: "ID100005",
    ),
    Guest(
      id: 1206,
      firstName: "Emily",
      lastName: "Davis",
      email: "emily.davis@email.com",
      phone: "555-0106",
      address: "987 Cedar Ave, Seattle",
      idNumber: "ID100006",
    ),
    Guest(
      id: 1207,
      firstName: "Daniel",
      lastName: "Miller",
      email: "daniel.miller@email.com",
      phone: "555-0107",
      address: "741 Birch Rd, Denver",
      idNumber: "ID100007",
    ),
    Guest(
      id: 1208,
      firstName: "Olivia",
      lastName: "Martinez",
      email: "olivia.martinez@email.com",
      phone: "555-0108",
      address: "852 Spruce St, San Francisco",
      idNumber: "ID100008",
    ),
    Guest(
      id: 1209,
      firstName: "James",
      lastName: "Taylor",
      email: "james.taylor@email.com",
      phone: "555-0109",
      address: "963 Willow Ave, Austin",
      idNumber: "ID100009",
    ),
    Guest(
      id: 1210,
      firstName: "Sophia",
      lastName: "Anderson",
      email: "sophia.anderson@email.com",
      phone: "555-0110",
      address: "159 Pine St, Portland",
      idNumber: "ID100010",
    ),
    // add 20+ more if you want large dataset
  ];

  static List<Booking> get sampleBookings => [
    Booking(
      id: 1301,
      guestId: 1201,
      roomId: 1101,
      checkInDate: DateTime.now().add(Duration(days: 1)).toIso8601String(),
      checkOutDate: DateTime.now().add(Duration(days: 4)).toIso8601String(),
      numberOfGuests: 1,
      totalAmount: 240,
      status: 'confirmed',
      createdAt: DateTime.now().toIso8601String(),
    ),
    Booking(
      id: 1302,
      guestId: 1202,
      roomId: 1102,
      checkInDate: DateTime.now().add(Duration(days: 2)).toIso8601String(),
      checkOutDate: DateTime.now().add(Duration(days: 5)).toIso8601String(),
      numberOfGuests: 2,
      totalAmount: 390,
      status: 'checked_in',
      createdAt: DateTime.now().toIso8601String(),
    ),
    Booking(
      id: 1303,
      guestId: 1203,
      roomId: 1103,
      checkInDate: DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
      checkOutDate: DateTime.now().add(Duration(days: 3)).toIso8601String(),
      numberOfGuests: 2,
      totalAmount: 360,
      status: 'checked_out',
      createdAt: DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
    ),
    Booking(
      id: 1304,
      guestId: 1204,
      roomId: 1104,
      checkInDate: DateTime.now().add(Duration(days: 3)).toIso8601String(),
      checkOutDate: DateTime.now().add(Duration(days: 6)).toIso8601String(),
      numberOfGuests: 1,
      totalAmount: 240,
      status: 'cancelled',
      createdAt: DateTime.now().toIso8601String(),
    ),
  ];

  static List<Payment> get samplePayments => [
    Payment(
      id: 1401,
      bookingId: 1301,
      amount: 240,
      method: 'credit_card',
      status: 'completed',
      paymentDate: DateTime.now().toIso8601String(),
      transactionId: 'TXN001',
    ),
    Payment(
      id: 1402,
      bookingId: 1302,
      amount: 390,
      method: 'cash',
      status: 'completed',
      paymentDate: DateTime.now().toIso8601String(),
      transactionId: 'TXN002',
    ),
    Payment(
      id: 1403,
      bookingId: 1303,
      amount: 360,
      method: 'bank_transfer',
      status: 'completed',
      paymentDate: DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
      transactionId: 'TXN003',
      notes: 'Deposit',
    ),
    Payment(
      id: 1404,
      bookingId: 1304,
      amount: 240,
      method: 'credit_card',
      status: 'pending',
      paymentDate: DateTime.now().add(Duration(days: 3)).toIso8601String(),
      transactionId: 'TXN004',
      notes: 'Balance due',
    ),
  ];
}

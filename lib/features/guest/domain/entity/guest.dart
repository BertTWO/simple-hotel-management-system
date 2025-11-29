// lib/data/models/guest.dart
import 'package:floor/floor.dart';

@Entity(tableName: 'guests')
class Guest {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'first_name')
  final String firstName;

  @ColumnInfo(name: 'last_name')
  final String lastName;

  final String email;
  final String phone;
  final String? address;

  @ColumnInfo(name: 'id_number')
  final String? idNumber;

  @ColumnInfo(name: 'date_of_birth')
  final String? dateOfBirth; // Stored as ISO string for simplicity

  Guest({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.address,
    this.idNumber,
    this.dateOfBirth,
  });

  String get fullName => '$firstName $lastName';

  Guest copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    String? idNumber,
    String? dateOfBirth,
  }) {
    return Guest(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      idNumber: idNumber ?? this.idNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }

  @override
  String toString() {
    return 'Guest(id: $id, fullName: $fullName, email: $email, phone: $phone)';
  }
}

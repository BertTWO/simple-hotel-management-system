import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:jordanhotel/features/booking/domain/entity/booking.dart';
import 'package:jordanhotel/features/guest/domain/entity/guest.dart';
import 'package:jordanhotel/features/rooms/domain/entity/room.dart';
import 'package:jordanhotel/features/booking/presentation/cubit/booking_cubit.dart';

class AddBookingBottomSheet extends StatefulWidget {
  final Booking? booking;
  const AddBookingBottomSheet({super.key, this.booking});

  @override
  State<AddBookingBottomSheet> createState() => _AddBookingBottomSheetState();
}

class _AddBookingBottomSheetState extends State<AddBookingBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _guestController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();
  final TextEditingController _checkInController = TextEditingController();
  final TextEditingController _checkOutController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();

  int? selectedGuestId;
  Room? selectedRoom;
  int numberOfGuests = 1;
  double totalAmount = 0.0;
  String _selectedStatus = 'confirmed';

  @override
  void initState() {
    super.initState();
    if (widget.booking != null) {
      _checkInController.text = widget.booking!.checkInDate;
      _checkOutController.text = widget.booking!.checkOutDate;
      numberOfGuests = widget.booking!.numberOfGuests;
      selectedGuestId = widget.booking!.guestId;
      _guestController.text = widget.booking!.guestId.toString();
      _totalAmountController.text = widget.booking!.totalAmount.toStringAsFixed(
        2,
      );
      _selectedStatus = widget.booking!.status;
      _prefillRoomData();
    } else {
      _totalAmountController.text = '0.00';
      _selectedStatus = 'confirmed'; // Default for new bookings
    }
  }

  void _calculateTotalAmount() {
    if (selectedRoom != null &&
        _checkInController.text.isNotEmpty &&
        _checkOutController.text.isNotEmpty) {
      try {
        final checkIn = DateTime.parse(_checkInController.text);
        final checkOut = DateTime.parse(_checkOutController.text);
        final numberOfNights = checkOut.difference(checkIn).inDays;

        if (numberOfNights > 0) {
          final total = selectedRoom!.pricePerNight * numberOfNights;
          setState(() {
            totalAmount = total;
            _totalAmountController.text = total.toStringAsFixed(2);
          });
        }
      } catch (e) {
        setState(() {
          totalAmount = 0.0;
          _totalAmountController.text = '0.00';
        });
      }
    } else {
      setState(() {
        totalAmount = 0.0;
        _totalAmountController.text = '0.00';
      });
    }
  }

  // Get available statuses based on current situation
  List<String> _getAvailableStatuses() {
    if (widget.booking == null) {
      // New booking - can only be confirmed or cancelled
      return ['confirmed', 'cancelled'];
    } else {
      // Existing booking - follow the workflow
      switch (widget.booking!.status) {
        case 'confirmed':
          return ['confirmed', 'checked_in', 'cancelled'];
        case 'checked_in':
          return ['checked_in', 'checked_out', 'cancelled'];
        case 'checked_out':
          return ['checked_out']; // Can't change completed bookings
        case 'cancelled':
          return ['cancelled']; // Can't change cancelled bookings
        default:
          return ['confirmed', 'cancelled'];
      }
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'confirmed':
        return 'Confirmed (Future Booking)';
      case 'checked_in':
        return 'Checked In (Guest Arrived)';
      case 'checked_out':
        return 'Checked Out (Completed)';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableStatuses = _getAvailableStatuses();

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.booking == null
                          ? 'Create Booking'
                          : 'Update Booking',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, size: 24),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Guest TypeAhead
                const Text(
                  'Guest',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                TypeAheadField<Guest>(
                  debounceDuration: const Duration(milliseconds: 300),
                  builder: (context, controller, focusNode) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: 'Search guest by name or email...',
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                  suggestionsCallback: (pattern) async {
                    if (pattern.isEmpty) return [];
                    return await context.read<BookingCubit>().searchGuests(
                      pattern,
                    );
                  },
                  itemBuilder: (context, guest) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[200]!),
                        ),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEC4899), Color(0xFFF472B6)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          guest.fullName,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          guest.email,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    );
                  },
                  onSelected: (guest) {
                    setState(() {
                      _guestController.text = guest.fullName;
                      selectedGuestId = guest.id;
                    });
                  },
                  controller: _guestController,
                ),
                const SizedBox(height: 16),

                // Room TypeAhead
                const Text(
                  'Room',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                TypeAheadField<Room>(
                  debounceDuration: const Duration(milliseconds: 300),
                  builder: (context, controller, focusNode) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: 'Search available rooms...',
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.king_bed,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                  suggestionsCallback: (pattern) async {
                    if (pattern.isEmpty) return [];
                    return await context
                        .read<BookingCubit>()
                        .searchAvailableRooms(pattern);
                  },
                  itemBuilder: (context, room) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[200]!),
                        ),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.king_bed,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          'Room ${room.roomNumber}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          '${_capitalize(room.type)} • \$${room.pricePerNight.toStringAsFixed(2)}/night',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              room.status,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _getStatusColor(
                                room.status,
                              ).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            _capitalize(room.status),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _getStatusColor(room.status),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  onSelected: (room) {
                    setState(() {
                      _roomController.text = 'Room ${room.roomNumber}';
                      selectedRoom = room;
                      _calculateTotalAmount();
                    });
                  },
                  controller: _roomController,
                ),
                const SizedBox(height: 16),

                // Dates Row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Check-in',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _checkInController,
                            decoration: InputDecoration(
                              hintText: 'Select date',
                              filled: true,
                              fillColor: Colors.grey[50],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              prefixIcon: const Icon(
                                Icons.calendar_today,
                                color: Colors.grey,
                              ),
                            ),
                            readOnly: true,
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (date != null) {
                                setState(() {
                                  _checkInController.text = date
                                      .toIso8601String();
                                  _calculateTotalAmount();
                                });
                              }
                            },
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                ? 'Select check-in date'
                                : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Check-out',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _checkOutController,
                            decoration: InputDecoration(
                              hintText: 'Select date',
                              filled: true,
                              fillColor: Colors.grey[50],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              prefixIcon: const Icon(
                                Icons.calendar_today,
                                color: Colors.grey,
                              ),
                            ),
                            readOnly: true,
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now().add(
                                  const Duration(days: 1),
                                ),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (date != null) {
                                setState(() {
                                  _checkOutController.text = date
                                      .toIso8601String();
                                  _calculateTotalAmount();
                                });
                              }
                            },
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                ? 'Select check-out date'
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Number of Guests
                const Text(
                  'Number of Guests',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: numberOfGuests.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    prefixIcon: const Icon(Icons.people, color: Colors.grey),
                  ),
                  onChanged: (value) =>
                      numberOfGuests = int.tryParse(value) ?? 1,
                ),
                const SizedBox(height: 16),

                // Total Amount (Auto-calculated)
                const Text(
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _totalAmountController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.attach_money,
                      color: Colors.green,
                    ),
                    suffixIcon: selectedRoom != null
                        ? Tooltip(
                            message:
                                'Calculated: ${selectedRoom!.pricePerNight}/night × ${_getNumberOfNights()} nights',
                            child: const Icon(
                              Icons.info_outline,
                              color: Colors.grey,
                            ),
                          )
                        : null,
                  ),
                  readOnly: true,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 16),

                // Status Dropdown
                const Text(
                  'Booking Status',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    prefixIcon: const Icon(Icons.circle, color: Colors.grey),
                  ),
                  items: availableStatuses.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(_getStatusLabel(status)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value!;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          selectedGuestId != null &&
                          selectedRoom != null) {
                        final booking = Booking(
                          id: widget.booking?.id,
                          guestId: selectedGuestId!,
                          roomId: selectedRoom!.id!,
                          checkInDate: _checkInController.text,
                          checkOutDate: _checkOutController.text,
                          numberOfGuests: numberOfGuests,
                          totalAmount: totalAmount,
                          status: _selectedStatus,
                          createdAt:
                              widget.booking?.createdAt ??
                              DateTime.now().toIso8601String(),
                        );

                        if (widget.booking == null) {
                          context.read<BookingCubit>().addBooking(booking);
                        } else {
                          context.read<BookingCubit>().updateBooking(booking);
                        }

                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0368B3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      widget.booking == null
                          ? 'Create Booking'
                          : 'Update Booking',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _prefillRoomData() async {
    try {
      final cubit = context.read<BookingCubit>();
      final room = await cubit.getRoomById(widget.booking!.roomId);

      if (room != null) {
        setState(() {
          selectedRoom = room;
          _roomController.text = 'Room ${room.roomNumber}';
        });
      }
    } catch (e) {
      setState(() {
        _roomController.text = 'Room ID: ${widget.booking!.roomId}';
      });
    }
  }

  int _getNumberOfNights() {
    try {
      if (_checkInController.text.isNotEmpty &&
          _checkOutController.text.isNotEmpty) {
        final checkIn = DateTime.parse(_checkInController.text);
        final checkOut = DateTime.parse(_checkOutController.text);
        return checkOut.difference(checkIn).inDays;
      }
    } catch (e) {
      return 0;
    }
    return 0;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'available':
        return const Color(0xFF10B981);
      case 'occupied':
        return const Color(0xFFF59E0B);
      case 'maintenance':
        return const Color(0xFFEF4444);
      case 'cleaning':
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  void dispose() {
    _guestController.dispose();
    _roomController.dispose();
    _checkInController.dispose();
    _checkOutController.dispose();
    _totalAmountController.dispose();
    super.dispose();
  }
}

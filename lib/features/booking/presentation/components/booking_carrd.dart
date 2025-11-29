// lib/features/bookings/presentation/widgets/booking_card.dart
import 'package:flutter/material.dart';
import 'package:jordanhotel/features/booking/domain/entity/booking.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String? guestName;
  final String? roomNumber;

  const BookingCard({
    super.key,
    required this.booking,
    this.onEdit,
    this.onDelete,
    this.guestName,
    this.roomNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with ID and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Booking ID with nice styling
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: _getBookingGradient(booking.status),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'BOOKING #${booking.id ?? 'NEW'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getStatusColor(booking.status).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    _formatStatus(booking.status),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(booking.status),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Booking Details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: _getBookingGradient(booking.status),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getBookingIcon(booking.status),
                    color: Colors.white,
                    size: 20,
                  ),
                ),

                const SizedBox(width: 12),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Guest Info - FIXED DISPLAY
                      Text(
                        guestName != null
                            ? guestName!
                            : 'Guest ID: ${booking.guestId}', // Changed from Guest #
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Room Info - FIXED DISPLAY
                      Text(
                        roomNumber != null
                            ? 'Room: $roomNumber • ${booking.numberOfGuests} guests'
                            : 'Room ID: ${booking.roomId} • ${booking.numberOfGuests} guests', // Changed from Room #
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),

                      const SizedBox(height: 8),

                      // Dates
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${_formatDate(booking.checkInDate)} - ${_formatDate(booking.checkOutDate)}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Amount
                      Row(
                        children: [
                          Icon(
                            Icons.attach_money,
                            size: 14,
                            color: Colors.green[600],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '\$${booking.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF059669),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '• ${_getNumberOfNights()} nights',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Actions Menu
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.grey[500],
                    size: 20,
                  ),
                  onSelected: (value) {
                    if (value == 'edit' && onEdit != null) onEdit!();
                    if (value == 'delete' && onDelete != null) onDelete!();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18, color: Color(0xFF3B82F6)),
                          SizedBox(width: 8),
                          Text(
                            'Edit',
                            style: TextStyle(color: Color(0xFF3B82F6)),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to calculate number of nights
  int _getNumberOfNights() {
    try {
      final checkIn = DateTime.parse(booking.checkInDate);
      final checkOut = DateTime.parse(booking.checkOutDate);
      return checkOut.difference(checkIn).inDays;
    } catch (e) {
      return 0;
    }
  }

  LinearGradient _getBookingGradient(String status) {
    switch (status) {
      case 'confirmed':
        return const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'checked_in':
        return const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF34D399)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'checked_out':
        return const LinearGradient(
          colors: [Color(0xFF6B7280), Color(0xFF9CA3AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'cancelled':
        return const LinearGradient(
          colors: [Color(0xFFEF4444), Color(0xFFF87171)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  IconData _getBookingIcon(String status) {
    switch (status) {
      case 'confirmed':
        return Icons.confirmation_num_outlined;
      case 'checked_in':
        return Icons.login_rounded;
      case 'checked_out':
        return Icons.logout_rounded;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.calendar_today_outlined;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return const Color(0xFF3B82F6);
      case 'checked_in':
        return const Color(0xFF10B981);
      case 'checked_out':
        return const Color(0xFF6B7280);
      case 'cancelled':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF8B5CF6);
    }
  }

  String _formatStatus(String status) {
    switch (status) {
      case 'confirmed':
        return 'CONFIRMED';
      case 'checked_in':
        return 'CHECKED IN';
      case 'checked_out':
        return 'COMPLETED';
      case 'cancelled':
        return 'CANCELLED';
      default:
        return status.toUpperCase();
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${_getMonthAbbr(date.month)} ${date.day}, ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _getMonthAbbr(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}

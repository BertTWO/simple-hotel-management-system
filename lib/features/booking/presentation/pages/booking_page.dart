import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordanhotel/features/booking/domain/entity/booking.dart';
import 'package:jordanhotel/features/booking/presentation/components/add_bokking_sheet.dart';
import 'package:jordanhotel/features/booking/presentation/components/booking_carrd.dart';
import 'package:jordanhotel/features/booking/presentation/cubit/booking_cubit.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  String _currentFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocListener<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }

          if (state is BookingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Column(
          children: [
            _buildHeader(context),
            _buildFilterChips(),
            _buildBookingsList(),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBookingBottomSheet(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  // ---------------- HEADER ----------------

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.9),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),

            BlocBuilder<BookingCubit, BookingState>(
              builder: (context, state) {
                if (state is BookingLoaded) {
                  final total = state.bookings.length;
                  final confirmed = state.bookings
                      .where((b) => b.status == 'confirmed')
                      .length;
                  final checkedIn = state.bookings
                      .where((b) => b.status == 'checked_in')
                      .length;
                  final checkedOut = state.bookings
                      .where((b) => b.status == 'checked_out')
                      .length;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildHeaderStat('Total', total.toString(), Colors.white),
                      _buildHeaderStat(
                        'Confirmed',
                        confirmed.toString(),
                        Colors.blue,
                      ),
                      _buildHeaderStat(
                        'Checked In',
                        checkedIn.toString(),
                        Colors.green,
                      ),
                      _buildHeaderStat(
                        'Completed',
                        checkedOut.toString(),
                        Colors.grey,
                      ),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  // ---------------- FILTER CHIPS ----------------

  Widget _buildFilterChips() {
    final filters = [
      'All',
      'Confirmed',
      'Checked In',
      'Checked Out',
      'Cancelled',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: SizedBox(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: filters.map((filter) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter),
                selected: _currentFilter == filter,
                onSelected: (_) {
                  setState(() => _currentFilter = filter);
                  _applyFilter(context, filter);
                },
                backgroundColor: Colors.white,
                selectedColor: Theme.of(context).colorScheme.primary,
                labelStyle: TextStyle(
                  color: _currentFilter == filter
                      ? Colors.white
                      : Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ---------------- BOOKINGS LIST ----------------

  Widget _buildBookingsList() {
    return Expanded(
      child: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BookingError) {
            return Center(child: Text(state.message));
          }

          if (state is BookingLoaded) {
            final filtered = _filterBookings(state.bookings, _currentFilter);

            if (filtered.isEmpty) return _buildEmptyState();

            return RefreshIndicator(
              onRefresh: () => context.read<BookingCubit>().loadAllBookings(),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final booking = filtered[index];
                  return BookingCard(
                    booking: booking,
                    onEdit: () => _showEditBookingBottomSheet(context, booking),
                    onDelete: () => _showDeleteDialog(context, booking),
                  );
                },
              ),
            );
          }

          return _buildEmptyState();
        },
      ),
    );
  }

  // ---------------- EMPTY STATE ----------------

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 72,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No Bookings Found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // ---------------- FILTER LOGIC ----------------

  List<Booking> _filterBookings(List<Booking> bookings, String filter) {
    switch (filter) {
      case 'Confirmed':
        return bookings.where((b) => b.status == 'confirmed').toList();
      case 'Checked In':
        return bookings.where((b) => b.status == 'checked_in').toList();
      case 'Checked Out':
        return bookings.where((b) => b.status == 'checked_out').toList();
      case 'Cancelled':
        return bookings.where((b) => b.status == 'cancelled').toList();
      default:
        return bookings;
    }
  }

  void _applyFilter(BuildContext context, String filter) {
    final cubit = context.read<BookingCubit>();
    switch (filter) {
      case 'All':
        cubit.loadAllBookings();
        break;
      case 'Confirmed':
        cubit.loadBookingsByStatus('confirmed');
        break;
      case 'Checked In':
        cubit.loadBookingsByStatus('checked_in');
        break;
      case 'Checked Out':
        cubit.loadBookingsByStatus('checked_out');
        break;
      case 'Cancelled':
        cubit.loadBookingsByStatus('cancelled');
        break;
    }
  }

  // ---------------- MODALS ----------------

  void _showAddBookingBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<BookingCubit>(),
        child: const AddBookingBottomSheet(),
      ),
    );
  }

  void _showEditBookingBottomSheet(BuildContext context, Booking booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<BookingCubit>(),
        child: AddBookingBottomSheet(booking: booking),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Booking booking) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Booking'),
        content: Text('Delete booking #${booking.id}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<BookingCubit>().deleteBooking(booking);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

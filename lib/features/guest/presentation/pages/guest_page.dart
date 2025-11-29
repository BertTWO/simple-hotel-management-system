// lib/features/guests/presentation/pages/guests_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordanhotel/core/di/injector.dart';
import 'package:jordanhotel/features/guest/domain/entity/guest.dart';
import 'package:jordanhotel/features/guest/presentation/components/add_guest_sheet.dart';
import 'package:jordanhotel/features/guest/presentation/components/guest_card.dart';
import 'package:jordanhotel/features/guest/presentation/cubit/guest_cubit.dart';

class GuestsPage extends StatefulWidget {
  const GuestsPage({super.key});

  @override
  State<GuestsPage> createState() => _GuestsPageState();
}

class _GuestsPageState extends State<GuestsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      context.read<GuestCubit>().loadAllGuests();
    } else {
      context.read<GuestCubit>().searchGuests(_searchController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildHeader(context),
          _buildSearchBar(),
          Expanded(
            child: BlocListener<GuestCubit, GuestState>(
              listener: (context, state) {
                if (state is GuestOperationSuccess) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                  context.read<GuestCubit>().loadAllGuests();
                }

                if (state is GuestError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              child: BlocBuilder<GuestCubit, GuestState>(
                builder: (context, state) {
                  if (state is GuestLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF0368B3),
                        ),
                      ),
                    );
                  }

                  if (state is GuestLoaded) {
                    if (state.guests.isEmpty) return _buildEmptyState();

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<GuestCubit>().loadAllGuests();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        itemCount: state.guests.length,
                        itemBuilder: (context, index) {
                          final guest = state.guests[index];
                          return GuestCard(
                            guest: guest,
                            onEdit: () =>
                                _showEditGuestBottomSheet(context, guest),
                            onDelete: () => _showDeleteDialog(context, guest),
                          );
                        },
                      ),
                    );
                  }

                  return _buildEmptyState();
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGuestBottomSheet(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.person_add, size: 28),
      ),
    );
  }

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
            BlocBuilder<GuestCubit, GuestState>(
              builder: (context, state) {
                if (state is GuestLoaded) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildHeaderStat(
                        'Total Guests',
                        state.guests.length.toString(),
                        Colors.white,
                      ),
                      _buildHeaderStat(
                        'Active',
                        _getActiveBookingsCount(state.guests),
                        const Color(0xFF10B981),
                      ),
                      _buildHeaderStat(
                        'New Today',
                        _getNewTodayCount(state.guests),
                        const Color(0xFF3B82F6),
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
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
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search guests by name, email, or phone...',
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      context.read<GuestCubit>().loadAllGuests();
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildGuestsList() {
    return Expanded(
      child: BlocBuilder<GuestCubit, GuestState>(
        builder: (context, state) {
          if (state is GuestLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0368B3)),
              ),
            );
          }

          if (state is GuestError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.read<GuestCubit>().loadAllGuests(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0368B3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Try Again',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is GuestLoaded) {
            if (state.guests.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<GuestCubit>().loadAllGuests();
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                itemCount: state.guests.length,
                itemBuilder: (context, index) {
                  final guest = state.guests[index];
                  return GuestCard(
                    guest: guest,
                    onEdit: () => _showEditGuestBottomSheet(context, guest),
                    onDelete: () => _showDeleteDialog(context, guest),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                const Text(
                  'No Guests Found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _searchController.text.isEmpty
                      ? 'Add your first guest to get started'
                      : 'No guests found for "${_searchController.text}"',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getActiveBookingsCount(List<Guest> guests) {
    // This would ideally come from your bookings data
    // For now, return a placeholder
    return '0';
  }

  String _getNewTodayCount(List<Guest> guests) {
    final today = DateTime.now();
    final newGuests = guests.where((guest) {
      // Assuming you have a createdAt field in your Guest model
      // For now, return a placeholder
      return false;
    }).length;
    return newGuests.toString();
  }

  void _showAddGuestBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddGuestBottomSheet(),
    );
  }

  void _showEditGuestBottomSheet(BuildContext context, Guest guest) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddGuestBottomSheet(guest: guest),
    );
  }

  void _showDeleteDialog(BuildContext context, Guest guest) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Guest'),
        content: Text('Are you sure you want to delete ${guest.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<GuestCubit>().deleteGuest(guest);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

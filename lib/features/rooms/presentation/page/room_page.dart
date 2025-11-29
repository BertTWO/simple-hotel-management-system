// lib/features/rooms/presentation/pages/rooms_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordanhotel/features/rooms/domain/entity/room.dart';
import 'package:jordanhotel/features/rooms/presentation/components/add_room_sheet.dart';
import 'package:jordanhotel/features/rooms/presentation/components/item_card.dart';
import 'package:jordanhotel/features/rooms/presentation/cubit/room_cubit.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  String _currentFilter = 'All';

  @override
  void initState() {
    super.initState();
    // Load rooms when the page opens
    context.read<RoomCubit>().loadAllRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildHeader(context),
          _buildFilterChips(),
          Expanded(
            child: BlocListener<RoomCubit, RoomState>(
              listener: (context, state) {
                if (state is RoomOperationSuccess) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                  context.read<RoomCubit>().loadAllRooms();
                }

                if (state is RoomError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              child: BlocBuilder<RoomCubit, RoomState>(
                builder: (context, state) {
                  if (state is RoomLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF0368B3),
                        ),
                      ),
                    );
                  }

                  if (state is RoomLoaded) {
                    final filteredRooms = _filterRooms(
                      state.rooms,
                      _currentFilter,
                    );

                    if (filteredRooms.isEmpty) {
                      return _buildEmptyState();
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<RoomCubit>().loadAllRooms();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        itemCount: filteredRooms.length,
                        itemBuilder: (context, index) {
                          final room = filteredRooms[index];
                          return RoomCard(
                            room: room,
                            onEdit: () =>
                                _showEditRoomBottomSheet(context, room),
                            onDelete: () => _showDeleteDialog(context, room),
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
        onPressed: () => _showAddRoomBottomSheet(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  // ================= Header =================
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
            BlocBuilder<RoomCubit, RoomState>(
              builder: (context, state) {
                if (state is RoomLoaded) {
                  final available = state.rooms
                      .where((r) => r.status == 'available')
                      .length;
                  final occupied = state.rooms
                      .where((r) => r.status == 'occupied')
                      .length;
                  final maintenance = state.rooms
                      .where((r) => r.status == 'maintenance')
                      .length;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildHeaderStat(
                        'Total',
                        state.rooms.length.toString(),
                        Colors.white,
                      ),
                      _buildHeaderStat(
                        'Available',
                        available.toString(),
                        const Color(0xFF10B981),
                      ),
                      _buildHeaderStat(
                        'Occupied',
                        occupied.toString(),
                        const Color(0xFFF59E0B),
                      ),
                      _buildHeaderStat(
                        'Maintenance',
                        maintenance.toString(),
                        const Color(0xFFEF4444),
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

  // ================= Filter Chips =================
  Widget _buildFilterChips() {
    final filters = ['All', 'Available', 'Occupied', 'Maintenance', 'Cleaning'];

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
                onSelected: (selected) {
                  setState(() {
                    _currentFilter = filter;
                  });
                  _applyFilter(filter);
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

  void _applyFilter(String filter) {
    final cubit = context.read<RoomCubit>();

    switch (filter) {
      case 'All':
        cubit.loadAllRooms();
        break;
      case 'Available':
        cubit.loadAvailableRooms();
        break;
      case 'Occupied':
        cubit.loadRoomsByStatus('occupied');
        break;
      case 'Maintenance':
        cubit.loadRoomsByStatus('maintenance');
        break;
      case 'Cleaning':
        cubit.loadRoomsByStatus('cleaning');
        break;
    }
  }

  // ================= Room List =================
  List<Room> _filterRooms(List<Room> rooms, String filter) {
    if (filter == 'All') return rooms;
    return rooms.where((room) => room.status == filter.toLowerCase()).toList();
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
                Icon(
                  Icons.king_bed_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  'No Rooms Found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _currentFilter == 'All'
                      ? 'Add your first room to get started'
                      : 'No ${_currentFilter.toLowerCase()} rooms',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= Bottom Sheets & Dialogs =================
  void _showAddRoomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddRoomBottomSheet(),
    );
  }

  void _showEditRoomBottomSheet(BuildContext context, Room room) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddRoomBottomSheet(room: room),
    );
  }

  void _showDeleteDialog(BuildContext context, Room room) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Room'),
        content: Text(
          'Are you sure you want to delete Room ${room.roomNumber}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<RoomCubit>().deleteRoom(room);
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

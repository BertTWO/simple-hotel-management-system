// lib/features/dashboard/presentation/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordanhotel/core/di/injector.dart';
import 'package:jordanhotel/features/dashboard/presentation/cubit/dashboard_cubit.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardCubit>(
      create: (_) => getIt<DashboardCubit>()..loadDashboardData(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoading) {
                return _buildLoadingState();
              }

              if (state is DashboardError) {
                return _buildErrorState(state.message, context);
              }

              if (state is DashboardLoaded) {
                return _buildDashboard(context, state);
              }

              return _buildEmptyState();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, DashboardLoaded state) {
    return CustomScrollView(
      slivers: [
        // Header
        SliverAppBar(
          expandedHeight: 180,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.hotel,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hotel ni Jordan',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Management Dashboard',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),

        // Stats Grid
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.0, // Reduced from 1.1 to fit better
            ),
            delegate: SliverChildListDelegate([
              _buildModernStatCard(
                context: context,
                title: 'Total Rooms',
                value: state.totalRooms.toString(),
                icon: Icons.king_bed_outlined,
                gradient: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              _buildModernStatCard(
                context: context,
                title: 'Available',
                value: state.availableRooms.toString(),
                icon: Icons.check_circle_outline,
                gradient: const [Color(0xFF10B981), Color(0xFF34D399)],
              ),
              _buildModernStatCard(
                context: context,
                title: 'Occupied',
                value: state.occupiedRooms.toString(),
                icon: Icons.people_outline,
                gradient: const [Color(0xFFF59E0B), Color(0xFFFBBF24)],
              ),
              _buildModernStatCard(
                context: context,
                title: 'Total Guests',
                value: state.totalGuests.toString(),
                icon: Icons.person_outline,
                gradient: const [Color(0xFFEC4899), Color(0xFFF472B6)],
              ),
              _buildModernStatCard(
                context: context,
                title: 'Active Bookings',
                value: state.activeBookings.toString(),
                icon: Icons.calendar_today_outlined,
                gradient: const [Color(0xFFEF4444), Color(0xFFF87171)],
              ),
              _buildModernStatCard(
                context: context,
                title: "Today's Revenue",
                value: '\$${state.todayRevenue.toStringAsFixed(2)}',
                icon: Icons.attach_money_outlined,
                gradient: const [Color(0xFF059669), Color(0xFF10B981)],
              ),
            ]),
          ),
        ),

        // Quick Actions Header
        SliverPadding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
            bottom: 10,
          ),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
        ),

        // Quick Actions Grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4, // Adjusted for better fit
            ),
            delegate: SliverChildListDelegate([
              _buildActionCard(
                context: context,
                title: 'Check-in',
                subtitle: 'New guest',
                icon: Icons.login,
                color: const Color(0xFF10B981),
              ),
              _buildActionCard(
                context: context,
                title: 'Check-out',
                subtitle: 'Process payment',
                icon: Icons.logout,
                color: const Color(0xFFEF4444),
              ),
              _buildActionCard(
                context: context,
                title: 'Add Booking',
                subtitle: 'Create reservation',
                icon: Icons.add_circle_outline,
                color: const Color(0xFF3B82F6),
              ),
              _buildActionCard(
                context: context,
                title: 'Room Status',
                subtitle: 'View all rooms',
                icon: Icons.room_preferences,
                color: const Color(0xFF8B5CF6),
              ),
            ]),
          ),
        ),

        // Add some bottom padding
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }

  Widget _buildModernStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required List<Color> gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(16), // Reduced from 20
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.3),
            blurRadius: 8, // Reduced from 10
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16), // Reduced from 20
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              MainAxisAlignment.center, // Changed from spaceBetween
          children: [
            Container(
              padding: const EdgeInsets.all(6), // Reduced from 8
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10), // Reduced from 12
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ), // Reduced from 24
            ),
            const SizedBox(height: 12), // Added spacing
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20, // Reduced from 24
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12, // Reduced from 14
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ), // Reduced from 16
      child: Padding(
        padding: const EdgeInsets.all(12), // Reduced from 16
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              MainAxisAlignment.center, // Changed from spaceBetween
          children: [
            Icon(icon, color: color, size: 24), // Reduced from 28
            const SizedBox(height: 12), // Added spacing
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14, // Reduced from 16
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 2), // Reduced from 4
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11, // Reduced from 12
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
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
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0368B3)),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Loading Dashboard...',
            style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message, BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Oops!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  context.read<DashboardCubit>().loadDashboardData(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0368B3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.hotel, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                const Text(
                  'Welcome to Jordan Hotel',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Management System',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

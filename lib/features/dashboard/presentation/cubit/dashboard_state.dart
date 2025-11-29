// lib/features/dashboard/business_logic/dashboard_state.dart
part of 'dashboard_cubit.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final int totalRooms;
  final int availableRooms;
  final int occupiedRooms;
  final int totalGuests;
  final int activeBookings;
  final double todayRevenue;

  const DashboardLoaded({
    required this.totalRooms,
    required this.availableRooms,
    required this.occupiedRooms,
    required this.totalGuests,
    required this.activeBookings,
    required this.todayRevenue,
  });

  @override
  List<Object> get props => [
    totalRooms,
    availableRooms,
    occupiedRooms,
    totalGuests,
    activeBookings,
    todayRevenue,
  ];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object> get props => [message];
}

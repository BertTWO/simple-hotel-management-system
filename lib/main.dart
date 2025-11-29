// lib/main.dart (updated)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordanhotel/core/di/injector.dart';
import 'package:jordanhotel/core/theme/app_theme.dart';
import 'package:jordanhotel/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:jordanhotel/features/auth/presentation/pages/login_page.dart';
import 'package:jordanhotel/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:jordanhotel/features/booking/presentation/pages/booking_page.dart';
import 'package:jordanhotel/features/dashboard/presentation/components/app_drawer.dart';
import 'package:jordanhotel/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:jordanhotel/features/guest/presentation/cubit/guest_cubit.dart';
import 'package:jordanhotel/features/guest/presentation/pages/guest_page.dart';
import 'package:jordanhotel/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:jordanhotel/features/payment/presentation/pages/payment_pages.dart';
import 'package:jordanhotel/features/rooms/presentation/cubit/room_cubit.dart';
import 'package:jordanhotel/features/rooms/presentation/page/room_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const HotelApp());
}

class HotelApp extends StatelessWidget {
  const HotelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RoomCubit>(
          create: (_) => getIt<RoomCubit>()..loadAllRooms(),
        ),
        BlocProvider<GuestCubit>(
          create: (_) => getIt<GuestCubit>()..loadAllGuests(),
        ),
        BlocProvider<BookingCubit>(
          create: (_) => getIt<BookingCubit>()..loadAllBookings(),
        ),
        BlocProvider<PaymentCubit>(
          create: (_) => getIt<PaymentCubit>()..loadAllPayments(),
        ),
        BlocProvider<AuthCubit>(create: (_) => getIt<AuthCubit>()),
      ],
      child: MaterialApp(
        title: 'Hotel ni Jordan',
        theme: HotelAppTheme.theme,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/Dashboard': (context) => const MainLayout(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const RoomsPage(),
    const GuestsPage(),
    const BookingsPage(),
    const PaymentsPage(),
  ];

  final List<String> _titles = [
    'Dashboard',
    'Rooms',
    'Guests',
    'Bookings',
    'Payments',
  ];
  void _onDrawerItemSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: MyDrawer(onItemSelected: _onDrawerItemSelected),
      body: _pages[_currentIndex],
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.data_usage),
      // ),
    );
  }

  // // Add this to your main layout or debug page
  // Future<void> _seedSampleData() async {
  //   final roomCubit = context.read<RoomCubit>();
  //   final guestCubit = context.read<GuestCubit>();
  //   final bookingCubit = context.read<BookingCubit>();
  //   final paymentCubit = context.read<PaymentCubit>();

  //   // Clear existing data first (optional)
  //   // await _clearAllData();

  //   // Seed rooms
  //   for (final room in DataSeeder.sampleRooms) {
  //     await roomCubit.addRoom(room);
  //   }

  //   // Wait for rooms to be added
  //   await Future.delayed(Duration(milliseconds: 500));

  //   // Seed guests
  //   for (final guest in DataSeeder.sampleGuests) {
  //     await guestCubit.addGuest(guest);
  //   }

  //   // Wait for guests to be added
  //   await Future.delayed(Duration(milliseconds: 500));

  //   // Seed bookings
  //   for (final booking in DataSeeder.sampleBookings) {
  //     await bookingCubit.addBooking(booking);
  //   }

  //   // Wait for bookings to be added
  //   await Future.delayed(Duration(milliseconds: 500));

  //   // Seed payments (now they have valid booking IDs)
  //   for (final payment in DataSeeder.samplePayments) {
  //     await paymentCubit.addPayment(payment);
  //   }

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('✅ Sample data seeded successfully!')),
  //   );
  // }

  // // Optional: Clear function if you want to reset
  // Future<void> _clearAllData() async {
  //   final roomCubit = context.read<RoomCubit>();
  //   final guestCubit = context.read<GuestCubit>();
  //   final bookingCubit = context.read<BookingCubit>();
  //   final paymentCubit = context.read<PaymentCubit>();

  //   // You'd need to implement deleteAll methods in your repositories
  //   // For now, this is just a placeholder
  // }
}

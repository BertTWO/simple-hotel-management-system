// lib/core/constants/drawer_items.dart
import 'package:flutter/material.dart';

class DrawerItem {
  final String title;
  final IconData icon;
  final String route;

  const DrawerItem({
    required this.title,
    required this.icon,
    required this.route,
  });
}

class DrawerItems {
  static const List<DrawerItem> mainItems = [
    DrawerItem(title: 'Dashboard', icon: Icons.dashboard, route: '/dashboard'),
    DrawerItem(title: 'Rooms', icon: Icons.king_bed, route: '/rooms'),
    DrawerItem(title: 'Guests', icon: Icons.people, route: '/guests'),
    DrawerItem(
      title: 'Bookings',
      icon: Icons.calendar_today,
      route: '/bookings',
    ),
    DrawerItem(title: 'Payments', icon: Icons.payment, route: '/payments'),
  ];

  static const List<DrawerItem> secondaryItems = [
    DrawerItem(title: 'Settings', icon: Icons.settings, route: '/settings'),
    DrawerItem(title: 'Logout', icon: Icons.logout, route: '/logout'),
  ];
}

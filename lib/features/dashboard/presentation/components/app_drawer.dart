import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordanhotel/core/constants/drawer_item.dart';
import 'package:jordanhotel/features/auth/presentation/cubit/auth_cubit.dart';

class MyDrawer extends StatelessWidget {
  final ValueChanged<int> onItemSelected;

  const MyDrawer({super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 8),
              Flexible(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: DrawerItems.mainItems.length,
                  itemBuilder: (context, index) {
                    final item = DrawerItems.mainItems[index];
                    return _buildMenuItem(context, item, index);
                  },
                ),
              ),
              const Divider(color: Colors.white30, height: 1),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.hotel, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            'Hotel ni Jordan',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Management System',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, DrawerItem item, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(item.icon, color: Colors.white, size: 20),
        ),
        title: Text(
          item.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () {
          Navigator.pop(context); // close drawer
          onItemSelected(index); // notify parent
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: DrawerItems.secondaryItems.map((item) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            child: ListTile(
              leading: Icon(item.icon, color: Colors.white70, size: 20),
              title: Text(
                item.title,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context);
                _navigateToPage(context, item.route);
              },
              dense: true,
            ),
          );
        }).toList(),
      ),
    );
  }

  void _navigateToPage(BuildContext context, String route) {
    if (route == '/logout') {
      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            'Logout',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                Navigator.of(ctx).pop(); // close dialog
                context.read<AuthCubit>().logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      );
      return;
    }

    // Otherwise, navigate normally
    Navigator.pushNamed(context, route);
  }
}

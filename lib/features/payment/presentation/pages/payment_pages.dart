// lib/features/payments/presentation/pages/payments_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordanhotel/core/di/injector.dart';
import 'package:jordanhotel/features/payment/domain/entity/payment.dart';
import 'package:jordanhotel/features/payment/presentation/components/payment_card.dart';
import 'package:jordanhotel/features/payment/presentation/components/payment_form.dart';
import 'package:jordanhotel/features/payment/presentation/cubit/payment_cubit.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  String _currentFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PaymentCubit>()..loadAllPayments(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Column(
          children: [
            // Header
            _buildHeader(context),
            // Filter Chips
            _buildFilterChips(),
            // Payments List
            _buildPaymentsList(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddPaymentBottomSheet(context),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 4,
          child: const Icon(Icons.payment, size: 28),
        ),
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
            BlocBuilder<PaymentCubit, PaymentState>(
              builder: (context, state) {
                if (state is PaymentLoaded) {
                  final completed = state.payments
                      .where((p) => p.status == 'completed')
                      .length;
                  final pending = state.payments
                      .where((p) => p.status == 'pending')
                      .length;
                  final totalRevenue = state.payments
                      .where((p) => p.status == 'completed')
                      .fold(0.0, (sum, payment) => sum + payment.amount);

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildHeaderStat(
                        'Total',
                        state.payments.length.toString(),
                        Colors.white,
                      ),
                      _buildHeaderStat(
                        'Completed',
                        completed.toString(),
                        const Color(0xFF10B981),
                      ),
                      _buildHeaderStat(
                        'Pending',
                        pending.toString(),
                        const Color(0xFFF59E0B),
                      ),
                      _buildHeaderStat(
                        'Revenue',
                        '\₱${totalRevenue.toStringAsFixed(0)}',
                        const Color.fromARGB(255, 121, 143, 27),
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

  Widget _buildFilterChips() {
    final filters = ['All', 'Completed', 'Pending', 'Failed', 'Refunded'];

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

  Widget _buildPaymentsList() {
    return Expanded(
      child: BlocBuilder<PaymentCubit, PaymentState>(
        builder: (context, state) {
          if (state is PaymentLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0368B3)),
              ),
            );
          }

          if (state is PaymentError) {
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
                    onPressed: () =>
                        context.read<PaymentCubit>().loadAllPayments(),
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

          if (state is PaymentLoaded) {
            final filteredPayments = _filterPayments(
              state.payments,
              _currentFilter,
            );

            if (filteredPayments.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<PaymentCubit>().loadAllPayments();
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                itemCount: filteredPayments.length,
                itemBuilder: (context, index) {
                  final payment = filteredPayments[index];
                  return PaymentCard(
                    payment: payment,
                    onEdit: () => _showEditPaymentBottomSheet(context, payment),
                    onDelete: () => _showDeleteDialog(context, payment),
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
                Icon(
                  Icons.payments_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  'No Payments Found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _currentFilter == 'All'
                      ? 'Record your first payment to get started'
                      : 'No $_currentFilter.toLowerCase() payments',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Payment> _filterPayments(List<Payment> payments, String filter) {
    if (filter == 'All') return payments;

    switch (filter) {
      case 'Completed':
        return payments
            .where((payment) => payment.status == 'completed')
            .toList();
      case 'Pending':
        return payments
            .where((payment) => payment.status == 'pending')
            .toList();
      case 'Failed':
        return payments.where((payment) => payment.status == 'failed').toList();
      case 'Refunded':
        return payments
            .where((payment) => payment.status == 'refunded')
            .toList();
      default:
        return payments;
    }
  }

  void _applyFilter(BuildContext context, String filter) {
    final cubit = context.read<PaymentCubit>();

    switch (filter) {
      case 'All':
        cubit.loadAllPayments();
        break;
      case 'Completed':
        cubit.loadPaymentsByStatus('completed');
        break;
      case 'Pending':
        cubit.loadPaymentsByStatus('pending');
        break;
      case 'Failed':
        cubit.loadPaymentsByStatus('failed');
        break;
      case 'Refunded':
        cubit.loadPaymentsByStatus('refunded');
        break;
    }
  }

  void _showAddPaymentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddPaymentBottomSheet(),
    );
  }

  void _showEditPaymentBottomSheet(BuildContext context, Payment payment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddPaymentBottomSheet(payment: payment),
    );
  }

  void _showDeleteDialog(BuildContext context, Payment payment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Payment'),
        content: Text(
          'Are you sure you want to delete payment #${payment.id ?? 'N/A'}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<PaymentCubit>().deletePayment(payment);
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

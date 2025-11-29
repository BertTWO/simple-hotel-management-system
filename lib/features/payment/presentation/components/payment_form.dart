// lib/features/payments/presentation/widgets/add_payment_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:jordanhotel/features/booking/domain/entity/booking.dart';
import 'package:jordanhotel/features/payment/domain/entity/payment.dart';
import 'package:jordanhotel/features/payment/presentation/cubit/payment_cubit.dart';

class AddPaymentBottomSheet extends StatefulWidget {
  final Payment? payment;

  const AddPaymentBottomSheet({super.key, this.payment});

  @override
  State<AddPaymentBottomSheet> createState() => _AddPaymentBottomSheetState();
}

class _AddPaymentBottomSheetState extends State<AddPaymentBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bookingController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _transactionIdController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  int? selectedBookingId;
  String _selectedMethod = 'cash';
  String _selectedStatus = 'completed';
  DateTime? _paymentDate;

  @override
  void initState() {
    super.initState();
    if (widget.payment != null) {
      _amountController.text = widget.payment!.amount.toString();
      _transactionIdController.text = widget.payment!.transactionId ?? '';
      _notesController.text = widget.payment!.notes ?? '';
      _selectedMethod = widget.payment!.method;
      _selectedStatus = widget.payment!.status;
      selectedBookingId = widget.payment!.bookingId;
      _bookingController.text = 'Booking ID: ${widget.payment!.bookingId}';

      try {
        _paymentDate = DateTime.parse(widget.payment!.paymentDate);
      } catch (e) {
        // Handle date parsing error
      }
    } else {
      _paymentDate = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.payment == null
                          ? 'Record Payment'
                          : 'Edit Payment',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, size: 24),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Booking TypeAhead
                const Text(
                  'Booking',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                TypeAheadField<Booking>(
                  debounceDuration: const Duration(milliseconds: 300),
                  builder: (context, controller, focusNode) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: 'Search booking by ID or guest...',
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.confirmation_number,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                  suggestionsCallback: (pattern) async {
                    if (pattern.isEmpty) return [];
                    return await context.read<PaymentCubit>().searchBookings(
                      pattern,
                    );
                  },
                  itemBuilder: (context, booking) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[200]!),
                        ),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: _getBookingGradient(booking.status),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getBookingIcon(booking.status),
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          'Booking #${booking.id ?? 'N/A'}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          'Room ${booking.roomId} • ${_formatDate(booking.checkInDate)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getBookingStatusColor(
                              booking.status,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _getBookingStatusColor(
                                booking.status,
                              ).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            _formatBookingStatus(booking.status),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _getBookingStatusColor(booking.status),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  onSelected: (booking) {
                    setState(() {
                      _bookingController.text = 'Booking #${booking.id}';
                      selectedBookingId = booking.id;
                    });
                  },
                  controller: _bookingController,
                ),
                const SizedBox(height: 16),

                // Amount
                const Text(
                  'Amount',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    hintText: 'Enter payment amount',
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.attach_money,
                      color: Colors.grey,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Payment Method
                const Text(
                  'Payment Method',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedMethod,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    prefixIcon: const Icon(Icons.payment, color: Colors.grey),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'cash', child: Text('Cash')),
                    DropdownMenuItem(
                      value: 'credit_card',
                      child: Text('Credit Card'),
                    ),
                    DropdownMenuItem(
                      value: 'debit_card',
                      child: Text('Debit Card'),
                    ),
                    DropdownMenuItem(
                      value: 'bank_transfer',
                      child: Text('Bank Transfer'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedMethod = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Status
                const Text(
                  'Status',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    prefixIcon: const Icon(Icons.circle, color: Colors.grey),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'completed',
                      child: Text('Completed'),
                    ),
                    DropdownMenuItem(value: 'pending', child: Text('Pending')),
                    DropdownMenuItem(value: 'failed', child: Text('Failed')),
                    DropdownMenuItem(
                      value: 'refunded',
                      child: Text('Refunded'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Payment Date
                const Text(
                  'Payment Date',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today, color: Colors.grey),
                  title: Text(
                    _paymentDate == null
                        ? 'Select payment date'
                        : '${_formatDate(_paymentDate!.toIso8601String())}',
                  ),
                  onTap: () => _selectPaymentDate(context),
                ),
                const SizedBox(height: 16),

                // Transaction ID
                const Text(
                  'Transaction ID (Optional)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _transactionIdController,
                  decoration: InputDecoration(
                    hintText: 'Enter transaction ID',
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    prefixIcon: const Icon(Icons.receipt, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),

                // Notes
                const Text(
                  'Notes (Optional)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    hintText: 'Enter any notes...',
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    prefixIcon: const Icon(Icons.note, color: Colors.grey),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0368B3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      widget.payment == null
                          ? 'Record Payment'
                          : 'Update Payment',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectPaymentDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _paymentDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _paymentDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _paymentDate != null &&
        selectedBookingId != null) {
      final payment = Payment(
        id: widget.payment?.id,
        bookingId: selectedBookingId!,
        amount: double.parse(_amountController.text),
        method: _selectedMethod,
        status: _selectedStatus,
        paymentDate: _paymentDate!.toIso8601String(),
        transactionId: _transactionIdController.text.isEmpty
            ? null
            : _transactionIdController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      if (widget.payment == null) {
        context.read<PaymentCubit>().addPayment(payment);
      } else {
        context.read<PaymentCubit>().updatePayment(payment);
      }

      Navigator.pop(context);
    }
  }

  LinearGradient _getBookingGradient(String status) {
    switch (status) {
      case 'confirmed':
        return const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
        );
      case 'checked_in':
        return const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF34D399)],
        );
      case 'checked_out':
        return const LinearGradient(
          colors: [Color(0xFF6B7280), Color(0xFF9CA3AF)],
        );
      case 'cancelled':
        return const LinearGradient(
          colors: [Color(0xFFEF4444), Color(0xFFF87171)],
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
        );
    }
  }

  IconData _getBookingIcon(String status) {
    switch (status) {
      case 'confirmed':
        return Icons.confirmation_num;
      case 'checked_in':
        return Icons.login;
      case 'checked_out':
        return Icons.logout;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.calendar_today;
    }
  }

  Color _getBookingStatusColor(String status) {
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

  String _formatBookingStatus(String status) {
    switch (status) {
      case 'confirmed':
        return 'Confirmed';
      case 'checked_in':
        return 'Checked In';
      case 'checked_out':
        return 'Checked Out';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  @override
  void dispose() {
    _bookingController.dispose();
    _amountController.dispose();
    _transactionIdController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

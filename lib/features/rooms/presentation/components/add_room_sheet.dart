// lib/features/rooms/presentation/widgets/add_room_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordanhotel/features/rooms/domain/entity/room.dart';
import 'package:jordanhotel/features/rooms/presentation/cubit/room_cubit.dart';

class AddRoomBottomSheet extends StatefulWidget {
  final Room? room;

  const AddRoomBottomSheet({super.key, this.room});

  @override
  State<AddRoomBottomSheet> createState() => _AddRoomBottomSheetState();
}

class _AddRoomBottomSheetState extends State<AddRoomBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _roomNumberController = TextEditingController();
  final _priceController = TextEditingController();
  final _capacityController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedType = 'single';
  String _selectedStatus = 'available';

  @override
  void initState() {
    super.initState();
    if (widget.room != null) {
      _roomNumberController.text = widget.room!.roomNumber;
      _priceController.text = widget.room!.pricePerNight.toString();
      _capacityController.text = widget.room!.capacity.toString();
      _descriptionController.text = widget.room!.description ?? '';
      _selectedType = widget.room!.type;
      _selectedStatus = widget.room!.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.room == null ? 'Add New Room' : 'Edit Room',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _roomNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Room Number',
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter room number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Room Type',
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'single', child: Text('Single')),
                    DropdownMenuItem(value: 'double', child: Text('Double')),
                    DropdownMenuItem(value: 'deluxe', child: Text('Deluxe')),
                    DropdownMenuItem(value: 'suite', child: Text('Suite')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price per Night',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _capacityController,
                  decoration: const InputDecoration(
                    labelText: 'Capacity',
                    prefixIcon: Icon(Icons.people),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter capacity';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter valid capacity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    prefixIcon: Icon(Icons.circle),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'available',
                      child: Text('Available'),
                    ),
                    DropdownMenuItem(
                      value: 'occupied',
                      child: Text('Occupied'),
                    ),
                    DropdownMenuItem(
                      value: 'maintenance',
                      child: Text('Maintenance'),
                    ),
                    DropdownMenuItem(
                      value: 'cleaning',
                      child: Text('Cleaning'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
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
                      widget.room == null ? 'Add Room' : 'Update Room',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final room = Room(
        id: widget.room?.id,
        roomNumber: _roomNumberController.text,
        type: _selectedType,
        pricePerNight: double.parse(_priceController.text),
        status: _selectedStatus,
        capacity: int.parse(_capacityController.text),
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
      );

      if (widget.room == null) {
        context.read<RoomCubit>().addRoom(room);
      } else {
        context.read<RoomCubit>().updateRoom(room);
      }
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _roomNumberController.dispose();
    _priceController.dispose();
    _capacityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

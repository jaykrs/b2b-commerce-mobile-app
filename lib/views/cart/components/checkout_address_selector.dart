import 'package:EazySupplies/core/constants/apiClients.dart';
import 'package:EazySupplies/core/constants/api_config.dart';
import 'package:EazySupplies/core/routes/app_routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:EazySupplies/core/constants/apiCall.dart';
import 'package:EazySupplies/core/models/userModel.dart';
import '../../../core/components/title_and_action_button.dart';
import 'checkout_address_card.dart';

class AddressSelector extends StatefulWidget {
  final ValueChanged<Address> onAddressSelected;

  const AddressSelector({
    super.key,
    required this.onAddressSelected,
  });

  @override
  State<AddressSelector> createState() => _AddressSelectorState();
}

class _AddressSelectorState extends State<AddressSelector> {
  int _activeIndex = 0;
  List<Address> addressList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    try {
      final data = await getAddress();
      setState(() {
        addressList = data;
        isLoading = false;
      });

      // Auto-select first address
      if (data.isNotEmpty) {
        widget.onAddressSelected(data[0]);
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('Error fetching addresses: $e');
    }
  }

  void _selectAddress(int index) {
    setState(() {
      _activeIndex = index;
    });

    widget.onAddressSelected(addressList[index]);
  }

  Future<void> _deleteAddress(Address address) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        debugPrint('Attempting to delete address ID: ${address.id}');

        // Using query parameters as seen in readNotification API
        final response = await ApiClient.dio.delete(
          ApiConfig.addressPost,
          queryParameters: {'id': address.id},
        );

        debugPrint('Delete response: ${response.statusCode} - ${response.data}');

        if (response.statusCode == 200 ||
            response.statusCode == 204 ||
            response.data?['success'] == true) {
          fetchAddresses();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Address deleted successfully')),
            );
          }
        }
      } catch (e) {
        debugPrint('Delete address error details: $e');
        if (e is DioException) {
          debugPrint('Delete error response: ${e.response?.data}');
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete address')),
          );
        }
      }
    }
  }

  Future<void> _openAddEditPage([Address? address]) async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.addEditAddressPage,
      arguments: address,
    );

    if (result == true) {
      // refresh list after add/edit
      fetchAddresses();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (addressList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "No addresses found.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _openAddEditPage(),
              icon: const Icon(Icons.add_location_alt_outlined),
              label: const Text("Add Delivery Address"),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        TitleAndActionButton(
          title: 'Select Delivery Address',
          actionLabel: 'Add New',
          onTap: () {
            _openAddEditPage();
          },
          isHeadline: false,
        ),
        ...List.generate(addressList.length, (index) {
          final address = addressList[index];
          return AddressCard(
            label: address.name,
            phoneNumber: address.zipcode,
            address: '${address.address}, ${address.city}',
            isActive: _activeIndex == index,
            onTap: () => _selectAddress(index),
            onEdit: () => _openAddEditPage(address),
            onDelete: () => _deleteAddress(address),
          );
        }),
      ],
    );
  }
}

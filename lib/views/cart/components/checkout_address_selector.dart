import 'package:EazySupplies/core/routes/app_routes.dart';
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
      if (!mounted) return;
      setState(() {
        addressList = data;
        isLoading = false;
      });

      // Auto-select first address
      if (data.isNotEmpty) {
        widget.onAddressSelected(data[0]);
      }
    } catch (e) {
      if (!mounted) return;
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
      return Column(
        children: [
          TitleAndActionButton(
            title: 'Delivery Address',
            actionLabel: 'Add New',
            onTap: () => _openAddEditPage(),
            isHeadline: false,
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
                child: Text('Add a delivery address to place your order.')),
          ),
        ],
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
            phoneNumber: address.zipcode, // replace if phone exists
            address: '${address.address}, ${address.city}',
            isActive: _activeIndex == index,
            onTap: () => _selectAddress(index),
          );
        }),
      ],
    );
  }
}

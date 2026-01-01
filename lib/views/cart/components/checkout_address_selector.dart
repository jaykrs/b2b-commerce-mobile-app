import 'package:flutter/material.dart';
import 'package:grocery/core/constants/apiCall.dart';
import 'package:grocery/core/models/userModel.dart';
import '../../../core/components/title_and_action_button.dart';
import 'checkout_address_card.dart';
import '../../../core/constants/get_bundels.dart';

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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (addressList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text("No addresses found.")),
      );
    }

    return Column(
      children: [
        TitleAndActionButton(
          title: 'Select Delivery Address',
          actionLabel: 'Add New',
          onTap: () {
            // TODO: Navigate to Add Address Page
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


// import 'package:flutter/material.dart';
// import 'package:grocery/core/constants/apiCall.dart';
// import 'package:grocery/core/models/userModel.dart';
// import '../../../core/components/title_and_action_button.dart';
// import 'checkout_address_card.dart';// make sure this is your Address model
// import '../../../core/constants/get_bundels.dart'; // where getAddress() is

// class AddressSelector extends StatefulWidget {
//   const AddressSelector({super.key});

//   @override
//   State<AddressSelector> createState() => _AddressSelectorState();
// }

// class _AddressSelectorState extends State<AddressSelector> {
//   int _activeIndex = 0;
//   List<Address> addressList = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchAddresses();
//   }

//   Future<void> fetchAddresses() async {
//     try {
//       final data = await getAddress(); // your API call
//       setState(() {
//         addressList = data;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() => isLoading = false);
//       debugPrint('Error fetching addresses: $e');
//     }
//   }

//   void _selectAddress(int index) {
//     setState(() {
//       _activeIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (addressList.isEmpty) {
//       return const Center(child: Text("No addresses found."));
//     }

//     return Column(
//       children: [
//         TitleAndActionButton(
//           title: 'Select Delivery Address',
//           actionLabel: 'Add New',
//           onTap: () {
//             // handle add new address
//           },
//           isHeadline: false,
//         ),
//         ...List.generate(addressList.length, (index) {
//           final address = addressList[index];
//           return AddressCard(
//             label: address.name,
//             phoneNumber: address.zipcode, // replace if you have phone field
//             address: '${address.address}, ${address.city}',
//             isActive: _activeIndex == index,
//             onTap: () => _selectAddress(index),
//           );
//         }),
//       ],
//     );
//   }
// }
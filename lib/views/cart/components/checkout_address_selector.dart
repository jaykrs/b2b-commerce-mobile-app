import 'package:flutter/material.dart';
import 'package:grocery/core/models/dummy_bundle_model.dart';
import '../../../core/components/title_and_action_button.dart';
import 'checkout_address_card.dart';// make sure this is your Address model
import '../../../core/constants/get_bundels.dart'; // where getAddress() is

class AddressSelector extends StatefulWidget {
  const AddressSelector({super.key});

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
      final data = await getAddress(); // your API call
      setState(() {
        addressList = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('Error fetching addresses: $e');
    }
  }

  void _selectAddress(int index) {
    setState(() {
      _activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (addressList.isEmpty) {
      return const Center(child: Text("No addresses found."));
    }

    return Column(
      children: [
        TitleAndActionButton(
          title: 'Select Delivery Address',
          actionLabel: 'Add New',
          onTap: () {
            // handle add new address
          },
          isHeadline: false,
        ),
        ...List.generate(addressList.length, (index) {
          final address = addressList[index];
          return AddressCard(
            label: address.name,
            phoneNumber: address.zipcode, // replace if you have phone field
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

// import '../../../core/components/title_and_action_button.dart';
// import 'checkout_address_card.dart';

// class AddressSelector extends StatelessWidget {
//   const AddressSelector({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TitleAndActionButton(
//           title: 'Select Delivery Address',
//           actionLabel: 'Add New',
//           onTap: () {},
//           isHeadline: false,
//         ),
//         AddressCard(
//           label: 'Home Address',
//           phoneNumber: '(309) 071-9396-939',
//           address: '1749 Custom Road, Chhatak',
//           isActive: false,
//           onTap: () {},
//         ),
//         AddressCard(
//           label: 'Office Address',
//           phoneNumber: '(309) 071-9396-939',
//           address: '1749 Custom Road, Chhatak',
//           isActive: true,
//           onTap: () {},
//         )
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:grocery/core/constants/apiCall.dart';
import 'package:grocery/core/constants/app_colors.dart';
import 'package:grocery/core/constants/app_defaults.dart';
import 'package:grocery/core/models/userModel.dart';
import 'package:grocery/core/routes/app_routes.dart';

class AddressWidget extends StatefulWidget {
  const AddressWidget({super.key});

  @override
  State<AddressWidget> createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  List<Address> addressList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    setState(() => isLoading = true);
    try {
      final data = await getAddress(); // fetch addresses from API
      setState(() {
        addressList = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('Error fetching addresses: $e');
    }
  }

  // Open Add/Edit page and refresh after return
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
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.of(context).pop()),
        title: const Text('My Addresses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openAddEditPage(),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : addressList.isEmpty
              ? const Center(child: Text("No addresses found."))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: addressList.length,
                  itemBuilder: (context, index) {
                    final address = addressList[index];
                    return AddressCardView(
                      label: address.name,
                      phoneNumber: address.zipcode,
                      address: '${address.address}, ${address.city}',
                      onEdit: () => _openAddEditPage(address),
                    );
                  },
                ),
    );
  }
}

class AddressCardView extends StatelessWidget {
  const AddressCardView({
    super.key,
    required this.label,
    required this.phoneNumber,
    required this.address,
    this.onEdit,
  });

  final String label;
  final String phoneNumber;
  final String address;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDefaults.padding,
        vertical: AppDefaults.padding / 2,
      ),
      child: Material(
        color: AppColors.textInputBackground,
        borderRadius: AppDefaults.borderRadius,
        child: InkWell(
          borderRadius: AppDefaults.borderRadius,
          onTap: () {}, // optional: tap on entire card
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDefaults.padding),
            decoration: BoxDecoration(
              borderRadius: AppDefaults.borderRadius,
              border: Border.all(
                color: Colors.grey.shade400,
                width: 0.7,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Address info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        phoneNumber,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        address,
                        style: Theme.of(context).textTheme.bodyMedium,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),

                // Edit icon
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: onEdit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:grocery/core/constants/apiCall.dart';
// import 'package:grocery/core/constants/app_colors.dart';
// import 'package:grocery/core/constants/app_defaults.dart';
// import 'package:grocery/core/models/userModel.dart';
// import 'package:grocery/core/routes/app_routes.dart';

// class AddressWidget extends StatefulWidget {
//   const AddressWidget({super.key});

//   @override
//   State<AddressWidget> createState() => _AddressWidgetState();
// } 

// class _AddressWidgetState extends State<AddressWidget> {
//   List<Address> addressList = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchAddresses();
//   }

//   Future<void> fetchAddresses() async {
//     try {
//       final data = await getAddress();
//       setState(() {
//         addressList = data;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() => isLoading = false);
//       debugPrint('Error fetching addresses: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: BackButton(
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: const Text('My Addresses'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () {
//               Navigator.pushNamed(
//                 context,
//                 AppRoutes.addEditAddressPage,
//               );
//             },
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : addressList.isEmpty
//               ? const Center(child: Text("No addresses found."))
//               : ListView.builder(
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   itemCount: addressList.length, 
//                   itemBuilder: (context, index) {
//                     final address = addressList[index];
//                     return AddressCardView(
//                       label: address.name,
//                       phoneNumber: address.zipcode,
//                       address: '${address.address}, ${address.city}',
//                       onEdit: () {
//                         Navigator.pushNamed(
//                           context,
//                           AppRoutes.addEditAddressPage,
//                           arguments: address,
//                         );
//                       },
//                     );
//                   },
//                 ),
//     );
//   }
// }

// class AddressCardView extends StatelessWidget {
//   const AddressCardView({
//     super.key,
//     required this.label,
//     required this.phoneNumber,
//     required this.address,
//     this.onEdit,
//   });

//   final String label;
//   final String phoneNumber;
//   final String address;
//   final VoidCallback? onEdit;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: AppDefaults.padding,
//         vertical: AppDefaults.padding / 2,
//       ),
//       child: Material(
//         color: AppColors.textInputBackground,
//         borderRadius: AppDefaults.borderRadius,
//         child: InkWell(
//           borderRadius: AppDefaults.borderRadius,
//           onTap: () {}, // optional click on entire card
//           child: Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(AppDefaults.padding),
//             decoration: BoxDecoration(
//               borderRadius: AppDefaults.borderRadius,
//               border: Border.all(
//                 color: Colors.grey.shade400,
//                 width: 0.7,
//               ),
//             ),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Address info
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         label,
//                         style: Theme.of(context)
//                             .textTheme
//                             .bodyLarge
//                             ?.copyWith(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         phoneNumber,
//                         style: Theme.of(context).textTheme.bodyMedium,
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         address,
//                         style: Theme.of(context).textTheme.bodyMedium,
//                         softWrap: true,
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Edit icon
//                 IconButton(
//                   icon: const Icon(Icons.edit, color: Colors.blue),
//                   onPressed: onEdit,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:EazySupplies/core/models/userModel.dart';
import 'package:EazySupplies/core/routes/app_routes.dart';

class OrderViewPage extends StatefulWidget {
  final Order orderData;

  const OrderViewPage({super.key, required this.orderData});

  @override
  State<OrderViewPage> createState() => _OrderViewPageState();
}

class _OrderViewPageState extends State<OrderViewPage> {
  String? selectedPaymentMethodId;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final shipping = widget.orderData.shipping;
    final items = widget.orderData.items;
    final note = widget.orderData.jsonData?['note'] ?? '';
    final payment = widget.orderData.payment;
    debugPrint('........${selectedPaymentMethodId}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${widget.orderData.id}'), 
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Details
            Text(
              'Order Details',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Status', widget.orderData.status),
            _buildInfoRow(
                'Approved', widget.orderData.approved ? 'APPROVED' : 'PENDING'),
            if (note.isNotEmpty) _buildInfoRow('Note', note),

            const Divider(height: 32),

            // Items
            Text(
              'Items',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...items.map((item) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.productDetails,
                        arguments: item.productId,
                      );
                    },
                    child: Text(
                      'Product: ${item.productName}',
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                  subtitle: Text('Quantity: ${item.quantity}'),
                  trailing: Text('₹${item.price}'),
                ),
              );
            }),

            const Divider(height: 32),

            // Shipping Info
            Text(
              'Shipping Info',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Address', shipping?.address ?? ''),
            _buildInfoRow('City', shipping?.city ?? ''),
            _buildInfoRow('State', shipping?.state ?? ''),
            _buildInfoRow('Postal Code', shipping?.postalCode ?? ''),
            _buildInfoRow('Country', shipping?.country ?? ''),
            _buildInfoRow('Status', shipping?.status ?? ''),

            const Divider(height: 32),

            // Payment Info
            Text(
              'Payment Info',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.orderData.status == 'APPROVED') ...[
                  // Show subtotal, tax, total
                  _buildInfoRow('Subtotal', '₹'),
                  _buildInfoRow('Tax', '₹'),
                  _buildInfoRow('Total', '₹'),

                  const SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        const Text(
                          'Payment:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                            width: 12), // spacing between label and dropdown
                        Expanded(
                          child: DropdownButton<String>(
                            isExpanded:
                                true, // make dropdown fill the available space
                            value: selectedPaymentMethodId,
                            hint: const Text('Select Payment Method'),
                            items: PaymentMethod.values.map((method) {
                              return DropdownMenuItem<String>(
                                value: method.id,
                                child: Text(method.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedPaymentMethodId = value;
                              });
                              print('Selected Payment Method ID: $value');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity, // full width
                    child: ElevatedButton(
                      onPressed: selectedPaymentMethodId == null
                          ? null
                          : () {
                              print(
                                  'Proceed to pay with ID: $selectedPaymentMethodId');
                            },
                      child: const Text('Proceed to Pay'),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 8),
                  _buildInfoRow('TransactionId', payment?.transactionId ?? ''),
                  _buildInfoRow('Amount', '₹${payment?.amount ?? 0}'),
                  _buildInfoRow('Method', payment?.method ?? ''),
                  _buildInfoRow('Status', payment?.status ?? ''),
                  const SizedBox(height: 12),
                  DropdownButton<String>(
                    value: selectedPaymentMethodId,
                    hint: const Text('Select Payment Method'),
                    items: PaymentMethod.values.map((method) {
                      return DropdownMenuItem<String>(
                        value: method.id,
                        child: Text(method.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethodId = value;
                      });
                      print('Selected Payment Method ID: $value');
                    },
                  ),
                ],
              ],
            )

            // _buildInfoRow('TransactionId', payment?.transactionId ?? ''),
            // _buildInfoRow('Amount', '₹${payment?.amount ?? 0}'),
            // _buildInfoRow('Method', payment?.method ?? ''),
            // _buildInfoRow('Status', payment?.status ?? ''),

            // const SizedBox(height: 12),
            // DropdownButton<String>(
            //   value: selectedPaymentMethodId, // binds to selected ID
            //   hint: const Text('Select Payment Method'),
            //   items: PaymentMethod.values.map((method) {
            //     return DropdownMenuItem<String>(
            //       value: method.id, // <-- This is the payment method ID
            //       child: Text(method.name), // Display name
            //     );
            //   }).toList(),
            //   onChanged: (value) {
            //     setState(() {
            //       selectedPaymentMethodId = value; // only store the ID
            //     });

            //     // 👇 Use the ID directly here
            //     print('Selected Payment Method ID: $value');
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:EazySupplies/core/models/userModel.dart';
// import 'package:EazySupplies/core/routes/app_routes.dart';
// import 'package:EazySupplies/core/models/userModel.dart';

// class OrderViewPage extends StatelessWidget {
//   final Order orderData; // Use the Order model directly

//   const OrderViewPage({super.key, required this.orderData});

//   @override
//   Widget build(BuildContext context) {
//     final shipping = orderData.shipping;
//     final payment = orderData.payment;
//     final items = orderData.items;
//     final note = orderData.jsonData?['note'] ?? '';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('order #${orderData.id}'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // orderData Details
//             Text(
//               'order Details',
//               style: Theme.of(context)
//                   .textTheme
//                   .titleLarge
//                   ?.copyWith(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             _buildInfoRow('Status', orderData.status),
//             _buildInfoRow('Created At', orderData.createdAt.toString()),
//             _buildInfoRow(
//                 'Approved', orderData.approved ? 'APPROVED' : 'PENDING'),
//             if (note.isNotEmpty) _buildInfoRow('Note', note),
//             const Divider(height: 32),

//             // Items
//             Text(
//               'Items',
//               style: Theme.of(context)
//                   .textTheme
//                   .titleLarge
//                   ?.copyWith(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             ...items.map((item) {
//               return Card(
//                 margin: const EdgeInsets.symmetric(vertical: 6),
//                 child: ListTile(
//                   title: InkWell(
//                     onTap: () {
//                       Navigator.pushNamed(
//                         context,
//                         AppRoutes.productDetails,
//                         arguments: item.productId, // pass productId
//                       );
//                     },
//                     child: Text(
//                       'Product: ${item.productName}',
//                       style: const TextStyle(color: Colors.blue),
//                     ),
//                   ),
//                   subtitle: Text('Quantity: ${item.quantity}'),
//                   trailing: Text('₹${item.price}'),
//                 ),
//               );
//             }).toList(),
//             const Divider(height: 32),

//             // Shipping
//             Text(
//               'Shipping Info',
//               style: Theme.of(context)
//                   .textTheme
//                   .titleLarge
//                   ?.copyWith(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             _buildInfoRow('Address', shipping?.address ?? ''),
//             _buildInfoRow('City', shipping?.city ?? ''),
//             _buildInfoRow('State', shipping?.state ?? ''),
//             _buildInfoRow('Postal Code', shipping?.postalCode ?? ''),
//             _buildInfoRow('Country', shipping?.country ?? ''),
//             _buildInfoRow('Status', shipping?.status ?? ''),
//             const Divider(height: 32),

//             // Payment
//             Text(
//               'Payment Info',
//               style: Theme.of(context)
//                   .textTheme
//                   .titleLarge
//                   ?.copyWith(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             _buildInfoRow('TransactionId', '${payment?.transactionId ?? ''}'),
//             _buildInfoRow('Amount', '₹${payment?.amount ?? 0}'),
//             _buildInfoRow('Method', payment?.method ?? ''),
//             _buildInfoRow('Status', payment?.status ?? ''),
//             DropdownButton<String>(
//               value: PaymentMethod.values.any((e) => e.id == payment?.method)
//                   ? payment?.method
//                   : null,
//               hint: const Text('Select Payment Method'),
//               items: PaymentMethod.values.map((method) {
//                 return DropdownMenuItem(
//                   value: method.id,
//                   child: Text(method.name),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   payment = payment?.copyWith(method: value);
//                 });
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }
// }

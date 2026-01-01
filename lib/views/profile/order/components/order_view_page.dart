import 'package:flutter/material.dart';
import 'package:grocery/core/routes/app_routes.dart';

class OrderViewPage extends StatelessWidget {
  final dynamic orderData; // can be Map or object

  const OrderViewPage({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    // Treat it as a Map
    final orderMap = Map<String, dynamic>.from(orderData as Map); // cast safely
    final shipping = orderMap['shipping'] ?? {};
    final payment = orderMap['payment'] ?? {};
    final items = List<Map<String, dynamic>>.from(orderMap['items'] ?? []);
    final note = orderMap['jsonData']?['note'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${orderMap['id']}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Details',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Status', orderMap['status'] ?? ''),
            _buildInfoRow('Created At', orderMap['createdAt'] ?? ''),
            _buildInfoRow('Approved',
                (orderMap['approved'] ?? false) ? 'APPROVED' : 'PENDING'),
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
                      // Navigate to product details page
                      Navigator.pushNamed(
                        context,
                        AppRoutes.productDetails, // your route name
                        arguments: item['productId'], // pass product id
                      );
                    },
                    child: Text(
                      'Product: ${item['productName'] ?? ''}',
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  subtitle: Text('Quantity: ${item['quantity']}'),
                  trailing: Text('₹${item['price']}'),
                ),
              );
            }).toList(),

            const Divider(height: 32),

            // Shipping
            Text(
              'Shipping Info',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Address', shipping['address'] ?? ''),
            _buildInfoRow('City', shipping['city'] ?? ''),
            _buildInfoRow('State', shipping['state'] ?? ''),
            _buildInfoRow('Postal Code', shipping['postalCode'] ?? ''),
            _buildInfoRow('Country', shipping['country'] ?? ''),
            _buildInfoRow('Status', shipping['status'] ?? ''),
            const Divider(height: 32),

            // Payment
            Text(
              'Payment Info',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Amount', '₹${payment['amount'] ?? 0}'),
            _buildInfoRow('Method', payment['method'] ?? ''),
            _buildInfoRow('Status', payment['status'] ?? ''),
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
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

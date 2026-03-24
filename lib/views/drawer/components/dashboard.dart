import 'package:EazySupplies/core/utils/responsive.dart';
import 'package:EazySupplies/core/routes/app_routes.dart';
import 'package:flutter/material.dart';

class UserDashboard extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final int totalOrders;

  const UserDashboard({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.totalOrders,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Welcome Section
          Card(
            elevation: 0,
            color: Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $name!',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: Responsive.hp(context, 8 / 8)),

          /// Counter Section
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.shopping_bag,
                          size: 40,
                          color: Colors.green,
                        ),
                        SizedBox(width: Responsive.wp(context, 16 / 4)),
                        InkWell(
                          onTap: () {
                            // Navigate to your desired page
                            Navigator.pushNamed(context, AppRoutes.myOrder);
                          },
                          borderRadius: BorderRadius.circular(
                              8), // optional ripple effect
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                totalOrders.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: Responsive.hp(context, 4 / 8)),
                              const Text(
                                'Total Orders',
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: Responsive.hp(context, 24 / 8)),

          /// Account Information
          _sectionCard(
            context,
            title: 'Account Information',
            children: [
              _infoRow('Full Name', name),
              _infoRow('Phone', phone),
            ],
          ),

          SizedBox(height: Responsive.hp(context, 16 / 8)),

          /// Login Details
          _sectionCard(
            context,
            title: 'Login Details',
            children: [
              _infoRow('Email', email),
            ],
          ),
        ],
      ),
    );
  }

  /// Reusable Card Section
  Widget _sectionCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  /// Info Row
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        '$label : $value',
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}

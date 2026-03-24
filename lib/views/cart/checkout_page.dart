import 'package:flutter/material.dart';
import 'package:EazySupplies/core/constants/apiClients.dart';
import 'package:EazySupplies/core/constants/api_config.dart';
import 'package:EazySupplies/core/constants/cartStorage.dart';
import 'package:EazySupplies/core/models/userModel.dart';
import 'package:EazySupplies/views/cart/components/checkout_address_selector.dart';

import '../../core/components/app_back_button.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/routes/app_routes.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> checkOutList;

  const CheckoutPage({
    super.key,
    required this.checkOutList,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Address? selectedAddress;
  bool isLoading = false;
  void onAddressSelected(Address address) {
    setState(() {
      selectedAddress = address;
    });
  }

  Future<void> placeOrder() async {
    if (selectedAddress == null) return;
    setState(() => isLoading = true);
    try {
      final payload = {
        "userId": 1,
        "status": "PENDING",
        "items": widget.checkOutList,
        "shipping": {
          "address": selectedAddress!.address,
          "city": selectedAddress!.city,
          "state": "KA",
          "postalCode": selectedAddress!.zipcode,
          "country": "IN"
        }
      };
      final response = await ApiClient.dio
          .post(ApiConfig.orders, data: payload)
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse =
            response.data as Map<String, dynamic>;
        CartStorage.clearCart();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order placed successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate after a short delay if you want
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushNamed(context, AppRoutes.orderSuccessfull);
        });
      }
    } catch (e) {
      debugPrint('Place order error: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to place order')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AddressSelector(
              onAddressSelected: onAddressSelected,
            ),
            BillingSummary(
              checkOutList: widget.checkOutList,
            ),
            PayNowButton(
                selectedAddress: selectedAddress,
                placeOrder: () => placeOrder(),
                isLoading: isLoading),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class PayNowButton extends StatelessWidget {
  final Address? selectedAddress;
  final bool isLoading = false;

  ///final VoidCallback placeOrder;
  final Future<void> Function() placeOrder;
  const PayNowButton(
      {super.key,
      required this.selectedAddress,
      required this.placeOrder,
      required isLoading});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(AppDefaults.padding),
        child: ElevatedButton(
          onPressed:
              selectedAddress == null ? null : () async => await placeOrder(),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Place Order'),
        ),
      ),
    );
  }
}

class BillingSummary extends StatelessWidget {
  final List<Map<String, dynamic>> checkOutList;

  const BillingSummary({
    super.key,
    required this.checkOutList,
  });

  double get subTotal {
    return checkOutList.fold(0.0, (sum, item) {
      return sum + (item['price'] * item['quantity']);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double total = subTotal;

    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Billing Summary',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),

          // Items
          ...checkOutList.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item['name']}   x  ${item['quantity']}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text('₹${item['price'] * item['quantity']}'),
                ],
              ),
            );
          }),

          const Divider(height: 24),

          _priceRow(
            'Total',
            total,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:EazySupplies/core/constants/apiCall.dart';
import 'package:EazySupplies/core/constants/apiClients.dart';
import 'package:EazySupplies/core/constants/api_config.dart';
import 'package:EazySupplies/core/constants/app_colors.dart';
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
  User? currentUser;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await getUser();
    if (mounted) {
      setState(() {
        currentUser = user;
      });
    }
  }

  void onAddressSelected(Address address) {
    setState(() {
      selectedAddress = address;
    });
  }

  Future<void> placeOrder() async {
    if (selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery address')),
      );
      return;
    }
    if (currentUser == null || currentUser!.id <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login again to place order')),
      );
      return;
    }
    setState(() => isLoading = true);
    try {
      // 1. Calculate items strictly following the OrderItem model
      final List<Map<String, dynamic>> itemsPayload =
          widget.checkOutList.map((item) {
        final double price = (item['price'] as num).toDouble();
        final int qty = (item['quantity'] as num).toInt();
        final double taxPercent = ((item['tax'] as num?) ?? 0).toDouble();
        final double lineTotal = price * qty;
        final double taxAmt = lineTotal * (taxPercent / 100);

        return {
          "productId": item['productId'] ?? item['id'],
          "quantity": qty,
          "price": price,
          "productName": item['name'],
          "backlogquantity": 0,
          "_discountAmount": 0,
          "taxamt": taxAmt,
          "totalprice": lineTotal + taxAmt,
        };
      }).toList();

      // 2. Build payload strictly following Order and Shipping models
      // NOTE: Some backends require jsonOrderData INSIDE jsonData for invoice generation
      final payload = {
        "userId": currentUser!.id,
        "status": "PENDING",
        "approved": false,
        "items": itemsPayload,
        "jsonOrderData": itemsPayload,
        "jsonData": {
          "note": "Mobile App Order",
          "gstn": currentUser!.gstn ?? "",
          "email": currentUser!.email,
          "name": currentUser!.name,
          "jsonOrderData": itemsPayload, // Redundant copy inside jsonData
        },
        "shipping": {
          "address": selectedAddress!.address,
          "city": selectedAddress!.city,
          "state": "DL",
          "postalCode": selectedAddress!.zipcode,
          "country": "IN",
          "status": "PENDING",
        },
      };

      debugPrint('DEBUG_PAYLOAD: ${jsonEncode(payload)}');

      final response = await ApiClient.dio
          .post(ApiConfig.orders, data: payload)
          .timeout(ApiConfig.timeout);

      debugPrint('DEBUG_RESPONSE: ${response.statusCode} - ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        await CartStorage.clearCart();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Order placed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }

        // Navigate after a short delay if you want
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.myOrder,
              (route) => route.isFirst,
            );
          }
        });
      }
    } on DioException catch (e) {
      debugPrint(
          'DEBUG_ERROR: ${e.response?.statusCode} - ${e.response?.data}');
      final message = e.response?.data is Map
          ? (e.response?.data['error'] ??
                  e.response?.data['message'] ??
                  'Failed to place order')
              .toString()
          : 'Failed to place order';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      debugPrint('DEBUG_ERROR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to place order')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardColor,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Checkout'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            AddressSelector(
              onAddressSelected: onAddressSelected,
            ),
            const SizedBox(height: 16),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: BillingSummary(
                  checkOutList: widget.checkOutList,
                ),
              ),
            ),
            const SizedBox(height: 16),
            PayNowButton(
                selectedAddress: selectedAddress,
                placeOrder: () => placeOrder(),
                isLoading: isLoading),
            const Text(
              'Happy Shopping',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class PayNowButton extends StatelessWidget {
  final Address? selectedAddress;
  final bool isLoading;

  ///final VoidCallback placeOrder;
  final Future<void> Function() placeOrder;
  const PayNowButton({
    super.key,
    required this.selectedAddress,
    required this.placeOrder,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(AppDefaults.padding),
        child: ElevatedButton(
          onPressed: (selectedAddress == null || isLoading)
              ? null
              : () async => await placeOrder(),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
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

  double get taxTotal {
    return checkOutList.fold(0.0, (sum, item) {
      final double price = (item['price'] as num).toDouble();
      final int qty = (item['quantity'] as num).toInt();
      final double taxPercent = ((item['tax'] as num?) ?? 0).toDouble();
      return sum + (price * qty * (taxPercent / 100));
    });
  }

  @override
  Widget build(BuildContext context) {
    final double subtotal = subTotal;
    final double tax = taxTotal;
    final double total = subtotal + tax;

    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Billing Summary',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: 16),

          // Items
          ...checkOutList.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item['name']}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Qty: ${item['quantity']} × ₹${item['price']}',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '₹${((item['price'] as num) * (item['quantity'] as num)).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          }),

          const Divider(height: 32),

          _priceRow('Subtotal', subtotal),
          if (tax > 0) _priceRow('GST/Tax', tax),
          const SizedBox(height: 8),
          _priceRow(
            'Grand Total',
            total,
            isBold: true,
            color: AppColors.primary,
            fontSize: 18,
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, double amount,
      {bool isBold = false, Color? color, double fontSize = 14}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: fontSize,
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}

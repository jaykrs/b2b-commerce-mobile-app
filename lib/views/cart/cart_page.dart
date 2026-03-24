import 'package:flutter/material.dart';
import 'package:EazySupplies/core/constants/apiCall.dart';
import 'package:EazySupplies/core/constants/cartStorage.dart';
import 'package:EazySupplies/core/models/userModel.dart';

import '../../core/components/app_back_button.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/routes/app_routes.dart';
import 'components/items_totals_price.dart';
import 'components/single_cart_item_tile.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key, this.isHomePage = false});

  final bool isHomePage;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;
  List<Map<String, dynamic>> mergedCartItems = [];
  @override
  void initState() {
    super.initState();
    loadCartWithProducts(); // Load merged cart initially
  }

// Updated loadCartWithProducts

  Future<void> loadCartWithProducts() async {
    setState(() => isLoading = true);

    final cart = await CartStorage.getCartItems();
    final products = await getProducts();

    mergedCartItems = cart.map((cartItem) {
      final product = products.firstWhere(
        (p) => p.id.toString() == cartItem['id'],
        orElse: () => Product(
            id: 0,
            name: 'Unknown',
            description: '',
            price: 0,
            stock: 0,
            categoryId: 0,
            brandId: 0,
            tags: '',
            sku: '',
            skuType: '',
            createdAt: '',
            updatedAt: '',
            dimension: '',
            pkgUnit: '',
            tax: 0,
            unitRate: 0,
            supplier: '',
            status: false,
            category: Category.empty(),
            brand: Brand.empty(),
            suppliers: [],
            ordersCount: 0,
            mrp: 0,
            caseRate: 0),
      );

      return {
        'product': product,
        'quantity': cartItem['itemQty'],
      };
    }).toList();

    setState(() => isLoading = false);
  }

// Update quantity
  void onQuantityChanged(String productId, int newQty) async {
    await CartStorage.updateCartQty(productId, newQty);
    loadCartWithProducts(); // reload merged cart after change
  }

// Remove item
  void removeItem(String productId) async {
    await CartStorage.removeFromCart(productId);
    loadCartWithProducts();
  }

// Calculate total price
  double getTotalPrice() {
    return mergedCartItems.fold<double>(
      0,
      (sum, item) {
        final product = item['product'] as Product;
        final qty = item['quantity'] as int;
        return sum + (product.price * qty);
      },
    );
  }

  void AddCheckOut() async {
    List<Map<String, dynamic>> checkOutItem = mergedCartItems.map((item) {
      final product = item['product'] as Product;
      final qty = item['quantity'] as int;

      return {
        'productId': product.id,
        'quantity': qty,
        'price': product.price,
        'name': product.name
      };
    }).toList();

    Navigator.pushNamed(context, AppRoutes.checkoutPage,
        arguments: checkOutItem);
  }

// In build()
  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (mergedCartItems.isEmpty) {
      return const Center(child: Text('Your cart is empty'));
    }

    final totalPrice = getTotalPrice();

    return WillPopScope(
      onWillPop: () async {
        // Always redirect to entryPoint if user presses back
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.entryPoint,
          (route) => false, // remove all previous routes
        );
        return false; // prevent default back action
      },
      child: Scaffold(
        appBar: widget.isHomePage
            ? null
            : AppBar(
                leading: const AppBackButton(),
                title: const Text('Cart Page'),
              ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...mergedCartItems.map((item) {
                  final product = item['product'] as Product;
                  final qty = item['quantity'] as int;

                  return SingleCartItemTile(
                    productId: product.id.toString(),
                    name: product.name,
                    quantity: qty,
                    price: product.price,
                    imageUrl: product.productImage ?? '',
                    onQuantityChanged: onQuantityChanged,
                    onRemove: removeItem,
                  );
                }),
                ItemTotalsAndPrice(totalPrice: totalPrice),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(AppDefaults.padding),
                    child: ElevatedButton(
                      onPressed: AddCheckOut,
                      child: const Text('Checkout'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // return WillPopScope(
    //   onWillPop: () async {
    //     Navigator.pushNamed(context, AppRoutes.entryPoint);
    //     return false;
    //   },
    //   child: Scaffold(
    //     appBar: widget.isHomePage
    //         ? null
    //         : AppBar(
    //             leading: const AppBackButton(), title: const Text('Cart Page')),
    //     body: SafeArea(
    //       child: SingleChildScrollView(
    //         child: Column(
    //           children: [
    //             ...mergedCartItems.map((item) {
    //               final product = item['product'] as Product;
    //               final qty = item['quantity'] as int;

    //               return SingleCartItemTile(
    //                 productId: product.id.toString(),
    //                 name: product.name,
    //                 quantity: qty,
    //                 price: product.price,
    //                 imageUrl: product.productImage ?? '',
    //                 onQuantityChanged: onQuantityChanged,
    //                 onRemove: removeItem,
    //               );
    //             }).toList(),
    //             // const CouponCodeField(),
    //             ItemTotalsAndPrice(totalPrice: totalPrice),
    //             SizedBox(
    //               width: double.infinity,
    //               child: Padding(
    //                 padding: const EdgeInsets.all(AppDefaults.padding),
    //                 child: ElevatedButton(
    //                   onPressed: () => {AddCheckOut()},
    //                   child: const Text('Checkout'),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}

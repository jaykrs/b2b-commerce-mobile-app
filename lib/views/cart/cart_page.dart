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
  String? loadError;
  int unavailableItemCount = 0;
  List<Map<String, dynamic>> mergedCartItems = [];
  @override
  void initState() {
    super.initState();
    loadCartWithProducts(); // Load merged cart initially
  }

// Updated loadCartWithProducts

  Future<void> loadCartWithProducts() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      loadError = null;
    });

    final cart = await CartStorage.getCartItems();
    if (cart.isEmpty) {
      if (!mounted) return;
      setState(() {
        cartItems = [];
        mergedCartItems = [];
        unavailableItemCount = 0;
        isLoading = false;
      });
      return;
    }

    try {
      final productIds = cart
          .map((item) => int.tryParse(item['id']?.toString() ?? ''))
          .whereType<int>();
      final products = await getProducts(
        ids: productIds,
        rethrowErrors: true,
      );
      final productsById = {
        for (final product in products) product.id: product
      };
      final hydratedItems = [
        for (final cartItem in cart)
          if (productsById[int.tryParse(cartItem['id']?.toString() ?? '')]
              case final product?)
            {
              'product': product,
              'quantity': (cartItem['itemQty'] as num?)?.toInt() ?? 1,
            },
      ];

      if (!mounted) return;
      setState(() {
        cartItems = cart;
        mergedCartItems = hydratedItems;
        unavailableItemCount = cart.length - hydratedItems.length;
        isLoading = false;
      });
    } catch (error) {
      debugPrint('Cart product refresh failed: $error');
      if (!mounted) return;
      setState(() {
        cartItems = cart;
        loadError =
            'We could not refresh your cart right now. Your saved items are safe.';
        isLoading = false;
      });
    }
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

  // ignore: non_constant_identifier_names
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
    if (loadError != null && mergedCartItems.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDefaults.padding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(loadError!, textAlign: TextAlign.center),
              const SizedBox(height: AppDefaults.padding),
              ElevatedButton(
                onPressed: loadCartWithProducts,
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }
    if (mergedCartItems.isEmpty) {
      return Center(
        child: Text(
          cartItems.isEmpty
              ? 'Your cart is empty'
              : 'The saved items in your cart are no longer available.',
          textAlign: TextAlign.center,
        ),
      );
    }

    final totalPrice = getTotalPrice();

    // ignore: deprecated_member_use
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
                const Text('Product Cart'),
                if (unavailableItemCount > 0)
                  Padding(
                    padding: const EdgeInsets.all(AppDefaults.padding),
                    child: Text(
                      '$unavailableItemCount saved cart item(s) are currently unavailable.',
                      textAlign: TextAlign.center,
                    ),
                  ),
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

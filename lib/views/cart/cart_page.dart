import 'package:flutter/material.dart';
import 'package:grocery/core/constants/cartStorage.dart';
import 'package:grocery/core/constants/get_bundels.dart';
import 'package:grocery/core/models/dummy_bundle_model.dart';

import '../../core/components/app_back_button.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/routes/app_routes.dart';
import 'components/coupon_code_field.dart';
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
    final products = await getBundles();

    mergedCartItems = cart.map((cartItem) {
      final product = products.firstWhere(
        (p) => p.id.toString() == cartItem['id'],
        orElse: () => BundleModel(
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
        ),
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
        final product = item['product'] as BundleModel;
        final qty = item['quantity'] as int;
        return sum + (product.price * qty);
      },
    );
  }

// In build()
  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (mergedCartItems.isEmpty)
      return const Center(child: Text('Your cart is empty'));

    final totalPrice = getTotalPrice();

    return Scaffold(
      appBar: widget.isHomePage
          ? null
          : AppBar(
              leading: const AppBackButton(), title: const Text('Cart Page')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ...mergedCartItems.map((item) {
                final product = item['product'] as BundleModel;
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
              }).toList(),
              // const CouponCodeField(),
              ItemTotalsAndPrice(totalPrice: totalPrice),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(AppDefaults.padding),
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.checkoutPage),
                    child: const Text('Checkout'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


//   @override
//   void initState() {
//     super.initState();
//     loadCart();
//   }

//   Future<void> loadCart() async {
//     final items = await CartStorage.getCartItems();
//     setState(() {
//       cartItems = items;
//       isLoading = false;
//     });
//   }


// Future<void> loadCartWithProducts() async {
//     setState(() => isLoading = true);

//     final cart = await CartStorage.getCartItems();
//     final products = await getBundles();

//     mergedCartItems = cart.map((cartItem) {
//       final product = products.firstWhere(
//         (p) => p.id.toString() == cartItem['id'],
//         orElse: () => BundleModel(
//           id: 0,
//           name: 'Unknown',
//           description: '',
//           price: 0,
//           stock: 0,
//           categoryId: 0,
//           brandId: 0,
//           tags: '',
//           sku: '',
//           skuType: '',
//           createdAt: '',
//           updatedAt: '',
//           dimension: '',
//           pkgUnit: '',
//           tax: 0,
//           unitRate: 0,
//           supplier: '',
//           status: false,
//           category: Category.empty(),
//           brand: Brand.empty(),
//           suppliers: [],
//         ),
//       );

//       return {
//         'product': product,
//         'quantity': cartItem['itemQty'],
//       };
//     }).toList();

//     setState(() => isLoading = false);
//   }

//    double getTotalPrice() {
//     double total = 0;
//     for (var item in mergedCartItems) {
//       final product = item['product'] as BundleModel;
//       final qty = item['quantity'] as int;
//       total += product.price * qty;
//     }
//     return total;
//   }

//   void onQuantityChanged(String productId, int newQty) async {
//     await CartStorage.updateCartQty(productId, newQty);
//     loadCart(); // reload cart to reflect changes
//   }

//   void removeItem(String productId) async {
//     await CartStorage.removeFromCart(productId);
//     loadCart();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (cartItems.isEmpty) {
//       return const Center(child: Text('Your cart is empty'));
//     }

//     final totalPrice = cartItems.fold<double>(
//       0,
//       (sum, item) => sum + ((item['price'] ?? 0) * (item['itemQty'] ?? 0)),
//     );

//     return Scaffold(
//       appBar: widget.isHomePage
//           ? null
//           : AppBar(
//               leading: const AppBackButton(),
//               title: const Text('Cart Page'),
//             ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               ...cartItems.map((item) => SingleCartItemTile(
//                     productId: item['id'],
//                     name: item['name'] ?? 'Product',
//                     quantity: item['itemQty'] ?? 1,
//                     price: item['price']?.toDouble() ?? 0,
//                     imageUrl: item['imageUrl'] ?? '',
//                     onQuantityChanged: onQuantityChanged,
//                     onRemove: removeItem,
//                   )),
//               const CouponCodeField(),
//               ItemTotalsAndPrice(totalPrice: totalPrice),
//               SizedBox(
//                 width: double.infinity,
//                 child: Padding(
//                   padding: const EdgeInsets.all(AppDefaults.padding),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.pushNamed(context, AppRoutes.checkoutPage);
//                     },
//                     child: const Text('Checkout'),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

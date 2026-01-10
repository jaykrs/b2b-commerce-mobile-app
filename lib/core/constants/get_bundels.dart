// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:EazySupplies/core/constants/api_config.dart';
// import 'package:EazySupplies/core/constants/localStorageService.dart';
// import 'package:EazySupplies/core/models/userModel.dart';
// import 'package:http/http.dart' as http;

// Future<List<Product>> getBundles() async {
//   // ✅ STEP 1: Load from local storage first
//   // final localBundles = await LocalStorageService.loadBundles();
//   // if (localBundles.isNotEmpty) {
//   //   debugPrint('Loaded bundles from local storage');
//   //   return localBundles;
//   // }

//   // ✅ STEP 2: If no local data → call API
//   try {
//     final response = await http
//         .get(
//           Uri.parse(ApiConfig.products),
//         )
//         .timeout(ApiConfig.timeout);

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
//       final List<dynamic> data = jsonResponse['data'];

//       final bundles = data.map((e) => Product.fromJson(e)).toList();

//       // ✅ STEP 3: Save API data locally
//       //    await LocalStorageService.saveBundles(bundles);

//       debugPrint('Loaded bundles from API');
//       return bundles;
//     } else {
//       return [];
//     }
//   } catch (e) {
//     debugPrint('API error: $e');
//     return [];
//   }
// }

// Future<List<Category>> getCategories() async {
//   // 1️⃣ Load local first
//   try {
//     final response = await http
//         .get(Uri.parse(ApiConfig.categories))
//         .timeout(ApiConfig.timeout);
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
//       final List<dynamic> data = jsonResponse['data'];
//       final categories = data.map((e) => Category.fromJson(e)).toList();

//       // 3️⃣ Save locally
//       //await LocalStorageService.saveCategories(categories);

//       return categories;
//     }
//   } catch (e) {
//     debugPrint('Category API error: $e');
//   }

//   return [];
// }

// Future<List<TagModel>> getProductListBasedOnTags() async {
//   try {
//     final response = await http
//         .get(Uri.parse(ApiConfig.tagTogetProduct))
//         .timeout(ApiConfig.timeout);
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonResponse =
//           jsonDecode(response.body) as Map<String, dynamic>;

//       final List<dynamic> data = jsonResponse['data'];

//       final List<TagModel> tags =
//           data.map((e) => TagModel.fromJson(e)).toList();

//       // Save locally (optional)
//       // await LocalStorageService.saveTags(tags);

//       return tags;
//     }
//   } catch (e) {
//     debugPrint('Tag API error: $e');
//   }

//   return [];
// }

// Future<List<Brand>> getBrands() async {
//   try {
//     final response =
//         await http.get(Uri.parse(ApiConfig.brands)).timeout(ApiConfig.timeout);
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
//       final List<dynamic> data = jsonResponse['data'];
//       final brands = data.map((e) => Brand.fromJson(e)).toList();
//       return brands;
//     }
//   } catch (e) {
//     debugPrint('Brand API error: $e');
//   }
//   return []; // return empty List<Brand> if error
// }

// Future<List<Address>> getAddress() async {
//   try {
//     final response = await http
//         .get(Uri.parse(ApiConfig.address))
//         .timeout(ApiConfig.timeout);

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonResponse =
//           jsonDecode(response.body) as Map<String, dynamic>;

//       final List<dynamic> data = jsonResponse['data'];

//       final List<Address> address =
//           data.map<Address>((e) => Address.fromJson(e)).toList();

//       return address;
//     }
//   } catch (e) {
//     debugPrint('Address API error: $e');
//   }

//   return <Address>[]; // empty list of Address
// }

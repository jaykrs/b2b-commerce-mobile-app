
// class Product {
//   final int id;
//   final String name;
//   final String description;
//   final double price;
//   final int stock;
//   final int categoryId;
//   final int brandId;
//   final String tags;
//   final String sku;
//   final String skuType;
//   final String? selfLife;
//   final String? mfDate;
//   final String? expDate;
//   final String createdAt;
//   final String updatedAt;
//   final String? productIcon;
//   final String? productImage;
//   final String? createdBy;
//   final String dimension;
//   final String? keyword;
//   final int? ordersCount;
//   final int tax;
//   final String? pkgGwt;
//   final String pkgUnit;
//   final double? mrp;
//   final double? caseRate;
//   final double unitRate;
//   final String supplier;
//   final bool status;
//   final dynamic jsonData;
//   final Category category;
//   final Brand brand;
//   final List<Supplier> suppliers;

//   Product({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.stock,
//     required this.categoryId,
//     required this.brandId,
//     required this.tags,
//     required this.sku,
//     required this.skuType,
//     this.selfLife,
//     this.mfDate,
//     this.expDate,
//     required this.createdAt,
//     required this.updatedAt,
//     this.productIcon,
//     this.productImage,
//     this.createdBy,
//     required this.dimension,
//     this.keyword,
//     this.ordersCount,
//     required this.tax,
//     this.pkgGwt,
//     required this.pkgUnit,
//     this.mrp,
//     this.caseRate,
//     required this.unitRate,
//     required this.supplier,
//     required this.status,
//     this.jsonData,
//     required this.category,
//     required this.brand,
//     required this.suppliers,
//   });

//   /// ---------------- FROM JSON ----------------
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? '',
//       description: json['description'] ?? '',
//       price: (json['price'] as num?)?.toDouble() ?? 0.0,
//       stock: json['stock'] ?? 0,
//       categoryId: json['categoryId'] ?? 0,
//       brandId: json['brandId'] ?? 0,
//       tags: json['tags']?.toString() ?? '',
//       sku: json['sku']?.toString() ?? '',
//       skuType: json['skuType']?.toString() ?? '',
//       selfLife: json['selfLife']?.toString(),
//       mfDate: json['mfDate']?.toString(),
//       expDate: json['expDate']?.toString(),
//       createdAt: json['createdAt'] ?? '',
//       updatedAt: json['updatedAt'] ?? '',
//       productIcon: json['productIcon']?.toString(),
//       productImage: json['productImage']?.toString(),
//       createdBy: json['createdBy']?.toString(),
//       dimension: json['dimension'] ?? '',
//       keyword: json['keyword']?.toString(),
//       ordersCount: json['ordersCount'],
//       tax: json['tax'] ?? 0,
//       pkgGwt: json['pkgGwt']?.toString(),
//       pkgUnit: json['pkgUnit']?.toString() ?? '',
//       mrp: (json['mrp'] as num?)?.toDouble(),
//       caseRate: (json['caseRate'] as num?)?.toDouble(),
//       unitRate: (json['unitRate'] as num?)?.toDouble() ?? 0.0,
//       supplier: json['supplier']?.toString() ?? '',
//       status: json['status'] is bool ? json['status'] : json['status'] == 1,
//       jsonData: json['jsonData'],
//       category: json['category'] != null
//           ? Category.fromJson(json['category'])
//           : Category.empty(),
//       brand:
//           json['brand'] != null ? Brand.fromJson(json['brand']) : Brand.empty(),
//       suppliers: (json['suppliers'] as List<dynamic>?)
//               ?.map((e) => Supplier.fromJson(e))
//               .toList() ??
//           [],
//     );
//   }

//   /// ---------------- TO JSON ----------------
//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name,
//         'description': description,
//         'price': price,
//         'stock': stock,
//         'categoryId': categoryId,
//         'brandId': brandId,
//         'tags': tags,
//         'sku': sku,
//         'skuType': skuType,
//         'selfLife': selfLife,
//         'mfDate': mfDate,
//         'expDate': expDate,
//         'createdAt': createdAt,
//         'updatedAt': updatedAt,
//         'productIcon': productIcon,
//         'productImage': productImage,
//         'createdBy': createdBy,
//         'dimension': dimension,
//         'keyword': keyword,
//         'ordersCount': ordersCount,
//         'tax': tax,
//         'pkgGwt': pkgGwt,
//         'pkgUnit': pkgUnit,
//         'mrp': mrp,
//         'caseRate': caseRate,
//         'unitRate': unitRate,
//         'supplier': supplier,
//         'status': status,
//         'jsonData': jsonData,
//         'category': category.toJson(),
//         'brand': brand.toJson(),
//         'suppliers': suppliers.map((e) => e.toJson()).toList(),
//       };
// }

// class Category {
//   final int id;
//   final String name;
//   final String slug;
//   final String createdAt;
//   final String updatedAt;

//   Category({
//     required this.id,
//     required this.name,
//     required this.slug,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory Category.fromJson(Map<String, dynamic> json) {
//     return Category(
//       id: json['id'] as int,
//       name: json['name'] as String,
//       slug: json['slug'] as String,
//       createdAt: json['createdAt'] as String,
//       updatedAt: json['updatedAt'] as String,
//     );
//   }
//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name,
//         'slug': slug,
//         'createdAt': createdAt,
//         'updatedAt': updatedAt,
//       };

//   static empty() {}
// }

// class Brand {
//   final int id;
//   final String name;
//   final String slug;
//   final String createdAt;
//   final String updatedAt;

//   Brand({
//     required this.id,
//     required this.name,
//     required this.slug,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory Brand.fromJson(Map<String, dynamic> json) {
//     return Brand(
//       id: json['id'] as int,
//       name: json['name'] as String,
//       slug: json['slug'] as String,
//       createdAt: json['createdAt'] as String,
//       updatedAt: json['updatedAt'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name,
//         'slug': slug,
//         'createdAt': createdAt,
//         'updatedAt': updatedAt,
//       };

//   static empty() {}
// }

// class Supplier {
//   final int id;
//   final String name;
//   final String description;
//   final dynamic productList;
//   final String gstIn;
//   final String address;
//   final String pinCode;
//   final String city;
//   final String phone;
//   final String remarks;

//   Supplier({
//     required this.id,
//     required this.name,
//     required this.description,
//     this.productList,
//     required this.gstIn,
//     required this.address,
//     required this.pinCode,
//     required this.city,
//     required this.phone,
//     required this.remarks,
//   });

//   factory Supplier.fromJson(Map<String, dynamic> json) {
//     return Supplier(
//       id: json['id'] as int,
//       name: json['name'] as String,
//       description: json['description'] as String,
//       productList: json['productList'],
//       gstIn: json['gstIn'] as String,
//       address: json['address'] as String,
//       pinCode: json['pinCode'] as String,
//       city: json['city'] as String,
//       phone: json['phone'] as String,
//       remarks: json['remarks'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name,
//         'description': description,
//         'productList': productList,
//         'gstIn': gstIn,
//         'address': address,
//         'pinCode': pinCode,
//         'city': city,
//         'phone': phone,
//         'remarks': remarks,
//       };
// }

// class TagModel {
//   final int id;
//   final String name;
//   final String slug;
//   final String description;
//   final String createdAt;
//   final String updatedAt;
//   final List<Product> product;

//   TagModel({
//     required this.id,
//     required this.name,
//     required this.slug,
//     required this.description,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.product
//   });

//   /// ---------------- FROM JSON ----------------
//   factory TagModel.fromJson(Map<String, dynamic> json) {
//     return TagModel(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? '',
//       slug: json['slug'] ?? '',
//       description: json['description'] ?? '',
//       createdAt: json['createdAt']?.toString() ?? '',
//       updatedAt: json['updatedAt']?.toString() ?? '',
//       product: (json['product'] as List<dynamic>?)
//               ?.map((e) => Product.fromJson(e))
//               .toList() ??
//           []
//     );
//   }
//   /// ---------------- TO JSON ----------------
//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name,
//         'slug': slug,
//         'description': description,
//         'createdAt': createdAt,
//         'updatedAt': updatedAt,
//         'product': product.map((e)=> e.toJson()).toList()
//       };

//   /// ---------------- EMPTY (Optional) ----------------
//   factory TagModel.empty() => TagModel(
//         id: 0,
//         name: '',
//         slug: '',
//         description: '',
//         createdAt: '',
//         updatedAt: '',
//         product: []
//       );
// }

// class Address {
//   final int id;
//   final int userId;
//   final String name;
//   final String zipcode;
//   final String city;
//   final String address;
//   final String createdAt;
//   final String? updatedAt;

//   Address({
//     required this.id,
//     required this.userId,
//     required this.name,
//     required this.zipcode,
//     required this.city,
//     required this.address,
//     required this.createdAt,
//     this.updatedAt,
//   });

//   factory Address.fromJson(Map<String, dynamic> json) {
//     return Address(
//       id: json['id'] as int,
//       userId: json['userId'] as int,
//       name: json['name'] as String,
//       zipcode: json['zipcode'] as String,
//       city: json['city'] as String,
//       address: json['address'] as String,
//       createdAt: json['createdAt'] as String,
//       updatedAt: json['updatedAt'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'userId': userId,
//         'name': name,
//         'zipcode': zipcode,
//         'city': city,
//         'address': address,
//         'createdAt': createdAt,
//         'updatedAt': updatedAt,
//       };

//   static Address empty() {
//     return Address(
//       id: 0,
//       userId: 0,
//       name: '',
//       zipcode: '',
//       city: '',
//       address: '',
//       createdAt: '',
//       updatedAt: null,
//     );
//   }
// }

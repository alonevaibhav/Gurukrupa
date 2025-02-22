//
//
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import '../Constants/api_con.dart';
//
// class Product {
//   final int id;
//   final String name;
//   final String unit;
//
//   Product({
//     required this.id,
//     required this.name,
//     required this.unit,
//   });
// }
//
// class ProductController extends GetxController {
//   var products = <Product>[].obs;
//   var currentPage = 1.obs;
//   var itemsPerPage = 7.obs;
//   var totalPages = 1.obs;
//
//   // Mapping from UI int id to backend's actual String _id.
//   final Map<int, String> _backendIdMapping = {};
//
//   // Available units for dropdown
//   final List<String> availableUnits = ['Kg', 'Gram', 'Liters', 'nos'].obs;
//
//   // Text editing controllers
//   final productNameController = TextEditingController();
//   var selectedUnit = ''.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     selectedUnit.value = availableUnits[0]; // Default unit
//     loadProducts();
//   }
//
//   @override
//   void onClose() {
//     productNameController.dispose();
//     super.onClose();
//   }
//
//   Future<void> loadProducts() async {
//     final url = Uri.parse(baseUrl + getProduct);
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         print(response.body);
//         print(response.statusCode);
//
//         final List<dynamic> productData = jsonDecode(response.body);
//         _backendIdMapping.clear();
//
//         products.value = productData.map((json) {
//           final String backendId = json['_id'];
//           final int uiId = backendId.hashCode;
//           _backendIdMapping[uiId] = backendId;
//           print("Products loaded successfully");
//           print("_backendIdMapping: $_backendIdMapping");
//
//           return Product(
//             id: uiId,
//             name: json['name'] ?? 'Unknown', // Ensure name is not null
//             unit: json['unit']?.toString() ?? 'N/A', // Fix null unit issue
//           );
//         }).toList();
//
//         calculateTotalPages();
//       } else {
//         Get.snackbar('Error', 'Failed to load products', snackPosition: SnackPosition.BOTTOM);
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Something went wrong: $e', snackPosition: SnackPosition.BOTTOM);
//     }
//   }
//
//
//   Future<void> postProduct() async {
//     if (productNameController.text.trim().isEmpty) {
//       Get.snackbar('Error', 'Please enter product name', snackPosition: SnackPosition.BOTTOM);
//       return;
//     }
//
//     final newProduct = {
//       "name": productNameController.text.trim(),
//       "unit": selectedUnit.value,
//     };
//
//     final url = Uri.parse(baseUrl + registerProduct);
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(newProduct),
//       );
//
//       if (response.statusCode == 201 || response.statusCode == 200) {
//         Get.snackbar('Success', 'Product added successfully', snackPosition: SnackPosition.BOTTOM);
//         productNameController.clear();
//         selectedUnit.value = availableUnits[0];
//         loadProducts();
//       } else {
//         Get.snackbar('Error', 'Failed to add product: ${response.body}', snackPosition: SnackPosition.BOTTOM);
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Something went wrong: $e', snackPosition: SnackPosition.BOTTOM);
//     }
//   }
//
//   Future<void> updateProductAPI(Product product) async {
//     final String? backendId = _backendIdMapping[product.id];
//     if (backendId == null) {
//       Get.snackbar('Error', 'Backend ID not found for product', snackPosition: SnackPosition.BOTTOM);
//       return;
//     }
//
//     final updatedProduct = {
//       "id": backendId,
//       "name": productNameController.text.trim(),
//       "unit": selectedUnit.value,
//     };
//
//     final url = Uri.parse(baseUrl + updateProduct);
//
//     try {
//       final response = await http.put(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(updatedProduct),
//       );
//
//       if (response.statusCode == 200) {
//         Get.snackbar('Success', 'Product updated successfully', snackPosition: SnackPosition.BOTTOM);
//         productNameController.clear();
//         selectedUnit.value = availableUnits[0];
//         loadProducts();
//       } else {
//         Get.snackbar('Error', 'Failed to update product: ${response.body}', snackPosition: SnackPosition.BOTTOM);
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Something went wrong: $e', snackPosition: SnackPosition.BOTTOM);
//     }
//   }
//
//   Future<void> deleteProductAPI(Product product) async {
//     final String? backendId = _backendIdMapping[product.id];
//     if (backendId == null) {
//       Get.snackbar('Error', 'Backend ID not found for product', snackPosition: SnackPosition.BOTTOM);
//       return;
//     }
//
//     final deletePayload = {
//       "id": backendId,
//     };
//
//     final url = Uri.parse(baseUrl + deleteProduct);
//
//     try {
//       final response = await http.delete(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(deletePayload),
//       );
//
//       if (response.statusCode == 200) {
//         Get.snackbar('Success', 'Product deleted successfully', snackPosition: SnackPosition.BOTTOM);
//         loadProducts();
//       } else {
//         Get.snackbar('Error', 'Failed to delete product: ${response.body}', snackPosition: SnackPosition.BOTTOM);
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Something went wrong: $e', snackPosition: SnackPosition.BOTTOM);
//     }
//   }
//
//   void calculateTotalPages() {
//     totalPages.value = (products.length / itemsPerPage.value).ceil();
//   }
//
//   List<Product> get paginatedProducts {
//     final startIndex = (currentPage.value - 1) * itemsPerPage.value;
//     final endIndex = startIndex + itemsPerPage.value;
//     if (startIndex >= products.length) return [];
//     return products.sublist(startIndex, endIndex > products.length ? products.length : endIndex);
//   }
//
//   void nextPage() {
//     if (currentPage.value < totalPages.value) {
//       currentPage.value++;
//     }
//   }
//
//   void previousPage() {
//     if (currentPage.value > 1) {
//       currentPage.value--;
//     }
//   }
// }


import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Constants/api_con.dart';

class Product {
  final String id; // Use the actual backend id as a String
  final String name;
  final String unit;

  Product({
    required this.id,
    required this.name,
    required this.unit,
  });
}

class ProductController extends GetxController {
  var products = <Product>[].obs;
  var currentPage = 1.obs;
  var itemsPerPage = 7.obs;
  var totalPages = 1.obs;

  // Available units for dropdown
  final List<String> availableUnits = ['Kg', 'Gram', 'Liters', 'nos'];

  // Text editing controllers
  final productNameController = TextEditingController();
  var selectedUnit = ''.obs;

  @override
  void onInit() {
    super.onInit();
    selectedUnit.value = availableUnits[0]; // Default unit
    loadProducts();
  }

  @override
  void onClose() {
    productNameController.dispose();
    super.onClose();
  }

  Future<void> loadProducts() async {
    final url = Uri.parse(baseUrl + getProduct);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        print(response.statusCode);

        final List<dynamic> productData = jsonDecode(response.body);

        products.value = productData.map((json) {
          final String backendId = json['_id']; // Use backend id directly
          print("Products loaded successfully with id: $backendId");

          return Product(
            id: backendId,
            name: json['name'] ?? 'Unknown',
            unit: json['unit']?.toString() ?? 'N/A',
          );
        }).toList();

        calculateTotalPages();
      } else {
        Get.snackbar(
          'Error',
          'Failed to load products',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> postProduct() async {
    if (productNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter product name',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final newProduct = {
      "name": productNameController.text.trim(),
      "unit": selectedUnit.value,
    };

    final url = Uri.parse(baseUrl + registerProduct);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(newProduct),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Product added successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        productNameController.clear();
        selectedUnit.value = availableUnits[0];
        loadProducts();
      } else {
        Get.snackbar(
          'Error',
          'Failed to add product: ${response.body}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateProductAPI(Product product) async {
    final updatedProduct = {
      "id": product.id, // Directly using the backend id
      "name": productNameController.text.trim(),
      "unit": selectedUnit.value,
    };

    final url = Uri.parse(baseUrl + updateProduct);

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedProduct),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Product updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        productNameController.clear();
        selectedUnit.value = availableUnits[0];
        loadProducts();
      } else {
        Get.snackbar(
          'Error',
          'Failed to update product: ${response.body}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteProductAPI(Product product) async {
    final deletePayload = {
      "id": product.id, // Directly using the backend id
    };

    final url = Uri.parse(baseUrl + deleteProduct);

    try {
      final response = await http.delete(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(deletePayload),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Product deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        loadProducts();
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete product: ${response.body}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void calculateTotalPages() {
    totalPages.value = (products.length / itemsPerPage.value).ceil();
  }

  List<Product> get paginatedProducts {
    final startIndex = (currentPage.value - 1) * itemsPerPage.value;
    final endIndex = startIndex + itemsPerPage.value;
    if (startIndex >= products.length) return [];
    return products.sublist(
      startIndex,
      endIndex > products.length ? products.length : endIndex,
    );
  }

  void nextPage() {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
    }
  }
}

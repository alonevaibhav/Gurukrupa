//
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import '../Constants/api_con.dart';
//
// class CustomerOrderItem {
//   final int id; // UI ID (hash of backend ID)
//   final int customerId; // UI customer ID
//   final String customerName;
//   final int productId; // UI product ID
//   final String productName;
//   final int quantity;
//   final double amount;
//
//   CustomerOrderItem({
//     required this.id,
//     required this.customerId,
//     required this.customerName,
//     required this.productId,
//     required this.productName,
//     required this.quantity,
//     required this.amount,
//   });
// }
//
// class CustomerOrderController extends GetxController {
//   var orderItems = <CustomerOrderItem>[].obs;
//   final Map<int, String> _backendIdMapping = {}; // Maps UI IDs to backend ObjectIds
//
//   // Load orders from the backend
//   Future<void> loadOrders() async {
//     final url = Uri.parse(baseUrl + getOrderCustomer);
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final List<dynamic> orderData = jsonDecode(response.body);
//         _backendIdMapping.clear(); // Clear the mapping on every load
//         orderItems.value = orderData.map((json) {
//           final String backendId = json['_id']; // Backend ObjectId
//           final int uiId = backendId.hashCode; // Generate UI ID
//           _backendIdMapping[uiId] = backendId; // Save the mapping
//
//           return CustomerOrderItem(
//             id: uiId,
//             customerId: json['customer']['_id'].hashCode, // UI customer ID
//             customerName: json['customer']['name'],
//             productId: json['product']['_id'].hashCode, // UI product ID
//             productName: json['product']['name'],
//             quantity: json['quantity'],
//             amount: json['amount'].toDouble(),
//           );
//         }).toList();
//       } else {
//         Get.snackbar('Error', 'Failed to load orders');
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Something went wrong: $e');
//     }
//   }
//   Future<void> postOrder(int customerId, int productId, int quantity, double amount) async {
//     print("Inside postOrder method");
//
//     // Get MongoDB ObjectIds from the mapping
//     final String? customerObjectId = _backendIdMapping[customerId];
//     final String? productObjectId = _backendIdMapping[productId];
//
//     // Check if mappings exist
//     if (customerObjectId == null || productObjectId == null) {
//       print("Error: Invalid customer or product ID");
//       print("Customer ID: $customerId, Mapped ObjectId: $customerObjectId");
//       print("Product ID: $productId, Mapped ObjectId: $productObjectId");
//       Get.snackbar('Error', 'Invalid customer or product ID');
//       return;
//     }
//
//     // Prepare the payload
//     final newOrder = {
//       "customer": customerObjectId, // Use MongoDB ObjectId
//       "product": productObjectId, // Use MongoDB ObjectId
//       "quantity": quantity,
//       "amount": amount,
//     };
//
//     print("Request Payload: $newOrder");
//
//     // Send the request
//     final url = Uri.parse(baseUrl + registerOrderCustomer);
//     print("API URL: $url");
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(newOrder),
//       );
//
//       print("API Response Status Code: ${response.statusCode}");
//       print("API Response Body: ${response.body}");
//
//       if (response.statusCode == 201 || response.statusCode == 200) {
//         Get.snackbar('Success', 'Order added successfully');
//         loadOrders(); // Refresh the list
//       } else {
//         Get.snackbar('Error', 'Failed to add order: ${response.body}');
//       }
//     } catch (e) {
//       print("Error occurred: $e");
//       Get.snackbar('Error', 'Something went wrong: $e');
//     }
//   }
//
//   // Update an existing order
//   Future<void> updateOrder(CustomerOrderItem order) async {
//     // Get MongoDB ObjectId from the mapping
//     final String? backendId = _backendIdMapping[order.id];
//
//     if (backendId == null) {
//       Get.snackbar('Error', 'Backend ID not found');
//       return;
//     }
//
//     // Prepare the payload
//     final updatedOrder = {
//       "id": backendId, // Use MongoDB ObjectId
//       "product": _backendIdMapping[order.productId], // Use MongoDB ObjectId
//       "customer": _backendIdMapping[order.customerId], // Use MongoDB ObjectId
//       "quantity": order.quantity,
//       "amount": order.amount,
//     };
//
//     // Send the request
//     final url = Uri.parse(baseUrl + updateOrderCustomer);
//     try {
//       final response = await http.put(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(updatedOrder),
//       );
//
//       if (response.statusCode == 200) {
//         Get.snackbar('Success', 'Order updated successfully');
//         loadOrders(); // Refresh the list
//       } else {
//         Get.snackbar('Error', 'Failed to update order: ${response.body}');
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Something went wrong: $e');
//     }
//   }
//
//   // Delete an order
//   Future<void> deleteOrder(CustomerOrderItem order) async {
//     // Get MongoDB ObjectId from the mapping
//     final String? backendId = _backendIdMapping[order.id];
//
//     if (backendId == null) {
//       Get.snackbar('Error', 'Backend ID not found');
//       return;
//     }
//
//     // Prepare the payload
//     final deletePayload = {"id": backendId}; // Use MongoDB ObjectId
//
//     // Send the request
//     final url = Uri.parse(baseUrl + deleteOrderCustomer);
//     try {
//       final response = await http.delete(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(deletePayload),
//       );
//
//       if (response.statusCode == 200) {
//         Get.snackbar('Success', 'Order deleted successfully');
//         loadOrders(); // Refresh the list
//       } else {
//         Get.snackbar('Error', 'Failed to delete order: ${response.body}');
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Something went wrong: $e');
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Constants/api_con.dart';

class CustomerOrderItem {
  final String id; // Backend order ID
  final String customerId; // Actual backend customer ID
  final String customerName;
  final String productId; // Actual backend product ID
  final String productName;
  final int quantity;
  final double amount;

  CustomerOrderItem({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.amount,
  });
}

class CustomerOrderController extends GetxController {
  var orderItems = <CustomerOrderItem>[].obs;

  Future<void> loadOrders() async {
    final url = Uri.parse(baseUrl + getOrderCustomer);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> orderData = jsonDecode(response.body);

        orderItems.value = orderData.map((json) {
          // The order's own _id
          final String orderId = (json['_id'] ?? '').toString();

          // customer might be an object { "_id": "...", "name": "..." }
          // or just a string "67b474ac53fd7c3c10664af2"
          final dynamic customerData = json['customer'];
          String customerId;
          String customerName;

          if (customerData is Map<String, dynamic>) {
            customerId = (customerData['_id'] ?? '').toString();
            customerName = (customerData['name'] ?? 'Unknown').toString();
          } else {
            // If it's just a string or null
            customerId = customerData?.toString() ?? '';
            customerName = 'Unknown';
          }

          // product might be an object { "_id": "...", "name": "..." }
          // or just a string "67b6fb9cfa72f087b979987b"
          final dynamic productData = json['product'];
          String productId;
          String productName;

          if (productData is Map<String, dynamic>) {
            productId = (productData['_id'] ?? '').toString();
            productName = (productData['name'] ?? 'Unknown').toString();
          } else {
            // If it's just a string or null
            productId = productData?.toString() ?? '';
            productName = 'Unknown';
          }

          // Safely parse quantity and amount
          final int quantity = (json['quantity'] ?? 0) as int;
          final double amount =
          (json['amount'] is num) ? (json['amount'] as num).toDouble() : 0.0;

          return CustomerOrderItem(
            id: orderId,
            customerId: customerId,
            customerName: customerName,
            productId: productId,
            productName: productName,
            quantity: quantity,
            amount: amount,
          );
        }).toList();

      } else {
        Get.snackbar('Error', 'Failed to load orders');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }


  // Create a new order using actual backend IDs for customer and product.
  Future<void> postOrder(String customerId, String productId, int quantity, double amount) async {
    print("Inside postOrder method");

    // Prepare the payload directly using the actual backend IDs
    final newOrder = {
      "customer": customerId,
      "product": productId,
      "quantity": quantity,
      "amount": amount,
    };

    print("Request Payload: $newOrder");

    final url = Uri.parse(baseUrl + registerOrderCustomer);
    print("API URL: $url");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(newOrder),
      );

      print("API Response Status Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar('Success', 'Order added successfully');
        loadOrders(); // Refresh the list
      } else {
        Get.snackbar('Error', 'Failed to add order: ${response.body}');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  // Update an existing order
  Future<void> updateOrder(CustomerOrderItem order, {
    String? newCustomerId,
    String? newProductId,
    int? newQuantity,
    double? newAmount
  }) async {
    // Prepare the payload using new values if provided; otherwise, use current order values.
    final updatedOrder = {
      "id": order.id,
      "customer": newCustomerId ?? order.customerId,
      "product": newProductId ?? order.productId,
      "quantity": newQuantity ?? order.quantity,
      "amount": newAmount ?? order.amount,
    };

    final url = Uri.parse(baseUrl + updateOrderCustomer);
    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedOrder),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Order updated successfully');
        loadOrders(); // Refresh the list
      } else {
        Get.snackbar('Error', 'Failed to update order: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  // Delete an order
  Future<void> deleteOrder(CustomerOrderItem order) async {
    // Prepare the payload using the backend order ID directly.
    final deletePayload = {"id": order.id};

    final url = Uri.parse(baseUrl + deleteOrderCustomer);
    try {
      final response = await http.delete(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(deletePayload),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Order deleted successfully');
        loadOrders(); // Refresh the list
      } else {
        Get.snackbar('Error', 'Failed to delete order: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }


}
